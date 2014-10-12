class Video < ActiveRecord::Base
	belongs_to :category
	has_many :reviews
	validates :title, presence: true
	validates :description, presence: true
	validates_uniqueness_of :review, scope: :user_id

	def search_by_title(search_param)
	  string = "%" + search_param + "%"
	  Video.where("title LIKE '#{string}'")
	end

	def average_rating
	  self.reviews.inject(0){|sum, review| sum+review.rating} / self.reviews.size
	end
end