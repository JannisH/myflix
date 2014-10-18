class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  def current_user
  	  @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
  	!!current_user
  end

  def require_login
    if !logged_in?
      flash[:danger] = "Please log in"
      redirect_to root_path
    end
  end

  def change_ratings(changes)
  changes.each do |item|
      review = Review.find_by(video_id: item["id"], user_id: current_user.id)
      if(review && !(review.rating == item["rating"]))
        review.rating = item["rating"]
        review.save
      elsif review == nil
        Review.create(user_id: current_user.id, rating: item["rating"])
      end
    end
  end
end
