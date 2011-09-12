module JekyllBroadcaster
  class FacebookBroadcaster
    def self.do_it!(message = "I've pushed new content up to my blog!", url = "")
      raise "I need a message, an access token, and a URL" unless message && ENV['FACEBOOK_ACCESS_TOKEN'] && url
      # Broadcast me!
      FbGraph::User.me(ENV['FACEBOOK_ACCESS_TOKEN']).feed!(
        :message => message,
        :link => url,
        :name => "Blog Broadcaster",
        :description => "Publishes blog posts on social networks from Git pushes."
      )
    end
  end
end

