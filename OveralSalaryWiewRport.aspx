<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="OveralSalaryWiewRport.aspx.cs" Inherits="OveralSalaryWiewRport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        [uib-typeahead-popup].dropdown-menu
        {
            display: block;
        }
    </style>
    <style type="text/css">
        .uib-time input
        {
            width: 50px;
        }
    </style>
    <style type="text/css">
        [uib-tooltip-popup].tooltip.top-left > .tooltip-arrow, [uib-tooltip-popup].tooltip.top-right > .tooltip-arrow, [uib-tooltip-popup].tooltip.bottom-left > .tooltip-arrow, [uib-tooltip-popup].tooltip.bottom-right > .tooltip-arrow, [uib-tooltip-popup].tooltip.left-top > .tooltip-arrow, [uib-tooltip-popup].tooltip.left-bottom > .tooltip-arrow, [uib-tooltip-popup].tooltip.right-top > .tooltip-arrow, [uib-tooltip-popup].tooltip.right-bottom > .tooltip-arrow, [uib-tooltip-html-popup].tooltip.top-left > .tooltip-arrow, [uib-tooltip-html-popup].tooltip.top-right > .tooltip-arrow, [uib-tooltip-html-popup].tooltip.bottom-left > .tooltip-arrow, [uib-tooltip-html-popup].tooltip.bottom-right > .tooltip-arrow, [uib-tooltip-html-popup].tooltip.left-top > .tooltip-arrow, [uib-tooltip-html-popup].tooltip.left-bottom > .tooltip-arrow, [uib-tooltip-html-popup].tooltip.right-top > .tooltip-arrow, [uib-tooltip-html-popup].tooltip.right-bottom > .tooltip-arrow, [uib-tooltip-template-popup].tooltip.top-left > .tooltip-arrow, [uib-tooltip-template-popup].tooltip.top-right > .tooltip-arrow, [uib-tooltip-template-popup].tooltip.bottom-left > .tooltip-arrow, [uib-tooltip-template-popup].tooltip.bottom-right > .tooltip-arrow, [uib-tooltip-template-popup].tooltip.left-top > .tooltip-arrow, [uib-tooltip-template-popup].tooltip.left-bottom > .tooltip-arrow, [uib-tooltip-template-popup].tooltip.right-top > .tooltip-arrow, [uib-tooltip-template-popup].tooltip.right-bottom > .tooltip-arrow, [uib-popover-popup].popover.top-left > .arrow, [uib-popover-popup].popover.top-right > .arrow, [uib-popover-popup].popover.bottom-left > .arrow, [uib-popover-popup].popover.bottom-right > .arrow, [uib-popover-popup].popover.left-top > .arrow, [uib-popover-popup].popover.left-bottom > .arrow, [uib-popover-popup].popover.right-top > .arrow, [uib-popover-popup].popover.right-bottom > .arrow, [uib-popover-html-popup].popover.top-left > .arrow, [uib-popover-html-popup].popover.top-right > .arrow, [uib-popover-html-popup].popover.bottom-left > .arrow, [uib-popover-html-popup].popover.bottom-right > .arrow, [uib-popover-html-popup].popover.left-top > .arrow, [uib-popover-html-popup].popover.left-bottom > .arrow, [uib-popover-html-popup].popover.right-top > .arrow, [uib-popover-html-popup].popover.right-bottom > .arrow, [uib-popover-template-popup].popover.top-left > .arrow, [uib-popover-template-popup].popover.top-right > .arrow, [uib-popover-template-popup].popover.bottom-left > .arrow, [uib-popover-template-popup].popover.bottom-right > .arrow, [uib-popover-template-popup].popover.left-top > .arrow, [uib-popover-template-popup].popover.left-bottom > .arrow, [uib-popover-template-popup].popover.right-top > .arrow, [uib-popover-template-popup].popover.right-bottom > .arrow
        {
            top: auto;
            bottom: auto;
            left: auto;
            right: auto;
            margin: 0;
        }
        [uib-popover-popup].popover, [uib-popover-html-popup].popover, [uib-popover-template-popup].popover
        {
            display: block !important;
        }
    </style>
    <style type="text/css">
        .uib-datepicker-popup.dropdown-menu
        {
            display: block;
            float: none;
            margin: 0;
        }
        .uib-button-bar
        {
            padding: 10px 9px 2px;
        }
    </style>
    <style type="text/css">
        .uib-position-measure
        {
            display: block !important;
            visibility: hidden !important;
            position: absolute !important;
            top: -9999px !important;
            left: -9999px !important;
        }
        .uib-position-scrollbar-measure
        {
            position: absolute !important;
            top: -9999px !important;
            width: 50px !important;
            height: 50px !important;
            overflow: scroll !important;
        }
        .uib-position-body-scrollbar-measure
        {
            overflow: scroll !important;
        }
    </style>
    <style type="text/css">
        .uib-datepicker .uib-title
        {
            width: 100%;
        }
        .uib-day button, .uib-month button, .uib-year button
        {
            min-width: 100%;
        }
        .uib-left, .uib-right
        {
            width: 100%;
        }
    </style>
    <style type="text/css">
        .ng-animate.item:not(.left):not(.right)
        {
            -webkit-transition: 0s ease-in-out left;
            transition: 0s ease-in-out left;
        }
    </style>
    <style type="text/css">@charset "UTF-8";[ng\:cloak],[ng-cloak],[data-ng-cloak],[x-ng-cloak],.ng-cloak,.x-ng-cloak,.ng-hide:not(.ng-hide-animate){display:none !important;}ng\:form{display:block;}.ng-animate-shim{visibility:hidden;}.ng-anchor{position:absolute;}</style>
    <title></title>
    <link rel="stylesheet" href="https://kendo.cdn.telerik.com/2018.2.516/styles/kendo.common-material.min.css" />
    <link rel="stylesheet" href="https://kendo.cdn.telerik.com/2018.2.516/styles/kendo.material.min.css" />
    <link rel="stylesheet" href="https://kendo.cdn.telerik.com/2018.2.516/styles/kendo.material.mobile.min.css" />
    <script src="https://kendo.cdn.telerik.com/2018.2.516/js/jquery.min.js"></script>
    <script src="https://kendo.cdn.telerik.com/2018.2.516/js/kendo.all.min.js"></script>
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
    </script>
    <script type="text/javascript">

        $(function () {
            $('#slct_month').click(function () {
                document.getElementById('spn_gosvdtotsal').innerHTML = "";
                document.getElementById('spn_svdstotsal').innerHTML = "";
                document.getElementById('spn_svdsPers').innerHTML = "";
                document.getElementById('spn_svdtotsal').innerHTML = "";
                document.getElementById('spn_svdPers').innerHTML = "";
                document.getElementById('spn_RMRDEtotsal').innerHTML = "";
                document.getElementById('spn_rmrdPers').innerHTML = "";

            });
        });

        function callHandler(d, s, e) {
            $.ajax({
                url: 'EmployeeManagementHandler.axd',
                data: JSON.stringify(dataToLog),
                type: 'GET',
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function CallHandlerUsingJson(d, s, e) {
            d = JSON.stringify(d);
            d = d.replace(/&/g, '\uFF06');
            d = d.replace(/#/g, '\uFF03');
            d = d.replace(/\+/g, '\uFF0B');
            d = d.replace(/\=/g, '\uFF1D');
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
        //--------seperate amount by commas-------//

        function addCommas(nStr) {
            nStr += '';
            x = nStr.split('.');
            x1 = x[0];
            x2 = x.length > 1 ? '.' + x[1] : '';
            var rgx = /(\d+)(\d{3})/;
            while (rgx.test(x1)) {
                x1 = x1.replace(rgx, '$1' + ',' + '$2');
            }
            return x1 + x2;
        }
        $(function () {
            get_govffto_report();
            get_gosvd_report();
            $("#div_gosvd").css("display", "block");
        });
        function generate_report() {
            get_govffto_report();
            get_gosvd_report();
            $("#div_gosvd").css("display", "block");
        }

        function get_govffto_report() {
            var month = document.getElementById('slct_month').value;
            var data = { 'op': 'get_govffto_report', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        govfto_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var branches = [];
        var gosvd_totgross = 0;
        function govfto_details(msg) {
            var totgross = msg[0].totgross;
            gosvd_totgross = totgross;
            var totgrosss = addCommas(msg[0].totgross);

            var totsal = '₹' + " " + " " + totgrosss + '/-'
            //            var totsal = '₹' + totgross.formatMoney(2, ',', '.');
            document.getElementById('spn_gosvdtotsal').innerHTML = totsal;
            document.getElementById('spn_gosvdtotsal2').innerHTML = totgross;
        }

        function get_gosvd_report() {
            var month = document.getElementById('slct_month').value;
            var data = { 'op': 'get_gsvdtot_report', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        svdspl_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var branches = [];
        function svdspl_details(msg) {
            for (var i = 0; i < msg.length; i++) {

                var totgross = msg[i].totgross;
                var totgrosss = addCommas(msg[i].totgross);
                var totsalar = '₹' + " " + " " + totgrosss + '/-'

                totsal = totgross / gosvd_totgross * 100;

                var sno = msg[i].sno;


                if (sno == "1") {

                    document.getElementById('spn_svdstotsal').innerHTML = totsalar;
                    document.getElementById('spn_svdstotsal2').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_svdsPers').innerHTML = percentage;
                }
                if (sno == "2") {

                    document.getElementById('spn_svdtotsal').innerHTML = totsalar;
                    document.getElementById('spn_svdtotsal2').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_svdPers').innerHTML = percentage;
                }
                if (sno == "4") {

                    document.getElementById('spn_RMRDEtotsal').innerHTML = totsalar;
                    document.getElementById('spn_RMRDEtotsal2').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_rmrdPers').innerHTML = percentage;
                }
            }
        }

        function get_gosvds_branchtype_wiserep() {
            var month = document.getElementById('slct_month').value;
            var companyid = "1";
            var data = { 'op': 'get_gosvd_branchtypewise_report', 'month': month, 'companyid': companyid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        svdscc_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var branches = [];
        var bwise_totsal = 0;
        function svdscc_details(msg) {
            for (var i = 0; i < msg.length; i++) {

                var branchtype = msg[i].branchtype;
                var totgross = msg[i].totgross;
                var totalgross = '₹' + " " + " " + totgross + '/-'
                var totamt = document.getElementById('spn_svdstotsal2').innerHTML;
                totsal = totgross / totamt * 100;

                if (branchtype == "CC") {

                    document.getElementById('spn_svdscctotsal').innerHTML = totalgross;
                    document.getElementById('spn_svdscctotsal2').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_svdsccPers').innerHTML = percentage;
                }
                if (branchtype == "Plant") {

                    document.getElementById('spn_svdsplanttotsal').innerHTML = totalgross;
                    document.getElementById('spn_svdsplanttotsal2').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_svdsplantPers').innerHTML = percentage;
                }
                if (branchtype == "SalesOffice") {

                    document.getElementById('spn_svdssalestotsal').innerHTML = totalgross;
                    document.getElementById('spn_svdssalestotsal2').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_svdssalesPers').innerHTML = percentage;
                }
            }
        }
        
        function get_svdscc_report() {
            var month = document.getElementById('slct_month').value;
            var companyid = "1";
            var btype = "CC";
            var data = { 'op': 'get_gosvd_branchwise_report', 'month': month, 'cmpid': companyid, 'btype': btype };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        gsvds_cc_branch_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var branches = [];
        function gsvds_cc_branch_details(msg) {
            for (var i = 0; i < msg.length; i++) {

                var branchname = msg[i].branchname;
                var totgross = msg[i].totgross;
                var totalgross = '₹' + " " + " " + totgross + '/-'
                var cctotamt = document.getElementById('spn_svdscctotsal2').innerHTML;
                totsal = totgross / cctotamt * 100;

                if (branchname == "Arani Cc") {

                    document.getElementById('spn_arani_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_arani_Pers').innerHTML = percentage;
                }
                if (branchname == "Walaja ") {

                    document.getElementById('spn_Walaja_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_Walaja_Pers').innerHTML = percentage;
                }
                if (branchname == "Kaveripatnam") {

                    document.getElementById('spn_kpm_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_kpm_Pers').innerHTML = percentage;
                }
                if (branchname == "Rc Puram") {

                    document.getElementById('spn_rc_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_rc_Pers').innerHTML = percentage;
                }
                if (branchname == "Tarigonda ") {

                    document.getElementById('spn_tari_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_tari_Pers').innerHTML = percentage;
                }
                if (branchname == "Kaligiri") {

                    document.getElementById('spn_Kaligiri_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_Kaligiri_Pers').innerHTML = percentage;
                }
                if (branchname == "RMRD Kuppam") {

                    document.getElementById('spn_rmrd_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_rmrd_Pers').innerHTML = percentage;
                }
            }
        }

        
        function get_svdsplant_report() {
            var month = document.getElementById('slct_month').value;
            var companyid = "1";
            var btype = "Plant";
            var data = { 'op': 'get_gosvd_branchwise_report', 'month': month, 'cmpid': companyid, 'btype': btype };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        gsvds_plant_branch_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var branches = [];
        function gsvds_plant_branch_details(msg) {
            for (var i = 0; i < msg.length; i++) {

                var branchname = msg[i].branchname;
                var totgross = msg[i].totgross;
                var totalgross = '₹' + " " + " " + totgross + '/-'
                var planttotamt = document.getElementById('spn_svdsplanttotsal2').innerHTML;

                totsal = totgross / planttotamt * 100;

                if (branchname == "Punabaka") {

                    document.getElementById('spn_punabaka_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_punabaka_Pers').innerHTML = percentage;
                }
                if (branchname == "Kuppam") {

                    document.getElementById('spn_Kuppam_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_Kuppam_Pers').innerHTML = percentage;
                }
            }
        }

        
        function get_svdssales_report() {
            var month = document.getElementById('slct_month').value;
            var companyid = "1";
            var btype = "SalesOffice";
            var data = { 'op': 'get_gosvd_branchwise_report', 'month': month, 'cmpid': companyid, 'btype': btype };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        gsvds_sales_branch_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var branches = [];
        function gsvds_sales_branch_details(msg) {
            for (var i = 0; i < msg.length; i++) {

                var branchname = msg[i].branchname;
                var totgross = msg[i].totgross;
                var totalgross = '₹' + " " + " " + totgross + '/-'
                var salestotamt = document.getElementById('spn_svdssalestotsal2').innerHTML;
                totsal = totgross / salestotamt * 100;

                if (branchname == "Chennai ") {

                    document.getElementById('spn_chn_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_chn_Pers').innerHTML = percentage;
                }
                if (branchname == "Bangalore") {

                    document.getElementById('spn_bng_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_bng_Pers').innerHTML = percentage;
                }
                if (branchname == "Kanchipuram ") {

                    document.getElementById('spn_kanchi_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_kanchi_Pers').innerHTML = percentage;
                }
                if (branchname == "Nellore ") {

                    document.getElementById('spn_nlr_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_nlr_Pers').innerHTML = percentage;
                }
                if (branchname == "Madanapalli") {

                    document.getElementById('spn_mndpl_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_mndpl_Pers').innerHTML = percentage;
                }
                if (branchname == "Tirupathi") {

                    document.getElementById('spn_tpt_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_tpt_Pers').innerHTML = percentage;
                }
                if (branchname == "Chennai Marketing Office") {

                    document.getElementById('spn_cmo_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_cmo_Pers').innerHTML = percentage;
                }
                if (branchname == "Skht Parlore") {

                    document.getElementById('spn_skht_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_skht_Pers').innerHTML = percentage;
                }
            }
        }

        
        function get_gosvd_branchtype_wiserep() {
            var month = document.getElementById('slct_month').value;
            var companyid = "2";
            var data = { 'op': 'get_gosvd_branchtypewise_report', 'month': month, 'companyid': companyid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        svdcc_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var branches = [];
        var bwise_totsal = 0;
        function svdcc_details(msg) {
            for (var i = 0; i < msg.length; i++) {

                var branchtype = msg[i].branchtype;
                var totgross = msg[i].totgross;
                var totamt = document.getElementById('spn_svdtotsal2').innerHTML;
                totsal = totgross / totamt * 100;
                var totalgross = '₹' + " " + " " + totgross + '/-'
                if (branchtype == "CC") {

                    document.getElementById('spn_svdcctotsal').innerHTML = totalgross;
                    document.getElementById('spn_svdcctotsal2').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_svdccPers').innerHTML = percentage;
                }
            }
        }

        

        function get_svdcc_report() {
            var month = document.getElementById('slct_month').value;
            var companyid = "2";
            var btype = "CC";
            var data = { 'op': 'get_gosvd_branchwise_report', 'month': month, 'cmpid': companyid, 'btype': btype };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        gsvd_cc_branch_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var branches = [];
        function gsvd_cc_branch_details(msg) {
            for (var i = 0; i < msg.length; i++) {

                var branchname = msg[i].branchname;
                var totgross = msg[i].totgross;
                var cctotamt = document.getElementById('spn_svdcctotsal2').innerHTML;
                totsal = totgross / cctotamt * 100;

                if (branchname == "Kavali Office") {

                    document.getElementById('spn_kavalicc_totsal').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_kavalicc_Pers').innerHTML = percentage;
                }
                if (branchname == "Kondepi") {

                    document.getElementById('spn_Kondepi_totsal').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_Kondepi_Pers').innerHTML = percentage;
                }
                if (branchname == "Kavali Plant") {

                    document.getElementById('spn_Kavaliplnt_totsal').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_Kavaliplnt_Pers').innerHTML = percentage;
                }
                if (branchname == "Gudluru") {

                    document.getElementById('spn_Gudluru_totsal').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_Gudluru_Pers').innerHTML = percentage;
                }
                if (branchname == "Gudipallipadu") {

                    document.getElementById('spn_gdpl_totsal').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_gdpl_Pers').innerHTML = percentage;
                }
                if (branchname == "C.S.Puram") {

                    document.getElementById('spn_csp_totsal').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_csp_Pers').innerHTML = percentage;
                }
            }
        }

        

        function get_rmrde_report() {
            var month = document.getElementById('slct_month').value;
            var companyid = "4";
            var btype = "Plant";
            var data = { 'op': 'get_gosvd_branchwise_report', 'month': month, 'cmpid': companyid, 'btype': btype };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        rmr_plant_branch_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var branches = [];
        function rmr_plant_branch_details(msg) {
            for (var i = 0; i < msg.length; i++) {

                var branchname = msg[i].branchname;
                var totgross = msg[i].totgross;
                var rmrtotamt = document.getElementById('spn_RMRDEtotsal2').innerHTML;
                totsal = totgross / rmrtotamt * 100;
                var totalgross = '₹' + " " + " " + totgross + '/-'
                if (branchname == "Ramdev") {

                    document.getElementById('spn_rmrplant_totsal').innerHTML = totalgross;
                    document.getElementById('spn_rmrplant_totsal2').innerHTML = totgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_rmrplant_Pers').innerHTML = percentage;
                }
            }
        }

       

        function get_rmdrplant_report() {
            var month = document.getElementById('slct_month').value;
            var companyid = "4";
            var btype = "Plant";
            var data = { 'op': 'get_gosvd_branchwise_report', 'month': month, 'cmpid': companyid, 'btype': btype };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        rmr_branch_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var branches = [];
        function rmr_branch_details(msg) {
            for (var i = 0; i < msg.length; i++) {

                var branchname = msg[i].branchname;
                var totgross = msg[i].totgross;
                var totalgross = '₹' + " " + " " + totgross + '/-'
                var rmrtotamt = document.getElementById('spn_rmrplant_totsal2').innerHTML;

                totsal = totgross / rmrtotamt * 100;

                if (branchname == "Ramdev") {

                    document.getElementById('spn_rmrdplant_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_rmrdplant_Pers').innerHTML = percentage;
                }
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
       <%-- <h1>
            Overal Report<small>Report</small>
        </h1>--%>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard" ></i>Reports</a></li>
            <li><a href="#">Overal payment report</a></li>
        </ol>
    </section>
    <div id="div_employesatusdetails">
        <div class="box-header with-border">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i>Overal payment report
            </h3>
        </div>
        <div class='divcontainer' style="overflow: auto;">
            <div class='divcontainer' style="overflow: auto;">
                <table id="Table1" align="center">
                    <tr>
                        <td>
                            <label class="control-label">
                                Month</label>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <select id="slct_month" class="form-control" style="width: 100%;">
                                <%--<option selected disabled value="00">Select Month</option>--%>
                                <option value="01">January</option>
                                <option value="02">Febravary</option>
                                <option value="03">March</option>
                                <option selected value="04">April</option>
                                <option value="05">May</option>
                                <option value="06">June</option>
                                <option value="07">July</option>
                                <option value="08">Auguest</option>
                                <option value="09">September</option>
                                <option value="10">october</option>
                                <option value="11">November</option>
                                <option value="12">December</option>
                            </select>
                        </td>
                        <td>
                            &nbsp; &nbsp;
                        </td>
                        <td style="height: 40px;">
                            <input id="Button1" type="button" class="btn btn-primary" name="submit" title="Click Here To Generate!"
                                value="Generate" onclick="generate_report();">
                        </td>
                    </tr>
                </table>
            </div>

            <div id="div_gosvd" style="display: none;">
                <div class="demo-section k-content">
                    <ul id="treeview">
                        <%-- //-------------------Group Of Vyshnavi Dairy----------------//   --%>
                        <li data-expanded="true" class="k-item k-first k-last" role="treeitem" data-uid="adb6c08e-c934-4ee1-9a70-bc22697b8d0d"
                            aria-selected="false" style="border: 1px; width: 80%;">
                            <div class="k-top k-bot">
                                <span class="k-icon k-i-collapse"></span><span class="k-in"><span class="k-sprite folder">
                                </span><span class="k-in" style="border: 1px solid; background: aliceblue;"><span
                                    class="k-sprite folder"></span>Group Of Vyshnavi Dairy &nbsp; <span id="spn_gosvdtotsal"
                                        style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                        font-size: 14px; position: relative; height: 26px; line-height: 21px;"></span>
                                    <span id="spn_gosvdtotsal2" style="display: none;"></span>&nbsp; <span style="background-color: rgb(68, 128, 226);
                                        color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                        height: 26px; line-height: 21px;">100% </span></span></span>
                            </div>
                            <ul class="k-group">
                                <%-- //-------------------SVDS----------------//   --%>
                                <li class="k-item" role="treeitem" data-uid="d637e460-3d61-4ca2-9a48-1caa4b71ae77"
                                    aria-selected="false" aria-expanded="false" id="treeview_tv_active" style="border: 1px;
                                    width: 80%;">
                                    <div class="k-top">
                                        <span class="k-icon k-i-expand" onclick="get_gosvds_branchtype_wiserep();"></span>
                                        <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                            background: aliceblue;"><span class="k-sprite folder"></span>SVDS &nbsp; <span id="spn_svdstotsal"
                                                style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                font-size: 14px; position: relative; height: 26px; line-height: 21px;"></span>
                                            <span id="spn_svdstotsal2" style="display: none;"></span>&nbsp; <span id="spn_svdsPers"
                                                style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                font-size: 14px; position: relative; height: 26px; line-height: 21px;"></span>
                                        </span></span>
                                    </div>
                                    <ul class="k-group" style="overflow: visible; display: none; height: 0px;">
                                        <li class="k-item" role="treeitem" data-uid="e81addf7-e873-48de-8efd-d2543fc43c3d"
                                            aria-selected="false" aria-expanded="false" id="Li1" style="border: 1px; width: 60%;">
                                            <div class="k-top">
                                                <span onclick="get_svdscc_report();" class="k-icon k-i-expand"></span><span class="k-in">
                                                    <span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                        background: aliceblue;"><span class="k-sprite folder"></span>CC &nbsp; <span id="spn_svdscctotsal"
                                                            style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;"></span>
                                                        <span id="spn_svdscctotsal2" style="display: none;"></span>&nbsp; <span id="spn_svdsccPers"
                                                            style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;"></span>
                                                    </span></span>
                                            </div>
                                            <%--//-------------plant wise list under CC----------------//--%>
                                            <ul class="k-group" style="height: 0px; overflow: visible; display: none;">
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Arani Cc &nbsp; <span
                                                                        id="spn_arani_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_arani_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">100% </span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Walaja &nbsp; <span
                                                                        id="spn_Walaja_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_Walaja_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">% </span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Kaveri Patnam &nbsp;
                                                                    <span id="spn_kpm_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_kpm_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">% </span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Rc Puram &nbsp; <span
                                                                        id="spn_rc_totsal" style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px;
                                                                        border-radius: 5px; font-size: 14px; position: relative; height: 26px; line-height: 21px;">
                                                                    </span>&nbsp; <span id="spn_rc_Pers" style="background-color: rgb(68, 128, 226);
                                                                        color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                        height: 26px; line-height: 21px;">% </span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Tarigonda &nbsp; <span
                                                                        id="spn_tari_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_tari_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">% </span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Kaligiri &nbsp; <span
                                                                        id="spn_Kaligiri_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;">RS </span>&nbsp; <span id="spn_Kaligiri_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">% </span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>RMRD Kuppam &nbsp;
                                                                    <span id="spn_rmrd_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;">RS </span>&nbsp; <span id="spn_rmrd_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">% </span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                            </ul>
                                            <%--//-----------------------//--%>
                                        </li>
                                        <li class="k-item" role="treeitem" data-uid="e81addf7-e873-48de-8efd-d2543fc43c3d"
                                            aria-selected="false" aria-expanded="false" id="Li2" style="border: 1px; width: 60%;">
                                            <div class="k-top">
                                                <span class="k-icon k-i-expand" onclick="get_svdsplant_report();"></span><span class="k-in">
                                                    <span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                        background: aliceblue;"><span class="k-sprite folder"></span>Plant &nbsp; <span id="spn_svdsplanttotsal"
                                                            style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;"></span>
                                                        <span id="spn_svdsplanttotsal2" style="display: none;"></span>&nbsp; <span id="spn_svdsplantPers"
                                                            style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;">% </span>
                                                    </span></span>
                                            </div>
                                            <%--//-------------plant wise list under Plant----------------//--%>
                                            <ul class="k-group" style="height: 0px; overflow: visible; display: none;">
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Punabaka &nbsp; <span
                                                                        id="spn_punabaka_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_punabaka_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Kuppam &nbsp; <span
                                                                        id="spn_Kuppam_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_Kuppam_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                            </ul>
                                            <%--//--------------------//--%>
                                        </li>
                                        <li class="k-item" role="treeitem" data-uid="e81addf7-e873-48de-8efd-d2543fc43c3d"
                                            aria-selected="false" aria-expanded="false" id="Li3" style="border: 1px; width: 60%;">
                                            <div class="k-top">
                                                <span class="k-icon k-i-expand" onclick="get_svdssales_report();"></span><span class="k-in">
                                                    <span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                        background: aliceblue;"><span class="k-sprite folder"></span>Sales Office &nbsp;
                                                        <span id="spn_svdssalestotsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                            padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                            line-height: 21px;"></span><span id="spn_svdssalestotsal2" style="display: none;">
                                                        </span>&nbsp; <span id="spn_svdssalesPers" style="background-color: rgb(68, 128, 226);
                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                            height: 26px; line-height: 21px;"></span></span></span>
                                            </div>
                                            <%--//-------------plant wise list under Sales Office----------------//--%>
                                            <ul class="k-group" style="height: 0px; overflow: visible; display: none;">
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Chennai &nbsp; <span
                                                                        id="spn_chn_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_chn_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Benguluru &nbsp; <span
                                                                        id="spn_bng_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_bng_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Kanchi Puram &nbsp;
                                                                    <span id="spn_kanchi_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_kanchi_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Nellore &nbsp; <span
                                                                        id="spn_nlr_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_nlr_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>MadanaPalli &nbsp;
                                                                    <span id="spn_mndpl_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_mndpl_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Tirupathi &nbsp; <span
                                                                        id="spn_tpt_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_tpt_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Chennai Marketing Office
                                                                    &nbsp; <span id="spn_cmo_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_cmo_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Skht Parlore &nbsp;
                                                                    <span id="spn_skht_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;">40000 </span>&nbsp; <span id="spn_skht_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">100% </span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                            </ul>
                                            <%----------------------------%>
                                        </li>
                                    </ul>
                                </li>
                                <%-- //-------------------SVD----------------//   --%>
                                <li class="k-item" role="treeitem" data-uid="d637e460-3d61-4ca2-9a48-1caa4b71ae77"
                                    aria-selected="false" aria-expanded="false" id="Li4" style="border: 1px; width: 80%;">
                                    <div class="k-top">
                                        <span class="k-icon k-i-expand" onclick="get_gosvd_branchtype_wiserep();"></span>
                                        <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                            background: aliceblue;"><span class="k-sprite folder"></span>SVD &nbsp; <span id="spn_svdtotsal"
                                                style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                font-size: 14px; position: relative; height: 26px; line-height: 21px;"></span>
                                            <span id="spn_svdtotsal2" style="display: none;"></span>&nbsp; <span id="spn_svdPers"
                                                style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                font-size: 14px; position: relative; height: 26px; line-height: 21px;"></span>
                                        </span></span>
                                    </div>
                                    <ul class="k-group" style="overflow: visible; display: none; height: 0px;">
                                        <li class="k-item" role="treeitem" data-uid="e81addf7-e873-48de-8efd-d2543fc43c3d"
                                            aria-selected="false" aria-expanded="false" id="Li5" style="border: 1px; width: 60%;">
                                            <div class="k-top">
                                                <span class="k-icon k-i-expand" onclick="get_svdcc_report();"></span><span class="k-in">
                                                    <span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                        background: aliceblue;"><span class="k-sprite folder"></span>CC &nbsp; <span id="spn_svdcctotsal"
                                                            style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;"></span><span id="spn_svdcctotsal2" style="display: none;">
                                                        &nbsp; <span id="spn_svdccPers" style="background-color: rgb(68, 128, 226); color: #fff;
                                                            padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                            line-height: 21px;"></span></span></span>
                                            </div>
                                            <ul class="k-group" style="height: 0px; overflow: visible; display: none;">
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Kavali Office &nbsp;
                                                                    <span id="spn_kavalicc_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_kavalicc_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Kondepi &nbsp; <span
                                                                        id="spn_Kondepi_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_Kondepi_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Kavali Plant &nbsp;
                                                                    <span id="spn_Kavaliplnt_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_Kavaliplnt_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Gudluru &nbsp; <span
                                                                        id="spn_Gudluru_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_Gudluru_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Gudipallipadu &nbsp;
                                                                    <span id="spn_gdpl_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_gdpl_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>C.S.Puram &nbsp; <span
                                                                        id="spn_csp_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_csp_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                            </ul>
                                        </li>
                                        <%--<li class="k-item" role="treeitem" data-uid="e81addf7-e873-48de-8efd-d2543fc43c3d"
                                        aria-selected="false" aria-expanded="false" id="Li6" style="border: 1px; width: 60%;">
                                        <div class="k-top">
                                            <span class="k-icon k-i-expand"></span><span class="k-in"><span class="k-sprite folder">
                                            </span><span class="k-in" style="border: 1px solid; background: aliceblue;"><span
                                                class="k-sprite folder"></span>Plant &nbsp; <span style="background-color: rgb(68, 128, 226);
                                                    color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                    height: 26px; line-height: 21px;">40000 </span>&nbsp; <span style="background-color: rgb(68, 128, 226);
                                                        color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                        height: 26px; line-height: 21px;">100% </span></span></span>
                                        </div>
                                        <ul class="k-group" style="height: 0px; overflow: visible; display: none;">
                                            <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                aria-selected="false">
                                                <div class="k-top">
                                                    <span class="k-in">
                                                        <div class="k-top">
                                                            <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                background: aliceblue;"><span class="k-sprite folder"></span>Walaja &nbsp; <span
                                                                    style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                                    font-size: 14px; position: relative; height: 26px; line-height: 21px;">40000
                                                                </span>&nbsp; <span style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px;
                                                                    border-radius: 5px; font-size: 14px; position: relative; height: 26px; line-height: 21px;">
                                                                    100% </span></span></span>
                                                        </div>
                                                    </span>
                                                </div>
                                            </li>
                                            <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                aria-selected="false">
                                                <div class="k-top">
                                                    <span class="k-in">
                                                        <div class="k-top">
                                                            <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                background: aliceblue;"><span class="k-sprite folder"></span>Arani &nbsp; <span style="background-color: rgb(68, 128, 226);
                                                                    color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                    height: 26px; line-height: 21px;">40000 </span>&nbsp; <span style="background-color: rgb(68, 128, 226);
                                                                        color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                        height: 26px; line-height: 21px;">100% </span></span></span>
                                                        </div>
                                                    </span>
                                                </div>
                                            </li>
                                        </ul>
                                    </li>--%>
                                        <%--<li class="k-item" role="treeitem" data-uid="e81addf7-e873-48de-8efd-d2543fc43c3d"
                                        aria-selected="false" aria-expanded="false" id="Li7" style="border: 1px; width: 60%;">
                                        <div class="k-top">
                                            <span class="k-icon k-i-expand"></span><span class="k-in"><span class="k-sprite folder">
                                            </span><span class="k-in" style="border: 1px solid; background: aliceblue;"><span
                                                class="k-sprite folder"></span>Sales Office &nbsp; <span style="background-color: rgb(68, 128, 226);
                                                    color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                    height: 26px; line-height: 21px;">40000 </span>&nbsp; <span style="background-color: rgb(68, 128, 226);
                                                        color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                        height: 26px; line-height: 21px;">100% </span></span></span>
                                        </div>
                                        <ul class="k-group" style="height: 0px; overflow: visible; display: none;">
                                            <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                aria-selected="false">
                                                <div class="k-top">
                                                    <span class="k-in">
                                                        <div class="k-top">
                                                            <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                background: aliceblue;"><span class="k-sprite folder"></span>Walaja &nbsp; <span
                                                                    style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                                    font-size: 14px; position: relative; height: 26px; line-height: 21px;">40000
                                                                </span>&nbsp; <span style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px;
                                                                    border-radius: 5px; font-size: 14px; position: relative; height: 26px; line-height: 21px;">
                                                                    100% </span></span></span>
                                                        </div>
                                                    </span>
                                                </div>
                                            </li>
                                            <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                aria-selected="false">
                                                <div class="k-top">
                                                    <span class="k-in">
                                                        <div class="k-top">
                                                            <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                background: aliceblue;"><span class="k-sprite folder"></span>Arani &nbsp; <span style="background-color: rgb(68, 128, 226);
                                                                    color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                    height: 26px; line-height: 21px;">40000 </span>&nbsp; <span style="background-color: rgb(68, 128, 226);
                                                                        color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                        height: 26px; line-height: 21px;">100% </span></span></span>
                                                        </div>
                                                    </span>
                                                </div>
                                            </li>
                                        </ul>
                                    </li>--%>
                                    </ul>
                                </li>
                                <%-- //-------------------SVf----------------//   --%>
                                <li class="k-item" role="treeitem" data-uid="d637e460-3d61-4ca2-9a48-1caa4b71ae77"
                                    aria-selected="false" aria-expanded="false" id="Li8" style="border: 1px; width: 80%;">
                                    <div class="k-top">
                                        <span class="k-icon k-i-expand"></span><span class="k-in"><span class="k-sprite folder">
                                        </span><span class="k-in" style="border: 1px solid; background: aliceblue;"><span
                                            class="k-sprite folder"></span>SVF &nbsp; <span style="background-color: rgb(68, 128, 226);
                                                color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                height: 26px; line-height: 21px;">₹ 0/- </span>&nbsp; <span style="background-color: rgb(68, 128, 226);
                                                    color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                    height: 26px; line-height: 21px;">0% </span></span></span>
                                    </div>
                                    <ul class="k-group" style="overflow: visible; display: none; height: 0px;">
                                        <li class="k-item" role="treeitem" data-uid="78d15c6f-2bf5-4f17-b870-e3721b0c73ff"
                                            aria-selected="false">
                                            <div class="k-mid">
                                                <span class="k-in" style="color: red;"><span class="k-sprite html"></span>NO Data Found</span>
                                        </li>
                                    </ul>
                                </li>
                                <%-- //-------------------RMRDE----------------//   --%>
                                <li class="k-item" role="treeitem" data-uid="d637e460-3d61-4ca2-9a48-1caa4b71ae77"
                                    aria-selected="false" aria-expanded="false" id="Li12" style="border: 1px; width: 80%;">
                                    <div class="k-top">
                                        <span class="k-icon k-i-expand" onclick="get_rmrde_report();"></span><span class="k-in">
                                            <span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                background: aliceblue;"><span class="k-sprite folder"></span>Ramdev &nbsp; <span
                                                    id="spn_RMRDEtotsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                    padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                    line-height: 21px;"></span><span id="spn_RMRDEtotsal2" style="display: none;">
                                                </span>&nbsp; <span id="spn_rmrdPers" style="background-color: rgb(68, 128, 226);
                                                    color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                    height: 26px; line-height: 21px;"></span></span></span>
                                    </div>
                                    <ul class="k-group" style="overflow: visible; display: none; height: 0px;">
                                        <li class="k-item" role="treeitem" data-uid="e81addf7-e873-48de-8efd-d2543fc43c3d"
                                            aria-selected="false" aria-expanded="false" id="Li14" style="border: 1px; width: 60%;">
                                            <div class="k-top">
                                                <span class="k-icon k-i-expand" onclick="get_rmdrplant_report();"></span><span class="k-in">
                                                    <span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                        background: aliceblue;"><span class="k-sprite folder"></span>Plant &nbsp; <span id="spn_rmrplant_totsal"
                                                            style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;"></span>
                                                        <span id="spn_rmrplant_totsal2" style="display: none;"></span>&nbsp; <span id="spn_rmrplant_Pers"
                                                            style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;"></span>
                                                    </span></span>
                                            </div>
                                            <ul class="k-group" style="height: 0px; overflow: visible; display: none;">
                                                <li class="k-item" role="treeitem" data-uid="f125c077-35fc-4778-a997-b5657c9c7967"
                                                    aria-selected="false">
                                                    <div class="k-top">
                                                        <span class="k-in">
                                                            <div class="k-top">
                                                                <span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Ramdev &nbsp; <span
                                                                        id="spn_rmrdplant_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;"></span>&nbsp; <span id="spn_rmrdplant_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;"></span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                            </ul>
                                        </li>
                                    </ul>
                                </li>
                                <%-- <li class="k-item" role="treeitem" data-uid="dffc15a3-5d8d-4af2-9abc-8e8baaebcaf4" aria-selected="false"><div class="k-mid"><span class="k-in"><span class="k-sprite html"></span>about.html</span></div></li>
                            <li class="k-item" role="treeitem" data-uid="78d15c6f-2bf5-4f17-b870-e3721b0c73ff" aria-selected="false"><div class="k-mid"><span class="k-in"><span class="k-sprite html"></span>contacts.html</span></div></li>
                            <li class="k-item" role="treeitem" data-uid="222c3338-d6e9-4e9a-b2aa-39a2ad727357" aria-selected="false"><div class="k-mid"><span class="k-in"><span class="k-sprite html"></span>index.html</span></div></li>
                            <li class="k-item k-last" role="treeitem" data-uid="4345a094-ea7b-4358-adfe-727dfbb09606" aria-selected="false"><div class="k-bot"><span class="k-in"><span class="k-sprite html"></span>portfolio.html</span></div></li>--%>
                            </ul>
                        </li>
                    </ul>
                </div>
                <script>
                    $(document).ready(function () {
                        $("#treeview").kendoTreeView();
                    });
                </script>
                <style>
                    #treeview .k-sprite
                    {
                        background-image: url("../content/web/treeview/coloricons-sprite.png");
                    }
                    
                    .rootfolder
                    {
                        background-position: 0 0;
                    }
                    .folder
                    {
                        background-position: 0 -16px;
                    }
                    .pdf
                    {
                        background-position: 0 -32px;
                    }
                    .html
                    {
                        background-position: 0 -48px;
                    }
                    .image
                    {
                        background-position: 0 -64px;
                    }
                </style>
            </div>
        </div>
    </div>
</asp:Content>
