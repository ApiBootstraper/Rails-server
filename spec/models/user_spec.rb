require 'spec_helper'

describe "User" do
  fixtures :users

  describe "creation" do
    # it "includes articles published less than one week ago" do
    #   article = Article.create!(:published_at => Date.today - 1.week + 1.second)
    #   Article.recent.should eq([article])
    # end

    # it "excludes articles published at midnight one week ago" do
    #   article = Article.create!(:published_at => Date.today - 1.week)
    #   Article.recent.should be_empty
    # end

    # it "excludes articles published more than one week ago" do
    #   article = Article.create!(:published_at => Date.today - 1.week - 1.second)
    #   Article.recent.should be_empty
    # end

    it "should not save user without username" do
      user = User.new
      assert !user.save
    end

    it "should save a user with username and password and email" do
      user = User.new
      user.username = "unittest"
      user.password = "unittest_pass"
      user.email = "unittest@apibootstraper.com"
      assert user.save
    end
  end
end
