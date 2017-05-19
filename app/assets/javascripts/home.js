
$(document).ready(function(){

  $("#log").on('click', function(e){
    e.preventDefault();
    $("#logInDiv").fadeToggle();
  });
  $("#sign").on('click', function (e){
    e.preventDefault();
    $("#signUpDiv").fadeToggle();
  });
  // $("#forgot").on('click', function(e){
  //   e.preventDefault();
  //   $("#forgotPasswordDiv").fadeToggle();
  // });
    $.ajax({
      url: $(this).attr('action'),
      method: $(this).attr('method'),
      dataType: "text",
      data: $(this).serialize()
    });
});
