Private Ladder
========================================================
A mini-app that uses some simple ruby tools to provide a private starcraft 2
ladder system for a group of friends that want to keep track of their relative
ranking.

Uses:

+   CouchDB for storage
+   CouchRest + Model for talking to CouchDB ( https://github.com/couchrest/couchrest, https://github.com/couchrest/couchrest_model )
    + Currently couchrest_model must be built from source since the rubygems.org version has a bad dependency on activesupport-2.3.5
+   Sinatra for a web interface layer ( http://www.sinatrarb.com )
+   HAML + SCSS for rendering templates ( http://haml-lang.com/, http://sass-lang.com/ )
+   Pony for sending emails ( http://adam.heroku.com/past/2008/11/2/pony_the_express_way_to_send_email_from_ruby/ )

My Installation:

+ rvm
+ Ruby 1.9.2
+ build couchrest_model from github source https://github.com/couchrest/couchrest_model
+ gem install railties -v 3.0.0.rc2
+ gem install activesupport -v 3.0.0.rc2
+ gem install sinatra couchrest sinatra
