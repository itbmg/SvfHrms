<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="DashBoard.aspx.cs" Inherits="DashBoard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .table > thead > tr > th, .table > tbody > tr > th, .table > tfoot > tr > th, .table > thead > tr > td, .table > tbody > tr > td, .table > tfoot > tr > td
        {
            border-style: none;
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
                        fillnew_employee = msg;
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
        function fillnew_employee_list(msg) {
            var monthNames = ["January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"];
            var today = new Date();
            var dd = today.getDate() + 1;
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            mm = monthNames[today.getMonth()];
            var tomorrow = dd + "-" + mm;
            var Tomorrowdate = tomorrow;
            for (var i = 0; i < msg.length; i++) {
                var tablerowcnt = document.getElementById("tbl_new_employee_list").rows.length;
                var empname = msg[i].empname + " - " + msg[i].empnum;
                var email = msg[i].email;
                var cellphone = msg[i].cellphone;
                var img_url = "";
                var placeholder = "";
                var bod = msg[i].Birth_Days;
                var currentdate = msg[i].currentdate;
                var jBirthDays = msg[i].BirthDays;
                var BirthDays = parseInt(jBirthDays);
                if (bod == currentdate || bod == Tomorrowdate) {
                    if (bod == currentdate) {
                        img_url = "http://182.18.162.51/HRMS/Wishes/birthday2.png";
                    }
                    else {
                        img_url = "http://182.18.162.51/HRMS/Wishes/birthday.png";
                    }
                    placeholder = "Happy Birthday " + msg[i].empname + " " + bod + " Have a great year ahead!";
                    var email;
                    var img_url;
                    var cellphone;
                    $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                    $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #999;padding-left: 10%;" >' + placeholder + '</th></tr>');
                    $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                    $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><img src=' + img_url + '  style="cursor:pointer;border-radius: 5px;"/></th></tr>');
                    $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                    $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc; padding-left:10px;"><textarea id="txtremarks" placeholder="Enter Wishes" class="form-control" rows="1" cols="2" style="width:500px;"></textarea><span style="padding-left:465px;"  onclick="sendmailclick(\'' + email + '\',\'' + img_url + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true"></i>Send</span></th></tr>');
                    $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc; padding-left:10px;"><textarea id="txtremarks" placeholder="Enter Wishes" class="form-control" rows="1" cols="2" style="width:500px;"></textarea><span style="padding-left:465px;"  onclick="sendmobileclick(\'' + img_url + '\',\'' + cellphone + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true"></i>Send</span></th></tr>');
                    $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                }
            }

            for (var i = 0; i < msg.length; i++) {
                var empname = msg[i].empname + " - " + msg[i].empnum;
                var jdays = msg[i].joingdays;
                var joingdays = parseInt(jdays);
                if (joingdays > 60) {
                }
                else {
                    if (jdays <10) {
                        if (jdays >= 0 && jdays < 10) {
                            img_url = "http://182.18.162.51/HRMS/Wishes/Welcome.png";
                        }
                        placeholder = msg[i].empname + " has joined us in the company on " + msg[i].joindate;
                        var email;
                        var img_url;
                        var cellphone;
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #999;padding-left: 10%;" >' + placeholder + '</th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><img src=' + img_url + '  style="cursor:pointer;border-radius: 5px;"/></th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc; padding-left:10px;"><textarea id="txtremarks" placeholder="Enter Wishes" class="form-control" rows="1" cols="2" style="width:500px;"></textarea><span style="padding-left:465px;"  onclick="sendmailclick(\'' + email + '\',\'' + img_url + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true"></i>Send</span></th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc; padding-left:10px;"><textarea id="txtremarks" placeholder="Enter Wishes" class="form-control" rows="1" cols="2" style="width:500px;"></textarea><span style="padding-left:465px;"  onclick="sendmobileclick(\'' + img_url + '\',\'' + cellphone + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true"></i>Send</span></th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                    }
                }
            }
            for (var i = 0; i < msg.length; i++) {
                var jyears = msg[i].joingyears;
                var joingdays = msg[i].joingdays;
                var joingyears = parseInt(jyears);
                if (joingyears == 2 || joingyears == 1) {
                    if (joingyears > 0) {
                        if (joingyears == 1) {
                            img_url = "http://182.18.162.51/HRMS/Wishes/anniversary1.png";
                        }
                        else {
                            img_url = "http://182.18.162.51/HRMS/Wishes/anniversary.png";
                        }
                        placeholder = "Our congratulations to " + msg[i].empname + " on completing " + joingyears + " successful year. ";
                        var email;
                        var img_url;
                        var cellphone;
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #999;padding-left: 10%;" >' + placeholder + '</th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><img src=' + img_url + '  style="cursor:pointer;border-radius: 5px;"/></th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc; padding-left:10px;"><textarea id="txtremarks" placeholder="Enter Wishes" class="form-control" rows="1" cols="2" style="width:500px;"></textarea><span style="padding-left:465px;"  onclick="sendmailclick(\'' + email + '\',\'' + img_url + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true"></i>Send</span></th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc; padding-left:10px;"><textarea id="txtremarks" placeholder="Enter Wishes" class="form-control" rows="1" cols="2" style="width:500px;"></textarea><span style="padding-left:465px;"  onclick="sendmobileclick(\'' + img_url + '\',\'' + cellphone + '\');"><i class="fa fa-arrow-circle-right"  aria-hidden="true"></i>Send</span></th></tr>');
                        $('#tbl_new_employee_list').append('<tr><th scope="Category Name" style="color: #3c8dbc;"><br/></th></tr>');
                    }
                }
            }
        }
        function sendmailclick(email, img_url) {
            var email;
            var img_url;
            var data = { 'op': 'send_employee_wishes_mail', 'img_url': img_url, 'email': email };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        alert(msg);
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

          function sendmobileclick( img_url, cellphone) {
              var img_url;
              var cellphone;
              var data = { 'op': 'send_employee_wishes_moblie', 'img_url': img_url, 'cellphone': cellphone };
              var s = function (msg) {
                  if (msg) {
                      if (msg) {
                          alert(msg);
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

          function CallHandlerUsingJson_POST(d, s, e) {
              d = JSON.stringify(d);
              d = encodeURIComponent(d);
              $.ajax({
                  type: "POST",
                  url: "FleetManagementHandler.axd",
                  dataType: "json",
                  contentType: "application/json; charset=utf-8",
                  data: d,
                  async: true,
                  cache: true,
                  success: s,
                  error: e
              });
          }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            DashBoard<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">DashBoard</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-dashboard"></i>DashBoard Details
                </h3>
                
            </div>
            <div>
                <table id="tbl_new_employee_list" align="center">
                </table>
            </div>
        </div>
    </section>
</asp:Content>
