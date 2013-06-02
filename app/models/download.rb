class Download < ActiveRecord::Base
  include GitHubHelper
  belongs_to :repo
  after_create :populate_sha
  attr_accessible :retrieved_at, :tag, :tagged_at, :sha, :backup
  mount_uploader :backup, BackupUploader

  def self.create_from_hook(hook)
    new_download = Download.new
    new_download.tag = hook.tag
    new_download.tagged_at = Time.now
    new_download.save

    new_download
  end

  def populate_sha
    tag_details = get_tag_info(self.repo.owner,self.repo.name,self.tag)
    self.update_attribute(:sha, tag_details.commit.sha )
  end

  def self.download_content(id)
    find(id).download
  end

  def download
    tag_details = get_tag_info(self.repo.owner,self.repo.name,self.tag)
    tarball_url = "#{tag_details.tarball_url}?access_token=#{GITHUB_CONFIG['github_token']}"
    self.remote_backup_url = tarball_url
    update_attribute(:retrieved_at, Time.now)
  end

end
