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

// jQuery UI sortable function:

$(function() {
  $( ".sortable" ).sortable({
     revert: true,
   });

// Toggle for login/signup forms:

  $('.dropdown-toggle').dropdown({
    revert: true,
  });

  // Login with buttons:

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


// Searchbar on left side panel:

$('.toggle_search').on('click', function(){
  if ($('#search-form').css('display')==='none') {
    $("#search-form").show("slide", {direction: "left"}, 100);
    $("#search-form").parent().addClass("is-visible");
  } else {
    $("#search-form").hide("slide", {direction: "left"}, 100);
    $("#search-form").parent().removeClass("is-visible");
  }
});

// Expanding/shrinking 'large card' view:

$('.expand').on('click', function() {
  var card = $(this).parent().parent().parent();
  var id = card.attr('data-id');
  var position = card.parent().position();
  var width = card.outerWidth();
  console.log(id);
  console.log(width);
  console.log(position);
  console.log(card);
  card.css('visibility', 'hidden');
  // $('.largecard.' + id).position() = position;
  if (window.matchMedia("(max-width: 1200px)").matches) {
    $('.largecard.' + id).css({'display':'block', 'top':position['top'], 'left':position['left']+29, 'width': width, 'height' : 83});
  } else {
    $('.largecard.' + id).css({'display':'block', 'top':position['top'], 'left':position['left']+32, 'width': width, 'height' : 83});
    }
  var content_height = $('.largecard.' + id + ' ul').height();
  console.log(content_height)
  $('.largecard.' + id).attr('id', id);
  $('.largecard.' + id).animate({height: content_height + 150}, 500);
});

$('.shrink').on('click', function(){
  var largecard = $(this).parent().parent().parent();
  var id = largecard.attr('id');
  console.log(id)
  // var height = $('.largecard.' + id).height();
  var card = $('.card.' + id);
  console.log(card);
  $('.largecard.' + id).animate({height: 100}, 500, function(){
    card.css({'visibility': 'visible'});
    $('.largecard.' + id).css('display','none');
  });
});

// Left sidebar slider:

window.navSlider = $('#slider').slideReveal({
  trigger: $("#slidetrigger"),
  push: false,
  width: 300,
  zIndex: 100,
  autoEscape: true,

});

// Dropdown Menu
var dropdown = document.querySelectorAll('.dropdown');
var dropdownArray = Array.prototype.slice.call(dropdown,0);
dropdownArray.forEach(function(el){
	var button = el.querySelector('a[data-toggle="dropdown"]'),
			menu = el.querySelector('.dropdown-menu'),
			arrow = button.querySelector('i.icon-arrow');

	button.onclick = function(event) {
		if(!menu.hasClass('show')) {
			menu.classList.add('show');
			menu.classList.remove('hide');
			arrow.classList.add('open');
			arrow.classList.remove('close');
			event.preventDefault();
		}
		else {
			menu.classList.remove('show');
			menu.classList.add('hide');
			arrow.classList.remove('open');
			arrow.classList.add('close');
			event.preventDefault();
		}
	};
})

Element.prototype.hasClass = function(className) {
    return this.className && new RegExp("(^|\\s)" + className + "(\\s|$)").test(this.className);
};

});
