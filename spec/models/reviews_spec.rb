require 'spec_helper'

describe Review do 
	it {should belong_to(:video)}
	it {should belong_to(:user)}
	it {should validate_presence_of(:user_id)}
	it {should validate_presence_of(:text)}
	it {should validate_presence_of(:rating)}

end

