$(document).ready(function(){
  $("a#otherButton").on('click', function(e){
    console.log(e);
    e.stopPropagation();
    e.preventDefault();
    $("#otherWindow").fadeIn();
  });
  $("#addOther").on('submit', function (e){
    e.preventDefault();
    $.ajax({
      url: $(this).attr('action'),
      method: $(this).attr('method'),
      dataType: "text",
      data: $(this).serialize()
    }).done(function (data){
    });
  });
});



  // $(.profileButtons).click(function("#otherButton"){
  //
  //   $("#otherWindow").FadeIn();
  // )};
  // $(".fadeInForm form").on('submit', function (e){
  //   e.preventDefault();
  //   $.ajax({
  //     url: $(this).attr('action'),
  //     method: $(this).attr('method'),
  //     dataType: "text",
  //     data: $(this).serialize()
  //   }).done(function (data){
