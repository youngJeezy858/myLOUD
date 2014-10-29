
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
    
    setTimeout(refreshDatPartial, 60000);

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
	var name = $(this).data("name");
	var url = "clouds/" + id + "/" + action;
	$.ajax({
	    url: url,
	    type: 'PUT'
	});
	setTimeout(refreshPartial, 1000);

	$('p#cloud-msgs').text(name + " was successfully " + pastTense(action));
        $('#cloud-msgs-container').show()
        setTimeout(function() {
            $('#cloud-msgs-container').fadeOut(2000);
        }, 2000);
    });
}

function refreshPartial() {
    $('.instances').load('/control_panel/refresh');
}


function refreshDatPartial() {
    refreshPartial();
    setTimeout(refreshDatPartial, 60000);
}


function pastTense(string) {
    if (string == "stop") {
	string = "stopped.";
    } else if (string == "start") {
	string = "started.";
    } else {
	string = "rebooted.";
    }
    
    return string;
}
