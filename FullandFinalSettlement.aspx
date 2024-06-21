<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="FullandFinalSettlement.aspx.cs" Inherits="FullandFinalSettlement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
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
            get_Employeedetails();
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

        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
        }

        var employeedetails = [];
        function get_Employeedetails() {
            var data = { 'op': 'get_search_employee' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#selct_employe').autocomplete({
                        source: empnameList,
                        change: employeenamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function employeenamechange() {
            var empname = document.getElementById('selct_employe').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('txtsupid').value = employeedetails[i].employeid;
                }
            }
        }

        function btn__employeefinal_click() {
            var empid = document.getElementById('txtsupid').value;
            if (empid == "") {
                alert("Please enter Employee Name");
                return false;
            }
            var data = { 'op': 'get_finalsttelement_details_click', 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        var employeesaldetails = msg[0].empresiglist;
                        var distinctMap = {};
                        for (var i = 0; i < employeesaldetails.length; i++) {
                            var value = employeesaldetails[i].month;
                            distinctMap[value] = '';
                        };
                        var unique_values = [];
                        unique_values = Object.keys(distinctMap);
                        unique_values.sort(function (a, b) { return a - b });
                        var nmonth = [];
                        for (var i = 0; i < unique_values.length; i++) {
                            var month = new Array();
                            var months = ["", "January", "February", "March", "April", "May", "June",
               "July", "August", "September", "October", "November", "December"];
                            nmonth.push(months[(parseInt(unique_values[i]))]);
                        }
                        var employee_details = employeesaldetails[0];
                        var employee_details1 = employeesaldetails[1];
                        var employeeresigdet = msg[0].emplist;
                        $('#divPrint').css('display', 'block');
                        //var employee_details = msg;
                        document.getElementById('lblEmpID').innerHTML = employee_details.employee_num;
                        document.getElementById('spn_Empname').innerHTML = employeeresigdet[0].fullname;
                        document.getElementById('spn_Depart').innerHTML = employeeresigdet[0].department;
                        document.getElementById('SpnDesignation').innerHTML = employeeresigdet[0].designation;
                        document.getElementById('Spn_Brach').innerHTML = employeeresigdet[0].branchname;
                        document.getElementById('Spn_lbljoing').innerHTML = employeeresigdet[0].joindate;
                        document.getElementById('Spn_DOResign').innerHTML = employeeresigdet[0].resignationdate;
                        document.getElementById('Spn_LastDOW').innerHTML = employeeresigdet[0].lastworkingday;
                        document.getElementById('month').innerHTML = nmonth[1];
                        document.getElementById('month1').innerHTML = nmonth[0];
                        //                        document.getElementById('Spn_SalPaid').innerHTML = employee_details.lastsalpaid;
                        //                        document.getElementById('Spn_aplltr').innerHTML = employeeresigdet[0].applicationletter;
                        //                        document.getElementById('Spn_Ntcprd').innerHTML = employeeresigdet[0].noticeprdadjstble;
                        //                        document.getElementById('Spn_Pldays').innerHTML = employee_details.pldays;
                        //                        document.getElementById('Spn_Nodaysalpay').innerHTML = employee_details.numpaydays;
                        //                        document.getElementById('Spn_NOinMonth').innerHTML = employee_details.daysinmonth;
                        document.getElementById('spn_ernbasic').innerHTML = employee_details.basic;
                        document.getElementById('Spanbasic2').innerHTML = employee_details1.basic;
                        document.getElementById('spn_HousingRent').innerHTML = employee_details.hra;
                        document.getElementById('Spanhra2').innerHTML = employee_details1.hra;
                        document.getElementById('spn_Converance').innerHTML = employee_details.convenace;
                        document.getElementById('Spancon2').innerHTML = employee_details1.convenace;
                        document.getElementById('spn_Medical').innerHTML = employee_details.medicalallowance;
                        document.getElementById('Spanme2').innerHTML = employee_details.medicalallowance;
                        document.getElementById('spn_WashingAllowance').innerHTML = employee_details.washingallowance;
                        document.getElementById('Spanwa2').innerHTML = employee_details1.washingallowance;
                        document.getElementById('spn_TotalEarnings').innerHTML = employee_details.totalearnings;
                        document.getElementById('Spante2').innerHTML = employee_details1.totalearnings;
                        document.getElementById('spn_PF').innerHTML = employee_details.pf;
                        document.getElementById('Spanpf2').innerHTML = employee_details1.pf;
                        document.getElementById('spn_professinaltax').innerHTML = employee_details.pt;
                        document.getElementById('Spanpt2').innerHTML = employee_details1.pt;
                        document.getElementById('spn_Esi').innerHTML = employee_details.esi;
                        document.getElementById('Spanesi2').innerHTML = employee_details1.esi;
                        document.getElementById('spn_Incometax').innerHTML = employee_details.tdsdedcution;
                        document.getElementById('Spanit2').innerHTML = employee_details1.tdsdedcution;
                        document.getElementById('spn_canteendeduction').innerHTML = employee_details.canteendeduction;
                        document.getElementById('Spancd2').innerHTML = employee_details1.canteendeduction;
                        document.getElementById('spn_Totaldeduction').innerHTML = employee_details.totaldeduction;
                        document.getElementById('Spantd2').innerHTML = employee_details1.totaldeduction;
                        document.getElementById('spn_netsalary').innerHTML = employee_details.netpay;
                        document.getElementById('Spanps2').innerHTML = employee_details1.netpay;
                        document.getElementById('spn_loan').innerHTML = employee_details.loan;
                        document.getElementById('Spanld2').innerHTML = employee_details1.loan;
                        document.getElementById('spn_salaryadvnc').innerHTML = employee_details.salaryadavance;
                        document.getElementById('spn_otherdedu').innerHTML = employee_details.totaldeduction;
                        document.getElementById('Spanod2').innerHTML = employee_details1.totaldeduction;
                        document.getElementById('spn_medicliam').innerHTML = employee_details.medicliam;
                        document.getElementById('Spanmed2').innerHTML = employee_details1.medicliam;
                        document.getElementById('spn_mbldeduction').innerHTML = employee_details.mobilededuction;
                        document.getElementById('Spanmd2').innerHTML = employee_details1.mobilededuction;
                        document.getElementById('recevied').innerHTML = toWords(employee_details.netpay);
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

        var th = ['', 'thousand', 'million', 'billion', 'trillion'];

        var dg = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];

        var tn = ['ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'];

        var tw = ['twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];

        function toWords(s) {
            s = s.toString();
            s = s.replace(/[\, ]/g, '');
            if (s != parseFloat(s)) return 'not a number';
            var x = s.indexOf('.');
            if (x == -1) x = s.length;
            if (x > 15) return 'too big';
            var n = s.split('');
            var str = '';
            var sk = 0;
            for (var i = 0; i < x; i++) {
                if ((x - i) % 3 == 2) {
                    if (n[i] == '1') {
                        str += tn[Number(n[i + 1])] + ' ';
                        i++;
                        sk = 1;
                    } else if (n[i] != 0) {
                        str += tw[n[i] - 2] + ' ';
                        sk = 1;
                    }
                } else if (n[i] != 0) {
                    str += dg[n[i]] + ' ';
                    if ((x - i) % 3 == 0) str += 'hundred ';
                    sk = 1;
                }
                if ((x - i) % 3 == 1) {
                    if (sk) str += th[(x - i - 1) / 3] + ' ';
                    sk = 0;
                }
            }
            if (x != s.length) {
                var y = s.length;
                str += 'point ';
                for (var i = x + 1; i < y; i++) str += dg[n[i]] + ' ';
            }
            return str.replace(/\s+/g, ' ');

        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Final Settlement <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Final Settlement</a></li>
            <li><a href="#">Final Settlement</a></li>
        </ol>
    </section>
    <section>
   <div class="box box-info">
      <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Final Settlement
                    </h3>
                </div>
                <div class="box-body">
                <div>
                    <table>
                        <tr>
                            <td>
                                Employee Name
                            </td>
                            <td>
                                <input type="text" class="form-control" id="selct_employe" placeholder="Enter employee name"
                                    onkeypress="return ValidateAlpha(event);" />
                            </td>
                            <td style="height: 40px;">
                                <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                            </td>
                            <td>
                                <input id="Button1" type="button" class="btn btn-primary" name="submit" value='Generate'
                                    onclick="btn__employeefinal_click()" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="divPrint" style="display: none;">
                    <div style="width: 13%; float: left;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
                    <div align="center">
                        <div align="center" style="font-family: Arial; font-size: 12pt; font-weight: bold; color: Black;">
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
                        <span style="font-size: 16px; font-weight: bold;">FINAL SETTLEMENT</span>
                    </div>
                    <div align="center" style="width: 100%;">
                        <table align="center">
                            <tr>
                                <td style="width: 49%; padding-right: 5px;">
                                    <label style="width: 60%;">
                                        Employee Code</label>
                                        </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="lblEmpID"></span>
                                    </td>
                            </tr>
                            <tr>
                                <td style="width: 49%;">
                                    <label style="width: 60%;">
                                        Employee Name </label>
                                          </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="spn_Empname"></span>
                                    </td>
                            </tr>
                            <tr>
                                <td style="width: 49%;">
                                    <label style="width: 60%;">
                                        Department </label>
                                          </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="spn_Depart"></span>
                                    <br />
                                </td>
                            </tr>
                            
                            <tr>
                                <td style="width: 49%; float: left;">
                                    <label style="width: 60%;">
                                        Designation </label>
                                          </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="SpnDesignation"></span>
                                    <br />
                                </td>
                            </tr>
                             <tr>
                                <td style="width: 49%;">
                                    <label style="width: 60%;">
                                        Location </label>
                                          </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="Spn_Brach"></span>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                   <label style="width: 60%;">
                                        Date of Joining </label>
                                          </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="Spn_lbljoing"></span>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label style="width: 60%;">
                                        Submission date of resignation </label>
                                          </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="Spn_DOResign"></span>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label style="width: 60%;">
                                        Last date of working </label>
                                          </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="Spn_LastDOW"></span>
                                    <br />
                                </td>
                            </tr>
                          <%--  <tr>
                                <td>
                                    <label style="width: 60%;">
                                        Last salary paid</label>
                                          </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="Spn_SalPaid"></span>
                                    <br />
                                </td>
                            </tr>
                             <tr>
                                <td>
                                    <label style="width: 60%;">
                                        Notice period as per application letter</label>
                                          </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="Spn_aplltr"></span>
                                    <br />
                                </td>
                            </tr>
                             <tr>
                                <td>
                                    <label style="width: 60%;">
                                        Notice period adjustable</label>
                                          </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="Spn_Ntcprd"></span>
                                    <br />
                                </td>
                            </tr>
                             <tr>
                                <td>
                                    <label style="width: 60%;">
                                        PL days payable</label>
                                          </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="Spn_Pldays"></span>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label style="width: 60%;">
                                       Number of days salary payable</label>
                                         </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="Spn_Nodaysalpay"></span>
                                    <br />
                                </td>
                            </tr>
                             <tr>
                                <td>
                                    <label style="width: 60%;">
                                       Number of days in the month</label>
                                         </td>
                                        <td style="width: 2%;">:</td>
                                        <td style="width: 49%;">
                                    <span id="Spn_NOinMonth"></span>
                                    <br />
                                </td>
                            </tr>--%>
                          
                             </table>
                             <div>
                           <table class="tablecenter" width="98%">
                <tr  valign="top">
                    <td colspan="2" style="padding-left: 18px;" width="40%">
                     <section class="content">
    <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 100px; font-weight:bold" class="fa fa-cog"></i>EARNINGS
                    <span class="inputbox" id="month"></span>
                </h3>
            </div>
            <div class="box-body">
                                <table align="left" width="65%">
                                    <tr>
                                        <td >
                                           <strong>Basic</strong>
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="spn_ernbasic" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight:bold">
                                            House Rent Allowance
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="spn_HousingRent"  ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" font-weight:bold">
                                            Conveyance
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="spn_Converance" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight:bold">
                                            Medical Earnings
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="spn_Medical"  ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" font-weight:bold">
                                           Washing Allowance
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="spn_WashingAllowance" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                    <td style=" display:none">
                                            Salarymode
                                        </td>
                                        <td style="display:none">
                                            <span  class="inputBox" id="spnsalarymode" ></span>
                                             
                                        </td>
                                        <td style=" font-weight:bold">
                                            Total Earnings
                                        </td>
                                        <td>
                                            <span class="inputBox"  id="spn_TotalEarnings"  ></span>
                                             
                                        </td>
                                    </tr>
                                </table>
                                </div>
                                </div>
                                </section>
                           
                        </td>
                        <td colspan="2" width="50%" style="padding-left:18px;">
                            <section class="content">
    <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i class="fa fa-cog" style="padding-right: 100px; font-weight:bold"></i>Deduction
                </h3>
            </div>
            <div class="box-body">

                                <table width="60%" align="left">
                                    <tr>
                                        <td style="  font-weight:bold">
                                            Provident Fund
                                        </td>
                                        <td>
                                            <span class="inputBox" id="spn_PF"  ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight:bold">
                                              Professional Tax
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="spn_professinaltax" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" font-weight:bold">
                                            ESI
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="spn_Esi"></span>
                                             
                                        </td>
                                    </tr>
                                   <tr>
                                        <td style=" font-weight:bold">
                                            Income Tax
                                        </td>
                                        <td>
                                            <span type="text" class="inputBox" id="spn_Incometax"  ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                    <td style=" font-weight:bold">
                                             Canteen Deduction
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="spn_canteendeduction" ></span>  
                                             
                                        </td>
                                       </tr>
                                        <tr>
                                        <td style="font-weight:bold">
                                           Mobile Deduction
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="spn_mbldeduction" ></span>
                                             
                                        </td>
                                    </tr>
                                     <tr>
                                        <td style="font-weight:bold">
                                          Loan Deduction
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="spn_loan" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" font-weight:bold">
                                          Salary Advance
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="spn_salaryadvnc" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight:bold">
                                          Other Deduction
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="spn_otherdedu" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" font-weight:bold">
                                          Mediclaim Deduction
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="spn_medicliam" ></span>
                                             
                                        </td>
                                    </tr>
                                    <%--<tr>
                                        <td style="height: 40px;">
                                          TDS Deduction
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Span3" ></span>
                                             
                                        </td>
                                    </tr>--%>
                                    <tr>
                                        <td style="font-weight:bold">
                                            Total Deductions
                                        </td >
                                        <td>
                                            <span class="inputBox" id="spn_Totaldeduction" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                     <td style=" font-weight:bold">
                                Payable Salary
                            </td>
                            <td>
                                <span  class="inputBox" id="spn_netsalary" />
                            </td>
                                    </tr>

                                </table>
                                </div>
                          </div>
                          </section>
                        </td>
                    </tr>

                    <tr  valign="top">
                    <td colspan="2" style="padding-left: 18px;" width="40%">
                     <section class="content">
    <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 100px; font-weight:bold" class="fa fa-cog"></i>EARNINGS
                    <span class="inputbox" id="month1"></span>
                </h3>
            </div>
            <div class="box-body">
                                <table align="left" width="65%">
                                    <tr>
                                        <td>
                                           <strong>Basic</strong>
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Spanbasic2" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" font-weight:bold">
                                            House Rent Allowance
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Spanhra2"  ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" font-weight:bold">
                                            Conveyance
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Spancon2" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" font-weight:bold">
                                            Medical Earnings
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Spanme2"  ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" font-weight:bold">
                                           Washing Allowance
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Spanwa2" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                    <td style="display:none">
                                            Salarymode
                                        </td>
                                        <td style="display:none">
                                            <span  class="inputBox" id="Spansm2" ></span>
                                             
                                        </td>
                                        <td style=" font-weight:bold">
                                            Total Earnings
                                        </td>
                                        <td>
                                            <span class="inputBox"  id="Spante2"  ></span>
                                             
                                        </td>
                                    </tr>
                                </table>
                                </div>
                                </div>
                                </section>
                           
                        </td>
                        <td colspan="2" width="50%" style="padding-left:18px;">
                            <section class="content">
    <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i class="fa fa-cog" style="padding-right: 100px; font-weight:bold"></i>Deduction
                </h3>
            </div>
            <div class="box-body">

                                <table width="60%" align="left">
                                    <tr>
                                        <td style=" font-weight:bold">
                                            Provident Fund
                                        </td>
                                        <td>
                                            <span class="inputBox" id="Spanpf2"  ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" font-weight:bold">
                                              Professional Tax
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Spanpt2" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight:bold">
                                            ESI
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Spanesi2"></span>
                                             
                                        </td>
                                    </tr>
                                   <tr>
                                        <td style=" font-weight:bold">
                                            Income Tax
                                        </td>
                                        <td>
                                            <span type="text" class="inputBox" id="Spanit2"  ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                    <td style=" font-weight:bold">
                                             Canteen Deduction
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Spancd2" ></span>  
                                             
                                        </td>
                                       </tr>
                                        <tr>
                                        <td style=" font-weight:bold">
                                           Mobile Deduction
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Spanmd2" ></span>
                                             
                                        </td>
                                    </tr>
                                     <tr>
                                        <td style="font-weight:bold">
                                          Loan Deduction
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Spanld2" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" font-weight:bold">
                                          Salary Advance
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Spansa2" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" font-weight:bold">
                                          Other Deduction
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Spanod2" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" font-weight:bold">
                                          Mediclaim Deduction
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Spanmed2" ></span>
                                             
                                        </td>
                                    </tr>
                                    <%--<tr>
                                        <td style="height: 40px;">
                                          TDS Deduction
                                        </td>
                                        <td>
                                            <span  class="inputBox" id="Span3" ></span>
                                             
                                        </td>
                                    </tr>--%>
                                    <tr>
                                        <td style="font-weight:bold">
                                            Total Deductions
                                        </td >
                                        <td>
                                            <span class="inputBox" id="Spantd2" ></span>
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                     <td style=" font-weight:bold">
                                Payable Salary
                            </td>
                            <td>
                                <span  class="inputBox" id="Spanps2" />
                            </td>
                                    </tr>

                                </table>
                                </div>
                          </div>
                          </section>
                        </td>
                    </tr>
                </table>
                 <div align="center"  style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                        <span style="font-size: 16px; font-weight: bold;">Amount in Words</span>
                    </div>
                <table>
                    <tr>
                    <td>
                    <label style="margin-top: -90px;">
                    NO dues Clearance done from all deptt: &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp(YES/NO)  
                    </label>
                    </td>
                        <td style="width:50%">
                         <label>
                                   I Recevied the  ("  <span id="recevied" style="font-weight:bold" onclick="test.rnum.value = toWords(test.inum.value);" value="To Words"> 
                                    </span><span>Rupees Only/-</span>")
                                    amount towards my full and final settlement  thro cheque,
                                    i declare that i have no dues from the company,i further
                                    declare that my legal heirs
                                    does not claim any money from the company in future
                                     <hr />
                                </label>
                            
                             <label>
                               <hr />
                             (signature of Employee)                                                                              
                             </label>
                                </td>
                                </tr>
                               
                                <tr>
                                <td>
                                <label>
                                HR Department
                               <hr />

                                </label>
                                </td>

                                </tr>
                                <tr>
                                <td>
                                <label>
                                -----------------For Accounts Department only---------------
                               <hr />

                                </label>
                                </td>
                                </tr>
                                <tr>
                                <td>
                                Payment vide Cheque No :...........................................
                               <hr />

                                Date of Payment :...........................................
                               <hr />

                                Name of Bank :...........................................
                               <hr />

                                </td>
                                <td>
                               <label> For Sri Vyshnavi Foods Pvt Ltd
                               <hr />

                             
                               </label>
                                </td>
                                </tr>
                                <tr>
                                <td>
                                <label style="width:50%">
                                Date:_____________________
                                </label>
                                <label>
                                Accounts Department
                                <hr />
                                (Authorised Signatory)
                                </label>
                                </td>
                                <td>
                                <label>
                                 (Authorised Signatory)
                                 <hr />
                                 </label>
                                </td>
                                <td>
                                </td>
                                </tr>
                </table>
                </div>
                       
                    </div>
                   <%-- <br />
                    <br />
                     <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 13px;">Employee Signature</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 13px;">CHECKED BY</span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                     <br />
                     <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 13px;">AUTHORIZED BY</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 13px;">RECEIVED AND SIGNED</span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">MANAGER</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">GENERAL MANAGER</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">DIRECTOR</span>
                            </td>
                        </tr>
                    </table>--%>
                </div>
                <input id="Button2" type="button" class="btn btn-primary" name="submit" value='Print'
                    onclick="javascript:CallPrint('divPrint');" />
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
            </div>
   </div>
    </section>
</asp:Content>
