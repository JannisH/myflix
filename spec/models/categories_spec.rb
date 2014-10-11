require 'spec_helper'

describe Category do
	
	it{should have_many(:videos)}

	describe "most_recent" do
		it "should list at most six videos" do
			Category.create(name: "Fun")
			video = Video.create(title: "testMovie", description: "fun movie", category_id: 1)
			video2 = Video.create(title: "testMovie2", description: "even more fun", category_id: 1)
			video3 = Video.create(title: "testMovie3", description: "fun movie", category_id: 1)
			video4 = Video.create(title: "testMovie4", description: "even more fun", category_id: 1)
			video5 = Video.create(title: "testMovie5", description: "fun movie", category_id: 1)
			video6 = Video.create(title: "testMovie6", description: "even more fun", category_id: 1)
			video7 = Video.create(title: "testMovie7", description: "fun movie", category_id: 1)
			video8 = Video.create(title: "testMovie8", description: "even more fun", category_id: 1)
			expect(Category.first.recent_videos().size).to eq(6)
		end

		it "should list newer ones first" do
			Category.create(name: "Fun")
			video = Video.create(title: "testMovie", description: "fun movie", category_id: 1)
			video2 = Video.create(title: "testMovie2", description: "even more fun", category_id: 1)
			video3 = Video.create(title: "testMovie3", description: "fun movie", category_id: 1)
			video4 = Video.create(title: "testMovie4", description: "even more fun", category_id: 1)
			video5 = Video.create(title: "testMovie5", description: "fun movie", category_id: 1)
			video6 = Video.create(title: "testMovie6", description: "even more fun", category_id: 1)
			video7 = Video.create(title: "testMovie7", description: "fun movie", category_id: 1)
			video8 = Video.create(title: "testMovie8", description: "even more fun", category_id: 1)
			expect(Category.first.recent_videos()).to eq([video, video2, video3, video4, video5, video6])
		end

		it "should return all videos if there are less than six in this category" do
			Category.create(name: "Fun")
			video = Video.create(title: "testMovie", description: "fun movie", category_id: 1)
			video2 = Video.create(title: "testMovie2", description: "even more fun", category_id: 1)
			video3 = Video.create(title: "testMovie3", description: "fun movie", category_id: 1)
			expect(Category.first.recent_videos()).to eq([video, video2, video3])
		end
	end
end