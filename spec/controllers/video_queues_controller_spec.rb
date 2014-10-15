require 'spec_helper'

describe VideoQueuesController do 
	describe 'GET show' do
		let(:user) { Fabricate(:user) }
		
		context "with authentication" do
			before do
				session[:user_id] = user.id
			end

			it 'should render the my Queue page' do
				video = Video.create(title: "movie1", description: "fun")
				review = Review.create(text: "fun", user_id: user.id, video_id: video.id, rating: 5)
				queue = VideoQueue.create(user_id: user.id)
				queue.videos << video
			  	get :show, id: queue.id
			  	expect(response).to render_template(:show)
			end

			it 'should assign the videos in the queue to the @videos variable' do
				video = Video.create(title: "movie1", description: "fun")
				review = Review.create(text: "fun", user_id: user.id, video_id: video.id, rating: 5)
				queue = VideoQueue.create(user_id: user.id)
				queue.videos << video
			  	get :show, id: queue.id
			  	expect(assigns(:videos)).to eq(queue.videos)
			end

		end
	end

	describe 'POST add' do
		let(:user) { Fabricate(:user) }
		
		context "with authentication" do
			before do
				session[:user_id] = user.id
			end

			it 'redirects to the my Queue page' do
				video = Video.create(title: "movie1", description: "fun")
				queue = VideoQueue.create(user_id: user.id)
				post :add , video_id: video.id
			  	expect(response).to redirect_to(video_queue_path(user.video_queue))
			end

			it 'adds one video to the queue if it that was not part of the queue before' do
				video = Video.create(title: "movie1", description: "fun")
				queue = VideoQueue.create(user_id: user.id)
				queue_videos = queue.videos.size
				post :add , video_id: video.id
				expect(queue.videos.size).to eq(queue_videos+1)
			end

			it 'puts the video as the last one in the queue' do
				video = Video.create(title: "movie1", description: "fun")
				video2 = Video.create(title: "movie2", description: "fun")
				queue = VideoQueue.create(user_id: user.id)
				queue.videos << [video, video2]
				item1 = Queueable.find_by(video_id: video.id)
				item2 = Queueable.find_by(video_id: video2.id)
				item1.priority = 1
				item2.priority = 2
				item1.save
				item2.save
				video3 = Video.create(title: "movie3", description: "very much fun")
				post :add, video_id: video3.id
				expect(Queueable.find_by(video_id: video3.id).priority).to eq(3)
			end

			it 'does not add a video that is already part of the queue' do
				video = Video.create(title: "movie1", description: "fun")
				queue = VideoQueue.create(user_id: user.id)
				Queueable.create(video_queue_id: queue.id, video_id: video.id,priority:1)
				request.env["HTTP_REFERER"] = video_path(video)
				post :add, video_id: video.id
				expect(flash[:danger]).to eq("The video you tried to add was already on your queue!")
				expect(queue.videos.size).to eq(1)
			end

		end

		context 'without authentication' do

			it 'redirects to the front page when trying to add to the queue' do
				video = Video.create(title: "movie1", description: "fun")
				queue = VideoQueue.create(user_id: user.id)
				post :add, video_id: video.id
				expect(response).to redirect_to(root_path)
			end

		end
	end
end


