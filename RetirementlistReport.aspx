<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="RetirementlistReport.aspx.cs" Inherits="RetirementlistReport" %>

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
        get_CompanyMaster_details();
        
    });
    function onchangebranch() {

        var type = document.getElementById("slct_type").value;
        if (type == "1") {
            $('#slct_location').css('display', 'none');
            $('#branchname').css('display', 'none');
        }
        else {
            $('#slct_location').css('display', 'block');
            $('#branchname').css('display', 'block');

        }
    }

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


        function get_CompanyMaster_details() {
            var data = { 'op': 'get_CompanyMaster_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcompany(msg);
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
            var data = document.getElementById('slct_compname');
            var length = data.options.length;
            document.getElementById('slct_compname').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Company";
            opt.value = "Select Company";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
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
            var companyid = document.getElementById('slct_compname').value;
            var type = document.getElementById('slct_type').value;
            if (type == '2') {
                $('#branchname').show();
            }
            var data = { 'op': 'get_compaywiselocation_fill', 'companyid': companyid, 'type': type };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranch(msg);
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
        function fillbranch(msg) {
            var data = document.getElementById('slct_locname');
            var length = data.options.length;
            document.getElementById('slct_locname').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branch";
            opt.value = "Select Branch";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
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
        function get_retirement_list() {
            //            var address = document.getElementById('lblAddress').innerHTML;
            //            var heading = document.getElementById('lblHeading').innerHTML;
            var companyid = document.getElementById('slct_compname').value;
            var type = document.getElementById('slct_type').value;
            var branchid = document.getElementById('slct_locname').value;
            var data = { 'op': 'get_retirement_list', 'companyid': companyid, 'type': type, 'branchid': branchid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filllretirementdetails(msg);
                        $('#btn_retireprint').css('display', 'block');
                        $('#divPrint').css('display', 'block');
                        $('#printbtn').css('display', 'block');
                        document.getElementById('lblTitle').innerHTML = msg[0].title;
                        document.getElementById('lblAddress').innerHTML = msg[0].address;
                        document.getElementById('lblHeading').innerHTML = "RetirementDetails";
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
        function filllretirementdetails(msg) {
            //var title = document.getElementById('lblTitle').innerHTML;
//            document.getElementById('lblTitle').innerHTML = msg[0].title;
//            document.getElementById('lblAddress').innerHTML = msg[0].address;
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 20px;font-weight: bold;">' + msg[0].title + '</th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 12px;font-weight: bold;">' + msg[0].address + ' </th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 18px;font-weight: bold;">'+ "RetirementDetails" +'</th></tr></thead></tbody>';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">EmployeeCode</th><th scope="col">Name</th><th scope="col">JoinDate</th><th scope="col">BirthDate</th><th scope="col">Age</th><th scope="col">Department</th><th scope="col">Designation</th><th scope="col">BranchName</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>'
                results += '<th scope="row" class="1">' + msg[i].empnum + '</th>';
                results += '<th scope="row" class="2">' + msg[i].fullname + '</th>';
                results += '<th scope="row" class="3">' + msg[i].joindate + '</th>';
                results += '<th scope="row" class="4">' + msg[i].bdate + '</th>';
                results += '<th scope="row" class="5">' + msg[i].age + '</th>';
                results += '<th scope="row" class="6">' + msg[i].dept + '</th>';
                results += '<th scope="row" class="7">' + msg[i].desig + '</th>';
//                results += '<th scope="row" style="display:none" class="10">' + msg[i].title + '</th>';
//                results += '<th scope="row" style="display:none" class="7">' + msg[i].address + '</th>';
                results += '<td  class="8">' + msg[i].branchid + '</td></tr>';
                //var title = document.getElementById('lblTitle').innerHTML;
                //                var title = $(thisid).parent().parent().children('.10').html();
//                document.getElementById('lblTitle').innerHTML = msg[i].title;
//                document.getElementById('lblAddress').innerHTML = msg[i].address;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_retireemp").html(results);
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
        Retirement Report<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">   Retirement Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Retirement Report
                </h3>
            </div>
            <div class="box-body">
             <div id="div_comp">
                   <div id='fillform' >
                      <table>
                            <tr>
                                <td>
                                    <label>
                                       Company</label>
                                </td>
                                <td style="height: 40px;">
                                    <select id="slct_compname" class="form-control"></select>
                               </td>
                                <td>
                                    <label>
                                      Type</label>
                                </td>
                                <td style="height: 40px;">
                                    <select id="slct_type" class="form-control" type="text" onchange="branchnamechange();onchangebranch();">
                                    <option value="1">ALL</option>
                                    <option value="2">Location Wise</option>
                                    </select>
                               </td>
                               <%--<tr id="branchname" style="display:none;">--%>
                               
                                  <td id="branchname"  style="display:none;">
                                    <label>
                                      Location Name</label>
                                </td>
                                <td style="height: 40px; display:none;" id="slct_location">
                                    <select id="slct_locname" class="form-control" type="text" ></select>
                               </td>
                               
                               <%--</tr>--%>
                               <td style="height:40px;"></td>
                               <td colspan="2" align="center" style="height:40px;">
                              <input id="btn_retire" type="button" class="btn btn-primary" name="Generate" value='Generate' onclick="get_retirement_list()" />
                            </td> 
                             </tr>
                              <tr style="display:none;">
                              <td>
                            <label id="lbl_retiresno"></label>
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
                             <div id ="div_retireemp" ></div>
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
                                         <button type="button" id="btn_retireprint" class="btn btn-success"   onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                                        </td>
                                        <td>
                                        <input type="button" class="btntogglecls" style="height: 28px; opacity: 1.0; width: 100px;
                                        background-color: #d5d5d5; color: Blue;" onclick="tableToExcel('div_retireemp', 'W3C Example Table')"
                                        value="Export to Excel" />
                                        </td>
                                        </tr>
                                        </table>
                                         </div>
                                         
</div>
    </section>



</asp:Content>

