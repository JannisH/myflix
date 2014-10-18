class ReviewsController < ApplicationController
	before_action :require_login, only: :create
	
	def new
	  @review = Review.new
	end

	def create
	  @video = Video.find_by(id: params[:video_id])
	  if(@video.review_exists?(current_user.id))
	  	flash[:danger] = "You have already reviewed this video."
	  	redirect_to :back
	  else
 		@review = @video.reviews.build(review_params)
	    @review.user = current_user
	    if @review.save
	      redirect_to video_path(@video)
	    else
	      flash[:danger] = "Please check if you entered all the informations for your review."
	      redirect_to :back
	    end
	  end
	end

	def update
	  
	end


private
	def review_params
	  params.require(:review).permit(:rating, :text)
	end

end