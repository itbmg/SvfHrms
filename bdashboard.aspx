<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="bdashboard.aspx.cs" Inherits="bdashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
   
   <link rel="stylesheet" href="//kendo.cdn.telerik.com/2016.2.714/styles/kendo.common-material.min.css" />
    <link rel="stylesheet" href="//kendo.cdn.telerik.com/2016.2.714/styles/kendo.material.min.css" />
    <link rel="stylesheet" href="//kendo.cdn.telerik.com/2016.2.714/styles/kendo.default.mobile.min.css" />

    <script src="//kendo.cdn.telerik.com/2016.2.714/js/jquery.min.js"></script>
    <script src="//kendo.cdn.telerik.com/2016.2.714/js/kendo.all.min.js"></script>

    <script type="text/javascript">
        $(function () {
            get_birthday_details();
            get_leave_details();
            get_holiday_details();
            get_employe_taskdetails();
            get_bullentin_details();
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
        function get_employe_taskdetails() {
            var data = { 'op': 'get_employe_taskdetails' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filltaskdetails(msg);
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
        function filltaskdetails(msg) {
            var table = document.getElementById("tbl_taskdetails_list");
            for (var k = table.rows.length - 1; k > 0; k--) {
                table.deleteRow(k);
            }
            var j = 1;
            var l = 0;
            var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                var tablerowcnt = document.getElementById("tbl_taskdetails_list").rows.length;
                var task = msg[i].assetname;
                var module = msg[i].assetvalue;
                var empname = msg[i].fullname + " - " + task + " - " + module;
                $('#tbl_taskdetails_list').append('<tr style="background-color:' + COLOR[l] + '"><th scope="Category Name" style="color: #3c8dbc;">' + empname + '</th></tr>');
                $('#tbl_taskdetails_list').append('<tr><th scope="Category Name"></th></tr>');
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
        }
        function get_birthday_details() {
            var data = { 'op': 'get_birthday_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbdetails(msg);
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
        function fillbdetails(msg) {
            var table = document.getElementById("tbl_Upcoming_birthDays_list2");
            for (var k = table.rows.length - 1; k > 0; k--) {
                table.deleteRow(k);
            }
            var j = 1;
            var l = 0;
            var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                var tablerowcnt = document.getElementById("tbl_Upcoming_birthDays_list2").rows.length;
                var img_url = "";
                var rndmnum = Math.floor((Math.random() * 10) + 1);
                img_url = msg[i].ftplocation + msg[i].photo + '?v=' + rndmnum;
                if (msg[i].photo != "") {
                    img_url = msg[i].ftplocation + msg[i].photo + '?v=' + rndmnum;
                }
                else {
                    img_url = "Images/Employeeimg.jpg";
                }
                var placeholder = msg[i].Birth_Days;
                var empname = msg[i].empname + " - " + msg[i].empnum;
                $('#tbl_Upcoming_birthDays_list2').append('<tr style="background-color:' + COLOR[l] + '"><th scope="Category Name" style="color: #3c8dbc;"><img src=' + img_url + '  style="cursor:pointer;height:50px;width:50px;border-radius:50%;"/>' + empname + '</th></tr>');
                $('#tbl_Upcoming_birthDays_list2').append('<tr><th scope="Category Name"></th></tr>');                
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
        }

        function get_leave_details() {
            var data = { 'op': 'get_leave_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillldetails(msg);
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
        function fillldetails(msg) {
            var table = document.getElementById("tbl_leavedetails_list");
            for (var k = table.rows.length - 1; k > 0; k--) {
                table.deleteRow(k);
            }
            var j = 1;
            var l = 0;
            var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                var tablerowcnt = document.getElementById("tbl_leavedetails_list").rows.length;
                var img_url = "";
                var rndmnum = Math.floor((Math.random() * 10) + 1);
                img_url = msg[i].ftplocation + msg[i].photo + '?v=' + rndmnum;
                if (msg[i].photo != "") {
                    img_url = msg[i].ftplocation + msg[i].photo + '?v=' + rndmnum;
                }
                else {
                    img_url = "Images/Employeeimg.jpg";
                }
                var placeholder = msg[i].conformdate;
                var empname = msg[i].empname + " Apply" + placeholder + " Days Leave";
                $('#tbl_leavedetails_list').append('<tr style="background-color:' + COLOR[l] + '"><th scope="Category Name"><img src=' + img_url + '  style="cursor:pointer;height:30px;width:30px;border-radius:30%;"/>' + empname + '</th></tr>');
                $('#tbl_leavedetails_list').append('<tr><th scope="Category Name"></th></tr>');
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
        }
        function get_holiday_details() {
            var data = { 'op': 'get_holiday_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillhdetails(msg);
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

        function fillhdetails(msg) {
            var table = document.getElementById("tbl_holidaydetails_list");
            for (var k = table.rows.length - 1; k > 0; k--) {
                table.deleteRow(k);
            }
            var j = 1;
            var l = 0;
            var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                var tablerowcnt = document.getElementById("tbl_holidaydetails_list").rows.length;
                var placeholder = msg[i].empname;
                $('#tbl_holidaydetails_list').append('<tr style="background-color:' + COLOR[l] + '"><th scope="Category Name">' + placeholder + '</th></tr>');
                $('#tbl_holidaydetails_list').append('<tr><th scope="Category Name"></th></tr>');
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
        }

        function sendmailclick() {
            var email = document.getElementById("txtemail").value;
            var subject = document.getElementById("txtsubject").value;
            var area = document.getElementById("txtarea").value;
            var data = { 'op': 'send_employee_mail', 'subject': subject, 'area':area, 'email': email };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        alert("Message send successfully");
                        document.getElementById("txtemail").value = "";
                        document.getElementById("txtsubject").value = "";
                        document.getElementById("txtarea").value = "";
                    }
                    else {
                    }
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        $(document).ready(function () {
            // create Calendar from div HTML element
            $("#calendar").kendoCalendar();
        });

        function get_bullentin_details() {
            var data = { 'op': 'get_bullentin_details' };
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
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        //var content = document.getElementById("txt_descrption").textContent;
        function filldetails(msg) {
            var k = 1;
            var results = '<div class="divcontainer" ><table class="table table-bordered table-hover dataTable no-footer" boarder="0">';
            var l = 0;
            var color = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + color[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].title + '</th>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].description + '</td>';
                results += '<td data-title="brandstatus" style="display:none" class="3">' + msg[i].sno + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_bulentdata").html(results);
        }
      
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="content-wrapper" style="margin-left: 10px !important; font-size:12px !important;">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                Dashboard <small>Control panel</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="#"><i class="fa fa-dashboard"></i>Home</a></li>
                <li class="active">Dashboard</li>
            </ol>
        </section>
        <!-- Main content -->
        <section class="content">
            <!-- Small boxes (Stat box) -->
            
            <!-- /.row -->
            <!-- Main row -->
            <div class="row">
                <!-- Left col -->
                <section class="col-lg-7 connectedSortable" style="width:33% !important;">
                    <!-- Custom tabs (Charts with tabs)-->
                    <div class="nav-tabs-custom">
                        <!-- Tabs within a box -->
                        <ul class="nav nav-tabs pull-right">
                            <li class="pull-left header"><i class="fa fa-fw fa-birthday-cake"></i>To Day Birthdays</li>
                        </ul>
                        <div class="tab-content no-padding">
                            <!-- Morris chart - Sales -->
                            <div id="divbirthdays" style="height: 300px; overflow-y: scroll;">
                                <table class="table" id="tbl_Upcoming_birthDays_list2">
                                </table>
                            </div>
                        </div>
                    </div>
                    <!-- /.nav-tabs-custom -->
                    <div class="box box-info">
                        <div class="box-header">
                            <i class="ion ion-clipboard"></i>
                            <h3 class="box-title">
                               Holidays List</h3>
                            <div class="box-tools pull-right">
                                <button type="button" class="btn bg-teal btn-sm" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                                <button type="button" class="btn bg-teal btn-sm" data-widget="remove">
                                    <i class="fa fa-times"></i>
                                </button>
                            </div>
                        </div>
                        <div class="box-body border-radius-none">
                            <div class="chart" id="line-chart" style="height: 247px; overflow-y: scroll;">
                            <table class="table" id="tbl_holidaydetails_list">
                                </table>
                            </div>
                        </div>
                    </div>
                </section>
                <!-- /.Left col -->
                <!-- right col (We are only adding the ID to make the widgets sortable)-->
                <section class="col-lg-5 connectedSortable" style="width:31% !important;">
                    <!-- Map box -->
                    <!-- quick email widget -->
                    <div class="box box-info">
                        <div class="box-header">
                            <i class="fa fa-envelope"></i>
                            <h3 class="box-title">
                                Quick Email</h3>
                            <!-- tools box -->
                            <div class="pull-right box-tools">
                                <button type="button" class="btn btn-info btn-sm" data-widget="remove" data-toggle="tooltip"
                                    title="Remove">
                                    <i class="fa fa-times"></i>
                                </button>
                            </div>
                            <!-- /. tools -->
                        </div>
                        <div class="box-body">
                            <form action="#" method="post">
                            <div class="form-group">
                                <input type="email" id="txtemail" class="form-control" name="emailto" placeholder="Email to:">
                            </div>
                            <div class="form-group">
                                <input type="text" id="txtsubject" class="form-control" name="subject" placeholder="Subject">
                            </div>
                            <div>
                                <textarea id="txtarea" class="textarea" placeholder="Message" style="width: 100%; height: 125px;
                                    font-size: 14px; line-height: 18px; border: 1px solid #dddddd; padding: 10px;"></textarea>
                            </div>
                            </form>
                        </div>
                        <div class="box-footer clearfix">
                            <button type="button" class="pull-right btn btn-default" id="sendEmail" onclick="sendmailclick()">
                                Send <i class="fa fa-arrow-circle-right"></i>
                            </button>
                        </div>
                    </div>
                    
                   <div class="box box-info">
                        <div class="box-header">
                            <i class="fa fa-tasks"></i>
                            <h3 class="box-title">
                               Tasks</h3>
                            <div class="box-tools pull-right">
                                <button type="button" class="btn bg-teal btn-sm" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                                <button type="button" class="btn bg-teal btn-sm" data-widget="remove">
                                    <i class="fa fa-times"></i>
                                </button>
                            </div>
                        </div>
                        <div class="box-body border-radius-none">
                            <div class="chart" id="Div2" style="height: 247px; overflow-y: scroll;">
                            <table class="table" id="tbl_taskdetails_list">
                                </table>
                            </div>
                        </div>
                    </div>
                    <!-- Calendar -->
                    
                    <!-- /.box -->
                </section>
                <!-- right col -->

                <section class="col-lg-5 connectedSortable" style="width:31% !important;">
                    <div class="box box-info">
                        <div class="box-header">
                            <!-- tools box -->
                            <div class="pull-right box-tools">
                                <button type="button" class="btn btn-primary btn-sm daterange pull-right" data-toggle="tooltip"
                                    title="Date range">
                                    <i class="fa fa-calendar"></i>
                                </button>
                                <button type="button" class="btn btn-primary btn-sm pull-right" data-widget="collapse"
                                    data-toggle="tooltip" title="Collapse" style="margin-right: 5px;">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>
                            <!-- /. tools -->
                            <i class="fa fa-map-marker"></i>
                            <h3 class="box-title">
                                Alerts
                            </h3>
                        </div>
                        <div class="box-body">
                            <div id="world-map" style="height: 267px; overflow-y: scroll; width: 100%;">
                                <table class="table" id="tbl_leavedetails_list">
                                </table>
                            </div>
                        </div>
                        <!-- /.box-body-->
                    </div>
                    <!-- /.box -->
                    <!-- solid sales graph -->
                    
                    <!-- /.box -->
                    <!-- Calendar -->
                    <div class="box box-info">
                        <div class="box-header">
                            <i class="fa fa-calendar"></i>
                            <h3 class="box-title">
                                Calendar</h3>
                            <!-- tools box -->
                            <div class="pull-right box-tools">
                                <!-- button with a dropdown -->
                                <button type="button" class="btn btn-success btn-sm" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                                <button type="button" class="btn btn-success btn-sm" data-widget="remove">
                                    <i class="fa fa-times"></i>
                                </button>
                            </div>
                            <!-- /. tools -->
                        </div>
                        <!-- /.box-header -->
                        <div class="box-body">
                            <!--The calendar -->
                            <div id="calendar"></div>
                        </div>
                        <!-- /.box-body -->
                    </div>
                    <!-- /.box -->
                </section>
                <section class="col-lg-5 connectedSortable"  style="width:100% !important;">
                <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-tachometer"></i>Bulletin DashBoard 
                </h3>
                <h3 class="box-title">
                    <label id="lblsessionname">
                    </label>
                </h3>
            </div>
            <div class="box-body">
                <div>
                    <table>
                        <tr>
                            <td>
                                <marquee id="txt_descrption" behavior="scroll" onMouseOver="this.stop()" onMouseOut="this.start()" scrollamount="3" direction="left">
                   <div id="div_bulentdata"></div>
                    </marquee>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
                </section>
            </div>
            <!-- /.row (main row) -->
        </section>
        <!-- /.content -->
    </div>
</asp:Content>
