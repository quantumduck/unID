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
//= require jquery.slidereveal.min


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
    $("#search-form").show("slide", {direction: "left"}, 100);
    $("#search-form").parent().addClass("is-visible");
  } else {
    $("#search-form").hide("slide", {direction: "left"}, 100);
    $("#search-form").parent().removeClass("is-visible");
  }
});


// $('.col-md-4').hover( function() {
//   var obj = $(this);
//   var id = $(this).find(':first-child').attr('data-id');
//   var position = $(this).position();
//   var width = $(this).find(':first-child').outerWidth();
//   console.log(width)
//   console.log(position);
//   $(this).find(':first-child').css('visibility', 'hidden');
//   // $('.largecard.' + id).position() = position;
//   $('.largecard.' + id).css({'display':'block', 'top':position['top']+5, 'left':position['left']+23, 'width': width});
//   $('.largecard.' + id).hover(function(){
//     $('.largecard.' + id).css('display', 'block');
//     $(obj).find(':first-child').css('visibility', 'hidden');
//   }, function(){
//     $('.largecard.' + id).css('display', 'none');
//     $(obj).css('visibility', 'visibile')
//   });
// }, function(){
//   var id = $(this).find(':first-child').attr('data-id');
//   $('.largecard.' + id).css('display', 'none');
//   console.log('.largecard ' + id);
//   $(this).find(':first-child').css('visibility', 'visible');
// });


window.navSlider = $('#slider').slideReveal({
  trigger: $("#trigger"),
  push: false,
  width: 300,
  zIndex: 100,
  autoEscape: true,

});


          });
