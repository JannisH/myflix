class Review < ActiveRecord::Base
	belongs_to :user
	belongs_to :video
	validates :rating, presence: true
	validates :user_id, presence: true
	validates :text, presence: true
	validates_uniqueness_of :user, scope: :video_id

end