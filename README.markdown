Private Ladder
========================================================
A mini-app that uses some simple ruby tools to provide a private starcraft 2
ladder system for a group of friends that want to keep track of their relative
ranking.

Uses:

+   CouchDB for storage
+   CouchRest + Extended Model for talking to CouchDB ( https://github.com/couchrest/couchrest https://github.com/couchrest/couchrest_extended_document )
+   Sinatra for a web interface layer ( http://www.sinatrarb.com )
+   HAML for rendering templates ( http://haml-lang.com/ )
+   Pony for sending emails ( http://adam.heroku.com/past/2008/11/2/pony_the_express_way_to_send_email_from_ruby/ )