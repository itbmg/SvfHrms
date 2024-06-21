<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="Salaryadvance.aspx.cs" Inherits="Salaryadvance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
 <style type="text/css">
    
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
        //get_Dept_details();
        get_Employeedetails();
        get_salaryadvance_details();
       
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
    function Close_Click(msg) {
        $("#fill_Grid").css("display", "none");
        $("#div_saladvance").css("display", "block");
        $("#div_Deptdata").css("display", "block");

    }
    function closepopup(msg) {
        $("#myModal").css("display", "none");
    }

    function close_popup(msg) { 

        $("#fill_Grid").css("display", "none");
        $("#div_saladvance").css("display", "block");
        $("#div_Deptdata").css("display", "block");
    }
    function show_saladvancedetails() {
        $("#div_saladvance").css("display", "block");
        $("#div_approval").css("display", "none");
        $("#div_print").css("display", "none");
    }
    function show_salApprove() {
        $("#div_saladvance").css("display", "none");
        $("#div_approval").css("display", "block");
        $("#div_print").css("display", "block");
        get_salaryadvanceDetails();
    }
        function GettotalclsCal() {
            var totamount = 0;
            $('.tammountcls').each(function (i, obj) {
                var qtyclass = $(this).text();
                if (qtyclass == "" || qtyclass == "0") {
                }
                else {
                    totamount += parseFloat(qtyclass);
                }
            });
            document.getElementById('totalcls').innerHTML = parseFloat(totamount).toFixed(2);
        }
    function convertNumberToWords(amount) {
        var words = new Array();
        words[0] = '';
        words[1] = 'One';
        words[2] = 'Two';
        words[3] = 'Three';
        words[4] = 'Four';
        words[5] = 'Five';
        words[6] = 'Six';
        words[7] = 'Seven';
        words[8] = 'Eight';
        words[9] = 'Nine';
        words[10] = 'Ten';
        words[11] = 'Eleven';
        words[12] = 'Twelve';
        words[13] = 'Thirteen';
        words[14] = 'Fourteen';
        words[15] = 'Fifteen';
        words[16] = 'Sixteen';
        words[17] = 'Seventeen';
        words[18] = 'Eighteen';
        words[19] = 'Nineteen';
        words[20] = 'Twenty';
        words[30] = 'Thirty';
        words[40] = 'Forty';
        words[50] = 'Fifty';
        words[60] = 'Sixty';
        words[70] = 'Seventy';
        words[80] = 'Eighty';
        words[90] = 'Ninety';

        amount = amount.toString();
        var atemp = amount.split(".");
        var number = atemp[0].split(",").join("");
        var n_length = number.length;
        var words_string = "";
        if (n_length <= 9) {
            var n_array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0);
            var received_n_array = new Array();
            for (var i = 0; i < n_length; i++) {
                received_n_array[i] = number.substr(i, 1);
            }
            for (var i = 9 - n_length, j = 0; i < 9; i++, j++) {
                n_array[i] = received_n_array[j];
            }
            for (var i = 0, j = 1; i < 9; i++, j++) {
                if (i == 0 || i == 2 || i == 4 || i == 7) {
                    if (n_array[i] == 1) {
                        n_array[j] = 10 + parseInt(n_array[j]);
                        n_array[i] = 0;
                    }
                }
            }
            value = "";
            for (var i = 0; i < 9; i++) {
                if (i == 0 || i == 2 || i == 4 || i == 7) {
                    value = n_array[i] * 10;
                } else {
                    value = n_array[i];
                }
                if (value != 0) {
                    words_string += words[value] + " ";
                }
                if ((i == 1 && value != 0) || (i == 0 && value != 0 && n_array[i + 1] == 0)) {
                    words_string += "Crores ";
                }
                if ((i == 3 && value != 0) || (i == 2 && value != 0 && n_array[i + 1] == 0)) {
                    words_string += "Lakhs ";
                }
                if ((i == 5 && value != 0) || (i == 4 && value != 0 && n_array[i + 1] == 0)) {
                    words_string += "Thousand ";
                }
                if (i == 6 && value != 0 && (n_array[i + 1] != 0 && n_array[i + 2] != 0)) {
                    words_string += "Hundred and ";
                } else if (i == 6 && value != 0) {
                    words_string += "Hundred ";
                }
            }
            words_string = words_string.split("  ").join(" ");
        }
        document.getElementById('spnamttext').innerHTML = words_string;
    }

    //Function for only no
    function only_no() {
        $("#txtaccountno").keydown(function (event) {
            // Allow: backspace, delete, tab, escape, and enter
            if (event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 || event.keyCode == 190 ||
            // Allow: Ctrl+A
            (event.keyCode == 65 && event.ctrlKey === true) ||
            // Allow: home, end, left, right
            (event.keyCode >= 35 && event.keyCode <= 39)) {
                // let it happen, don't do anything
                return;
            }
            else {
                // Ensure that it is a number and stop the keypress
                if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
                    event.preventDefault();
                }
            }
        });
    }
    function ValidateAlpha(evt) {
        var keyCode = (evt.which) ? evt.which : evt.keyCode
        if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

            return false;
        return true;
    }

    var supperdetails = [];
    function get_Employeedetails() {
        var data = { 'op': 'get_Employeedetails' };
        var s = function (msg) {
            if (msg) {
                supperdetails = msg;
                var empnameList = [];
                for (var i = 0; i < msg.length; i++) {
                    var empname = msg[i].empname;
                    empnameList.push(empname);
                }
               
                $('#selct_employe').autocomplete({
                    source: empnameList,
                    change: employee,
                    autoFocus: true
                });
                $('#search_employe').autocomplete({
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
    
    function employee() {
        //alert('hi')
        var empname = document.getElementById('selct_employe').value;
        for (var i = 0; i < supperdetails.length; i++) {
            if (empname == supperdetails[i].empname) {
                document.getElementById('txtsupid').value = supperdetails[i].empsno;
                document.getElementById('txtempnum').value = supperdetails[i].empnum;
                document.getElementById('txtsearchsupid').value = employeedetails[i].empsno;
            }
        }
    }
    function save_Salary_Advancedetails() {
        var employeid = document.getElementById('txtsupid').value;
        if (employeid == "") {
            alert("Select Employee Name ");
            return false;
        }
        var empnum = document.getElementById('txtempnum').value;
        var Remarks = document.getElementById('txtRemarks').value;
        if (Remarks == "") {
            alert("Enter Remarks ");
            return false;

        }
        var Amount = document.getElementById('txt_Amount').value;
        if (Amount == "") {
            alert("Select amount ");
            return false;

        }
        var monthofpaid = document.getElementById('txt_Monthofpaid').value;
        if (monthofpaid == "") {
            alert("Select monthofpaid ");
            return false;

        }
        var sno = document.getElementById('lbl_sno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_Salary_Advancedetails', 'employeid': employeid, 'Remarks': Remarks, 'Amount': Amount, 'monthofpaid': monthofpaid, 'sno': sno,
            'btnval': btnval, 'empnum': empnum
        };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                
                    alert("Employee Salary Advance successfully added");
                    get_salaryadvance_details();
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
        //document.getElementById('selct_department').selectedIndex = 0;
        document.getElementById('selct_employe').value = "";
        document.getElementById('txt_Amount').value = "";
        document.getElementById('txtRemarks').value = "";
        document.getElementById('txt_Monthofpaid').value = "";
        document.getElementById('btn_save').value = "Save";
        $("#lbl_code_error_msg").hide();
        $("#lbl_name_error_msg").hide();
        get_salaryadvance_details();
    }


    function get_salaryadvance_details() {
        var data = { 'op': 'get_salaryadvance_details'};
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    filldetails(msg);
                    employee_data = msg;
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
    function get_salaryadvance_generate() {
        var fromdate = document.getElementById('txtfromdate').value;
        var todate = document.getElementById('txttodate').value
        var employeid = document.getElementById('txtsrchempid').value;
        var data = { 'op': 'get_salaryadvance_generate', 'employeid': employeid, 'fromdate': fromdate, 'todate': todate };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    filldetails(msg);
                    employee_data = msg;
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
    function filldetails(msg) {
        var k = 1;
        var results = '<div  style="overflow:auto;"><table id="tbl_empmaster" class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col"></th><th scope="col"></th><th scope="col" style="text-align:center;">Sno</th><th scope="col" style="text-align:center;">EmployeeCode</th><th scope="col" style="text-align:center;"></i>Employee Name</th><th scope="col" style="text-align:center;">Salary Advance</th><th scope="col" style="text-align:center;">Date</th></tr></thead></tbody>';
        var l = 0;
        var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '"><td style="width:  10%;"><button type="button" title="Click Here To View!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background-color:  darkcyan;"  onclick="getmeview(\'' + msg[i].empcode + '\');"><span style="top: 0px !important;">View</span></button></td>';
            results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background: #f44336 !important;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;color: #ffffff !important;border-color: #f44336 !important;"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td>';
            results += '<td> <button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="color: #68d2ec; border-color: #00acd6;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;"  onclick="getmeprint(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
            results += '<td style="text-align:center;">' + k++ + '</td>';
            results += '<th style="display:none" scope="row" class="1" style="text-align:center;">' + msg[i].empcode + '</th>';
            results += '<td  data-title="brandstatus" class="1" style="text-align:center;"><span class="glyphicon glyphicon-triangle-right" style="color: cadetblue;"></span>  <span id="1" class="1">  ' + msg[i].empcode + ' </span></td>';
            results += '<td  class="5" style="text-align:center;"> <span class="glyphicon glyphicon-user" style="color: cadetblue;"></span> <span id="5" class="5">' + msg[i].fullname + '</td>';
            results += '<td  style="display:none"class="9">' + msg[i].Designetion + '</td>';
            results += '<td style="display:none" class="10">' + msg[i].Department + '</td>';
            results += '<td data-title="Code" class="2" style="text-align:center;"><i class="fa fa-inr" style="font-size: 76%; padding: 1%;"></i><span id="2" class="2">' + msg[i].Amount + '</span></td>';
            results += '<td style="display:none" class="3">' + msg[i].monthofpaid + '</td>';
            results += '<td style="display:none" class="8">' + msg[i].sno + '</td>';
            results += '<td style="display:none" class="17">' + msg[i].joindate + '</td>';
            results += '<td style="display:none" class="18">' + msg[i].netpay + '</td>';
            results += '<td style="display:none" class="4">' + msg[i].Remarks + '</td>';
            results += '<td data-title="Code" class="13" style="text-align:center;">' + msg[i].doe + '</td>';
            results += '<td style="display:none" class="19">' + msg[i].monthofpaidname + '</td>';
            results += '<td style="display:none" class="6">' + msg[i].employeid + '</td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
        }
        results += '</table></div>';
        $("#div_Deptdata").html(results);


    }
    function getme(thisid) {
        var empcode = $(thisid).parent().parent().children('.1').html();
        var sno = $(thisid).parent().parent().children('.8').html();
        
        var Amount = $(thisid).parent().parent().find('#2').html();
        //        var Amount = $(thisid).parent().parent().children('#2').html();
        var monthofpaid = $(thisid).parent().parent().children('.3').html();
        var Remarks = $(thisid).parent().parent().children('.4').html();
        var fullname = $(thisid).parent().parent().find('#5').text();
        //        var fullname = $(thisid).parent().parent().children('.5').html();
        var employeid = $(thisid).parent().parent().children('.6').html();
        document.getElementById('selct_employe').value = fullname;
        //        document.getElementById('search_employe').value = fullname;
        document.getElementById('txt_Amount').value = Amount;
        document.getElementById('txt_Monthofpaid').value = monthofpaid;
        document.getElementById('lbl_sno').value = sno;
        document.getElementById('txtRemarks').value = Remarks;
        document.getElementById('txtsupid').value = employeid;
        document.getElementById('btn_save').value = "Modify";

    }


    function getmeview(empid) {
        var empid;
        var data = { 'op': 'get_salaryadvance', 'empid': empid };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillsallsaldetails(msg);
                    employee_data = msg;
                }
            }
            else {
            }
        };
        var e = function (x, h, e) {
        };
        $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
        $('#fill_Grid').css('display', 'block');
        $('#divPrint').css('display', 'none');
        $('#div_Deptdata').css('display', 'none');
        $('#div_saladvance').css('display', 'none');

    }
    function fillsallsaldetails(msg) {
        $('#divanualincmtax').css('display', 'block');
        var k = 1;
        var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
        var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr></th></th><th scope="col" style="text-align:center;">Sno</th><th scope="col" style="text-align:center;">EmployeeCode</th><th scope="col" style="text-align:center;">Employee Name</th><th scope="col" style="text-align:center;">Advance amount</th><th scope="col" style="text-align:center;">Date</th></tr></thead></tbody>';
        var l = 0;
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
            results += '<th  scope="row" class="1" style="text-align:center;">' + msg[i].empcode + '</th>';
            results += '<td  class="2" style="text-align:center;">' + msg[i].fullname + '</td>';
            results += '<td  class="tammountcls" style="text-align:center;">' + msg[i].amount + '</td>';
            results += '<td  class="3" style="text-align:center;">' + msg[i].doe + '</td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
        }
        results += '<tr style="text-align:center;"><th scope="row" class="1" style="text-align:center;"></th>';
        results += '<td data-title="brandstatus" class="6"></td>';
        results += '<td data-title="brandstatus" class="badge bg-yellow" style="text-align:center;">Total</td>';
        results += '<td data-title="brandstatus" class="5" ><span id="totalcls" class="badge bg-yellow"></span></td></tr>';
        results += '</table></div>';
        $("#ShowCategoryData").html(results);
        GettotalclsCal();
    }

    function getmeprint(thisid) {

        $('#myModal').css('display', 'block');
        $('#divPrint').css('display', 'block');
        var empcode = $(thisid).parent().parent().children('.1').html();
        var sno = $(thisid).parent().parent().children('.8').html();
        var Amount = $(thisid).parent().parent().find('#2').html();
        var monthofpaid = $(thisid).parent().parent().children('.3').html();
        var Remarks = $(thisid).parent().parent().children('.4').html();
        var fullname = $(thisid).parent().parent().children('.5').html();
        var employeid = $(thisid).parent().parent().children('.6').html();
        var designation = $(thisid).parent().parent().children('.9').html();
        var department = $(thisid).parent().parent().children('.10').html();
        var doe = $(thisid).parent().parent().children('.13').html();
        var joindate = $(thisid).parent().parent().children('.17').html();
        var netpay = $(thisid).parent().parent().children('.18').html();
        var monthofpaidname = $(thisid).parent().parent().children('.19').html();
        document.getElementById('lblempname').innerHTML = fullname;
        document.getElementById('lblEmpID').innerHTML = empcode;
        document.getElementById('lblDesignation').innerHTML = designation;
        document.getElementById('lbldepartment').innerHTML = department;
        document.getElementById('lblmonthpaid').innerHTML = monthofpaid;
        document.getElementById('lblremarks').innerHTML = Remarks;
        document.getElementById('lblamount').innerHTML = '<i class="fa fa-inr" style="font-size: 76%; padding: 1%;"></i>' + Amount;
        document.getElementById('lblrefrenceno').innerHTML = sno;
        document.getElementById('lbljoindate').innerHTML = joindate;
        document.getElementById('lblnetpay').innerHTML = netpay;
        document.getElementById('lblmonthofpaidname').innerHTML = monthofpaidname;


        document.getElementById('spnamttext').innerHTML = inWords(Amount);

        //convertNumberToWords(value);
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

    var emp_sno = 0;
    function employeenamechange() {
        // document.getElementById('txt_empname1').value = branchid;
        //document.getElementById('txt_empcode1').value = employeetype;
        var table = document.getElementById("tbl_empmaster");
        for (var i = table.rows.length - 1; i > 0; i--) {
            table.deleteRow(i);
        }
        var results = employee_data;
        var employeename = document.getElementById('search_employe').value;
        if (employeename == "") {
            var k = 1;
            var l = 0;
            //            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < results.length; i++) {
                if (results[i].empcode != null) {
                    var empcode = results[i].empcode;
                    var fullname = results[i].fullname;
                    var Designetion = results[i].Designetion;
                    var Department = results[i].Department;
                    var Amount = results[i].Amount;
                    var monthofpaid = results[i].monthofpaid;
                    var sno = results[i].sno;
                    var Remarks = results[i].Remarks;
                    var employeid = results[i].employeid;
                    document.getElementById('txtsrchempid').value = results[i].employeid;
                    var joindate = results[i].joindate;
                    var monthofpaidname = results[i].monthofpaidname;
                    var tablerowcnt = document.getElementById("tbl_empmaster").rows.length;
                    $('#tbl_empmaster').append('<tr style="background-color:' + COLOR[l] + '"><td style="width:  10%;"><button type="button" title="Click Here To View!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background-color:  darkcyan;"  onclick="getmeview(\'' + results[i].empcode + '\');"><span style="top: 0px !important;">View</span></button></td><td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background: #f44336 !important;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;color: #ffffff !important;border-color: #f44336 !important;"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td><td> <button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="color: #68d2ec; border-color: #00acd6;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;"  onclick="getmeprint(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td> <td >' + k++ + '</td><th style="display:none" scope="row" class="1" style="text-align:center;">' + empcode + '</th><td  data-title="brandstatus" class="1"><span class="glyphicon glyphicon-triangle-right" style="color: cadetblue;"></span>  <span id="1" class="1">  ' + empcode + ' </span></td><td id="5"  class="5">' + fullname + '</td><td  style="display:none"class="9">' + Designetion + '</td><td style="display:none" class="10">' + Department + '</td><td data-title="Code" class="2" ><i class="fa fa-usd" style="font-size: 76%; padding: 1%;"></i><span id="2" class="2">' + Amount + '</span></td><td style="display:none" class="3">' + monthofpaid + '</td><td style="display:none" class="8">' + sno + '</td><td style="display:none" class="4">' + Remarks + '</td><td style="display:none" class="6">' + employeid + '</td><td style="display:none" class="17">' + joindate + '</td><td style="display:none" class="19">' + monthofpaidname + '</td></tr>');
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
        }
        else {
            var k = 1;
            var l = 0;
            //            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < results.length; i++) {
                if (employeename == results[i].fullname) {
                    var empcode = results[i].empcode;
                    var fullname = results[i].fullname;
                    var Designetion = results[i].Designetion;
                    var Department = results[i].Department;
                    var Amount = results[i].Amount;
                    var monthofpaid = results[i].monthofpaid;
                    var sno = results[i].sno;
                    var Remarks = results[i].Remarks;
                    var employeid = results[i].employeid;
                    document.getElementById('txtsrchempid').value = results[i].employeid;
                    var joindate = results[i].joindate;
                    var monthofpaidname = results[i].monthofpaidname;
                    var tablerowcnt = document.getElementById("tbl_empmaster").rows.length;
                    $('#tbl_empmaster').append('<tr style="background-color:' + COLOR[l] + '"><td style="width:  10%;"><button type="button" title="Click Here To View!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background-color:  darkcyan;"  onclick="getmeview(\'' + results[i].empcode + '\');"><span style="top: 0px !important;">View</span></button></td><td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background: #f44336 !important;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;color: #ffffff !important;border-color: #f44336 !important;"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td><td> <button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="color: #68d2ec; border-color: #00acd6;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;"  onclick="getmeprint(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td> <td >' + k++ + '</td><th style="display:none" scope="row" class="1" style="text-align:center;">' + empcode + '</th><td  data-title="brandstatus" class="1"><span class="glyphicon glyphicon-triangle-right" style="color: cadetblue;"></span>  <span id="1" class="1">  ' + empcode + ' </span></td><td  id="5" class="5">' + fullname + '</td><td  style="display:none"class="9">' + Designetion + '</td><td style="display:none" class="10">' + Department + '</td><td data-title="Code" class="2"><i class="fa fa-inr" style="font-size: 76%; padding: 1%;"></i><span id="2" class="2">' + Amount + '</span></td><td style="display:none" class="3">' + monthofpaid + '</td><td style="display:none" class="8">' + sno + '</td><td style="display:none" class="4">' + Remarks + '</td><td style="display:none" class="6">' + employeid + '</td><td style="display:none" class="17">' + joindate + '</td><td style="display:none" class="19">' + monthofpaidname + '</td></tr>');
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
        }
    }
    function get_salaryadvanceDetails() {
        var data = { 'op': 'get_salaryadvanceDetails' };
        var s = function (msg) {
            if (msg) {
                fillsalaryadvancedetails(msg);
            }
            else {
            }
        };
        var e = function (x, h, e) {
        };
        $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
    }
    function fillsalaryadvancedetails(msg) {
        var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr></th></th><th scope="col">Employee Name</th><th scope="col">EmployeeCode</th><th scope="col">BranchName</th><th scope="col">DOJ</th><th scope="col">Purpose of Advance</th><th scope="col">Advance amount</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><th scope="row" class="1" style="text-align:center;">' + msg[i].fullname + '</th>';
            results += '<td  class="2">' + msg[i].Empcode + '</td>';
            results += '<td  class="2">' + msg[i].branchname + '</td>';
            //            results += '<td  class="2">' + msg[i].designation + '</td>';
            results += '<td  class="3">' + msg[i].joindate + '</td>';
            results += '<td  class="5">' + msg[i].purpose_of_advance + '</td>';
            results += '<td class="4">' + msg[i].Advanceamount + '</td>';
            results += '<td><input id="btn_poplate" type="button" name="submit" class="btn btn-primary" onclick="save_salaryadvance_approve_click(this);" value="Approval" /></td><td><input id="btn_poplate" type="button"  onclick="getme1(this)" name="submit" class="btn btn-danger" value="Reject" /></td>';
            results += '<td style="display:none" class="7">' + msg[i].status + '</td>';
            results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#fillGrid").html(results);
    }
    function CloseClick() {
        $('#divMainAddNewRow').css('display', 'none');
    }
    var sno = 0;
    function getme1(thisid) {
        $('#divMainAddNewRow').css('display', 'block');
        var fullname = $(thisid).parent().parent().children('.1').html();
        var designation = $(thisid).parent().parent().children('.2').html();
        var joindate = $(thisid).parent().parent().children('.3').html();
        var purpose_of_loan = $(thisid).parent().parent().children('.5').html();
        var loanamount = $(thisid).parent().parent().children('.4').html();
        sno = $(thisid).parent().parent().children('.6').html();
        var status = $(thisid).parent().parent().children('.7').html();
    }

    function save_salaryadvance_reject_click() {
        var rejectremarks = document.getElementById("txt_remarks").value;
        var data = { 'op': 'save_salaryadvance_reject_click', 'sno': sno, 'rejectremarks': rejectremarks };
        var s = function (msg) {
            if (msg) {
                alert(msg);
                $('#divMainAddNewRow').css('display', 'none');
                get_salaryadvanceDetails();
            }
            else {
            }
        };
        var e = function (x, h, e) {
        };
        $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
    }

    function save_salaryadvance_approve_click(thisid) {
        sno = $(thisid).parent().parent().children('.6').html();
        var data = { 'op': 'save_salaryadvance_approve_click', 'sno': sno };
        var s = function (msg) {
            if (msg) {
                alert(msg);
                get_salaryadvanceDetails();
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

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Salary Advance  Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#"> Salary Advance  Master</a></li>
        </ol>
    </section>
    <section class="content">
    <div class="box box-info">        
        <div class="box box-info" style="margin-bottom:0px">
                    <ul class="nav nav-tabs">
                        <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="show_saladvancedetails()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;Salary Advance Details</a></li>
                        <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="show_salApprove()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Approval Details</a></li>
                    </ul>
                </div>
                <div id="div_saladvance">
            <div class="box-header with-border">


                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Salary Advance Details
                </h3>
            </div>
            <div class="box-body">
                <div class="row-fluid">
        <div >
            <table id="tbl_leavemanagement" align="center">
                <tr>
                    <td style="height: 50px;">
                    <label class="control-label" >
                        Employee name
                        </label>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="selct_employe" placeholder="Enter Employee Name " />
                    </td>
                    <td style="height: 40px; display:none">
                        <input id="txtsrchempid" type="hidden" class="form-control" name="srchhiddenempid" />
                        <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                         <input id="txtempnum" type="hidden" class="form-control" name="hiddenempid" />
                    </td>
                    <td>
                    <label class="control-label" >
                        Amount
                        </label>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="txt_Amount" placeholder="Enter Amount"
                            onkeypress="return isNumber(event)" />
                    </td>
                </tr>
                
                <tr  >
                    <td>
                    <label class="control-label" >
                        Remarks 
                        </label>
                    </td>
                    <td style="height: 40px;">

                        <textarea type="text" class="form-control" id="txtRemarks"  placeholder="Enter Remarks"></textarea>
                      
                    </td>
                    <td>
                    <label class="control-label" >
                        Month of Paid
                        </label>
                    </td>
                    <td>
                        <input type="date" class="form-control" id="txt_Monthofpaid" placeholder="Enter Amount" onkeypress="return isNumber(event)" />
                    </td>
                </tr>
                <tr>
                   <td>
                   </td>
                   <td></td>
                    <td style="height: 40px;">
                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                            onclick="save_Salary_Advancedetails();">
                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Cancel"
                            onclick="forclearall();" >
                    </td>
                </tr>
               
                <tr hidden>
                    <td>
                        <label id="lbl_sno">
                        </label>
                    </td>
                </tr>
            </table>
        </div>
        <div>
       
      <div class="input-group margin" >
      
                <input id="search_employe" type="text" class="form-control" name="branch_search"  placeholder="Enter Emloyee Name"/>
                <input id="txtsearchsupid" type="text" style="display:none" class="form-control" name="branch_searchid" />
                    <span class="input-group-btn">
                      <button type="button" class="btn btn-info btn-flat" style="height: 34px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                    </span>
                    <table>
                    <tr>
                   <td style="width: 5px;">
                        </td>
                            <td>
                                <label>
                                    From Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txtfromdate" class="form-control" />
                            </td>
                            <td style="width: 5px;">
                        </td>
                            <td>
                                <label>
                                    To Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txttodate" class="form-control" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            
                            <td>
                                <input id="txt_save" type="button" class="btn btn-primary" name="submit" value='GENERATE'
                                  onclick="get_salaryadvance_generate()"   />
                                    </td>
                        </tr>
                    </table>
              </div>
            <div id="div_Deptdata">
            <table id="tbl_empmaster" class="table table-bordered table-hover dataTable no-footer">
                        <thead>
                            <tr >
                                <th scope="col">
                                    
                                </th>
                                <th scope="col" >
                                   
                                </th>
                                <th scope="col" >
                                    Sno
                                </th>
                                <th scope="col">
                                    Employee code
                                </th>
                                
                                <th scope="col">
                                    <i class="fa fa-user"></i>Employee name
                                </th>
                                <th scope="col">
                                    <i class="fa fa-asterisk"></i>Salary advance
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
            </div>
            </div>
            </div>
            </div>
            </div>
            <div class="modal" id="myModal" role="dialog" style="overflow:auto;">
    <div class="modal-dialog">
      <!-- Modal content-->
     
      <div class="modal-content">
        <div class="modal-header" >
        
         
        </div>
        <div class="modal-body">
           <div id="divPrint" style="display:none">
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
                        <span style="font-size: 26px; font-weight: bold;">Salary Advance </span>
                    </div>
                    <div style="width: 100%;">
                        <table style="width: 100%;">
                        <tr>
                        <td colspan="2"><label class="control-label" >
                                        Reference no :</label>
                                    <span id="lblrefrenceno"></span></td>
                                     <td>
                                    <label class="control-label" >
                                        Month of paid :</label>
                                    <span id="lblmonthpaid"></span>
                                    <br />
                                </td>

                        </tr>
                            <tr>
                              <td colspan="2"><label class="control-label" >
                                        Name of the Staff :</label>
                                    <span id="lblempname"></span></td>
                                <td >
                                    <label class="control-label" >
                                        Employee Number :</label>
                                    <span id="lblEmpID"></span></td>
                                   
                            </tr>
                            <tr>
                                <td  colspan="2">
                                    <label class="control-label" >
                                        Designation :</label>
                                    <span id="lblDesignation"></span>
                                    <br />
                                </td>
                                <td>
                                 <label class="control-label" >
                                        Department:</label>
                                    <span id="lbldepartment"></span>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                              <td colspan="2">
                                       <label class="control-label" >
                                             Advance Required in Rs :</label>
                                        <span id="lblamount"></span>
                                        <br />
                                    </td>
                                    <td>
                                    <label class="control-label" >
                                        Deduction of Month :</label>
                                    <span id="lblmonthofpaidname"></span>
                                    <br />
                                </td>
                              
                               
                            </tr>
                             <tr>
                              <td colspan="2">
                                       <label class="control-label" >
                                             Date of Joining :</label>
                                        <span id="lbljoindate"></span>
                                        <br />
                                    </td>
                                <td>
                                    <label class="control-label" >
                                       Salary as on Date :</label>
                                    <span id="lblmonthpaid"></span>
                                    <br />
                                </td>
                              
                               
                            </tr>
                             <tr>
                              <td colspan="2">
                                       <label class="control-label" >
                                             No of Days present as on date :</label>
                                        <span id="Span2"></span>
                                        <br />
                                    </td>
                                    </tr>
                                    <tr>
                              <td colspan="2">
                                       <label class="control-label" >
                                             Balance as on Date :</label>
                                        <span id="lblnetpay" style="display:none;"></span>
                                        <br />
                                    </td>
                                    </tr>
                            
                           <tr>
                           </tr>
                        </table>
                        <br />
                        Remarks : <span id="lblremarks"></span> 
                        <br />
                        <br />
                       Rupees :  <span id="spnamttext" style="font-weight:bold"></span><span> Only/-</span> 
                    </div>
                    <br />
                    <br />
                     
                     <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 13px;">Employee Signature  </span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 13px;">HR Sign</span>
                            </td>
                              <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">Accounts Sign</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 12px;">Authorised Signatory</span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />                   
                </div>
                
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
        </div>
        <div class="modal-footer">
         <input id="Button2" type="button" class="btn btn-primary" name="submit" value='Print'
                    onclick="javascript:CallPrint('divPrint');" />
          <button type="button" class="btn btn-default" id="close" onclick="closepopup();">Close</button>
        </div>
      </div>
      
    </div>
  </div>
            
        
        <div id="div_approval" style="display:none">
            <div class="box-header with-border">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i> Salary Advance Request Details
            </h3>
        </div>
        <div class='divcontainer' style="overflow:auto;">
        <div id="fillGrid">
                </div>
        <div id="divView">

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
                            <input type="button" class="btn btn-danger" id="btn_cancel" value="Reject" onclick="save_salaryadvance_reject_click();" />
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
        </div>
        <div>
           <div id="fill_Grid" style="display:none;"  >
                <div id="div2" style="border: 5px solid #A0A0A0; position: fixed; top: 8%;
                    background-color: White; left: 20%; right: 10%; width: 80%;  -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"

                        <tr>
                            <td colspan="7">
                                <div style="height:500px;overflow-y:auto;" id="ShowCategoryData">
                                </div>
                            </td>
                        </tr>
                        <tr>
                       <td colspan="7" style="text-align:center">
                        <button type="button" class="btn btn-success"  onclick ="javascript:CallPrint('fill_Grid');"><i class="fa fa-print"></i> Print</button>
                                <input type="button" class="btn btn-danger" id="close_vehmaster" value="Close" onclick="Close_Click();" />
                            </td>
                        </tr>
                    </table>
                     <div id="div1" style="width: 35px; top: 7.5%; right: 10%; position: absolute;
                      z-index: 99999; cursor: pointer;">
                     <img src="Images/Close.png" alt="close" onclick="Close_Click();" />
                </div>
                </div>
            </div>


<%--              <div id="fill_Grid" class="pickupclass" style="text-align: center; height: 100%;
            width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
            background: rgba(192, 192, 192, 0.7);">
            <div id="div5" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                border-radius: 10px 10px 10px 10px;">
                  <div id="divanualincmtax" class="box box-primary" style="display:none;">
            <div class="box-body box-profile" style="text-align: left;">
              <div style="height:500px;overflow-y:auto;" id="ShowCategoryData"></div>
            </div>
            <!-- /.box-body -->
          </div>
          <tr>
                       <td colspan="7" style="text-align:center">
                        <button type="button" class="btn btn-success"  onclick ="javascript:CallPrint('fill_Grid');"><i class="fa fa-print"></i> Print</button>
                                <input type="button" class="btn btn-danger" id="Button1" value="Close" onclick="Close_Click();" />
                            </td>
                        </tr>
            </div>
            <div id="div9" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                z-index: 99999; cursor: pointer;">
                <img src="Images/Close.png" alt="close" onclick="Close_Click();" />
                 </div>
                       </div>--%>



          </div>
    </section>
</asp:Content>

