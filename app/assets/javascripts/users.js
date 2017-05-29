$(document).ready(function(){



  $("#signup_link").on('click', function(e){
    e.preventDefault();
    $("#signUpLayout").fadeIn();
  });

  $("#login_link").on('click', function(e){
    e.preventDefault();
    $("#logInLayout").fadeIn();
  });

  $("#userEditLink").on('click', function(e){
    e.preventDefault();
    window.navSlider.slideReveal("hide");
    $("#userEditForm").fadeIn();
  });

  $("#forgot-password-link").on('click', function(e){
    e.preventDefault();
    $("#logInLayout").fadeOut();
    $("#resetLayout").fadeIn();
  });




  $("#userDeleteLink").on('click', function(e){
    e.preventDefault();
    $('#userEditForm').fadeOut();
    setTimeout(function () {
      $('.fadeInForm form').each(function() { this.reset(); });
      $('.fadeInForm .actions input').removeAttr('disabled');
    }, 500);
    $("#userDeleteForm").fadeIn();
  });


  // The fade in form should work for ALL forms!

});
