module JekyllBroadcaster
  class App < Sinatra::Base
    require 'json'
    require File.dirname(__FILE__) + '/twitter_broadcaster'

    #Setup!
    set :broadcast_matcher, "BROADCAST:"
    set :blog_url, "http://blog.joshmcarthur.com"

    # Present an aboot page
    get '/' do
      erb :aboot
    end

    # Receive a post-receive hook from Github
    post '/' do
      @message = JSON.parse(params[:payload])["commits"].last["message"]
      @message.strip! if @message.is_a?(String)
      return "<h1>I'm not broadcasting, you didn't tell me to</h1>" unless i_should_continue?
      broadcast!(@message)
    end

    private

    def i_should_continue?
      if @message && @message =~ /\A#{settings.broadcast_matcher}/
        true
      else
        false
      end
    end

    def broadcast!(message)
      begin
        JekyllBroadcaster::TwitterBroadcaster.do_it!(message, settings.blog_url)
        #FacebookBroadcaster.do_it!(message, settings.blog_url)
        return "Posted #{message}."
      rescue Exception => exp
        return "Woah! #{exp.message}"
      end
    end

  end
end

