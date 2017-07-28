class CollectShippedProjectsJob < ApplicationJob
  queue_as :default

  CLOUD9_TEAM = Rails.application.secrets.cloud9_team_name
  CLOUD9_USERNAME = Rails.application.secrets.cloud9_username
  CLOUD9_PASSWORD = Rails.application.secrets.cloud9_password

  GITHUB_ACCESS_TOKEN = Rails.application.secrets.github_bot_access_token

  GITHUB_ERR_EMPTY_REPO = "This repository is empty."

  PROJECT_TYPE_WORKSHOP = 1
  PROJECT_TYPE_STANDALONE = 2

  MAX_PROJECTS=20

  def perform
    github_projects
  end

  def github_projects
    repos = scm_projects
      .reverse
      .take(MAX_PROJECTS)
      .select { |p| p[:scmurl].match(/https\:\/\/github.com.*/) }
      .map { |p| p[:scmurl] }
      .map { |url| username_and_repo_from_url url }

    repos.map do |repo|
      case repo[:repo]
      when /(.*).github.io/
        puts "#{repo[:repo]} is a workshop"
        projects_from_workshop_repo(repo)
      else
        puts "#{repo[:repo]} is a standalone"
        project_from_repo(repo)
      end
    end
      .flatten
  end

  def projects_from_workshop_repo(repo)
    contents = github_contents(repo[:username], repo[:repo])

    return if contents.nil?
      
    contents.map do |f|
      next unless f["type"] == "dir"
      
      new_project(
        title: prettify_str(f["name"]),
        live_url: "https://#{repo[:repo]}",
        source_url: repo[:url],
        git_dir: f["name"],
        author_name: repo[:owner],
        author_email: "REPLACEME@example.com",
        type: PROJECT_TYPE_WORKSHOP,
      )
    end
      .reject { |b| b.nil? }
  end

  def project_from_repo(repo)
    new_project(
      title: prettify_str(repo[:repo]),
      live_url: repo[:url],
      source_url: repo[:url],
      git_dir: "/",
      author_name: repo[:owner],
      author_email: "REPLACEME@example.com",
      type: PROJECT_TYPE_STANDALONE,
    )
  end

  def new_project(title:, live_url:, source_url:, git_dir:, author_name:,
                  author_email:, type:)

    {
      title: title,
      live_url: live_url,
      source_url: source_url,
      git_dir: git_dir,
      author_name: author_name,
      author_email: author_name,
      type: type,
    }
  end


  def scm_projects
    projects.select { |p| !p[:scmurl].empty? }
  end

  def projects
    @projects ||= Cloud9Client::Project.all(CLOUD9_TEAM)
  end

  def username_and_repo_from_url(url)
    m = /https\:\/\/github.com\/(.*)\/(.*)?$/.match(url)

    return nil unless m

    username = m[1]
    repo = m[2]

    return nil unless username && repo

    repo = repo.gsub(/\.git$/, '')

    {
      username: username,
      repo: repo,
      url: url,
    }
  end

  GITHUB_API_ROOT = 'https://api.github.com'

  def github_contents(owner, repo)
    fpath = ''
    path = GITHUB_API_ROOT + "/repos/#{owner}/#{repo}/contents/#{fpath}"

    resp = nil

    begin
      resp = RestClient.get(path, { params: { access_token: GITHUB_ACCESS_TOKEN }})

      JSON.parse(resp)
    rescue RestClient::NotFound=>e
      err = JSON.parse(e.response)

      if err["message"] == GITHUB_ERR_EMPTY_REPO
        nil
      else
        nil
      end
    end
  end

  def prettify_str(str)
    str.gsub(/\_/, ' ').titlecase
  end
end
