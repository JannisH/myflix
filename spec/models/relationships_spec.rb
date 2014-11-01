require 'spec_helper'

describe Relationship do 
	it { should respond_to(:follower) }
	it { should respond_to(:followed) }
end
