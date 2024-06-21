<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="tdsdeclaration.aspx.cs" Inherits="tdsdeclaration" %>

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
        .tdsize
        {
            font-size: 12px;
        }
        .tdheading
        {
            font-size: 12px;
            font-weight: bold;
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
            var data = { 'op': 'get_Employeedetails' };
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
                    document.getElementById('txtsupid').value = employeedetails[i].empsno;
                }
            }
        }

        function btn_LoanInfom_order_click() {
            var empid = document.getElementById('txtsupid').value;
            if (empid == "") {
                alert("Please enter Employee Name");
                return false;
            }
            var data = { 'op': 'get_Loan_Request_details_click', 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        var employee_details = msg;
                        $('#divPrint').css('display', 'block');
                        //var employee_details = msg;
                        document.getElementById('lblempname').innerHTML = employee_details[0].fullname;
                        document.getElementById('lblEmpID').innerHTML = employee_details[0].employee_num;
                        document.getElementById('lblFathersName').innerHTML = employee_details[0].fathername;
                        document.getElementById('lblAdress').innerHTML = employee_details[0].presentaddress;
                        document.getElementById('lblperementaddress').innerHTML = employee_details[0].home_address;
                        document.getElementById('lblContactNumber').innerHTML = employee_details[0].cellphone;
                        document.getElementById('lblDOB').innerHTML = employee_details[0].dob;
                        document.getElementById('lblDesignation').innerHTML = employee_details[0].designation;
                        document.getElementById('lblExprnceCompany').innerHTML = employee_details[0].experience;
                        document.getElementById('lblSalaryPaydate').innerHTML = employee_details[0].salarydate;
                        document.getElementById('lblPuposeloan').innerHTML = employee_details[0].purpose_of_loan;
                        document.getElementById('lblAnyprivoesloan').innerHTML = employee_details[0].previousloan;
                        document.getElementById('lblLoanAmount').innerHTML = employee_details[0].loanamount;
                        document.getElementById('lblLoanNomonth').innerHTML = employee_details[0].months;
                        document.getElementById('lblname1').innerHTML = employee_details[0].refemp1;
                        document.getElementById('lblDesgnation1').innerHTML = employee_details[0].designation1;
                        document.getElementById('lblAddress1').innerHTML = employee_details[0].address1;
                        document.getElementById('lblname2').innerHTML = employee_details[0].refemp2;
                        document.getElementById('lblDesgnation2').innerHTML = employee_details[0].designation2;
                        document.getElementById('lblAddress2').innerHTML = employee_details[0].address2;
                        document.getElementById('Spa_loanemi').innerHTML = employee_details[0].loanemimonth;
                        document.getElementById('lblnumbr1').innerHTML = employee_details[0].refphone1;
                        document.getElementById('lblnumbr2').innerHTML = employee_details[0].refphone2;
                        document.getElementById('spnchqno1').innerHTML = employee_details[0].chequeno1;
                        document.getElementById('spnchqno2').innerHTML = employee_details[0].chequeno2;
                        document.getElementById('spnemprefnum2').innerHTML = employee_details[0].emprefnum2;
                        document.getElementById('spnemprefnum1').innerHTML = employee_details[0].emprefnum1;

                        document.getElementById('spnempdept').innerHTML = employee_details[0].empdept;
                        document.getElementById('spnempdept1').innerHTML = employee_details[0].empdept1;
                        document.getElementById('spnempdept2').innerHTML = employee_details[0].empdept2;
                        document.getElementById('spnnarationloanemi').innerHTML = employee_details[0].loanemimonth;
                        document.getElementById('spnnarname').innerHTML = employee_details[0].fullname;
                        document.getElementById('spnexpemp1').innerHTML = employee_details[0].refemp1exp;
                        document.getElementById('spnexpemp2').innerHTML = employee_details[0].refemp2exp;
                        document.getElementById('lblstartmonthpdate').innerHTML = employee_details[0].startdate;

                        var loanamt = employee_details[0].loanamount;

                        document.getElementById('spnamttext').innerHTML = inWords(parseInt(loanamt));
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

        var a = ['', 'one ', 'two ', 'three ', 'four ', 'five ', 'six ', 'seven ', 'eight ', 'nine ', 'ten ', 'eleven ', 'twelve ', 'thirteen ', 'fourteen ', 'fifteen ', 'sixteen ', 'seventeen ', 'eighteen ', 'nineteen '];
        var b = ['', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];

        function inWords(num) {
            if ((num = num.toString()).length > 9) return 'overflow';
            n = ('000000000' + num).substr(-9).match(/^(\d{2})(\d{2})(\d{2})(\d{1})(\d{2})$/);
            if (!n) return; var str = '';
            str += (n[1] != 0) ? (a[Number(n[1])] || b[n[1][0]] + ' ' + a[n[1][1]]) + 'crore ' : '';
            str += (n[2] != 0) ? (a[Number(n[2])] || b[n[2][0]] + ' ' + a[n[2][1]]) + 'lakh ' : '';
            str += (n[3] != 0) ? (a[Number(n[3])] || b[n[3][0]] + ' ' + a[n[3][1]]) + 'thousand ' : '';
            str += (n[4] != 0) ? (a[Number(n[4])] || b[n[4][0]] + ' ' + a[n[4][1]]) + 'hundred ' : '';
            str += (n[5] != 0) ? ((str != '') ? 'and ' : '') + (a[Number(n[5])] || b[n[5][0]] + ' ' + a[n[5][1]]) + 'only ' : '';
            return str;
        }

        var replaceHtmlEntites = (function () {
            var translate_re = /&(nbsp|amp|quot|lt|gt);/g;
            var translate = {
                "nbsp": " ",
                "amp": "&",
                "quot": "\"",
                "lt": "<",
                "gt": ">"
            };
            return function (s) {
                return (s.replace(translate_re, function (match, entity) {
                    return translate[entity];
                }));
            }
        })();
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Loan Information Report<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#"> Loan Information Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i> Loan Information Report
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
                                    onclick="btn_LoanInfom_order_click()" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="divPrint">
                    <div style="border: 2px solid gray;">
                        <div style="width: 17%; float: right; padding-top:5px;">
                            <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                            <br />
                        </div>
                     
 <div style="border: 1px solid gray;">
                   <div style="width: 100%; padding-top: 3px;">
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 49%;  padding-left:2%; border:1px solid gray; line-height: 1.628571 !important;">
                                    <label><b>
                                        Name :</b></label>
                                    <span class="lblempname"  id="Span2">Obulasetti Naveen Kumar</span>
                                   
                                </td>
                                <td style="width: 50%;  padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;" >
                                    <label id="Label1"><b>Designation :</b></label>
                                    <span id="Span3">SoftWare Developer</span>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 49%;  padding-left:2%; border:1px solid gray; line-height: 1.628571 !important;">
                                    <label><b>
                                        PAN :</b></label>
                                    <span class="lblpanno"  id="Span4"></span>
                                   
                                </td>
                                <td style="width: 50%;  padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;" >
                                    <label id="Label2"><b>DOJ :</b></label>
                                    <span id="spndoj">05-Sep-2015</span>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 49%;  padding-left:2%; border:1px solid gray; line-height: 1.628571 !important;">
                                    <label><b>
                                        Sri Vyshnavi Foods Pvt Ltd<br />NO 25, 2ND STREET, PERIYAR NAGAR, KORATTUR, Chennai 600080.</label>
                                </td>
                                <td style="width: 50%;  padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;" >
                                    <label id="Label3"><b>Company :</b></label>
                                    <span id="Span7">Sri Vyshnavi Foods Pvt Ltd</span>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 49%;  padding-left:2%; border:1px solid gray; line-height: 1.628571 !important;">
                                    <label><b>
                                        Pan No :</b></label>
                                    <span class="lblempname"  id="Span8">AAFCS1152D</span>
                                   
                                </td>
                            </tr>

                            </table>
                         <table style="width: 100%;">
                            <tr>
                                <td class="labelrpt" style="border:1px solid gray; text-align:center;"> 
                            
                                    <label style="font-size:16px !important;"><b>
                                        Gross Salary And Other Allowances </b></label>
                                </td>
                                 <td class="labelrpt"  style="border:1px solid gray; text-align:center;"> 
                                <div>
                                    <label><b>
                                        Rs. </b></label></div>
                                </td>
                                <td class="labelrpt"  style="border:1px solid gray;text-align:center;"> 
                                <div>
                                    <label><b>
                                        Rs. </b></label></div>
                                </td>
                            </tr>
                           
                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                        Salary From April 2017 to March 2018</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                       Add Bonus</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="3" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt" style="font-size:16px !important;"><b>
                                       Less HRA Exempted U/s 10 (13A)</b></label>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      1)  Actual HRA Received</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      2)  Actual Rent Paid</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>


                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                            Less: 10 % of Basic Salary</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      3)  50 % of Basic Salary</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                        (Least of the above is exempt from tax)</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="3" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt" style="font-size:16px !important;"><b>
                                       Less Deduction u/s. 80C :  (Up to Rs 1,50,000/-)</b></label>
                                </td>
                                
                            </tr>

                            <tr>
                                <td colspan="3" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                        (Deduction up to Rs.150000/- for the aggregate of the following deposits)</b></label>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      1)  Life Insurance Premium Paid</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      2) Payment for Annuity Plan</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>


                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      3)  Contribution towards Provident Fund / PPF
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      4)  Investment in NSC (VIII issue) + Interest
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      5)  Contribution towards ULIP
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      6)  Contribution towards notified pension fund by MF / UTI
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      7)  Re-payment of Housing Loan etc
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      8)  Tuition Fees paid for children
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      9)  5 Years Fixed Deposit with PO or Schdule Bank
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      10)  Contribution towards NPF
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      11)  Employee's Contribution towards NPS (uo to 10%) (u/s.80CCD)
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      12) Employer's Contribution towards NPS (uo to 10%) (u/s.80CCD)
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      13)  Long Term Infrastructure Bonds (u/s.80CCF)
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      14)  Investment under Equity Saving Scheme (u/s.80CCG)
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      15)  Any Other Deductable (u/s.80C)
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="float: right;padding-right: 12px; line-height: 1.628571 !important;">
                                    <label class="labelrpt" style="font-size: 16px !important;"><b>
                                      Total
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                              <td colspan="3"><br /></td> 
                            </tr>

                            <tr>
                                <td colspan="3" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                     Less Deduction u/s 80 D 
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      Mediclaim Insurance Premium
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="3" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                     Less Deduction u/s 80 E 
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                      Interest on Loan for Higher Education
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                              <tr>
                                <td colspan="3" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                    Deduction u/s 80 EE
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                     Interest on Loan taken for Residential House
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="3" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                   Deduction u/s 80 G 
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                    Donations
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="3" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                   Deduction u/s 80 TTA
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                  Interest on Deposits in Savings Account
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>
                            
                            <tr>
                                <td style="float: right;padding-right: 12px; line-height: 1.628571 !important;">
                                    <label class="labelrpt" style="font-size: 16px !important;"><b>
                                       Net Taxable Income
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>
                           
                            <tr>
                                <td>
                                   <br />
                                </td>
                            </tr>

                            <tr>
                                <td colspan="3" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt" style="font-size:16px !important;"><b>
                                  Income Tax
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                  Less: Tax Rebate U/s.87 A (Taxable Income doesn't exceed Rs.5 Lacs)
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>
                              <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                 Add: Surcharge @ 12% on Income Tax (If income exceed Rs1 Crore)
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                             <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                Add: Edu / Secodary & Higher Edu Cess @ 3% on Income Tax & Surcharge
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="float: right;padding-right: 12px; line-height: 1.628571 !important;">
                                    <label class="labelrpt" style="font-size: 16px !important;"><b>
                                       Tax to be Deducted
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>
                             <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                TO BE FILLED BY HRD
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                TO BE FILLED BY EMPLOYEE
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                  <input type="text" style="width: 100%;"/>
                                </td>
                            </tr>

                             <tr>
                                <td colspan="3" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                For Senior Citizen up to Rs.3,00,000/- exempted (Above 60 years but below 80 years)
                                </td>
                            </tr>

                             <tr>
                                <td colspan="3" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                For Super Senior Citizen up to Rs.5,00,000/- exempted (Above 80 years) 
                                </td>
                            </tr>

                             <tr>
                                <td colspan="3" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                               For Others up to Rs.2,50,000/- exempted
                                </td>
                            </tr>
                        </table>

                        <table>
                        <tr>
                                <td colspan="2" style="float: right;padding-right: 12px; line-height: 1.628571 !important;">
                                    <label class="labelrpt" style="font-size: 16px !important;"><b>
                                        Tax Rates
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                   Tax 
                                </td>
                            </tr>
                           
                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                     1)  Upto Rs.250000    -   Nil</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                 	0
                                </td>
                            </tr>

                            <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                  2)  Rs.250000 - Rs.500000                              - 10%</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                 	0
                                </td>
                            </tr>

                             <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                 3)  Rs.500000 - Rs 1000000                            - Rs.12500 + 20%</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                 	0
                                </td>
                            </tr>

                             <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                 4)   Rs.1000000 - Rs.10000000                        - Rs.112500 + 30%</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                 	0
                                </td>
                            </tr>
                             <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                5)   Above Rs.10000000                                   - Rs.2812500+ 30%</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                 	0
                                </td>
                            </tr>
                             <tr>
                                <td style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                  (If income exceed Rs.1 Crores Surcharge @ 10% will applicable)</b></label>
                                </td>
                                <td style="border:1px solid gray; line-height: 1.628571 !important;">
                                 	0
                                </td>
                            </tr>

                             <tr>
                                <td colspan="2" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                  <br />
                                </td>
                            </tr>

                             <tr>
                                <td colspan="2" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                               <label class="labelrpt" style="font-size:16px !important;"><b>
                                  Notes</b></label>  
                                </td>
                            </tr>
                             <tr>
                                <td  colspan="2" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                  Actual Rent Paid - It should be supported by Rent Receipt or Declaration given by the Employee</b></label>
                                </td>
                            </tr>
                            <tr>
                                <td  colspan="2" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                 Repayment of Housing Loan - It should be supported by Certificate issued by the Bank</b></label>
                                </td>
                            </tr>
                            <tr>
                                <td  colspan="2" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                 LIC Premium Paid - It should be supported by Premium Receipts</b></label>
                                </td>
                            </tr>
                            <tr>
                                <td  colspan="2" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                 Tuition Fee Paid - It should be supported by the Receipt</b></label>
                                </td>
                            </tr>
                             <tr>
                                <td  colspan="2" style="padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                Others (if any) - It should be supported by proper Receipts</b></label>
                                </td>
                            </tr>
                        </table>
                        </div>
                    </div>              
                     </div>
                </div>
                <br />
                <br />
                
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
            </div>
        </div>
        <div class="input-group" id="Button2" style="padding-right: 90%;">
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-print" onclick="javascript: CallPrint('divPrint');"></span> <span id="Span1" onclick="javascript: CallPrint('divPrint');">Print</span>
                    </div>
                </div>
    </section>
</asp:Content>

