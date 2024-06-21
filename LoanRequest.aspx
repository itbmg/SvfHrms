<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="LoanRequest.aspx.cs" Inherits="LoanRequest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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
            get_LoanRequest_Details();
            $("#divloandata").css("display", "block");
            $("#div_body").css("display", "block");
            $("#div_loanrequest").css("display", "none");
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txt_salarydate').val(today);
            $('#txt_startdate').val(today);
        });
        $(document).keyup(function (e) {
            if (e.keyCode === 27) {
                closepopup(btn_closepopup);
            }
        });
        function closepopup() {
            forclearall();
            $("#divloandata").css("display", "block"); 
            $("#svds_empdetails").css("display", "none");
            $("#loanbuttn").css("display", "block");
        }
        function showloanentry() {
            forclearall();
            $("#divloandata").css("display", "none");
            $("#div_loanrequest").css("display", "block");
            $("#loanbuttn").css("display", "none");
        }
        function closeloanentry() {
            forclearall();
            $("#divloandata").css("display", "block");
            $("#div_loanrequest").css("display", "none");
            $("#loanbuttn").css("display", "block");
        }
        function show_loanrequestdetails() {
            $("#div_approval").css("display", "none");
            $("#div_loanrequest").css("display", "none");
            $("#div_body").css("display", "block");
            $("#divloandata").css("display", "block");
            $("#fillgrid_rejected").css("display", "none");
            $("#loanbuttn").css("display", "block");
            get_Employeedetails();
            get_LoanRequest_Details();
        }

        function show_Approveloan() {
            $("#div_approval").css("display", "block");
            $("#fillGrid_approved").css("display", "block");
            $("#divloandata").css("display", "none");
            $("#div_loanrequest").css("display", "none");
            $("#fillgrid_rejected").css("display", "none");
            $("#loanbuttn").css("display", "none");
            $("#div_body").css("display", "none");
            get_LoanRequestApprovalDetails();
        }
        function show_rejectedloan() {
            $("#div_approval").css("display", "none");
            $("#fillGrid_approved").css("display", "none");
            $("#fillgrid_rejected").css("display", "block");
            $("#divloandata").css("display", "none");
            $("#div_loanrequest").css("display", "none");
            $("#loanbuttn").css("display", "none");
            $("#div_body").css("display", "none");

            get_LoanRequestRejectDetails();
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
                    $('#txt_empREF1name').autocomplete({
                        source: empnameList,
                        change: refemployeenamechange,
                        autoFocus: true
                    });
                    $('#txt_empREF2name').autocomplete({
                        source: empnameList,
                        change: refemployeenamechange1,
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
                    document.getElementById('txtAddress').innerHTML = employeedetails[i].presentaddress;
                    document.getElementById('txt_Permentadress').innerHTML = employeedetails[i].address;
                    document.getElementById('SpanDesigination').innerHTML = employeedetails[i].designation;
                    document.getElementById('txt_Contactnumber').innerHTML = employeedetails[i].cellphone;
                    document.getElementById('txt_Fathername').value = employeedetails[i].fathername;
                    document.getElementById('txt_Dob').innerHTML = employeedetails[i].dob;
                    document.getElementById('txt_Age').value = employeedetails[i].age;
                    //                get_loan_fill_Details();
                }
            }
        }

        function refemployeenamechange() {
            var employee_name = document.getElementById('txt_empREF1name').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (employee_name == employeedetails[i].employee_name) {
                    document.getElementById('txt_Refrencemp1').value = employeedetails[i].empsno;
                    document.getElementById('txt_emp1deg').innerHTML = employeedetails[i].designation;
                    document.getElementById('txt_emp1Address').innerHTML = employeedetails[i].address;
                    document.getElementById('txt_emp1Moble').innerHTML = employeedetails[i].cellphone;
                }
            }
        }
        function refemployeenamechange1() {
            var employee_name = document.getElementById('txt_empREF2name').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (employee_name == employeedetails[i].employee_name) {
                    document.getElementById('txt_Refrencemp2').value = employeedetails[i].empsno;
                    document.getElementById('txt_emp2deg').innerHTML = employeedetails[i].designation;
                    document.getElementById('txt_emp2Moble').innerHTML = employeedetails[i].cellphone;
                    document.getElementById('txt_emp2Address').innerHTML = employeedetails[i].address;
                }
            }
        }

        function save_Loan_Request_click() {
            var employeid = document.getElementById('txtsupid').value;
            if (employeid == "") {
                alert("Select Employee name ");
                return false;
            }
            var fathername = document.getElementById('txt_Fathername').value;
            var experience = document.getElementById('txt_experince').value;
            var age = document.getElementById('txt_Age').value;
            var salarydate = document.getElementById('txt_salarydate').value;
            var purpose_of_loan = document.getElementById('txt_purposeofloan').value;
            if (purpose_of_loan == "") {
                alert("Enter purpose of loan ");
                return false;
            }
            var previousloan = document.getElementById('txt_Anypreviousloan').value;
            var loanamount = document.getElementById('txt_LoanAmount').value;
            if (loanamount == "") {
                alert("Enter loan Amount");
                return false;
            }
            var loanemi = document.getElementById('txt_EMI').value;
            var months = document.getElementById('txt_LoanRecovermonth').value;
            var refemp1 = document.getElementById('txt_Refrencemp1').value;
            if (refemp1 == "") {
                alert("Select REf name ");
                return false;
            }
            var refemp2 = document.getElementById('txt_Refrencemp2').value;
            if (refemp2 == "") {
                alert("Select REf2 name ");
                return false;
            }
            var Cheque1 = document.getElementById('txt_cheq1').value;
            var Cheque2 = document.getElementById('txt_cheq2').value;
            var startdate = document.getElementById('txt_startdate').value;
            var btnval = document.getElementById('btn_save').value;
            var data = { 'op': 'save_Loan_Request_click', 'employeid': employeid, 'refemp2': refemp2, 'experience': experience, 'fathername': fathername, 'age': age, 'salarydate': salarydate, 'purpose_of_loan': purpose_of_loan, 'previousloan': previousloan, 'loanamount': loanamount, 'months': months, 'refemp1': refemp1, 'startdate': startdate, 'loanemi': loanemi, 'Cheque1': Cheque1, 'Cheque2': Cheque2, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert("Employee Loan details successfully added");
                        forclearall();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function forclearall() {
            document.getElementById('selct_employe').value = "";
            document.getElementById('txt_Fathername').value = "";
            document.getElementById('txt_experince').value = "";
            document.getElementById('txt_Age').value = "";
            document.getElementById('txt_salarydate').value = "";
            document.getElementById('txt_purposeofloan').value = "";
            document.getElementById('txt_Anypreviousloan').value = "";
            document.getElementById('txt_LoanAmount').value = "";
            document.getElementById('txt_LoanRecovermonth').value = "";
            document.getElementById('txt_EMI').value = "";
            document.getElementById('txt_empREF1name').value = "";
            document.getElementById('txt_emp1deg').innerHTML = "";
            document.getElementById('txt_emp1Moble').innerHTML = "";
            document.getElementById('txt_empREF2name').value = "";
            document.getElementById('txt_emp2deg').innerHTML = "";
            document.getElementById('txt_emp2Moble').innerHTML = "";
            document.getElementById('txt_emp1Address').innerHTML = "";
            document.getElementById('txt_emp2Address').innerHTML = "";
            document.getElementById('txtsupid').innerHTML = "";
            document.getElementById('txtAddress').innerHTML = "";
            document.getElementById('txt_Permentadress').innerHTML = "";
            document.getElementById('SpanDesigination').innerHTML = "";
            document.getElementById('txt_Dob').innerHTML = "";
            document.getElementById('txt_Contactnumber').innerHTML = "";
            document.getElementById('txt_startdate').value = "";
            document.getElementById('txt_cheq1').value = "";
            document.getElementById('txt_cheq2').value = "";
            document.getElementById('btn_save').value = "Save";
        }


        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }


        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
        }

        function get_LoanRequest_Details() {
            var status = "P";
            var data = { 'op': 'get_LoanRequest_Details', 'status': status };
            var s = function (msg) {
                if (msg) {
                    fillresignation(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var leveltype = '<%=Session["leveltype"] %>';
        if (leveltype == "Admin" || leveltype == "SuperAdmin" || leveltype == "manager") {
            function fillresignation(msg) {
                var k = 1;
                var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                results += '<thead><tr></th></th><th scope="col">Sno</th><th scope="col">Employee Name</th><th scope="col">EmployeeCode</th><th scope="col">BranchName</th><th scope="col">Designation</th><th scope="col">DOE</th><th scope="col">Purpose of Loan</th><th scope="col">Loan amount</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < msg.length; i++) {
                    results += '<tr><td >' + k++ + '</td>';
                    results += '<th scope="row"  class="1" style="text-align:  center;"><span id="spninqty"  onclick="view_loanreq_details(this);"><i class="fa fa-arrow-circle-right" style="width: 22px;" aria-hidden="true"></i><span style="text-decoration: none;">' + msg[i].fullname + '</th>';
                    results += '<td  class="2">' + msg[i].Empcode + '</td>';
                    results += '<td  class="2">' + msg[i].branchname + '</td>';
                    results += '<td  class="2">' + msg[i].designation + '</td>';
                    results += '<td  class="3">' + msg[i].dateofentry + '</td>';
                    results += '<td  class="5">' + msg[i].purpose_of_loan + '</td>';
                    results += '<td class="4">' + msg[i].loanamount + '</td>';
                    results += '<td><input id="btn_poplate" type="button" name="submit" class="btn btn-primary" onclick="save_loanrequest_approve_click(this);" value="Approval" /></td><td><input id="btn_poplate" type="button"  onclick="save_loanrequest_reject_click(this)" name="submit" class="btn btn-danger" value="Reject" /></td>';
                    results += '<td style="display:none" class="7">' + msg[i].status + '</td>';
                    results += '<td style="display:none" class="6">' + msg[i].sno + '</td>';
                    results += '<td style="display:none" class="8">' + msg[i].empid + '</td></tr>';
                }
                results += '</table></div>';
                $("#divloandata").html(results);
            }
        }
        else {
            function fillresignation(msg) {
                var k = 1;
                var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                results += '<thead><tr></th></th><th scope="col">Sno</th><th scope="col">Employee Name</th><th scope="col">EmployeeCode</th><th scope="col">BranchName</th><th scope="col">Designation</th><th scope="col">DOE</th><th scope="col">Purpose of Loan</th><th scope="col">Loan amount</th></tr></thead></tbody>';
                for (var i = 0; i < msg.length; i++) {
                    results += '<tr><td >' + k++ + '</td>';
                    results += '<th scope="row"  class="1" style="text-align:  center;"><span id="spninqty"  onclick="view_loanreq_details(this);"><i class="fa fa-arrow-circle-right" style="width: 22px;" aria-hidden="true"></i><span style="text-decoration: none;">' + msg[i].fullname + '</th>';
                    results += '<td  class="2">' + msg[i].Empcode + '</td>';
                    results += '<td  class="2">' + msg[i].branchname + '</td>';
                    results += '<td  class="2">' + msg[i].designation + '</td>';
                    results += '<td  class="3">' + msg[i].dateofentry + '</td>';
                    results += '<td  class="5">' + msg[i].purpose_of_loan + '</td>';
                    results += '<td class="4">' + msg[i].loanamount + '</td>';
                    results += '<td style="display:none" class="7">' + msg[i].status + '</td>';
                    results += '<td style="display:none" class="6">' + msg[i].sno + '</td>';
                    results += '<td style="display:none" class="8">' + msg[i].empid + '</td></tr>';
                }
                results += '</table></div>';
                $("#divloandata").html(results);
            }
        }

        function get_LoanRequestApprovalDetails() {
            var status = "A";
            var data = { 'op': 'get_LoanRequest_Details', 'status': status };
            var s = function (msg) {
                if (msg) {
                    fillloanapproval_details(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
                var leveltype = '<%=Session["leveltype"] %>';
                if (leveltype == "Admin" || leveltype == "SuperAdmin" || leveltype == "manager") {
                    function fillloanapproval_details(msg) {
                        $('#fillGrid_approved').empty();
                        var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                        results += '<thead><tr></th></th><th scope="col">Employee Name</th><th scope="col">EmployeeCode</th><th scope="col">BranchName</th><th scope="col">Designation</th><th scope="col">DOE</th><th scope="col">Purpose of Loan</th><th scope="col">Loan amount</th><th scope="col">Status</th><th scope="col"></th></tr></thead></tbody>';
                        for (var i = 0; i < msg.length; i++) {
                            results += '<tr><th scope="row" class="1" style="text-align:center;">' + msg[i].fullname + '</th>';
                            results += '<td  class="2">' + msg[i].Empcode + '</td>';
                            results += '<td  class="2">' + msg[i].branchname + '</td>';
                            results += '<td  class="2">' + msg[i].designation + '</td>';
                            results += '<td  class="3">' + msg[i].dateofentry + '</td>';
                            results += '<td  class="5">' + msg[i].purpose_of_loan + '</td>';
                            results += '<td  class="4">' + msg[i].loanamount + '</td>';
                            results += '<td  class="7">' + msg[i].status + '</td>';
                            results += '<td><input id="btn_poplate" type="button"  onclick="save_loanrequest_reject_click(this)" name="submit" class="btn btn-danger" value="Reject" /></td>';
                            results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
                        }
                        results += '</table></div>';
                        $("#fillGrid_approved").html(results);
                    }
                }
                else {
                    function fillloanapproval_details(msg) {
                        $('#fillGrid_approved').empty();
                        var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                        results += '<thead><tr></th></th><th scope="col">Employee Name</th><th scope="col">EmployeeCode</th><th scope="col">BranchName</th><th scope="col">Designation</th><th scope="col">DOE</th><th scope="col">Purpose of Loan</th><th scope="col">Loan amount</th><th scope="col">Status</th></tr></thead></tbody>';
                        for (var i = 0; i < msg.length; i++) {
                            results += '<tr><th scope="row" class="1" style="text-align:center;">' + msg[i].fullname + '</th>';
                            results += '<td  class="2">' + msg[i].Empcode + '</td>';
                            results += '<td  class="2">' + msg[i].branchname + '</td>';
                            results += '<td  class="2">' + msg[i].designation + '</td>';
                            results += '<td  class="3">' + msg[i].dateofentry + '</td>';
                            results += '<td  class="5">' + msg[i].purpose_of_loan + '</td>';
                            results += '<td  class="4">' + msg[i].loanamount + '</td>';
                            results += '<td  class="7">' + msg[i].status + '</td>';
                            results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
                        }
                        results += '</table></div>';
                        $("#fillGrid_approved").html(results);
                    }
                }
                function get_LoanRequestRejectDetails() {
                    var status = "R";
                    var data = { 'op': 'get_LoanRequest_Details', 'status': status };
                    var s = function (msg) {
                        if (msg) {
                            fillloanreject_details(msg);
                        }
                        else {
                        }
                    };
                    var e = function (x, h, e) {
                    };
                    $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
                    callHandler(data, s, e);
                }
                        var leveltype = '<%=Session["leveltype"] %>';
                        if (leveltype == "Admin" || leveltype == "SuperAdmin" || leveltype == "manager") {
                            function fillloanreject_details(msg) {
                                var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                                results += '<thead><tr></th></th><th scope="col">Employee Name</th><th scope="col">EmployeeCode</th><th scope="col">BranchName</th><th scope="col">Designation</th><th scope="col">DOE</th><th scope="col">Purpose of Loan</th><th scope="col">Loan amount</th><th scope="col">Status</th><th scope="col"></th></tr></thead></tbody>';
                                for (var i = 0; i < msg.length; i++) {
                                    results += '<tr><th scope="row" class="1" style="text-align:center;">' + msg[i].fullname + '</th>';
                                    results += '<td  class="2">' + msg[i].Empcode + '</td>';
                                    results += '<td  class="2">' + msg[i].branchname + '</td>';
                                    results += '<td  class="2">' + msg[i].designation + '</td>';
                                    results += '<td  class="3">' + msg[i].dateofentry + '</td>';
                                    results += '<td  class="5">' + msg[i].purpose_of_loan + '</td>';
                                    results += '<td  class="4">' + msg[i].loanamount + '</td>';
                                    results += '<td  class="7">' + msg[i].status + '</td>';
                                    results += '<td><input id="btn_poplate" type="button" name="submit" class="btn btn-primary" onclick="save_loanrequest_approve_click(this);" value="Approval" /></td>';
                                    results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
                                }
                                results += '</table></div>';
                                $("#fillgrid_rejected").html(results);
                            }
                            function CloseClick() {
                                $('#divMainAddNewRow').css('display', 'none');
                            }
                        }
                        else {
                            function fillloanreject_details(msg) {
                                var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                                results += '<thead><tr></th></th><th scope="col">Employee Name</th><th scope="col">EmployeeCode</th><th scope="col">BranchName</th><th scope="col">Designation</th><th scope="col">DOE</th><th scope="col">Purpose of Loan</th><th scope="col">Loan amount</th><th scope="col">Status</th></tr></thead></tbody>';
                                for (var i = 0; i < msg.length; i++) {
                                    results += '<tr><th scope="row" class="1" style="text-align:center;">' + msg[i].fullname + '</th>';
                                    results += '<td  class="2">' + msg[i].Empcode + '</td>';
                                    results += '<td  class="2">' + msg[i].branchname + '</td>';
                                    results += '<td  class="2">' + msg[i].designation + '</td>';
                                    results += '<td  class="3">' + msg[i].dateofentry + '</td>';
                                    results += '<td  class="5">' + msg[i].purpose_of_loan + '</td>';
                                    results += '<td  class="4">' + msg[i].loanamount + '</td>';
                                    results += '<td  class="7">' + msg[i].status + '</td>';
                                    results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
                                }
                                results += '</table></div>';
                                $("#fillgrid_rejected").html(results);
                            }
                            function CloseClick() {
                                $('#divMainAddNewRow').css('display', 'none');
                            }
                        }
//        var sno = 0;
//        function getme(thisid) {
//            $('#divMainAddNewRow').css('display', 'block');
//            var fullname = $(thisid).parent().parent().children('.1').html();
//            var designation = $(thisid).parent().parent().children('.2').html();
//            var joindate = $(thisid).parent().parent().children('.3').html();
//            var purpose_of_loan = $(thisid).parent().parent().children('.5').html();
//            var loanamount = $(thisid).parent().parent().children('.4').html();
//            sno = $(thisid).parent().parent().children('.6').html();
//            var status = $(thisid).parent().parent().children('.7').html();
//        }

        function save_loanrequest_reject_click(thisid) {
            sno = $(thisid).parent().parent().children('.6').html();
            var data = { 'op': 'save_loanrequest_reject_click', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    $('#divMainAddNewRow').css('display', 'none');
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function save_loanrequest_approve_click(thisid) {
            sno = $(thisid).parent().parent().children('.6').html();
            var data = { 'op': 'save_loanrequest_approve_click', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        //test
        function view_loanreq_details(thisid) {
            var empid = $(thisid).parent().parent().children('.8').html();
            var data = { 'op': 'get_Loan_Request_details_click', 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        var employee_details = msg;
                        $('#divPrint').css('display', 'block');
                        $('#svds_empdetails').css('display', 'block');
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
                        document.getElementById('spnamttext').innerHTML = employee_details[0].loanamount;

                        //                        var loanamt = employee_details[0].loanamount;

                        //                        document.getElementById('spnamttext').innerHTML = inWords(parseInt(loanamt));
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

        function CloseClick() {
            $('#divMainAddNewRow').css('display', 'none');
        }




    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Emplolyee Loan Request Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Employee Loan Request Details</a></li>
        </ol>
    </section>
    <section class="content">
    <div class="box box-info" style="margin-bottom:0px">
                    <ul class="nav nav-tabs">
                        <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="show_loanrequestdetails()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;Loan Request Details</a></li>
                        <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="show_Approveloan()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Approval Details</a></li>

                        <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="show_rejectedloan()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Rejected Details</a></li>
                    </ul>
                </div>
        <div class="box box-info">
        <br />
    <div id="div_body" style="display:none;">
        <div id="loanbuttn">
         <div class="input-group" style="padding-left:85%;">
                                <div class="input-group-addon" style="border-color: #3c8dbc;background-color: #3c8dbc;border-radius: 4px;color: whitesmoke;">
                                <span class="glyphicon glyphicon-plus-sign"  ></span> <span onclick="showloanentry()">Add Loan Details</span>
                          </div>
                          </div>
                          </div>
        <div id="divloandata" style="display:none;">
        </div> 

        <div id="div_loanrequest">
            <div class="box-header with-border">


                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Emplolyee Loan Request Details
                </h3>
            </div>
            <div class="box-body">
                <div class="row-fluid">
                    <div>
                        <table id="tbl_leavemanagement" align="center">
                            <tr>
                                <td>
                                 <label class="control-label">
                                    Employee Name
                                    </label>
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="selct_employe" placeholder="Enter employee name"
                                        onkeypress="return ValidateAlpha(event);" />
                                </td>
                                <td>
                                    <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                 <label class="control-label">
                                    Father Name
                                    </label>
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="txt_Fathername" placeholder="Enter Father Name"
                                        onkeypress="return ValidateAlpha(event);" />
                                </td>
                                <td>
                                 <label class="control-label">
                                    Age
                                    </label>
                                </td>
                                <td style="height: 40px;">
                                    <input type="text" class="form-control" id="txt_Age" placeholder="Enter employee Age"
                                        onkeypress="return isNumber(event)" />
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    <label class="control-label">
                                Address : 
                                </label>
                                </td>
                                <td style="width: 200px;">
                                    <span id="txtAddress" />
                                </td>
                                <td style="height: 40px;">
                                   <label class="control-label">
                               Permanent Address:
                               </label>
                                </td>
                                <td style="width: 200px;">
                                    <span id="txt_Permentadress" />
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                   <label class="control-label">
                               Contact Number:
                               </label>
                                </td>
                                <td style="width: 200px;">
                                    <span id="txt_Contactnumber" onkeypress="return isNumber(event)" />
                                </td>
                                <td>
                                  <label class="control-label">
                               DOB:
                               </label>
                                </td>
                                <td style="width: 200px;">
                                    <span id="txt_Dob" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                 <label class="control-label">
                               Designation:
                             </label>
                                </td>
                                <td style="width: 200px;">
                                    <span id="SpanDesigination" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                <label class="control-label">
                                    Experience in the company
                                    </label>
                                </td>
                                <td style="width: 200px;">
                                    <input type="text" class="form-control" id="txt_experince" placeholder="Enter Experience   " />
                                </td>
                                <td>
                                <label class="control-label">
                                    Salary paid as on date
                                    </label>
                                </td>
                                <td style="height: 40px;">
                                    <input type="date" class="form-control" id="txt_salarydate" placeholder="Enter Salary paid as on date" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                <label class="control-label">
                                    Purpose of Loan
                                    </label>
                                </td>
                                <td style="height: 40px;">
                                    <input type="text" class="form-control" id="txt_purposeofloan" placeholder="Enter Purpose of Loan" />
                                </td>
                                <td>
                                <label class="control-label">
                                    Any previous Loan
                                    </label>
                                </td>
                                <td style="height: 40px;">
                                    <input type="text" class="form-control" id="txt_Anypreviousloan" placeholder="Enter Any previous Loan" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                <label class="control-label">
                                    Loan amount
                                    </label>
                                </td>
                                <td style="height: 40px;">
                                    <input type="text" class="form-control" id="txt_LoanAmount" placeholder="Enter Loan amount"
                                        onkeypress="return isNumber(event)" />
                                </td>
                                <td>
                                <label class="control-label">
                                    Loan Recovered EMI
                                    </label>
                                </td>
                                <td style="height: 40px;">
                                    <input type="text" class="form-control" id="txt_EMI" placeholder="Enter recovered amount " />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                <label class="control-label">
                                    Loan to be recovered in no.of months
                                    </label>
                                </td>
                                <td style="height: 40px;">
                                    <input type="text" class="form-control" id="txt_LoanRecovermonth" placeholder="EnterLoan to be recovered in no.of months" />
                                </td>
                                <td>
                                <label class="control-label">
                                    Starting month Of date
                                    </label>
                                </td>
                                <td style="height: 40px;">
                                    <input type="date" class="form-control" id="txt_startdate" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="box box-danger">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Reference of 2 Employees in
                        the company for loan retrieval guarantee</h3>
                </div>
                <div class="box-body">
                    <div class="row-fluid">
                        <div style="padding-left: 150px;">
                            <div>
                                <table>
                                    <tr>
                                        <td>
                                        <label class="control-label">
                                            Name :
                                            </label>
                                        </td>
                                        <td style="height: 40px;">
                                            <input type="text" class="form-control" id="txt_empREF1name" placeholder="Enter employee name"
                                                 onchange="refemployeenamechange();" />
                                    <input id="txt_Refrencemp1" type="hidden" class="form-control" name="hiddenempid" />
                                </td>
                                        <td>
                                        </td>
                                        <td>
                                        <label class="control-label">
                                            Name :
                                            </label>
                                        </td>
                                        <td style="height: 40px;">
                                            <input type="text" class="form-control" id="txt_empREF2name" placeholder="Enter employee name"
                                                 onchange="refemployeenamechange1();" />
                                                <input id="txt_Refrencemp2" type="hidden" class="form-control" name="hiddenempid" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        <label class="control-label">
                                            Designation :
                                            </label>
                                        </td>
                                        <td style="height: 40px;">
                                            <span id="txt_emp1deg" />
                                               
                                        </td>
                                        <td>
                                        </td>
                                        <td>
                                        <label class="control-label">
                                            Designation :
                                            </label>
                                        </td>
                                        <td style="height: 40px;">
                                            <span  id="txt_emp2deg" />
                                               
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        <label class="control-label">
                                            Address :
                                            </label>
                                        </td>
                                        <td style="height: 40px;">
                                            <span  id="txt_emp1Address"></span>
                                        </td>
                                        <td>
                                        </td>
                                        <td>
                                        <label class="control-label">
                                            Address :
                                            </label>
                                        </td>
                                        <td style="height: 40px;">
                                            <span  id="txt_emp2Address" ></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        <label class="control-label">
                                            Contact number :
                                            </label>
                                        </td>
                                        <td style="height: 40px;">
                                            <span id="txt_emp1Moble" />
                                        </td>
                                        <td>
                                        </td>
                                        <td>
                                    <label class="control-label">
                                            Contact number :
                                            </label>
                                        </td>
                                        <td style="height: 40px;">
                                            <span  id="txt_emp2Moble" />
                                               
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                        <label class="control-label">
                                            Cheque Details1 :
                                            </label>
                                        </td>
                                        <td style="height: 40px;">
                                            <input type="text" class="form-control" id="txt_cheq1" placeholder="Enter Cheque Details"/>
                                        </td>
                                        <td>
                                        </td>
                                        <td>
                                        <label class="control-label">
                                            Cheque Details2 :
                                            </label>
                                        </td>
                                        <td style="height: 40px;">
                                            <input type="text" class="form-control" id="txt_cheq2" placeholder="Enter Cheque Details"/>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div>
                        <table align="center">
                            <tr>
                                <td>
                                    <input type="button" class="btn btn-primary" id="btn_save" value="Save" onclick="save_Loan_Request_click();" />
                                    <input type="button" class="btn btn-danger" id="close_id" value="Close" onclick="closeloanentry();" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            </div>
            </div>
            <div id="div_approval" style="display:none">
        <div id="fillGrid_approved" style="display:none;">
        </div>
        <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 100%;
            width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
            background: rgba(192, 192, 192, 0.7);">
            <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                border-radius: 10px 10px 10px 10px;">
                <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                    id="tableCollectionDetails" class="mainText2" border="1">
                    <tr>
                        <td>
                            <label>
                                Remarks</label>
                        </td>
                        <td style="height: 40px;">
                            <textarea id="txt_remarks" type="text" class="form-control" name="Remarks" placeholder="Enter remarmks"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                            <input type="button" class="btn btn-danger" id="btn_cancel" value="Reject" onclick="save_loanrequest_reject_click();" />
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divclose" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                z-index: 99999; cursor: pointer;">
                <img src="Images/Close.png" alt="close" onclick="CloseClick();" />
            </div>
        </div>
            </div>
      <div id="fillgrid_rejected" style="display:none;">
        </div>
            <div class="modal" id="svds_empdetails" role="dialog"; style="display: none; overflow:auto;">
            <div class="modal-dialog" style="width: 650px; margin: 30px auto;">
                <div class="modal-content" style="border: 2px solid; border-color: antiquewhite;">
                    <div class="modal-body">
                        <div id="div4" style="border: 4px solid; border-color: aliceblue;">
        <div id="divPrint" style="display: none;">
                    <div style="border: 2px solid gray;">
                        <div style="width: 17%; float: right; padding-top:5px;">
                            <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                            <br />
                        </div>
                        <div style="border: 1px solid gray;">
                            <div style="font-family: Arial; font-size: 22px; font-weight: bold; color: Black;text-align: center;">
                                <span>Sri Vyshnavi Foods Pvt Ltd </span>
                                <br />
                            </div>
                            <div style="width:68%;text-align: center;padding-left: 14%;">
                            <span id="spnAddress" class="spanrpt">
                                R.S.No:381/2,Punabaka village Post, Pellakuru Mandal, Nellore, District -524129. 
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
                                <td style="width: 49%;  padding-left:2%; border:1px solid gray; line-height: 1.628571 !important;">
                                    <label><b>
                                        Name :</b></label>
                                    <span class="lblempname"  id="lblempname"></span>
                                    <br />
                                    <label class="labelrpt"><b>
                                        Employee code :</b></label>
                                    <span id="lblEmpID" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>
                                        Fathers name  :</b></label>
                                    <span id="lblFathersName" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>Address :</b></label>
                                    <span id="lblAdress" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>Permanent address :</b></label>
                                    <span id="lblperementaddress" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>Contact number :</b></label>
                                    <span id="lblContactNumber" class="tdsize"></span>
                                    <br />
                                    <label class="labelrpt"><b>DOB :</b></label>
                                    <span id="lblDOB" class="tdsize"></span>
                                    
                                    
                                </td>
                                <td style="width: 50%;  padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;" >
                                    <label id="Label9"><b>Department :</b></label>
                                    <span id="spnempdept"></span>
                                     <br />
                                    <label id="lbl_ref_no"><b>Designation :</b></label>
                                    <span id="lblDesignation"></span>

                                    <br />
                                    <label id="Label1"><b>Experience in the company :</b></label>
                                    <span id="lblExprnceCompany"></span> Years.

                                    <br />
                                    <label id="Label2"><b>Salary paid as on date :</b></label>
                                    <span id="lblSalaryPaydate"></span>

                                    <br />
                                    <label id="Label3"><b>Purpose of loan :</b></label>
                                    <span id="lblPuposeloan"></span>

                                    <br />
                                    <label id="Label4"><b>Any previous loan :</b></label>
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
                                <td style="width: 49%; padding-left:2%;border:1px solid gray; line-height: 1.628571 !important;">
                                    <label class="labelrpt"><b>
                                        Name :</b></label>
                                    <span id="lblname1" class="spanrpt"></span>
                                     <br />
                                    <label class="labelrpt"><b>
                                        Employee code :</b></label>
                                    <span id="spnemprefnum1" class="spanrpt"></span>
                                    <br />
                                    <label id="Label10"><b>Department :</b></label>
                                    <span id="spnempdept1"></span>
                                    <br />
                                    <label class="labelrpt"><b>
                                        Designation :</b></label>
                                    <span id="lblDesgnation1" class="spanrpt"></span>
                                     <br />
                                    <label><b>
                                        Experience in the company :</b></label>
                                    <span id="spnexpemp1"></span> Years
                                    <br />
                                    <label class="labelrpt"><b>
                                        Address :</b></label>
                                    <span id="lblAddress1" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>
                                         Phone number :</b></label>
                                    <span id="lblnumbr1" class="spanrpt"></span>
                                    <br />
                                    <label class="labelrpt"><b>Cheque number :</b></label>
                                    <span id="spnchqno1" class="spanrpt"></span>
                                     <br />
                                     <br />
                                    <label><b>
                                        Employee Signature </b></label>
                                </td>
                                <td style="width: 50%;  padding-left:2%; border:1px solid gray; line-height: 1.628571 !important;">
                                    <label><b>
                                        Name :</b></label>
                                    <span id="lblname2"></span>
                                     <br />
                                    <label class="labelrpt"><b>
                                        Employee code :</b></label>
                                    <span id="spnemprefnum2" class="spanrpt"></span>
                                    <br />
                                 
                                    <label id="Label11"><b>Department :</b></label>
                                    <span id="spnempdept2"></span>
                                       <br />
                                    <label><b>
                                        Designation:</b></label>
                                    <span id="lblDesgnation2"></span>

                                    <br />
                                    <label><b>
                                        Experience in the company :</b></label>
                                    <span id="spnexpemp2"></span> Years
                                    <br />

                                    <label><b>
                                        Address :</b></label>
                                    <span id="lblAddress2"></span>

                                    <br />
                                    <label><b>
                                         Phone number  :</b></label>
                                    <span id="lblnumbr2"></span>

                                    <br />
                                    <label><b>
                                        Cheque number :</b></label>
                                    <span id="spnchqno2"></span>
                                     <br />
                                     <br />
                                    <label><b>
                                        Employee Signature </b></label>
                                </td>
                            </tr>
                        </table>
                        
                        </div>
                    </div>
                     
                     <b> Rupees in Words : </b>&nbsp;<span id="spnamttext" class="spanrpt"></span> Rupees Only/- <br />

                      <b> Narration : </b> Beaing The Amount Paid To <span id="spnnarname" class="spanrpt"></span> towords loan amount paid. this amount will be deducted by the salary formonth <span id="spnnarationloanemi" class="spanrpt"></span>  Rupees Only/-

                     <br />
                       <br />
                     <br />
                     <table style="width: 100%;">
                   
                       
                        <tr>
                            <td style="width: 35%;">
                                <span style="font-weight: bold;" class="tdsize">Signature Loan Employee</span>
                            </td>
                            <td style="width: 15%;">
                                <span style="font-weight: bold;" class="tdsize"></span>
                            </td>
                            <td style="width: 15%;">
                                <span style="font-weight: bold;" class="tdsize"></span>
                            </td>
                            <td style="width: 35%;">
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
                        <div class="input-group" id="Button2" style="padding-left: 40%;">
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-print" onclick="javascript: CallPrint('divPrint');"></span> <span id="Span1" onclick="javascript: CallPrint('divPrint');">Print</span>
                    </div>
                    <div>
                    <input type="button" class="btn btn-danger" id="btn_closepopup" style="width: 22%;height: 30px;" value="Close" onclick="closepopup();" />
                    </div>
                </div>
                 </div>
                </div>
            </div>
        </div>
        </div>
            </div>

    </section>
</asp:Content>
