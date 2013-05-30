module GitHubHelper

 require 'hashie'

  def get_repos
    git_connection = establish_git_connection
    accessible_repos = []
    member_organizations = get_organizations(git_connection)
    if member_organizations.count > 0
      org_names = []
      member_organizations.each { |org| org_names << org.login }
      org_names.each do |org|
        user_org_teams = get_org_teams(git_connection,org)
        user_org_teams.each do |team|
          team_repos = git_connection.orgs.teams.list_repos team.id
          team_repos.each { |repo| accessible_repos.push(repo) }
        end
      end
    end
    user_repos = git_connection.repos.list :type => 'all'
    user_repos.each {|repo| accessible_repos.push(repo) }
    accessible_repos.uniq!
    accessible_repos
  end

  def get_organizations(git_connection)
    git_connection.orgs.list
  end

  def get_repo_details(repos)
    git_connection = establish_git_connection
    repos.map! {|repo| git_connection.get_request(repo)}
  end

  def create_notification_hook(repo_name, repo_owner)
    begin
        git_connection = establish_git_connection
        hook_params = {:name => 'web' , :config => {:url => 'http://requestb.in/1c0iy5s1'}}
        git_connection.repos.hooks.create(repo_owner, repo_name, hook_params)
        active_hooks = git_connection.repos.hooks.list(repo_owner, repo_name)
        active_hooks.detect { |hook| hook.config.url == hook_params['config']['url']}
    rescue => e
      #Github::Error::GithubError => e
      raise e
    end
  end

  def delete_notification_hook(repo_name, repo_owner, hook_id)
    begin
      git_connection = establish_git_connection
      git_connection.repos.hooks.delete(repo_owner,repo_name,hook_id)
    rescue Github::Error::GithubError => e
      if e.is_a?(Github::Error::NotFound)
        puts e.message
      else
        raise(e)
      end
    end
  end


  def get_org_teams(git_connection,org)
    # it looks like the api only returns teams that the user is part of, including only pull access
    org_teams = git_connection.orgs.teams.list(org)
    #TODO verify that this permission rejection is setup properly
    org_teams.keep_if { |team| team.permission == 'admin' }
    org_teams
  end

  def parse_github_hook(payload)
    payload_hash = JSON.parse(payload)
    event = Hashie::Mash.new(payload_hash)
    if is_tag?(event.ref)
      event.tag = get_event_tag(event.ref)
      event
    else
      raise('rejected')
    end
  end

  def get_event_tag(ref)
    ref.split('/').last
  end

  def is_tag?(ref)
    ref.split('/')[1] == 'tags'
  end

  def get_commits(git_connection,repo_name,repo_owner, branch_name=false)
    # if branch name is provided method will return all commits from that branch. else return all commits from repo
    if branch_name
      git_connection.get_request("/repos/#{repo_owner}/#{repo_name}/commits", { :sha => branch_name })
    else
      git_connection.repos.commits.all(repo_owner,repo_name)
      #git_connection.get_request("/repos/#{repo_owner}/#{repo_name}/commits")
    end
  end

  def get_commit_details(git_connection,repo_name,repo_owner,sha)
    #git_connection.get_request("/repos/#{repo_owner}/#{repo_name}/commits", { :sha => branch_name })
    git_connection.git_data.commits.get(repo_owner,repo_name,sha)
  end

  def get_repo_tags(git_connection,repo_name,repo_owner)
    git_connection.repos.tags(repo_owner,repo_name)
  end

 def get_tag_sha(repo_owner,repo_name,tag)
   git_connection = establish_git_connection
   repo_tags = git_connection.repos.tags(repo_owner,repo_name)
   repo_tags.detect { |repo_tag| repo_tag.name == tag }
 end


  private
  def establish_git_connection
    Github.new :oauth_token => GITHUB_CONFIG['github_token']
  end

end

