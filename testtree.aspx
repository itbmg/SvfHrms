<%@ Page Language="C#" AutoEventWireup="true" CodeFile="testtree.aspx.cs" Inherits="testtree" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="utf-8">
    <link rel="icon" href="images/hr.png" type="image/x-icon" title="Vyshnavi HRMS" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vyshnavi HRMS</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
        name="viewport">
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
        name="viewport">
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
    <!-- DataTables -->
    <link rel="stylesheet" href="plugins/datatables/dataTables.bootstrap.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="dist/css/skins/_all-skins.min.css">
    <script src="plugins/morris/morris.js" type="text/javascript"></script>
    <!-- Theme style -->
    <script src="plugins/slimScroll/jquery.slimscroll.min.js"></script>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <!-- AdminLTE App -->
    <link rel="stylesheet" href="dist/css/AdminLTE.min.css?v=16002">
    <!-- AdminLTE Skins. Choose a skin from the css/skins
         folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="dist/css/skins/_all-skins.min.css">
    <!-- iCheck -->
    <link rel="stylesheet" href="plugins/iCheck/flat/blue.css">
    <!-- Morris chart -->
    <link rel="stylesheet" href="plugins/morris/morris.css">
    <!-- jvectormap -->
    <link rel="stylesheet" href="plugins/jvectormap/jquery-jvectormap-1.2.2.css">
    <!-- Date Picker -->
    <link rel="stylesheet" href="plugins/datepicker/datepicker3.css">
    <!-- Daterange picker -->
    <link rel="stylesheet" href="plugins/daterangepicker/daterangepicker-bs3.css">
    <!-- bootstrap wysihtml5 - text editor -->
    <link rel="stylesheet" href="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">
    <link rel="stylesheet" href="Styles/chosen.css">
    <script src="js/jquery.js"></script>
    <%-- <script src="JSF/jquery.min.js"></script>--%>
     
    <link href="css/font-awesome.min.css" rel="stylesheet">
   
    <link href="css/custom.css" rel="stylesheet" type="text/css" />
   
    <script src="amcharts/amcharts.js" type="text/javascript"></script>
    <script src="amcharts/pie.js" type="text/javascript"></script>
    <script src="amcharts/serial.js" type="text/javascript"></script>
    <script src="amcharts/plugins/export/export.js" type="text/javascript"></script>
    <link href="amcharts/plugins/export/export.css" rel="stylesheet" type="text/css" />
    <script src="amcharts/plugins/export/export.min.js" type="text/javascript"></script>
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="amcharts/themes/light.js"></script>
    <script src="https://www.amcharts.com/lib/3/themes/none.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <%--  <script>
        function totalleaves() {
            var data = { 'op': 'Total_leave_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        laeavedetales(msg);
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
        function laeavedetales(msg) {
            var tot_la = msg[0].totalleaveapprovaldetailes;
            var tot_onduty = msg[0].totalODpendingdetailes;
            var tot_BD = msg[0].totalbrithdaysldetailes;
            document.getElementById('txt_leaveapproval').innerHTML = tot_la.length;
            document.getElementById('txt_count').innerHTML = tot_la.length;
            document.getElementById('txt_odapproval').innerHTML = tot_onduty.length;
            document.getElementById('txt_odcount').innerHTML = tot_onduty.length;
            document.getElementById('txt_brithdays').innerHTML = tot_BD.length;
            document.getElementById('txt_brithdaycount').innerHTML = tot_BD.length;
            $('#ul_showallleaves').html('');
            for (var i = 0; i < tot_la.length; i++) {
                $('#ul_showallleaves').append('<li ><a  href="#"><div class="pull-left">  <img src="images/Employeeimg.jpg" class="img-circle" alt="User Image"></div><h4>' + tot_la[i].fullname + '<small><i class="fa fa-clock-o"></i>' + tot_la[i].leavedays + '</small></h4><p>' + tot_la[i].remarks + '</p></a></li>');
            }
            $('#ui_Odpennding').html('');
            for (var i = 0; i < tot_onduty.length; i++) {
                $('#ui_Odpennding').append('<li ><a  href="#"><div class="pull-left"> <img src="images/Employeeimg.jpg" class="img-circle" alt="User Image"></div><h4>' + tot_onduty[i].fullname + '<small><i class="fa fa-clock-o"></i>' + tot_onduty[i].oddays + '</small></h4><p>' + tot_onduty[i].remarks + '</p></a></li>');
            }
            $('#ui_brithadays').html('');
            for (var i = 0; i < tot_BD.length; i++) {
                $('#ui_brithadays').append('<li ><a  href="#"><div class="pull-left">  <img src="images/Employeeimg.jpg" class="img-circle" alt="User Image"></div><h4>' + tot_BD[i].fullname + '</h4><p>' + tot_BD[i].Birth_Days + '</p></a></li>');
            }
        }
    </script>--%>
    <script type="text/javascript">
        $(function () {


    $('#min').click(function(){
        mnt.value = "0" +(mnt.value-1)
        generateclick()
        get_govffto_report();
        get_allbranches_report();
        get_svdssales_report();
        get_svdsplant_report();
        get_svdscc_report();
        get_svdcc_report();
        get_rmdrplant_report();
      })
        $('#add').click(function(){
        var monthvalue = (+mnt.value+1)
        if(monthvalue > 12)
                     {
//                      alert("no");
                      return false;
                     }
                     else{
                     mnt.value = "0"+ monthvalue;
                     }
        generateclick();
        get_govffto_report();
        get_allbranches_report();
        get_svdssales_report();
        get_svdsplant_report();
        get_svdscc_report();
        get_svdcc_report();
        get_rmdrplant_report();
      })
          
    $('#yearmin').click(function(){
        year.value = (year.value-1)
        generateclick();
        get_govffto_report();
        get_allbranches_report();
        get_svdssales_report();
        get_svdsplant_report();
        get_svdscc_report();
        get_svdcc_report();
        get_rmdrplant_report();
     })

               $('#yearadd').click(function(){
                     var yearvalue = (+year.value+1);
                     
                     if(yearvalue > 2018)
                     {
//                      alert("select bellow current year");
                      return false;
                     }
                     else{
                     year.value = yearvalue;
                     }
                  generateclick();
                  get_govffto_report();
                  get_allbranches_report();
                  get_svdssales_report();
                  get_svdsplant_report();
                  get_svdscc_report();
                  get_svdcc_report();
                  get_rmdrplant_report();
                })

        var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            var hrs = today.getHours();
            var mnts = today.getMinutes();
            $('#ddlmonth').val(mm);
            year.value=yyyy;
            var month = mm-1;
            mnt.value = '0' +  month;
        var BranchType = '<%=Session["branchid"] %>';
        var leveltype = '<%=Session["leveltype"] %>';
        var department = '<%=Session["department"] %>';
        var usrphoto = '<%=Session["photo"] %>';
        var rndmnum = Math.floor((Math.random() * 10) + 1);
        var ftplocation = "ftp://223.196.32.30:21/HRMS/";
        img = ftplocation + usrphoto + '?v=' + rndmnum;
//        totalleaves();
        Get3monthsNetpaychartvalues();
            employeeagewisechart();
             Getbranchwisesalary();
            Getemployeegenderdetails();
            Getemployeeaddandsubbarchart();
            Getemployeetypewisedetails();
            Getdepartemntandbranchwisesalary();
            get_govffto_report();
            get_allbranches_report();
           
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
        function Getemployeegenderdetails() {
            var type = "Gender";
            var ChartType ="All Location";
            $('#divHide').css('display', 'block');
            var salarywiseLinechart = "salarywiseLinechart";
            var data = { 'op': 'employeetypePieChartValues', 'type': type,'ChartType': ChartType, 'FormName': salarywiseLinechart };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        LineChartforVehicleMileage(msg);
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
        function LineChartforVehicleMileage(databind) {
            newXarray = [];
            var textname = "";
            var ChartType = "All Location";
            var countgen = databind[0].countgen;
            var branchname = databind[0].branchname;
            for (var i = 0; i < branchname.length; i++) {
                newXarray.push({ "category": branchname[i], "value": parseFloat(countgen[i]) });
            }


            var chart = AmCharts.makeChart("divChart", {
                type: "pie",
                theme: "light",
                dataProvider:newXarray,
                valueField: "value",
                titleField: "category",
                outlineAlpha: 0.4,
                depth3D: 15,
                balloonText: "[[title]]<br><span style='font-size:14px'><b>[[value]]</b> ([[percents]]%)</span>",
                angle: 30,
                export: {
                    enabled: true
                }
            });
            
        }

        function employeeagewisechart() {
            var barnchname = "ALL";
            var campny = '<%= Session["company_id"] %>';
            var data = { 'op': 'Agewiseemployeecount_barChartValues', 'campny': campny, 'barnchname': barnchname };
            var s = function (msg) {
                if (msg == "") {
                    alert("No Data Found");
                    $("#divChart1").css('display', 'none');
                }
                else if (msg) {
                    if (msg.length > 0) {
                        createbarChart(msg)
                        $("#divChart1").css('display', 'block');
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
        var datainXSeries = 0;
        var datainYSeries = 0;
        var newXarray = [];
        var newYarray = [];
        function createbarChart(databind) {
            var xbranchname = databind[0].branchname;
            var xcountgen = databind[0].countgen;
            var newYarray = [];
            var newXarray = [];
            var myData = [];
            if (databind.length > 0) {
                for (var k = 0; k < databind.length; k++) {
                    var BranchName = [];
                    xbranchname = databind[0].branchname;
                    xcountgen = databind[0].countgen;
                    color = ["#d9534f",  "#FF6600", "#FF9E01", "#04D215",  "#B0DE09", "#F8FF01", "#FCD202", "#FF6600"];
                    for (var i = 0; i < xbranchname.length; i++) {
                         myData.push({"branch":xbranchname[i].toString(), "empcount":parseInt(xcountgen[i]),"color":color[i]});
                    }
                }
            }
             var chart = AmCharts.makeChart("divChart1", {
                 "type": "serial",
                 "theme": "light",
                 "marginRight": 70,
                 "rotate": true,
                 dataProvider:myData,
                 "valueAxes": [{
                     "axisAlpha": 0,
                     "position": "left",
                     "title": "Age Distribution"
                 }],
                 "startDuration": 1,
                 "graphs": [{
                     "balloonText": "<b>[[category]]: [[value]]</b>",
                     "fillColorsField": "color",
                     "fillAlphas": 0.9,
                     "lineAlpha": 0.2,
                     "type": "column",
                     "valueField": "empcount"
                 }],
                 "chartCursor": {
                     "categoryBalloonEnabled": false,
                     "cursorAlpha": 0,
                     "zoomable": false
                 },
                 "categoryField": "branch",

                 "categoryAxis": {
                     "gridPosition": "start",
                      "labelRotation": 45
                 },
                 "export": {
                     "enabled": true
                 }

             });
             


        }
        function Getemployeeaddandsubbarchart() {
            var name = "";
            var tmonth = "";
            var ChartType = "All Location";
            var today = new Date();
            var dd = today.getDate();
//            var mm = Date.today().add(-1).months();
//            var mm = today.getMonth() ; //January is 0!
//            var yyyy = today.getFullYear();
//            if (dd < 10) {
//                dd = '0' + dd
//            }
//            if (mm < 10) {
//                mm = '0' + mm
//            }
//            Month = mm; 
//            Year = yyyy;
           var Month=document.getElementById("mnt").value;
           var Year=document.getElementById("year").value;

            var salarywiseLinechart = "salarywiseLinechart";
            var data = { 'op': 'employee_relieving_joingcount_barChartValues', 'Month': Month, 'Year': Year, 'name': name, 'ChartType': ChartType, 'FormName': salarywiseLinechart };
            var s = function (msg) {
                if (msg == "No data Found") {
                    $('#graph').css('display', 'none');
                }
                else if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        createlineChart(msg);
                        $('#graph').css('display', 'block');
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

        var datainXSeries = 0;
        var datainYSeries = 0;
        var newXarray = [];
        var newYarray = [];
        function createlineChart(databind) {
         var xbranchname = databind[0].branchname;
            var xcountgen = databind[0].countgen;
            var xcountgen1 = databind[0].countgen1;
            var newYarray = [];
            var newXarray = [];
            var chartData = [];
            if (databind.length > 0) {
                for (var k = 0; k < databind.length; k++) {
                    var BranchName = [];
                    xbranchname = databind[0].branchname;
                    xcountgen = databind[0].countgen;
                    xcountgen1 = databind[0].countgen1;
                    for (var i = 0; i < xbranchname.length; i++) {
                        chartData.push({ "branch": xbranchname[i].toString(), "Joiningcount": parseInt(xcountgen[i]), "Relievingcount":  parseInt(xcountgen1[i]) });
                    }
                }
            }

var chart = AmCharts.makeChart("graph", {
    "type": "serial",
    "theme": "light",
    "legend": {
        "useGraphSettings": true
    },
    "dataProvider":chartData ,
    "valueAxes": [{
        "integersOnly": true,
        "maximum": 10,
        "minimum": 0,
        "reversed": false,
        "axisAlpha": 0,
        "dashLength": 5,
        "gridCount": 10,
        "position": "left",
        "title": "Emp Additions & Attrition"
    }],
    "startDuration": 0.5,
    "graphs": [
   {
        "balloonText": "Joiningcount in [[category]]: [[value]]",
        "bullet": "round",
        "title": "Joiningcount",
        "valueField": "Joiningcount",
		"fillAlphas": 0,
        "fill": "#009933"
    }, {
        "balloonText": "Relievingcount in [[category]]: [[value]]",
        "bullet": "round",
        "title": "Relievingcount",
        "valueField": "Relievingcount",
		"fillAlphas": 0
    }],
    "chartCursor": {
        "cursorAlpha": 0,
        "zoomable": false
    },
    "categoryField": "branch",
    "categoryAxis": {
        "gridPosition": "start",
        "axisAlpha": 0,
        "fillAlpha": 0.05,
        "fillColor": "#000000",
        "gridAlpha": 0,
        "position": "left",
         "labelRotation": 25
         
    },
    "export": {
    	"enabled": true,
        "position": "bottom-right"
     }
});

}



        function Getemployeetypewisedetails() {
            var type = "Employee Type";
            var ChartType ="All Location";
            $('#divHide').css('display', 'block');
            var salarywiseLinechart = "salarywiseLinechart";
            var data = { 'op': 'employeetypePieChartValues', 'type': type,'ChartType': ChartType, 'FormName': salarywiseLinechart };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        createemployeetypebarChart(msg);
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
         var datainXSeries = 0;
        var datainYSeries = 0;
        var newXarray = [];
        var newYarray = [];
        function createemployeetypebarChart(databind) {
            var xbranchname = databind[0].branchname;
            var xcountgen = databind[0].countgen;
            var newYarray = [];
            var newXarray = [];
            var myData = [];
            if (databind.length > 0) {
                for (var k = 0; k < databind.length; k++) {
                    var BranchName = [];
                    xbranchname = databind[0].branchname;
                    xcountgen = databind[0].countgen;
                    color = ["#ff8000", "#ffff00", "#bfff00", "#40ff00", "#00ffbf", "#00bfff", "#4000ff", "#00ffff", "#0D52D1", "#8A0CCF", "#CD0D74", "#754DEB", "#DDDDDD", "#999999", "#333333", "#000000"];
                    for (var i = 0; i < xbranchname.length; i++) {
                        myData.push({ "emptype": xbranchname[i].toString(), "count": parseInt(xcountgen[i]), "color": color[i] });

                    }
                }
            }
            var chart = AmCharts.makeChart("divChart3", {
                "type": "serial",
                "theme": "light",
                "marginRight": 70,
                "rotate": true,
                dataProvider: myData,
                "valueAxes": [{
                    "axisAlpha": 0,
                    "position": "left",
                    "title": "Employees By Status"
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
                "categoryField": "emptype",

                "categoryAxis": {
                    "gridPosition": "start",
                },
                "export": {
                    "enabled": true
                }
            });


        }

         function Getdepartemntandbranchwisesalary() {
         var month=document.getElementById("mnt").value;
         var year=document.getElementById("year").value;
            var data = { 'op': 'Getdepartemntandbranchwisesalary','month':month,'year':year };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        fillsalarydetails(msg);
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
       


        function fillsalarydetails(msg) {
            var netpay = 0;
            var values = [];
            var emptytable4 = [];
             values = msg[0].EmployeDetalis;
             var distinctMap = {};
            for (var i = 0; i < values.length; i++) {
                var value = values[i].department;
                distinctMap[value] = '';
            };
            var unique_values = [];
            unique_values = Object.keys(distinctMap);
            unique_values.sort(function (a, b) { return a - b });
            var department = [];
            for (var i = 0; i < unique_values.length; i++) {
                department.push([(unique_values[i])]);
            }
            var m = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr>';
            results += '<th scope="col">Sno</th><th scope="col">Branchname</th>';
            for (var i = 0; i < department.length; i++) {
                results += '<th id="header" scope="col">' + department[i] + '</th>';
            }
            results += '</tr></thead></tbody>';
            for (var i = 0; i < values.length; i++) {
                values.sort(function (a, b) {
                    return a.department - b.department;
                });
                results += '<tr>';
                var branchname = values[i].branchname
                var x = values[i].department;
                if (emptytable4.indexOf(branchname) == -1) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><td>' + m++ + '</td>';
                    results += '<td data-title="brandstatus" >' + values[i].branchname + '</td>';
                    emptytable4.push(branchname);
                    for (var k = 0; k < values.length; k++) {
                        var x1 = values[i].department;
                        var x2 = department[i];
                        var netpay = values[k].netpay;
                        var netpay1 = 0;
                        if (branchname == values[k].branchname && x1 == values[i].department) {
                            if (branchname != "" && x1 != "") {
                                results += '<td data-title="brandstatus1" >' + values[k].Netpay + '</td>';
                            }
                        }
//                        
                        
                    }

                }
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divnetpay").html(results);
        }
         function Getdepartemntandbranchwisesalarychart(branchid) {
         var branchid=branchid;
            var data = { 'op': 'Getdepartemntandbranchwisesalarychart','branchid':branchid };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        departmentsalarybarChart(msg);
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
        function departmentsalarybarChart(databind) {
            newXarray = [];
            var textname = "";
            var ChartType = "All Location";
            var countgen = databind[0].netpay1;
            var branchname = databind[0].departmentcount;
            for (var i = 0; i < branchname.length; i++) {
                newXarray.push({ "category": branchname[i], "value": parseFloat(countgen[i]) });
            }


            var chart = AmCharts.makeChart("chartdiv", {
                type: "pie",
                theme: "light",
                dataProvider:newXarray,
                valueField: "value",
                titleField: "category",
                outlineAlpha: 0.4,
                depth3D: 15,
                balloonText: "[[title]]<br><span style='font-size:14px'><b>[[value]]</b> ([[percents]]%)</span>",
                angle: 30,
                export: {
                    enabled: true
                }
            });
            
        }
         function Getbranchwisesalary() {
         var year=document.getElementById("year").value;
         var month=document.getElementById("mnt").value;
            var data = { 'op': 'Getbranchwisesalaryandemployeecount','month':month,'year':year };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        fillsalaryempcountdetails(msg);
                        createemployeesalarybarChart(msg);
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
      
        function fillsalaryempcountdetails(msg){
        var totalcount=[];
        var salarydetails=[];
         var l = 0;
            totalcount = msg[0].Employecount;
            salarydetails = msg[0].EmployeDetalis;
            var results = '<div  style="overflow:auto;"><table id="example2" class="table table-bordered table-hover dataTable" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr role="row" style="background-color:white;"><th  class="sorting" tabindex="0" aria-controls="example2" rowspan="1" colspan="1" aria-label="Rendering engine: activate to sort column ascending">BRANCH NAME</th><th class="sorting" tabindex="0" aria-controls="example2" rowspan="1" colspan="1" aria-label="Browser: activate to sort column ascending" >NET PAY</th><th scope="col" >TotalEmp</th></tr></thead></tbody>';
            for (var k = 0; k < salarydetails.length; k++) {
            if(totalcount[k].employeecount != null){
                results += '<tr role="row">';
                    results += '<th scope="row"  class="1"><span id="spninqty"  onclick="Getdepartemntandbranchwisesalarychart(\'' +totalcount[k].branchname + '\');"><i class="fa fa-arrow-circle-right" style="width: 22px;" aria-hidden="true"></i><span style="text-decoration: none; ">' + totalcount[k].branchname + '</th>';
                    results += '<td  class="3">' + salarydetails[k].Netpay + '</td>';
                    var count = totalcount[k].employeecount;
                    results += '<td class="2">' + totalcount[k].employeecount + '</td>';
                         results += '</tr>';
                    }
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
               
            results += '</table></div>';
            $("#divtbldata").html(results);
        }
         var datainXSeries = 0;
        var datainYSeries = 0;
        var newXarray = [];
        var newYarray = [];

         function createemployeesalarybarChart(databind) {
               var chart;

          var xbranchname = databind[0].branchnamecount;
            var xcountgen = databind[0].countgen;
            var newYarray = [];
            var newXarray = [];
            var myData = [];
            if (databind.length > 0) {
                for (var k = 0; k < databind.length; k++) {
                    var BranchName = [];
                    xbranchname = databind[0].branchnamecount;
                    xcountgen = databind[0].countgen;
                    color=["#FF0F00","#FF6600","#FF9E01","#FCD202","#F8FF01", "#F8FF01","#B0DE09", "#04D215","#0D8ECF","#40ff00","#00ff40"," #00ff80"," #00ffff"," #0080ff","#0D52D1", "#2A0CD0","#8A0CCF", "#CD0D74","#754DEB","#DDDDDD","#999999","#333333","#000000"];
                    for (var i = 0; i < xbranchname.length; i++) {
                        myData.push({"branch":xbranchname[i].toString(), "amount":parseInt(xcountgen[i]),"color":color[i]});
                    }
                }
            }

        var chart = AmCharts.makeChart("divChart4", {
                            type: "serial",
                 theme: "light",
                marginRight: 70,
                dataProvider: myData,
                categoryField: "branch",
                categoryAxis: {
                    labelRotation: 45,
                    gridPosition: "start"
                },
                    valueAxes: [{
                    axisAlpha: 0,
                    position: "left",
                    title: "Branch wise Netamount"
                }],
                startDuration: 1,
                graphs: [{
                    valueField: "amount",
                    colorField: "color",
                    type: "column",
                    lineAlpha: 0.2,
                    fillAlphas: 1
                }],
                chartCursor: {
                    cursorAlpha: 0,
                    zoomable: false,
                    categoryBalloonEnabled: false
                },
                "export": {
                    "enabled": true
                }

            });
}




function Get3monthsNetpaychartvalues() {
            var name = "";
            var tmonth = "";
            var type = "Pie Chart";
            var ChartType = "All Location";
            var month = "6"
            $('#divHide').css('display', 'block');
            var salarywiseLinechart = "salarywiseLinechart";
            var data = { 'op': 'GetPieChartValues', 'type': type,  'month': month, 'ChartType': ChartType, 'FormName': salarywiseLinechart };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        last6monthssalarybarChart(msg);
                        values1 =msg[0].EmployeDetalis;
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
        function last6monthssalarybarChart(databind){
         var Month = databind[0].branchname;
         Month.sort();
         var nmonth=[]; 
         for (var i = 0; i < Month.length; i++) {
                var month = new Array();
                var months = ["","January", "February", "March", "April", "May", "June",
               "July", "August", "September", "October", "November", "December"];
                nmonth.push(months[(parseInt(Month[i]))]);
            }
            var Netpay = databind[0].netpay;
             Netpay.reverse();
            var AVGAmount = [];
            var avg= [];
            var myData = [];
            if (databind.length > 0) {
                for (var k = 0; k < databind.length; k++) {
                    var BranchName = [];
                    xMonth = databind[0].branchname;
                    xNetpay = databind[0].netpay;
                    for (var i = 0; i < xMonth.length; i++) {
                    avg=parseInt(xNetpay[i])/xMonth.length;
                    AVGAmount.push({avg});
                        myData.push({"branch":nmonth[i].toString(), "amount":parseInt(xNetpay[i]),"avg":parseInt(avg)});
                    }
                }
            }
            var chart = AmCharts.makeChart( "Divbaravg", {
  "type": "serial",
  "addClassNames": true,
  "theme": "light",
  "autoMargins": false,
  "marginLeft": 30,
  "marginRight": 8,
  "marginTop": 10,
  "marginBottom": 26,
  "balloon": {
    "adjustBorderColor": false,
    "horizontalPadding": 10,
    "verticalPadding": 8,
    "color": "#ffffff"
  },

  "dataProvider":myData,
  "valueAxes": [ {
    "axisAlpha": 0,
    "position": "left"
  } ],
  "startDuration": 1,
  "graphs": [ {
    "alphaField": "alpha",
    "balloonText": "<span style='font-size:12px;'>[[title]] in [[category]]:<br><span style='font-size:20px;'>[[value]]</span> [[additional]]</span>",
    "fillAlphas": 1,
    "title": "Netpay",
    "type": "column",
    "valueField": "amount",
    "dashLengthField": "dashLengthColumn"
  }, {
    "id": "graph2",
    "balloonText": "<span style='font-size:12px;'>[[title]] in [[category]]:<br><span style='font-size:20px;'>[[value]]</span> [[additional]]</span>",
    "bullet": "round",
    "lineThickness": 3,
    "bulletSize": 7,
    "bulletBorderAlpha": 1,
    "bulletColor": "#FFFFFF",
    "useLineColorForBulletBorder": true,
    "bulletBorderThickness": 3,
    "fillAlphas": 0,
    "lineAlpha": 1,
    "title": "AVG amount",
    "valueField": "avg",
    "dashLengthField": "dashLengthLine"
  } ],
  "categoryField": "branch",
  "categoryAxis": {
    "gridPosition": "start",
    "axisAlpha": 0,
    "tickLength": 0
  },
  "export": {
    "enabled": true
  }
} );

       }
         
        function generateclick(){
      
   
//        var plusimage=document.getElementById("plus").value;
        
       
         Get3monthsNetpaychartvalues();
            employeeagewisechart();
             Getbranchwisesalary();
            Getemployeegenderdetails();
            Getemployeeaddandsubbarchart();
            Getemployeetypewisedetails();
            Getdepartemntandbranchwisesalary();
        }
    </script>
    <style>
        #divChart4
        {
            width: 100%;
            height: 500px;
        }
        
        .amcharts-export-menu-top-right
        {
            top: 10px;
            right: 0;
        }
    </style>
    <!--new styles-->
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
            $('#mnt').click(function () {
                document.getElementById('spn_gosvdtotsal').innerHTML = "";
                document.getElementById('spn_svdstotsal').innerHTML = "";
                document.getElementById('spn_svdsPers').innerHTML = "";
                document.getElementById('spn_svdtotsal').innerHTML = "";
                document.getElementById('spn_svdPers').innerHTML = "";
                document.getElementById('spn_RMRDEtotsal').innerHTML = "";
                document.getElementById('spn_rmrdPers').innerHTML = "";

            });
        });


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
            get_allbranches_report();
            $("#div_gosvd").css("display", "block");
        });
        function generate_report() {
            get_govffto_report();
            get_allbranches_report();
            $("#div_gosvd").css("display", "block");
        }

        function get_govffto_report() {
            var month = document.getElementById('mnt').value;
            var year = document.getElementById('year').value;
            var data = { 'op': 'get_gosvd_report', 'month': month, 'year': year };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        govfto_details(msg);
                    }
                    else {
                        document.getElementById('spn_gosvdtotsal').innerHTML = "₹ 0/-";
                        document.getElementById('spn_gsvdsPers').innerHTML = "0%";

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
            var totgross = msg[0].spntotgross;
            var totgrosss = msg[0].totgross;
            gosvd_totgross = totgross;

            if (gosvd_totgross != "" || gosvd_totgross != 0) {

                var totsalary = '₹' + " " + " " + totgrosss + '/-'
                totsal = totgross / gosvd_totgross * 100;

                document.getElementById('spn_gosvdtotsal').innerHTML = totsalary;
                document.getElementById('spn_gosvdtotsal2').innerHTML = totgross;
                var percentage = parseFloat(totsal).toFixed(2) + '%'
                document.getElementById('spn_gsvdsPers').innerHTML = percentage;
            }
            else {
                document.getElementById('spn_gosvdtotsal').innerHTML = "₹ 0/-";
                document.getElementById('spn_gsvdsPers').innerHTML = "0%";
            }
        }
       
        function get_gosvds_branchtype_wiserep() {
            var month = document.getElementById('mnt').value;
            var year = document.getElementById('year').value;
            var companyid = "1";
            var data = { 'op': 'get_gosvd_branchtypewise_report', 'month': month, 'year': year, 'companyid': companyid };
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
                var totgrosss = msg[i].spntotgross;
                var totgross = msg[i].totgross;
                var totalgross = '₹' + " " + " " + totgross + '/-'
                var totamt = document.getElementById('spn_svdstotsal2').innerHTML;
                totsal = totgrosss / totamt * 100;

                if (branchtype == "CC") {

                    document.getElementById('spn_svdscctotsal').innerHTML = totalgross;
                    document.getElementById('spn_svdscctotsal2').innerHTML = totgrosss;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_svdsccPers').innerHTML = percentage;
                }
                if (branchtype == "Plant") {

                    document.getElementById('spn_svdsplanttotsal').innerHTML = totalgross;
                    document.getElementById('spn_svdsplanttotsal2').innerHTML = totgrosss;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_svdsplantPers').innerHTML = percentage;
                }
                if (branchtype == "SalesOffice") {

                    document.getElementById('spn_svdssalestotsal').innerHTML = totalgross;
                    document.getElementById('spn_svdssalestotsal2').innerHTML = totgrosss;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_svdssalesPers').innerHTML = percentage;
                }
            }
        }
       
        function get_svdsplant_report() {
            var month = document.getElementById('mnt').value;
            var year = document.getElementById('year').value;
            var companyid = "1";
            var btype = "Plant";
            var data = { 'op': 'get_gosvd_branchwise_report', 'month': month, 'year': year, 'cmpid': companyid, 'btype': btype };
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
                var totgrosss = msg[i].spntotgross;
                var totgross = msg[i].totgross;
                var totalgross = '₹' + " " + " " + totgross + '/-'
                var planttotamt = document.getElementById('spn_svdsplanttotsal2').innerHTML;

                totsal = totgrosss / planttotamt * 100;

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
            var month = document.getElementById('mnt').value;
            var year = document.getElementById('year').value;
            var companyid = "1";
            var btype = "SalesOffice";
            var data = { 'op': 'get_gosvd_branchwise_report', 'month': month, 'year': year, 'cmpid': companyid, 'btype': btype };
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
                var totgrosss = msg[i].spntotgross;
                var totgross = msg[i].totgross;
                var totalgross = '₹' + " " + " " + totgross + '/-'
                var salestotamt = document.getElementById('spn_svdssalestotsal2').innerHTML;
                totsal = totgrosss / salestotamt * 100;

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
                if (branchname == "Chennai Corporate Office") {

                    document.getElementById('spn_cmo_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_cmo_Pers').innerHTML = percentage;
                }
                if (branchname == "Skht Parlore") {

                    document.getElementById('spn_skht_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_skht_Pers').innerHTML = percentage;
                }
                if (branchname == "Madanapalli Parlor") {

                    document.getElementById('spn_mdnplp_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_mdnplp_Pers').innerHTML = percentage;
                }
            }
        }
        function get_gosvd_branchtype_wiserep() {
            var month = document.getElementById('mnt').value;
            var year = document.getElementById('year').value;
            var companyid = "2";
            var data = { 'op': 'get_gosvd_branchtypewise_report', 'month': month, 'year': year, 'companyid': companyid };
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
                var totgrosss = msg[i].spntotgross;
                var totgross = msg[i].totgross;
                var totamt = document.getElementById('spn_svdtotsal2').innerHTML;
                totsal = totgrosss / totamt * 100;
                var totalgross = '₹' + " " + " " + totgross + '/-'
                if (branchtype == "CC") {

                    document.getElementById('spn_svdcctotsal').innerHTML = totalgross;
                    document.getElementById('spn_svdcctotsal2').innerHTML = totgrosss;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_svdccPers').innerHTML = percentage;
                }
            }
        }
        
        function get_rmrde_report() {
            var month = document.getElementById('mnt').value;
            var year = document.getElementById('year').value;
            var companyid = "4";
            var btype = "Plant";
            var data = { 'op': 'get_gosvd_branchwise_report', 'month': month, 'year': year, 'cmpid': companyid, 'btype': btype };
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
                var totgrosss = msg[i].spntotgross;
                var totgross = msg[i].totgross;
                var rmrtotamt = document.getElementById('spn_RMRDEtotsal2').innerHTML;
                totsal = totgrosss / rmrtotamt * 100;
                var totalgross = '₹' + " " + " " + totgross + '/-'
                if (branchname == "Ramdev") {

                    document.getElementById('spn_rmrplant_totsal').innerHTML = totalgross;
                    document.getElementById('spn_rmrplant_totsal2').innerHTML = totgrosss;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_rmrplant_Pers').innerHTML = percentage;
                }
            }
        }
        function get_rmdrplant_report() {
            var month = document.getElementById('mnt').value;
            var year = document.getElementById('year').value;
            var companyid = "4";
            var btype = "Plant";
            var data = { 'op': 'get_gosvd_branchwise_report', 'month': month, 'year': year, 'cmpid': companyid, 'btype': btype };
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
                var totgrosss = msg[i].spntotgross;
                var totgross = msg[i].totgross;
                var totalgross = '₹' + " " + " " + totgross + '/-'
                var rmrtotamt = document.getElementById('spn_rmrplant_totsal2').innerHTML;

                totsal = totgrosss / rmrtotamt * 100;

                if (branchname == "Ramdev") {

                    document.getElementById('spn_rmrdplant_totsal').innerHTML = totalgross;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_rmrdplant_Pers').innerHTML = percentage;
                }
            }
        }
        function get_allbranches_report() {
            var month = document.getElementById('mnt').value;
            var year = document.getElementById('year').value;
            var data = { 'op': 'get_allbranchestotsal_report', 'month': month, 'year': year };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        svdspl_details(msg);
                    }
                    else {
                        document.getElementById('spn_RMRDEtotsal').innerHTML = "₹ 0/-";
                        document.getElementById('spn_svdsPers').innerHTML = "0%";

                        document.getElementById('spn_svdtotsal').innerHTML = "₹ 0/-";
                        document.getElementById('spn_svdPers').innerHTML = "0%";

                        document.getElementById('spn_svdstotsal').innerHTML = "₹ 0/-";
                        document.getElementById('spn_rmrdPers').innerHTML = "0%";

                        document.getElementById('spn_svftotsal').innerHTML = "₹ 0/-";
                        document.getElementById('spn_svfPers').innerHTML = "0%";
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

                var totgrosss = msg[i].spntotgross;
                var totgross = msg[i].totgross;

                var totsalar = '₹' + " " + " " + totgross + '/-'

                totsal = totgrosss / gosvd_totgross * 100;

                var sno = msg[i].cmpid;

                if (sno == "1") {

                    document.getElementById('spn_svdstotsal').innerHTML = totsalar;
                    document.getElementById('spn_svdstotsal2').innerHTML = totgrosss;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_svdsPers').innerHTML = percentage;
                }
                if (sno == "2") {

                    document.getElementById('spn_svdtotsal').innerHTML = totsalar;
                    document.getElementById('spn_svdtotsal2').innerHTML = totgrosss;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_svdPers').innerHTML = percentage;
                }
                if (sno == "3") {

                    document.getElementById('spn_svftotsal').innerHTML = totsalar;
                    document.getElementById('spn_svftotsal2').innerHTML = totgrosss;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_svfPers').innerHTML = percentage;
                }
                if (sno == "4") {

                    document.getElementById('spn_RMRDEtotsal').innerHTML = totsalar;
                    document.getElementById('spn_RMRDEtotsal2').innerHTML = totgrosss;
                    var percentage = parseFloat(totsal).toFixed(2) + '%'
                    document.getElementById('spn_rmrdPers').innerHTML = percentage;
                }
            }
        }
        //----------test-------------//
        function get_svdscc_report() {
            var month = document.getElementById('mnt').value;
            var year = document.getElementById('year').value;
            var companyid = "1";
            var btype = "CC";
            var data = { 'op': 'get_group_grosspay_details', 'month': month, 'year': year, 'cmpid': companyid, 'btype': btype };
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
            var results = '<div class="k-top"><span class="k-in"><div class="k-top">';
            for (var i = 0; i < msg.length; i++) {
                var subrows = "";
                //for (var i = 0; i < msg.length; i++) {
                   
                //}
                results += '<tr><td></td>';
                results += '<th  class="1"><span  class="k-icon k-i-expand"></span><div><tr style="display:none;"><tbody><div class="k-top"><span class="k-in"><div class="k-top"><tr><td></td><td  class="1"><span  class="k-icon k-i-expand"></span><span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;background: aliceblue;"><span class="k-sprite folder"></span>' + "Sai" + '</td><td  class="3">&nbsp<span id="Span1" style="background-color: rgb(68, 128, 226); color: #fff;padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;line-height: 21px;">' + "₹ " + "0.0" + "/-" + '</span></td><th  class="2">&nbsp<span id="Span2" style="background-color: rgb(68, 128, 226);color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;height: 26px; line-height: 21px;">' + "0.0" + "%" + '</span></span></span></th></tr><br/></div></span></div></tbody></div></tr></th>';
                results += '<th><span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;background: aliceblue;"><span class="k-sprite folder"></span>' + msg[i].branchname + '</th>';
                results += '<td  class="3">&nbsp<span id="Span1" style="background-color: rgb(68, 128, 226); color: #fff;padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;line-height: 21px;">' + "₹ " + msg[i].spntotgross + "/-" + '</span></td>';
                results += '<th  class="2">&nbsp<span id="Span2" style="background-color: rgb(68, 128, 226);color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;height: 26px; line-height: 21px;">' + msg[i].spntotgross + "%" + '</span></span></span></th>';
                results += '</tr>';
                results += '<br/>';
            }
            results += '</div></span></div>';
            $("#div_ccdetails").html(results);
        }



//        function get_group_grosspay_details() {
//            var month = document.getElementById('mnt').value;
//            var year = document.getElementById('year').value;
//            var btype = "Plant";
//            var data = { 'op': 'get_group_grosspay_details', 'month': month, 'year': year };
//            var s = function (msg) {
//                if (msg) {
//                    if (msg.length > 0) {
//                        gaet_det(msg);
//                    }
//                }
//                else {
//                }
//            };
//            var e = function (x, h, e) {
//            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
//            callHandler(data, s, e);
//        }
//        function gaet_det(msg) {
//            var results = '<div class="k-top"><span class="k-in"><div class="k-top">';
//            for (var i = 0; i < msg.length; i++) {
//                results += '<tr><td></td>';
//                results += '<th  class="1"><span  class="k-icon k-i-expand"></span><span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;background: aliceblue;"><span class="k-sprite folder"></span>' + msg[i].department + '</th>';
//                results += '<td  class="3">&nbsp<span id="Span1" style="background-color: rgb(68, 128, 226); color: #fff;padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;line-height: 21px;">' + "₹ " + msg[i].totgross + "/-" + '</span></td>';
//                results += '<th  class="2">&nbsp<span id="Span2" style="background-color: rgb(68, 128, 226);color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;height: 26px; line-height: 21px;">' + msg[i].pers + "%" + '</span></span></span></th>';
//                results += '</tr>';
//                results += '<br/>';
//            }
//            results += '</div></span></div>';
//            $("#div_aranidept").html(results);
//        }
//        function getVehciledocumentsdata() {
//            var table = document.getElementById("tbl_review_list_list");
//            for (var i = table.rows.length - 1; i > 0; i--) {
//                table.deleteRow(i);
//            }
//            var data = { 'op': 'get_Vehciledocuments_data' };
//            var s = function (msg) {
//                if (msg) {
//                    for (var i = 0; i < msg.length; i++) {
//                        var tablerowcnt = document.getElementById("tbl_review_list_list").rows.length;
//                        var subrows = "";
//                        for (var j = 0; j < msg[i].SubVehiclelist.length; j++) {
//                            subrows += '<tr><td data-title="nextcallreq_time">' + msg[i].SubVehiclelist[j].permit_expdate + '</td>
//                            <td data-title="description">' + msg[i].SubVehiclelist[j].pol_expdate + '</td>
//                            <td data-title="lead_entry_sno" >' + msg[i].SubVehiclelist[j].ins_expdate + '</td>
//                            <td data-title="lead_entry_sno" >' + msg[i].SubVehiclelist[j].fitness_expdate + '</td>
//                            <td data-title="lead_entry_sno" >' + msg[i].SubVehiclelist[j].roadtax_expdate + '</td>
//                            <td data-title="lead_entry_sno" >' + msg[i].SubVehiclelist[j].state_permit_expdate + '</td>
//                            <td data-title="lead_entry_sno" >' + msg[i].SubVehiclelist[j].state_roadtax_expdate + '</td></tr>';
//                        }
//                        $('#tbl_review_list_list').append('<tr><td data-title="categorysno">' + msg[i].vehicleno + '</td>
//                        <th scope="Category Name">' + msg[i].make + '</th>
//                        <td data-title="IsTransport">' + msg[i].type + '</td>
//                        <td data-title="IsTransport">' + msg[i].model + '</td>
//                        <td data-title="Application Status">' + msg[i].capacity + '</td>
//                        <td data-title="Application Status">' + msg[i].insurance + '</td>
//                        <td data-title="Status">' + msg[i].pollution + '</td>
//                        <td data-title="Status" >' + msg[i].fitness + '</td>
//                        <td data-title="section_sno">' + msg[i].roadtax + '</td>
//                        <td data-title="grade_sno" >' + msg[i].permit + '</td>
//                        <td></td>
//                        <td><i class="fa fa-plus-circle fa-2x elementlbl" style="width:30px;height:30px" onclick="expandthis(this);"></i></td></tr>
//                        
//                        <tr style="display:none;"><td colspan="15"><table class="responsive-table"><thead><tr><th scope="col" > Permit Exp Date</th><th scope="col" name=note">Pollution Exp Date</th><th scope="col" name=note">Insurance Exp Date</th><th scope="col" name=note">Fiteness Exp Date</th><th scope="col" name=note">RoadTax Exp Date</th><th scope="col" name=note">State Permit</th><th scope="col" name=note">State RoadTax </th></tr></tr></thead><tbody>' + subrows + '</tbody></table></td></tr>');
//                    }
//                }
//                else {
//                    document.location = "Default.aspx";
//                }
//            }
//            var e = function (x, h, e) {
//                alert(e.toString());
//            };
//            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
//            callHandler(data, s, e);
//        }
//        function expandthis(thisid) {
//            if (thisid.className == "fa fa-plus-circle fa-2x elementlbl") {
//                thisid.setAttribute("class", "fa fa-minus-circle fa-2x elementlbl");

//                $(thisid).closest('tr').next().removeAttr("style");
//            }

//            else if (thisid.className == "fa fa-minus-circle fa-2x elementlbl") {
//                thisid.setAttribute("class", "fa fa-plus-circle fa-2x elementlbl");
//                $(thisid).closest('tr').next().css('display', 'none');
//            }
//        }

//        function get_svdcc_report() {
//            var month = document.getElementById('mnt').value;
//            var year = document.getElementById('year').value;
//            var companyid = "2";
//            var btype = "CC";
//            var data = { 'op': 'get_gosvd_branchwise_report', 'month': month, 'year': year, 'cmpid': companyid, 'btype': btype };
//            var s = function (msg) {
//                if (msg) {
//                    if (msg.length > 0) {
//                        gsvd_cc_branch_details(msg);
//                    }
//                }
//                else {
//                }
//            };
//            var e = function (x, h, e) {
//            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
//            callHandler(data, s, e);
//        }
//        var branches = [];
//        function gsvd_cc_branch_details(msg) {
//            for (var i = 0; i < msg.length; i++) {
//                var results = '<div class="k-top"><span class="k-in"><div class="k-top">';
//                for (var i = 0; i < msg.length; i++) {
//                    results += '<tr><td></td>';
//                    results += '<th  class="1"><span class="k-in"><span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;background: aliceblue;"><span class="k-sprite folder"></span>' + msg[i].branchname + '</th>';
//                    results += '<td  class="3">&nbsp<span id="Span1" style="background-color: rgb(68, 128, 226); color: #fff;padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;line-height: 21px;">' + "₹ " + msg[i].spntotgross + "/-" + '</span></td>';
//                    results += '<th  class="2">&nbsp<span id="Span2" style="background-color: rgb(68, 128, 226);color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;height: 26px; line-height: 21px;">' + msg[i].spntotgross + "%" + '</span></span></span></th>';
//                    results += '</tr>';
//                    results += '<br/>';
//                }
//                results += '</div></span></div>';
//                $("#div_svdccdet").html(results);
//            }
//        }

        
        //----------test-------------//
                                                                       
    </script>
</head>
<body class="hold-transition skin-blue sidebar-mini sidebar-collapse">
    <div class="wrapper">
        <header class="main-header">
            <!-- Logo -->
            <a href="Dashboard.aspx" class="logo">
                <!-- mini logo for sidebar mini 50x50 pixels -->
                <span class="logo-mini"><b>V</b></span>
                <!-- logo for regular state and mobile devices -->
                <span class="logo-lg"><b>Vyshnavi</b></span> </a>
            <!-- Header Navbar: style can be found in header.less -->
            <nav class="navbar navbar-static-top" role="navigation">
                <!-- Sidebar toggle button-->
                <a href="#" id="id_navbar" class="sidebar-toggle" data-toggle="offcanvas" role="button"><span class="sr-only">
                    Toggle navigation</span> </a>
                <div class="navbar-custom-menu">
                    <ul class="nav navbar-nav">
                        <!-- Messages: style can be found in dropdown.less-->
                       
                        <!-- Notifications: style can be found in dropdown.less -->
                       <li class="dropdown messages-menu"><a href="LogOut.aspx">Sign out</a>
                                <ul class="dropdown-menu">
                                <li class="header">You have <span  id="txt_brithdaycount" ></span> </li>
                                <li>
                                    <!-- inner menu: contains the actual data -->
                                    <ul class="menu">
                                        <li>
                                            <!-- start message -->
                                            <a href="#">
                                                <ul class="menu" id="ui_brithadays"></ul>
                                            </a></li>
                                        <!-- end message -->
                                    </ul>
                                </li>
                                <li class="footer"><a href="#">View all Tasks</a> </li>
                            </ul>
                        </li>
                        <!-- Tasks: style can be found in dropdown.less -->
                      
                        <!-- User Account: style can be found in dropdown.less -->
                       
                        <!-- Control Sidebar Toggle Button -->
                       
                    </ul>
                </div>
            </nav>
        </header>
        <!-- Left side column. contains the logo and sidebar -->
    </div>
    <ol class="breadcrumb">
    </ol>
    <!-- Main content -->
    <section class="content">
    <div style="text-align:right"><a href="NewTimeline.aspx" style="text-decoration:underline; "><img src="Images/ani.gif" style="width: 3%" />Click Here to Go Mainpage</a></div>
    <div id='Inwardsilo_fillform' align="left" style="margin-top: -3%;text-align:  center;align-items:  center;margin-left:  40%;" >
     
                   
                    <div >
                     <table>
                    <tr>
                    <td>
                                        <div class="input-group">
                                        
                                    <span class="input-group-btn">
                                        <button type="button" class="quantity-left-minus btn btn-danger btn-number" style="height: 34px;" id="min" data-type="minus" data-field="">
                                          <span class="glyphicon glyphicon-minus"></span>
                                        </button>
                                    </span>
                                    <input type="text"  id="mnt" name="quantity" style="width:68px;" class="form-control input-number" value="04" min="1" max="100">
                                    <span class="input-group-btn">
                                        <button type="button" class="quantity-right-plus btn btn-success btn-number" style="height: 34px;" id="add" data-type="plus" data-field="">
                                            <span class="glyphicon glyphicon-plus"></span>
                                        </button>
                                    </span>
                                </div>
                                </td>
                               <td width="9%"></td>
                                <td>
                                <div class="input-group">
                        
                                    <span class="input-group-btn">
                                        <button type="button" class="quantity-left-minus btn btn-danger btn-number" style="height: 34px;" id="yearmin" data-type="minus" data-field="" >
                                          <span class="glyphicon glyphicon-minus"></span>
                                        </button>
                                    </span>
                                     <input   type="text" id="year" name="name" value="2017" style="width:68px;" onchange="slct_yearclick();" class="form-control input-number"  min="1" max="100">
                                    <span class="input-group-btn">
                                        <button type="button" class="quantity-right-plus btn btn-success btn-number" style="height: 34px;" id="yearadd" data-type="plus" data-field="" >
                                            <span class="glyphicon glyphicon-plus"></span>
                                        </button>
                                    </span>
                                </div></td>
                    </tr>
                        
                    </table>
                    </div>
                    <br />
                </div>
               

                
        <div class="row">
            <div class="col-md-4" style="width: 30% !important;">
                <!-- AREA CHART -->
                <div class="box box-solid bg-light-blue-gradient">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-bar-chart"></i>Employees By Status</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px;">
                              <div id="divChart3" style="height: 300px;"></div>
                        </div>
                    </div>
                </div>
                
                <div class="box box-solid bg-aqua-gradient">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-bar-chart"></i>Age Distribution</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <!-- /.box-header -->
                        <div class="box-body no-padding" style="height: 300px; ">
                          <div id="divChart1" style="height: 320px;" src="">
                    
                     </div>
                        </div>
                        <!-- /.box-body -->
                        <!-- /.box -->
                    </div>
                </div>
            </div>
            <div class="col-md-4" style="width:37% !important;">
                <!-- AREA CHART -->
                <div class="box box-solid box-success" style="background-color:  antiquewhite;">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Salary By Branch</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 670px;overflow-y: scroll;background-color:  antiquewhite;">
                          <div id="divtbldata" style="height: 300px; display:none;"></div>
                          <div id="div_employesatusdetails">
        <div class='divcontainer' style="overflow: auto;">
            

            <div id="div_gosvd">
                <div class="demo-section k-content" style="background-color:  antiquewhite;">
                    <ul id="treeview">
                        <%-- //-------------------Group Of Vyshnavi Dairy----------------//   --%>
                        <li data-expanded="true" class="k-item k-first k-last" role="treeitem" data-uid="adb6c08e-c934-4ee1-9a70-bc22697b8d0d"
                            aria-selected="false" style="border: 1px; width: 80%;">
                            <div class="k-top k-bot">
                                <span class="k-icon k-i-collapse"></span><span class="k-in"><span class="k-sprite folder">
                                </span><span class="k-in" style="border: 1px solid; background: aliceblue;"><span
                                    class="k-sprite folder"></span>Group Of Vyshnavi Dairy &nbsp; <span id="spn_gosvdtotsal"
                                        style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                        font-size: 14px; position: relative; height: 26px; line-height: 21px;">₹ 00/-</span>
                                    <span id="spn_gosvdtotsal2" style="display: none;"></span>&nbsp; <span id="spn_gsvdsPers" style="background-color: rgb(68, 128, 226);
                                        color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                        height: 26px; line-height: 21px;">0.0% </span></span></span>
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
                                                font-size: 14px; position: relative; height: 26px; line-height: 21px;">₹ 00/-</span>
                                            <span id="spn_svdstotsal2" style="display: none;"></span>&nbsp; <span id="spn_svdsPers"
                                                style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                font-size: 14px; position: relative; height: 26px; line-height: 21px;">0.0%</span>
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
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;">₹ 00/-</span>
                                                        <span id="spn_svdscctotsal2" style="display: none;"></span>&nbsp; <span id="spn_svdsccPers"
                                                            style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;">0.0%</span>
                                                    </span></span>
                                            </div>
                                            <%--//-------------plant wise list under CC----------------//--%>
                                            <ul style="height: 0px; overflow: visible;">
                                                    <li class="k-item" role="treeitem" data-uid="e81addf7-e873-48de-8efd-d2543fc43c3d"
                                                    aria-selected="false" aria-expanded="false" id="Li6" style="border: 1px; width: 60%;">
                                                        <div id="div_ccdetails" style="padding-left: 25%;"></div>
                                                    </li>
                                            </ul>
                                        </li>
                                        <li class="k-item" role="treeitem" data-uid="e81addf7-e873-48de-8efd-d2543fc43c3d"
                                            aria-selected="false" aria-expanded="false" id="Li2" style="border: 1px; width: 60%;">
                                            <div class="k-top">
                                                <span class="k-icon k-i-expand" onclick="get_svdsplant_report();"></span><span class="k-in">
                                                    <span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                        background: aliceblue;"><span class="k-sprite folder"></span>Plant &nbsp; <span id="spn_svdsplanttotsal"
                                                            style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;">₹ 00/-</span>
                                                        <span id="spn_svdsplanttotsal2" style="display: none;"></span>&nbsp; <span id="spn_svdsplantPers"
                                                            style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;">0.0% </span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_punabaka_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_Kuppam_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                            line-height: 21px;">₹ 00/-</span><span id="spn_svdssalestotsal2" style="display: none;">
                                                        </span>&nbsp; <span id="spn_svdssalesPers" style="background-color: rgb(68, 128, 226);
                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_chn_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_bng_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_kanchi_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_nlr_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_mndpl_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_tpt_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Chennai Corporate ofc
                                                                    &nbsp; <span id="spn_cmo_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_cmo_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/- </span>&nbsp; <span id="spn_skht_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0% </span></span></span>
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
                                                                    background: aliceblue;"><span class="k-sprite folder"></span>Madanapalli Parlor &nbsp;
                                                                    <span id="spn_mdnplp_totsal" style="background-color: rgb(68, 128, 226); color: #fff;
                                                                        padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                                        line-height: 21px;">₹ 00/- </span>&nbsp; <span id="spn_mdnplp_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0% </span></span></span>
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
                                                font-size: 14px; position: relative; height: 26px; line-height: 21px;">₹ 00/-</span>
                                            <span id="spn_svdtotsal2" style="display: none;"></span>&nbsp; <span id="spn_svdPers"
                                                style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                font-size: 14px; position: relative; height: 26px; line-height: 21px;">0.0%</span>
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
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;">₹ 00/-</span><span id="spn_svdcctotsal2" style="display: none;"></span>
                                                        &nbsp; <span id="spn_svdccPers" style="background-color: rgb(68, 128, 226); color: #fff;
                                                            padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative; height: 26px;
                                                            line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_kavalicc_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_Kondepi_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_Kavaliplnt_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_Gudluru_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_gdpl_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_csp_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                            </ul>
                                        </li>
                                    </ul>
                                </li>
                                <%-- //-------------------SVf----------------//   --%>
                                <li class="k-item" role="treeitem" data-uid="d637e460-3d61-4ca2-9a48-1caa4b71ae77"
                                    aria-selected="false" aria-expanded="false" id="Li8" style="border: 1px; width: 80%;">
                                    <div class="k-top">
                                        <span class="k-icon k-i-expand"></span><span class="k-in"><span class="k-sprite folder">
                                        </span><span class="k-in" style="border: 1px solid; background: aliceblue;"><span
                                            class="k-sprite folder"></span>SVF &nbsp; <span id="spn_svftotsal" style="background-color: rgb(68, 128, 226);
                                                color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                height: 26px; line-height: 21px;">₹ 00/-<span id="spn_svftotsal2" style="display: none;">
                                                </span> </span>&nbsp; <span id="spn_svfPers" style="background-color: rgb(68, 128, 226);
                                                    color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                    height: 26px; line-height: 21px;">0.0% </span></span></span>
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
                                                    line-height: 21px;">₹ 00/-</span><span id="spn_RMRDEtotsal2" style="display: none;">
                                                </span>&nbsp; <span id="spn_rmrdPers" style="background-color: rgb(68, 128, 226);
                                                    color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                    height: 26px; line-height: 21px;">0.0%</span></span></span>
                                    </div>
                                    <ul class="k-group" style="overflow: visible; display: none; height: 0px;">
                                        <li class="k-item" role="treeitem" data-uid="e81addf7-e873-48de-8efd-d2543fc43c3d"
                                            aria-selected="false" aria-expanded="false" id="Li14" style="border: 1px; width: 60%;">
                                            <div class="k-top">
                                                <span class="k-icon k-i-expand" onclick="get_rmdrplant_report();"></span><span class="k-in">
                                                    <span class="k-sprite folder"></span><span class="k-in" style="border: 1px solid;
                                                        background: aliceblue;"><span class="k-sprite folder"></span>Plant &nbsp; <span id="spn_rmrplant_totsal"
                                                            style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;">₹ 00/-</span>
                                                        <span id="spn_rmrplant_totsal2" style="display: none;"></span>&nbsp; <span id="spn_rmrplant_Pers"
                                                            style="background-color: rgb(68, 128, 226); color: #fff; padding: 4px 8px; border-radius: 5px;
                                                            font-size: 14px; position: relative; height: 26px; line-height: 21px;">0.0%</span>
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
                                                                        line-height: 21px;">₹ 00/-</span>&nbsp; <span id="spn_rmrdplant_Pers" style="background-color: rgb(68, 128, 226);
                                                                            color: #fff; padding: 4px 8px; border-radius: 5px; font-size: 14px; position: relative;
                                                                            height: 26px; line-height: 21px;">0.0%</span></span></span>
                                                            </div>
                                                        </span>
                                                    </div>
                                                </li>
                                            </ul>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>

                    </div>
                </div>
             </div>
            </div>
              </div>
             </div>
           </div>
            <div class="col-md-4" style="width:30% !important;">
                <!-- LINE CHART -->
                <div class="box box-solid" style="background: linear-gradient(to right, #ccccff 47%, #ffccff 105%)">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-bar-chart"></i>Additions & Attrition

                        </h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip" data-original-title="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px; ">
                            <div id="graph" style="height: 300px;"></div>
                        </div>
                    </div>
                </div>
                <div class="box box-solid bg-yellow-gradient">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-pie-chart"></i>Gender Distribution - Current Employees</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px; ">
                           <div id="divChart" style="height: 300px; ">
                         </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%--//-----------test------------//--%>

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
        <%--//-----------test------------//--%>


        <div class="row">
        <div class="box box-solid " style=" background: linear-gradient(to top, #ffffff 38%, #ffcc99 120%)">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-bar-chart"></i>Salary By Branch</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <!-- /.box-header -->
                        <div class="box-body no-padding" style="height: 370px; ">
                          <div id="divChart4" style="width: 100%; height: 400px;"src="">
                    
                     </div>
                        </div>
                        <!-- /.box-body -->
                        <!-- /.box -->
                    </div>
                </div>
                   <%--<div class="col-md-6">
           <div class="box box-solid bg-green-gradient">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-pie-chart"></i>Salary By Department</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px; ">
                           <div id="chartdiv" style="height: 300px; ">
                         </div>
                        </div>
                    </div>
                </div>
                </div>--%>
                <div class="col-md-6" style="width: 100%;">
           <div class="box box-solid " style=" background: linear-gradient(to bottom, #ccffff 0%, #ffffff 100%);">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-bar-chart"></i>Last 6 Months Salary By Total Branches</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px; ">
                           <div id="Divbaravg" style="height: 300px; ">
                         </div>
                        </div>
                    </div>
                </div>
                </div>
                </div>
       
                <!-- LINE CHART -->
                
         <script type="text/javascript" src="plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- Bootstrap 3.3.6 --><script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
<!-- DataTables -->
<script type="text/javascript" src="plugins/datatables/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="plugins/datatables/dataTables.bootstrap.min.js"></script>
<%--<script src="../../plugins/datatables/jquery.dataTables.min.js"></script>
<script src="../../plugins/datatables/dataTables.bootstrap.min.js"></script>--%>
<!-- SlimScroll -->
<script src="plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="plugins/fastclick/fastclick.js"></script>
<!-- AdminLTE App -->
<script type="text/javascript" src="dist/js/app.min.js"></script>
<script src="../../dist/js/app.min.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="dist/js/demo.js"></script>
<!-- page script -->

<script src="js/jquery.blockUI.js" type="text/javascript"></script>
    <script src="JSF/jquery-ui.js" type="text/javascript"></script>
    <script src="JSF/jquery.blockUI.js" type="text/javascript"></script>
<script>
    $(function () {
        //$("#example1").DataTable();
        $('#example2').DataTable({
            "paging": true,
            "lengthChange": false,
            "searching": false,
            "ordering": true,
            "info": true,
            "autoWidth": false
        });
    });
</script>        
                
                <footer class="main-footer">
       
<div class="pull-right hidden-xs">
</div>
        <strong>Copyright &copy; 2014-2015 <a target="_blank" href="http://vyshnavifoods.com">
            Sri Vyshnavi Foods Pvt Ltd</a>.</strong> All rights reserved.
      </footer>
    </section>
</body>
</html>
