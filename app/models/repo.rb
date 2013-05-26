class Repo < ActiveRecord::Base
  attr_accessible :git_repo_id, :last_tag, :name, :owner
  validates :git_repo_id, :uniqueness => true

	has_many :downloads

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

end
