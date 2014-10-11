require 'spec_helper'

describe Video do

	it {should belong_to(:category)}
	it {should validate_presence_of(:title)}
	it {should validate_presence_of(:description)}

	describe "search" do
		it "should find the correct video if there is just one that fits the search" do
			video = Video.create(title: "testMovie", description: "fun movie")
			video2 = Video.new
			expect(video2.search_by_title('test')[0]).to eq(video)
		end

		it "should return all the movies that fit the search pattern" do
			video = Video.create(title: "testMovie", description: "fun movie")
			video2 = Video.create(title: "testMovie2", description: "even more fun")
			expect(video2.search_by_title('test').size).to eq(2)
		end

		it "should return an empty array if there was no match" do
			video = Video.new()
			expect(video.search_by_title('test').size).to eq(0)
		end
	end
	


end