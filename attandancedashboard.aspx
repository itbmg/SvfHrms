<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="attandancedashboard.aspx.cs" Inherits="attandancedashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
   
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
        $(document).keyup(function (e) {
            if (e.keyCode === 27) {
                gosvdemp_closepopup(btn_close2);
            }
        });

        $(document).keyup(function (e) {
            if (e.keyCode === 27) {
                closepopup2(gosvdemp_close);
            }
        });
        function gosvdemp_closepopup(msg) {
            $("#svds_empdetails").css("display", "none");
            $("#class_model").css("display", "block");
            $('#selct_Cmpny').focus();
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
            var opt = document.createElement('option');
            opt.innerHTML = "ALL";
            opt.value = "ALL";
            opt.setAttribute("selected", "selected");
            data.appendChild(opt);
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
            var data = { 'op': 'get_compaywisebranchname_fill', 'companyid': companyid };
            var s = function (msg) {
                if (msg) {
//                        fillbranch(msg);
                        generate_report();
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
         function generate_report() {
            generate_branchwisepiechart();
            get_attendancedetailsrpt();
            generate_attadancebarchart();
            totalbranch();
            $("#att_dep").css("display", "none");
            $("#att_emp").css("display", "none");
            $("#divdashboard").css("display", "block");
        }
            function branchnamechange2() {
            var companyid = document.getElementById('selct_Cmpny').value;
            var data = { 'op': 'get_compaywisebranchname_fill', 'companyid': companyid };
            var s = function (msg) {
                if (msg) {
                        fillbranch(msg);
                        generate_report2();
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
            function generate_report2() {
            generate_branchwisepiechart();
            get_attendancedetailsrpt();
            generate_attadancebarchart();
            totalbranch();
            $("#att_dep").css("display", "none");
            $("#att_emp").css("display", "none");
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
            $("#att_dep").css("display", "block");
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
            var staffemployees = msg[0].totalstaffemployes;
            var casualemployees = msg[0].totalcasualsemployes;
            var present = msg[0].stafftotalpresent;
            var absent = msg[0].totalstaffabsent;
            var leaveapproval = msg[0].totalleaveapproval;
            var leavepennding = msg[0].totalleavepending;
            var odapproval = msg[0].totalodapproval;
            var odpennding = msg[0].totalodpending;

            document.getElementById('txt_totalbranches').innerHTML = branches;
            document.getElementById('txt_employees').innerHTML = employees;
            document.getElementById('txt_staffemployees').innerHTML = staffemployees;
            document.getElementById('txt_casualemployees').innerHTML = casualemployees;
            document.getElementById('txt_prsent').innerHTML = present;
            document.getElementById('txt_absent').innerHTML = absent;
//            document.getElementById('txt_leaveapprove').innerHTML = leaveapproval;
//            document.getElementById('txt_leapendding').innerHTML = leavepennding;
//            document.getElementById('txt_odapporval').innerHTML = odapproval;
//            document.getElementById('txt_odpennding').innerHTML = odpennding;
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
            var chart = AmCharts.makeChart("attendancechart", {
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
            $("#att_emp").css("display", "block");
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
                    var st = msg[k].empsno + '-' + msg[k].Date;
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
        function clearall2(){
         $("#divodpendata").css("display", "none");
            $("#divodAppdata").css("display", "none");
            $("#divpendingleaves").css("display", "none");
            $("#divlogs2").css("display", "block");
            $("#divleaves").css("display", "none");
            $("#myModal2").css("display", "block");
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var k = 1;
            var l = 0;
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';

            results += '</table></div>';
            $("#divlogs2").html(results);
        }
        function clearall3(){
         $("#divodpendata").css("display", "none");
            $("#divodAppdata").css("display", "none");
            $("#divpendingleaves").css("display", "none");
            $("#divlogs3").css("display", "block");
            $("#divleaves").css("display", "none");
            $("#myModal2").css("display", "block");
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var k = 1;
            var l = 0;
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';

            results += '</table></div>';
            $("#divlogs3").html(results);
        }
        function clearall4(){
         $("#divodpendata").css("display", "none");
            $("#divodAppdata").css("display", "none");
            $("#divpendingleaves").css("display", "none");
            $("#divlogs4").css("display", "block");
            $("#divleaves").css("display", "none");
            $("#myModal2").css("display", "block");
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var k = 1;
            var l = 0;
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';

            results += '</table></div>';
            $("#divlogs4").html(results);
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
        
            function gosvd_empdetails_click() {
            $("#svds_empdetails").css("display", "block");
            $("#gsvd_empdtype").css("display", "block");
            $("#gsvd_staffdtype").css("display", "none");
            $("#gsvd_casualdtype").css("display", "none");
            $("#gsvd_staffdtypeabsent").css("display", "none");

            $("#myModal").css("display", "none");
            var company_code = document.getElementById('selct_Cmpny').value;
            var branchid = document.getElementById('slct_branchtype').value;
            var doe = document.getElementById('txt_Date').value;
            var data = { 'op': 'get_branchwise_allempattandance', 'company_code':company_code,'branchid':branchid, 'doe': doe };
            var s = function (msg) {
                if (msg) 
                {
                    if (msg.length > 0) 
                    {
                        fill_empwise_details(msg);
                    }
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_empwise_details(msg) {
            $("#gsvd_empdtype").css("display", "block");
            $("#myModal").css("display", "none");
            var l = 0;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;"><th scope="col" Sno</th><th scope="col" >Emp Name</th><th scope="col">Branch Name</th><th scope="col">Disignation</th><th scope="col">Status</th></tr></thead></tbody>';
            var j = 1;
            for (var k = 0; k < msg.length; k++) {
                if (msg[k].status == "Present") {
                    var st = msg[k].empsno + '-' + msg[k].logdate;
                    results += '<tr>';
                     results += '<td scope="row"  class="1">' +(j++) + '</td>';
                    results += '<td scope="row"  class="1">' + msg[k].fullname + '</td>';
                    results += '<td scope="row"  class="1">' + msg[k].branchname + '</td>';
                    results += '<td scope="row"  class="1">' + msg[k].department + '</td>';
                    results += '<td data-title="Code" class="2" style="display:none">' + msg[k].status + '</td>';
                    if (msg[k].status == "Present") {
                        var status = "Present "
                        results += '<td class="2"><a id="' + msg[k].empsno + '"  onclick="logsclick2(\'' + st + '\');" title="' + msg[k].empsno + '"  data-toggle="modal" data-target="#myModal2" style="text-decoretion:none" >' + status + '</td>';
                    }
                }
                else {
                    results += '<tr>';
                     results += '<td scope="row"  class="1">' +(j++) + '</td>';
                    results += '<th scope="row"  class="1">' + msg[k].fullname + '</th>';
                    results += '<td scope="row"  class="1">' + msg[k].branchname + '</td>';
                    results += '<td scope="row"  class="1">' + msg[k].department + '</td>';
                    var status = "Absent "
                    results += '<th data-title="brandstatus" class="1"><a id="' + msg[k].empsno + '"  onclick="clearall2();" title="' + msg[k].empsno + '" data-toggle="modal" data-target="#myModal2" style="color:red;text:decoretion:none;">' + status + '</a></th>';
                }
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#gsvd_empdtype").html(results);
        }

        function logsclick2(st) {
            $("#myModal2").css("display", "block");
            $("#myModal").css("display", "none");
            var empid = st;
            var data = { 'op': 'get_bimetriclogdetails_details', 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbiologs2(msg)
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
        function fillbiologs2(msg) {
            $("#divodpendata").css("display", "none");
            $("#divodAppdata").css("display", "none");
            $("#divpendingleaves").css("display", "none");
            $("#divlogs2").css("display", "block");
            $("#divlogs3").css("display", "none");
            $("#divlogs4").css("display", "none");
            $("#divlogs5").css("display", "none");
            $("#divleaves").css("display", "none");
            $("#myModal2").css("display", "block");
            $("#myModal").css("display", "none");
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var k = 1;
            var l = 0;
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Log DATE</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td >' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].logdate + '</th>';
                results += '<td data-title="Code" class="2">' + msg[i].Status + '</td>';
//                results += '<td data-title="Code" class="3">' + msg[i].branchname + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divlogs2").html(results);
        }
        function closepopup2(msg) {
            $("#myModal2").css("display", "none");

        }
        function gosvd_staffdetails_click() {
            $("#svds_empdetails").css("display", "block");
            $("#gsvd_empdtype").css("display", "none");
            $("#gsvd_staffdtype").css("display", "block");
            $("#gsvd_casualdtype").css("display", "none");
            $("#gsvd_staffdtypeabsent").css("display", "none");
            $("#myModal").css("display", "none");
            var company_code = document.getElementById('selct_Cmpny').value;
            var branchid = document.getElementById('slct_branchtype').value;
            var doe = document.getElementById('txt_Date').value;
            var data = { 'op': 'get_branchwise_staffattandance', 'company_code':company_code,'branchid':branchid, 'doe': doe };
            var s = function (msg) {
                if (msg) 
                {
                    if (msg.length > 0) 
                    {
                        fill_staffwise_details(msg);
                    }
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_staffwise_details(msg) {
            $("#gsvd_staffdtype").css("display", "block");
            $("#myModal").css("display", "none");
            var j = 1;
            var k=1;
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Employee Name</th><th scope="col" style="text-align:center">Branch</th><th scope="col" style="text-align:center">Disignation</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
            var status=msg[i].status;
            if(status=="Present")
            {
            var st = msg[i].empsno + '-' + msg[i].logdate;
                results += '<tr><td>' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center; display:none;">' + msg[i].empsno + '</th>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].fullname + '</th>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].branchname + '</th>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].department + '</th>';
                results += '<td class="2"><a id="' + msg[i].empsno + '"  onclick="logsclick4(\'' + st + '\');" title="' + msg[i].empsno + '"  data-toggle="modal" data-target="#myModal2" style="text-decoretion:none" >' + status + '</td>';
                results += '</tr>';
            }
            }
            results += '</table></div>';
            $("#gsvd_staffdtype").html(results);
        }
        function logsclick3(st) {
            $("#myModal2").css("display", "block");
            $("#myModal").css("display", "none");
            var empid = st;
            var data = { 'op': 'get_bimetriclogdetails_details', 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbiologs3(msg)
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
        function fillbiologs3(msg) {
            $("#divodpendata").css("display", "none");
            $("#divodAppdata").css("display", "none");
            $("#divpendingleaves").css("display", "none");
            $("#divlogs2").css("display", "none");
            $("#divlogs3").css("display", "block");
            $("#divlogs4").css("display", "none");
            $("#divlogs5").css("display", "none");
            $("#divleaves").css("display", "none");
            $("#myModal2").css("display", "block");
            $("#myModal").css("display", "none");
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var k = 1;
            var l = 0;
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Log DATE</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td >' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].logdate + '</th>';
                results += '<td data-title="Code" class="2">' + msg[i].Status + '</td>';
//                results += '<td data-title="Code" class="3">' + msg[i].branchname + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divlogs3").html(results);
        }
        function closepopup2(msg) {
            $("#myModal2").css("display", "none");

        }

       function gosvd_casualdetails_click() {
            $("#svds_empdetails").css("display", "block");
            $("#gsvd_empdtype").css("display", "none");
            $("#gsvd_staffdtype").css("display", "none");
            $("#gsvd_casualdtype").css("display", "block");
            $("#gsvd_staffdtypeabsent").css("display", "none");
            $("#myModal").css("display", "none");
            var company_code = document.getElementById('selct_Cmpny').value;
            var branchid = document.getElementById('slct_branchtype').value;
            var doe = document.getElementById('txt_Date').value;
            var data = { 'op': 'get_branchwise_casuallattandance', 'company_code':company_code,'branchid':branchid, 'doe': doe };
            var s = function (msg) {
                if (msg) 
                {
                    if (msg.length > 0) 
                    {
                        fill_casualwise_details(msg);
                    }
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function fill_casualwise_details(msg) {
            $("#gsvd_casualdtype").css("display", "block");
            $("#myModal").css("display", "none");
            var l = 0;
            var k = 1;
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Employee Name</th><th scope="col" style="text-align:center">Branch</th><th scope="col" style="text-align:center">Disignation</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) 
            {
                    var status=msg[i].status;
                    if(status=="Present")
                    {
                        var st = msg[i].empsno + '-' + msg[i].logdate;
                        results += '<tr><td>' + k++ + '</td>';
                        results += '<th scope="row" class="1" style="text-align:center; display:none;">' + msg[i].empsno + '</th>';
                        results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].fullname + '</th>';
                        results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].branchname + '</th>';
                        results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].department + '</th>';
                        results += '<td class="2"><a id="' + msg[i].empsno + '"  onclick="logsclick4(\'' + st + '\');" title="' + msg[i].empsno + '"  data-toggle="modal" data-target="#myModal2" style="text-decoretion:none" >' + status + '</td>';
                        results += '</tr>';
                   }
                else {
                    results += '<tr><td>' + k++ + '</td>';
                    results += '<th scope="row" class="1" style="text-align:center; display:none;">' + msg[i].empsno + '</th>';
                    results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].fullname + '</th>';
                    results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].branchname + '</th>';
                    results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].department + '</th>';
                    results += '<td class="2"><a id="' + msg[i].empsno + '"  onclick="logsclick4(\'' + st + '\');" title="' + msg[i].empsno + '"  data-toggle="modal" data-target="#myModal2" style="color:red;text:decoretion:none;">' + "Absent" + '</td>';
                    results += '</tr>';
              }
           }
            results += '</table></div>';
            $("#gsvd_casualdtype").html(results);
         }
            function logsclick4(st) {
            $("#myModal2").css("display", "block");
            $("#myModal").css("display", "none");
            var empid = st;
            var data = { 'op': 'get_bimetriclogdetails_details', 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbiologs4(msg)
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
        function fillbiologs4(msg) {
            $("#divodpendata").css("display", "none");
            $("#divodAppdata").css("display", "none");
            $("#divpendingleaves").css("display", "none");
            $("#divlogs2").css("display", "none");
            $("#divlogs3").css("display", "none");
            $("#divlogs4").css("display", "block");
            $("#divlogs5").css("display", "none");
            $("#divleaves").css("display", "none");
            $("#myModal2").css("display", "block");
            $("#myModal").css("display", "none");
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var k = 1;
            var l = 0;
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Log DATE</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td >' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].logdate + '</th>';
                results += '<td data-title="Code" class="2">' + msg[i].Status + '</td>';
//                results += '<td data-title="Code" class="3">' + msg[i].branchname + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divlogs4").html(results);
        }
        function closepopup2(msg) {
            $("#myModal2").css("display", "none");

        }
        function gosvd_staffabsentdetails_click() {
            $("#svds_empdetails").css("display", "block");
            $("#gsvd_empdtype").css("display", "none");
            $("#gsvd_staffdtype").css("display", "none");
            $("#gsvd_casualdtype").css("display", "none");
            $("#gsvd_staffdtypeabsent").css("display", "block");
            $("#myModal").css("display", "none");
            $("#myModal2").css("display", "none");
            var company_code = document.getElementById('selct_Cmpny').value;
            var branchid = document.getElementById('slct_branchtype').value;
            var doe = document.getElementById('txt_Date').value;
            var data = { 'op': 'get_branchwise_staffattandance', 'company_code':company_code,'branchid':branchid, 'doe': doe };
            var s = function (msg) {
                if (msg) 
                {
                    if (msg.length > 0) 
                    {
                        fill_staffwiseabsent_details(msg);
                    }
                    else{
                    msg = 0;
                    fill_staffwiseabsent_details(msg);

                    }
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        //-----------test--------------//
            function fill_staffwiseabsent_details(msg) {
            $("#gsvd_staffdtypeabsent").css("display", "block");
            $("#myModal").css("display", "none");
            $("#myModal2").css("display", "none");
            $("#gsvd_staffdtype").css("display", "none");
            $("#myModal").css("display", "none");
            var j = 1;
            var k=1;
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Employee Name</th><th scope="col" style="text-align:center">Branch</th><th scope="col" style="text-align:center">Disignation</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) 
            {
                   var status=msg[i].status;
                   if(status=="Present")
                   {
                   }
                  else {
                      var st = msg[i].empsno + '-' + msg[i].logdate;
                      results += '<tr><td>' + k++ + '</td>';
                      results += '<th scope="row" class="1" style="text-align:center; display:none;">' + msg[i].empsno + '</th>';
                      results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].fullname + '</th>';
                      results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].branchname + '</th>';
                      results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].department + '</th>';
                      results += '<th data-title="brandstatus" class="1"><a  title="' + msg[i].empsno + '" style="color:red;text:decoretion:none;">' + status + '</a></th>';
                      results += '</tr>';
                 }
            }
            results += '</table></div>';
            $("#gsvd_staffdtypeabsent").html(results);
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $('body').addClass('hold-transition sidebar-mini skin-blue  sidebar-collapse');
    </script>
    <div class="cover" style="background-color: #F0F8FF">
        <div id="class_model">
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
                                <select id="selct_Cmpny" class="form-control" onchange="branchnamechange(); branchnamechange2();" style="border-radius: 0px; important">
                                    <option selected disabled value="Select state">Select company</option>
                                </select>
                            </td>
                            <td>
                                <label class="control-label" >Branch Name</label>
                                <select id="slct_branchtype" class="form-control" <%--onchange="generate_report();"--%> style="border-radius: 0px; important">
                                 <option selected value="ALL">ALL</option>
                                  </select>
                            </td>
                            <td>
                                <label class="control-label" >
                                    Date</label>
                                <input type="date" class="form-control" id="txt_Date" <%--onchange="generate_report();"--%> style="border-radius: 0px; important"/>
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
                        <div class="small-box bg-blue" style="height: 127px;">
                            <div class="inner" style="height: 104px;text-align:  center;">
                            <table style="text-align:  center;height: 100px;">
                            <tr>
                             <td style="width: 187px;">
                            <p style="font-size: 26px;">Total Branches</p>
                            </td>
                            <td>
                                <h3 id="txt_totalbranches"></h3>
                                </td>
                                </tr>
                                </table>
                            </div>
                            <div class="icon">
                                <i class="fa fa-thumbs-o-up"></i>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="gosvd_empdetails_click('delayupdate');">All Employe Attendance </a>
                        </div>
                    </div>
                    <!-- ./col -->


                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-purple"  style="height: 100%;width: 100%;">
                        <table style="height:  100%;">
                        <tr>
                        <td style="width: 40%;border-right:  1px solid;">
                        <div class="inner" style="width: 110px;text-align:  center;height: 65px;">
                        <p style="text-align:  center;">Total Employees</p>
                                <h3 id="txt_employees" style="text-align:  center;"></h3>
                            </div>
                            </td>
                             <td style="width: 100px;">
                             <table style="width: 100%; height:100%;">
                             <tbody>
                             <tr>
                             <td>
                                <p>Total Staff</p>
                                </td>
                            <td>
                                <h3 id="txt_staffemployees"></h3>
                                </td>
                            
                            </tr>
                            <tr>
                            <td>
                                <p>Total Casuals</p>
                                </td>
                            <td>
                                <h3 id="txt_casualemployees"></h3>
                                </td>
                            </tr>
                            </tbody>
                            </table>
                            </td>
                            </tr>
                            </table>
                            <div class="icon">
                                <i class="ion ion-person-add"></i>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="gosvd_casualdetails_click('delayupdate');"> casuals Attendance </a>
                        </div>
                    </div>


                    <!-- ./col -->
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-green"  style="height: 127px;">
                            <div class="inner" style="height: 104px;text-align:  center;">
                            <table style="text-align:  center;height: 100px;">
                            <tr>
                            <td style="width: 187px;">
                            <p style="font-size: 26px;">Staff Present</p>
                            </td>
                            <td>
                                <h3 id="txt_prsent"></h3>
                                </td>
                                </tr>
                                </table>
                            </div>
                            <div class="icon">
                                <i class="fa fa-thumbs-o-up"></i>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="gosvd_staffdetails_click('delayupdate');">Staff Prasent </a>
                        </div>
                    </div>
                    <!-- ./col -->
                    <div class="col-lg-3 col-xs-6">
                        <!-- small box -->
                        <div class="small-box bg-red"  style="height: 127px;">
                            <div class="inner" style="height: 104px;text-align:  center;">
                            <table style="text-align:  center;height: 100px;">
                            <tr>
                             <td style="width: 187px;">
                            <p style="font-size: 26px;">Staff Absent</p>
                            </td>
                            <td>
                                <h3 id="txt_absent"></h3>
                                </td>
                                </tr>
                                </table>
                            </div>
                            <div class="icon">
                                <i class="fa fa-thumbs-o-down"></i>
                            </div>
                            <a href="#datagrid" class="small-box-footer" onclick="gosvd_staffabsentdetails_click('delayupdate');">Staff Absent </a>
                        </div>
                    </div>
                </div>
                </div>
                 </div>
                 <div class="row">
                 <div class="col-sm-6">
                  <div class="box box-solid bg-light-blue-gradient" style=" background: linear-gradient(to bottom, #ccffff 0%, #ffffff 100%);">
                     <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="ion ion-pie-graph"></i>Staff Attendence By Branch</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                    <div class="box-body no-padding" style="height: 400px;">
                       <div id="attendancechart" style="height: 400px; ">
                     </div>
                    </div>
                   </div>
                  </div>
                 </div>
                 <div  id="datagrid" class="col-sm-6">
                     <div class="box box-solid box-success">
                        <div class="box-header with-border">
                           <h3 class="box-title">
                            <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Total Attendence By  Branch</h3>
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
                 <div class="col-sm-6" id="att_dep" style="display:none;" >
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
                    <div class="col-sm-6" id="att_emp" style="display:none;">
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
                    <div style="display:none;">
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
   <div class="modal" id="myModal" role="dialog" style="overflow:auto; display:none;">
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
        </div>
  <div class="modal" id="svds_empdetails" role="dialog"; style="display: none;">
        <div class="modal-dialog" style="width: 650px; margin: 30px auto;">
            <div class="modal-content" style="border: 2px solid; border-color: antiquewhite;">
                <div class="modal-body" id="div_boarder1">
                    <div class="modal-body">
                        <div id="div4" style="border: 4px solid; border-color: aliceblue;">
                            <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                                <span style="font-size: 26px; font-weight: bold;">Employee Wise Attendance Information
                                </span>
                            </div>
                            <br />
                            <div id="gsvd_empdtype" style="width: 100%; height: 400px; padding-top: 3px; display: none;
                                overflow-y: scroll;">
                            </div>
                            <div id="gsvd_staffdtype" style="width: 100%; height: 400px; padding-top: 3px; display: none;
                                overflow-y: scroll;">
                            </div>
                            <div id="gsvd_casualdtype" style="width: 100%; height: 400px; padding-top: 3px; display: none;
                                overflow-y: scroll;">
                            </div>
                            <div id="gsvd_staffdtypeabsent" style="width: 100%; height: 400px; padding-top: 3px;
                                display: none; overflow-y: scroll;">
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

        <%--//--------test-----------//--%>
         <div id="div_branchtype" class="col-sm-6" style="width: 100%;">
                <div class="box box-solid box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Employee Wise Attendance Information</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="table-responsive">
                            <div id="Div2" style="width: 100%; height: 400px; padding-top: 3px; display: none;
                                overflow-y: scroll;">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

       <%-- //----------------------//--%>
        <div class="modal" id="myModal2" role="dialog" style="overflow: auto;">
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header" style="background: linear-gradient(to right, #66ccff 0%, #ccffff 100%)">
                        <h4 class="modal-title">
                            Logs Details</h4>
                    </div>
                    <div class="modal-body">
                        <table align="center">
                            <tr>
                                <td colspan="4">
                                    <div id="divlogs2" style="display: none;">
                                    </div>
                                    <div id="divlogs3" style="display: none;">
                                    </div>
                                    <div id="divlogs4" style="display: none;">
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="modal-footer" style="background: linear-gradient(to right,#ccffff 0%, #66ccff 100%)">
                        <button type="button" class="btn btn-default" id="btn_close2" data-dismiss="modal"
                            data-backdrop="false" onclick="closepopup2();">
                            Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
     <script src="JSF/jquery.blockUI.js" type="text/javascript"></script>
</asp:Content>
