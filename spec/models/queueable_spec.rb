require 'spec_helper'

describe Queueable do 
	it {should belong_to(:video_queue)}

	describe "#rating" do
		let(:user) { Fabricate(:user) }
		it "returns the rating from the review if present" do
			populate_queue
			expect(Queueable.first.rating).to eq(5)
		end

		it "returns nil when the rating is not present" do
			populate_queue
			expect(Queueable.find(2).rating).to eq(nil)
		end
	end

	describe "#rating=" do
		let(:user) { Fabricate(:user) }
		it "changes the rating of the review if present" do
			populate_queue
			Queueable.first.rating = 1
			expect(Queueable.first.rating).to eq(1)
		end

		it "creates a review with a rating if the review is not present" do
			populate_queue
			Queueable.find(2).rating = 4
			expect(Review.find_by(video_id: Queueable.find(2).video.id)).to_not eq([])
		end
	end
end

