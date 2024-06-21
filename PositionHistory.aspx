<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="PositionHistory.aspx.cs" Inherits="PositionHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_Employeedetails();
//            var TitleName = '<%= Session["TitleName"] %>';
//            document.getElementById('lblTitle').innerHTML = TitleName;
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


        var employeedetails = [];
        function get_Employeedetails() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldata(msg);
                        employeedetails = msg;

                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var compiledList = [];
        function filldata(msg) {
            for (var i = 0; i < msg.length; i++) {
                var empname = msg[i].empname;
                compiledList.push(empname);
            }
            $("#txt_positionemp").autocomplete({
                source: compiledList,
                // change: chanhgeproductname,
                autoFocus: true
            });
        }
        function generate_position_history() {
            var positionemp = document.getElementById("txt_positionemp").value;
            var data = { 'op': 'generate_position_history', 'positionemp': positionemp };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillposition(msg);
                        $('#btn_position').css('display', 'block');
                        $('#div_positionhistory').css('display', 'block');
                        $('#divPrint').css('display', 'block');
                        document.getElementById('lblTitle').innerHTML = msg[0].title;
                        document.getElementById('lblAddress').innerHTML = msg[0].address;
                        document.getElementById('lblHeading').innerHTML = "Employee Position History";
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillposition(msg) {
            //            document.getElementById('lblTitle').innerHTML = msg[0].title;
            //            document.getElementById('lblAddress').innerHTML = msg[0].address;

            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 20px;font-weight: bold;">' + msg[0].title + '</th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 12px;font-weight: bold;">' + msg[0].address + ' </th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 18px;font-weight: bold;">' + " Employee Position History " + '</th></tr></thead></tbody>';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">EmployeeNumber</th><th scope="col">EmployeeName</th><th scope="col">Department</th><th scope="col">Designation</th><th scope="col">EmpType</th><th scope="col">Qualification</th><th scope="col">Grade</th><th scope="col">PayRollCutoffdate</th><th scope="col">Branch</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>'
                results += '<th scope="row" class="1">' + msg[i].empcode + '</th>';
                results += '<th scope="row" class="2">' + msg[i].fullname + '</th>';
                results += '<th scope="row" class="3">' + msg[i].dept + '</th>';
                results += '<td scope="row" class="4">' + msg[i].designation + '</td>';
                results += '<td scope="row" class="5">' + msg[i].emptype + '</td>';
                results += '<td scope="row" class="6">' + msg[i].degree + '</td>';
                results += '<td scope="row" class="7">' + msg[i].grade + '</td>';
                results += '<td scope="row" class="9">' + msg[i].cutoff + '</td>';
                results += '<td  class="8">' + msg[i].branchname + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_positionhistory").html(results);
        }
    </script>

        <script type="text/javascript">
    function CallPrint(strid) {
        var divToPrint = document.getElementById(strid);
        var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
        newWin.document.open();
        newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
        newWin.document.close();
    }
        
        </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <section class="content-header">
        <h1>
         Position History<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#"> Position History </a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i> Position History
                </h3>
            </div>
            <div class="box-body">
             <div id="div_dup">
                   <div id='fillform' >
                      <table align="center">
                            <tr>
                                <td>
                                    <label>
                                       Employee Name</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_positionemp" class="form-control" Placeholder="Enter Employee Name">
                                   
                               </td>
                               <td style="height:40px;"></td>
                               <td colspan="2" align="center" style="height:40px;">
                              <input id="btn_dupreport" type="button" class="btn btn-primary" name="Generate" value='Generate' onclick="generate_position_history()" />
                            </td> 
                             </tr>

                              <tr style="display:none;">
                              <td>
                            <label id="lbl_sno"></label>
                            </td>
                            </tr>
                           </table>
        </div>
        </div>
    </div>
                                        <div id="divPrint" style="display:none">
    <div align="center">
                                                <label id="lblTitle"  Font-Bold="true" Font-Size="20px" ForeColor="#0252aa" style="color:#0252AA !important;font-size:16px!important;font-weight: bold!important";
                                                    ></label>
                                                <br />
                                                <label id="lblAddress"  Font-Bold="true" Font-Size="12px" ForeColor="#0252aa" style="color:#0252AA !important;font-size:16px!important;font-weight: bold!important";
                                                    ></label>
                                                <br />
                                                 <label id="lblHeading"  Font-Bold="true" Font-Size="15px" ForeColor="#0252aa" style="color:#0252AA !important;font-size:16px!important;font-weight: bold!important";
                                                    ></label>
                                                    <br />
                                                <%--<span style="font-size: 18px; font-weight: bold; color: #0252aa;">Bank  Salary Statement
                                                    Report</span><br />--%>
                                            </div>
                             <div id ="div_positionhistory" ></div>
                                   <br />
                                   
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">Prepared By</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">Audit By</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">A.O</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">GM</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">Director</span>
                                                </td>
                                            </tr>
                                        </table>
                                        </div>


                                        <br />
                                        <div align="center">
                                         <button type="button" id="btn_position" class="btn btn-success" style="display:none"  onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                                         </div>
</div>
    </section>


</asp:Content>

