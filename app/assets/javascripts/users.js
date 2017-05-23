var signupForm = $("<div></div>");
$(document).ready(function(){
  $("#login_link").on('click', function(e){
    e.preventDefault();
    $("#signUpLayout").fadeIn();
  });
  // The fade in form should work for ALL forms!

});

function JSFlash(message) {
  $('#flash_box').append('<p class="flash_message"' + data.message + '</p>');
  $('#flash_box').fadeIn();
}
