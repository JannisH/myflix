require 'spec_helper'

describe SessionsController do 

	describe 'GET new' do
	  it 'should render the login page' do
	  	get :new
	  	response.should render_template :new
	  end
	end
	
	describe 'POST create' do
		context 'with authentication' do

	  it 'should create a session when the user signs in correctly' do
	  	user = Fabricate(:user)
	  	post :create,  {password: "testtest", email: "test@test.com"}
	  	session[:user_id].should == user.id
	  end

	  it 'should redirect to the video index page' do
	  	user = Fabricate(:user)
	  	post :create,  {password: "testtest", email: "test@test.com"}
	  	response.should redirect_to videos_path
	  end

	  it 'should flash the info message' do
	  	user = Fabricate(:user)
	  	post :create,  {password: "testtest", email: "test@test.com"}
	  	flash[:info].should_not == nil
	  end

	end

	context 'without authentication ' do

		it 'should create a session when the user signs in correctly' do
	  	user = Fabricate(:user)
	  	post :create,  {password: "testt", email: "test@test.com"}
	  	session[:user_id].should == nil
	  end

	  it 'should redirect to the video index page' do
	  	user = Fabricate(:user)
	  	post :create,  {password: "test", email: "test@test.com"}
	  	response.should render_template :new
	  end

	  it 'should flash the info message' do
	  	user = Fabricate(:user)
	  	post :create,  {password: "test", email: "test@test.com"}
	  	flash[:danger].should_not == nil
	  end
	end
end

	describe 'GET destroy' do

		before do
			user = Fabricate(:user)
	  	post :create,  {password: "testtest", email: "test@test.com"}
	  	get :destroy
		end

		it 'should set the user_id in the session to nil again' do
	  	session[:user_id].should == nil
	  end

	  it 'should redirect to the front page' do
	  	response.should redirect_to root_path
	  end

	  it 'should flash the verification message' do
	  	flash[:info].should_not == nil
	  end
	end
end