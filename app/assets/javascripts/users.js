var signupForm = $("<div></div>");
$(document).ready(function(){
  $("#login_link").on('click', function(e){
    e.preventDefault();
    $("#signUpLayout").fadeIn();
  });
  $(".fadeInForm form").on('submit', function (e){
    e.preventDefault();
    $.ajax({
      url: $(this).attr('action'),
      method: $(this).attr('method'),
      dataType: "text",
      data: $(this).serialize()
    }).done(function (data){

      if (data === "error") {
        $('.fadeInForm .actions input').removeAttr('disabled');
      } else {
        var message = $('<p>Thank you for signing up!<br></p>');
        var link = $('<a></a>').html(data).attr('href', data);
        $('.fadeInForm').append(message.append(link));
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
