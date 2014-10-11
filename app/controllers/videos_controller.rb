class VideosController < ApplicationController
	before_action :require_login
	
	def index
		@categories = Category.all
	end

	def show
		@video = Video.find(params[:id])
	end

	def search
		@search_term = params[:search_term]
		video = Video.new
		@videos = video.search_by_title(@search_term)
	end
end