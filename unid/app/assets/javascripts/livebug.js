$('document').ready(function() {

var headerUrl = "https://api.twitch.tv/kraken/streams/" + username;

$.ajaxSetup ({
        cache: false
    });


  $('body').append();

 $.ajax({
   url: headerUrl,
   method: 'get',
   response_type: 'jsonp',
   data: {},
   headers: {'Client-ID': 'uj53o98rasdwbhwic692sh6jmd36w5'}
 }).success( function(response) {
   console.log(response);
   if (response['stream'] == null) {
     $('#twitch_card').append("offline")
   }
   else {
     $('#twitch_card').append("LIVE")
   }
 });

});
