<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="dailyactivitiesMaster.aspx.cs" Inherits="dailyactivitiesMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
  <link href="autocomplete/jquery-ui.css?v=3002" rel="stylesheet" type="text/css" />
<style type="text/css">
        .container
        {
            max-width: 100%;
        }
        th
        {
            text-align: center;
        }
    </style>
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
        //get_dailyactivity_conduct_details();
        //get_Employeedetails();
        get_Employeedetails();
        GetFixedrows();
        $("#dialyactive").show();
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
        $('#txtStarttime').val(hrs + ':' + mnts);
        $('#txtEndtime').val(hrs + ':' + mnts); 
        $('#txtfromdate').val(yyyy + '-' + mm + '-' + dd);
        $('#txttodate').val(yyyy + '-' + mm + '-' + dd);
        $('#txt_Meetingdate').val(yyyy + '-' + mm + '-' + dd); 
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
                Error: e
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

        function showdailyactivity() {
            $("#dialyactive").show();
            $("#div_dalyactvereport").hide();

        }

        function showdailyactivityreport() {
            $("#dialyactive").hide();
            $("#div_dalyactvereport").show();
     
        }


        var employeedetails = [];
        function get_Employeedetails() {
            var data = { 'op': 'get_all_dash_employeedetails' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#txt_empname1').autocomplete({
                        source: empnameList,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }

        function GetFixedrows() {

            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Conclusion</th></tr></thead></tbody>';
            for (var i = 1; i < 6; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txtCode" class="codecls"   placeholder= "Conclusion" style="width:920px;height:50px;" /></td>';
                results += '<td data-title="minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }

        function Save_DailyActivity_Details() {
            var meetingdate = document.getElementById('txt_Meetingdate').value;
            var starttime = document.getElementById('txtStarttime').value;
            var endtime = document.getElementById('txtEndtime').value;
    
            var remarks = document.getElementById('txt_remarks').value;
            var btnval = document.getElementById('btn_save').value;
            if (btnval = "Save") {
                $("#btn_save").show();
            }
            
            if (meetingdate == "") {
                alert("Enter  Employee Name ");
                $("#txt_empname1").focus();
                return false;
            }
            if (meetingdate == "") {
                alert("Enter  Meeting Date");
                $("#txt_Meetingdate").focus();
                return false;
            }
            if (starttime == "") {
                alert("Enter  Start Time");
                $("#txtStarttime").focus();
                return false;
            }
            if (endtime == "") {
                alert("Enter End Time");
                $("#txtEndtime").focus();
                return false;
            }
            var fillitems = [];
            $('#tabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtSno').text();
                var conclusion = $(this).find('#txtCode').val();
                fillitems.push({ 'txtsno': txtsno, 'conclusion': conclusion
                });
            });
            if (fillitems.length == 0) {
                alert("Please enter conclusion");
                return false;
            }

            var remarks = document.getElementById('txt_remarks').value;
            var remarks = document.getElementById('txt_remarks').value;
            var data = { 'op': 'Save_DailyActivity_Details', 'meetingdate': meetingdate, 'starttime': starttime, 'endtime': endtime,  'btnVal': btnval, 'fillitems': fillitems, 'remarks': remarks };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                   
                        canceldetails();
                  
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }

        var DataTable;
        function insertrow() {
            DataTable = [];
            var txtsno = 0;
            var code = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtCode').val() != "") {
                    txtsno = rowsno;
                    code = $(this).find('#txtCode').val();
                    DataTable.push({ Sno: txtsno, code: code });
                    rowsno++;

                }
            });
            code = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, code: code });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Code</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txtCode" type="text" class="codecls"  style="width:920px;height:50px;" value="' + DataTable[i].code + '"/></td>';
                results += '<td data-title="minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        function canceldetails() {
            document.getElementById('txtStarttime').value = "";
            document.getElementById('txt_Meetingdate').value = "";
            document.getElementById('txtEndtime').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('btn_save').innerHTML = "Save";

        }
        var activitydetails = [];
        function btndailyactivity_click() {
            var fromdate = document.getElementById('txtfromdate').value;
            var todate = document.getElementById('txttodate').value
            if (fromdate == "") {
                alert("Please select from date");
                return false;
            }
            if (todate == "") {
                alert("Please select to date");
                return false;
            }
            var formtype = "Dailactivityreport";
            var data = { 'op': 'get_dailyactivity_details', 'fromdate': fromdate, 'todate': todate, 'formtype': formtype };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
              
                        activitydetails = msg;
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

        function filldetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Ref No</th><th scope="col">Branch</th><th scope="col">Remarks</th></tr></thead></tbody>';
            var l = 0;
            var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + msg[i].sno + '</th>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].branchid + '</td>';

                results += '<td data-title="brandstatus" class="2">' + msg[i].subject + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divactivitydata").html(results);
        }

        function btn_Dailyactiviy_generate_click() {
            var activityrefno = document.getElementById('txt_activityrefno').value;
            var data = { 'op': 'get_dailyactivity_Reports', 'activityrefno': activityrefno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        $('#divPrint').css('display', 'block');
                        fillactivitydetails(msg);
                        activitydetails = msg;
                        document.getElementById('spnaactivityrefno').innerHTML = activitydetails[0].activity_no;
                        document.getElementById('spnstartdate').innerHTML = activitydetails[0].starttime;

                        document.getElementById('spndate').innerHTML = activitydetails[0].doe;
                        document.getElementById('SpnEndtime').innerHTML = activitydetails[0].endtime;
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
        function fillactivitydetails(msg) {
            var activityrefno = document.getElementById('txt_activityrefno').value;
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" border="2">';
            results += '<thead><tr style="background:#cbc6dd;"><th scope="col">Sno</th><th scope="col">Activity</th></tr></thead></tbody>';
            var l = 0;
            var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                var subactivitylist = msg[i].fillitems;
                var j = 1;
                for (k = 0; k < subactivitylist.length; k++) {
                    if (activityrefno == subactivitylist[k].activity_no) {
                        results += '<tr style="background-color:' + COLOR[l] + '"><td>' + j++ + '</td>';
                        results += '<td class="1">' + subactivitylist[k].conclusion + '</td></tr>';
                    }
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#div_activityData").html(results);

        }        
        </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
             Organizatin Flow
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Organizatin Flow</a></li>
            <li><a href="#">Organizatin Flow</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Flow Details
                </h3>
            </div>
            <div class="box-body">
            <div>
                            <ul class="nav nav-tabs">
                                <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="showdailyactivity()"><i
                                    class="fa fa-university"></i>&nbsp;&nbsp;Daily Activities</a></li>
                                <li id="Li3" class=""><a data-toggle="tab" href="#" onclick="showdailyactivityreport()"><i
                                    class="fa fa-bar-chart"></i>&nbsp;&nbsp;Daily Activities Report</a></li>
                                    </ul>
                           
                        </div>
               
              
                <div id='dialyactive' style="display: none;">
                    <table align="center">
                    <br />
                    <tr>
                    <td>
                               <label class="control-label" > 
                                    Employe Name</label>
                            </td>
                    <td>
                     <input id="txt_empname1" type="text" style="opacity: 1.0;" class="form-control" placeholder="Search EMP Name" />
                    </td>
                    </tr>
                        <tr>
                         <td>
                               <label class="control-label" > 
                                    Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_Meetingdate" type="date" name="CustomerFName"
                                    class="form-control" />
                            </td>
                            </tr>
                            <tr>
                            <td>
                               <label class="control-label" > 
                                    Start Time</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtStarttime" type="time" name="CustomerFName" 
                                    class="form-control" />
                            </td>
                            <td>
                            </td>
                            <td>
                               <label class="control-label" > 
                                    End Time</label>
                            </td>
                            <td>
                                <input id="txtEndtime" type="time" name="CustomerFName" placeholder="Enter Name"
                                    class="form-control" />
                            </td>
                        </tr>
                       <tr style="height: 5px;">
                        </tr>
                        
                        <tr style="height: 5px;">
                        </tr>
                        <tr>
                        <td style="height: 40px;">
                        <label class="control-label" > 
                            Remarks <span style="color: red;">*</span>
                            </label>
                        </td>
                        <td>
                            <textarea cols="35" rows="3" id="txt_remarks"  class="form-control" placeholder="Enter Remarks" style="border: solid 1px orange;"></textarea>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                        <tr>
                        <td colspan="4" style="height: 60px;">
                         <div id="div_vendordata" style="background: #ffffff"></div>
                         </td>
                         </tr>
                        <tr style="height: 5px;">
                        </tr>
                        <tr style="display: none;">
                            <td>
                                <label id="lbl_sno">
                                </label>
                            </td>
                        </tr>
                    </table>
                   <br />
                    <div id="div_SectionData">
                    </div>
                         <table >
                            <tr>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-plus-sign" id="newrow1"  onclick="insertrow()"></span><span id="newrow" onclick="insertrow()">Insert row</span>
                                        </div>
                                    </div>
                                </td>
                                </tr>
                                </table>
                    <div id="">
                        <div>
                            <table align="center">
                            <tr>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-ok" id="btn_save1"  onclick="Save_DailyActivity_Details()"></span><span id="btn_save" onclick="Save_DailyActivity_Details()">Save</span>
                                        </div>
                                    </div>
                                </td>
                                <td style="width:10px;"></td>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id="btn_close1" onclick="canceldetails()"></span><span id="btn_close" onclick="canceldetails()">Close</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        </div>
                    </div>
                </div>
                <br />
                <div id='div_dalyactvereport' style="display: none;">
                

                <div runat="server" id="d">
                    <table>
                        <tr>
                            <td>
                             <label class="control-label" > 
                                    From Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txtfromdate" class="form-control" />
                            </td>
                            <td>
                               <label class="control-label" > 
                                    To Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txttodate" class="form-control" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class=" glyphicon glyphicon-refresh" id="Button12"  onclick="btndailyactivity_click()"></span><span id="Button1" onclick="btndailyactivity_click()">Get Details</span>
                                        </div>
                                    </div>
                                </td>
                        </tr>
                    </table>
                    <div id="div2" style="height: 300px; overflow-y: scroll;">
                    </div>
                </div>
                <br />
                <br />
                <div>
                    <table>
                        <tr>
                            <td>
                                <label class="control-label" > 
                                    Ref No:</label>
                            </td>
                            <td>
                                <input type="text" id="txt_activityrefno" class="form-control" placeholder="Enter Ref No" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                             <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-refresh" id="Button21"  onclick="btn_Dailyactiviy_generate_click()"></span><span id="Button2" onclick="btn_Dailyactiviy_generate_click()">Get Details</span>
                                        </div>
                                    </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="divPrint" style="display:none;">
                 <div style="width: 13%; float: right;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
                     <div>
                        <div style="font-family: Arial; font-size: 18pt; font-weight: bold; color: Black;">
                            <span>Sri Vyshnavi Dairy Specialities (P) Ltd </span>
                            <br />
                        </div>
                        R.S.No:381/2,Punabaka village Post<br />
                        Pellakuru Mandal,Nellore District -524129.,
                        <br />
                        ANDRAPRADESH (State)<br />
                        Phone: 9440622077, Fax: 044 – 26177799.
                    </div>
                      <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                        <span style="font-size: 26px; font-weight: bold;">Daily Activitiy </span>
                    </div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 49%; float: left;">
                              <label class="control-label" > 
                                    Activity Ref No :</label>
                                <span id="spnaactivityrefno"></span>
                                <br />
                               <label class="control-label" > 
                                    Start Time :</label>
                                <span id="spnstartdate"></span>
                                <br />
                              
                            </td>
                            <td style="width: 49%; float: right;">
                                <label class="control-label" > 
                                    Date :</label>
                                <span id="spndate"></span>
                                <br />
                               <label class="control-label" > 
                                    End Time :</label>
                                <span id="SpnEndtime"></span>
                                <br />
                                <br />
                            </td>
                        </tr>
                    </table>
                     <div id="div_activityData">
                </div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">Prepared By</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">Incharge Sign</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">Authorised By</span>
                            </td>
                        </tr>
                    </table>
                </div>
                <table>
                <tr>
                    <td>
                       <div class="input-group">
                             <div class="input-group-addon">
                                 <span class="glyphicon glyphicon-print" id="Button31"  onclick="javascript:CallPrint('divPrint');" ></span><span id="Button3"  onclick="javascript:CallPrint('divPrint');" >Print</span>
                              </div>
                        </div>
                      </td>
                 </tr>
                </table>
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
                </div>
            </div>
    </section>
</asp:Content>

