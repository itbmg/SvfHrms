<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="MainPage.aspx.cs" Inherits="MainPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="http://mottie.github.io/tablesorter/css/theme.default.css" rel="stylesheet">
     
    <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script> 
    <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.9.1/jquery.tablesorter.min.js"></script>

 <style>
.table>thead>tr>th, .table>tbody>tr>th, .table>tfoot>tr>th, .table>thead>tr>td, .table>tbody>tr>td, .table>tfoot>tr>td {
    border-style:none;
    line-height: 0px;
}
</style>
 <script type="text/javascript">
     $(function () {
         GetEmployeeDeatails();
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
     
     function GetEmployeeDeatails() {
         var data = { 'op': 'get_all_dash_employeedetails' };
         var s = function (msg) {
             if (msg) {
                 if (msg) {
                     fillnew_employee_list(msg);
                     fillAnniversary_employee_list(msg);
                     fillConfirmation_Due_employee(msg);
                     fillUpcoming_employee_birthDays(msg);
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
     var array = [];
     var sorted = array.sort(fillUpcoming_employee_birthDays);
     function fillUpcoming_employee_birthDays(msg) {
         sorted.push(fillUpcoming_employee_birthDays);
         var table = document.getElementById("tbl_Upcoming_birthDays_list");
         for (var i = table.rows.length - 1; i > 0; i--) {
             table.deleteRow(i);
         }
         
         var j = 1;
         var k = 0;
         var COLORUE = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
         for (var i = 0; i < msg.length; i++) {
             var tablerowcnt = document.getElementById("tbl_Upcoming_birthDays_list").rows.length;
             var placeholder = msg[i].Birth_Days;
             var empname = msg[i].empname + " - " + msg[i].empnum + " [ " + placeholder + " ] ";
             var jBirthDays = msg[i].BirthDays;
             var BirthDays = parseInt(jBirthDays);
             if (BirthDays < 10) {
                 var img_url = "";
                 var rndmnum = Math.floor((Math.random() * 10) + 1);
                 var ftplocation = "http://182.18.138.228:81/";
                 img_url = ftplocation + msg[i].photo + '?v=' + rndmnum;
                 if (msg[i].photo != "") {
                     img_url = ftplocation + msg[i].photo + '?v=' + rndmnum;
                 }
                 else {
                     img_url = "Images/Employeeimg.jpg";
                 }
                 $('#tbl_Upcoming_birthDays_list').append('<tr style="background-color:' + COLORUE[k] + '"><th scope="Category Name" style="color: #3c8dbc;"><img src=' + img_url + '  style="cursor:pointer;height:30px;width:30px;border-radius:30%;"/>' + empname + '</th></tr>');
                 $('#tbl_Upcoming_birthDays_list').append('<tr style="height: 3px;"><th scope="Category Name" style="height: 3px;"></th></tr>');
                 k = k + 1;
                 if (k == 4) {
                     k = 0;
                 }
             }
         }
     }
     
     function fillAnniversary_employee_list(msg) {
         var table = document.getElementById("tbl_Joining_Anniversary");
         for (var i = table.rows.length - 1; i > 0; i--) {
             table.deleteRow(i);
         }
         var j = 1;
         var k = 0;
         var COLORAE = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
         for (var i = 0; i < msg.length; i++) {
             var tablerowcnt = document.getElementById("tbl_Joining_Anniversary").rows.length;
             var jyears = msg[i].joingyears;
             var joingyears = parseInt(jyears);
             if (joingyears >= 1) {
             }
             else {
                 var img_url = "";
                 var rndmnum = Math.floor((Math.random() * 10) + 1);
                 var ftplocation = "http://182.18.138.228:81/";
                 img_url = ftplocation + msg[i].photo + '?v=' + rndmnum;
                 if (msg[i].photo != "") {
                     img_url = ftplocation + msg[i].photo + '?v=' + rndmnum;
                 }
                 else {
                     img_url = "Images/Employeeimg.jpg";
                 }
                 var placeholder = joingyears + " Years ago";
                 var empname = msg[i].empname + " - " + msg[i].empnum + " [ " + placeholder + " ] ";
                 $('#tbl_Joining_Anniversary').append('<tr style="background-color:' + COLORAE[k] + '"><th scope="Category Name" style="color: #3c8dbc;"><img src=' + img_url + '  style="cursor:pointer;height:30px;width:30px;border-radius:30%;"/>' + empname + '</th></tr>');
                 $('#tbl_Joining_Anniversary').append('<tr style="height: 3px;"><th scope="Category Name" style="height: 3px;" ></th></tr>');
                 j++;
                 k = k + 1;
                 if (k == 4) {
                     k = 0;
                 }
             }
         }
     }

     function fillConfirmation_Due_employee(msg) {
         var table = document.getElementById("tbl_Confirmation_Due");
         for (var i = table.rows.length - 1; i > 0; i--) {
             table.deleteRow(i);
         }
         var j = 1;
         var k = 0;
         var COLORDE = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
         for (var i = 0; i < msg.length; i++) {
             var tablerowcnt = document.getElementById("tbl_Confirmation_Due").rows.length;
             var jyears = msg[i].joingyears;
             var joingyears = parseInt(jyears);
             if (joingyears >= 1) {
                 var img_url = "";
                 var rndmnum = Math.floor((Math.random() * 10) + 1);
                 var ftplocation = "http://182.18.138.228:81/";
                 img_url = ftplocation + msg[i].photo + '?v=' + rndmnum;
                 if (msg[i].photo != "") {
                     img_url = ftplocation + msg[i].photo + '?v=' + rndmnum;
                 }
                 else {
                     img_url = "Images/Employeeimg.jpg";
                 }
                 var placeholder = joingyears + " Years ago";
                 var empname = msg[i].empname + " - " + msg[i].empnum + " [ " + placeholder + " ] ";
                 $('#tbl_Confirmation_Due').append('<tr style="background-color:' + COLORDE[k] + '"><th scope="Category Name" style="color: #3c8dbc;"><img src=' + img_url + '  style="cursor:pointer;height:30px;width:30px;border-radius: 30%;"/>' + empname + '</th></tr>');
                 $('#tbl_Confirmation_Due').append('<tr style="height: 3px;"><th scope="Category Name" style="height: 3px;" ></th></tr>');
                 j++;
                 k = k + 1;
                 if (k == 4) {
                     k = 0;
                 }
             }
         }
     }
     function fillnew_employee_list(msg) {
         var table = document.getElementById("tbl_new_employee_list");
         for (var i = table.rows.length - 1; i > 0; i--) {
             table.deleteRow(i);
         }
         var j = 0;
         var k = 0;
         var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
         for (var i = 0; i < msg.length; i++) {
             var tablerowcnt = document.getElementById("tbl_new_employee_list").rows.length;
             var jdays = msg[i].joingdays;
             var joingdays = parseInt(jdays);
             var placeholder = joingdays + " Days ago";
             var empname = msg[i].empname + " - " + msg[i].empnum + " [ " + placeholder + " ] ";
             if (joingdays > 60) {
             }
             else {
                 var img_url = "";
                 var rndmnum = Math.floor((Math.random() * 10) + 1);
                 var ftplocation = "http://182.18.138.228:81/";
                 img_url = ftplocation + msg[i].photo + '?v=' + rndmnum;
                 if (msg[i].photo != "") {
                     img_url = ftplocation + msg[i].photo + '?v=' + rndmnum;
                 }
                 else {
                     img_url = "Images/Employeeimg.jpg";
                     //                                 $('.prw_img,#imgemp').attr('src', 'Images/Employeeimg.jpg').width(20).height(20);
                 }
                 $('#tbl_new_employee_list').append('<tr style="background-color:' + COLOR[k] + '"><th scope="Category Name" style="color: #3c8dbc;"><img src=' + img_url + '  style="cursor:pointer;height:30px;width:30px;border-radius:30%;"/>' + empname + '</th></tr>');
                 $('#tbl_new_employee_list').append('<tr style="height:2px;"><th scope="Category Name" style="height:2px;"></th></tr>');                
                 j++;
                 k = k + 1;
                 if (k == 4) {
                     k = 0;
                 }
             }
         }
     }

</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <section class="content-header">
        <h1>
            Day-to-Day Activities <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
        </ol>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-md-6">
                <!-- AREA CHART -->
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-user-plus"></i>New Employees Details</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px; overflow-y: scroll;">
                            <table class="table" id="tbl_new_employee_list">
                            </table>
                        </div>
                    </div>
                </div>
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Joining Anniversary</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <!-- /.box-header -->
                        <div class="box-body no-padding" style="height: 300px; overflow-y: scroll;">
                            <table class="table" id="tbl_Joining_Anniversary">
                            </table>
                        </div>
                        <!-- /.box-body -->
                        <!-- /.box -->
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <!-- LINE CHART -->
                <div class="box box-danger">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-fw fa-birthday-cake"></i>Upcoming Birthdays Details
                        </h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px; overflow-y: scroll;">
                            <table class="table" id="tbl_Upcoming_birthDays_list">
                               </table>
                        </div>
                    </div>
                </div>
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Employee Years Of Service Details</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px; overflow-y: scroll;">
                            <table   id="tbl_Confirmation_Due" class="table">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>

