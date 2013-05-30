class Repo < ActiveRecord::Base
  include GitHubHelper
  attr_accessible :git_repo_id, :last_tag, :name, :owner, :repo_hook_id
  validates :git_repo_id, :uniqueness => true
  after_create :create_repo_hook
  after_destroy :delete_repo_hook
	has_many :downloads, :dependent => :destroy

	def self.create_selected_repos(repos)
	  repos.each do |repo|
		  begin
      new_repo = Repo.new
		  new_repo.name = repo.name
		  new_repo.owner = repo.owner.login
      new_repo.git_repo_id = repo.id
      new_repo.save!
      rescue => e
        next if e.message == 'Validation failed: Git repo has already been taken'
      end
	  end
  end

  private

  def create_repo_hook
    hook =  create_notification_hook(self.name, self.owner)
    self.repo_hook_id = hook.id
    self.save
  end

  def delete_repo_hook
    delete_notification_hook(self.name, self.owner, self.repo_hook_id)
  end

end
