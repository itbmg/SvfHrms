<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="TdsCaluculation.aspx.cs" Inherits="TdsCaluculation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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
            //            tds_generate_report();
            get_financial_years();
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
        function get_financial_years() {
            var data = { 'op': 'get_financial_years' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillyear(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillyear(msg) {
            var data = document.getElementById('slct_year');
            var length = data.options.length;
            document.getElementById('slct_year').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Year";
            opt.value = "Select Year";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                var option = document.createElement('option');
                option.innerHTML = msg[i].year;
                option.value = msg[i].year;
                data.appendChild(option);
            }
        }
        function tds_generate_report() {
            $("#div_tds_grid").css("display", "block");
            $("#div_print").css("display", "block");
            $("#divPrint").css("display", "block");
            var year = document.getElementById('slct_year').value;
            var data = { 'op': 'get_employe_tds_details', 'year': year };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        tds_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

                function tds_details(msg) {
                    var l = 0;
                    var i = 1;
                    var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
                    var results = '<div  style="overflow:auto;"><table id="tbl_empmaster" class="table table-bordered table-hover dataTable no-footer" >';
                    results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" style="text-align:  center;">Sno</th><th scope="col" style="text-align:  center;">Employee Name</th><th scope="col" style="text-align:  center;">Pan Number</th><th scope="col" style="text-align:  center;">Previous Salary</th><th scope="col" style="text-align:  center;">Previous Pf</th><th scope="col" style="text-align:  center;">Hike Ssalary</th><th scope="col" style="text-align:  center;">Pf</th><th scope="col" style="text-align:  center;">Total Salary</th><th scope="col" style="text-align:  center;">Basic</th><th scope="col" style="text-align:  center;">HRA</th><th scope="col" style="text-align:  center;">Conveyance</th><th scope="col" style="text-align:  center;">Total</th><th scope="col" style="text-align:  center;">PT</th><th scope="col" style="text-align:  center;"></th><th scope="col" style="text-align:  center;">HRA</th><th scope="col" style="text-align:  center;">PF</th><th scope="col" style="text-align:  center;">LIC</th><th scope="col" style="text-align:  center;">Stution Fee</th><th scope="col" style="text-align:  center;">Others</th><th scope="col" style="text-align:  center;">Total Savings</th><th scope="col" style="text-align:  center;">80D</th><th scope="col" style="text-align:  center;">Taxble Salary</th><th scope="col" style="text-align:  center;">Tax Payable Before Rebate 87A</th><th scope="col" style="text-align:  center;">Rebate U/S.87A</th><th scope="col" style="text-align:  center;"></th><th scope="col" style="text-align:  center;">Sub Chargers</th><th scope="col" style="text-align:  center;">tax Payeble</th><th scope="col" style="text-align:  center;">Tax Deducted</th><th scope="col" style="text-align:  center;">Tax Payable/Refundable</th></tr></thead></tbody>';
                    for (var k = 0; k < msg.length; k++) {
                        results += '<tr >';
                        //                results += '<tr><td style="text-align:  center;"><span id="btn_poplate" onclick="viewsms_details(this)" name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                        results += '<td style="text-align:  center;">' + i++ + '</td>';
                        results += '<td class="1"  style="text-align:  center;">' + msg[k].fullname + '</td>';
                        results += '<td class="2"  style="text-align:  center;">' + msg[k].pancard + '</td>';
                        results += '<td class="3"  style="text-align:  center;">' + msg[k].changedpackage + '</td>';
                        results += '<td class="4"  style="text-align:  center;">' + msg[k].providentfund + '</td>';
                        results += '<td class="5"  style="text-align:  center;">' + msg[k].gross + '</td>';
                        results += '<td class="6"  style="text-align:  center;">' + msg[k].providentfund + '</td>';
                        results += '<td class="7"  style="text-align:  center;">' + msg[k].totalgross + '</td>';
                        results += '<td class="8"  style="text-align:  center;">' + msg[k].totalbasicc + '</td>';
                        results += '<td class="9"  style="text-align:  center;">' + msg[k].totalhra + '</td>';
                        results += '<td class="10" style="text-align:  center;">' + msg[k].totalconveyance + '</td>';
                        results += '<td class="11" style="text-align:  center;">' + msg[k].total1 + '</td>';
                        results += '<td class="12" style="text-align:  center;" >' + msg[k].totprofitionaltax + '</td>';
                        results += '<td class="13" style="text-align:  center;" >' + msg[k].total2 + '</td>';
                        // results += '<td class="14" style="text-align:  center;">' + msg[k].totalhra2 + '</td>';
                        results += '<td class="14" style="text-align:  center;"><input id="txt_hra" type ="text" onkeyup="taxable_changecaluclation(this)"; class="form-control" style="width: 100px !important;" /></td>';
                        results += '<td class="15" style="text-align:  center;">' + msg[k].totpf + '</td>';
                        //                results += '<td class="16" style="text-align:  center;">' + msg[k].lic + '</td>';
                        results += '<td class="16" style="text-align:  center;"><input id="txt_lic" type ="text" onkeyup="changecaluclation(this);" class="form-control" style="width: 100px !important;"/></td>';
                        //                results += '<td class="17" style="text-align:  center;">' + msg[k].tutionfee + '</td>';
                        results += '<td class="17" style="text-align:  center;"><input id="txt_stutionfee" type ="text" onkeyup="changecaluclation(this);" class="form-control" style="width: 100px !important;"/></td>';
                        //                results += '<td class="18" style="text-align:  center;">' + msg[k].others + '</td>';
                        results += '<td class="18" style="text-align:  center;"><input id="txt_others" type ="text" onkeyup="changecaluclation(this);" class="form-control" style="width: 100px !important;"/></td>';
                        //                results += '<td class="19" style="text-align:  center;">' + msg[k].totalsavings + '</td>';
                        results += '<td class="19" style="text-align:  center;"><input id="txt_totalsavings" type ="text" onkeyup="changecaluclation(this);" class="form-control" style="width: 100px !important;" readonly/></td>';
                        results += '<td class="20" style="text-align:  center;"><input id="txt_eightyd" type ="text" onkeyup="taxable_changecaluclation(this);" class="form-control" style="width: 100px !important;"/></td>';
                        //                results += '<td class="21" style="text-align:  center;">' + msg[k].totaltaxablesal + '</td>';
                        results += '<td class="21" style="text-align:  center;"><input id="txt_taxable" type ="text" onkeyup="taxpayable_beforerebate(this);" class="form-control" style="width: 100px !important;" readonly/></td>';
                        //                results += '<td class="22" style="text-align:  center;">' + msg[k].taxbayablebeforerebate + '</td>';
                        results += '<td class="22" style="text-align:  center;"><input id="txt_taxpayrebate" type ="text" onkeyup="total_rebate(this);" class="form-control" style="width: 100px !important;" readonly/></td>';
                        results += '<td class="23" style="text-align:  center;"><input id="txt_rebate87a" type ="text" onkeyup="total_rebate(this);" class="form-control" style="width: 100px !important;" /></td>';
                        //                results += '<td class="24" style="text-align:  center;">' + msg[k].total3 + '</td>';
                        results += '<td class="24" style="text-align:  center;"><input id="txt_totalthree" type ="text" onkeyup="subchargers_onkey(this);taxpayable_onkey(this);"  class="form-control" style="width: 100px !important;" readonly/></td>';
                        //                results += '<td class="25" style="text-align:  center;">' + msg[k].subcharges + '</td>';
                        results += '<td class="25" style="text-align:  center;"><input id="txt_subchargers" type ="text" onkeyup="subchargers_onkey(this);taxpayable_onkey(this);"  class="form-control" style="width: 100px !important;" readonly/></td>';
                        //                results += '<td class="26" style="text-align:  center;">' + msg[k].taxpayable + '</td>';
                        results += '<td class="26" style="text-align:  center;"><input id="txt_taxpayable" type ="text" onkeyup="taxpayable_refundable(this);" class="form-control" style="width: 100px !important;" readonly/></td>';
                        //                results += '<td class="27" style="text-align:  center;">' + msg[k].tdsdedected + '</td>';
                        results += '<td class="27" style="text-align:  center;"><input id="txt_taxdeduct" type ="text" onkeyup="taxpayable_refundable(this);" class="form-control" style="width: 100px !important;" /></td>';
                        //                results += '<td class="28" style="text-align:  center;">' + msg[k].taxpayablerefundable + '</td>';
                        results += '<td class="28" style="text-align:  center;"><input id="txt_taxpayablerefundable" type ="text"  class="form-control" style="width: 100px !important;" readonly/></td>';

                        results += '</tr>'
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                    results += '</table>';
                    $("#div_empmaster_table").html(results);
                }

        function changecaluclation(thisid) {
            var totpf = $(thisid).parent().parent().children('.15').html();
            if (totpf != "") {
                totpf = parseFloat(totpf);
            }
            var lic = $(thisid).closest("tr").find('#txt_lic').val();
            if (lic != "") {
                lic = parseFloat(lic);
            }
            var stutionfee = $(thisid).closest("tr").find('#txt_stutionfee').val();
            if (stutionfee != "") {
                stutionfee = parseFloat(stutionfee);
            }
            var others = $(thisid).closest("tr").find('#txt_others').val();
            if (others != "") {
                others = parseFloat(others);
            }
            var totalsavings = totpf + lic + stutionfee + others;
            $('#txt_totalsavings').val(totalsavings);
        }

        function taxable_changecaluclation(thisid) {
            var totalpf = $(thisid).parent().parent().children('.13').html();
            if (totalpf != "") {
                totpf = parseFloat(totalpf);
            }
            var hra = $(thisid).closest("tr").find('#txt_hra').val();
            if (hra != "") {
                hra = parseFloat(hra);
            }
            var totalsavings = $(thisid).closest("tr").find('#txt_totalsavings').val();
            if (totalsavings != "") {
                totalsavings = parseFloat(totalsavings);
            }
            var eightyd = $(thisid).closest("tr").find('#txt_eightyd').val();
            if (eightyd != "") {
                eightyd = parseFloat(eightyd);
            }
            var taxablesalary = totalpf - hra - totalsavings - eightyd;
            $('#txt_taxable').val(taxablesalary);

        }
        function taxpayable_beforerebate(thisid) {
            var taxable = $(thisid).closest("tr").find('#txt_taxable').val();
            if (taxable != "") {
                taxable = parseFloat(taxable);
            }
            var taxablerebate = ((taxable - 250000)) * (5 / 100);
            $('#txt_taxpayrebate').val(taxablerebate);
        }
        function total_rebate(thisid) {
            var taxblerebate = $(thisid).closest("tr").find('#txt_taxpayrebate').val();
            if (taxblerebate != "") {
                taxblerebate = parseFloat(taxblerebate);
            }
            var rebatea = $(thisid).closest("tr").find('#txt_rebate87a').val();
            if (rebatea != "") {
                rebatea = parseFloat(rebatea);
            }
            var totalthree = taxblerebate - rebatea;
            $('#txt_totalthree').val(totalthree);
        }
        function subchargers_onkey(thisid) {
            var subchargestot = $(thisid).closest("tr").find('#txt_totalthree').val();
            if (subchargestot != "") {
                subchargestot = parseFloat(subchargestot);
            }
            var taxablerebate = (subchargestot) * (3 / 100);
            $('#txt_subchargers').val(taxablerebate);
        }
        function taxpayable_onkey(thisid) {
            var totalthree = $(thisid).closest("tr").find('#txt_totalthree').val();
            if (totalthree != "") {
                totalthree = parseFloat(totalthree);
            }
            var subchargestot = $(thisid).closest("tr").find('#txt_subchargers').val();
            if (subchargestot != "") {
                subchargestot = parseFloat(subchargestot);
            }
            var taxabletot = totalthree + subchargestot;
            $('#txt_taxpayable').val(taxabletot);
        }
        function taxpayable_refundable(thisid) {
            var taxpayable = $(thisid).closest("tr").find('#txt_taxpayable').val();
            if (taxpayable != "") {
                taxpayable = parseFloat(taxpayable);
            }
            var taxdeductions = $(thisid).closest("tr").find('#txt_taxdeduct').val();
            if (taxdeductions != "") {
                taxdeductions = parseFloat(taxdeductions);
            }
            var taxpayablerefundable = taxpayable - taxdeductions;
            $('#txt_taxpayablerefundable').val(taxpayablerefundable);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
           TDS <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">TDS master</a></li>
        </ol>
    </section>
    <section class="content">
    <div id="div_Documents" class="box box-danger">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-user-plus"></i>TDS Caluculations
                </h3>
                 </div>
                   <div class="box-body" id="div_tdsdiv">
                     <div align="center" >
                       <table>
                        <tr>
                            <td>
                                <label class="control-label" >
                                    Year</label>
                                    </td>
                                    <td>&nbsp</td>
                                    <td>
                               <select id="slct_year" class="form-control" style="width: 100%;">
                             </select>
                            </td>
                            &nbsp
                            <td >
                            <div class="input-group" style="padding-left: 10%;">
                              <div class="input-group-addon" style="border-color: #3c8dbc;background-color: #3c8dbc;border-radius: 4px;color: whitesmoke;">
                                <span class="glyphicon glyphicon-flash" onclick="tds_generate_report();"  ></span> <span id="btn_generate"  onclick="tds_generate_report();">Genarate</span>
                             </div>
                          </div>
                       </td>
                     </tr>
                   </table>
                </div>
                 </div>
                 <div id="divPrint" style="border-style: ridge; display:none;">
                <div id="div_empmaster_table"></div>
             </div>
             <br />
             <div style="padding-left: 43%;">
              <div class="input-group" id="div_print" style="padding-right: 90%; display:none;">
              <table>
              <tr>
              <td>
                    <div class="input-group-addon" id="">
                        <span class="glyphicon glyphicon-print" onclick="javascript: CallPrint('divPrint');"></span> <span id="Span1" onclick="javascript: CallPrint('divPrint');">Print</span>
                    </div>
                    </td>
                    <td>
                    <div>
                     <input type="button" class="btntogglecls" style="height: 28px; opacity: 1.0; width: 100px;
                                        background-color: #d5d5d5; color: Blue;" onclick="tableToExcel('tbl_empmaster', 'W3C Example Table')"
                                        value="Export to Excel">
                    </div>
                    </td>
                    </tr>
                    </table>
                </div>
                </div>
                <br/>
          </div>
       </div>
   </section>
</asp:Content>
