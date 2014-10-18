require 'spec_helper'

describe VideoQueuesController do 
	describe 'GET show' do
		let(:user) { Fabricate(:user) }
		
		context "with authentication" do
			before do
				session[:user_id] = user.id
			end

			it 'should render the my Queue page' do
				populate_queue
			  	get :show, id: VideoQueue.first.id
			  	expect(response).to render_template(:show)
			end

			it 'should assign the videos in the queue to the @videos variable' do
				populate_queue
			  	get :show, id: VideoQueue.first.id
			  	expect(assigns(:queueables)).to eq(VideoQueue.first.queueables)
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
				populate_queue
				video3 = Video.create(title: "movie3", description: "very much fun")
				post :add, video_id: video3.id
				expect(Queueable.find_by(video_id: video3.id).priority).to eq(3)
			end

			it 'does not add a video that is already part of the queue' do
				populate_queue
				request.env["HTTP_REFERER"] = video_path(Video.first)
				post :add, video_id: Video.first.id
				expect(flash[:danger]).to eq("The video you tried to add was already on your queue!")
				expect(VideoQueue.first.videos.size).to eq(2)
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

	describe 'DELETE remove' do
		let(:user) { Fabricate(:user) }
		
		context "with authentication" do
			before do
				session[:user_id] = user.id
			end

		it 'should redirect to the queue when a video is removed from it' do 
			populate_queue
			delete :remove, video_id: Video.first.id
			expect(response).to redirect_to(video_queue_path(user.video_queue))
		end

		it 'deletes the item out of the queue once it is removed from within' do
			populate_queue
			delete :remove, video_id: Video.first.id
			expect(VideoQueue.first.videos.size).to eq(1)
		end

		it 'displays a flash message and does not remove something when trying to delete a video not on the queue' do
			video = Video.create(title: "movie3", description: "fun")
			populate_queue
			delete :remove, video_id: video.id
			expect(flash[:danger]).to eq("The video you tried to remove wasn't in your queue!")
			expect(VideoQueue.first.videos.size).to eq(2)
		end	
	end
	context 'without authentication' do

		it 'should redirect to the front page for non signed users when trying to delete from a queue' do
			populate_queue
			delete :remove, video_id: Video.first.id
			expect(response).to redirect_to(root_path)
		end
	end
end
	describe 'POST update' do
		let(:user) { Fabricate(:user) }
		
		context "with authentication" do
			before do
				session[:user_id] = user.id
			end
		it 'updates the rating if a different one was set' do
			populate_queue
			put :update, queue_items: [{id: Queueable.first.id, position: 2, rating: 3}, {id: Queueable.find(2).id, position: 1}], video_queue_id: VideoQueue.first
			expect(Queueable.first.rating).to eq(3)
		end

		it 'should move videos based on the updated priority in the queue' do
			populate_queue
			put :update, queue_items: [{id: Queueable.first.id, position: 2}, {id: Queueable.find(2).id, position: 1}], video_queue_id: VideoQueue.first
			expect(Queueable.first.priority).to eq(2)
		end
		it 'should redirect to the queue after updating' do 
			populate_queue
			put :update, queue_items: [{id: Queueable.first.id, position: 2}, {id: Queueable.find(2).id, position: 1}], video_queue_id: VideoQueue.first
			expect(response).to redirect_to(video_queue_path(user.video_queue))
		end

		it 'normalizes the priority numbers' do
			populate_queue
			put :update, queue_items: [{id: Queueable.first.id, position: 22}, {id: Queueable.find(2).id, position: 11}], video_queue_id: VideoQueue.first
			expect(Queueable.first.priority).to eq(2)
		end
		context "with invalid input" do
			
			it 'displays an error message' do
				populate_queue
				put :update, queue_items: [{id: Queueable.first.id, position: 2.4}, {id: Queueable.find(2).id, position: "test"}], video_queue_id: VideoQueue.first
	  			expect(flash[:danger]).to eq("You assigned at least two videos with the same priority or used illegal signs!")
	  		end

	  		it 'does not change the queue order' do
	  			populate_queue
				put :update, queue_items: [{id: Queueable.first.id, position: 2.4}, {id: Queueable.find(2).id, position: "test"}], video_queue_id: VideoQueue.first
				expect(Queueable.first.priority).to eq(1)
			end
	  	 end	
	  end
	  context "without authentication" do

	  	it 'does not change the queue when an unauthorized user trys to update' do
	  		populate_queue
			put :update, queue_items: [{id: Queueable.first.id, position: 2}, {id: Queueable.find(2).id, position: 1}], video_queue_id: VideoQueue.first
			expect(Queueable.first.priority).to eq(1)
		end
	  end
   end
end
