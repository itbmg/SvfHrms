<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin.master" CodeFile="test.aspx.cs" Inherits="test" %>

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
                <div id="divPrint" style="display: none;">
                    <div style="border: 2px solid gray;">
                        <div style="width: 17%; float: right; padding-top:5px;">
                            <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                            <br />
                        </div>
                        <div style="border: 1px solid gray;">
                            <div style="font-family: Arial; font-size: 22px; font-weight: bold; color: Black;text-align: center;">
                                <span>Sri Vyshnavi Dairy Specialities (P) Ltd </span>
                                <br />
                            </div>
                            <div style="width:68%;text-align: center;padding-left: 14%;">
                            <span id="spnAddress" class="spanrpt">
                                R.S.No:381/2,Punabaka village Post, Pellakuru Mandal,Nellore District -524129.,
                                <br />
                                ANDRAPRADESH (State), Phone: 9440622077, Fax: 044 – 26177799.
                            </span>
                        </div>
                   <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                        <span id="spn_inv_title" style="font-size: 18px; font-weight: bold;">Loan Information</span>
                   </div>
                   <div style="width: 100%; padding-top: 3px;">
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 49%;  padding-left:2%; border:1px solid gray;">
                                    <label><b>
                                        Name :</b></label>
                                    <span class="lblempname" style="font-weight:bold;" id="lblempname"></span>
                                    <br />
                                    <label class="labelrpt"><b>
                                        Employee Code :</b></label>
                                    <span id="lblEmpID" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>
                                        Fathers Name  :</b></label>
                                    <span id="lblFathersName" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>Address :</b></label>
                                    <span id="lblAdress" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>Permanent Address :</b></label>
                                    <span id="lblperementaddress" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>Contact Number :</b></label>
                                    <span id="lblContactNumber" class="tdsize"></span>
                                    <br />
                                    <label class="labelrpt"><b>DOB :</b></label>
                                    <span id="lblDOB" class="tdsize"></span>
                                </td>
                                <td style="width: 50%;  padding-left:2%;border:1px solid gray;" >
                                   
                                    
                                    <label id="lbl_ref_no"><b>Designation :</b></label>
                                    <span id="lblDesignation"></span>

                                    <br />
                                    <label id="Label1"><b>Experience in the company :</b></label>
                                    <span id="lblExprnceCompany"></span>

                                    <br />
                                    <label id="Label2"><b>Salary paid as on date :</b></label>
                                    <span id="lblSalaryPaydate"></span>

                                    <br />
                                    <label id="Label3"><b>Purpose of Loan :</b></label>
                                    <span id="lblPuposeloan"></span>

                                    <br />
                                    <label id="Label4"><b>Any previous Loan :</b></label>
                                    <span id="lblAnyprivoesloan"></span>

                                    <br />
                                    <label id="Label5"><b>Loan amount :</b></label>
                                    <span id="lblLoanAmount"></span>

                                    <br />
                                    <label id="Label6"><b>Loan to be recovered in no.of months :</b></label>
                                    <span id="lblLoanNomonth"></span>

                                    <br />
                                    <label id="Label7"><b>Starting month Of date :</b></label>
                                    <span id="lblstartmonthpdate"></span>

                                    <br />
                                    <label id="Label8"><b>Loan EMI :</b></label>
                                    <span id="Spa_loanemi"></span>

                                </td>
                            </tr>
                            </table>
                         <table style="width: 100%;">
                            <tr>
                                <td class="labelrpt" colspan="2" style="text-align:center; border:1px solid gray;"> 
                                <div>
                                    <label><b>
                                        Referance Employees </b></label></div>
                                </td>
                              
                            </tr>
                           
                            <tr>
                                <td style="width: 49%; padding-left:2%;border:1px solid gray;">
                                    <label class="labelrpt"><b>
                                        Name :</b></label>
                                    <span id="lblname1" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>
                                        Designation :</b></label>
                                    <span id="lblDesgnation1" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>
                                        Address :</b></label>
                                    <span id="lblAddress1" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>
                                         Phone Number :</b></label>
                                    <span id="lblnumbr1" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>Cheque Number :</b></label>
                                    <span id="spnchqno1" class="spanrpt"></span>
                                </td>
                                <td style="width: 50%;  padding-left:2%; border:1px solid gray;">
                                    <label><b>
                                        Name2:</b></label>
                                    <span id="lblname2"></span>
                                    <br />
                                    <label><b>
                                        Designation:</b></label>
                                    <span id="lblDesgnation2"></span>
                                    <br />
                                    <label><b>
                                        Address :</b></label>
                                    <span id="lblAddress2"></span>

                                    <br />
                                    <label><b>
                                         Phone Number  :</b></label>
                                    <span id="lblnumbr2"></span>

                                    <br />
                                    <label><b>
                                        Cheque Number :</b></label>
                                    <span id="spnchqno2"></span>
                                </td>
                            </tr>
                        </table>
                        
                        </div>
                    </div>
                     
                     <b> Rupees in Words : </b>&nbsp;<span id="spnamttext" class="spanrpt"></span>

                     <br />
                       <br />
                     <br />
                     <table style="width: 100%;">
                   
                       
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold;" class="tdsize">Ref Employee1 Signature</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold;" class="tdsize">Ref Employee2 Signature</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold;" class="tdsize">Signature Loan Employee</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold;" class="tdsize">Head OF DEPT Signature</span>
                            </td>
                        </tr>
                    </table>

                      <br />
                       <br />
                     <br />
                   
                    <table style="width: 100%;">
                   
                       
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold;" class="tdsize">MANAGER</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold;" class="tdsize">GENERAL MANAGER</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold;" class="tdsize">DIRECTOR</span>
                            </td>
                        </tr>
                    </table>

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