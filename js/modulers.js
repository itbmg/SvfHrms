function callHandler(d, s, e) {
    $.ajax({
        url: 'EmployeeManagementHandler.axd',
        data: d,
        type: 'GET',
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: true,
        success: s,
        error: e
    });
}
//function CallHandlerUsingJson(d, s, e) {
//    $.ajax({
//        type: "GET",
//        url: "EmployeeManagementHandler.axd?json=",
//        dataType: "json",
//        contentType: "application/json; charset=utf-8",
//        data: JSON.stringify(d),
//        async: true,
//        cache: true,
//        success: s,
//        error: e
//    });
//}
function CallHandlerUsingJson(d, s, e) {
    d = JSON.stringify(d);
//    d = d.replace(/&/g, '\uFF06');
//    d = d.replace(/#/g, '\uFF03');
//    d = d.replace(/\+/g, '\uFF0B');
    //    d = d.replace(/\=/g, '\uFF1D');
    d = encodeURIComponent(d);
    $.ajax({
        type: "GET",
        url: "EmployeeManagementHandler.axd?json=",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: d,
        async: true,
        cache: true,
        success: s,
        error: e
    });
}


$(function () {
    $(".only_no").keydown(function (event) {
        // Allow: backspace, delete, tab, escape, and enter
        if (event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 || event.keyCode == 190 ||
        // Allow: Ctrl+A
            (event.keyCode == 65 && event.ctrlKey === true) ||
        // Allow: home, end, left, right
            (event.keyCode >= 35 && event.keyCode <= 39)) {
            // let it happen, don't do anything
            return;
        }
        else {
            // Ensure that it is a number and stop the keypress
            if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
                event.preventDefault();
            }
        }
    });
});

function only_no_classjqueryinitialzer() {
    $(".only_no").keydown(function (event) {
        // Allow: backspace, delete, tab, escape, and enter
        if (event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 || event.keyCode == 190 ||
        // Allow: Ctrl+A
            (event.keyCode == 65 && event.ctrlKey === true) ||
        // Allow: home, end, left, right
            (event.keyCode >= 35 && event.keyCode <= 39)) {
            // let it happen, don't do anything
            return;
        }
        else {
            // Ensure that it is a number and stop the keypress
            if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
                event.preventDefault();
            }
        }
    });
}

function callHandler_post(d, s, e) {
    $.ajax({
        url: 'EmployeeManagementHandler.axd',
        data: d,
        type: 'POST',
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: true,
        success: s,
        error: e
    });
}
function callHandler_nojson_post(d, s, e) {
    $.ajax({
        url: 'EmployeeManagementHandler.axd',
        type: "POST",
       // dataType: "json",
        contentType: false,
        processData: false,

        data: d,
        success: s,
        error: e
    });
}
function CallHandlerUsingJson_POST(d, s, e) {
    d = JSON.stringify(d);
    //    d = d.replace(/&/g, '\uFF06');
    //    d = d.replace(/#/g, '\uFF03');
    //    d = d.replace(/\+/g, '\uFF0B');
    //    d = d.replace(/\=/g, '\uFF1D');
    d = encodeURIComponent(d);
    $.ajax({
        type: "POST",
        url: "EmployeeManagementHandler.axd",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: d,
        async: true,
        cache: true,
        success: s,
        error: e
    });
}
