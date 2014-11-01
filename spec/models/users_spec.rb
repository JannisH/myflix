require 'spec_helper'

	describe 'can_follow?' do 
		let(:user) { Fabricate(:user) }
	  	let(:second_user) { Fabricate(:user) }
  		it 'should return true if the other user is not the same and is not already on the followeds list ' do
			expect(user.can_follow?(second_user)).to eq(true)
		end

		it 'should return false otherwise' do
			expect(user.can_follow?(user)).to eq(false)
			Relationship.create(follower_id: user.id, followed_id: second_user.id)
			expect(user.can_follow?(second_user)).to eq(false)
		end

	end

	describe 'get_followeds' do
		let(:user) { Fabricate(:user) }
	  	let(:second_user) { Fabricate(:user) }
		it 'should return a list of the followed users' do
			Relationship.create(follower_id: user.id, followed_id: second_user.id)
			expect(user.get_followeds).to eq([second_user])
		end
	end