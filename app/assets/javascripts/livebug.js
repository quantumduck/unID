// JavaScript for displaying Twitch profile online status.

$('document').ready(function() {


if (typeof twitch != 'undefined') {

var headerUrl = "https://api.twitch.tv/kraken/streams/" + twitch_username;


$.ajaxSetup ({
        cache: false
    });

    var interval

    interval = setInterval(livebug, 120000);
    function livebug() {


  $.ajax({
    url: headerUrl,
    method: 'get',
    response_type: 'jsonp',
    data: {},
    headers: {'Client-ID': 'uj53o98rasdwbhwic692sh6jmd36w5'}
  }).success( function(response) {
    console.log(response);
    if (response['stream'] == null) {
      $('#twitch_card').html("&#9673 OFFLINE")
    }
    else {
      $('#twitch_card').html("<span style=\"color:red\">&#9673 LIVE")
    }
  }).fail( function() {
    interval = null;
  });
};

livebug();


};


});
