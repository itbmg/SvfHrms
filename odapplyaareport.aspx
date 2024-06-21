<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="odapplyaareport.aspx.cs" Inherits="odapplyaareport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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
        var meetingdetails = [];
        function btnPODetails_click() {
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
            var formtype = "Meetingreport";
            var data = { 'op': 'get_od_details', 'fromdate': fromdate, 'todate': todate, 'formtype': formtype };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
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


        function filldetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Ref No</th><th scope="col">Employeename</th><th scope="col">Reporting</th><th scope="col">totaldays</th></tr></thead></tbody>';
            var l = 0;
            var k = 1;
            var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><th><input id="btn_Print" type="button"   onclick="printclick(this);"  name="Edit" class="btn btn-primary" value="Print" /></th>'
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1"  style="display:none">' + msg[i].sno + '</th>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].fullname + '</td>';
                results += '<td data-title="brandstatus" class="3">' + msg[i].reportingempid + '</td>';
                results += '<td data-title="brandstatus" class="4">' + msg[i].totaldays + '</td></tr>';
            }
            results += '</table></div>';
            $("#divoddata").html(results);
        }


        var getodsubdetilaslis = [];
        function printclick(thisid) {
            var sno = $(thisid).parent().parent().children('.1').html();
            var data = { 'op': 'get_odrefrence_details', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        $('#divPrint').css('display', 'block');
                        $('#Button2').css('display', 'block');
                        var meetingdetails = msg[0].odDetalis1list;
                        getodsubdetilaslis = msg[0].suboddetailslist;
                        //document.getElementById('spnameetingrefno').innerHTML = meetingdetails[0].meeting_no;
                        document.getElementById('spnsempname').innerHTML = meetingdetails[0].fullname;
                        document.getElementById('Spanemplid').innerHTML = meetingdetails[0].empcode;
                        document.getElementById('spntodate').innerHTML = meetingdetails[0].fromdate;
                        //document.getElementById('spnsignature').innerHTML = meetingdetails[0].conducted_by;
                        document.getElementById('spndate').innerHTML = meetingdetails[0].doe;
                        document.getElementById('SpnREfno').innerHTML = meetingdetails[0].Title;
                        document.getElementById('spnDeprt').innerHTML = meetingdetails[0].department;
                        document.getElementById('spndesig').innerHTML = meetingdetails[0].designation;
                        document.getElementById('spnreportname').innerHTML = meetingdetails[0].reportingempid;
                        //document.getElementById('ssignature').innerHTML = meetingdetails[0].conducted_by;
                        fillMeetingdetails(getodsubdetilaslis);
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
        function fillMeetingdetails(msg) {
           // var meetingrefno = document.getElementById('txt_meetingrefno').value;
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" border="2">';
            results += '<thead><tr style="background:#cbc6dd;"><th scope="col">Sr.No</th><th scope="col">Place of the Duty</th><th scope="col">Date of Entry</th><th scope="col">Purpose of Duty</th><th scope="col">Date of Exit</th><th scope="col">Reporting Manager Comments</th><th scope="col">Signature of Reporting Manage with Date</th></tr></thead></tbody>';
            var l = 0;
            var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
            var j = 1;
            for (k = 0; k < msg.length; k++) {
                    results += '<tr><td>' + j++ + '</td>';
                    results += '<td class="1">' + msg[k].branch + '</td>';
                    results += '<td class="1">' + msg[k].dateofentry + '</td>';
                    results += '<td class="1">' + msg[k].purpose + '</td>';
                    results += '<td class="1">' + msg[k].dateofexit + '</td>';
                    results += '<td class="1">' + msg[k].comments + '</td>';
                    results += '<td class="1">' + msg[k].reportingdate + '</td></tr>';
//                }
            }
            results += '</table></div>';
            $("#div_ODData").html(results);

        }        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            OD Apply Report<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">OD Apply Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>OD Apply Report 
                </h3>
            </div>
            <div class="box-body">
                <div runat="server" id="d">
                    <table>
                        <tr>
                            <td>
                                <label>
                                    From Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txtfromdate" class="form-control" />
                            </td>
                            <td>
                                <label>
                                    To Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txttodate" class="form-control" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <input id="btn_save" type="button" class="btn btn-primary" name="submit" value='Get Details'
                                    onclick="btnPODetails_click()" />
                            </td>
                        </tr>
                    </table>
                    <div id="divoddata" style="height: 300px; overflow-y: scroll;">
                    </div>
                </div>
                <br />
                <br />
                <div id="divPrint" style="display:none;">
                 <div style="width: 13%; float: right;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
                     <div>
                        <div style="font-family: Arial; font-size: 18pt; font-weight: bold; color: Black;">
                            <span>Sri Vyshnavi Foods Pvt Ltd </span>
                            <br />
                        </div>
                        R.S.No:381/2,Punabaka village Post<br />
                        Pellakuru Mandal,Nellore District -524129.,
                        <br />
                        ANDRAPRADESH (State)<br />
                        Phone: 9440622077, Fax: 044 – 26177799.
                    </div>
                      <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                        <span style="font-size: 26px; font-weight: bold;">OUT STATION DUTY APPLICATION  </span>
                    </div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 49%; float: left;">
                                <br />
                                <label>
                                    Name of the Employee:</label>
                                <span id="spnsempname"></span>
                                <br />
                                <label>
                                    Employee ID No :</label>
                                <span id="Spanemplid"></span>
                                <br />
                                <label>
                                    Period of Outstation  Duty: Starting Date:</label>
                                <span id="spntodate"></span>
                                <br />
                                <label>
                                    Signature of the Employee:</label>
                                <span id="spnsignature"></span>
                                <br />
                            </td>
                            <td style="width: 49%; float: right;">
                                <span id="SpnREfno" style="font-weight: bold;"></span>
                                <br />
                                <label>
                                    Date :</label>
                                <span id="spndate"></span>
                                <br />
                             
                                 <label>
                                     Department :</label>
                                <span id="spnDeprt"></span>
                                <br />
                                 <label>
                                     Designation:</label>
                                <span id="spndesig"></span>
                                <br />
                                 <label>
                                     Name of the Departmental Head:</label>
                                <span id="spnreportname"></span>
                                <br />
                                 <label>
                                     Signature of the Departmental Head:</label>
                                <span id="ssignature"></span>
                                <br />
                            </td>
                        </tr>
                    </table>
                     <br />
                      <br />
                    <div id="div_ODData">
                    </div>
                     <br />
                      <br />
                       <span style="margin-left:30px;" >
                         FOR OFFICE USE.
                       </span>
                      <br />
                      <span style="margin-left:30px;" >
                       Comments from the HR Department -
                       </span>
                      <textarea cols="35" rows="3" style="margin-left:30px; width: 70%;height: 80px;" placeholder="Comments from the HR Department" class="form-control">
                      </textarea>
                       <br />
                      <br />
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 15px;">On Duty End Date:</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 15px;">Signature of Employee</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 15px;">Signature of the Departmental Head</span>
                            </td>
                        </tr>
                    </table>
                </div>
                
                <input id="Button2" type="button" class="btn btn-primary" name="submit" style="display:none; align="center" " value='Print'
                    onclick="javascript:CallPrint('divPrint');" />
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
            </div>
        </div>
    </section>
</asp:Content>


