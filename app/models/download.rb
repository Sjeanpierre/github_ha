class Download < ActiveRecord::Base
  belongs_to :repo
  attr_accessible :retrieved_at, :tag, :tagged_at

  def self.create_from_hook(hook)
    new_download = Download.new
    new_download.tag = hook.tag
    new_download.tagged_at = Time.now
    new_download.save
  end

end
