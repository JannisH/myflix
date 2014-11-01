require 'spec_helper'

describe UsersController do 



	describe 'GET new' do
	  it 'should render the new template' do
	  	get :new
	  	response.should render_template :new
	  end
	  
	  it 'sets the @user variable' do
	  	get :new
	  	assigns(:user).should be_new_record
	  	assigns(:user).should be_instance_of(User)
	  end
	end

	describe 'POST create' do
	  
	  it 'should create a new User in the database when everything is filled out correctly' do
	  	post :create, user: {full_name: "peter", password: "123456", email: "peter@peter.com"}
	  	User.count.should == 1
	  	User.first.email.should == "peter@peter.com"
	  end

	  it 'should not create a User when the input is invalid' do
	  	post :create, user: {full_name: "peter", password: "1234", email: "peter@peter.com"}
	  	User.count.should == 0
	  end

	  it 'should render the sign up page again if input is invalid' do
	  	post :create, user: {full_name: "peter", password: "1234", email: "peter@peter.com"}
	  	response.should render_template :new
	  end

	  it 'should redirect to the videos index when signed up correctly' do
	  	post :create, user: {full_name: "peter", password: "123456", email: "peter@peter.com"}
		response.should redirect_to videos_path
	  end
	end

	describe 'GET show' do
	  let(:user) { Fabricate(:user) }


	  it 'sets the @user variable' do
	  	session[:id]=user.id
	  	get :show, id: 1
	  	expect(assigns(:user)).to eq(user)
	  end
	end
end