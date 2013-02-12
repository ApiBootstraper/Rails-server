require 'spec_helper'

describe "Api::V1_0_0::UsersController" do
  include AuthHelper
  fixtures :applications, :users

  before(:each) do
    @headers = {
      "X-Api-Version" => "1.0.0",
      "X-App-ID"      => applications(:android).app_id,
      "HTTP_ACCEPT"   => "application/json",
    }
  end

  describe "POST /todos" do
    it "doesn't create todo without name" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:alice).email, "alice_pass")
      post "/todos", {:todo => {}}, @headers

      response.status.should              be(400)
      response.content_type.should        eq("application/json")
    end

    it "create todo works!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:alice).email, "alice_pass")
      post "/todos", {:todo => {:name => "My first todo"}}, @headers

      response.status.should              be(201)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["todo"]["name"].should             eq("My first todo")
      json["response"]["todo"]["is_accomplished"].should  eq(false)
      json["response"]["todo"]["uuid"].should_not         be_empty
    end
  end


  describe "GET /todos/:uuid" do

  end


  describe "GET /todos/my" do

  end

  describe "PUT /todos/:uuid" do

  end
end
