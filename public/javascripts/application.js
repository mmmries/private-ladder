    window.Player = Backbone.Model.extend({});
    
    window.PlayerList = Backbone.Collection.extend({
        model: Player,
        url: '/players.json',
        initialize:function(){
            
        }
    });