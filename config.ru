require 'bundler/setup'
Bundler.require
require File.dirname(__FILE__) + '/lib/jekyll_broadcaster/app'


run JekyllBroadcaster::App
