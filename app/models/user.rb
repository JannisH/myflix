class User < ActiveRecord::Base
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

end