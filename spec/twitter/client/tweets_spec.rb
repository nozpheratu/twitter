require 'helper'

describe Twitter::Client do
  before do
    @client = Twitter::Client.new
  end

  describe ".status" do

    before do
      stub_get("/1/statuses/show/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.status(25938088801)
      a_get("/1/statuses/show/25938088801.json").
        should have_been_made
    end

    it "should return a single status" do
      status = @client.status(25938088801)
      status.text.should == "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end

  end

  describe ".update" do

    before do
      stub_post("/1/statuses/update.json").
        with(:body => {:status => "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"}).
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.update("@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!")
      a_post("/1/statuses/update.json").
        with(:body => {:status => "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"}).
        should have_been_made
    end

    it "should return a single status" do
      status = @client.update("@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!")
      status.text.should == "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end

  end

  describe ".update_with_media" do

    before do
      stub_post("/1/statuses/update_with_media.json", Twitter.media_endpoint).
        to_return(:body => fixture("status_with_media.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.update_with_media("You always have options", fixture("me.jpeg"))
      a_post("/1/statuses/update_with_media.json", Twitter.media_endpoint).
        should have_been_made
    end

    it "should return a single status" do
      status = @client.update_with_media("You always have options", fixture("me.jpeg"))
      status.text.should include("You always have options")
    end

    it 'should return the media as an entity' do
      status = @client.update_with_media("You always have options", fixture("me.jpeg"))
      status.entities.media.should be
    end

  end

  describe ".status_destroy" do

    before do
      stub_delete("/1/statuses/destroy/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.status_destroy(25938088801)
      a_delete("/1/statuses/destroy/25938088801.json").
        should have_been_made
    end

    it "should return a single status" do
      status = @client.status_destroy(25938088801)
      status.text.should == "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end

  end

  describe ".retweet" do

    before do
      stub_post("/1/statuses/retweet/28561922516.json").
        to_return(:body => fixture("retweet.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.retweet(28561922516)
      a_post("/1/statuses/retweet/28561922516.json").
        should have_been_made
    end

    it "should return the original tweet with retweet details embedded" do
      status = @client.retweet(28561922516)
      status.retweeted_status.text.should == "As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush."
    end

  end

  describe ".retweets" do

    before do
      stub_get("/1/statuses/retweets/28561922516.json").
        to_return(:body => fixture("retweets.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.retweets(28561922516)
      a_get("/1/statuses/retweets/28561922516.json").
        should have_been_made
    end

    it "should return up to 100 of the first retweets of a given tweet" do
      statuses = @client.retweets(28561922516)
      statuses.should be_an Array
      statuses.first.text.should == "RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush."
    end

  end

  describe ".retweeters_of" do

    before do
      stub_get("/1/statuses/27467028175/retweeted_by.json").
        to_return(:body => fixture("retweeters_of.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.retweeters_of(27467028175)
      a_get("/1/statuses/27467028175/retweeted_by.json").
        should have_been_made
    end

    it "should return " do
      users = @client.retweeters_of(27467028175)
      users.should be_an Array
      users.first.name.should == "Dave W Baldwin"
    end
  end
end
