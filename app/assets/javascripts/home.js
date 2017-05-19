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
    $.ajax({
      url: $(this).attr('action'),
      method: $(this).attr('method'),
      dataType: "text",
      data: $(this).serialize()
    });
});
