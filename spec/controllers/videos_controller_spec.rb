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
				expect(assigns(:video).reviews).to eq([review])
			end


			it "gets the correct video in the @video variable" do
				video = Video.create(title: "movie1", description: "fun")
				video2 = Video.create(title: "awesome movie", description: "awesome")

				get :show, id: video.id
				expect(assigns(:video)).to eq(video)
			end

			it "should render the show template" do
				video = Video.create(title: "movie1", description: "fun")
				get :show, id: video.id
				expect(response).to render_template(:show)
			end
		end
		
		context "without authentication" do
			it "gets no video " do
				video = Video.create(title: "movie1", description: "fun")
				video2 = Video.create(title: "awesome movie", description: "awesome")

				get :show, id: video.id
				expect(assigns(:video)).to eq(nil)
			end

			it "shouldn't render the show template" do
				video = Video.create(title: "movie1", description: "fun")

				get :show, id: video.id
				expect(response).to redirect_to(:root)
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
				expect(assigns(:videos).size).to eq(0)
			end

			it "should render the search template" do

				get :search, search_term: "test"
				expect(response).to render_template(:search)
			end

			it "should work for one video" do
   	   			video = Video.create(title: "movie1", description: "fun")
				video2 = Video.create(title: "awesome movie", description: "awesome")
				get :search, search_term: "1"
				expect(assigns(:videos)).to eq([video])
			end

			it "should work for multiple videos" do
   	   			video = Video.create(title: "movie1", description: "fun")
				video2 = Video.create(title: "awesome movie", description: "awesome")
				get :search, search_term: "movie"
				expect(assigns(:videos)).to eq([video, video2])
			end
		end
		context "without authentication" do
			it "shouldn't render the search template" do

				get :search, search_term: "test"
				expect(response).to redirect_to(:root)
			end

			it "shouldn't assign videos" do
   	    		video = Video.create(title: "movie1", description: "fun")
				video2 = Video.create(title: "awesome movie", description: "awesome")
				get :search, search_term: "1"
				expect(assigns(:videos)).to  eq(nil)
			end
		end
	end
end