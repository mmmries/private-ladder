Private Ladder
========================================================
A mini-app that uses some simple ruby tools to provide a private ladder system
for a group of friends that want to keep track of their relative ranking across
different games.

Hopefully development will be contributed from various friends and any other
people who find this project useful.

Help Needed
========================================================
This project needs help to make it awesome for everyone.  Any suggestions or
pull requests will be checked into.  Here are some areas that need help most
urgently.

+   The UI desperately needs an upgrade
+   A more realistic scoring mechanism where the relative ranking of players is considered
+   Dynamic scoring system where the different leagues can have different scoring
+   Support for different game types (ie more than 2 players, more than 1 winner, etc)

Project Information
=======================================================
This project uses a lot of existing ruby libraries to simplify its own codebase.
Here is a list of gems used and a suggested development environment.

Uses:

+   CouchDB for storage
+   CouchRest + Model for talking to CouchDB ( https://github.com/couchrest/couchrest, https://github.com/couchrest/couchrest_model )
    + Currently couchrest_model must be built from source since the rubygems.org version has a bad dependency on activesupport-2.3.5
+   Rails for a web interface layer ( do you really need a URL? )
+   HAML + SCSS for rendering templates ( http://haml-lang.com/, http://sass-lang.com/ )
+   Pony for sending emails ( http://adam.heroku.com/past/2008/11/2/pony_the_express_way_to_send_email_from_ruby/ )

My Installation:

+ ubuntu 10.10
+ rvm
+ Ruby 1.9.2
+ installing the couchrest_model (see below) should automatically install rails 3.0.1 if you have another rails version already installed consider using a separate gemset
  + rvm gemset create ladder
  + rvm gemset use
+ gem install couchrest haml rspec bundler
+ build couchrest_model from github source https://github.com/couchrest/couchrest_model
  + git clone https://github.com/couchrest/couchrest_model /tmp/couchrest_model
  + cd /tmp/couchrest_model
  + rake build
  + gem install pkg/couchrest_model-1.0.0.gem