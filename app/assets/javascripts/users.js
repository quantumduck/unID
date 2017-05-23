var signupForm = $("<div></div>");
$(document).ready(function(){
  $("#login_link").on('click', function(e){
    e.preventDefault();
    $("#signUpLayout").fadeIn();
  });
  // The fade in form should work for ALL forms!
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
        console.log(data.errors);
      } else {
        var message = $('<p>' + data.message + '<br></p>');
        $('.fadeInForm').append(message);
      }

    }).fail(function (error){

    }).always(function () {
      console.log("done");
    });
    console.log($(this));
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
  
}
