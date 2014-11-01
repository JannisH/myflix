class VideoQueuesController < ApplicationController
  before_action :require_login

  def add
  	@queue = current_user.video_queue.videos
  	if(!@queue.include?(Video.find(params[:video_id])))
  		Queueable.create(video_id: params[:video_id], video_queue_id: current_user.video_queue.id, priority: current_user.video_queue.get_priority)
  		redirect_to video_queue_path(current_user.video_queue)
  	else
  		flash[:danger] = "The video you tried to add was already on your queue!"
  		redirect_to :back
  	end
  end

  def show
  	@queueables = current_user.video_queue.queueables.sort_by {|x| x.priority}
  end

  def remove
  	queue = current_user.video_queue
  	size = queue.videos.size
  	item = queue.queueables.find_by(video_id: params[:video_id])
  	if item
  		delete_priority = queue.queueables.find_by(video_id: params[:video_id]).priority
  		queue.videos.delete(params[:video_id])
  		queue.queueables.each do |item|
  			if item.priority > delete_priority
  				item.priority -= 1
  				item.save
  			end
  		end
  	else
  		flash[:danger] = "The video you tried to remove wasn't in your queue!"
  	end
  	redirect_to video_queue_path(current_user.video_queue)
  end

  def update
  	queue = current_user.video_queue
  	queue_changes = params[:queue_items]
  	if invalid_input?(queue_changes)
  		flash[:danger] = "You assigned at least two videos with the same priority or used illegal signs!"
  	else
  		queue.update_queue(queue_changes)
      queue.normalize_priorities
  	end
  	redirect_to video_queue_path(current_user.video_queue)
  end

private
 def invalid_input?(priority_entries)
  new_order = priority_entries.map {|entry| entry['position']}
 	new_order.each do |num|
      position = new_order.delete_at(0)
  		if new_order.include?(position) || (position.to_i == 0) || (position.to_f > position.to_i)
   		  return true
  		end
  	end
  	false
 end

end