require 'spec_helper'

describe RelationshipsController do 

	describe 'GET index' do
	  let(:user) { Fabricate(:user) }
	  let(:second_user) { Fabricate(:user) }
	  let(:third_user) {Fabricate(:user)}
	  before do
	  	session[:user_id] = user.id
	  	Relationship.create(follower_id: user.id, followed_id: second_user.id)
	  	Relationship.create(follower_id: user.id, followed_id: third_user.id)
	  end

	  it 'should assign the @followed instance variable' do
	  	get :index
	  	expect(assigns(:followed)).to eq([second_user, third_user])
	  end

	end

	describe 'GET follow' do
	  let(:user) { Fabricate(:user) }
	  let(:second_user) { Fabricate(:user) }
	  let(:third_user) {Fabricate(:user)}
	  before do
	  	session[:user_id] = user.id
	  end

	  it 'should let a user follow another one' do
	  	get :follow, user_id: second_user.id
	  	expect(user.followed_users.size).to eq(1)
	  end

	  it 'should not let a user follow another one twice' do
	  	Relationship.create(follower_id: user.id, followed_id: second_user.id)
	  	get :follow, user_id: second_user.id
	  	expect(user.followed_users.size).to eq(1)
	  end

	  it 'should not let a user follow himself' do
	  	get :follow, user_id: user.id
	  	expect(user.followed_users.size).to eq(0)
	  end
	end

	describe 'DELETE destroy' do
      let(:user) { Fabricate(:user) }
	  let(:second_user) { Fabricate(:user) }
	  let(:third_user) {Fabricate(:user)}
	  before do
	  	session[:user_id] = user.id
	  	Relationship.create(follower_id: user.id, followed_id: second_user.id)
	  	Relationship.create(follower_id: user.id, followed_id: third_user.id)
	  end

	  it 'should remove a user from the follow list' do
	  	delete :destroy, user_id: second_user.id
	  	expect(user.followed_users.size).to eq(1)
	  end

	  it 'should redirect to the people page' do
	  	delete :destroy, user_id: second_user.id
	  	expect(response).to redirect_to(relationships_path)
	end
  end
end