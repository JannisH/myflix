class Relationship < ActiveRecord::Base
	belongs_to :follower, class_name: "User"
	belongs_to :followed, class_name: "User"
	validates :follower_id, presence: true
	validates :followed_id, presence: true
	validate :must_be_able_to_follow
	validates_uniqueness_of :follower, scope: :followed

	def must_be_able_to_follow
		errors.add(:base, 'can not follow yourself') unless follower.can_follow?(followed)
	end
end