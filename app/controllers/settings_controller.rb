class SettingsController < ApplicationController

	include GitHubHelper

	def github_repos
		repos = get_repos
		#TODO move this into helper module
		@repos = {}
		repos.each do |h|
			val = [h.name.humanize.titleize, h.full_name]
			key = h.owner.login.to_sym
			if @repos.has_key?(key)
				@repos[key].push(val)
			else
				@repos[key] = []
				@repos[key].push(val)
			end
		end
		render :setup_repos
	end

end
