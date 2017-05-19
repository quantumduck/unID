// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
var ready, set_positions;

set_positions = function(){
  // loop through and give each task a data-pos
   // attribute that holds its position in the DOM
   $('.card').each(function(i){
       $(this).attr("data-pos",i+1);
   });
}

$(function() {

  set_positions();


  $( ".row" ).sortable({
     revert: true,
   })
    //after the order changes

  $(".row").sortable({
    update: function( event, ui ) {

      //array to store new order

      updated_order = []

      //set the updated positions

      set_positions();

      //populate the updated_order array with the new task positions
      $('.card').each(function(i){
            updated_order.push({ id: $(this).data("id"), position: i+1 });

            // send the updated order via ajax
        $.ajax({
            type: "PUT",
            url: '/:id/profiles/something',
            data: { order: updated_order }

        })
      })
    }
  })

 $( ".row" ).disableSelection();
 });



//   $( ".card_names" ).sortable({
//     revert: true,
//   });
// });
