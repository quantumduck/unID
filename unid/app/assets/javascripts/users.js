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
        $("#signUpLayout").fadeOut();
        setTimeout(function () {
          $('.fadeInForm form').each(function() { this.reset(); });
          $('.fadeInForm .actions input').removeAttr('disabled');
        }, 500)
        console.log(data);
      }

    }).fail(function (error){

    }).always(function () {
      console.log("done");
    });
    console.log($(this));
  });
});
