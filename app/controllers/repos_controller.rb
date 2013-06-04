class ReposController < ApplicationController

	include GitHubHelper

  def index
    @repos = Repo.all

    respond_to do |format|
      format.html
      format.json { render json: @repos }
    end
  end


  def show
    @repo = Repo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repo }
    end
  end


  def new
    @repo = Repo.new

    respond_to do |format|
      format.html
      format.json { render json: @repo }
    end
  end

  def edit
    @repo = Repo.find(params[:id])
  end


  def create
	  selected_repos = params[:repo][:Repos].reject {|element| element.blank?}
	  selected_repos.map! {|repo_name| "/repos/#{repo_name}" }
	  repo_details = get_repo_details(selected_repos)
	  Repo.create_selected_repos(repo_details)
    redirect_to repos_path
    #respond_to do |format|
    #  if @repo.save
    #    format.html { redirect_to @repo, notice: 'Repo was successfully created.' }
    #    format.json { render json: @repo, status: :created, location: @repo }
    #  else
    #    format.html { render action: "new" }
    #    format.json { render json: @repo.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  def download

  end

  def update
    @repo = Repo.find(params[:id])

    respond_to do |format|
      if @repo.update_attributes(params[:repo])
        format.html { redirect_to @repo, notice: 'Repo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @repo.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @repo = Repo.find(params[:id])
    @repo.destroy

    respond_to do |format|
      format.html { redirect_to repos_url }
      format.json { head :no_content }
    end
  end
end
