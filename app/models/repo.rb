class Repo < ActiveRecord::Base
  attr_accessible :last_commit, :last_tag, :name, :owner

	has_many :downloads
end
