module JekyllBroadcaster
  class App < Sinatra::Base
    require File.dirname(__FILE__) + '/twitter_broadcaster'
    require File.dirname(__FILE__) + '/facebook_broadcaster'

    #Setup!
    set :broadcast_matcher, "BROADCAST:"
    set :remove_matcher, true
    set :blog_url, "http://blog.joshmcarthur.com"
    set :allowed_facebook_users, ["joshua.mcarthur"]

    # Present an aboot page
    get '/' do
      erb :aboot
    end

    # Facebook is stoopid. We need to have a bunch of routes here just to authorize the user
    get '/setup/authorize/fb' do
      facebook_auth_client.redirect_uri = request.url.gsub(/\?(.)*\Z/, '') + "/complete"
      redirect facebook_auth_client.authorization_uri(:scope => [:offline_access, :publish_stream])
    end

    get '/setup/authorize/fb/complete' do
      facebook_auth_client.authorization_code = params[:code]
      access_token = facebook_auth_client.access_token!
      set_access_token_if_we_want_it(access_token)
    end

    # Receive a post-receive hook from Github
    post '/' do
      @message = JSON.parse(params[:payload])["commits"].last["message"]
      @message.strip! if @message.is_a?(String)
      return "<h1>I'm not broadcasting, you didn't tell me to</h1>" unless i_should_continue?
      broadcast!(@message)
    end

    private

    def facebook_auth_client
      @facebook_auth_client ||= FbGraph::Auth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']).client
    end

    def i_should_continue?
      if @message && @message =~ /\A#{settings.broadcast_matcher}/
        @message.gsub!(/\A#{settings.broadcast_matcher}/, '') if settings.remove_matcher
        true
      else
        false
      end
    end

    def broadcast!(message)
      begin
        JekyllBroadcaster::TwitterBroadcaster.do_it!(message, settings.blog_url)
        FacebookBroadcaster.do_it!(message, settings.blog_url) if ENV['FACEBOOK_ACCESS_TOKEN']
        return "Posted #{message}."
      rescue Exception => exp
        return "Woah! #{exp.message}"
      end
    end

    def set_access_token_if_we_want_it(access_token)
      user = FbGraph::User.me(access_token).fetch
      unless settings.allowed_facebook_users.include?(user.identifier)
        return "<h1>Sorry, but you're not allowed to authorize as the broadcaster account.</h1>"
      end
      ENV['FACEBOOK_ACCESS_TOKEN'] = access_token
      return "<h1>Thanks #{user.full_name}. You're now the official broadcaster!</h1>"
    end

  end
end

