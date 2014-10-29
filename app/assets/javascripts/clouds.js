$(document).ready(function () {
    $(document)
        .ajaxStart(function() {
            $('#refresh_all').attr("src", "/assets/refresh.gif");
            $('#refresh_all_instances').off('click')
        })
        .ajaxStop(function() {
            $('#refresh_all').attr("src", "/assets/refresh.png");
            $('#refresh_all_instances').on('click', refresh_all);
        });

    setTimeout(cont_refresh_all, 60000);
    $('#refresh_all_instances').click(refresh_all);
});


function refresh_all() {
    $('#all_instances').load('/clouds/refresh');
}


function cont_refresh_all() {
    refresh_all();
    setTimeout(cont_refresh_all, 60000);
}
