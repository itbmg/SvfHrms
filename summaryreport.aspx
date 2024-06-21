<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="summaryreport.aspx.cs" Inherits="summaryreport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .container
        {
            max-width: 100%;
        }
    </style>
    <%--<script src="js/date.format.js" type="text/javascript"></script>--%>
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

        function exportfn() {
            window.location = "exporttoxl.aspx";
        }

        //------------>Prevent Backspace<--------------------//
        $(document).unbind('keydown').bind('keydown', function (event) {
            var doPrevent = false;
            if (event.keyCode === 8) {
                var d = event.srcElement || event.target;
                if ((d.tagName.toUpperCase() === 'INPUT' && (d.type.toUpperCase() === 'TEXT' || d.type.toUpperCase() === 'PASSWORD'))
            || d.tagName.toUpperCase() === 'TEXTAREA') {
                    doPrevent = d.readOnly || d.disabled;
                } else {
                    doPrevent = true;
                }
            }

            if (doPrevent) {
                event.preventDefault();
            }
        });
    </script>
    <script>
        $(function () {
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
            //            $('#year1').val(yyyy);
            var myselect = document.getElementById('year1'), year = new Date().getFullYear();
            var gen = function (max) { do { myselect.add(new Option(year++, max--), null); } while (max > 0); } ();
            var year = 1980;
            var min = new Date().getFullYear(),
                        max = min + 9
            for (i = 0; i < 100; i++) {
                $("#year1").get(0).options[$("#year1").get(0).options.length] = new Option(year, year);
                year = year + 1;
            }
            $('#year1').val(yyyy);
//            get_Branch_details();
        });
