<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="OveralWiewRport.aspx.cs" Inherits="OveralWiewRport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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
        $(function () {
            get_svdspl_report();
            get_svd_report();
            get_svf_report();
            get_RDEAP_report();
            $("#divdashboard").css("display", "block");
            $('#div_frontbody').focus();
            $('#slct_month').focus();

        });
        function generate_report() {
            get_svdspl_report();
            get_svd_report();
            get_svf_report();
            get_RDEAP_report();
            $("#divdashboard").css("display", "block");
        }

        function get_svdspl_report() {
            var month = document.getElementById('slct_month').value;
            var data = { 'op': 'get_svdspl_report', 'month': month };
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
            var companyname = msg[0].companyname;
            var totgross = msg[0].totgross;
            var totnetpay = msg[0].totnetpay;
            var totemp = msg[0].totemp;
            var sno = msg[0].companyid;
            var year = msg[0].year;
            var month = msg[0].month;

            if (msg[0].companyname == " Sri Vyshnavi Dairy Specialities Pvt Ltd") {
                document.getElementById('spn_bname').innerHTML = "SVDS";
            }
            document.getElementById('lbl_svdssno').innerHTML = sno;
            document.getElementById('lbl_totgross').innerHTML = totgross;
            document.getElementById('lbl_totnet').innerHTML = totnetpay;
            document.getElementById('lbl_totemp').innerHTML = totemp;
        }

        function get_svd_report() {
            var month = document.getElementById('slct_month').value;
            var data = { 'op': 'get_svd_report', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        svd_details(msg);
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
        function svd_details(msg) {
            var companyname = msg[0].companyname;
            var totgross = msg[0].totgross;
            var totnetpay = msg[0].totnetpay;
            var totemp = msg[0].totemp;
            var sno = msg[0].companyid;
            var year = msg[0].year;
            var month = msg[0].month;

            if (msg[0].companyname == " Sri Vyshnavi Dairy Pvt Ltd") {
                document.getElementById('Span1').innerHTML = "SVD";
            }
            document.getElementById('lbl_svdsno').innerHTML = sno;
            document.getElementById('Label1').innerHTML = totgross;
            document.getElementById('Label2').innerHTML = totnetpay;
            document.getElementById('Label3').innerHTML = totemp;
        }
        function get_svf_report() {
            var month = document.getElementById('slct_month').value;
            var data = { 'op': 'get_svf_report', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        svf_details(msg);
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
        function svf_details(msg) {
            var companyname = msg[0].companyname;
            if (msg[0].companyname == 0 || companyname == null) {
                document.getElementById('Span2').innerHTML = "SVF";
            }
            var totgross = msg[0].totgross;
            if (msg[0].totgross == 0 || totgross == null) {
                document.getElementById('Span3').innerHTML = "0";
            }
            var totnetpay = msg[0].totnetpay;
            if (msg[0].totnetpay == 0 || totnetpay == null) {
                document.getElementById('Span4').innerHTML = "0";
            }
            var totemp = msg[0].totemp;
            if (msg[0].totemp == 0 || totemp == null) {
                document.getElementById('Span5').innerHTML = "0";
            }
            var sno = "3";
            var year = msg[0].year;
            var month = msg[0].month;

            //            if (msg[0].companyname == "Sri Vyshnavi Foods Pvt Ltd") {
            //                document.getElementById('Span2').innerHTML = "0";
            //            }
            //            document.getElementById('Span3').innerHTML = totgross;
            //            document.getElementById('Span4').innerHTML = totnetpay;
            //            document.getElementById('Span5').innerHTML = totemp;
            document.getElementById('lbl_svfsno').innerHTML = "3";

        }
        function get_RDEAP_report() {
            var month = document.getElementById('slct_month').value;
            var data = { 'op': 'get_RDEAP_report', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        RDEAP_details(msg);
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
        function RDEAP_details(msg) {
            var companyname = msg[0].companyname;
            var totgross = msg[0].totgross;
            var totnetpay = msg[0].totnetpay;
            var totemp = msg[0].totemp;
            var sno = msg[0].companyid;
            var year = msg[0].year;
            var month = msg[0].month;

            if (msg[0].companyname == "Ramdev Dairy Engineering&Projects") {
                document.getElementById('Span6').innerHTML = "RDEAP";
            }
            document.getElementById('lbl_rdeapsno').innerHTML = sno;
            document.getElementById('Span7').innerHTML = totgross;
            document.getElementById('Span8').innerHTML = totnetpay;
            document.getElementById('Span9').innerHTML = totemp;
        }

        //---------branch type wise-----------//branch_wise_datagrid

        function get_svds_branchtypewise_report() {
            $("#div_branchtype").css("display", "block");
            $("#div_btype").css("display", "block");
            $('html, body').animate({
                scrollTop: $("#div_btype").offset().top
            }, 1000);
            $('#div_btype').focus();
            var month = document.getElementById("slct_month").value;
            var companyid = document.getElementById('lbl_svdssno').innerHTML;
            var data = { 'op': 'get_gosvd_branchtypewise_report', 'companyid': companyid, 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_svds_brantypechwise_details(msg);
                    }
                    else {
                        $("#div_btype").empty();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var attandence = []; var branches = [];
        function fill_svds_brantypechwise_details(msg) {
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table  id="example2" class="table table-bordered table-hover "role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col"  ></th><th scope="col">Sno</th><th scope="col">Branch Type</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th><th scope="col" >Total emploees</th><th scope="col" >Total Centers</th></tr></thead></tbody>';
            var l = 0;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><span id="btn_poplate"  onclick="get_gsvd_branchwise_report(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td >' + k++ + '</td>';
                results += '<th class="blink_me" title="' + msg[i].msg + '"  style="font-size: 12px;" scope="row"  class="1">' + msg[i].branchtype + '</th>';
                results += '<td style="font-size: 12px;" class="2">' + msg[i].totgross + '</td>';
                results += '<td style="font-size: 12px;" class="3">' + msg[i].totnetpay + '</td>';
                results += '<td style="font-size: 12px;"  class="4">' + msg[i].totemp + '</td>';
                results += '<td style="display:none;" id="parent" class="5">' + msg[i].branchtype + '</td>'
                results += '<td style="display:none;" id="parent" class="6">' + msg[i].cmpid + '</td>'
                results += '<td style="font-size: 12px;"  class="4">' + msg[i].totbtype + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_btype").html(results);
        }


        function get_svd_branctypehwise_report() {
            $("#div_branchtype").css("display", "block");
            $("#div_btype").css("display", "block");
            $('html, body').animate({
                scrollTop: $("#div_btype").offset().top
            }, 1000);
            $('#div_btype').focus();
            var month = document.getElementById("slct_month").value;
            var companyid = document.getElementById('lbl_svdsno').innerHTML;
            var data = { 'op': 'get_gosvd_branchtypewise_report', 'companyid': companyid, 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_svd_brantypechwise_details(msg);
                    }
                    else {
                        $("#div_btype").empty();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var attandence = []; var branches = [];
        function fill_svd_brantypechwise_details(msg) {
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table  id="example2" class="table table-bordered table-hover "role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col"  ></th><th scope="col">Sno</th><th scope="col">Branch Type</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th><th scope="col" >Total emploees</th><th scope="col" >Total centers</th></tr></thead></tbody>';
            var l = 0;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><span id="btn_poplate"  onclick="get_gsvd_branchwise_report(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td >' + k++ + '</td>';
                results += '<th class="blink_me" title="' + msg[i].msg + '"  style="font-size: 12px;" scope="row"  class="1">' + msg[i].branchtype + '</th>';
                results += '<td style="font-size: 12px;" class="2">' + msg[i].totgross + '</td>';
                results += '<td style="font-size: 12px;" class="3">' + msg[i].totnetpay + '</td>';
                results += '<td style="font-size: 12px;"  class="4">' + msg[i].totemp + '</td>';
                results += '<td style="display:none;" id="parent" class="5">' + msg[i].branchtype + '</td>'
                results += '<td style="display:none;" id="parent" class="6">' + msg[i].cmpid + '</td>'
                results += '<td style="font-size: 12px;"  class="4">' + msg[i].totbtype + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_btype").html(results);
        }


        function get_svf_branctypehwise_report() {
            $("#div_branchtype").css("display", "block");
            $("#div_btype").css("display", "block");
            $('html, body').animate({
                scrollTop: $("#div_btype").offset().top
            }, 1000);
            $('#div_btype').focus();
            var month = document.getElementById("slct_month").value;
            var companyid = "3";
            var data = { 'op': 'get_gosvd_branchtypewise_report', 'companyid': companyid, 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_svf_brantypechwise_details(msg);
                    }
                    else {
                        $("#div_btype").empty();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var attandence = []; var branches = [];
        function fill_svf_brantypechwise_details(msg) {
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table  id="example2" class="table table-bordered table-hover "role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col"  ></th><th scope="col">Sno</th><th scope="col">Branch Type</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th><th scope="col" >Total emploees</th><th scope="col" >Total Centers</th></tr></thead></tbody>';
            var l = 0;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><span id="btn_poplate"  onclick="get_gsvd_branchwise_report(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td >' + k++ + '</td>';
                results += '<th class="blink_me" title="' + msg[i].msg + '"  style="font-size: 12px;" scope="row"  class="1">' + msg[i].branchtype + '</th>';
                results += '<td style="font-size: 12px;" class="2">' + msg[i].totgross + '</td>';
                results += '<td style="font-size: 12px;" class="3">' + msg[i].totnetpay + '</td>';
                results += '<td style="font-size: 12px;"  class="4">' + msg[i].totemp + '</td>';
                results += '<td style="display:none;" id="parent" class="5">' + msg[i].branchtype + '</td>'
                results += '<td style="display:none;" id="parent" class="6">' + msg[i].cmpid + '</td>'
                results += '<td style="font-size: 12px;"  class="4">' + msg[i].totbtype + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_btype").html(results);
        }

        function get_RDEAP_branctypehwise_report() {
            $("#div_branchtype").css("display", "block");
            $("#div_btype").css("display", "block");
            $('html, body').animate({
                scrollTop: $("#div_btype").offset().top
            }, 1000);
            $('#div_btype').focus();
            var month = document.getElementById("slct_month").value;
            var companyid = document.getElementById('lbl_rdeapsno').innerHTML;
            var data = { 'op': 'get_gosvd_branchtypewise_report', 'companyid': companyid, 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_RDEAP_brantypechwise_details(msg);
                    }
                    else {
                        $("#div_btype").empty();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var attandence = []; var branches = [];
        function fill_RDEAP_brantypechwise_details(msg) {
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table  id="example2" class="table table-bordered table-hover "role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col"  ></th><th scope="col">Sno</th><th scope="col">Branch Type</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th><th scope="col" >Total emploees</th><th scope="col" >Total Centers</th></tr></thead></tbody>';
            var l = 0;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><span id="btn_poplate"  onclick="get_gsvd_branchwise_report(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td >' + k++ + '</td>';
                results += '<th class="blink_me" title="' + msg[i].msg + '"  style="font-size: 12px;" scope="row"  class="1">' + msg[i].branchtype + '</th>';
                results += '<td style="font-size: 12px;" class="2">' + msg[i].totgross + '</td>';
                results += '<td style="font-size: 12px;" class="3">' + msg[i].totnetpay + '</td>';
                results += '<td style="font-size: 12px;"  class="4">' + msg[i].totemp + '</td>';
                results += '<td style="display:none;" id="parent" class="5">' + msg[i].branchtype + '</td>'
                results += '<td style="display:none;" id="parent" class="6">' + msg[i].cmpid + '</td>'
                results += '<td style="font-size: 12px;"  class="4">' + msg[i].totbtype + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_btype").html(results);
        }
        //------------branch wise fill--------------//

        function get_gsvd_branchwise_report(thisid) {
            $("#att_dep").css("display", "block");
            $("#branch_wise_datagrid").css("display", "block");
            $("#divtbldata").css("display", "block");
            $('html, body').animate({
                scrollTop: $("#divtbldata").offset().top
            }, 1000);
            $('#divtbldata').focus();
            var month = document.getElementById("slct_month").value;
            var btype = $(thisid).parent().parent().children('.5').html();
            var cmpid = $(thisid).parent().parent().children('.6').html();
            var data = { 'op': 'get_gosvd_branchwise_report', 'cmpid': cmpid, 'btype': btype, 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_gsvd_branchwise_details(msg);
                        // createbarChart(msg);
                    }
                    else {
                        $("#divtbldata").empty();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var attandence = []; var branches = [];
        function fill_gsvd_branchwise_details(msg) {
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table  id="example2" class="table table-bordered table-hover "role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col"  ></th><th scope="col">Sno</th><th scope="col">BRANCH NAME</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th><th scope="col" >Totalemploees</th></tr></thead></tbody>';
            var l = 0;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><span id="btn_poplate"  onclick="viewdept_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td >' + k++ + '</td>';
                results += '<th class="blink_me" title="' + msg[i].msg + '"  style="font-size: 12px;" scope="row"  class="1">' + msg[i].branchname + '</th>';
                results += '<td style="font-size: 12px;" class="2">' + msg[i].totgross + '</td>';
                results += '<td style="font-size: 12px;" class="3">' + msg[i].totnetpay + '</td>';
                results += '<td style="font-size: 12px;"  class="4">' + msg[i].totemp + '</td>';
                results += '<td style="display:none;" id="parent" class="5">' + msg[i].branchid + '</td>'
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divtbldata").html(results);
        }

        //--------------branch wise report--------------------//

        function get_svd_branchwise_report() {
            var month = document.getElementById("slct_month").value;
            var companyid = document.getElementById('lbl_svdsno').innerHTML;
            var data = { 'op': 'get_gosvd_branchwise_report', 'companyid': companyid, 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_svf_branchwise_details(msg);
                        // createbarChart(msg);
                    }
                    else {
                        $("#divtbldata").empty();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var attandence = []; var branches = [];
        function fill_svf_branchwise_details(msg) {
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table  id="example2" class="table table-bordered table-hover "role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col"  ></th><th scope="col">Sno</th><th scope="col">BRANCH NAME</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th><th scope="col" >Totalemploees</th></tr></thead></tbody>';
            var l = 0;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><span id="btn_poplate"  onclick="viewdept_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td >' + k++ + '</td>';
                results += '<th class="blink_me" title="' + msg[i].msg + '"  style="font-size: 12px;" scope="row"  class="1">' + msg[i].branchname + '</th>';
                results += '<td style="font-size: 12px;" class="2">' + msg[i].totgross + '</td>';
                results += '<td style="font-size: 12px;" class="3">' + msg[i].totnetpay + '</td>';
                results += '<td style="font-size: 12px;"  class="4">' + msg[i].totemp + '</td>';
                results += '<td style="display:none;" id="parent" class="5">' + msg[i].branchid + '</td>'
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divtbldata").html(results);
        }

        function get_svf_branchwise_report() {
            var month = document.getElementById("slct_month").value;
            var companyid = document.getElementById('lbl_svfsno').innerHTML;
            var data = { 'op': 'get_gosvd_branchwise_report', 'companyid': companyid, 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_svf_branchwise_details(msg);
                        // createbarChart(msg);
                    }
                    else {
                        $("#divtbldata").empty();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var attandence = []; var branches = [];
        function fill_svf_branchwise_details(msg) {
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table  id="example2" class="table table-bordered table-hover "role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col"  ></th><th scope="col">Sno</th><th scope="col">BRANCH NAME</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th><th scope="col" >Totalemploees</th></tr></thead></tbody>';
            var l = 0;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><span id="btn_poplate"  onclick="viewdept_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td >' + k++ + '</td>';
                results += '<th class="blink_me" title="' + msg[i].msg + '"  style="font-size: 12px;" scope="row"  class="1">' + msg[i].branchname + '</th>';
                results += '<td style="font-size: 12px;" class="2">' + msg[i].totgross + '</td>';
                results += '<td style="font-size: 12px;" class="3">' + msg[i].totnetpay + '</td>';
                results += '<td style="font-size: 12px;"  class="4">' + msg[i].totemp + '</td>';
                results += '<td style="display:none;" id="parent" class="5">' + msg[i].branchid + '</td>'
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divtbldata").html(results);
        }
        function get_RDEAP_branchwise_report() {
            var month = document.getElementById("slct_month").value;
            var companyid = document.getElementById('lbl_rdeapsno').innerHTML;
            var data = { 'op': 'get_gosvd_branchwise_report', 'companyid': companyid, 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_RDEAP_branchwise_details(msg);
                        // createbarChart(msg);
                    }
                    else {
                        $("#divtbldata").empty();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var attandence = []; var branches = [];
        function fill_RDEAP_branchwise_details(msg) {
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table  id="example2" class="table table-bordered table-hover "role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col"  ></th><th scope="col">Sno</th><th scope="col">BRANCH NAME</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th><th scope="col" >Totalemploees</th></tr></thead></tbody>';
            var l = 0;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><span id="btn_poplate"  onclick="viewdept_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td >' + k++ + '</td>';
                results += '<th class="blink_me" title="' + msg[i].msg + '"  style="font-size: 12px;" scope="row"  class="1">' + msg[i].branchname + '</th>';
                results += '<td style="font-size: 12px;" class="2">' + msg[i].totgross + '</td>';
                results += '<td style="font-size: 12px;" class="3">' + msg[i].totnetpay + '</td>';
                results += '<td style="font-size: 12px;"  class="4">' + msg[i].totemp + '</td>';
                results += '<td style="display:none;" id="parent" class="5">' + msg[i].branchid + '</td>'
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divtbldata").html(results);
        }

        function viewdept_details(thisid) {
            $("#divdepartment").css("display", "block");
            $('html, body').animate({
                scrollTop: $("#divdepartment").offset().top
            }, 1000);
            $('#divdepartment').focus();
            var month = document.getElementById("slct_month").value;
            var companyid = document.getElementById('lbl_svdssno').innerHTML;
            var branchid = $(thisid).parent().parent().children('.5').html();
            var data = { 'op': 'get_svdspl_depthwise_report', 'companyid': companyid, 'branchid': branchid, 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        dep_wise_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function dep_wise_details(msg) {
            var l = 0;
            //            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" >Dept Name</th><th scope="col">Total Salary</th><th scope="col">Total Net </th><th scope="col">Total Employees </th></tr></thead></tbody>';
            for (var k = 0; k < msg.length; k++) {
                results += '<tr >';
                results += '<th scope="row"  class="1"><span id="spninqty"  onclick="view_emp_details(this);"><i class="fa fa-arrow-circle-right" style="width: 22px;" aria-hidden="true"></i><span style="text-decoration: none;">' + msg[k].department + '</th>';
                results += '<td class="2" style="display:none">' + msg[k].deptid + '</td>';
                results += '<td class="3" style="display:none">' + msg[k].branchid + '</td>';
                results += '<td class="4" >' + msg[k].totgross + '</td>';
                results += '<td class="5" >' + msg[k].totnetpay + '</td>';
                results += '<td  class="6" >' + msg[k].totemp + '</td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#divdepartment").html(results);
        }



        function view_emp_details(thisid) {
            $("#att_emp").css("display", "block");
//            $("#divemploye").css("display", "block");
            $('html, body').animate({
                scrollTop: $("#divemploye").offset().top
            }, 1000);
            $('#divemploye').focus();
            var month = document.getElementById("slct_month").value;
            var companyid = document.getElementById('lbl_svdssno').innerHTML;
            var deptid = $(thisid).parent().parent().children('.2').html();
            var branchid = $(thisid).parent().parent().children('.3').html();
            var data = { 'op': 'get_svdspl_empwise_report', 'companyid': companyid, 'deptid': deptid, 'branchid': branchid, 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        emp_wise_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function emp_wise_details(msg) {
            var l = 0;
            //            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" >Employee Name</th><th scope="col">Total Salary</th><th scope="col">Total Net </th></tr></thead></tbody>';
            for (var k = 0; k < msg.length; k++) {
                results += '<tr >';
                results += '<td class="1" >' + msg[k].fullname + '</td>';
                results += '<td class="2" style="display:none">' + msg[k].empid + '</td>';
                results += '<td class="3" >' + msg[k].totgross + '</td>';
                results += '<td class="4" >' + msg[k].totnetpay + '</td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#divemploye").html(results);
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Overal Report<small>Report</small>
        </h1>
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
        <div id="div_frontbody" class='divcontainer' style="overflow: auto;">
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
        <div id="divdashboard">
            <div class="row">
                <div class="col-lg-3 col-xs-6">
                    <!-- small box -->
                    <div class="small-box bg-aqua">
                        <div class="inner">
                            <table>
                                <tr>
                                    <td style="text-align: center; float: right;">
                                        <span id="spn_bname"></span>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td>
                                        <label id="lbl_svdssno">
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>
                                            Total Salary</label>
                                    </td>
                                    <td>
                                        <span id="lbl_totgross"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>
                                            Total Net</label>
                                    </td>
                                    <td>
                                        <span id="lbl_totnet"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>
                                            TotEmployes</label>
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        <span id="lbl_totemp"></span>
                                    </td>
                                </tr>
                            </table>
                            <%-- <h3 id="txt_totalbranches"></h3>
                                <p>Total Branches</p>--%>
                        </div>
                        <%--<div class="icon">
                            <i class="fa fa-cubes"></i>
                        </div>--%>
                        <a href="#datagrid" class="small-box-footer" onclick="get_svds_branchtypewise_report('all');">
                            View</a>
                    </div>
                </div>
                <!-- ./col -->
                <div class="col-lg-3 col-xs-6">
                    <!-- small box -->
                    <div class="small-box bg-purple">
                        <div class="inner">
                            <table>
                                <tr>
                                    <td style="text-align: center; float: right;">
                                        <span id="Span1"></span>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td>
                                        <label id="lbl_svdsno">
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span>Total Salary</span>
                                    </td>
                                    <td>
                                        <span id="Label1"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span>Total Net</span>
                                    </td>
                                    <td>
                                        <span id="Label2"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span>Total Employes</span>
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        <span id="Label3"></span>
                                    </td>
                                </tr>
                            </table>
                            <%-- <h3 id="txt_totalbranches"></h3>
                                <p>Total Branches</p>--%>
                        </div>
                        <%--<div class="icon">
                            <i class="ion ion-person-add"></i>
                        </div>--%>
                        <a href="#datagrid" class="small-box-footer" onclick="get_svd_branctypehwise_report('running');">
                            View </a>
                    </div>
                </div>
                <!-- ./col -->
                <div class="col-lg-3 col-xs-6">
                    <!-- small box -->
                    <div class="small-box bg-green">
                        <div class="inner">
                            <table>
                                <tr>
                                    <td style="text-align: center; float: right;">
                                    </td>
                                    <td>
                                        <span id="Span2">SVF</span>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td>
                                        <label id="lbl_svfsno">
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>
                                            Total Salary</label>
                                    </td>
                                    <td>
                                        <span id="Span3">0</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>
                                            Total Net</label>
                                    </td>
                                    <td>
                                        <span id="Span4">0</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>
                                            Total Employes</label>
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        <span id="Span5">0</span>
                                    </td>
                                </tr>
                            </table>
                            <%-- <h3 id="txt_totalbranches"></h3>
                                <p>Total Branches</p>--%>
                        </div>
                        <%--<div class="icon">
                            <i class="fa fa-thumbs-o-up"></i>
                        </div>--%>
                        <a href="#datagrid" class="small-box-footer" onclick="get_svf_branctypehwise_report('stopped');">
                            View</a>
                    </div>
                </div>
                <!-- ./col -->
                <div class="col-lg-3 col-xs-6">
                    <!-- small box -->
                    <div class="small-box bg-red">
                        <div class="inner">
                            <table>
                                <tr>
                                    <td style="text-align: center; float: right;">
                                        <span id="Span6"></span>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td>
                                        <label id="lbl_rdeapsno">
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>
                                            Total Salary</label>
                                    </td>
                                    <td>
                                        <span id="Span7"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>
                                            Total Net</label>
                                    </td>
                                    <td>
                                        <span id="Span8"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label>
                                            Total Employes</label>
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        <span id="Span9"></span>
                                    </td>
                                </tr>
                            </table>
                            <%-- <h3 id="txt_totalbranches"></h3>
                                <p>Total Branches</p>--%>
                        </div>
                        <%--<div class="icon">
                            <i class="fa fa-thumbs-o-down"></i>
                        </div>--%>
                        <a href="#datagrid" class="small-box-footer" onclick="get_RDEAP_branctypehwise_report('delayupdate');">
                            View </a>
                    </div>
                </div>
                <!-- ./col -->
            </div>
        </div>
        <div id="div_branchtype" class="col-sm-6" style="width: 100%; display:none;">
            <div class="box box-solid box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Branch Type Wise Details</h3>
                    <div class="box-tools pull-right">
                        <button class="btn btn-box-tool" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="table-responsive">
                        <div id="div_btype" style="height: 300px; overflow-y: scroll;">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="branch_wise_datagrid" class="col-sm-6" style="display:none;">
            <div class="box box-solid box-warning">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Branch Wise Details</h3>
                    <div class="box-tools pull-right">
                        <button class="btn btn-box-tool" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="table-responsive">
                        <div id="divtbldata" style="height: 300px; overflow-y: scroll;">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="att_dep" class="col-sm-6" style="display:none;">
            <div class="box box-solid box-warning">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Department Wise Details</h3>
                    <div class="box-tools pull-right">
                        <button class="btn btn-box-tool" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="table-responsive">
                        <div id="divdepartment" style="height: 300px; overflow-y: scroll;">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6" id="att_emp" style="width: 100%; display:none;">
            <div class="box box-solid box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Employewise Wise Details
                    </h3>
                    <div class="box-tools pull-right">
                        <button class="btn btn-box-tool" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="box-body no-padding" style="height: 300px;">
                        <div id="divemploye" style="height: 300px; overflow-y: scroll;">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
