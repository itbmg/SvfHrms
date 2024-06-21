<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="EmployeeLoanApplication.aspx.cs" Inherits="EmployeeLoanApplication" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
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
            view_loan_details();
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
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        var employeedetails = [];
        function get_Employeedetails() {
            var data = { 'op': 'get_Employee_details' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var employee_name = msg[i].employee_name;
                        empnameList.push(employee_name);
                    }
                    $('#selct_employe').autocomplete({
                        source: empnameList,
                        change: employeenamechange,
                        autoFocus: true
                    });
                    $('#txt_reportingto').autocomplete({
                        source: empnameList,
                        change: reportingnamechange,
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
            var employee_name = document.getElementById('selct_employe').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (employee_name == employeedetails[i].employee_name) {
                    document.getElementById('txtsupid').value = employeedetails[i].empsno;
                }
            }
        }
        function reportingnamechange() {
            var employee_name = document.getElementById('txt_reportingto').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (employee_name == employeedetails[i].employee_name) {
                    document.getElementById('txtrepid').value = employeedetails[i].empsno;
                    document.getElementById('txt_phone').value = employeedetails[i].cellphone;
                    document.getElementById('txt_email').value = employeedetails[i].email;
                }
            }
        }
        function get_radio_value() {
            var inputs = document.getElementsByName("gen_radio");
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].checked) {
                    return inputs[i].value;
                }
            }
        }
        function save_Loan_Request_click() {
            var employename = document.getElementById('selct_employe').value;
            if (employename == "") {
                alert("Select Employee name ");
                return false;
            }
            var employeid = document.getElementById('txtsupid').value;

            var loanamount = document.getElementById('txt_amount').value;
            if (loanamount == "") {
                alert("Enter Loan Amount");
                return false;
            }
            var loanpurpose = document.getElementById('txt_purposeofloan').value; txt_email

            var reportingtoid = document.getElementById('txtrepid').value;
            if (reportingtoid == "") {
                alert("Enter Loan Amount");
                return false;
            }
            var phone = document.getElementById('txt_phone').value;
            var email = document.getElementById('txt_email').value;
            var preveousloan = get_radio_value();
            var btnval = document.getElementById('btn_save').value;

            var data = { 'op': 'save_emp_Loan_Request', 'employeid': employeid, 'employename': employename, 'loanamount': loanamount, 'loanpurpose': loanpurpose, 'reportingtoid': reportingtoid, 'phone': phone, 'email': email, 'preveousloan': preveousloan, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert("Employee Loan details successfully added");
                        forclearall();
                        view_loan_details();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function view_loan_details() {
            var data = { 'op': 'get_emp_loan_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        emp_loan_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function emp_loan_details(msg) {
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table  id="example2" class="table table-bordered table-hover "role="grid" aria-describedby="example2_info">';
            results += '<thead><tr style="background-color:white; font-size: 12px;" role="row"><th scope="col"></th><th scope="col" style="text-align:  center;">Sno</th><th scope="col" style="text-align:  center;">Employee Name</th><th scope="col" style="text-align:  center;">Branch Name</th><th scope="col" style="text-align:  center;">Designation</th><th scope="col" style="text-align:  center;">Loan Amount</th><th scope="col" style="text-align:  center;" >Purpose</th><th scope="col" style="text-align:  center;" >Reporting To</th><th scope="col" style="text-align:  center;">Previous Loan</th><th scope="col" style="text-align:  center;">Date Of Entry</th><th scope="col" style="text-align:  center;"></th></tr></thead></tbody>';
            var l = 0;
            var totloanamount = 0;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td> <button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="color: #68d2ec; border-color: #00acd6;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;"  onclick="getmeprint(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
                results += '<td style="text-align:  center;">' + k++ + '</td>';
                results += '<th  class="1" style="text-align:  center;">' + msg[i].fullname + '</th>';
                results += '<th  class="2" style="Display:  none;">' + msg[i].empid + '</th>';
                results += '<th  class="3" style="text-align:  center;">' + msg[i].branchname + '</th>';
                results += '<td  class="4" style="text-align:  center;">' + msg[i].designation + '</td>';
                results += '<td  class="5" style="text-align:  center;">' + msg[i].LoanAmount + '</td>';
                results += '<td  class="6" style="text-align:  center;">' + msg[i].PurposeOfLoan + '</td>';
                results += '<th  class="7" style="Display:  none;">' + msg[i].reportingtoid + '</th>';
                results += '<td  class="8" style="text-align:  center;">' + msg[i].ReportingTo + '</td>';
                results += '<td  class="9" style="text-align:  center;">' + msg[i].Doe + '</td>';
                results += '<td  class="10" style="text-align:  center;">' + msg[i].PreviousLoans + '</td>';
                results += '<td style="text-align: center;"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme_upadate(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></td>';

                results += '</tr>';
                var loanamount = parseFloat(msg[i].LoanAmount) || 0;
                totloanamount += loanamount;
            }
            results += '<tr style="color:  red;background: aquamarine;">';
            results += '<th  scope="row"  ></th>';
            results += '<th  scope="row"  ></th>';
            results += '<th  scope="row"  style="text-align:  center;">' + "Grand Total" + '</th>';
            results += '<th  scope="row"  ></th>';
            results += '<th  scope="row"  ></th>';
            results += '<td  scope="row"  style="text-align:  center;">' + totloanamount + '</td>';
            results += '<th  scope="row"  ></th>';
            results += '<th  scope="row"  ></th>';
            results += '<th  scope="row"  ></th>';
            results += '<th  scope="row"  ></th>';
            results += '<th  scope="row"  ></th>';
            results += '</tr>';
            results += '</table></div>';
            $("#div_grid").html(results);
        }
        function getme_upadate(thisid) {
            var fullname = $(thisid).parent().parent().children('.1').html();
            var empid = $(thisid).parent().parent().children('.2').html();
            var branchname = $(thisid).parent().parent().children('.3').html();
            var designation = $(thisid).parent().parent().children('.4').html();
            var LoanAmount = $(thisid).parent().parent().children('.5').html();
            var PurposeOfLoan = $(thisid).parent().parent().children('.6').html();
            var reportingtoid = $(thisid).parent().parent().children('.7').html();
            var ReportingTo = $(thisid).parent().parent().children('.8').html();
            var Doe = $(thisid).parent().parent().children('.9').html();
            var PreviousLoans = $(thisid).parent().parent().children('.10').html();


            document.getElementById('selct_employe').value = fullname;
            document.getElementById('txtsupid').value = empid;
            document.getElementById('txt_amount').value = LoanAmount;
            document.getElementById('txt_purposeofloan').value = PurposeOfLoan;
            document.getElementById('txt_reportingto').value = ReportingTo;
            document.getElementById('txtrepid').value = reportingtoid;
//            document.getElementById('get_radio_value').checked = PreviousLoans;
            document.getElementById('btn_save').value = "Modify";
            $('#btn_upload_document').focus();
        }
        function getmeprint(thisid) {
            $('#myModal').css('display', 'block');
            $('#divPrints').css('display', 'block');
            var fullname = $(thisid).parent().parent().children('.1').html();
            var empid = $(thisid).parent().parent().children('.2').html();
            var branchname = $(thisid).parent().parent().children('.3').html();
            var designation = $(thisid).parent().parent().children('.4').html();
            var LoanAmount = $(thisid).parent().parent().children('.5').html();
            var PurposeOfLoan = $(thisid).parent().parent().children('.6').html();
            var ReportingTo = $(thisid).parent().parent().children('.8').html();
            var Doe = $(thisid).parent().parent().children('.9').html();
            var PreviousLoans = $(thisid).parent().parent().children('.10').html();


            document.getElementById('lblempname').innerHTML = fullname;
            document.getElementById('lblempid').innerHTML = empid;
            document.getElementById('lbl_branch').innerHTML = branchname;
            document.getElementById('lbl_designation').innerHTML = designation;
            document.getElementById('lbl_amount').innerHTML = LoanAmount;
            document.getElementById('lbl_reportingto').innerHTML = ReportingTo;
            document.getElementById('lbl_preloan').innerHTML = PreviousLoans;
            document.getElementById('lbl_purpose').innerHTML = PurposeOfLoan;
            document.getElementById('lbl_doe').innerHTML = Doe;
//            document.getElementById('lblbrnch').innerHTML = PreviousLoans;
        }
        function closepopup(msg) {
            $("#myModal").css("display", "none");
        }

        function forclearall() {
            document.getElementById('selct_employe').value = "";
            document.getElementById('txt_amount').value = "";
            document.getElementById('txt_purposeofloan').value = "";
            document.getElementById('txt_reportingto').value = "";
            document.getElementById('gndr_radio1').checked = false;
            document.getElementById('gndr_radio2').checked = true;
            document.getElementById('btn_save').value = "Request";
        }
        </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
           LoanApplication <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Loan Application master</a></li>
        </ol>
    </section>
    <section class="content">
    <div id="div_Documents" class="box box-danger">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-user-plus"></i>Employee Loan Aoolication
                </h3>
                 </div>
                   <div class="box-body">
                <div class="row-fluid">
                    <div>
                        <table id="tbl_leavemanagement" align="center">
                            <tr>
                                <td style="width: 45%;">
                                 <label class="control-label">
                                    Employee Name
                                    </label>
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="selct_employe" placeholder="Enter employee name" />
                                </td>
                                <td>
                                    <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                                </td>
                            </tr>
                            <tr>
                            <td>
                            <br />
                            </td>
                            </tr>
                            <tr>
                                <td>
                                <label class="control-label">
                                   Loan Amount
                                    </label>
                                </td>
                                <td style="width: 200px;">
                                    <input type="text" class="form-control" id="txt_amount" placeholder="Enter Loan Amounnt" onkeypress="return isNumber(event);" />
                                   
                                </td>
                              </tr>
                             <tr>
                            <td>
                            <br />
                            </td>
                            </tr>
                              <tr>
                                <td>
                                <label class="control-label">
                                    Purpose of Loan
                                    </label>
                                </td>
                                <td style="height: 40px;">
                                 <textarea id="txt_purposeofloan" type="text" class="form-control" name="Remarks" placeholder="Enter Purpose of Loan"></textarea>
                                </td>
                                </tr>
                                <tr>
                            <td>
                            <br />
                            </td>
                            </tr>
                            <tr>
                                <td style="width: 45%;">
                                 <label class="control-label">
                                    Reporting To
                                    </label>
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="txt_reportingto" placeholder="Enter employee name" />
                                </td>
                                <td>
                                    <input id="txt_phone" type="hidden" class="form-control" name="hiddenempid" />
                                    <input id="txt_email" type="hidden" class="form-control" name="hiddenempid" />
                                    <input id="txtrepid" type="hidden" class="form-control" name="hiddenempid" />
                                </td>
                            </tr>
                              <tr>
                            <td>
                            <br />
                            </td>
                            </tr>
                                <tr>
                             <td> 
                             <label class="control-label">
                             Any Previous Loan
                             </label>
                             </td>
                             <td>
                              <input id="gndr_radio1" type="radio" name="gen_radio" value="Yes"  />
                             Yes
                            <input id="gndr_radio2" type="radio" name="gen_radio" value="No" checked="true" />
                             No
                             </td>
                             </tr>
                        </table>
                        </div>
                            <br />
                          <div>
                         <table align="center">
                            <tr>
                               <td>
                                    <input type="button" class="btn btn-primary" id="btn_save" value="Request" onclick="save_Loan_Request_click();" />
                                    <input type="button" class="btn btn-danger" id="close_id" value="Close" onclick="forclearall();" />
                              </td>
                           </tr>
                        </table>
                    </div>
                    <br />
                    <div id="div_grid">
                    </div>
                    <div class="modal" id="myModal" role="dialog" style="overflow:auto;">
    <div class="modal-dialog">
      <!-- Modal content-->
     
      <div class="modal-content">
        <div class="modal-header" >
        
         
        </div>
        <div class="modal-body">
           <div id="divPrints" style="display:none">
                    <div style="width: 23%; float: right;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
                    <br />
                    <div>
                        <div align="center"  style="font-family: Arial; font-size: 18pt; font-weight: bold; color: Black;">
                            <span>Sri Vyshnavi Foods Pvt Ltd </span>
                            <br />
                        </div>
                        <span style="text-align:center; padding-left:5%;">
                        Survey No.381-2, Punabaka (V), Pellakur (M), SPSR Nellore Dt - 524129.</span>
                         <span style="text-align:center; padding-left:19%;">Phone: 9440622077, Fax: 044 – 26177799.</span>
                    </div>
                    <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                        <span style="font-size: 26px; font-weight: bold;"><u>Loan Form </u></span>
                    </div>
                    <div style="width: 100%;">
                        <table style="width: 100%;">
                        <tr>

                                <td style="float: left;padding-left: 30%;">
                                  <label class="control-label" >
                                        Emp ID :</label>
                                    <span id="lblempid"></span>
                                    <br />
                                </td>
                                <td colspan="3">
                                </td>
                                     <td style="float: right;padding-right: 10%;">
                                    <label class="control-label" >
                                        Date Of Entry :</label>
                                    <span id="lbl_doe"></span>
                                    <br />
                                </td>

                        </tr>
                        </table>
                        <table style="width: 100%;">
                        <tr>
                        <td style="height:15px;"></td>
                        </tr>
                            <tr>
                              <td colspan="3"><label class="control-label" >
                                       <b>Name :</b> </label>
                                    <span id="lblempname"></span></td>
                                <td >
                                    <label class="control-label" >
                                      <b>Branch :</b>  </label>
                                    <span id="lbl_branch"></span>
                                    </td>
                                    </tr>
                                    <tr>
                                    <td td colspan="3">
                                 <label class="control-label" >
                                       <b>Designation:</b> </label>
                                    <span id="lbl_designation"></span>
                                    </td>
                                <td>
                                    <label class="control-label" >
                                      <b> Loan Amounrt :</b></label>
                                    <span id="lbl_amount"></span>
                                    <br />
                                </td>
                                </tr>
                                <tr>
                                    <td td colspan="3">
                                    <label class="control-label" >
                                       <b>Reporting TO :</b></label>
                                    <span id="lbl_reportingto"></span>
                                    <br />
                                </td>
                              <td colspan="2">
                                       <label class="control-label" >
                                             <b>Previous Loan :</b></label>
                                        <span id="lbl_preloan"></span>
                                        <br />
                                    </td>
                                    </tr>
                                    <tr>
                                    <td colspan="3">
                                       <label class="control-label" >
                                             <b>Purpose :</b></label>
                                        <span id="lbl_purpose"></span>
                                        <br />
                                    </td>
                             </tr>
                           <tr>
                           </tr>
                        </table>
                    </div>
                    <br />
                    <br />
                     
                     <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 13px;">Employee Sig </span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 13px;">Dept Head  </span>
                            </td>
                            <td style="width: 19%;">
                                <span style="font-weight: bold; font-size: 13px;">H.R.D</span>
                            </td>
                              <td style="width: 19%;">
                                <span style="font-weight: bold; font-size: 12px;">Manager</span>
                            </td>
                              <td style="width: 27%;">
                                <span style="font-weight: bold; font-size: 12px;">Authorised By</span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />                   
                </div>
                
                <asp:Label ID="Label2" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
        </div>
        <div class="modal-footer">
         <input id="Button3" type="button" class="btn btn-primary" name="submit" value='Print'
                    onclick="javascript:CallPrint('divPrints');" />
          <button type="button" class="btn btn-default" id="close" onclick="closepopup();">Close</button>
        </div>
      </div>
      
    </div>
  </div>
                 </div>
              </div>
           </div>
      </section>
</asp:Content>

