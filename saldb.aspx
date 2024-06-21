<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="saldb.aspx.cs" Inherits="saldb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="js/jquery.blockUI.js" type="text/javascript"></script>
    <script src="JSF/jquery.blockUI.js" type="text/javascript"></script>
    <script src="amcharts/amcharts.js" type="text/javascript"></script>
    <script src="amcharts/pie.js" type="text/javascript"></script>
    <script src="amcharts/serial.js" type="text/javascript"></script>
    <script src="amcharts/plugins/export/export.js" type="text/javascript"></script>
    <link href="amcharts/plugins/export/export.css" rel="stylesheet" type="text/css" />
    <script src="amcharts/plugins/export/export.min.js" type="text/javascript"></script>
    <script src="amcharts/themes/light.js"></script>
    <script src="amcharts/themes/dark.js"></script>
    <script src="https://www.amcharts.com/lib/3/themes/none.js"></script>
    <style>
        body
        {
            font-family: 'Source Sans Pro','Helvetica Neue',Helvetica,Arial,sans-serif !important;
            font-weight: 400 !important;
        }
           .btn-glyphicon {
    padding:4px;
    background:#e7baec;
    margin-right:4px;
    color:cornflowerblue;
    font-size:12px;
}
.icon-btn {
    padding: 1px 15px 3px 2px;
    border-radius:50px;
    
}

.blink_me {
    -webkit-animation-name: blinker;
    -webkit-animation-duration: 1s;
    -webkit-animation-timing-function: linear;
    -webkit-animation-iteration-count: infinite;
    
    -moz-animation-name: blinker;
    -moz-animation-duration: 1s;
    -moz-animation-timing-function: linear;
    -moz-animation-iteration-count: infinite;
    
    animation-name: blinker;
    animation-duration: 1s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
}

@-moz-keyframes blinker {  
    0% { opacity: 1.0; }
    50% { opacity: 0.0; }
    100% { opacity: 1.0; }
}

@-webkit-keyframes blinker {  
    0% { opacity: 1.0; }
    50% { opacity: 0.0; }
    100% { opacity: 1.0; }
}

@keyframes blinker {  
    0% { opacity: 1.0; }
    50% { opacity: 0.0; }
    100% { opacity: 1.0; }
}

	html, body {
  width: 100%;
  height: 100%;
  margin: 0px;
}
.amcharts-pie-slice {
  transform: scale(1);
  transform-origin: 50% 50%;
  transition-duration: 0.3s;
  transition: all .3s ease-out;
  -webkit-transition: all .3s ease-out;
  -moz-transition: all .3s ease-out;
  -o-transition: all .3s ease-out;
  cursor: pointer;
  box-shadow: 0 0 30px 0 #000;
}

