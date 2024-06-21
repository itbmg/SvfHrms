function ajaxInlinePopup(id, url, autoFocusField) {


    if (id == "AddWizard2_0") {

        container = document.getElementById('shadowedBox');

        if (document.getElementById('titlePopupHeader')) {
            document.getElementById('titlePopupHeader').innerHTML = '';
        }

        if (!container) {
            alert('Container not found. Please wait for the page to load');
        }

        leftPx = 220 + (document.body.scrollLeft || document.documentElement.scrollLeft);
        topPx = 200 + (document.body.scrollTop || document.documentElement.scrollTop);
        container.style.left = leftPx + 'px';
        container.style.top = topPx + 'px';
        container.style.zIndex = 100;
        container.style.direction = "ltr";



        if (document.getElementById("headerDiv")) {
            $("#shadowedBox").draggable({ cursor: "move", handle: "#headerDiv", containment: "document" });
        }

        try {
            $("#shadowedBox").fadeIn('slow');
        } catch (e) {
            container.style.display = "inline";
        }

    }


}


function closeInlinePopup(id) {
    showSeeThroughElements();


    if (id == "shadowedBox") {

        try {
            $("#shadowedBox").fadeOut();
            $("#shadowedBox").draggable("destroy");
            $("#titlePopupHeader").html("");

            $('#save_qstn_btn').css('display', 'block');
            $('.createQAddAnother').html('<span></span>Save & Add Another');

        } catch (e) {
        }

        if (document.getElementById("shadowedBox").onclose) {
            document.getElementById("shadowedBox").onclose();
        }
    }

}

function showSeeThroughElements() {
    changeSeeThroughElementsDisplay("");
}

function hideSeeThroughElements() {
    changeSeeThroughElementsDisplay("none");
}

function changeSeeThroughElementsDisplay(display) {
    //add more elements that need to be hidden / shown here
    changeDisplayForElements("select", display);
    changeDisplayForElements("object", display);
}

function changeDisplayForElements(type, display) {
    var elements = document.getElementsByTagName(type);

    for (var i = 0; i < elements.length; i++) {
        var ele = elements[i];
        try {
            ele.style.display = display;
        } catch (e) {
            //eat it
        }
    }
}


function showDiv(divID) {
    obj = document.getElementById(divID);
    if (obj) {
        obj.style.display = "block";
    }
}
function hideDiv(divID) {
    obj = document.getElementById(divID);
    if (obj) {
        obj.style.display = "none";
    }
}


