
$(function () {
    $('#loading').hide()
    $(document)
	.ajaxStart(function() {
	    $('#loading').show();
	})
	.ajaxStop(function() {
	    $('#loading').hide();
	});
    refreshPartial();
});


// calls action refreshing the partial
function refreshPartial() {
    $('.instance_actions').load('/control_panel/instance_actions');
    setTimeout(refreshPartial, 10000);
}

