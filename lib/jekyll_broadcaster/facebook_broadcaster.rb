module JekyllBroadcaster
  class FacebookBroadcaster
    OAUTH_TOKEN = ENV['OAUTH_TOKEN']
    OAUTH_SECRET = ENV['OAUTH_SECRET']
  
    CLIENT_TOKEN = ENV['CLIENT_TOKEN']
    CLIENT_SECRET = ENV['CLIENT_SECRET']

    def self.do_it!(message = "I've pushed new content up to my blog!", url = "")
      raise "I need a message and a URL" unless message && url
      # Broadcast me!
    end
  end
end
