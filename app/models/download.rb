class Download < ActiveRecord::Base
  include GitHubHelper
  belongs_to :repo
  after_create :populate_sha
  attr_accessible :retrieved_at, :tag, :tagged_at, :sha

  def self.create_from_hook(hook)
    new_download = Download.new
    new_download.tag = hook.tag
    new_download.tagged_at = Time.now
    new_download.save
  end

  def populate_sha
    tag_details = get_tag_sha(self.repo.owner,self.repo.name,self.tag)
    self.update_attribute(:sha, tag_details.commit.sha )
  end

end
