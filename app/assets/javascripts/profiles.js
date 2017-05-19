$(document).ready(function(){
  $("#otherButton").on('click',function(e){
    e.preventDefault();
    $("#otherWindow").fadeToggle();
  });
  $("#addOther").on('submit', function (e){
    e.preventDefault();
    $.ajax({
      url: $(this).attr('action'),
      method: $(this).attr('method'),
      dataType: "text",
      data: $(this).serialize()
    }).done(function (data){
    })
  })
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
