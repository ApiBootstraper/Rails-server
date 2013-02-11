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

  describe "POST /users" do
    it "doesn't create user without username and email" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      post "/users", {:user => {:password => 'demo_fail_pass'}}, @headers

      response.status.should              be(400)
      response.content_type.should        eq("application/json")
    end

    it "doesn't create user without username" do
      post "/users", {:user => {:password => 'demo_fail_pass', :email => 'demo-fail@apibootstraper.com'}}, @headers

      response.status.should              be(400)
      response.content_type.should        eq("application/json")
    end

    it "doesn't create user without password" do
      post "/users", {:user => {:username => 'demo_test', :email => 'demo-fail@apibootstraper.com'}}, @headers

      response.status.should              be(400)
      response.content_type.should        eq("application/json")
    end

    it "create user works!" do
      post "/users", {:user => {:username => 'demo_test', :password => 'demo_test_pass', :email => 'api_unit_test@apibootstraper.com'}}, @headers

      response.status.should              be(201)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["user"]["username"].should       eq('demo_test')
      json["response"]["user"]["email"].should          eq('api_unit_test@apibootstraper.com')
      json["response"]["user"]["uuid"].should_not       be_empty
    end
  end


  describe "GET /users/my" do
    it "works!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:alice).email, "alice_pass")
      get "/users/my", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["user"]["username"].should       eq(users(:alice).username)
      json["response"]["user"]["email"].should          eq(users(:alice).email)
      json["response"]["user"]["uuid"].should           eq(users(:alice).uuid)
    end
  end


  describe "PUT /users/my" do
    it "change email works!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:bob).email, "bob_pass")
      put "/users/my", {:user => {:email => "bob2@apibootstraper.com"}}, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["user"]["username"].should       eq(users(:bob).username)
      json["response"]["user"]["email"].should          eq("bob2@apibootstraper.com")
      json["response"]["user"]["uuid"].should           eq(users(:bob).uuid)
    end

    it "change password works!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:bob).email, "bob_pass")
      put "/users/my", {:user => {:password => "bob2_pass"}}, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["user"]["username"].should       eq(users(:bob).username)
      json["response"]["user"]["email"].should          eq(users(:bob).email)
      json["response"]["user"]["uuid"].should           eq(users(:bob).uuid)

      # Try to connect with new logins
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:bob).email, "bob2_pass")
      get "/users/my", nil, @headers
      response.status.should    be(200)
    end
  end


  describe "GET /users/:uuid" do
    it "not found works!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:bob).email, "bob_pass")
      get "/users/736b2280-58dd-012f-3d2e-482a1450444f", nil, @headers

      response.status.should              be(404)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"].should be_nil
      json["header"]["status"]["code"].should be(404)
    end

    it "works!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:bob).email, "bob_pass")
      get "/users/#{users(:alice).uuid}", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["user"]["email"].should      be_nil
      json["response"]["user"]["uuid"].should       eq(users(:alice).uuid)
      json["response"]["user"]["username"].should   eq(users(:alice).username)
    end
  end


  describe "GET /users/search" do
    it "bad request works!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:bob).email, "bob_pass")
      get "/users/search", nil, @headers

      response.status.should              be(400)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"].should be_nil
      json["header"]["status"]["code"].should be(400)
    end

    it "works!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:bob).email, "bob_pass")
      get "/users/search?q=ali", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["query"].should              eq("ali")
      json["response"]["limit"].should              eq(25)
      json["response"]["offset"].should             eq(0)
      json["response"]["total"].should              eq(1)
    end

    it "works with pagination!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:bob).email, "bob_pass")
      get "/users/search?q=ali&page=1", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["query"].should              eq("ali")
      json["response"]["limit"].should              eq(25)
      json["response"]["offset"].should             eq(0)
      json["response"]["total"].should              eq(1)
    end

    it "works with limit!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:bob).email, "bob_pass")
      get "/users/search?q=bob&limit=1", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["query"].should              eq("bob")
      json["response"]["limit"].should              eq(1)
      json["response"]["offset"].should             eq(0)
      json["response"]["total"].should              eq(1)
    end

    it "works with offset!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:bob).email, "bob_pass")
      get "/users/search?q=ali&offset=1", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["query"].should              eq("ali")
      json["response"]["limit"].should              eq(25)
      json["response"]["offset"].should             eq(1)
      json["response"]["total"].should              eq(1)
    end

    it "works with limit and offset!" do
      @headers["HTTP_AUTHORIZATION"] = encode_credentials(users(:bob).email, "bob_pass")
      get "/users/search?q=bob&limit=2&offset=1", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["query"].should              eq("bob")
      json["response"]["limit"].should              eq(2)
      json["response"]["offset"].should             eq(1)
      json["response"]["total"].should              eq(1)
    end
  end


  describe "GET /users/availability" do
    it "bad request works!" do
      get "/users/availability", nil, @headers

      response.status.should              be(400)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"].should be_nil
      json["header"]["status"]["code"].should be(400)
    end

    it "works for non available username!" do
      get "/users/availability?username=bob", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["available"].should          eq(false)
      json["response"]["username"].should           eq("bob")
    end

    it "works for available username!" do
      get "/users/availability?username=choubaka", nil, @headers

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["available"].should          eq(true)
      json["response"]["username"].should           eq("choubaka")
    end
  end
end
