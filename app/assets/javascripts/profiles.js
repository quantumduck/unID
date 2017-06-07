$(document).ready(function(){
  $("a#otherButton").on('click', function(e){
    // console.log(e);
    e.stopPropagation();
    e.preventDefault();
    $("#otherWindow").fadeIn();
  });

  $(".edit_profile_link").on('click', function(e){
    var card = $(this).parent().parent().parent();
    var cardForm = card.next();
    e.preventDefault();
    e.stopPropagation();
    // card.fadeOut();
    cardForm.fadeIn();
  });

// THE REALLY COMPLICATED SORTABLE SOLUTION. PLZ NO BREAK.

  $('.sortable').on('sortupdate', function (e, ui){
    var order = $('.sortable .card').map(function(){
      return $(this).attr('data-id')
    }).toArray();

    var username = $('.card').attr('data-username');
    console.log("/" + username + "/profiles/sort")
    $.ajax ({
      method: "POST",
      url: "/" + username + "/profiles/sort",
      data: "order=" + order.join("%2C")
    }).done(function(response){
      console.log(response);
    }).fail().always();
  });


});

// $("#card-form-go-back a").on('click', function(e){
//   e.stopPropagation();
//   e.preventDefault();
//   $("#otherWindow").fadeOut();
//   setTimeout(function () {
//     $('#otherWindow form').each(function() { this.reset(); });
//     $('#otherWindow .actions input').removeAttr('disabled');
//   }, 500);
// })


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
