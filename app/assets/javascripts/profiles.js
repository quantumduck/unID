$(document).ready(function(){
  $("a#otherButton").on('click', function(e){
    // console.log(e);
    e.stopPropagation();
    e.preventDefault();
    $("#otherWindow").fadeIn();
  });
});

$("#card-form-go-back a").on('click', function(e){
  e.stopPropagation();
  e.preventDefault();
  $("#otherWindow").fadeOut();
  setTimeout(function () {
    $('#otherWindow form').each(function() { this.reset(); });
    $('#otherWindow .actions input').removeAttr('disabled');
  }, 500);
})


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
