require 'spec_helper'

describe VideoQueue do 
	it {should have_many(:videos)}
	it {should belong_to(:user)}
	

end

