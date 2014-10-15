require 'spec_helper'

describe VideosController do 
	describe 'GET show' do
		let(:user) { Fabricate(:user) }
		
		context "with authentication" do
			before do
				session[:user_id] = user.id
			end
			it "should be able to retrieve the reviews through the @video variable" do
				video = Video.create(title: "movie1", description: "fun")
				review = Review.create(text: "fun", user_id: user.id, video_id: video.id, rating: 5)

				get :show, id: video.id
				assigns(:video).reviews.should == [review]
			end


			it "gets the correct video in the @video variable" do
				video = Video.create(title: "movie1", description: "fun")
				video2 = Video.create(title: "awesome movie", description: "awesome")

				get :show, id: video.id
				assigns(:video).should == video
			end

			it "should render the show template" do
				video = Video.create(title: "movie1", description: "fun")

				get :show, id: video.id
				response.should render_template :show
			end
		end
		
		context "without authentication" do
			it "gets no video " do
				video = Video.create(title: "movie1", description: "fun")
				video2 = Video.create(title: "awesome movie", description: "awesome")

				get :show, id: video.id
				assigns(:video).should == nil
			end

			it "shouldn't render the show template" do
				video = Video.create(title: "movie1", description: "fun")

				get :show, id: video.id
				response.should redirect_to :root
			end
		end
	end
	describe 'GET search' do
		let(:user) { Fabricate(:user) }
		context "with authentication" do
			before do
				session[:user_id] = user.id
			end

			it "should assign no values if no videos are available" do

				get :search, search_term: "test"
				assigns(:videos).size.should == 0
			end

			it "should render the search template" do

				get :search, search_term: "test"
				response.should render_template :search
			end

			it "should work for one video" do
   	   			video = Video.create(title: "movie1", description: "fun")
				video2 = Video.create(title: "awesome movie", description: "awesome")
				get :search, search_term: "1"
				assigns(:videos).should == [video]
			end

			it "should work for multiple videos" do
   	   			video = Video.create(title: "movie1", description: "fun")
				video2 = Video.create(title: "awesome movie", description: "awesome")
				get :search, search_term: "movie"
				assigns(:videos).should == [video, video2]
			end
		end
		context "without authentication" do
			it "shouldn't render the search template" do

				get :search, search_term: "test"
				response.should redirect_to :root
			end

			it "shouldn't assign videos" do
   	    		video = Video.create(title: "movie1", description: "fun")
				video2 = Video.create(title: "awesome movie", description: "awesome")
				get :search, search_term: "1"
				assigns(:videos).should == nil
			end
		end
	end
end