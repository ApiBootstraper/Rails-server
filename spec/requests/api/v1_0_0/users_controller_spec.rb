require 'spec_helper'

describe "Api::V1_0_0::UsersController" do
  include AuthHelper
  fixtures :users

  after(:each) do
    # ActiveRecord::Base.connection.close
  end

  describe "POST /user" do
    it "doesn't create user without username and email" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      post "/user", {:user => {:password => 'demo_fail_pass'}}, {"X-Api-Version" => "1.0.0"}

      response.status.should              be(400)
      response.content_type.should        eq("application/json")
    end

    it "doesn't create user without username" do
      post "/user", {:user => {:password => 'demo_fail_pass', :email => 'demo-fail@apibootstraper.com'}}, {"X-Api-Version" => "1.0.0"}

      response.status.should              be(400)
      response.content_type.should        eq("application/json")
    end

    it "doesn't create user without password" do
      post "/user", {:user => {:username => 'demo_test', :email => 'demo-fail@apibootstraper.com'}}, {"X-Api-Version" => "1.0.0"}

      response.status.should              be(400)
      response.content_type.should        eq("application/json")
    end

    it "create user works!" do
      post "/user", {:user => {:username => 'demo_test', :password => 'demo_test_pass', :email => 'api_unit_test@apibootstraper.com'}}, {"X-Api-Version" => "1.0.0"}

      response.status.should              be(201)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["user"]["username"].should       eq('demo_test')
      json["response"]["user"]["email"].should          eq('api_unit_test@apibootstraper.com')
      json["response"]["user"]["uuid"].should_not       be_empty
    end
  end


  describe "GET /user/my" do
    it "works!" do
      get "/user/my", nil, {"X-Api-Version" => "1.0.0", "HTTP_AUTHORIZATION" => encode_credentials(users(:alice).email, "alice_pass")}

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["user"]["username"].should       eq(users(:alice).username)
      json["response"]["user"]["email"].should          eq(users(:alice).email)
      json["response"]["user"]["uuid"].should           eq(users(:alice).uuid)
    end
  end


  describe "PUT /user/my" do
    it "change email works!" do
      put "/user/my", {:user => {:email => "bob2@apibootstraper.com"}},
                      {"X-Api-Version" => "1.0.0", "HTTP_AUTHORIZATION" => encode_credentials(users(:bob).email, "bob_pass")}

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["user"]["username"].should       eq(users(:bob).username)
      json["response"]["user"]["email"].should          eq("bob2@apibootstraper.com")
      json["response"]["user"]["uuid"].should           eq(users(:bob).uuid)
    end

    it "change password works!" do
      put "/user/my", {:user => {:password => "bob2_pass"}},
                      {"X-Api-Version" => "1.0.0", "HTTP_AUTHORIZATION" => encode_credentials(users(:bob).email, "bob_pass")}

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["user"]["username"].should       eq(users(:bob).username)
      json["response"]["user"]["email"].should          eq(users(:bob).email)
      json["response"]["user"]["uuid"].should           eq(users(:bob).uuid)

      # Try to connect with new logins
      get "/user/my", nil, {"X-Api-Version" => "1.0.0", "HTTP_AUTHORIZATION" => encode_credentials(users(:bob).email, "bob2_pass")}
      response.status.should    be(200)
    end
  end


  describe "GET /user/:uuid" do
    it "not found works!" do
      get "/user/736b2280-58dd-012f-3d2e-482a1450444f", nil, {"X-Api-Version" => "1.0.0", "HTTP_AUTHORIZATION" => encode_credentials(users(:bob).email, "bob_pass")}

      response.status.should              be(404)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"].should be_nil
      json["header"]["status"]["code"].should be(404)
    end

    it "works!" do
      get "/user/#{users(:alice).uuid}", nil, {"X-Api-Version" => "1.0.0", "HTTP_AUTHORIZATION" => encode_credentials(users(:bob).email, "bob_pass")}

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["user"]["email"].should      be_nil
      json["response"]["user"]["uuid"].should       eq(users(:alice).uuid)
      json["response"]["user"]["username"].should   eq(users(:alice).username)
    end
  end


  describe "GET /user/search" do
    it "bad request works!" do
      get "/user/search", nil, {"X-Api-Version" => "1.0.0", "HTTP_AUTHORIZATION" => encode_credentials(users(:bob).email, "bob_pass")}

      response.status.should              be(400)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"].should be_nil
      json["header"]["status"]["code"].should be(400)
    end

    it "works!" do
      get "/user/search?q=a", nil, {"X-Api-Version" => "1.0.0", "HTTP_AUTHORIZATION" => encode_credentials(users(:bob).email, "bob_pass")}

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["query"].should              eq("a")
      json["response"]["page"].should               eq(1)
      json["response"]["total"].should              eq(1)
    end
  end


  describe "GET /user/availability" do
    it "bad request works!" do
      get "/user/availability", nil, {"X-Api-Version" => "1.0.0"}

      response.status.should              be(400)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"].should be_nil
      json["header"]["status"]["code"].should be(400)
    end

    it "works for non available username!" do
      get "/user/availability?username=bob", nil, {"X-Api-Version" => "1.0.0"}

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["available"].should          eq(false)
      json["response"]["username"].should           eq("bob")
    end

    it "works for available username!" do
      get "/user/availability?username=choubaka", nil, {"X-Api-Version" => "1.0.0"}

      response.status.should              be(200)
      response.content_type.should        eq("application/json")
      json = MultiJson.load(response.body)

      json["response"]["available"].should          eq(true)
      json["response"]["username"].should           eq("choubaka")
    end
  end
  
end
