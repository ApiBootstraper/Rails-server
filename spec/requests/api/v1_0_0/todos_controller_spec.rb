require 'spec_helper'

describe "Api::V1_0_0::UsersController" do
  include AuthHelper
  fixtures :applications, :users, :todos

  before(:each) do
    @headers = {
      "X-Api-Version" => "1.0.0",
      "X-App-ID"      => applications(:android).app_id,
      "HTTP_ACCEPT"   => "application/json",

      "HTTP_AUTHORIZATION" => encode_credentials(users(:alice).email, "alice_pass"),
    }
  end

  describe "POST /todos" do
    it "doesn't create todo without name" do
      post "/todos", {:todo => {}}, @headers

      response.status.should              be(400)
      response.content_type.should        eq("application/json")
    end

    it "create todo works!" do
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
    it "not found works!" do
      get "/todos/736bc280-58dd-012f-3d2e-482a1450444f", nil, @headers

      response.status.should              be(404)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"].should be_nil
      json["header"]["status"]["code"].should be(404)
    end

    it "works!" do
      get "/todos/#{todos(:todo_1).uuid}", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["todo"]["uuid"].should               eq(todos(:todo_1).uuid)
      json["response"]["todo"]["name"].should               eq(todos(:todo_1).name)
      json["response"]["todo"]["description"].should        eq(todos(:todo_1).description)
      json["response"]["todo"]["is_accomplished"].should    eq(todos(:todo_1).is_accomplished)
    end
  end


  describe "GET /todos/my" do

  end


  describe "PUT /todos/:uuid" do

  end


  describe "PUT /todos/:uuid/(check|uncheck)" do

  end


  describe "DELETE /todos/:uuid" do

  end


  describe "GET /todos/search" do
    it "bad request works!" do
      get "/todos/search", nil, @headers

      response.status.should              be(400)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"].should be_nil
      json["header"]["status"]["code"].should be(400)
    end

    it "works!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:bob).email, "bob_pass")
      get "/todos/search?q=todo", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["query"].should              eq("todo")
      json["response"]["limit"].should              eq(25)
      json["response"]["offset"].should             eq(0)
      json["response"]["total"].should              eq(1)
    end

    it "works with pagination!" do
      get "/todos/search?q=todo&page=1", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["query"].should              eq("todo")
      json["response"]["limit"].should              eq(25)
      json["response"]["offset"].should             eq(0)
      json["response"]["total"].should              eq(2)
    end

    it "works with limit!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:bob).email, "bob_pass")
      get "/todos/search?q=task&limit=1", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["query"].should              eq("task")
      json["response"]["limit"].should              eq(1)
      json["response"]["offset"].should             eq(0)
      json["response"]["total"].should              eq(1)
    end

    it "works with offset!" do
      get "/todos/search?q=alice&offset=1", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["query"].should              eq("alice")
      json["response"]["limit"].should              eq(25)
      json["response"]["offset"].should             eq(1)
      json["response"]["total"].should              eq(1)
    end

    it "works with limit and offset!" do
      get "/todos/search?q=todo&limit=2&offset=1", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["query"].should              eq("todo")
      json["response"]["limit"].should              eq(2)
      json["response"]["offset"].should             eq(1)
      json["response"]["total"].should              eq(2)
    end
  end

end
