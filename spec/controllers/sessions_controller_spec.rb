require 'spec_helper'

describe SessionsController do 

	describe 'GET new' do
	  it 'should render the login page' do
	  	get :new
	  	response.should render_template :new
	  end
	end
	
	describe 'POST create' do
		let(:user) { Fabricate(:user) }
	
	context 'with authentication' do
	  it 'should create a session when the user signs in correctly' do
	  	post :create,  {password: user.password, email: user.email}
	  	expect(session[:user_id]).to eq(user.id)
	  end

	  it 'should redirect to the video index page' do
	  	post :create,  {password: user.password, email: user.email}
	  	expect(response).to redirect_to(videos_path)
	  end

	  it 'should flash the info message' do
	  	post :create,  {password: user.password, email: user.email}
	  	expect(flash[:info]).to_not eq(nil)
	  end

	end

	context 'without authentication ' do

		it 'should not create a session when the user signs in correctly' do
	  	post :create,  {password: user.password+"s", email: user.email}
	  	expect(session[:user_id]).to eq(nil)
	  end

	  it 'should redirect to the video index page' do
	  	post :create,  {password: user.password+"s", email: user.email}
	  	expect(response).to render_template :new
	  end

	  it 'should flash the info message' do
	  	post :create,  {password: user.password+"s", email: user.email}
	  	expect(flash[:danger]).to_not eq(nil)
	  end
	end
end

	describe 'GET destroy' do
		let(:user) { Fabricate(:user) }
		
		before do
	  		post :create,  {password: user.password, email: user.email}
	  		get :destroy
		end

	  it 'should set the user_id in the session to nil again' do
	  	expect(session[:user_id]).to eq(nil)
	  end

	  it 'should redirect to the front page' do
	  	expect(response).to redirect_to root_path
	  end

	  it 'should flash the verification message' do
	  	expect(flash[:info]).to eq("You have successfully logged out!")
	  end
	end
end