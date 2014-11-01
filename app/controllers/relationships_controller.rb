class RelationshipsController < ApplicationController

  def index
    @followed = get_followed_ids.inject([]) {|array, id| array.push(User.find(id))}
  end

  def destroy
  	relationship = Relationship.find_by(follower_id: current_user.id, followed_id: params[:user_id])
  	if relationship
  	  relationship.destroy!
  	else
  	  flash[:danger]="This user wasn't in your follower list!"
  	end
  	redirect_to relationships_path
  end

  def follow
    if Relationship.create(follower_id: current_user.id, followed_id: params[:user_id])
      redirect_to relationships_path
    else
      flash[:danger] = "You already follow that user"
    end
  end

private

  def get_followed_ids
  	Relationship.where(follower_id: current_user.id).map {|relationship| relationship.followed}
  end
end