Blog Broadcaster
-------------

## About ##

This is a one-night hacking-together of an post-receive hook that can be pointed to by Github to automatically post a link and message to Facebook and Twitter if the commit message matches a particular format.

## I want! ##

Sure, take it. You'll need to change some configuration, notably in `lib/jekyll_broadcaster/app.rb`, around who can authorize their Facebook account, and the pattern to recognize in commit messages (by default, it's "BROADCAST:"), but it's all pretty easy and central. You'll need to set up your own Twitter and Facebook applications and load necessary app ids, tokens, secrets etc into your ENV.

## How does it work? ##

Github supports Web hooks, where some JSON is POSTed to a URL after a commit. This simple Sinatra app just receives the JSON, parses out the latest message, checks to see if it should broadcast it, and if it should - well, it broadcasts it!

## Is it tested then? ##

No, and it won't be unless enough people either start using it or have problems with it enough to necessitate me being able to say it works.

## Caveats ##

* Only the last commit message is checked for a match - if you push, and that push includes a bunch of changes, not all of the messages will be checked. **Make sure that your last commit is the one you want to broadcast!**
* There is no way to manually trigger or customize a broadcast

## Licensing ##
MIT as usual - it's all yours.

