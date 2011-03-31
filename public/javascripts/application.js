// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
    /** Attempt #1
    window.Player = Backbone.Model.extend({
        initialize: function(){
            if( !this.get("name") ){
                this.set({"name":"n00b"});
            }
        }
    });
    
    window.PlayerList = Backbone.Collection.extend({
       model: Player,
       comparator: function(player){
        return player.get("name");
       }
    });
    
    window.Players = new PlayerList();
    
    window.PlayerView = Backbone.View.extend({
        tagName: "div",
        template: _.template($('#player-template').html()),
        
        events:{
            
        },
        
        initialize: function(){
            _.bindAll(this, 'render');
            this.model.bind('change', this.render);
            this.model.view = this;
        },
        
        render: function() {
            $(this.el).html(this.template(this.model.toJSON()));
            this.setContent();
            return this;
        },
        
        setContent: function(){
            this.$('.name').text(this.get('name'));
        }
    });
    **/
    
    //Attempt #2
    window.Player = Backbone.Model.extend({});
    
    window.PlayerList = Backbone.Collection.extend({
        model: Player,
        initialize:function(){
            
        }
    });
    
    window.PlayerView = Backbone.View.extend({
        template: _.template($('#player-template').html()),
        
        initialize: function(){
            _.bindAll(this, 'changeName');
            
            this.model.bind('change:name', this.changeName);
        },
        
        changeName: function(){
            this.$('.name').text(this.model.get("name"));
        }
    });