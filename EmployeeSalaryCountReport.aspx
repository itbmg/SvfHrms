<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="EmployeeSalaryCountReport.aspx.cs" Inherits="EmployeeSalaryCountReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
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
    function get_employee_salarycount() {
        var type = document.getElementById("slct_type").value;
        var data = { 'op': 'get_employee_salarycount', 'type': type };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillsaldetails(msg);
                    $('#printexcel').css('display', 'block');
                    $('#div_empsalcount').css('display', 'block');
                    $('#divPrint').css('display', 'block');
                    $('#printbtn').css('display', 'block');
                    document.getElementById('lblTitle').innerHTML = msg[0].title;
                    document.getElementById('lblAddress').innerHTML = msg[0].address;
                    document.getElementById('lblHeading').innerHTML = " Employee Salary Count " +  type + " Statement";
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
    function fillsaldetails(msg) {
//        document.getElementById('lblTitle').innerHTML = msg[0].title;
        //        document.getElementById('lblAddress').innerHTML = msg[0].address;
        var type = document.getElementById("slct_type").value;
        var total = 0;
        var totalemp = 0;
        var totalsalary = 0;
        var T = "Total";
        var k = 1;
        var l = 0;
        var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
//        results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 20px;font-weight: bold;">' + msg[0].title + '</th></tr></thead></tbody>';
//        results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 12px;font-weight: bold;">' + msg[0].address + ' </th></tr></thead></tbody>';
//        results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 18px;font-weight: bold;">' + " Employee Salary Count" + type + " Statement" + '</th></tr></thead></tbody>';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col">Location</th><th scope="col">EmployeeCount</th><th scope="col">GrossSalary</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
            results += '<td scope="row" class="1">' + msg[i].Location + '</td>';
            results += '<td scope="row" class="2">' + msg[i].NoofEmp + '</td>';
            results += '<td  class="6">' + msg[i].Salary + '</td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
            total += parseFloat(msg[i].Salary);
            totalsalary = parseFloat(total).toFixed(2);
            totalemp += parseFloat(msg[i].NoofEmp);
        }
        results += '<tr style="background-color:' + COLOR[l] + '"><td ></td>';
        results += '<td scope="row" class="1" style="font-weight:bold;font-size:20px;">' + T + '</td>';
        results += '<td scope="row" class="2">' + totalemp + '</td>';
        results += '<td  class="6">' + totalsalary + '</td></tr>';


        results += '</table></div>';
        $("#div_empsalcount").html(results);

    }
    var tableToExcel = (function () {
        var uri = 'data:application/vnd.ms-excel;base64,'
    , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>'
    , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
    , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }
        return function (table, name) {
            if (!table.nodeType) table = document.getElementById(table)
            var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
            window.location.href = uri + base64(format(template, ctx))
        }
    })()
    </script>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
       Employee Salary Count Statement
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Employee Salary Count Statement </a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Salary Count Statement Details
                </h3>
            </div>
            <div class="box-body">
             <div id="div_deplocsal">
                   <div id='fillform' >
                      <table align="center">
                            <tr>
                                <td>
                                    <label>
                                      Employee Category</label>
                                </td>
                                <td style="height: 40px;">
                                    <select id="slct_type" class="form-control">
                                    <option value="0">Select</option>
                                    <option value="Location">Location</option>
                                    <option value="Department">Department</option>
                                    <option value="Designation">Designation</option>
                                     </select>
                               </td>
                               <td style="height:40px;"></td>
                               <td colspan="2" align="center" style="height:40px;">
                              <input id="btn_deptloc" type="button" class="btn btn-primary" name="Generate" value='Generate' onclick="get_employee_salarycount()" />
                            </td> 
                             </tr>

                              <tr style="display:none;">
                              <td>
                            <label id="lbl_escsno"></label>
                            </td>
                            </tr>
                           </table>
        </div>
        </div>
    </div>
                            <%--<div id="divPrint">
                             <div id ="div_empsalcount"></div>
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
                                        </div>--%>

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
                             <div id ="div_empsalcount" ></div>
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
                                        <div align="center" id="printbtn" style="display:none">
                                        <table>
                                        <tr>
                                        <td>
                                         <button type="button" id="Button1" class="btn btn-success"   onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                                        </td>
                                        <td>
                                        <input type="button" class="btntogglecls" style="height: 28px; opacity: 1.0; width: 100px;
                                        background-color: #d5d5d5; color: Blue;" onclick="tableToExcel('div_empsalcount', 'W3C Example Table')"
                                        value="Export to Excel" />
                                        </td>
                                        </tr>
                                        </table>
                                         </div>
                                          <br />
                                        <%--<div align="center" id="printexcel" style="display:none">
                                        <table>
                                        <tr>
                                        <td>
                                         <button type="button" id="Button2" class="btn btn-success"   onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                                        </td>
                                         <td style="width: 10px">
                                        <td>
                                        <input type="button" class="btntogglecls" style="height: 28px; opacity: 1.0; width: 100px;
                                        background-color: #d5d5d5; color: Blue;" onclick="tableToExcel('div_empsalcount', 'W3C Example Table')"
                                        value="Export to Excel">
                                        </td>
                                        </tr>
                                        </table>
                                         </div>--%>
</div>
    </section>


</asp:Content>

