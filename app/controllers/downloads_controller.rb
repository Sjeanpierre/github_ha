class DownloadsController < ApplicationController
  protect_from_forgery :except => :receive_hook

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
    begin
    hook_data = parse_github_hook(params[:payload])
    @repo = Repo.find_by_git_repo_id(hook_data.repository.id)
    @download = @repo.downloads.create_from_hook(hook_data)
    #Download.delay.download_content(@download.id)
    Download.download_content(@download.id)
    render json: @download, status: :created
    rescue => e
      render json: {:message =>"failed to create download: #{e}"}, status: :unprocessable_entity
    end
  end

  def download
    p
  end

  def download_tag_backup
    begin
      backup_url = Repo.where(:owner => params[:repo_owner], :name => params[:repo_name]).first.downloads.where(:tag => params[:tag]).last.backup
      redirect_to backup_url.to_s
    rescue => e
      render text: 'Could not find requested resource', status: :not_found
    end
  end



end
