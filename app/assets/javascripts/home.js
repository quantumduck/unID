$(document).ready(function(){
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
  // $("#forgot").on('click', function(e){
  //   e.preventDefault();
  //   $("#forgotPasswordDiv").fadeToggle();
  // });
    // $.ajax({
    //   url: $(this).attr('action'),
    //   method: $(this).attr('method'),
    //   dataType: "text",
    //   data: $(this).serialize()
    // });


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
        $('.fadeInForm .actions input').removeAttr('disabled');
        alert('Error: \n\n' +  response.errors.join('\n'));
      } else {
        console.log($(this).parent());
        $('.fadeInForm').fadeOut();
        setTimeout(function () {
          $('.fadeInForm form').each(function() { this.reset(); });
          $('.fadeInForm .actions input').removeAttr('disabled');
        }, 500);
        if (response.redirect) {
          window.location.href = response.redirect
        }
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

});


function JSFlash(message) {
  $('#flash_box').append('<p class="flash_message"' + message + '</p>');
  $('#flash_box').fadeIn();
}
