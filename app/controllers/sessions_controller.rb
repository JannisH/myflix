class SessionsController < ApplicationController
  def new
    #binding.pry
  end


  def create
    @user = User.find_by(email: params[:email])
    if (@user && @user.authenticate(params[:password]))
      session[:user_id] = @user.id
      flash[:info] = "You have successfully logged in!"
      redirect_to videos_path
    else
      flash[:danger] = "Something is wrong with your password or your username!"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "You have successfully logged out!"
    redirect_to root_path
  end


end