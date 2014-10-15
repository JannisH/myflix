require 'spec_helper'

describe ReviewsController do 

	describe 'POST create' do
		let(:user) { Fabricate(:user) }
		context 'with authentication' do
		  
		  before do
			session[:user_id] = user.id
		  end

		  it 'should tell the user that its not possible to review a video twice ' do
		  	video = Video.create(title: "movie1", description: "fun")
		  	review = Review.create(text: "fun", rating: 5, user_id: user.id, video_id: video.id)
		  	request.env["HTTP_REFERER"] = video_path(video)
		  	post :create, {video_id: video.id, user_id: user.id, review: {rating: 5, text: "awesome"}}
		  	expect(flash[:danger]).to eq("You have already reviewed this video.")
		  end

		  it 'should be possible to post reviews' do
		  	video = Video.create(title: "movie1", description: "fun")
		  	post :create, {video_id: video.id, user_id: user.id, review: {rating: 5, text: "awesome"}}
		  	expect(video.reviews.size).to eq(1)
		  end

		  it 'should be redirected to the reviewed video after posting a review' do
		  	video = Video.create(title: "movie1", description: "fun")
		  	post :create, {video_id: video.id, user_id: user.id, review: {rating: 5, text: "awesome"}}
		  	response.should redirect_to video
		  end

		end
		context 'without authentication' do
		  
		  it'should not be possible to review a video when not logged in' do
		  	video = Video.create(title: "movie1", description: "fun")
		  	post :create, {video_id: video.id, user_id: user.id, review: {rating: 5, text: "awesome"}}
		  	expect(video.reviews.size).to eq(0)
		  end

		  

		end

	end
end