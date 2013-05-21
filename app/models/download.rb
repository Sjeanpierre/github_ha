class Download < ActiveRecord::Base
  belongs_to :repo
  attr_accessible :retrieved_at, :tag, :tagged_at
end
