require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  it { should belong_to(:commentable) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of(:comment) }
end