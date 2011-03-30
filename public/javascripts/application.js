// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


var Player = Backbone.Model.extend({
    
});

var League = Backbone.Model.extend({
    
});

var LeagueList = Backbone.Collection.extend({
    'model':League,
    'fetch':function(){
        
    }
});

window.PlayerView = Backbone.View.extend({
   tagName: "div",
   
   template: _.template($("#player-template").html()),
   events: { },
   
   initialize: function(){
    _.bindAll(this, 'render', 'close');
    this.model.bind('change', this.render);
   },
   
   render: function() {
    $(this.el).html( this.template(this.model.toJSON()) );
    this.setContent();
    return this;
   }
   
   setContent: function() {
    
   }
});