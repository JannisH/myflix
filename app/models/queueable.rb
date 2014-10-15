class Queueable < ActiveRecord::Base
	belongs_to :video_queue
	belongs_to :video
	validates_uniqueness_of :video_queue_id, scope: :video_id
end