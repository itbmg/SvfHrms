<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="EmployeeFullDetailesReport.aspx.cs" Inherits="EmployeeFullDetailesReport" %>

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

        function btn_Purchase_order_click() {
            var empid = document.getElementById('txtsupid').value;
            if (empid == "") {
                alert("Please enter empid");
                return false;
            }
            var data = { 'op': 'get_Loan_Request_details_click', 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        var employee_details = msg;
                        $('#divPrint').css('display', 'block');
                        //var employee_details = msg;
                        document.getElementById('lblEmpID').innerHTML = employee_details[0].employee_num;
                        document.getElementById('lblFathersName').innerHTML = employee_details[0].fathername;
                        document.getElementById('lblAdress').innerHTML = employee_details[0].presentaddress;
                        document.getElementById('lblperementaiddress').innerHTML = employee_details[0].home_address;
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
                        //fill_sub_Po_details(po_sub_details);
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Employee  Information Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Employee  Information Details </a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee  Information Details
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
                                    onclick="btn_Purchase_order_click()" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="divPrint" style="display: none;">
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
                        <span style="font-size: 26px; font-weight: bold;">Employee Information  Form </span>
                    </div>
                    <div style="width: 100%;">
                        <%-- <label>
                            To,</label>
                        --%>
                        <table style="width: 100%;">
                            <tr>
                             <td align="left">
                                    <span style="font-size: 16px; font-weight: bold;">personal Detailes </span>
                                    <br />
                                </td>
                                 <td align="center">
                                    <span style="font-size: 16px; font-weight: bold;">Qulifaction Detailes </span>
                                    <br />
                                </td>
                                  <td align="right">
                                    <span style="font-size: 16px; font-weight: bold;">Family Detailes </span>
                                    <br />
                                </td>
                                </tr>
                                <tr>
                                <%--<td style="width: 49%; float: left;">--%>
                                <td>
                                    <%--<span id="spnvendorname"></span>
                                    <br />
                                    --%>
                                    <label>
                                        Employee Code :</label>
                                    <span id="lblEmpID"></span>
                                    <br />
                                    </td>
                                    <td>
                                        <label>
                                            Qualification:</label>
                                        <span id="lblFathersName"></span>
                                        <br />
                                    </td>
                                      <td>
                                        <label>
                                           Family Member Name	:</label>
                                        <span id="Span1"></span>
                                        <br />
                                    </td>
                            </tr>
                            <tr>
                                <td style="width: 49%; float: left;">
                                    <label>
                                        DOB :</label>
                                    <span id="lblDOB"></span>
                                    <br />
                                </td>
                                <td>
                                    <label>
                                        	Institute :</label>
                                    <span id="lblSalaryPaydate"></span>
                                    <br />
                                </td>
                                 <td>
                                        <label>
                                           Relation	:</label>
                                        <span id="Span2"></span>
                                        <br />
                                    </td>
                            </tr>
                           
                            <tr>
                                <td style="width: 49%; float: left;">
                                    <label>
                                        Contact Number :</label>
                                    <span id="lblContactNumber"></span>
                                    <br />
                                </td>
                                <td>
                                    <label>
                                        	University :</label>
                                    <span id="lblDOB"></span>
                                    <br />
                                </td>
                                 <td>
                                        <label>
                                          Family Date Of Birth	:</label>
                                        <span id="Span3"></span>
                                        <br />
                                    </td>
                            </tr>
                             <tr>
                                <td style="width: 49%; float: left;">
                                    <label>
                                        Address :</label>
                                    <span id="lblAdress"></span>
                                    <br />
                                </td>
                                <td>
                                    <label>
                                        Permanent Address :</label>
                                    <span id="lblperementaiddress"></span>
                                    <br />
                                </td>
                                <td>
                                    <label>
                                        Bloodgroup :</label>
                                    <span id="Span4"></span>
                                    <br />
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 49%; float: left;">
                                    <label>
                                        Designation :</label>
                                    <span id="lblDesignation"></span>
                                    <br />
                                </td>
                                <td>
                                    <label>
                                        EDuration Of Course :</label>
                                    <span id="lblExprnceCompany"></span>
                                    <br />
                                </td>
                                <td>
                                    <label>
                                        Profession:</label>
                                    <span id="Span5"></span>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                      <label>
                                        Permanent Address :</label>
                                    <span id="lblperementaddriess"></span>
                                    <br />
                                </td>
                                <td>
                                    <label>
                                        Purpose of Loan :</label>
                                    <span id="lblPuposeloan"></span>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                       location :</label>
                                    <span id="lblAnyprivoesloan"></span>
                                    <br />
                                    </td>
                                    <td>
                                        <label>
                                            Loan amount :</label>
                                        <span id="lblLoanAmount"></span>
                                        <br />
                                    </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Gender :</label>
                                    <span id="lblLoanNomonth"></span>
                                    <br />
                                </td>
                                <td>
                                    <label>
                                        Starting month Of date :</label>
                                    <span id="lblstartmonthpdate"></span>
                                    <br />
                                </td>
                            </tr>
                           <%-- </table>
                            <table>--%>
                            <tr>
                                <td align="left">
                                    <span style="font-size: 16px; font-weight: bold;">Id Prrof </span>
                                    <br />
                                      <br />
                                </td>
                                 <td align="center">
                                    <span style="font-size: 16px; font-weight: bold;">Leave detailes </span>
                                    <br />
                                </td>
                                <td align="right">
                                    <span style="font-size: 16px; font-weight: bold;">Task detailes </span>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                       Type of Idproof :</label>
                                    <span id="lblname1"></span>
                                    <br />
                                </td>
                                <td>
                                    <label>
                                        Leave Type :</label>
                                    <span id="lblname2"></span>
                                    <br />
                                </td>
                                <td>
                                    <label>
                                        Assign Task :</label>
                                    <span id="Span6"></span>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Designation :</label>
                                    <span id="lblDesgnation1"></span>
                                    <br />
                                </td>
                                <td>
                                    <label>
                                        Totaly Leave Count :</label>
                                    <span id="lblDesgnation2"></span>
                                    <br />
                                </td>
                                <td>
                                    <label>
                                        Task detailes:</label>
                                    <span id="Span7"></span>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Addres1 :</label>
                                    <span id="lblAddress1"></span>
                                    <br />
                                </td>
                                <td>
                                    <label>
                                        Address :</label>
                                    <span id="lblAddress2"></span>
                                    <br />
                                </td>
                                 <td>
                                    <label>
                                        Date Of Finshing  :</label>
                                    <span id="Span8"></span>
                                    <br />
                                </td>
                            </tr>
                             <tr>
                                <td>
                                    <label>
                                        Loan EMI :</label>
                                    <span id="Spa_loanemi"></span>
                                    <br />
                                </td>
                            </tr>
                        </table>
                    </div>
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
                    </table>
                </div>
                <input id="Button2" type="button" class="btn btn-primary" name="submit" value='Print'
                    onclick="javascript:CallPrint('divPrint');" />
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
            </div>
        </div>
    </section>
</asp:Content>

