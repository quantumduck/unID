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
//= require bootstrap-sprockets
//= require_tree .
//= resuire vendor/assets/javascripts/google_platform.js


$(function() {
  $( ".sortable" ).sortable({
     revert: true,
   });


  $('.dropdown-toggle').dropdown({
    revert: true,
  });

  $('#faceboo_login').on('click', function(){
    window.location.href='/auth/facebook'
  });

  $('#twitter_login').on('click', function(){
    window.location.href='/auth/twitter'
  });

  $('#google_login').on('click', function(){
    window.location.href='/auth/google'
  });

  $('#linkedin_login').on('click', function(){
    window.location.href='/auth/linkedin'
  });




$('.toggle_search').on('click', function(){
  if ($('#search-form').css('display')==='none') {
    console.log("CLICK");
    $("#search-form").show("slide", {direction: "left"}, 500);
    $("#search-form").parent().addClass("is-visible");
  } else {
    console.log("UNCLICK");
    $("#search-form").hide("slide", {direction: "left"}, 500);
    $("#search-form").parent().removeClass("is-visible");
  }
});


});
