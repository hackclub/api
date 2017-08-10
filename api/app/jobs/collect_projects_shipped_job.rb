class CollectProjectsShippedJob < ApplicationJob
  CLOUD9_TEAM=Rails.application.secrets.cloud9_team_name

  GITHUB_API_ROOT = 'https://api.github.com'
  GITHUB_ACCESS_TOKEN = Rails.application.secrets.github_bot_access_token

  def perform
    byebug

    projects = []

    projects << cloud9_projects
    projects << github_projects

    projects
  end

  # Get project from Github
  def github_projects(usernames=github_usernames)
  end

  # Get projects from Cloud9
  def cloud9_projects(workspaces=cloud9_workspaces)
    wp = 0
    scp = 0
    ep = 0

    workspaces.map do |ws|
      byebug
      if cloud9_workshop_project? ws
        wp += 1
      elsif cloud9_scm_project? ws
        scp += 1

        Project.new(
          title: ws[:name],
          description: ws[:descr],
          git_url: ws[:scmurl],
          workspace: ws,
        )
      else
        ep += 1
      end
    end

    puts "Workshop projs: #{wp}. SCM Projects: #{scp}. Other: #{ep}"
  end

  # Get every single GitHub account off of the workspaces in C9
  def github_usernames
  end

  # Get every single workspace in the Hack Club team off of C9
  def cloud9_workspaces
    @workspaces ||= Cloud9Client::Project.all(CLOUD9_TEAM)
  end

  def cloud9_workshop_project?(workspace)
    return false unless cloud9_scm_project? workspace

    scmurl = workspace[:scmurl]

    scmurl = scmurl.gsub(/\.git$/, '')

    github_url_repo(scmurl).end_with? '.github.io'
  end

  def cloud9_scm_project?(workspace)
    !workspace[:scmurl].empty?
  end

  def github_repo_contents(owner, repo, fpath='')
    path = GITHUB_API_ROOT + "/repos/#{owner}/#{repo}/contents/#{fpath}"

    Rails.cache.fetch(path, expires_in: 5.minutes) do
      resp = nil

      begin
        resp = RestClient.get(path, { params: { access_token: GITHUB_ACCESS_TOKEN }})

        JSON.parse(resp)
      rescue RestClient::NotFound=>e
        err = JSON.parse(e.response)

        Rails.logger.log("Error getting GitHub repo contents #{err}")

        nil
      end
    end
  end

  def github_url_repo(url)
    m = /github.com\/(?:.*)\/(.*)/.match(url)

    m ? m[1] : ''
  end
end
