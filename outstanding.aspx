<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="outstanding.aspx.cs" Inherits="outstanding" %>


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

        $(function () {
            get_svdspl_report();
            get_svd_report();
            get_RDEAP_report();
            get_gosvds_report();
            get_totstaff_casual_report();
            get_gsvd_branchwise_report();
            $("#divdashboard").css("display", "block");
        });

        //        $(function () {
        //                get_svdspl_report();
        //                get_svd_report();
        //                get_RDEAP_report();
        //                get_gosvds_report();
        //                get_totstaff_casual_report();
        //                get_gsvd_branchwise_report();
        //                $("#divdashboard").css("display", "block");

        //        });
        function generate_report() {
            get_svdspl_report();
            get_svd_report();
            get_RDEAP_report();
            get_gosvds_report();
            get_totstaff_casual_report();
            get_gsvd_branchwise_report();
            $("#divdashboard").css("display", "block");
        }
        //--------close popup by pressing escape key-------//

        $(document).keyup(function (e) {
            if (e.keyCode === 27) {
                dep_closepopup(dep_close);
            }
        });

        $(document).keyup(function (e) {
            if (e.keyCode === 27) {
                gosvdemp_closepopup(gosvdemp_close);
            }
        });

        function dep_closepopup(msg) {
            $("#div_depmodel").css("display", "none");
            $("#div_employesatusdetails").css("display", "block");
            $('#div_empwisemodel').css('display', 'none');
        }
        function emp_closepopup(msg) {
            //            $("#div_empwisemodel").css("display", "none");
            //            $('#div_depmodel').css('display', 'block');
            $("#div_depmodel").css("display", "none");
            $("#div_employesatusdetails").css("display", "block");
            $('#div_empwisemodel').css('display', 'none');
        }
        function emp_backpopup(msg) {
            $("#div_empwisemodel").css("display", "none");
            $('#div_depmodel').css('display', 'block');
            $('#btn_poplate').focus();
        }
        function gosvdemp_closepopup(msg) {
            $("#svds_empdetails").css("display", "none");
            $('#gsvd_empdtype').css('display', 'none');
            $("#div_employesatusdetails").css("display", "block");
        }
        function gosvdemp_nextpopup(msg) {
            $("#div_depmodel").css("display", "none");
            $("#div_empwisemodel").css("display", "block");
        }

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


        function get_gosvds_report() {
            var month = document.getElementById('slct_month').value;
            var data = { 'op': 'get_govfto_report', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        gosvd_details(msg);
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
        function gosvd_details(msg) {
            var totgross = msg[0].totgross;
            var totsal = '₹' + " " + " " + totgross + '/-'
            var totnetpay = msg[0].totnetpay;
            var totnet = '₹' + " " + " " + totnetpay + '/-'
            var totemp = msg[0].totemp;

            document.getElementById('spn_gosvsal').innerHTML = totsal;
            document.getElementById('spn_gosvdnet').innerHTML = totnet;
            document.getElementById('spn_gostotemp').innerHTML = totemp;
        }


        function get_svdspl_report() {
            var month = document.getElementById('slct_month').value;
            var data = { 'op': 'get_svdspl_report', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        svdspl_detailsss1(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function svdspl_detailsss1(msg) {
            var totgross = msg[0].totgross;
            var totgross = '₹' + " " + " " + totgross + '/-'

            var totnetpay = msg[0].totnetpay;
            var totnetpay = '₹' + " " + " " + totnetpay + '/-'
            var totemp = msg[0].totemp;
            var companyid = msg[0].companyid;

            if (msg[0].companyname == " Sri Vyshnavi Foods Pvt Ltd") {
                document.getElementById('spn_bname').innerHTML = "SVDS";
            }
            document.getElementById('lbl_svdssno').innerHTML = companyid;
            document.getElementById('lbl_totgross').innerHTML = totgross;
            document.getElementById('lbl_svdstotnet').innerHTML = totnetpay;
            document.getElementById('lbl_svdstotemp').innerHTML = totemp;
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
            var totgross = '₹' + " " + " " + totgross + '/-'

            var totnetpay = msg[0].totnetpay;
            var totnetpay = '₹' + " " + " " + totnetpay + '/-'

            var totemp = msg[0].totemp;
            var sno = msg[0].companyid;

            if (msg[0].companyname == " Sri Vyshnavi Dairy Pvt Ltd") {
                document.getElementById('Span1').innerHTML = "SVD";
            }
            document.getElementById('lbl_svdsno').innerHTML = sno;
            document.getElementById('Label1').innerHTML = totgross;
            document.getElementById('Label2').innerHTML = totnetpay;
            document.getElementById('Label3').innerHTML = totemp;
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
            var totgross = '₹' + " " + " " + totgross + '/-'

            var totnetpay = msg[0].totnetpay;
            var totnetpay = '₹' + " " + " " + totnetpay + '/-'

            var totemp = msg[0].totemp;
            var sno = msg[0].companyid;

            if (msg[0].companyname == "Ramdev Dairy Engineering&Projects") {
                document.getElementById('Span6').innerHTML = "RAMDEV";
            }
            document.getElementById('lbl_rdeapsno').innerHTML = sno;
            document.getElementById('Span7').innerHTML = totgross;
            document.getElementById('Span8').innerHTML = totnetpay;
            document.getElementById('Span9').innerHTML = totemp;
        }
        function get_totstaff_casual_report() {
            var month = document.getElementById('slct_month').value;
            var data = { 'op': 'get_totstaff_casual_report', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        totstaff_details(msg);
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
        function totstaff_details(msg) {
            var totstaffgross = msg[0].totstaffgross;
            var totstaffgross = '₹' + " " + " " + totstaffgross + '/-'

            var totstaffnetpay = msg[0].totstaffnetpay;
            var totstaffnetpay = '₹' + " " + " " + totstaffnetpay + '/-'

            var totstaffemp = msg[0].totstaffemp;

            var totcasualgross = msg[0].totcasualgross;
            var totcasualgross = '₹' + " " + " " + totcasualgross + '/-'

            var totcasualnetpay = msg[0].totcasualnetpay;
            var totcasualnetpay = '₹' + " " + " " + totcasualnetpay + '/-'

            var totcasualemp = msg[0].totcasualemp;

            document.getElementById('spn_totstaffsal').innerHTML = totstaffgross;
            document.getElementById('tot_staffnet').innerHTML = totstaffnetpay;
            document.getElementById('spn_totstaff').innerHTML = totstaffemp;

            document.getElementById('spn_totcasualsal').innerHTML = totcasualgross;
            document.getElementById('tot_casualnet').innerHTML = totcasualnetpay;
            document.getElementById('spn_totcasual').innerHTML = totcasualemp;
        }


        function get_gsvd_branchwise_report(thisid) {
            $("#divtbldata").css("display", "block");
            var month = document.getElementById("slct_month").value;
            var data = { 'op': 'get_gosvd_branch_details', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function filldetails(msg) {
            var emptable = [];
            var results = '<div style="overflow:auto;"><table  id="example1" class="table table-bordered table-hover "role="grid" aria-describedby="example1_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col">Branch Type</th><th scope="col">Branch Name</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th><th scope="col" >Totalemploees</th><th scope="col" >Total Staff</th><th scope="col" >Total Casuals</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = [""];
            var ttotgross = 0;
            var tNetpays = 0;
            var tempcounts = 0;
            var tstaffempcounts = 0;
            var tcasualempcounts = 0;

            var gttotgross = 0;
            var gtNetpays = 0;
            var gtempcounts = 0;
            var gtstaffempcounts = 0;
            var gtcasualempcounts = 0;

            for (var i = 0; i < msg.length; i++) {
                if (emptable.indexOf(msg[i].branchtype) == -1) {
                    if (ttotgross > 0) {
                        results += '<tr style="color:  red;background: cornsilk;">';
                        results += '<th  scope="row"  class="1">' + "Total" + '</th>';
                        results += '<th  scope="row"  class="1"></th>';
                        results += '<td  scope="row"  class="1">' + ttotgross + '</td>';
                        results += '<td  scope="row"  class="1">' + tNetpays + '</td>';
                        results += '<td  scope="row"  class="1">' + tempcounts + '</td>';
                        results += '<td  scope="row"  class="1">' + tstaffempcounts + '</td>';
                        results += '<td  scope="row"  class="1">' + tcasualempcounts + '</td>';
                        results += '</tr>';
                        ttotgross = 0;
                        tNetpays = 0;
                        tempcounts = 0;
                        tstaffempcounts = 0;
                        tcasualempcounts = 0;
                    }
                    results += '<tr>';
                    results += '<th   scope="row"  class="1">' + msg[i].branchtype + '</th>';
                    results += '<th scope="row"  class="2"><span id="spninqty"  onclick="view_dep_details(this);"><i class="fa fa-arrow-circle-right" style="width: 22px;" aria-hidden="true"></i><span style="text-decoration: none;">' + msg[i].branchnames + '</th>';
                    results += '<th   scope="row"  class="8" style="display:none;">' + msg[i].branchid + '</th>';
                    results += '<td  class="3">' + parseFloat(msg[i].totgrosss) + '</td>';
                    results += '<td  class="4">' + parseFloat(msg[i].Netpays) + '</td>';
                    results += '<td  class="5">' + msg[i].empcounts + '</td>';
                    results += '<td  class="6">' + msg[i].staffempcounts + '</td>';
                    results += '<td  class="7">' + msg[i].casualempcounts + '</td>';
                    results += '</tr>';
                    var totgrosss = parseFloat(msg[i].totgrosss) || 0;
                    ttotgross += totgrosss;
                    gttotgross += totgrosss;

                    var Netpays = parseFloat(msg[i].Netpays) || 0;
                    tNetpays += Netpays;
                    gtNetpays += Netpays;

                    var empcounts = parseFloat(msg[i].empcounts) || 0;
                    tempcounts += empcounts;
                    gtempcounts += empcounts;

                    var staffempcounts = parseFloat(msg[i].staffempcounts) || 0;
                    tstaffempcounts += staffempcounts;
                    gtstaffempcounts += staffempcounts;

                    var casualempcounts = parseFloat(msg[i].casualempcounts) || 0;
                    tcasualempcounts += casualempcounts;
                    gtcasualempcounts += casualempcounts;

                    emptable.push(msg[i].branchtype);
                }
                else {
                    results += '<tr>';
                    results += '<th  scope="row"  class="1"></th>';
                    results += '<th scope="row"  class="1"><span id="spninqty"  onclick="view_dep_details(this);"><i class="fa fa-arrow-circle-right" style="width: 22px;" aria-hidden="true"></i><span style="text-decoration: none;">' + msg[i].branchnames + '</th>';
                    results += '<th   scope="row"  class="8" style="display:none;">' + msg[i].branchid + '</th>';
                    results += '<td  class="2">' + parseFloat(msg[i].totgrosss) + '</td>';
                    results += '<td  class="3">' + parseFloat(msg[i].Netpays) + '</td>';
                    results += '<td  class="4">' + msg[i].empcounts + '</td>';
                    results += '<td  class="5">' + msg[i].staffempcounts + '</td>';
                    results += '<td  class="6">' + msg[i].casualempcounts + '</td>';
                    results += '</tr>';
                    var totgrosss = parseFloat(msg[i].totgrosss) || 0;
                    ttotgross += totgrosss;
                    gttotgross += totgrosss;

                    var Netpays = parseFloat(msg[i].Netpays) || 0;
                    tNetpays += Netpays;
                    gtNetpays += Netpays;

                    var empcounts = parseFloat(msg[i].empcounts) || 0;
                    tempcounts += empcounts;
                    gtempcounts += empcounts;

                    var staffempcounts = parseFloat(msg[i].staffempcounts) || 0;
                    tstaffempcounts += staffempcounts;
                    gtstaffempcounts += staffempcounts;

                    var casualempcounts = parseFloat(msg[i].casualempcounts) || 0;
                    tcasualempcounts += casualempcounts;
                    gtcasualempcounts += casualempcounts;
                }
            }
            if (ttotgross > 0) {
                results += '<tr style="color:  red;background: cornsilk;">';
                results += '<th  scope="row"  class="1">' + "Total" + '</th>';
                results += '<th  scope="row"  class="1"></th>';
                results += '<td  scope="row"  class="1">' + ttotgross + '</td>';
                results += '<td  scope="row"  class="1">' + tNetpays + '</td>';
                results += '<td  scope="row"  class="1">' + tempcounts + '</td>';
                results += '<td  scope="row"  class="1">' + tstaffempcounts + '</td>';
                results += '<td  scope="row"  class="1">' + tcasualempcounts + '</td>';
                results += '</tr>';
                ttotgross = 0;
                tNetpays = 0;
                tempcounts = 0;
                tstaffempcounts = 0;
                tcasualempcounts = 0;
            }
            results += '<tr style="color:  red;background: aquamarine;">';
            results += '<th  scope="row"  class="1">' + "Grand Total" + '</th>';
            results += '<th  scope="row"  class="1"></th>';
            results += '<td  scope="row"  class="1">' + gttotgross + '</td>';
            results += '<td  scope="row"  class="1">' + gtNetpays + '</td>';
            results += '<td  scope="row"  class="1">' + gtempcounts + '</td>';
            results += '<td  scope="row"  class="1">' + gtstaffempcounts + '</td>';
            results += '<td  scope="row"  class="1">' + gtcasualempcounts + '</td>';
            results += '</tr>';
            results += '</table></div>';
            $("#div_btype").html(results);
        }
        function view_dep_details(thisid) {
            $("#div_depmodel").css("display", "block");
            $("#div_empwisemodel").css("display", "none");
            var month = document.getElementById("slct_month").value;
            var branchid = $(thisid).parent().parent().children('.8').html();
            var data = { 'op': 'get_gosvd_depthwise_report', 'branchid': branchid, 'month': month };
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
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table  id="example2" class="table table-bordered table-hover "role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col"></th><th scope="col">Sno</th><th scope="col">Department Name</th><th scope="col">Total Salary</th><th scope="col" >Total NetPay</th><th scope="col" >Total Emploees</th></tr></thead></tbody>';
            var l = 0;
            var gttotgross = 0;
            var gtNetpays = 0;
            var gtempcounts = 0;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><span id="btn_poplate"  onclick="viewemp_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td >' + k++ + '</td>';
                results += '<th  ' + msg[i].msg + '"  scope="row"  class="1">' + msg[i].department + '</th>';
                results += '<th  ' + msg[i].msg + '"  scope="row"  class="1">' + msg[i].totgross + '</th>';
                results += '<td  class="2">' + msg[i].totnetpay + '</td>';
                results += '<td  class="3">' + msg[i].totemp + '</td>';
                results += '<td  class="5" style="display:none;">' + msg[i].branchid + '</td>';
                results += '<td  class="6" style="display:none;">' + msg[i].deptid + '</td>';
                results += '</tr>';
                var totgrosss = parseFloat(msg[i].totgross) || 0;
                gttotgross += totgrosss;

                var Netpays = parseFloat(msg[i].totnetpay) || 0;
                gtNetpays += Netpays;

                var empcounts = parseFloat(msg[i].totemp) || 0;
                gtempcounts += empcounts;
            }
            results += '<tr style="color:  red;background: aquamarine;">';
            results += '<th  scope="row"  class="1"></th>';
            results += '<th  scope="row"  class="1"></th>';
            results += '<th  scope="row"  class="1">' + "Grand Total" + '</th>';
            results += '<td  scope="row"  class="1">' + gttotgross + '</td>';
            results += '<td  scope="row"  class="1">' + gtNetpays + '</td>';
            results += '<td  scope="row"  class="1">' + gtempcounts + '</td>';
            results += '</tr>';
            results += '</table></div>';
            $("#div_deptype").html(results);
        }
        function viewemp_details(thisid) {
            $("#div_depmodel").css("display", "none");
            $("#div_empwisemodel").css("display", "block");
            var month = document.getElementById("slct_month").value;
            var branchid = $(thisid).parent().parent().children('.5').html();
            var deptid = $(thisid).parent().parent().children('.6').html();
            var data = { 'op': 'get_gosvd_empwise_report', 'branchid': branchid, 'deptid': deptid, 'month': month };
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
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table  id="example3" class="table table-bordered table-hover "role="grid" aria-describedby="example3_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col">Sno</th><th scope="col">Employee Name</th><th scope="col">Total Salary</th><th scope="col" >Total NetPay</th></tr></thead></tbody>';
            var l = 0;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td >' + k++ + '</td>';
                results += '<th  class="1">' + msg[i].fullname + '</th>';
                results += '<th  class="2">' + msg[i].totgross + '</th>';
                results += '<td  class="3">' + msg[i].totnetpay + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_emptypee").html(results);
        }
        function gosvd_empdetails_click() {
            $("#svds_empdetails").css("display", "block");
            $("#gsvd_empdtype").css("display", "block");
            $("#svds_empdtype").css("display", "none");
            $("#svd_empdtype").css("display", "none");
            $("#rmrd_empdtype").css("display", "none");
            $("#staff_empdtype").css("display", "none");
            $("#casual_empdtype").css("display", "none");
            var month = document.getElementById("slct_month").value;
            var data = { 'op': 'get_gosvd_empwise_details', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        gosvd_empwise_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function gosvd_empwise_details(msg) {
            var emptable = [];
            var results = '<div style="overflow:auto;"><table  id="example1" class="table table-bordered table-hover "role="grid" aria-describedby="example1_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col">Branch Name</th><th scope="col">Full Name</th><th scope="col" >Total Salary</th><th scope="col" >Totalnet</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var ttotgross = 0;
            var ttotnetpay = 0;
            var gttotgross = 0;
            var gttotnetpay = 0;
            for (var i = 0; i < msg.length; i++) {
                if (emptable.indexOf(msg[i].branchname) == -1) {
                    if (ttotgross > 0) {
                        results += '<tr style="color:  red;background: cornsilk;">';
                        results += '<td  class="3">' + "Total" + '</td>';
                        results += '<td  class="3"></td>';
                        results += '<td  class="4">' + ttotgross + '</td>';
                        results += '<td  class="6">' + ttotnetpay + '</td>';
                        results += '</tr>';
                        ttotgross = 0;
                        ttotnetpay = 0;
                    }
                    results += '<tr>';
                    results += '<th   scope="row"  class="1">' + msg[i].branchname + '</th>';
                    results += '<td  class="3">' + msg[i].fullname + '</td>';
                    results += '<td  class="4">' + msg[i].totgross + '</td>';
                    results += '<td  class="6">' + msg[i].totnetpay + '</td>';
                    results += '</tr>';
                    var totgross = parseFloat(msg[i].totgross) || 0;
                    var totnetpay = parseFloat(msg[i].totnetpay) || 0;
                    ttotgross += totgross;
                    ttotnetpay += totnetpay;
                    gttotgross += totgross;
                    gttotnetpay += totnetpay;
                    emptable.push(msg[i].branchname);
                }
                else {
                    results += '<tr>';
                    results += '<th  scope="row"  class="1"></th>';
                    results += '<td  class="3">' + msg[i].fullname + '</td>';
                    results += '<td  class="4">' + msg[i].totgross + '</td>';
                    results += '<td  class="6">' + msg[i].totnetpay + '</td>';
                    results += '</tr>';
                    var totgross = parseFloat(msg[i].totgross) || 0;
                    var totnetpay = parseFloat(msg[i].totnetpay) || 0;
                    ttotgross += totgross;
                    ttotnetpay += totnetpay;
                    gttotgross += totgross;
                    gttotnetpay += totnetpay;
                }
            }
            if (ttotgross > 0) {
                results += '<tr style="color:  red;background: cornsilk;">';
                results += '<td  class="3">' + "Total" + '</td>';
                results += '<td  class="3"></td>';
                results += '<td  class="4">' + ttotgross + '</td>';
                results += '<td  class="6">' + ttotnetpay + '</td>';
                results += '</tr>';
                ttotgross = 0;
                ttotnetpay = 0;
            }
            results += '<tr style="color:  red;background: aquamarine;">';
            results += '<td  class="3">' + "Grand Total" + '</td>';
            results += '<td  class="3"></td>';
            results += '<td  class="4">' + gttotgross + '</td>';
            results += '<td  class="6">' + gttotnetpay + '</td>';
            results += '</tr>';
            results += '</table></div>';
            $("#gsvd_empdtype").html(results);
        }
        function svds_empdetails_click() {
            $("#svds_empdetails").css("display", "block");
            $("#gsvd_empdtype").css("display", "none");
            $("#svds_empdtype").css("display", "block");
            $("#svd_empdtype").css("display", "none");
            $("#rmrd_empdtype").css("display", "none");
            $("#staff_empdtype").css("display", "none");
            $("#casual_empdtype").css("display", "none");
            var month = document.getElementById("slct_month").value;
            var data = { 'op': 'get_svds_empwise_details', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        svds_empwise_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        //        function svds_empwise_details(msg) {
        //            var k = 1;
        //            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
        //            var results = '<div style="overflow:auto;"><table  id="svds_id" class="table table-bordered table-hover "role="grid" aria-describedby="example2_info">';
        //            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col">Sno</th><th scope="col">Branch Name</th><th scope="col">Employe Name</th><th scope="col">Total Salary</th><th scope="col" >Total NetPay</th></tr></thead></tbody>';
        //            var l = 0;
        //            for (var i = 0; i < msg.length; i++) {
        ////                results += '<tr><td><span id="btn_poplate"  onclick="viewemp_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
        //                results += '<tr><td >' + k++ + '</td>';
        //                results += '<td  class="2">' + msg[i].branchname + '</td>';
        //                results += '<th  class="1">' + msg[i].fullname + '</th>';
        //                results += '<td  class="3">' + msg[i].totgross + '</td>';
        //                results += '<td  class="4">' + msg[i].totnetpay + '</td>';
        //                results += '</tr>';
        //                l = l + 1;
        //                if (l == 4) {
        //                    l = 0;
        //                }
        //            }
        //            results += '</table></div>';
        //            $("#svds_empdtype").html(results);
        //        }

        function svds_empwise_details(msg) {
            var emptable = [];
            var results = '<div style="overflow:auto;"><table  id="example1" class="table table-bordered table-hover "role="grid" aria-describedby="example1_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col">Branch Name</th><th scope="col">Full Name</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var ttotgross = 0;
            var ttotnetpay = 0;
            var gttotgross = 0;
            var gttotnetpay = 0;
            for (var i = 0; i < msg.length; i++) {
                if (emptable.indexOf(msg[i].branchname) == -1) {
                    if (ttotgross > 0) {
                        results += '<tr style="color:  red;background: cornsilk;">';
                        results += '<td  class="3">' + "Total" + '</td>';
                        results += '<td  class="3"></td>';
                        results += '<td  class="4">' + ttotgross + '</td>';
                        results += '<td  class="6">' + ttotnetpay + '</td>';
                        results += '</tr>';
                        ttotgross = 0;
                        ttotnetpay = 0;
                    }
                    results += '<tr>';
                    results += '<th   scope="row"  class="1">' + msg[i].branchname + '</th>';
                    results += '<td  class="3">' + msg[i].fullname + '</td>';
                    results += '<td  class="4">' + msg[i].totgross + '</td>';
                    results += '<td  class="6">' + msg[i].totnetpay + '</td>';
                    results += '</tr>';
                    var totgross = parseFloat(msg[i].totgross) || 0;
                    var totnetpay = parseFloat(msg[i].totnetpay) || 0;
                    ttotgross += totgross;
                    ttotnetpay += totnetpay;
                    gttotgross += totgross;
                    gttotnetpay += totnetpay;
                    emptable.push(msg[i].branchname);
                }
                else {
                    results += '<tr>';
                    results += '<th  scope="row"  class="1"></th>';
                    results += '<td  class="3">' + msg[i].fullname + '</td>';
                    results += '<td  class="4">' + msg[i].totgross + '</td>';
                    results += '<td  class="6">' + msg[i].totnetpay + '</td>';
                    results += '</tr>';
                    var totgross = parseFloat(msg[i].totgross) || 0;
                    var totnetpay = parseFloat(msg[i].totnetpay) || 0;
                    ttotgross += totgross;
                    ttotnetpay += totnetpay;
                    gttotgross += totgross;
                    gttotnetpay += totnetpay;
                }
            }
            if (ttotgross > 0) {
                results += '<tr style="color:  red;background: cornsilk;">';
                results += '<td  class="3">' + "Total" + '</td>';
                results += '<td  class="3"></td>';
                results += '<td  class="4">' + ttotgross + '</td>';
                results += '<td  class="6">' + ttotnetpay + '</td>';
                results += '</tr>';
                ttotgross = 0;
                ttotnetpay = 0;
            }
            results += '<tr style="color:  red;background: aquamarine;">';
            results += '<td  class="3">' + "Grand Total" + '</td>';
            results += '<td  class="3"></td>';
            results += '<td  class="4">' + gttotgross + '</td>';
            results += '<td  class="6">' + gttotnetpay + '</td>';
            results += '</tr>';
            results += '</table></div>';
            $("#svds_empdtype").html(results);
        }

        //-------------------test close---------------//
        function svd_empdetails_click() {
            $("#svds_empdetails").css("display", "block");
            $("#gsvd_empdtype").css("display", "none");
            $("#svds_empdtype").css("display", "none");
            $("#svd_empdtype").css("display", "block");
            $("#rmrd_empdtype").css("display", "none");
            $("#staff_empdtype").css("display", "none");
            $("#casual_empdtype").css("display", "none");
            var month = document.getElementById("slct_month").value;
            var data = { 'op': 'get_svd_empwise_details', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        svd_empwise_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function svd_empwise_details(msg) {
            var emptable = [];
            var results = '<div style="overflow:auto;"><table  id="example1" class="table table-bordered table-hover "role="grid" aria-describedby="example1_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col">Branch Name</th><th scope="col">Full Name</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var ttotgross = 0;
            var ttotnetpay = 0;
            var gttotgross = 0;
            var gttotnetpay = 0;
            for (var i = 0; i < msg.length; i++) {
                if (emptable.indexOf(msg[i].branchname) == -1) {
                    if (ttotgross > 0) {
                        results += '<tr style="color:  red;background: cornsilk;">';
                        results += '<td  class="3">' + "Total" + '</td>';
                        results += '<td  class="3"></td>';
                        results += '<td  class="4">' + ttotgross + '</td>';
                        results += '<td  class="6">' + ttotnetpay + '</td>';
                        results += '</tr>';
                        ttotgross = 0;
                        ttotnetpay = 0;
                    }
                    results += '<tr>';
                    results += '<th   scope="row"  class="1">' + msg[i].branchname + '</th>';
                    results += '<td  class="3">' + msg[i].fullname + '</td>';
                    results += '<td  class="4">' + msg[i].totgross + '</td>';
                    results += '<td  class="6">' + msg[i].totnetpay + '</td>';
                    results += '</tr>';
                    var totgross = parseFloat(msg[i].totgross) || 0;
                    var totnetpay = parseFloat(msg[i].totnetpay) || 0;
                    ttotgross += totgross;
                    ttotnetpay += totnetpay;
                    gttotgross += totgross;
                    gttotnetpay += totnetpay;
                    emptable.push(msg[i].branchname);
                }
                else {
                    results += '<tr>';
                    results += '<th  scope="row"  class="1"></th>';
                    results += '<td  class="3">' + msg[i].fullname + '</td>';
                    results += '<td  class="4">' + msg[i].totgross + '</td>';
                    results += '<td  class="6">' + msg[i].totnetpay + '</td>';
                    results += '</tr>';
                    var totgross = parseFloat(msg[i].totgross) || 0;
                    var totnetpay = parseFloat(msg[i].totnetpay) || 0;
                    ttotgross += totgross;
                    ttotnetpay += totnetpay;
                    gttotgross += totgross;
                    gttotnetpay += totnetpay;
                }
            }
            if (ttotgross > 0) {
                results += '<tr style="color:  red;background: cornsilk;">';
                results += '<td  class="3">' + "Total" + '</td>';
                results += '<td  class="3"></td>';
                results += '<td  class="4">' + ttotgross + '</td>';
                results += '<td  class="6">' + ttotnetpay + '</td>';
                results += '</tr>';
                ttotgross = 0;
                ttotnetpay = 0;
            }
            results += '<tr style="color:  red;background: aquamarine;">';
            results += '<td  class="3">' + "Grand Total" + '</td>';
            results += '<td  class="3"></td>';
            results += '<td  class="4">' + gttotgross + '</td>';
            results += '<td  class="6">' + gttotnetpay + '</td>';
            results += '</tr>';
            results += '</table></div>';
            $("#svd_empdtype").html(results);
        }

        function rmrd_empdetails_click() {
            $("#svds_empdetails").css("display", "block");
            $("#gsvd_empdtype").css("display", "none");
            $("#svds_empdtype").css("display", "none");
            $("#svd_empdtype").css("display", "none");
            $("#rmrd_empdtype").css("display", "block");
            $("#staff_empdtype").css("display", "none");
            $("#casual_empdtype").css("display", "none");
            var month = document.getElementById("slct_month").value;
            var data = { 'op': 'get_rmrd_empwise_details', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        rmrd_empwise_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function rmrd_empwise_details(msg) {
            var emptable = [];
            var results = '<div style="overflow:auto;"><table  id="example1" class="table table-bordered table-hover "role="grid" aria-describedby="example1_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col">Branch Name</th><th scope="col">Full Name</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var ttotgross = 0;
            var ttotnetpay = 0;
            var gttotgross = 0;
            var gttotnetpay = 0;
            for (var i = 0; i < msg.length; i++) {
                if (emptable.indexOf(msg[i].branchname) == -1) {
                    if (ttotgross > 0) {
                        results += '<tr style="color:  red;background: cornsilk;">';
                        results += '<td  class="3">' + "Total" + '</td>';
                        results += '<td  class="3"></td>';
                        results += '<td  class="4">' + ttotgross + '</td>';
                        results += '<td  class="6">' + ttotnetpay + '</td>';
                        results += '</tr>';
                        ttotgross = 0;
                        ttotnetpay = 0;
                    }
                    results += '<tr>';
                    results += '<th   scope="row"  class="1">' + msg[i].branchname + '</th>';
                    results += '<td  class="3">' + msg[i].fullname + '</td>';
                    results += '<td  class="4">' + msg[i].totgross + '</td>';
                    results += '<td  class="6">' + msg[i].totnetpay + '</td>';
                    results += '</tr>';
                    var totgross = parseFloat(msg[i].totgross) || 0;
                    var totnetpay = parseFloat(msg[i].totnetpay) || 0;
                    ttotgross += totgross;
                    ttotnetpay += totnetpay;
                    gttotgross += totgross;
                    gttotnetpay += totnetpay;
                    emptable.push(msg[i].branchname);
                }
                else {
                    results += '<tr>';
                    results += '<th  scope="row"  class="1"></th>';
                    results += '<td  class="3">' + msg[i].fullname + '</td>';
                    results += '<td  class="4">' + msg[i].totgross + '</td>';
                    results += '<td  class="6">' + msg[i].totnetpay + '</td>';
                    results += '</tr>';
                    var totgross = parseFloat(msg[i].totgross) || 0;
                    var totnetpay = parseFloat(msg[i].totnetpay) || 0;
                    ttotgross += totgross;
                    ttotnetpay += totnetpay;
                    gttotgross += totgross;
                    gttotnetpay += totnetpay;
                }
            }
            if (ttotgross > 0) {
                results += '<tr style="color:  red;background: cornsilk;">';
                results += '<td  class="3">' + "Total" + '</td>';
                results += '<td  class="3"></td>';
                results += '<td  class="4">' + ttotgross + '</td>';
                results += '<td  class="6">' + ttotnetpay + '</td>';
                results += '</tr>';
                ttotgross = 0;
                ttotnetpay = 0;
            }
            results += '<tr style="color:  red;background: aquamarine;">';
            results += '<td  class="3">' + "Grand Total" + '</td>';
            results += '<td  class="3"></td>';
            results += '<td  class="4">' + gttotgross + '</td>';
            results += '<td  class="6">' + gttotnetpay + '</td>';
            results += '</tr>';
            results += '</table></div>';
            $("#rmrd_empdtype").html(results);
        }
        function staff_empdetails_click() {
            $("#svds_empdetails").css("display", "block");
            $("#gsvd_empdtype").css("display", "none");
            $("#svds_empdtype").css("display", "none");
            $("#svd_empdtype").css("display", "none");
            $("#rmrd_empdtype").css("display", "none");
            $("#staff_empdtype").css("display", "block");
            $("#casual_empdtype").css("display", "none");
            var month = document.getElementById("slct_month").value;
            var data = { 'op': 'get_staff_empwise_details', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        staff_empwise_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function staff_empwise_details(msg) {
            var emptable = [];
            var results = '<div style="overflow:auto;"><table  id="example1" class="table table-bordered table-hover "role="grid" aria-describedby="example1_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col">Branch Name</th><th scope="col">Full Name</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var ttotgross = 0;
            var ttotnetpay = 0;
            var gttotgross = 0;
            var gttotnetpay = 0;
            for (var i = 0; i < msg.length; i++) {
                if (emptable.indexOf(msg[i].branchname) == -1) {
                    if (ttotgross > 0) {
                        results += '<tr style="color:  red;background: cornsilk;">';
                        results += '<td  class="3">' + "Total" + '</td>';
                        results += '<td  class="3"></td>';
                        results += '<td  class="4">' + ttotgross + '</td>';
                        results += '<td  class="6">' + ttotnetpay + '</td>';
                        results += '</tr>';
                        ttotgross = 0;
                        ttotnetpay = 0;
                    }
                    results += '<tr>';
                    results += '<th   scope="row"  class="1">' + msg[i].branchname + '</th>';
                    results += '<td  class="3">' + msg[i].fullname + '</td>';
                    results += '<td  class="4">' + msg[i].totgross + '</td>';
                    results += '<td  class="6">' + msg[i].totnetpay + '</td>';
                    results += '</tr>';
                    var totgross = parseFloat(msg[i].totgross) || 0;
                    var totnetpay = parseFloat(msg[i].totnetpay) || 0;
                    ttotgross += totgross;
                    ttotnetpay += totnetpay;
                    gttotgross += totgross;
                    gttotnetpay += totnetpay;
                    emptable.push(msg[i].branchname);
                }
                else {
                    results += '<tr>';
                    results += '<th  scope="row"  class="1"></th>';
                    results += '<td  class="3">' + msg[i].fullname + '</td>';
                    results += '<td  class="4">' + msg[i].totgross + '</td>';
                    results += '<td  class="6">' + msg[i].totnetpay + '</td>';
                    results += '</tr>';
                    var totgross = parseFloat(msg[i].totgross) || 0;
                    var totnetpay = parseFloat(msg[i].totnetpay) || 0;
                    ttotgross += totgross;
                    ttotnetpay += totnetpay;
                    gttotgross += totgross;
                    gttotnetpay += totnetpay;
                }
            }
            if (ttotgross > 0) {
                results += '<tr style="color:  red;background: cornsilk;">';
                results += '<td  class="3">' + "Total" + '</td>';
                results += '<td  class="3"></td>';
                results += '<td  class="4">' + ttotgross + '</td>';
                results += '<td  class="6">' + ttotnetpay + '</td>';
                results += '</tr>';
                ttotgross = 0;
                ttotnetpay = 0;
            }
            results += '<tr style="color:  red;background: aquamarine;">';
            results += '<td  class="3">' + "Grand Total" + '</td>';
            results += '<td  class="3"></td>';
            results += '<td  class="4">' + gttotgross + '</td>';
            results += '<td  class="6">' + gttotnetpay + '</td>';
            results += '</tr>';
            results += '</table></div>';
            $("#staff_empdtype").html(results);
        }
        function casual_empdetails_click() {
            $("#svds_empdetails").css("display", "block");
            $("#gsvd_empdtype").css("display", "none");
            $("#svds_empdtype").css("display", "none");
            $("#svd_empdtype").css("display", "none");
            $("#rmrd_empdtype").css("display", "none");
            $("#staff_empdtype").css("display", "none");
            $("#casual_empdtype").css("display", "block");
            var month = document.getElementById("slct_month").value;
            var data = { 'op': 'get_casual_empwise_details', 'month': month };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        casual_empwise_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function casual_empwise_details(msg) {
            var emptable = [];
            var results = '<div style="overflow:auto;"><table  id="example1" class="table table-bordered table-hover "role="grid" aria-describedby="example1_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col">Branch Name</th><th scope="col">Full Name</th><th scope="col">Total Salary</th><th scope="col" >Totalnet</th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var ttotgross = 0;
            var ttotnetpay = 0;
            var gttotgross = 0;
            var gttotnetpay = 0;
            for (var i = 0; i < msg.length; i++) {
                if (emptable.indexOf(msg[i].branchname) == -1) {
                    if (ttotgross > 0) {
                        results += '<tr style="color:  red;background: cornsilk;">';
                        results += '<td  class="3">' + "Total" + '</td>';
                        results += '<td  class="3"></td>';
                        results += '<td  class="4">' + ttotgross + '</td>';
                        results += '<td  class="6">' + ttotnetpay + '</td>';
                        results += '</tr>';
                        ttotgross = 0;
                        ttotnetpay = 0;
                    }
                    results += '<tr>';
                    results += '<th   scope="row"  class="1">' + msg[i].branchname + '</th>';
                    results += '<td  class="3">' + msg[i].fullname + '</td>';
                    results += '<td  class="4">' + msg[i].totgross + '</td>';
                    results += '<td  class="6">' + msg[i].totnetpay + '</td>';
                    results += '</tr>';
                    var totgross = parseFloat(msg[i].totgross) || 0;
                    var totnetpay = parseFloat(msg[i].totnetpay) || 0;
                    ttotgross += totgross;
                    ttotnetpay += totnetpay;
                    gttotgross += totgross;
                    gttotnetpay += totnetpay;
                    emptable.push(msg[i].branchname);
                }
                else {
                    results += '<tr>';
                    results += '<th  scope="row"  class="1"></th>';
                    results += '<td  class="3">' + msg[i].fullname + '</td>';
                    results += '<td  class="4">' + msg[i].totgross + '</td>';
                    results += '<td  class="6">' + msg[i].totnetpay + '</td>';
                    results += '</tr>';
                    var totgross = parseFloat(msg[i].totgross) || 0;
                    var totnetpay = parseFloat(msg[i].totnetpay) || 0;
                    ttotgross += totgross;
                    ttotnetpay += totnetpay;
                    gttotgross += totgross;
                    gttotnetpay += totnetpay;
                }
            }
            if (ttotgross > 0) {
                results += '<tr style="color:  red;background: cornsilk;">';
                results += '<td  class="3">' + "Total" + '</td>';
                results += '<td  class="3"></td>';
                results += '<td  class="4">' + ttotgross + '</td>';
                results += '<td  class="6">' + ttotnetpay + '</td>';
                results += '</tr>';
                ttotgross = 0;
                ttotnetpay = 0;
            }
            results += '<tr style="color:  red;background: aquamarine;">';
            results += '<td  class="3">' + "Grand Total" + '</td>';
            results += '<td  class="3"></td>';
            results += '<td  class="4">' + gttotgross + '</td>';
            results += '<td  class="6">' + gttotnetpay + '</td>';
            results += '</tr>';
            results += '</table></div>';
            $("#casual_empdtype").html(results);
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
    <div id="totbody">
        <div id="div_employesatusdetails">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Overal payment report
                </h3>
            </div>
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
                        <div>
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
                                <span id="spn_year"></span>
                            </td>
                        </div>
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
            <div id="divdashboard" style="display: none;">
                <div class="row" style="width: 1444px;">
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-aqua">
                            <div class="inner">
                                <table>
                                    <tr>
                                        <td style="text-align: center; float: right; width: 100px;">
                                            <span id="spn_bname" style="font-size: 20px;"></span>
                                        </td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td>
                                            <span id="lbl_svdssno"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 179px;">
                                            <span style="font-size: 16px;">Total Salary</span>
                                        </td>
                                        <td>
                                            <span id="lbl_totgross" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <tr>
                                        <td>
                                            <span style="font-size: 16px;">Total Net</span>
                                        </td>
                                        <td>
                                            <span id="lbl_svdstotnet" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <tr>
                                        <td>
                                            <span style="font-size: 16px;">TotEmployes</span>
                                        </td>
                                        <td>
                                            <span id="lbl_svdstotemp" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="svds_empdetails_click('all');">View</a>
                        </div>
                    </div>
                    <!-- ./col -->
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-purple">
                            <div class="inner">
                                <table>
                                    <tr>
                                        <td style="text-align: center; float: right; width: 100px;">
                                            <span id="Span1" style="font-size: 20px;"></span>
                                        </td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td>
                                            <span id="lbl_svdsno"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 179px;">
                                            <span style="font-size: 16px;">Total Salary</span>
                                        </td>
                                        <td>
                                            <span id="Label1" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span style="font-size: 16px;">Total Net</span>
                                        </td>
                                        <td>
                                            <span id="Label2" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span style="font-size: 16px;">Total Employes</span>
                                        </td>
                                        <td>
                                            <span id="Label3" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="svd_empdetails_click('all');">View</a>
                        </div>
                    </div>
                    <!-- ./col -->
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-green">
                            <div class="inner">
                                <table>
                                    <tr>
                                        <td style="text-align: center; float: right; width: 100px;">
                                            <span id="Span6" style="font-size: 20px;"></span>
                                        </td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td>
                                            <span id="lbl_rdeapsno"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 179px;">
                                            <span style="font-size: 16px;">Total Salary</span>
                                        </td>
                                        <td>
                                            <span id="Span7" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <tr>
                                        <td>
                                            <span style="font-size: 16px;">Total Net</span>
                                        </td>
                                        <td>
                                            <span id="Span8" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <tr>
                                        <td>
                                            <span style="font-size: 16px;">Total Employes</span>
                                        </td>
                                        <td>
                                            <span id="Span9" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="rmrd_empdetails_click('all');">View</a>
                        </div>
                    </div>
                    <!-- ./col -->
                </div>
                <div class="row" id="shiva" style="width: 1444px;">
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box small-box bg-olive">
                            <div class="inner">
                                <table>
                                    <tr>
                                        <td style="text-align: center; float: right; width: 100px;">
                                            <span id="Span2" style="font-size: 20px;">Grand Total</span>
                                        </td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td>
                                            <span id="Label4"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 179px;">
                                            <span style="font-size: 16px;">Total Salary</span>
                                        </td>
                                        <td>
                                            <span id="spn_gosvsal" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <tr>
                                        <td>
                                            <span style="font-size: 16px;">Total Net</span>
                                        </td>
                                        <td>
                                            <span id="spn_gosvdnet" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <tr>
                                        <td>
                                            <span style="font-size: 16px;">Totl Employees</span>
                                        </td>
                                        <td>
                                            <span id="spn_gostotemp" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="gosvd_empdetails_click('all');">View</a>
                        </div>
                    </div>
                    <!-- ./col -->
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-red">
                            <div class="inner">
                                <table>
                                    <tr>
                                        <td style="text-align: center; float: right; width: 100px;">
                                            <span id="Span3" style="font-size: 20px;">Staff</span>
                                        </td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td>
                                            <span id="Span4"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 179px;">
                                            <span style="font-size: 16px;">Total Salary</span>
                                        </td>
                                        <td>
                                            <span id="spn_totstaffsal" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <tr>
                                        <td>
                                            <span style="font-size: 16px;">Total Net</span>
                                        </td>
                                        <td>
                                            <span id="tot_staffnet" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <tr>
                                        <td>
                                            <span style="font-size: 16px;">Totl Employees</span>
                                        </td>
                                        <td>
                                            <span id="spn_totstaff" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="staff_empdetails_click('all');">View</a>
                        </div>
                    </div>
                    <!-- ./col -->
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-teal">
                            <div class="inner">
                                <table>
                                    <tr>
                                        <td style="text-align: center; float: right; width: 100px;">
                                            <span id="Span12" style="font-size: 20px;">Casuals</span>
                                        </td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td>
                                            <span id="Span13"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 179px;">
                                            <span style="font-size: 16px;">Total Salary</span>
                                        </td>
                                        <td>
                                            <span id="spn_totcasualsal" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <tr>
                                        <td>
                                            <span style="font-size: 16px;">Total Net</span>
                                        </td>
                                        <td>
                                            <span id="tot_casualnet" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <tr>
                                        <td>
                                            <span style="font-size: 16px;">Totl Employees</span>
                                        </td>
                                        <td>
                                            <span id="spn_totcasual" style="font-size: 16px;"></span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="casual_empdetails_click('all');">View</a>
                        </div>
                    </div>
                    <!-- ./col -->
                </div>
            </div>
            <div id="div_branchtype" class="col-sm-6" style="width: 100%;">
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
                            <div id="div_btype" style="height: auto; overflow-y: scroll;">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal" id="div_depmodel" role="dialog" style="overflow: auto; 
            display: none;">
            <div class="modal-dialog">
                 <div class="modal-content" style="border: 2px solid; border-color: antiquewhite;">
                    <div class="modal-body">
                        <div id="divPrints" style="border: 4px solid; border-color: aliceblue;">
                             <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                                <span style="font-size: 26px; font-weight: bold;">Department Wise Payment Information
                                </span>
                            </div>
                            <br />
                            <div id="div_deptype" style="width: 100%; padding-top: 3px;">
                            </div>
                        <div class="modal-footer">
                        <table>
                        <tr>
                        <td class="modal-footer" style="text-align: left; width: 40%;">
                        <button type="button" class="btn btn-default" id="Button2" onclick="dep_closepopup();" style="background-color:  paleturquoise;">
                             Back </button>
                    </td>
                    <td>&nbsp;</td>
                        <td class="modal-footer" style="text-align: center; width: 2%;">
                            <button type="button" class="btn btn-default" id="dep_close" onclick="dep_closepopup();" style="background-color:  rosybrown;">
                                Close</button>
                        </td>
                        <td>&nbsp;</td>
                    <td class="modal-footer" style="text-align: Right;">
                        <button type="button" class="btn btn-default" id="Button3" onclick="gosvdemp_nextpopup();" style="background-color:  paleturquoise;">
                             Next </button>
                    </td>
                    </tr>
                    </table>
                    </div>
                        <div id="div1" style="width: 35px; top: 0.5%; right: 0%; position: absolute; z-index: 99999;
                            cursor: pointer;">
                            <img src="Images/Close.png" alt="close" onclick="dep_closepopup();" />
                        </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal" id="div_empwisemodel" role="dialog" style="overflow: auto;
            display: none;">
            <div class="modal-dialog">
                 <div class="modal-content" style="border: 2px solid; border-color: antiquewhite;">
                    <div class="modal-body">
                        <div id="div3" style="border: 4px solid; border-color: aliceblue;">
                            <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                                <span style="font-size: 26px; font-weight: bold;">Employee Wise Payment Information </span>
                            </div>
                            <br />
                            <div id="div_emptypee" style="width: 100%; padding-top: 3px;">
                            </div>
                    <div>
                    <table style="width: 100%; text-align:  center;">
                    <tr>
                    <td class="modal-footer" style="text-align: right;">
                        <button type="button" class="btn btn-default" id="Button4" onclick="emp_backpopup();" style="background-color:  paleturquoise;">
                            Back</button>
                    </td>
                    <td class="modal-footer" style="text-align: left;">
                        <button type="button" class="btn btn-default" id="emp_close" onclick="emp_closepopup();" style="background-color:  rosybrown;">
                            Close</button>
                    </td>
                    </tr>
                    </table>
                    </div>
                    <div id="div6" style="width: 35px; top: 0.5%; right: 0%; position: absolute; z-index: 99999;
                        cursor: pointer;">
                        <img src="Images/Close.png" alt="close" onclick="emp_closepopup();" />
                     </div>
                    </div>
                  </div>
               </div>
            </div>
        </div>
        <div class="modal" id="svds_empdetails" role="dialog"; style="display: none;">
            <div class="modal-dialog" style="width: 650px; margin: 30px auto;">
                <div class="modal-content" style="border: 2px solid; border-color: antiquewhite;">
                    <div class="modal-body">
                        <div id="div4" style="border: 4px solid; border-color: aliceblue;">
                            <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                                <span style="font-size: 26px; font-weight: bold;">Employee Wise Payment Information </span>
                            </div>
                            <br />
                            <div id="gsvd_empdtype" style="width: 100%; height:400px; padding-top: 3px; display:none; overflow-y: scroll;">
                            </div>
                            <div id="svds_empdtype" style="width: 100%; height:400px; padding-top: 3px; display:none; overflow-y: scroll;">
                            </div>
                            <div id="svd_empdtype" style="width: 100%; height:400px; padding-top: 3px; display:none; overflow-y: scroll;">
                            </div>
                            <div id="rmrd_empdtype" style="width: 100%; height:400px; padding-top: 3px; display:none; overflow-y: scroll;">
                            </div>
                            <div id="staff_empdtype" style="width: 100%; height:400px; padding-top: 3px; display:none; overflow-y: scroll;">
                            </div>
                            <div id="casual_empdtype" style="width: 100%; height:400px; padding-top: 3px; display:none; overflow-y: scroll;">
                            </div>
                            <br />
                        <asp:Label ID="Label7" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
                    <div class="modal-footer" style="text-align: center;">
                        <button type="button" class="btn btn-default" id="gosvdemp_close" onclick="gosvdemp_closepopup();">
                            Close</button>
                    </div>
                    <div id="div7" style="width: 35px; top: 0.5%; right: 0%; position: absolute; z-index: 99999;
                        cursor: pointer;">
                        <img src="Images/Close.png" alt="close" onclick="gosvdemp_closepopup();" />
                    </div>
                        </div>
                        </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
