
$(document).ready(function () {
    $(document)
	.ajaxStart(function() {
	    $('#refresh').attr("src", "/assets/refresh.gif");
	    $('#refresh_instances').off('click')
	})
	.ajaxStop(function() {
	    $('#refresh').attr("src", "/assets/refresh.png");
	    $('#refresh_instances').on('click', refreshPartial);
	    fire_it_up();
	});
    refreshDatPartial();

    $('#refresh_instances').click(refreshPartial);
    fire_it_up();
});



function fire_it_up() {
    cloudAction("start");
    cloudAction("stop");
    cloudAction("reboot");
}


function cloudAction(action) {
    $("[id^=" + action + "-]").click(function () {
	var id = $(this).data("id");
	var url = "clouds/" + id + "/" + action;
	$.ajax({
	    url: url,
	    type: 'PUT'
	});
	setTimeout(refreshPartial, 1000);
    });
}

function refreshPartial() {
    $('.instance_actions').load('/control_panel/refresh');
}


// calls action refreshing the partial
function refreshDatPartial() {
    refreshPartial();
    setTimeout(refreshDatPartial, 60000);
}

