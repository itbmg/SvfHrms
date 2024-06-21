<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="SimCardMaster.aspx.cs" Inherits="SimCardMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css" />
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" />
     <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
     <style type="text/css">
         /*this style effect in antor style sheet*/
     .form_control 
     {
         margin: 0px;
    height: 34px;
    width: 200px;
    border-color: #d2d6de;
    box-shadow: none;
    padding: 6px 12px;
    font-size: 14px;
    line-height: 1.42857143;
    color: #555;
    background-color: #fff;
    background-image: none;
    border: 1px solid #ccc;
     }
     </style>
    <script type="text/javascript">
        $(function () {
            get_sim_details();
            get_Employeedetails();
            get_Issue_details();
            get_return_details();
            get_approveissue_details();
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
        function show_simdesign() {
            $("#div_issue").css("display", "none");
            $("#div_sim").css("display", "block");
            $("#div_Return").css("display", "none");
            $("#div_approval").css("display", "none");
            canceldetails();
        }
        function showdivissuedesign() {
            $("#div_issue").css("display", "block");
              $("#div_sim").css("display", "none");
              $("#div_Return").css("display", "none");
              $("#div_approval").css("display", "none");
        }
        function showdivReturndesign() {
            $("#div_issue").css("display", "none");
            $("#div_sim").css("display", "none");
            $("#div_Return").css("display", "block");
            $("#div_approval").css("display", "none");
        }
        function showdivapprove() {
            $("#div_issue").css("display", "none");
            $("#div_sim").css("display", "none");
            $("#div_Return").css("display", "none");
            $("#div_approval").css("display", "block");
            get_approveissue_details();
        }
        function showsimdesign() {
            forclearall();
            $("#div_simdata").hide();
            $("#fill_sim").show();
            $('#showlogs_sim').hide();
            forclearall();
        }
        function showissuedesign() {
            forclearall1();
            $("#div_Issuedata").hide();
            $("#fill_issue").show();
            $('#show_logs_Issue').hide();
        }
        function showReturndesign() {
            forclearall2();
            $("#div_ReturnData").hide();
            $("#fill_Return").show();
            $('#Show_Logs_Retrn').hide();
        }
        function canceldetails() {
          
            $("#div_simdata").show();
            $("#fill_sim").hide();
            $('#showlogs_sim').show();
            forclearall();
        }
        function cancelIssuedetails() {
            $("#div_Issuedata").show();
            $("#fill_issue").hide();
            $('#show_logs_Issue').show();
        }
        function cancelreturndetails() {
            $("#div_ReturnData").show();
            $("#fill_Return").hide();
            $('#Show_Logs_Retrn').show();
        }
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)
                return false;
            return true;
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        var empname_data = [];
        function get_Employeedetails() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    empname_data = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#selct_employe').autocomplete({
                        source: empnameList,
                        change: employeechange1,
                        autoFocus: true
                    });
                    $('#selct_employe1').autocomplete({
                        source: empnameList,
                        change: employeechange2,
                        autoFocus: true
                    });
                    $('#slct_emp').autocomplete({
                        source: empnameList,
                        change: employeechange3,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function employeechange1() {
            var empname = document.getElementById('selct_employe').value;
            for (var i = 0; i < empname_data.length; i++) {
                if (empname == empname_data[i].empname) {
                    document.getElementById('txtsupid').value = empname_data[i].empsno;
                    document.getElementById('txtempcode').value = empname_data[i].empnum;
                }
            }
        }
        function employeechange2() {
            var empname = document.getElementById('selct_employe1').value;
            for (var i = 0; i < empname_data.length; i++) {
                if (empname == empname_data[i].empname) {
                    document.getElementById('txtempid1').value = empname_data[i].empsno;
                    document.getElementById('txtempcode1').value = empname_data[i].empnum;
                }
            }
        }
        function employeechange3() {
            var empname = document.getElementById('slct_emp').value;
            for (var i = 0; i < empname_data.length; i++) {
                if (empname == empname_data[i].empname) {
                    document.getElementById('txt_id').value = empname_data[i].empsno;
                    document.getElementById('txt_code').value = empname_data[i].empnum;
                }
            }
        }
        var empname_data = [];
        function employeesim1() {
            var Phonenumber = document.getElementById('slct_phonenum').value;
            for (var i = 0; i < empname_sim.length; i++) {
                if (Phonenumber == empname_sim[i].Phonenumber) {
                    document.getElementById('txt_phno1').value = empname_sim[i].sno;
                 
                }
            }
        }
        function employeesim2() {
            var Phonenumber = document.getElementById('slct_phonenum').value;
            for (var i = 0; i < empname_sim.length; i++) {
                if (Phonenumber == empname_sim[i].Phonenumber) {
                    document.getElementById('txt_phon1').value = empname_sim[i].sno;
                   
                }
            }
        }
        function validateEmail(email) {
            var reg = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
            if (reg.test(email)) {
                return true;
            }
            else {
                  return false;
            }
        }
        function saveSimMaster() {
            var Networktype = document.getElementById('Selct_Network').value;
            if (Networktype == "Select Network") {
                $("#Selct_Network").focus();
                alert("Enter Networktype ");
                return false;
            }
            var Simno = document.getElementById('txt_SimNo').value;
            if (Simno == "") {
                $("#txt_SimNo").focus();
                alert("Enter Simno ");
                return false;
            }
            var Phonenumber = document.getElementById('txt_Phonenum').value;
            if (Simno == "") {
                $("#txt_Phonenum").focus();
                alert("Enter Phonenumber ");
                return false;
            }
            var Typeofsim = document.getElementById('Selct_Typesim').value;
            if (Typeofsim == "") {
                $("#Selct_Typesim").focus();
                alert("Enter Type of Sim ");
                return false;
            }
            var Remarks = document.getElementById('txt_Remarks').value;
            var sno = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_save').value;
            var data = { 'op': 'saveSimMaster', 'Networktype': Networktype, 'Simno': Simno, 'Phonenumber': Phonenumber, 'Typeofsim': Typeofsim, 'Remarks': Remarks, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_sim_details();
                        $('#div_simdata').show();
                        $('#fill_sim').css('display', 'none');
                        $('#showlogs_sim').css('display', 'block');
                        forclearall();
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
        function forclearall() {
            document.getElementById('Selct_Network').selectedIndex = 0;
            document.getElementById('txt_SimNo').value = "";
            document.getElementById('txt_Phonenum').value = "";
            document.getElementById('Selct_Typesim').selectedIndex = 0;
            document.getElementById('txt_Remarks').value = "";
            document.getElementById('lbl_sno').innerHTML = "";
            document.getElementById('btn_save').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
        }
        var empname_sim = [];
        function get_sim_details() {
            var data = { 'op': 'get_sim_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                        empname_sim = msg;
                        var empnamesimlist = [];
                        for (var i = 0; i < msg.length; i++) {
                            var Phonenumber = msg[i].Phonenumber;
                            empnamesimlist.push(Phonenumber);
                        }
                        $('#txt_phonenumbr1').autocomplete({
                            source: empnamesimlist,
                            change: employeesim1,
                            autoFocus: true
                        });
                        $('#slct_phonenum').autocomplete({
                            source: empnamesimlist,
                            change: employeesim2,
                            autoFocus: true
                        });
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
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Network Type</th><th scope="col">Phone Number</th><th scope="col">Type Of Sim</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<th scope="row" class="1" >' + msg[i].Networktype + '</th>';
                results += '<td scope="row" style="display:none" class="2" >' + msg[i].Simno + '</td>';
                results += '<td scope="row" class="3" >' + msg[i].Phonenumber + '</td>';
                results += '<td scope="row" class="4" >' + msg[i].Typeofsim + '</td>';
                results += '<td scope="row" style="display:none" class="5" >' + msg[i].Remarks + '</td>';
                results += '<td scope="row" class="6" style="display:none" >' + msg[i].status + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].sno + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 3) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_simdata").html(results);
        }
        function getme(thisid) {
            var Networktype = $(thisid).parent().parent().children('.1').html();
            var Simno = $(thisid).parent().parent().children('.2').html();
            var Phonenumber = $(thisid).parent().parent().children('.3').html();
            var Typeofsim = $(thisid).parent().parent().children('.4').html();
            var Remarks = $(thisid).parent().parent().children('.5').html();
            var status = $(thisid).parent().parent().children('.6').html();
            var sno = $(thisid).parent().parent().children('.7').html();
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('Selct_Network').value = Networktype;
            document.getElementById('txt_SimNo').value = Simno;
            document.getElementById('txt_Phonenum').value = Phonenumber;
            document.getElementById('Selct_Typesim').value = Typeofsim;
            document.getElementById('txt_Remarks').value = Remarks;
            document.getElementById('btn_save').innerHTML = "Modify";
            $("#div_simdata").hide();
            $("#fill_sim").show();
            $('#showlogs_sim').hide();
        }
        function save_IssueSim_Detailes() {
            var empcode = document.getElementById('txtempcode').value;
            var usedby = document.getElementById('txt_Usedby').value;
            if (usedby == "") {
                $("#txt_Usedby").focus();
                alert("Enter Used By ");
                return false;
            }
            var employeid = document.getElementById('txtsupid').value;
            if (employeid == "") {
                $("#txtsupid").focus();
                alert("Select Employee Name ");
                return false;
            }
            var Network = document.getElementById('Selct_Netwrok1').value;
            var Phonenumbr = document.getElementById('txt_phonenumbr1').value;
            var Approveby = document.getElementById('txtempid1').value;
            if (Approveby == "") {
                $("#txtempid1").focus();
                alert("Select Employee Name ");
                return false;
            }
            var Approvebycode = document.getElementById('txtempcode1').value;
            var limitby = document.getElementById('txt_Limt').value;
            var Remarks = document.getElementById('txt_Remarks1').value;
            var btnsave = document.getElementById('bttn_issuesave').innerHTML;
            var sno = document.getElementById('lbl_sno1').value;
            var approveemp = document.getElementById('lbl_approve').value;
            var data = { 'op': 'save_IssueSim_Detailes', 'usedby':usedby,'employeid': employeid, 'Approvebycode': Approvebycode, 'empcode': empcode, 'Network': Network, 'Phonenumbr': Phonenumbr, 'btnVal': btnsave, 'Approveby': Approveby, 'limitby': limitby, 'Remarks': Remarks, 'sno': sno, 'approveemp': approveemp };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_Issue_details();
                        $('#div_Issuedata').show();
                        $('#fill_issue').css('display', 'none');
                        $('#show_logs_Issue').css('display', 'block');
                        forclearall1();
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
        function get_Issue_details() {
            var data = { 'op': 'get_Issue_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillissuedetails(msg);
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
        function fillissuedetails(msg) {
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Used By</th><th scope="col">Employee Name</th><th scope="col">Phone No</th><th scope="col">Status</th><th scope="col">Limit</th><th scope="col">Approve By</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<th scope="row" class="12" >' + msg[i].usedby + '</th>';
                results += '<td scope="row" class="1" >' + msg[i].empname + '</td>';
                results += '<td scope="row" class="4" >' + msg[i].Phonenumber + '</td>';
                results += '<td scope="row" class="2" style="display:none" >' + msg[i].Networktype + '</td>';
                results += '<td scope="row" class="8"  >' + msg[i].status + '</td>';
                results += '<td scope="row"  class="3" >' + msg[i].limit + '</td>';
                results += '<td scope="row" class="10"   >' + msg[i].empname1 + '</td>';
//                results += '<td scope="row" class="10"  style="display:none" style="text-align:center;">' + msg[i].empname1 + '</td>';
                results += '<td scope="row" class="11"  style="display:none" >' + msg[i].empid1 + '</td>';
                results += '<td scope="row" class="5"  style="display:none" >' + msg[i].empcode + '</td>';
                results += '<td scope="row" class="6"   style="display:none" >' + msg[i].Remarks + '</td>';
                //results += '<td scope="row" class="12"   style="display:none" style="text-align:center;">' + msg[i].usedby + '</td>';
                results += '<td scope="row" style="display:none" class="7" >' + msg[i].employeid + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].sno + '</td>'
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getissue(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 3) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_Issuedata").html(results);
        }
        function get_approveissue_details() {
            var data = { 'op': 'get_approveissue_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillapprovedetails(msg);
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
        function fillapprovedetails(msg) {
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Employee Name</th><th scope="col">Limit</th><th scope="col">Phone No</th><th scope="col">Approve By</th><th scope="col"></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" >' + msg[i].empname + '</th>';
                results += '<td scope="row"  class="3" >' + msg[i].limit + '</td>';
                results += '<td scope="row" class="4" >' + msg[i].Phonenumber + '</td>';
                results += '<td scope="row" class="10"  >' + msg[i].empname1 + '</td>';
                results += '<td scope="row" class="2"  style="display:none" >' + msg[i].Networktype + '</td>';
                results += '<td scope="row" class="5"  style="display:none" >' + msg[i].empcode + '</td>';
                results += '<td scope="row" class="6"   style="display:none" >' + msg[i].Remarks + '</td>';
                results += '<td scope="row" style="display:none" class="7" >' + msg[i].employeid + '</td>';
                results += '<td scope="row" class="8" style="display:none" >' + msg[i].status + '</td>';
                results += '<td><button type="button" title="Click Here To Approve!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="save_Issuesim_approve_click(this)"><span class="glyphicon glyphicon-thumbs-up" style="top: 0px !important;"></span></button>';
                results += '<td style="display:none" class="9">' + msg[i].sno + '</td></tr>';
//                results += '<td></td></tr>';
                l = l + 1;
                if (l == 3) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_approvdata").html(results);
        }
        function save_Issuesim_approve_click(thisid) {
            sno = $(thisid).parent().parent().children('.9').html();
            var employeid = $(thisid).parent().parent().children('.7').html();
            var data = { 'op': 'save_Issuesim_approve_click', 'sno': sno, 'employeid': employeid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_approveissue_details();
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
        function getissue(thisid) {
            var empname = $(thisid).parent().parent().children('.1').html();
            var Networktype = $(thisid).parent().parent().children('.2').html();
            var Phonenumber = $(thisid).parent().parent().children('.4').html();
            var limit = $(thisid).parent().parent().children('.3').html();
            var Remarks = $(thisid).parent().parent().children('.6').html();
            var status = $(thisid).parent().parent().children('.8').html();
            var employeid = $(thisid).parent().parent().children('.7').html();
            var empcode = $(thisid).parent().parent().children('.5').html();
            var sno = $(thisid).parent().parent().children('.9').html();
            var empname1 = $(thisid).parent().parent().children('.10').html();
            var approveemp = $(thisid).parent().parent().children('.11').html();
            var usedby = $(thisid).parent().parent().children('.12').html();
            document.getElementById('selct_employe').value = empname;
            document.getElementById('Selct_Netwrok1').value = Networktype;
            document.getElementById('txt_phonenumbr1').value = Phonenumber;
            document.getElementById('txt_Limt').value = limit;
            document.getElementById('txt_Remarks1').value = Remarks;
            document.getElementById('txtempcode').value = empcode;
            document.getElementById('txtsupid').value = employeid;
            document.getElementById('selct_employe1').value = empname1;
            document.getElementById('txtempid1').value = approveemp;
            document.getElementById('txt_Usedby').value = usedby;
            document.getElementById('lbl_sno1').value = sno;
            document.getElementById('bttn_issuesave').innerHTML = "Modify";
            $("#div_Issuedata").hide();
            $("#fill_issue").show();
            $('#show_logs_Issue').hide();
        }
        function CloseClick() {
            $('#divMainAddNewRow').css('display', 'none');
        }
        function forclearall1() {
            document.getElementById('selct_employe').value = "";
            document.getElementById('txt_Usedby').value = "";
            document.getElementById('txtsupid').value = "";
            document.getElementById('txt_Limt').value = "";
            document.getElementById('txt_phonenumbr1').value = "";
            document.getElementById('selct_employe1').value = "";
            document.getElementById('txtempid1').value = "";
            document.getElementById('txtempcode1').value = "";
            document.getElementById('txt_Remarks1').value = "";
            document.getElementById('lbl_sno1').value = "";
            document.getElementById('Selct_Netwrok1').selectedIndex = 0;
            document.getElementById('bttn_issuesave').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
        }
        function save_Return_Master() {
            var empcode = document.getElementById('txt_code').value;
            var employeid = document.getElementById('txt_id').value;
            if (employeid == "") {
                alert("Select Employee Name ");
                document.getElementById('slct_emp').focus;
                $("#slct_emp").focus();
                return false;
            }
            var Phonenumber = document.getElementById('slct_phonenum').value;
            var Remarks = document.getElementById('txt_remarks1').value;
            var sno = document.getElementById('lbl_snoreturn').value;
            var btnval = document.getElementById('btn_retunsave').innerHTML;
            var data = { 'op': 'save_Return_Master', 'empcode': empcode, 'employeid': employeid, 'Phonenumber': Phonenumber, 'Remarks': Remarks, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_return_details();
                        $('#div_ReturnData').show();
                        $('#fill_Return').css('display', 'none');
                        $('#Show_Logs_Retrn').css('display', 'block');
                        forclearall2();
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
        function forclearall2() {
            document.getElementById('txt_code').value = "";
            document.getElementById('slct_emp').value = "";
            document.getElementById('txt_id').value = "";
            document.getElementById('slct_phonenum').value = "";
            document.getElementById('txt_remarks1').value = "";
            document.getElementById('lbl_snoreturn').innerHTML = "";
            document.getElementById('btn_retunsave').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
        }
        function get_return_details() {
            var data = { 'op': 'get_return_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillreturndetails(msg);
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
        function fillreturndetails(msg) {
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Employee Name</th><th scope="col">Return Date</th><th scope="col">Phone Number</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<th scope="row" class="1" >' + msg[i].empname + '</th>';
                results += '<td scope="row"  class="2" >' + msg[i].returndate + '</td>';
                results += '<td scope="row" class="3"  >' + msg[i].Phonenumber + '</td>';
                results += '<td scope="row" class="4" style="display:none" >' + msg[i].employeid + '</td>';
                results += '<td scope="row" style="display:none" class="5" >' + msg[i].Remarks + '</td>';
                results += '<td scope="row" class="6" style="display:none" >' + msg[i].empcode + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].sno + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getretunme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 3) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_ReturnData").html(results);
        }
        function getretunme(thisid) {
            var empname = $(thisid).parent().parent().children('.1').html();
            var returndate = $(thisid).parent().parent().children('.2').html();
            var Phonenumber = $(thisid).parent().parent().children('.3').html();
            var employeid = $(thisid).parent().parent().children('.4').html();
            var Remarks = $(thisid).parent().parent().children('.5').html();
            var empcode = $(thisid).parent().parent().children('.6').html();
            var sno = $(thisid).parent().parent().children('.7').html();

            document.getElementById('lbl_snoreturn').value = sno;
            document.getElementById('txt_code').value = empcode;
            document.getElementById('txt_id').value = employeid;
            document.getElementById('slct_phonenum').value = Phonenumber;
            document.getElementById('slct_emp').value = empname;
            document.getElementById('txt_remarks1').value = Remarks;
            document.getElementById('btn_retunsave').innerHTML = "Modify";
            $("#div_ReturnData").hide();
            $("#fill_Return").show();
            $('#Show_Logs_Retrn').hide();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Sim Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Sim Master</a></li>
        </ol>
    </section>
    <section>
        <section class="content">
            <div class="box box-info">
                <div>
                    <ul class="nav nav-tabs">
                        <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="show_simdesign()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;Sim Card Details</a></li>
                        <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showdivissuedesign()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Issue Card Details</a></li>
                             <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="showdivReturndesign()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Return Card Details</a></li>
                             <li id="Li2" class=""><a data-toggle="tab" href="#" onclick="showdivapprove()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Approve sim Card Details</a></li>
                    </ul>
                </div>
                 <div id="div_sim" >
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Sim Details
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="showlogs_sim" style="text-align: -webkit-right;">
                        <table>
                <tr>
                <td>
                <div class="input-group">
                    <div class="input-group-addon" >
                    <span class="glyphicon glyphicon-plus-sign"  onclick="showsimdesign()"></span> <span  onclick="showsimdesign()">Add Sim</span>
                </div>
                </div>
                </td>
                </tr>
                </table>
                        </div>
                        <div id="div_simdata">
                        </div>
                        <div id='fill_sim' style="display: none;">
                        <div style="float:left; padding-left:20px">
          <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img"
                                                                    src="Iconimages/simcard.png" alt="your image" style="border-radius: 5px; width: 200px;
                                                                    height: 200px; border-radius: 50%;" />
                                                                    </div>
                            <table align="center" style="width: 60%;">
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Network Type<span style="color: red;">*</span>
                                        </label>
                                    </td>
                                     <td>
                                        <select id="Selct_Network" class="form-control" style="margin: 0px; height: 35px; width: 200px;">
                                            <option value="Select Network">Select Network</option>
                                            <option value="Aircel">Aircel</option>
                                            <option value="AIRTEL">AIRTEL</option>
                                            <option value="IDEA">IDEA</option>
                                            <option value="Bsnl">Bsnl</option>
                                            <option value="Voda Phone">Vodafone</option>
                                            <option value="Tata Docomo">Tata Docomo</option>
                                            <option value="Reliance CDMA">Reliance CDMA</option>
                                            <option value="Reliance GSM">Reliance GSM</option>
                                           
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Sim Number
                                        </label>
                                    </td>
                                    <td>
                                      <input type="text" id="txt_SimNo" class="form_control" placeholder="Enter Sim Number" style="margin: 0px; height: 35px; width: 200px;"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Phone Number
                                        </label>
                                    </td>
                                    <td>
                                      <input type="text" id="txt_Phonenum" class="form_control" placeholder="Enter Phone Number" style="margin: 0px; height: 35px; width: 200px;" onkeypress="return isNumber(event)" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                       Type Of Sim<span style="color: red;">*</span>
                                       </label>
                                    </td>
                                     <td>
                                        <select id="Selct_Typesim" class="form-control" style="margin: 0px; height: 35px; width: 200px;">
                                           <option value="Select Network">Select Network</option>
                                            <option value="VTS">VTS</option>
                                            <option value="Dongle">Dongle</option>
                                            <option value="DPU">DPU</option>
                                             <option value="TAB">TAB</option>
                                            <option value="Voice Calling">Voice Calling</option>
                                        </select>
                                    </td>
                                </tr>
                                 <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Remarks
                                        </label>
                                    </td>
                                    <td>
                                      <textarea  cols="30" rows="3" id="txt_Remarks" class="form_control" placeholder="Enter Remarks"   ></textarea>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                              
                            </table>
                            <br />
                            <table align="center">
                            <tr>
                              <td>
                                <div class="input-group">
                                        <div class="input-group-addon" >
                                             <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="saveSimMaster()"></span> <span id="btn_save" onclick="saveSimMaster()">save</span>
                                        </div>
                               </div>
                            </td>
                            <td width="2%"></td>
                            <td>
                                <div class="input-group">
                                    <div class="input-group-close" >
                                        <span class="glyphicon glyphicon-remove" id='btn_close1' onclick="canceldetails()"></span> <span id='btn_close' onclick="canceldetails()">Close</span>
                                    </div>
                                </div>
                            </td>
                           </tr>
                            </table>
                        </div>

                        </div>
                        </div>
                    
                <div id="div_issue" style="display: none;">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Sim Issue Details
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="show_logs_Issue" style="text-align: -webkit-right;" >
                        <table>
                        <tr>
                        <td>
                        <div class="input-group">
                            <div class="input-group-addon" >
                            <span class="glyphicon glyphicon-plus-sign"  onclick="showissuedesign()"></span> <span  onclick="showissuedesign()">Add Issue Sim</span>
                        </div>
                        </div>
                </td>
                </tr>
                </table>
                        </div>
                        <div id="div_Issuedata">
                        </div>
                        <div id='fill_issue' style="display: none;">
                        <div style="float:left; padding-left:20px">
          <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="Img1"
                                                                    src="Iconimages/issuesim.png" alt="your image" style="border-radius: 5px; width: 200px;
                                                                    height: 200px; border-radius: 50%;" />
                                                                    </div>
                            <table align="center" style="width: 60%;">
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                     Used Purpose
                                     </label>
                                    </td>
                                    <td>
                                      <input type="text" id="txt_Usedby" class="form_control" placeholder="Enter Used purpose" style="text-transform: capitalize;width: 200px;"  />
                                    </td>
                                </tr>
                                <tr>
                                     <td>
                                       <label class="control-label" >
                                                Employee Name
                                                </label>
                                            </td>
                                            <td>
                                                <input type="text" class="form-control" style="margin: 0px; height: 35px; width: 200px;" id="selct_employe" placeholder="Enter Employee Name"
                                                    onkeypress="return ValidateAlpha(event);" />
                                            </td>
                                            <td style="height: 40px;">
                                                <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                                            </td>
                                            <td style="height: 40px;">
                                                <input id="txtempcode" type="hidden" class="form-control" name="hiddenempid" />
                                            </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Network Types
                                        </label>
                                    </td>
                                    <td>
                                        <select id="Selct_Netwrok1" class="form-control" style="margin: 0px; height: 35px; width: 200px;">
                                           <option value="Select Network">Select Network</option>
                                            <option value="Aircel">Aircel</option>
                                            <option value="AIRTEL">AIRTEL</option>
                                            <option value="IDEA">IDEA</option>
                                            <option value="Bsnl">Bsnl</option>
                                            <option value="Voda Phone">Vodafone</option>
                                            <option value="Tata Docomo">Tata Docomo</option>
                                            <option value="Reliance CDMA">Reliance CDMA</option>
                                            <option value="Reliance GSM">Reliance GSM</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Phone Number
                                        </label>
                                    </td>
                                   
                                      <td>
                                        <input type="text" class="form-control" id="txt_phonenumbr1" placeholder="Enter Phone Number"  style="margin: 0px; height: 35px; width: 200px;"   onkeypress="return isNumber(event);"/>
                                           
                                    </td>
                                     <td style="display: none">
                                        <input id="txt_phno" type="hidden" class="form-control" name="hiddenempid" />
                                    </td>
                                </tr>
                                 <tr>
                                    <td style="height: 40px;">
                                     <label class="control-label" >
                                       Approve By
                                       </label>
                                    </td>
                                    <td>
                                        <input type="text" class="form-control" id="selct_employe1" placeholder="Enter Employe Name" style="margin: 0px; height: 35px; width: 200px;"
                                            onkeypress="return ValidateAlpha(event);" />
                                    </td>
                                    <td style="display: none">
                                        <input id="txtempid1" type="hidden" class="form-control" name="hiddenempid" />
                                    </td>
                                    <td style="display: none">
                                        <input id="txtempcode1" type="hidden" class="form-control" name="hiddenempid" />
                                    </td>
                                </tr>
                                 <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                      Limit
                                      </label>
                                    </td>
                                    <td>
                                      <input type="text" id="txt_Limt" class="form_control" placeholder="Enter Limit" style="margin: 0px; height: 35px; width: 200px;" onkeypress="return isNumber(event);" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Remarks
                                        </label>
                                    </td>
                                    <td>
                                      <textarea  cols="30" rows="3" id="txt_Remarks1" class="form_control" placeholder="Enter Remarks" ></textarea>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td>
                                        <label id="lbl_sno1">
                                        </label>
                                    </td>
                                    <td>
                                    <label id="lbl_approve">
                                    </label>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <table align="center">
                            <tr>
                              <td >
                    <div class="input-group">
                                <div class="input-group-addon" >
                                <span class="glyphicon glyphicon-ok" id="bttn_issuesave1" onclick="save_IssueSim_Detailes()"></span> <span id="bttn_issuesave" onclick="save_IssueSim_Detailes()">save</span> 
                             </div>
                    </td>
                    <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-addon" style="border-color:#D9534F;background-color: #D9534F;border-radius: 4px;color: whitesmoke;">
                                <span class="glyphicon glyphicon-remove" id='btn_cancel1' onclick="cancelIssuedetails()"></span> <span id='btn_cancel' onclick="cancelIssuedetails()">Close</span>
                          </div>
                    </td>
                            </tr>
                  
                    </table>
                       </div>
                    </div>
            </div>
                
                <div id="div_Return" style="display: none;">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Sim Return Details
                        </h3>
                    </div>
                    <div class="box-body">

                        <div id="Show_Logs_Retrn" style="text-align: -webkit-right;">
                          <table>
                <tr>
                <td>
                <div class="input-group">
                                <div class="input-group-addon" >
                                <span class="glyphicon glyphicon-plus-sign"  onclick="showReturndesign()"></span> <span  onclick="showReturndesign()">Add Return Sim</span>
                          </div>
                          </div>
               
                </td>
                </tr>
                </table>
                        </div>
                        <div id="div_ReturnData">
                        </div>
                        <div id="fill_Return" style="display: none;">
                            <table align="center">
                                <tr>
                                    <th>
                                    </th>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Employee Name
                                        </label>
                                    </td>
                                    <td>
                                                <input type="text" class="form-control" id="slct_emp" placeholder="Enter Employee Name"
                                                    onkeypress="return ValidateAlpha(event);" />
                                            </td>
                                            <td style="height: 40px;">
                                                <input id="txt_id" type="hidden" class="form-control" name="hiddenempid" />
                                            </td>
                                            <td style="height: 40px;">
                                                <input id="txt_code" type="hidden" class="form-control" name="hiddenempid" />
                                            </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Phone Number
                                        </label>
                                    </td>
                                      <td>
                                        <input type="text" class="form-control" id="slct_phonenum" placeholder="Enter Phone Number" onkeypress="return isNumber(event);"
                                           />
                                    </td>
                                     <td style="display: none">
                                        <input id="txt_phon1" type="hidden" class="form-control" name="hiddenempid" />
                                    </td>
                                </tr>
                                 <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Remarks
                                        </label>
                                    </td>
                                    <td>
                                      <textarea  cols="26" rows="3" id="txt_remarks1" class="form_control" placeholder="Enter Remarks" style="width: 86%;" ></textarea>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td>
                                        <label id="lbl_snoreturn">
                                        </label>
                                    </td>
                                </tr>
                                
                            </table>
                           <br />
                            <table align="center">
                            <tr>
                              <td >
                        <div class="input-group">
                                <div class="input-group-addon" >
                                <span class="glyphicon glyphicon-ok" id="btn_retunsave1" onclick="save_Return_Master()"></span> <span id="btn_retunsave" onclick="save_Return_Master()">save</span>
                             </div>
                             </div>
                    </td>
                    <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close">
                                <span class="glyphicon glyphicon-remove" id='bt_close1' onclick="cancelreturndetails()"></span> <span id='bt_close' onclick="cancelreturndetails()">Close</span>
                          </div>
                          </div>
                    </td>
                            </tr>
                  
                    </table>
                    </div>
                </div>
                </div>

                <div id="div_approval" style="display: none;">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Sim Approve Details 
                </h3>
            </div>
            <div class='divcontainer' style="overflow: auto;">
                <div id="div_approvdata">
                </div>
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
                                 <label class="control-label" >
                                    Remarks</label>
                            </td>
                            <td style="height: 40px;">
                                <textarea id="Textarea1" type="text" class="form-control" name="Remarks" placeholder="Enter Remarks"></textarea>
                            </td>
                        </tr>
                        <tr>
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
        </section>
    </section>
</asp:Content>