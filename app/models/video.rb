class Video < ActiveRecord::Base
	belongs_to :category
	has_many :video_queues, through: :queueables
	has_many :reviews
	has_many :queueables
	validates :title, presence: true
	validates :description, presence: true

	def search_by_title(search_param)
	  string = "%" + search_param + "%"
	  Video.where("title LIKE '#{string}'")
	end

	def get_priority_by_user(user)
		queueable= Queueable.find_by(video_id: self.id, video_queue_id: user.video_queue.id)
		if queueable
			queueable.priority
		end
	end

	def average_rating
		if self.reviews.size > 0
	      self.reviews.inject(0) { |sum, review| sum + review.rating} / self.reviews.size.to_f
	  end
	end

	def review_exists?(user_id)
		Review.find_by(user_id: user_id, video_id: self.id) != nil
	end

end