//                function ddlTypeChange() {
//                    //            var type = document.getElementById('slct_type').value;
//                    var ChartType = document.getElementById('ddlChartType').value;
//                    if (ChartType == "Location") {
//                        $("#bname").css("display", "none");
//                        $("#Slect_Name").css("display", "none");
//                        //get_Branch_details();
//                    }
//                    if (ChartType == " Wise") {
//                        $("#bname").css("display", "block");
//                        $("#Slect_Name").css("display", "block");
//                        get_Branch_details();
//                    }
        //                }
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


        function GetSummaryreportdetails() {
            var name = "";
            var tmonth = "";
            var branchtype = document.getElementById('ddlChartType').value;
            var ChartType = document.getElementById('ddltype').value;
            //            var branchtype = document.getElementById('ddltype').value;
            //            if (ChartType == "All Location") {
            //                name = document.getElementById('Slect_Name').value;

            //            }

            //            if (ChartType == "Location Wise") {
//            name = document.getElementById('Slect_Name').value;
//            if (name == "" || name == "Select name ") {
//                alert("Please Select name ");
//                return false;
//            }
            //            }
            Month = document.getElementById('ddlmonth').value;
            if (Month == "Select Month") {

                alert("Please Select Month ");
                return false;

            }
            Year = document.getElementById('year1').value;
            if (Year == "") {
                alert("Please Select Year ");
                return false;
            }
            var salarywiseLinechart = "salarywiseLinechart";
            var data = { 'op': 'btn_Generate_Click', 'ChartType': ChartType, 'branchtype': branchtype, 'Month': Month, 'Year': Year, 'FormName': salarywiseLinechart };
            var s = function (msg) {
                if (msg == "No data Found") {
                    $('#divChart').css('display', 'none');
                    $('#divPrint').css('display', 'none');
                }
                else if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        filldetails(msg);
                        $('#divPrint').css('display', 'block');
                        $('#divChart').css('display', 'block');
                        $('#printbtn').css('display', 'block');
                        filldifdetails(msg);
//                        GetSummarybankreportdetails(msg);
//                        totalemployee = msg;
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


        
        var diff = [];
        function filldetails(msg) {
            var totalsalarysummary = [];
            var totalconsummary = [];
            var totalbanksummary = [];
              var branchtype = document.getElementById('ddlChartType').value;
            var month = document.getElementById("ddlmonth").value;
            var year = document.getElementById("year1").value;
            diff = [];
            var total = 0;
            var totcon = 0;
            var totextra = 0;
            var totconve = 0;
            var grand_tot1 = 0;
            totalsalarysummary = msg[0].summarysalaryDetalis;
       
            var distinctMap = {};
            for (var i = 0; i < month.length; i++) {
                var value = month;
                distinctMap[value] = '';
            };
            var unique_values = [];
            unique_values = Object.keys(distinctMap);
            unique_values.sort(function (a, b) { return a - b });
            //            document.getElementById("header").innerHTML = unique_values;
            var nmonth = [];
            for (var i = 0; i < unique_values.length; i++) {
                var month = new Array();
                var months = ["", "January", "February", "March", "April", "May", "June",
               "July", "August", "September", "October", "November", "December"];
                nmonth.push(months[(parseInt(unique_values[i]))]);
            }
            var k = 1;
            var l = 0;
            var j = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 20px;font-weight: bold;">' + totalsalarysummary[0].title + '</th></tr></thead></tbody>';
            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 12px;font-weight: bold;">' + totalsalarysummary[0].address + ' </th></tr></thead></tbody>';
            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 18px;font-weight: bold;">' + "SALARY SUMMARY STATEMENT FOR THE MONTH OF:" + nmonth[0] + "  " + year + " Statement" + '</th></tr></thead></tbody>'; //<th scope="col">Medical Insurancepremium</th>
            if (branchtype!="Driver") {
            results += '<thead><tr style="background-color:white;"><th scope="col" ></th><th scope="col" >BRANCH NAME</th><th scope="col">ACTUAL GROSS SALARY</th><th scope="col">EARNED GROSS SALARY</th><th scope="col">Prof.Tax</th><th scope="col">P.F</th><th scope="col">ESI</th><th scope="col">SALARY Advance</th><th scope="col">Loan</th><th scope="col">Canteen</th><th scope="col">Mobile deduction</th><th scope="col">TDS</th><th scope="col">Other Deduction</th><th scope="col">Total Deduction</th><th scope="col">NET SAL Payable</th></tr></thead></tbody>';
           }
           else{
            results += '<thead><tr style="background-color:white;"><th scope="col" ></th><th scope="col" >BRANCH NAME</th><th scope="col">Betta/Day</th><th scope="col">EARNED GROSS SALARY</th><th scope="col">Prof.Tax</th><th scope="col">P.F</th><th scope="col">ESI</th><th scope="col">SALARY Advance</th><th scope="col">Loan</th><th scope="col">Canteen</th><th scope="col">Mobile deduction</th><th scope="col">TDS</th><th scope="col">Other Deduction</th><th scope="col">Total Deduction</th><th scope="col">NET SAL Payable</th></tr></thead></tbody>';
            }
            for (var i = 0; i < totalsalarysummary.length; i++) {//<input id="btn_poplate" type="button"  onclick="viewdept_details(this)" name="submit" class="btn btn-primary" value="ViewDept" />
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th  scope="row" class="1" style="text-align:center;">' + totalsalarysummary[i].branchname + '</th>';
//                results += '<td data-title="Code" class="2">' + totalsalarysummary[i].Employeetype + '</td>';
                results += '<td data-title="Code" class="2">' + totalsalarysummary[i].TotalgrossAmount + '</td>';
                if (branchtype == "Driver") {
//                    results += '<td data-title="Code" class="2">' + totalsalarysummary[i].RateDay + '</td>';
                    results += '<td data-title="Code" class="2">' + totalsalarysummary[i].BettaDay + '</td>';
                }
                results += '<td  class="4">' + totalsalarysummary[i].GROSSEarnings + '</td>';
                results += '<td  class="4">' + totalsalarysummary[i].PT + '</td>';
                results += '<td  class="4">' + totalsalarysummary[i].PF + '</td>';
                results += '<td  class="4">' + totalsalarysummary[i].ESI + '</td>';
                results += '<td  class="4">' + totalsalarysummary[i].Salaryadv + '</td>';
                results += '<td  class="4">' + totalsalarysummary[i].loan + '</td>';
                results += '<td  class="4">' + totalsalarysummary[i].Canteen + '</td>';
                results += '<td  class="4">' + totalsalarysummary[i].Mobilededuction + '</td>';
                results += '<td  class="4">' + totalsalarysummary[i].TDS + '</td>'; 
                results += '<td  class="4">' + totalsalarysummary[i].Otherdeductions + '</td>';
                results += '<td  class="4">' + totalsalarysummary[i].totaldeductions + '</td>';
                results += '<td  class="4">' + totalsalarysummary[i].TotalAmount + '</td></tr>';
                total = parseFloat(totalsalarysummary[i].TotalAmount);
                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
               
            }
           
            results += '</table></div>';
            $("#divChart").html(results);

            /////////Extrapay Amount//////////////////////////////////
//            totalconsummary = msg[0].convneanceDetails;
            var k = 1;
            var l = 0;
            var j = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;"><th scope="col" ></th><th scope="col" >BRANCH NAME</th><th scope="col">FixedConveyance</th><th scope="col">CONVEYANCE</th></tr></thead></tbody>';
            for (var i = 0; i < totalsalarysummary.length; i++) {//<input id="btn_poplate" type="button"  onclick="viewdept_details(this)" name="submit" class="btn btn-primary" value="ViewDept" />
                if (totalsalarysummary[i].CONVEYANCE!="0") {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th  scope="row" class="1" style="text-align:center;">' + totalsalarysummary[i].branchname + '</th>';
                results += '<td data-title="Code" class="2" style="text-align:center;">' + totalsalarysummary[i].FIXEDCONVEYANCE + '</td>';
                results += '<td data-title="Code" class="2" style="text-align:center;">' + totalsalarysummary[i].CONVEYANCE + '</td></tr>';

                //                totamt += parseFloat(totalemployee[i].TotalAmount);
                }
                totcon = parseFloat(totalsalarysummary[i].CONVEYANCE);
                totextra = parseFloat(totalsalarysummary[i].Extrapay);
                totshift = parseFloat(totalsalarysummary[i].shift);
                total = parseFloat(totalsalarysummary[i].TotalAmount);
                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }

            }
            totconve = totcon;
            totshiftallowance = totshift;
            totalamount = total;
            grand_tot1 = totconve + totalamount + totextra + totshiftallowance;
            diff.push(grand_tot1);
            results += '<tr>'
            results += '</tr>'
            results += '<tr>'
            results += '</tr>'
            results += '<td scope="row" class="1" style="font-size:18px;font-weight:bold;color:#006400;" ></td>';
            results += '<td scope="row" class="1" style="font-size:18px;font-weight:bold;color:#006400;" >GrandTotal</td>';
            results += '<td scope="row" class="1" style="font-size:18px;font-weight:bold;color:#006400;" ></td>';
            results += '<td data-title="Code" class="2" style="text-align:center;">' + grand_tot1 + '</td></tr>';
            results += '</table></div>';
            $("#divChart3").html(results);
            if (branchtype != "CC") {
                var k = 1;
                var l = 0;
                var j = 1;
                var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
                var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                results += '<thead><tr style="background-color:white;"><th scope="col" ></th><th scope="col" >BRANCH NAME</th><th scope="col">Extrapay</th><th scope="col">Shift</th></tr></thead></tbody>';
                for (var i = 0; i < totalsalarysummary.length; i++) {//<input id="btn_poplate" type="button"  onclick="viewdept_details(this)" name="submit" class="btn btn-primary" value="ViewDept" />

                    results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                    results += '<th  scope="row" class="1" style="text-align:center;">' + totalsalarysummary[i].branchname + '</th>';
                    results += '<td scope="row" class="1" style="text-align:center;">' + totalsalarysummary[i].Extrapay + '</td>';
                    results += '<td scope="row" class="1" style="text-align:center;">' + totalsalarysummary[i].shift + '</td></tr>';


                    //                totamt += parseFloat(totalemployee[i].TotalAmount);

                    j++;
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }

                }
               
                results += '</table></div>';
                $("#divChart4").html(results);
            }


            ///// Bank Summary Details/////////////////
            diff2 = [];
            var totamt = 0;
            var grand_tot = 0;
            totalbanksummary = msg[0].summarybankDetalis;
            var k = 1;
            var l = 0;
            var j = 1;
            var COLOR = ["Bisque", "MistyRose", "#daffff", "AntiqueWhite", "#b3ffe6"];
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;"><th scope="col" ></th><th scope="col">BankName</th><th scope="col">Amount</th></tr></thead></tbody>';
            for (var i = 0; i < totalbanksummary.length; i++) {//<input id="btn_poplate" type="button"  onclick="viewdept_details(this)" name="submit" class="btn btn-primary" value="ViewDept" />
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row" style="display:none" class="1" style="text-align:center;">' + totalbanksummary[i].month + '</th>';
                results += '<td data-title="Code" class="2">' + totalbanksummary[i].bankname + '</td>';
                results += '<td  class="4">' + totalbanksummary[i].TotalAmount + '</td></tr>';
                j++;
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
                grand_tot = parseFloat(totalbanksummary[i].TotalAmount);
            }
            diff2.push(grand_tot);
            results += '</table></div>';
            $("#divChart2").html(results);

        }



        function filldifdetails(msg) {
            Difference = diff[0] - diff2[0];
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<tr style="background-color:AntiqueWhite">';
            results += '<td scope="row" class="1" style="font-size:18px;font-weight:bold;color:#006400;" >Difference</td>';
            results += '<td  class="5">' + parseFloat(Difference).toFixed(2) + '</td></tr>';

            results += '</table></div>';
            $("#divChart5").html(results);
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
           SummaryReport<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-pie-chart"></i>Summary Report </a></li>
            <li><a href="#">Pie Chart</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employeetype wise SummaryReport
                </h3>
            </div>
            <div class="box-body">
                <div style="width: 100%;" align="center">
                    <table>
                        <tr>
                            <td>
                                <span>Chart Type</span>
                            </td>
                            <td >
                                <select id="ddlChartType" class="form-control" >
                                    <option>Select Type</option>
                                     <option>SalesOffice</option>
                                    <option>CC</option>
                                    <option>Plant</option>
                                    <option>Driver</option>
                                </select>
                            </td>

                            <td style="width: 6px;">
                            </td>
                             <td>
                                <span>Summary</span>
                            </td>
                            <td >
                                <select id="ddltype" class="form-control" >
                                    <option>Select Type</option>
                                     <option>Location</option>
                                    <option>Department</option>
                                </select>
                            </td>
                           <%-- <td>
                                <span id="bname">Branch Name</span>
                            </td>
                            <td>
                                <select id="Slect_Name" class="form-control">
                                </select>
                            </td>--%>
                           <td>
                             <label>
                             Month
                             </label>
                             <select  id="ddlmonth">
                                 <option value="00">Select Month</option>
                                 <option value="01">January</option>
                                 <option value="02">February</option>
                                 <option value="03">March</option>
                                 <option value="04">April</option>
                                 <option value="05">May</option>
                                 <option value="06">June</option>
                                 <option value="07">July</option>
                                 <option value="08">August</option>
                                 <option value="09">September</option>
                                 <option value="10">October</option>
                                 <option value="11">November</option>
                                 <option value="12">December</option>
                             </select>

                                        </td>
                            <td style="width: 6px;">
                            </td>
                            <td style="width: 90px; height: 50px;">
                                <span> Year</span>
                              <select  id="year1"></select>
                            </td>
                            <td>
                                <input type="button" id="submit" value="Generate" class="btn btn-primary" onclick="GetSummaryreportdetails()" />
                            </td>
                        </tr>
                    </table>
                </div>
               
                                                       <div id="divPrint" style="display:none">
    <div align="center">
                                                <label id="lblTitle"  Font-Bold="true" Font-Size="20px" ForeColor="#0252aa"
                                                    ></label>
                                                <br />
                                                <label id="lblAddress"  Font-Bold="true" Font-Size="12px" ForeColor="#0252aa"
                                                    ></label>
                                                <br />
                                                 <label id="lblHeading"  Font-Bold="true" Font-Size="15px" ForeColor="#0252aa"
                                                    ></label>
                                                    <br />
                                                <%--<span style="font-size: 18px; font-weight: bold; color: #0252aa;">Bank  Salary Statement
                                                    Report</span><br />--%>
                                            </div>
                                            <div id="div_summary">
                        <table>
               
                <tr>
                <td>
                 <div id="divChart" >
                </div>
                </td>
                 </tr>
                 
                 <tr>
                  <td style="float:left;">
                    <div  id="divChart3"  ></div>
                 </td>
                    <td style="float:left;">
                    <div  id="divChart4"  ></div>
                 </td>
                 </tr>
                 <tr>
                <td>
                 <div id="divChart2" style="width:40%;"></div>
                 </td>
                 </tr>
                  <tr>
                  <td>
                    <div  id="divChart5"  style="float:left"></div>
                 </td>
                 </tr>
               
                 </table>
                 </div>
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
                                        background-color: #d5d5d5; color: Blue;" onclick="tableToExcel('div_summary','divChart2','divChart3', 'W3C Example Table')"
                                        value="Export to Excel" />
                                        </td>
                                        </tr>
                                        </table>
                                         </div>
              
            </div>
    
    
        </div>
    </section>
</asp:Content>





<%--<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdateProgress ID="updateProgress1" runat="server">
        <ProgressTemplate>
            <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
                right: 0; left: 0; z-index: 9999999; background-color: #FFFFFF; opacity: 0.7;">
                <br />
                <asp:Image ID="imgUpdateProgress" runat="server" ImageUrl="thumbnails/loading.gif"
                    AlternateText="Loading ..." ToolTip="Loading ..." Style="padding: 10px; position: absolute;
                    top: 35%; left: 40%;" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <section class="content-header">
        <h1>
           Summary Salary Detailes <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#"> Summary Salary Details </a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i> Summary Salary Details
                </h3>
            </div>
            <div class="box-body">
                <asp:UpdatePanel ID="updPanel" runat="server">
                    <ContentTemplate>
                        <div>
                            <div align="center">
                                <table>
                                    <tr>
                                    <td>
                                     <td>
                                            <asp:Label ID="Label4" runat="server" Text="Label">Branch Type</asp:Label>&nbsp;
                                            <asp:DropDownList ID="ddlbranchtype" runat="server" CssClass="ddlclass">
                                            <asp:ListItem>SalesOffice</asp:ListItem>
                                            <asp:ListItem>CC</asp:ListItem>
                                            <asp:ListItem>Plant</asp:ListItem>
                                            <asp:ListItem>Driver</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </td>
                                    <td>
                                  <asp:Label ID="Label2" runat="server" Text="Label">Summary</asp:Label>&nbsp;
                                            <asp:DropDownList ID="ddltype" runat="server" CssClass="ddlclass">
                                            <asp:ListItem Value="Select Type">Select Type</asp:ListItem>
                                            <asp:ListItem Value="Location">Location</asp:ListItem>
                                            <asp:ListItem Value="Department">Department</asp:ListItem>
                                            </asp:DropDownList>
                                            </td>
                                            <td>
                                            <asp:Label ID="Label1" runat="server" Text="Label">Month</asp:Label>&nbsp;
                                            <asp:DropDownList ID="ddlmonth" runat="server" CssClass="ddlclass">
                                            <asp:ListItem Value="00">Select Month</asp:ListItem>
                                            <asp:ListItem Value="01">January</asp:ListItem>
                                            <asp:ListItem Value="02">February</asp:ListItem>
                                            <asp:ListItem Value="03">March</asp:ListItem>
                                            <asp:ListItem Value="04">April</asp:ListItem>
                                            <asp:ListItem Value="05">May</asp:ListItem>
                                            <asp:ListItem Value="06">June</asp:ListItem>
                                            <asp:ListItem Value="07">July</asp:ListItem>
                                            <asp:ListItem Value="08">August</asp:ListItem>
                                            <asp:ListItem Value="09">September</asp:ListItem>
                                            <asp:ListItem Value="10">October</asp:ListItem>
                                            <asp:ListItem Value="11">November</asp:ListItem>
                                            <asp:ListItem Value="12">December</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                         <td>
                                            <asp:Label ID="Label6" runat="server" Text="Label">Year</asp:Label>&nbsp;
                                            <asp:DropDownList ID="ddlyear" runat="server" CssClass="ddlclass">
                                            <asp:ListItem Value="00">Select Year</asp:ListItem>
                                            <asp:ListItem Value="2013">2013</asp:ListItem>
                                            <asp:ListItem Value="2014">2014</asp:ListItem>
                                            <asp:ListItem Value="2015">2015</asp:ListItem>
                                            <asp:ListItem Value="2016">2016</asp:ListItem>
                                            <asp:ListItem Value="2017">2017</asp:ListItem>
                                            <asp:ListItem Value="2018">2018</asp:ListItem>
                                            <asp:ListItem Value="2019">2019</asp:ListItem>
                                            <asp:ListItem Value="2020">2020</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:Button ID="Button2" runat="server" Text="GENERATE" CssClass="btn btn-success"
                                                OnClick="btn_Generate_Click" /><br />
                                        </td>
                                        <td>
                                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/exporttoxl.aspx">Export to XL</asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                                <asp:Panel ID="hidepanel" runat="server" Visible='false'>
                                    <div id="divPrint">
                                        <div style="width: 100%;">
                                            <div style="width: 13%; float: left;">
                                                <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="120px" height="82px" />
                                            </div>
                                            <div align="center">
                                                <asp:Label ID="lblTitle" runat="server" Font-Bold="true" Font-Size="20px" ForeColor="#0252aa"
                                                    Text=""></asp:Label>
                                                <br />
                                                <asp:Label ID="lblAddress" runat="server" Font-Bold="true" Font-Size="12px" ForeColor="#0252aa"
                                                    Text=""></asp:Label>
                                                <br />
                                                 <asp:Label ID="lblHeading" runat="server" Font-Bold="true" Font-Size="18px" ForeColor="#0252aa"
                                                    Text=""></asp:Label>
                                                    <br />
                                               <%-- <span style="font-size: 18px; font-weight: bold; color: #0252aa;">Salary Statement
                                                    Report</span><br />
                                            </div>
                                            <table style="width: 80%">
                                                <tr>
                                                    <td>
                                                        From Date
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblFromDate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    </td>
                                                    <td>
                                                        To date:
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lbltodate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                            <div>
                                      <table>
                                            <tr>
                                            <td valign="top">
                                        <asp:GridView  ID="grdReports" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                                    GridLines="Both" Font-Bold="true" OnRowDataBound="grdReports_RowDataBound">
                                                    <EditRowStyle BackColor="#999999" />
                                                    <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                                    <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                                        Font-Names="Raavi" Font-Size="Small" />
                                                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                                    <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" Height="40px"/>
                                                    <AlternatingRowStyle HorizontalAlign="Center" />
                                                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                                </asp:GridView>
                                               </div>
                                               <br>
                                            <br>
                                            <br>
                                            <br></br>
                                            <div>
                                                <td valign="top">
                                                    <asp:GridView ID="gridBank" runat="server" align="Right" CssClass="gridcls" 
                                                        Font-Bold="true" ForeColor="White" GridLines="Both" 
                                                        OnRowDataBound="grdReports_RowDataBound" Width="100%">
                                                        <EditRowStyle BackColor="#999999" />
                                                        <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                                        <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" Font-Italic="False" 
                                                            Font-Names="Raavi" Font-Size="Small" ForeColor="Black" />
                                                        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                                        <RowStyle BackColor="#ffffff" ForeColor="#333333" Height="40px" 
                                                            HorizontalAlign="Center" />
                                                        <AlternatingRowStyle HorizontalAlign="Center" />
                                                        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                                    </asp:GridView>
                                            </td>
                                                </tr>
                                                </table>
                                               </td>
                                            </div>
                                            <br>
                                            <br></br>
                                            <br>
                                            <br>
                                            <br></br>
                                            <br></br>
                                            <br></br>
                                            <br></br>
                                            </br>
                                            </br>
                                            </br>
                                            </br>
                                            </br>
                                            </br>
                                            </div>
                                    </div>
                                    <br />
                                    <br />
                                    <asp:Button ID="btnPrint" runat="Server" CssClass="btn btn-success" OnClientClick="javascript:CallPrint('divPrint');"
                                        Text="Print" />
                                        <button type="button" class="btn btn-success"  onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                                </asp:Panel>
                                <asp:Label ID="lblmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </section>
</asp:Content>--%>

