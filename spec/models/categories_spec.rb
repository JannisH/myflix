require 'spec_helper'

describe Category do
	
	it{should have_many(:videos)}

	describe "most_recent" do
		it "should list at most six videos" do
			Category.create(name: "Fun")
			create_video_list(6)
			expect(Category.first.recent_videos().size).to eq(6)
		end

		it "should list newer ones first" do
			Category.create(name: "Fun")
			create_video_list(6)
			expect(Category.first.recent_videos().map {|x| x}).to eq(Video.limit(6))
		end

		it "should return all videos if there are less than six in this category" do
			Category.create(name: "Fun")
			create_video_list(3)
			expect(Category.first.recent_videos().map {|x| x}).to eq(Video.limit(3))
		end
	end
end