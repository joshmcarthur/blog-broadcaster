module JekyllBroadcaster
  class App < Sinatra::Base

    #Setup!
    set :broadcast_matcher, "BROADCAST:"
    set :blog_url, "http://blog.joshmcarthur.com"

    # Present an aboot page
    get '/' do
      erb :aboot
    end

    # Receive a post-receive hook from Github
    post '/' do
      @message = JSON.parse(params[:payload]).commits.last.message
      return "<h1>I'm not broadcasting, you didn't tell me to</h1>" unless i_should_continue?
      return "Received #{@message}"
      #broadcast!(@message)
    end

    private

    def should_i_continue?
      if @message && @message =~ /\A#{broadcast_matcher}/
        true
      else
        false
      end
    end

    def broadcast!
      begin
        TwitterBroadcaster.do_it!(message, blog_url)
        FacebookBroadcaster.do_it!(message, blog_url)
        return "Posted #{message}."
      rescue Exception => exp
        return "Woah! #{exp.message}"
      end
    end

  end
end

