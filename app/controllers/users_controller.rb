class UsersController < ApplicationController

	def show
	  @user = User.find(params[:id])
	end

	def new
	  @user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			flash[:success] = "Your account has been created!"
			session[:user_id] = @user.id
			redirect_to videos_path
		else
			render :new
		end
	end


private
	def user_params
		params.require(:user).permit(:full_name, :password, :email)
	end
end