.amcharts-pie-slice:hover {
  transform: scale(1.1);
  filter: url(#shadow);
}		
						
    </style>
    <script type="text/javascript">
        $(function () {
            var leveltype = '<%=Session["leveltype"] %>';
            if (leveltype == "Admin" || leveltype == "Super Admin") {
                $('#Inwardsilo_fillform').css('display', 'block');
            }
            else {
                $('#Inwardsilo_fillform').css('display', 'none');
            }
            get_CompanyMaster_details();
            //generate_agedetailes();
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txt_Date').val(today);
            // $("#id_navbar").css("display", "none");
        });

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

        function get_emptotinfodetails_details(){
         var data = { 'op': 'get_emptotinfodetails_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcompany(msg);
                        branchnamechange(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function get_CompanyMaster_details() {
            var data = { 'op': 'get_CompanyMaster_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcompany(msg);
                        branchnamechange(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillcompany(msg) {
            var data = document.getElementById('selct_Cmpny');
            var length = data.options.length;
            document.getElementById('selct_Cmpny').options.length = null;
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].CompanyName != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].CompanyName;
                    option.value = msg[i].CompanyCode;
                    data.appendChild(option);
                }
            }
        }

        function branchnamechange() {
            var companyid = document.getElementById('selct_Cmpny').value;
            //$("#slct_branchtype").css("display", "none");
            var data = { 'op': 'get_compaywisebranchname_fill', 'companyid': companyid };
            var s = function (msg) {
                if (msg) {
                    //if (msg.length > 0) {
                        fillbranch(msg);
                        generate_report();
                   // }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fillbranch(msg) {
            var data = document.getElementById('slct_branchtype');
            var length = data.options.length;
            document.getElementById('slct_branchtype').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "ALL";
            opt.value = "ALL";
            opt.setAttribute("selected", "selected");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].branchname;
                    option.value = msg[i].branchid;
                    data.appendChild(option);
                }
            }
        }
        function generate_report() {
            generate_branchwisepiechart();
            get_attendancedetailsrpt();
            generate_attadancebarchart();
            //generate_agedetailes();
            totalbranch();
            $("#divattendance").css("display", "none");
            $("#divdashboard").css("display", "block");
        }
        function get_attendancedetailsrpt() {
            var branchid = document.getElementById('slct_branchtype').value;
            var company_code = document.getElementById("selct_Cmpny").value;
            var doe = document.getElementById('txt_Date').value;
            var data = { 'op': 'get_branchwise_attandance', 'branchid': branchid, 'doe': doe, 'company_code': company_code };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
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
        function filldetails(msg) {
            var l = 0;
            //            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            tootattendance = msg[0].totallist;
            var branchname = document.getElementById('slct_branchtype').value;
            var results = '<div style="overflow:auto;"><table  id="example2" class="table table-bordered table-hover "role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col"  ></th><th>BRANCH NAME</th><th scope="col">TotalEmp</th><th scope="col" >Present</th><th scope="col" >Absent</th></tr></thead></tbody>';
            for (var k = 0; k < msg.length; k++) {//<input id="btn_poplate" type="button"  onclick="viewdept_details(this)" name="submit" class="btn btn-primary" value="ViewDept" />
                if (msg[k].presentemployes == "0") {
                    results += '<tr   ><td><span id="btn_poplate"  onclick="viewdept_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                    results += '<th class="blink_me" title="' + msg[k].msg + '"  style="background-color:#42c5f4; font-size: 12px;" scope="row"  class="1">' + msg[k].branchname + '</th>';
                    results += '<td style="font-size: 12px;" class="2">' + msg[k].totalemployes + '</td>';
                    results += '<td style="font-size: 12px;" class="3">' + msg[k].presentemployes + '</td>';
                    results += '<td style="font-size: 12px;"  class="4">' + msg[k].absentemployes + '</td>';
                    results += '<td style="display:none;" id="parent" class="5">' + msg[k].branch_id + '</td>'
                    results += '</tr>';
                }
                else {
                    results += '<tr  ><td><span id="btn_poplate"  onclick="viewdept_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                    results += '<th  style="font-size: 12px; scope="row"  class="1">' + msg[k].branchname + '</th>';
                    results += '<td style="font-size: 12px; class="2">' + msg[k].totalemployes + '</td>';
                    results += '<td style="font-size: 12px;  class="3">' + msg[k].presentemployes + '</td>';
                    results += '<td style="font-size: 12px; class="4">' + msg[k].absentemployes + '</td>';
                    results += '<td style="display:none;" class="5">' + msg[k].branch_id + '</td>'
                    results += '</tr>';
                }
            }
            //}
            results += '</table></div>';
            $("#divtbldata").html(results);
        }




        function viewdept_details(thisid) {
            $("#divattendance").css("display", "block");
            $('html, body').animate({
                scrollTop: $("#divattendance").offset().top
            }, 2000);
            $('#divattendance').focus();
            var branchid = $(thisid).parent().parent().children('.5').html();
            var doe = document.getElementById('txt_Date').value;
            var data = { 'op': 'dept_wise_attandance_details', 'branchid': branchid, 'doe': doe };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        deptdetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function viewmore_details() {
            $("#divattendance").css("display", "block");
            var branchid = document.getElementById('slct_branchtype').value;
            var doe = document.getElementById('txt_Date').value;
            var data = { 'op': 'dept_wise_attandance_details', 'branchid': branchid, 'doe': doe };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        deptdetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);

        }

        function deptdetails(msg) {
            var l = 0;
            //            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" >Dept Name</th><th scope="col">TotalEmp</th><th scope="col">Present </th><th scope="col">Absent </th></tr></thead></tbody>';
            for (var k = 0; k < msg.length; k++) {
                results += '<tr >';
                results += '<th scope="row"  class="1"><span id="spninqty"  onclick="get_DeptemployeesAttendence(this);"><i class="fa fa-arrow-circle-right" style="width: 22px;" aria-hidden="true"></i><span style="text-decoration: none;">' + msg[k].deptname + '</th>';
                results += '<td class="2" style="display:none">' + msg[k].branch + '</td>';
                results += '<td class="3" style="display:none">' + msg[k].deptid + '</td>';
                results += '<td class="4" >' + msg[k].totalemployes + '</td>';
                results += '<td  class="5" >' + msg[k].presentemployes + '</td>';
                results += '<td  class="6" >' + msg[k].absentemployes + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divattendance").html(results);
        }

        function generate_branchwisepiechart() {
            var branchid = document.getElementById('slct_branchtype').value;
            var company_code = document.getElementById("selct_Cmpny").value;
            var doe = document.getElementById('txt_Date').value;
            var data = { 'op': 'get_branchwise_attandance_details', 'branchid': branchid, 'doe': doe, 'company_code': company_code };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        createChart(msg);
                        //createbarChart(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function generate_attadancebarchart() {
            var branchid = document.getElementById('slct_branchtype').value;
            var company_code = document.getElementById("selct_Cmpny").value;
            var doe = document.getElementById('txt_Date').value;
            var data = { 'op': 'generate_attadancebarchart', 'branchid': branchid, 'doe': doe, 'company_code': company_code };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        createbarChart(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        var noofemp = "";
        function totalbranch() {
            var branchid = document.getElementById('slct_branchtype').value;
            var company_code = document.getElementById("selct_Cmpny").value;
            var doe = document.getElementById('txt_Date').value;
            var data = { 'op': 'Total_branches_details', 'branchid': branchid, 'doe': doe, 'company_code': company_code };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        branchdetales(msg);
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
        function branchdetales(msg) {
            var branches = msg[0].totalbranches;
            var employees = msg[0].totalemployes;
            var present = msg[0].totalpresent;
            var absent = msg[0].totalabsent;
            var leaveapproval = msg[0].totalleaveapproval;
            var leavepennding = msg[0].totalleavepending;
            var odapproval = msg[0].totalodapproval;
            var odpennding = msg[0].totalodpending;

            document.getElementById('txt_totalbranches').innerHTML = branches;
            document.getElementById('txt_employees').innerHTML = employees;
            document.getElementById('txt_prsent').innerHTML = present;
            document.getElementById('txt_absent').innerHTML = absent;
            document.getElementById('txt_leaveapprove').innerHTML = leaveapproval;
            document.getElementById('txt_leapendding').innerHTML = leavepennding;
            document.getElementById('txt_odapporval').innerHTML = odapproval;
            document.getElementById('txt_odpennding').innerHTML = odpennding;
        }


        var newXarray = [];
        function createChart(databind) {
            //            $("#chart").empty();
            newXarray = [];
            var value = databind[0].absent;
            var name = databind[0].present;
            for (var i = 0; i < name.length; i++) {
                newXarray.push({ "category": name[i], "value": parseFloat(value[i]) });
            }
            var chart = AmCharts.makeChart("chart", {
                "type": "pie",
                "startDuration": 0,
                "theme": "light",
                "addClassNames": true,
                "labelRadius": -35,
                "labelText": "",
                "legend": {
                    "align": "center",
                    "position": "bottom",
                    "marginRight": 21,
                    "markerType": "circle",
                    "right": -20,
                    "labelText": "[[title]]",
                    "valueText": "",
                    "valueWidth": 80,
                    "textClickEnabled": true,
                    "labelsEnabled": false,
                    "autoMargins": false,
                    "marginTop": 0,
                    "marginBottom": 0,
                    "marginLeft": 0,
                    "marginRight": 0,
                    "pullOutRadius": 0,
                     fontSize: 9,
                      fontweight: "bold",
                },
                "innerRadius": "30%",
                "defs": {
                    "filter": [{
                        "id": "shadow",
                        "width": "200%",
                        "height": "200%",
                        "feOffset": {
                            "result": "offOut",
                            "in": "SourceAlpha",
                            "dx": 0,
                            "dy": 0
                        },
                        "feGaussianBlur": {
                            "result": "blurOut",
                            "in": "offOut",
                            "stdDeviation": 5
                        },
                        "feBlend": {
                            "in": "SourceGraphic",
                            "in2": "blurOut",
                            "mode": "normal"
                        }
                    }]
                },
                "dataProvider": newXarray,
                "valueField": "value",
                "titleField": "category",
                "export": {
                    "enabled": true
                }
            });

        }

        var newXarray = [];
        function createbarChart(databind) {
            //             $("#divbarchart").empty();

            var value = databind[0].present;
            var name = databind[0].branchname;
            var newYarray = [];
            var newXarray = [];
            var myData = [];
            if (databind.length > 0) {
                //                 for (var k = 0; k < name.length; k++) {
                var BranchName = [];
                xname = databind[0].branchname;
                xvalue = databind[0].present;
                color = ["#ff8000", "#ffff00", "#bfff00", "#40ff00", "#00ffbf", "#00bfff", "#4000ff", "#00ffff", "#0D52D1", "#8A0CCF", "#CD0D74", "#754DEB", "#DDDDDD", "#999999", "#333333", "#000000"];
                for (var i = 0; i < name.length; i++) {
                    myData.push({ "branchname": xname[i].toString(), "count": parseInt(xvalue[i]), "color": color[i] });

                }
                //                 }
            }
            var chart = AmCharts.makeChart("divbarchart", {
                "type": "serial",
                "theme": "light",
                "marginRight": 70,
                dataProvider: myData,
                "valueAxes": [{
                    "axisAlpha": 0,
                    "position": "left",
                    "title": "Visitors from country"
                }],
                "startDuration": 1,
                "graphs": [{
                    "balloonText": "<b>[[category]]: [[value]]</b>",
                    "fillColorsField": "color",
                    "fillAlphas": 0.9,
                    "lineAlpha": 0.2,
                    "type": "column",
                    "valueField": "count"
                }],
                "chartCursor": {
                    "categoryBalloonEnabled": false,
                    "cursorAlpha": 0,
                    "zoomable": false
                },
                "categoryField": "branchname",
                "categoryAxis": {
                    "gridPosition": "start",
                    "labelRotation": 45
                },
                "export": {
                    "enabled": true
                }

            });

        }



        function get_DeptemployeesAttendence(thisid) {
            $("#att_dep").css("display", "block");
            $("#divattendance").css("display", "block");
            var branchid = $(thisid).parent().parent().children('.2').html();
            var department = $(thisid).parent().parent().children('.3').html();
            var doe = document.getElementById('txt_Date').value;
            var data = { 'op': 'get_DeptemployeesAttendence', 'branchid': branchid, 'doe': doe, 'department': department };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        deptempdetails(msg);
                        Empworkinghoursdetails(thisid);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);

        }

        function deptempdetails(msg) {
            $("#att_emp").css("display", "block");
            var l = 0;
            //             var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;"><th scope="col" >Emp Name</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var k = 0; k < msg.length; k++) {
                if (msg[k].status == "P") {
                    var st = msg[k].empsno + '-' + msg[k].LogDate;
                    results += '<tr >';
                    results += '<th scope="row"  class="1">' + msg[k].employee_name + '</th>';
                    results += '<td data-title="Code" class="2" style="display:none">' + msg[k].status + '</td>';
                    if (msg[k].status == "P") {
                        var status = "Present "
                        results += '<td class="2"><a id="' + msg[k].empsno + '"  onclick="logsclick(\'' + st + '\');" title="' + msg[k].empsno + '"  data-toggle="modal" data-target="#myModal" style="text-decoretion:none" >' + status + '</td>';
                    }
                }
                else {
                    results += '<tr >';
                    results += '<th scope="row"  class="1">' + msg[k].employee_name + '</th>';
                    var status = "Absent "
                    results += '<td data-title="brandstatus" class="1"><a id="' + msg[k].empsno + '"  onclick="clearall();" title="' + msg[k].empsno + '" data-toggle="modal" data-target="#myModal" style="color:red;text:decoretion:none;">' + status + '</a></td>';
                }
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divemployee").html(results);
        }

        function logsclick(st) {
            $("#myModal").css("display", "block");
            // var empid = $(thisid).closest("tr").find('#txtemp').val();
            var empid = st;
            var data = { 'op': 'get_bimetriclogdetails_details', 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbiologs(msg)
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillbiologs(msg) {
            $("#divodpendata").css("display", "none");
            $("#divodAppdata").css("display", "none");
            $("#divpendingleaves").css("display", "none");
            $("#divlogs").css("display", "block");
            $("#divleaves").css("display", "none");
            $("#myModal").css("display", "block");
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var k = 1;
            var l = 0;
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Log DATE</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td >' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].logdate + '</th>';
                results += '<td data-title="Code" class="2">' + msg[i].Status + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divlogs").html(results);
        }
        function closepopup(msg) {
            $("#myModal").css("display", "none");
        }
        function clearall(){
         $("#divodpendata").css("display", "none");
            $("#divodAppdata").css("display", "none");
            $("#divpendingleaves").css("display", "none");
            $("#divlogs").css("display", "block");
            $("#divleaves").css("display", "none");
            $("#myModal").css("display", "block");
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var k = 1;
            var l = 0;
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
//            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Log DATE</th><th scope="col">Status</th></tr></thead></tbody>';
//            for (var i = 0; i < msg.length; i++) {
//                results += '<tr style="background-color:' + COLOR[l] + '"><td >' + k++ + '</td>';
//                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].logdate + '</th>';
//                results += '<td data-title="Code" class="2">' + msg[i].Status + '</td>';
//                results += '</tr>';
//                l = l + 1;
//                if (l == 4) {
//                    l = 0;
//                }
//            }
            results += '</table></div>';
            $("#divlogs").html(results);
        }
        function Empworkinghoursdetails(thisid) {
            var type = "piechart";
            var time = "Day";
            var branch = $(thisid).parent().parent().children('.2').html();
            var department = $(thisid).parent().parent().children('.3').html();
            var fromdate = document.getElementById('txt_Date').value;
            var todate = document.getElementById('txt_Date').value
            if (fromdate == "") {
                alert("Please select from date");
                return false;
            }
            if (todate == "") {
                alert("Please select to date");
                return false;
            }
            var data = { 'op': 'get_empwork_details_click', 'branch': branch, 'department': department, 'fromdate': fromdate, 'todate': todate, 'time': time, 'type': type };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        createworkinghoursChart(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var newXarray = [];
        function createworkinghoursChart(databind) {
            //            $("#chart").empty();
            newXarray = [];
            var name = databind[0].empname;
            var value = databind[0].workhours;
            for (var i = 0; i < name.length; i++) {
                newXarray.push({ "category": name[i], "value": parseFloat(value[i]) });
            }
            var chart = AmCharts.makeChart("workingchart", {
                "type": "pie",
                "startDuration": 0,
                "theme": "light",
                "addClassNames": true,
                "labelRadius": -35,
                "labelText": "",
                "legend": {
                    "align": "center",
                    "position": "bottom",
                    "marginRight": 21,
                    "markerType": "circle",
                    "right": -4,
                    "labelText": "",
                    "valueText": " [[title]] [[value]]",
                    "valueWidth": 100,
                    "labelWidth": 50,
                    "textClickEnabled": true

                },
                "innerRadius": "30%",
                "defs": {
                    "filter": [{
                        "id": "shadow",
                        "width": "200%",
                        "height": "200%",
                        "feOffset": {
                            "result": "offOut",
                            "in": "SourceAlpha",
                            "dx": 0,
                            "dy": 0
                        },
                        "feGaussianBlur": {
                            "result": "blurOut",
                            "in": "offOut",
                            "stdDeviation": 5
                        },
                        "feBlend": {
                            "in": "SourceGraphic",
                            "in2": "blurOut",
                            "mode": "normal"
                        }
                    }]
                },
                "dataProvider": newXarray,
                "valueField": "value",
                "titleField": "category",
                "export": {
                    "enabled": true
                }
            });
        }

        function leavedetails() {
            var fromdate = document.getElementById('txt_Date').value;
            var todate = document.getElementById('txt_Date').value
            var data = { 'op': 'Gettodayleavedetails', 'fromdate': fromdate, 'todate': todate };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillleaveApprovedetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillleaveApprovedetails(msg) {
            $("#divpendingleaves").css("display", "none");
            $("#divlogs").css("display", "none");
            $("#divodpendata").css("display", "none");
            $("#divodAppdata").css("display", "none");
            $("#divleaves").css("display", "block");
            $("#myModal").css("display", "block");
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Employee Name</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                var status = msg[i].status;
                if (status == "Approved") {
                    results += '<tr style="background-color:' + COLOR[l] + '"><td >' + k++ + '</td>';
                    results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empname + '</th>';
                    results += '<td data-title="Code" class="2">' + msg[i].status + '</td>';
                    results += '</tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#divleaves").html(results);
        }
        function pendingleavedetails() {
            var fromdate = document.getElementById('txt_Date').value;
            var todate = document.getElementById('txt_Date').value
            var data = { 'op': 'Gettodayleavedetails', 'fromdate': fromdate, 'todate': todate };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillleavePendingdetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillleavePendingdetails(msg) {
            $("#divpendingleaves").css("display", "block");
            $("#divodpendata").css("display", "none");
            $("#divodAppdata").css("display", "none");
            $("#divlogs").css("display", "none");
            $("#divleaves").css("display", "none");
            $("#myModal").css("display", "block");
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Employee Name</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                var status = msg[i].status;
                if (status == "Pending") {
                    results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                    results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empname + '</th>';
                    results += '<td data-title="Code" class="2">' + msg[i].status + '</td>';
                    results += '</tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#divpendingleaves").html(results);
        }
        function closepopup(msg) {
            $("#myModal").css("display", "none");
        }



        var meetingdetails = [];
        function getapprovedOddetails() {
            var fromdate = document.getElementById('txt_Date').value;
            var todate = document.getElementById('txt_Date').value;
            var formtype = "Meetingreport";
            var data = { 'op': 'get_od_details', 'fromdate': fromdate, 'todate': todate, 'formtype': formtype };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillOddetails(msg);
                        //fillMeetingdetails(msg);
                        meetingdetails = msg;
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillOddetails(msg) {
            $("#divpendingleaves").css("display", "none");
            $("#divodpendata").css("display", "none");
            $("#divodAppdata").css("display", "block");
            $("#divlogs").css("display", "none");
            $("#divleaves").css("display", "none");
            $("#myModal").css("display", "block");
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Employee Name</th><th scope="col">Reporting</th><th scope="col">Status</th></tr></thead></tbody>';
            var l = 0;
            var k = 1;

            for (var i = 0; i < msg.length; i++) {
                if (msg[i].status=="A") {
                    results += '<tr style="background-color:' + COLOR[l] + '" ><th></th>'
                results += '<th  scope="row" class="1"  style="display:none">' + msg[i].sno + '</th>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].fullname + '</td>';
                results += '<td data-title="brandstatus" class="3">' + msg[i].status + '</td>';
                results += '<td data-title="brandstatus" class="4">' + msg[i].totaldays + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
                }
            }
            results += '</table></div>';
            $("#divodAppdata").html(results);
        }
        var meetingdetails = [];
        function getpendingOddetails() {
            var fromdate = document.getElementById('txt_Date').value;
            var todate = document.getElementById('txt_Date').value;
            var formtype = "Meetingreport";
            var data = { 'op': 'get_od_details', 'fromdate': fromdate, 'todate': todate, 'formtype': formtype };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillpendingdetails(msg);
                        //fillMeetingdetails(msg);
                        meetingdetails = msg;
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillpendingdetails(msg) {
            $("#divpendingleaves").css("display", "none");
            $("#divodpendata").css("display", "block");
            $("#divodAppdata").css("display", "none");
            $("#divlogs").css("display", "none");
            $("#divleaves").css("display", "none");
            $("#myModal").css("display", "block");
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Employee Name</th><th scope="col">Status</th><th scope="col">Total Days</th></tr></thead></tbody>';
            var l = 0;
            var k = 1;

            for (var i = 0; i < msg.length; i++) {
                if (msg[i].status == "P") {
                    results += '<tr style="background-color:' + COLOR[l] + '"><th></th>'
                    results += '<th  scope="row" class="1"  style="display:none">' + msg[i].sno + '</th>';
                    results += '<td data-title="brandstatus" class="2">' + msg[i].fullname + '</td>';
                    results += '<td data-title="brandstatus" class="3">' + msg[i].status + '</td>';
                    results += '<td data-title="brandstatus" class="4">' + msg[i].totaldays + '</td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#divodpendata").html(results);
        }
    </script>
    <style>
        .small-box .icon
        {
            -webkit-transition: all .3s linear;
            -o-transition: all .3s linear;
            transition: all .3s linear;
            position: absolute;
            top: 5px;
            right: 10px;
            z-index: 0;
            font-size: 90px;
            color: rgba(0,0,0,0.15);
        }
    </style>
</asp:Content>
<asp:content id="Content2" contentplaceholderid="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $('body').addClass('hold-transition sidebar-mini skin-blue  sidebar-collapse');
    </script>
    <div class="cover" style="background-color: #F0F8FF">
        <section class="content">
        <div >
            <div class="box-body">
            <div class="box box-info">
                <div id='Inwardsilo_fillform' style="padding-left: 10%; padding-top: 1%;">
                    <table>
                        <tr>
                           <td>
                             <label class="control-label" >
                                    Company Name</label>
                                <select id="selct_Cmpny" class="form-control" onchange="branchnamechange()" style="border-radius: 0px; important">
                                    <option selected disabled value="Select state">Select company</option>
                                </select>
                            </td>
                            <td>
                                <label class="control-label" >Branch Name</label>
                                <select id="slct_branchtype" class="form-control" style="border-radius: 0px; important"> 
                                </select>
                            </td>
                            <td>
                                <label class="control-label" >
                                    Date</label>
                                <input type="date" class="form-control" id="txt_Date" style="border-radius: 0px; important"/>
                            </td>
                           <%-- <td>
                                <input id='btn_generate' type="button" class="btn btn-success" name="submit" value='Genarate'
                                    onclick="generate_report()" />
                            </td>--%>
                            <td style="padding-top: 4%;">
                                <div class="input-group">
                                <div class="input-group-addon" style="border-color: #3c8dbc;background-color: #3c8dbc;border-radius: 4px;color: whitesmoke;">
                                <span class="glyphicon glyphicon-flash" onclick="generate_report();"  ></span> <span id="btn_generate"  onclick="generate_report();">Genarate</span>
                          </div>
                          </div>
                           </td>
                        </tr>
                    </table>
                    <br />
                </div>
                
             <div id="example" >
             <div id="divdashboard" style="display:none">
                <div class="row">
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-aqua">
                            <div class="inner">
                                <h3 id="txt_totalbranches"></h3>
                                <p>Total Branches</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-cubes"></i>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="a_vehicles_moreinfo('all');">Total Branches</a>
                        </div>
                    </div>
                    <!-- ./col -->
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-purple">
                            <div class="inner">
                                <h3 id="txt_employees"></h3>
                                <p>Employees</p>
                            </div>
                            <div class="icon">
                                <i class="ion ion-person-add"></i>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="a_vehicles_moreinfo('running');">Total Employees </a>
                        </div>
                    </div>
                    <!-- ./col -->
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-green">
                            <div class="inner">
                                <h3 id="txt_prsent"></h3>
                                <p>Present</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-thumbs-o-up"></i>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="a_vehicles_moreinfo('stopped');">Total Present</a>
                        </div>
                    </div>
                    <!-- ./col -->
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-red">
                            <div class="inner">
                                <h3 id="txt_absent"></h3>
                                <p>Absent</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-thumbs-o-down"></i>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="a_vehicles_moreinfo('delayupdate');">Total Absent </a>
                        </div>
                    </div>
                    <!-- ./col -->
                </div>
                <div class="row">
                      <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-olive">
                            <div class="inner">
                                <h3 id="txt_leaveapprove"></h3>
                                <p>Total Approval</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-user"></i>
                            </div>
                            <a  class="small-box-footer" onclick="leavedetails();" data-toggle="modal" data-target="#myModal">Total Leave Approval <i class="fa fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-teal">
                            <div class="inner">
                                <h3 id="txt_leapendding"></h3>
                                <p>Leave Pending</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-user-times"></i>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="pendingleavedetails();" data-toggle="modal" data-target="#myModal">Total Leave Pending <i class="fa fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <!-- ./col -->
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-yellow">
                            <div class="inner">
                                <h3 id="txt_odapporval"></h3>
                                <p>OD Approval </p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-check-square"></i>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="getapprovedOddetails();" data-toggle="modal" data-target="#myModal">Total OD Approval  <i class="fa fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <!-- ./col -->
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-blue">
                            <div class="inner">
                                <h3 id="txt_odpennding"></h3>
                                <p>OD Pending </p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-ban"></i>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="getpendingOddetails();" data-toggle="modal" data-target="#myModal">Total OD Pending  <i class="fa fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <!-- ./col -->
                </div>
                </div>
                 </div>
                 <div class="row">
                 <div class="col-sm-6">
                  <div class="box box-solid bg-light-blue-gradient" style=" background: linear-gradient(to bottom, #ccffff 0%, #ffffff 100%);">
                     <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="ion ion-pie-graph"></i>Attendence By Branch</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                    <div class="box-body no-padding" style="height: 400px;">
                       <div id="chart" style="height: 400px; ">
                     </div>
                    </div>
                   </div>
                  </div>
                 </div>
                 <div  id="datagrid" class="col-sm-6">
                     <div class="box box-solid box-success">
                        <div class="box-header with-border">
                           <h3 class="box-title">
                            <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Attendence By  Branch</h3>
                             <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="table-responsive"  >
                            <div id="divtbldata" style="height: 400px; overflow-y: scroll;">
                     </div>
                    </div>
                   </div>
                  </div>
                 </div>
                 </div>
                <div class="row">
                 <div class="col-sm-6" id="att_dep" >
            <div class="box box-solid box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Attendence By Department</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px; ">
                         <div id="divattendance" style="height: 300px; overflow-y: scroll;">
            </div>
                         </div>
                        </div>
                    </div>
                    </div>
                    <div class="col-sm-6" id="att_emp" >
            <div class="box box-solid box-warning">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Employee Details By Department</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px; ">
                         <div id="divemployee" style="height: 300px; overflow-y: scroll;">
            </div>
                         </div>
                        </div>
                    </div>
                    </div>
                </div>
            <div class="row">
                    <div class="col-sm-6" id="Div1" style="display:none" >
            <div class="box box-solid " style=" background: linear-gradient(to bottom, #99ffcc 0%, #ccff66 100%)">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-fw fa-user"></i>Empdetails By Department</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 400px; ">
                         <div id="workingchart" style="height: 400px; ">
            </div>
                         </div>
                        </div>
                    </div>
                    </div>
                    </div>
                    <div >
                    <div class="box box-solid bg-purple-gradient">
                        <div class="box-header with-border">
                          <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-bar-chart"></i>Attendence By Branch</h3>
                           <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                    <div class="box-body no-padding" style="height: 300px;">
                      <div id="divbarchart" style="height: 300px;">
                      </div>
                    </div>
                   </div>
                  </div>
                 </div>
                </div>
                </div>
       </div>
   <div class="modal" id="myModal" role="dialog" style="overflow:auto;">
    <div class="modal-dialog">
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background: linear-gradient(to right, #66ccff 0%, #ccffff 100%)">
          <h4 class="modal-title"> Logs Details</h4>
        </div>
        <div class="modal-body">
          <table align="center">
                        <tr>
                            <td colspan="4">
                                <div id="divleaves">
                                </div>
                                <div id="divpendingleaves">
                                </div>
                                <div id="divodAppdata">
                                </div>
                                <div id="divodpendata">
                                </div>
                                <div id="divlogs">
                                </div>
                            </td>
                        </tr>
                    </table>
        </div>
        <div class="modal-footer" style="background: linear-gradient(to right,#ccffff 0%, #66ccff 100%)">
          <button type="button" class="btn btn-default" id="close" data-dismiss="modal" data-backdrop="false" onclick="closepopup();">Close</button>
        </div>
      </div>
      
    </div>
  </div>
    </section>
    </div>
</asp:content>

