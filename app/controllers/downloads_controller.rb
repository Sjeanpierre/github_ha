class DownloadsController < ApplicationController

  include GitHubHelper

	def new
		@download = Download.new

		respond_to do |format|
			format.html
			format.json { render json: @download }
		end
	end

	def create
		@repo = Repo.find(params[:download][:repo_id])
		params[:download].delete(:repo_id)
		@download = @repo.downloads.new(params[:download])
		respond_to do |format|
			if @download.save
				format.html { redirect_to repo_path(@repo), notice: 'Download was successfully created.' }
				format.json { render json: @download, status: :created, location: @download }
			else
				format.html { render action: "new" }
				format.json { render json: @download.errors, status: :unprocessable_entity }
			end
		end
  end

  def receive_hook
    hook_data = parse_github_hook(params[:payload])
    @repo = Repo.find_by_git_repo_id(hook_data.repository.id)
    @download = @repo.downloads.create_from_hook(hook_data)
  end

end
