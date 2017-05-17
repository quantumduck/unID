var signupForm = $("<div></div>");
$(document).ready(function(){
  $("#login_link").on('click', function(e){
    e.preventDefault();
    $("#signUpLayout").fadeIn();
  });
  $(".fadeInForm").on('submit', function (e){
    e.preventDefault();
    // $.ajax({
    //   url: $(this).attr('action'),
    //   method: $(this).attr('method'),
    //   dataType: "html",
    //   data: this.serialize()
    // }).done( ).fail().always(function (data){
    //   console.log(data);
    // });
  });
});
