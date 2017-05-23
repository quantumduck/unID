$(document).ready(function(){
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
    }).done(function (data){
      if (data.errors) {
          $('.fadeInForm .actions input').removeAttr('disabled');
          $('.fadeInForm .actions button').removeAttr('disabled');
        console.log(data.errors);
      } else {
        console.log(data);
        // console.log($(this).parent());
        $('.fadeInForm').fadeOut();
        // JSFlash(data.message);
      }
    }).fail(function (error){
    }).always(function () {
      console.log("done");
    });
  });

  $(".form_close").on('click', function (e) {
    e.preventDefault()
    $("#signUpLayout").fadeOut();
    setTimeout(function () {
      $('.fadeInForm form').each(function() { this.reset(); });
      $('.fadeInForm .actions input').removeAttr('disabled');
    }, 500);
  });


});


function JSFlash(message) {
  $('#flash_box').append('<p class="flash_message"' + message + '</p>');
  $('#flash_box').fadeIn();
}
