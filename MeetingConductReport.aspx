<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="MeetingConductReport.aspx.cs" Inherits="MeetingConductReport" %>

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
        $(function () {
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txtfromdate').val(today);
            $('#txttodate').val(today);
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
            var data = { 'op': 'get_meeting_conduct_details', 'fromdate': fromdate, 'todate': todate, 'formtype': formtype };
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
            results += '<thead><tr><th scope="col">Ref No</th><th scope="col">Department</th><th scope="col">conducted_by</th><th scope="col">participants</th></tr></thead></tbody>';
            var l = 0;
            var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + msg[i].sno + '</th>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].department + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].conducted_by + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].participants + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divPOdata").html(results);
        }

        function btn_Purchase_order_click() {
            var meetingrefno = document.getElementById('txt_meetingrefno').value;
            var data = { 'op': 'get_meeting_conduct_Reports', 'meetingrefno': meetingrefno };
            var s = function (msg) {
                    if (msg) {
                        if (msg.length > 0) {
                            $('#divPrint').css('display', 'block');
                            fillMeetingdetails(msg);
                            meetingdetails = msg;
                            document.getElementById('spnameetingrefno').innerHTML = meetingdetails[0].meeting_no;
                            document.getElementById('spnstartdate').innerHTML = meetingdetails[0].starttime;
                            document.getElementById('SpanSubject').innerHTML = meetingdetails[0].subject;
                            document.getElementById('SpnParticipates').innerHTML = meetingdetails[0].participants;
                            document.getElementById('SpnConductby').innerHTML = meetingdetails[0].conducted_by;
                            document.getElementById('spndate').innerHTML = meetingdetails[0].doe;
                            document.getElementById('SpnEndtime').innerHTML = meetingdetails[0].endtime;
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
                var meetingrefno = document.getElementById('txt_meetingrefno').value;
                var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" border="2">';
                results += '<thead><tr style="background:#cbc6dd;"><th scope="col">Sno</th><th scope="col">Conclusion</th></tr></thead></tbody>';
                var l = 0;
                var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
                for (var i = 0; i < msg.length; i++) {
                    var submeetinglist = msg[i].sub_meeting_list;
                    var j = 1;
                    for (k = 0; k < submeetinglist.length; k++) {
                        if (meetingrefno == submeetinglist[k].meeting_no) {
                            results += '<tr style="background-color:' + COLOR[l] + '"><td>' + j++ + '</td>';
                            results += '<td class="1">' + submeetinglist[k].conclusion + '</td></tr>';
                        }
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }
                results += '</table></div>';
                $("#div_MeetingData").html(results);

            }        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Meeting Conduct Report<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Meeting Conduct Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Meeting Conduct Report
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
                    <div id="divPOdata" style="height: 300px; overflow-y: scroll;">
                    </div>
                </div>
                <br />
                <br />
                <div>
                    <table>
                        <tr>
                            <td>
                                <label>
                                    Ref No:</label>
                            </td>
                            <td>
                                <input type="text" id="txt_meetingrefno" class="form-control" placeholder="Enter Ref No" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <input id="Button1" type="button" class="btn btn-primary" name="submit" value='Generate'
                                    onclick="btn_Purchase_order_click()" />
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
                        <span style="font-size: 26px; font-weight: bold;">Meeting Conduct </span>
                    </div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 49%; float: left;">
                                <label>
                                    Meeting Ref No :</label>
                                <span id="spnameetingrefno"></span>
                                <br />
                                <label>
                                    Start Time :</label>
                                <span id="spnstartdate"></span>
                                <br />
                                <label>
                                    Subject :</label>
                                <span id="SpanSubject"></span>
                                <br />
                                <label>
                                    Participates :</label>
                                <span id="SpnParticipates"></span>
                                <br />
                                <label>
                                    Conduct By :</label>
                                <span id="SpnConductby"></span>
                                <br />
                            </td>
                            <td style="width: 49%; float: right;">
                                <label>
                                    Date :</label>
                                <span id="spndate"></span>
                                <br />
                                <label>
                                    End Time :</label>
                                <span id="SpnEndtime"></span>
                                <br />
                                <br />
                            </td>
                        </tr>
                    </table>
                    <div id="div_MeetingData">
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
                <input id="Button2" type="button" class="btn btn-primary" name="submit" value='Print'
                    onclick="javascript:CallPrint('divPrint');" />
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
            </div>
        </div>
    </section>
</asp:Content>
