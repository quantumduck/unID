$(document).ready(function(){


// Login Window JS

  if ($('#flash-alert').text().trim()) {
    alert($('#flash-alert').text())
  }
  if ($('#flash-notice').text().trim()) {
    alert($('#flash-notice').text())
  }

  $("#log").on('click', function(e){
    e.preventDefault();
    $("#logInDiv").slideToggle();
  });
  $("#sign").on('click', function (e){
    e.preventDefault();
    $("#signUpDiv").slideToggle();
  });

// Signup form + email response

  $(".fadeInForm form").on('submit', function (e){
    e.preventDefault();
    $.ajax({
      url: $(this).attr('action'),
      method: $(this).attr('method'),
      dataType: "json",
      data: $(this).serialize()
    }).done(function (response){
      console.log(response)
      if (response.errors) {
        setTimeout(function () {
          $('.fadeInForm .actions input').removeAttr('disabled');
        }, 10);
        alert('Error: \n\n' +  response.errors.join('\n'));
      } else {
        if (response.redirect) {
          window.location.href = response.redirect
        } else if (response.email) {
          alert('An email was sent to ' + response.email + ' with a link to set your password.');
        }
        setTimeout(function () {
          $('.fadeInForm form').each(function() { this.reset(); });
          $('.fadeInForm .actions input').removeAttr('disabled');
        }, 500);
      }
    }).fail(function (error){
    }).always(function () {
      console.log("done");
    });
  });

  $(".form_close").on('click', function (e) {
    e.preventDefault()
    $(".fadeInForm").fadeOut();
    setTimeout(function () {
      $('.fadeInForm form').each(function() { this.reset(); });
      $('.fadeInForm .actions input').removeAttr('disabled');
    }, 500);
  });

  $('#flash_box').on('click', function() {
    $(this).fadeOut();
    $(this).html('');
  });



    $("#signup_link").on('click', function(e){
      e.preventDefault();
      $("#signUpLayout").fadeIn();
    });

    $("#login_link").on('click', function(e){
      e.preventDefault();
      $("#logInLayout").fadeIn();
    });

    $("#forgot-password-link").on('click', function(e){
      e.preventDefault();
      $("#logInLayout").fadeOut();
      $("#resetLayout").fadeIn();
    });

    $("#delete-account-link").on('click', function(e){
      e.preventDefault();
      $("#editUserForm").fadeOut();
      $("#deleteUserForm").fadeIn();
    });

    $("#delete-account-link").on('click', function(e){
      e.preventDefault();
      $('#userEditForm').fadeOut();
      $("#userDeleteForm").fadeIn();
    });


});


function JSFlash(message) {
  $('#flash_box').append('<p class="flash_message"' + message + '</p>');
  $('#flash_box').fadeIn();
}
