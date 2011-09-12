module JekyllBroadcaster
  class TwitterBroadcaster
    def self.consumer_token
      ENV['TWITTER_CONSUMER_TOKEN']
    end

    def self.consumer_secret
      ENV['TWITTER_CONSUMER_SECRET']
    end

    def self.access_token
      ENV['TWITTER_ACCESS_TOKEN']
    end

    def self.access_secret
      ENV['TWITTER_ACCESS_SECRET']
    end

    def self.do_it!(message = "I've pushed new content up to my blog!", url = "")
      Twitter.configure do |config|
        config.consumer_key = ENV['TWITTER_CONSUMER_TOKEN']
        config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
        config.oauth_token = ENV['TWITTER_ACCESS_TOKEN']
        config.oauth_secret = ENV['TWITTER_ACCESS_SECRET']
      end
      raise "I need a 140 char message and a URL." unless message && url && message.length < 140
      Twitter.update(message[0..120] + " " + url)
    end
  end
end

