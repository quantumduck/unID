$(document).ready(function(){
  $("#signup_link").on('click', function(e){
    e.preventDefault();
    $("#signUpLayout").fadeIn();
  });

  $("#login_link").on('click', function(e){
    e.preventDefault();
    $("#logInLayout").fadeIn();
  });

  // The fade in form should work for ALL forms!

});
