
var cloud = $('#instance_actions').attr("data-cloud");
var URL = 'instance_actions/' + cloud;

$(document).ready(function () {
    // will call refreshPartial every 10 seconds
    setInterval(refreshPartial, 1000)

});

// calls action refreshing the partial
function refreshPartial() {
  $.ajax({
    url: URL
 });
}
