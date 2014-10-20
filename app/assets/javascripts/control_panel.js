
$(function () {
    // will call refreshPartial every 10 seconds
    setInterval(refreshPartial, 1000)
});

// calls action refreshing the partial
function refreshPartial() {
    $('.instance_actions').load('/control_panel/instance_actions');
}
