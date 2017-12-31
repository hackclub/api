# frozen_string_literal: true
class CollectProjectsShippedJob < ApplicationJob
  CLOUD9_TEAM = Rails.application.secrets.cloud9_team_name

  GITHUB_API_ROOT = 'https://api.github.com'
  GITHUB_ACCESS_TOKEN = Rails.application.secrets.github_bot_access_token

  def perform
    projects = []

    projects << github_projects
    projects << cloud9_projects

    projects
      .flatten
      .reject(&:nil?)
      .each(&:save)
      .map(&:source)
  end

  # Get project from Github
  def github_projects(usernames = github_usernames)
    usernames.map do |u|
      repos = github_users_repos(u)
      next if repos.nil?

      github_projects_from_repos(repos)
    end
  end

  # Get projects from Cloud9
  def cloud9_projects(workspaces = cloud9_workspaces)
    workspaces.map do |ws|
      if cloud9_workshop_project? ws
        cloud9_workshop_projects(ws)
      elsif cloud9_scm_project? ws
        cloud9_scm_project(ws)
      end
    end
  end

  # rubocop:enable Style/EmptyElse
  def cloud9_scm_project(workspace)
    ::Project.new(
      title: workspace[:name],
      description: workspace[:descr],
      git_url: workspace[:scmurl],
      data: workspace,
      source: :cloud9_workshop
    )
  end

  # Get every single github account off of the workspaces in c9
  def github_usernames
    @github_usernames ||= cloud9_workspaces.map do |ws|
      next unless ws[:scmurl]

      info = github_info_from_url(ws[:scmurl])

      next unless info

      info[:user]
    end
                                           .reject(&:nil?)
  end

  def github_workshop?(repo)
    scmurl = repo['git_url'].gsub(/\.git$/, '')

    scmurl.end_with? '.github.io'
  end

  def github_workshops(repo)
    info = github_info_from_url(repo['git_url'])

    return if info.nil?

    contents = github_repo_contents(info[:user], info[:repo])

    return if contents.nil?

    contents.map do |f|
      next unless f['type'] == 'dir'

      ::Project.new(
        title: repo['name'],
        description: repo['description'],
        git_url: info[:git_url],
        live_url: workshop_live_url(info[:repo], f['path']),
        local_dir: f['name'],
        data: repo,
        source: :github_workshop
      )
    end
            .reject(&:nil?)
  end

  def github_projects_from_repos(repos)
    repos.map do |repo|
      if github_workshop?(repo)
        github_workshops(repo)
      else
        github_project(repo)
      end
    end
  end

  def github_project(repo)
    ::Project.new(
      title: repo['name'],
      description: repo['description'],
      git_url: repo['git_url'],
      data: repo,
      source: :github
    )
  end

  # Get every single workspace in the Hack Club team off of C9
  def cloud9_workspaces
    @workspaces ||= Cloud9Client::Project.all(CLOUD9_TEAM)
  end

  def cloud9_workshop_project?(workspace)
    return false unless cloud9_scm_project? workspace

    scmurl = workspace[:scmurl].gsub(/\.git$/, '')

    github_url_repo(scmurl).end_with? '.github.io'
  end

  def cloud9_workshop_projects(ws)
    info = github_info_from_url(ws[:scmurl])

    return if info.nil?

    contents = github_repo_contents(info[:user], info[:repo])

    return if contents.nil?

    contents.map do |f|
      next unless f['type'] == 'dir'

      ::Project.new(
        title: info[:repo],
        description: ws[:descr],
        git_url: info[:git_url],
        local_dir: f['name'],
        live_url: workshop_live_url(info[:repo], f['name']),
        data: ws,
        source: :cloud9
      )
    end
            .reject(&:nil?)
  end

  def cloud9_scm_project?(workspace)
    !workspace[:scmurl].empty?
  end

  def github_repo_contents(owner, repo, fpath = '')
    path = "/repos/#{owner}/#{repo}/contents/#{fpath}"

    github_api_request(path)
  end

  def github_users_repos(owner)
    path = "/users/#{owner}/repos"

    github_api_request(path)
  end

  def github_url_repo(url)
    m = %r{github.com\/(?:.*)\/(.*)}.match(url)

    m ? m[1] : ''
  end

  def github_info_from_url(url)
    m = %r{github\.com\/(.*)\/(.*)?$}.match(url)

    return nil unless m

    username = m[1]
    repo = m[2]

    return nil unless username && repo

    repo = repo.gsub(/\.git$/, '')

    {
      user: username,
      repo: repo,
      git_url: "https://github.com/#{username}/#{repo}.git"
    }
  end

  def github_api_request(path, headers = {})
    headers = { accept: 'application/vnd.github.v3+json',
                params: { access_token: GITHUB_ACCESS_TOKEN } }
              .merge(headers)

    path = GITHUB_API_ROOT + path

    resp = Rails.cache.fetch(path, expires_in: 5.minutes) do
      RestClient.get(path, headers).to_s
    end

    JSON.parse(resp)
  rescue RestClient::NotFound
    nil
  end

  def workshop_live_url(repo, local_url)
    URI.join("https://#{repo}", URI.escape(local_url))
  end
end
