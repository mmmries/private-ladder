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

+   MongoDB for storage
+   Mongoid for talking to MongoDB
+   Rails for a web interface layer ( do you really need a URL? )
+   HAML + SCSS for rendering templates ( http://haml-lang.com/, http://sass-lang.com/ )
+   Pony for sending emails ( http://adam.heroku.com/past/2008/11/2/pony_the_express_way_to_send_email_from_ruby/ )

My Installation:

+ ubuntu 10.10
+ sudo apt-get install libxslt-dev libxml2-dev
+ rvm
+ rvm install ruby-1.9.2-p180
+ rvm use ruby-1.9.2-p180
+ rvm gemset create ladder
+ rvm gemset use ladder
+ gem install rspec bundler
+ bundle install
