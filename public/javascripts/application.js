// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


var Player = Backbone.Model.extend({
   promptName: function(){
        var new_name = prompt("Please enter the new name: ");
        this.set({name: new_name});
   }
});

