class User < ActiveRecord::Base
  has_many :followed_users,  class_name: "Relationship", foreign_key: 'follower_id'
  has_many :followers, class_name: "Relationship", foreign_key: 'followed_id'


  validates :full_name, presence: true
  has_many :reviews
  has_many :videos
  has_one :video_queue
  has_secure_password
  validates :password, on: :create, length: {minimum: 6}
  validates :email, uniqueness: true
  
  def get_priority(video)
  	Queueable.find_by(video_id: video.id, video_queue_id: self.video_queue.id).priority
  end

  def get_rating(video)
    review = Review.find_by(video_id: video.id, user_id: self.id)
    if review
      review.rating
    else
      ""
    end
  end

  def can_follow?(user)
    !(self == user || get_followeds.include?(user))
  end

  def get_followeds
      Relationship.where(follower_id: self.id).map {|relationship| relationship.followed}
  end

end