<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="deductionsmaster.aspx.cs" Inherits="deductionsmaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_Employeedetails();
            get_tds_details();
            get_medicliem_details();
            $("#showdivtds").css("display", "block");
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txt_Dateoff').val(today);
            $('#txt_Datedamge').val(today);
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
        function showdivtds() {
            //forclearall();
            //cancelbankdetails();
            $("#div_Medicliem").css("display", "none");
            $("#div_tds").css("display", "block");
        }
        function showdivmidicliam() {
            // cancelbankdetails();
            $("#div_Medicliem").css("display", "block");
            $("#div_tds").css("display", "none");
        }
        function showdivtraval() {
            // cancelbankdetails();
            $("#div_Medicliem").css("display", "none");
            $("#div_tds").css("display", "none");
            $("#div_travel").css("display", "block");
        }

        function showdamgedesign() {
            $("#div_mediclaimdata").hide();
            $("#div_fillmedicliam").show();
            $('#show_logs_Damage').hide();
        }
        function showtravaldesign() {
            $("#div_mediclaimdata").hide();
            $("#div_fillmedicliam").hide();
            $('#show_logs_Damage').hide();
            $('#div_filltravel').show();
        }
        
        function showdesign() {
            $("#div_tdsdata").hide();
            $("#fillform").show();
            $('#showlogs').hide();
            //forclearall();
            //cancelbankdetails();
        }

        function canceldetails() {
            forclearall1();
            $("#div_tdsdata").show();
            $("#fillform").hide();
            $('#showlogs').show();
        }

        function canceldamagedetails() {
            forclearall();
            $("#div_mediclaimdata").show();
            $("#div_fillmedicliam").hide();
            $('#show_logs_Damage').show();
        }
        function canceltraveldetails() {
            forclearall();
            $("#div_mediclaimdata").hide();
            $("#div_fillmedicliam").hide();
            $('#show_logs_Damage').hide();
            $('#div_filltravel').hide();
            $('#div_travel').show();
           // $('#div_filltravel').hide();
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
                    $('#selct_employe2').autocomplete({
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
                    document.getElementById('txtempid').value = empname_data[i].empsno;
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
            var empname = document.getElementById('selct_employe2').value;
            for (var i = 0; i < empname_data.length; i++) {
                if (empname == empname_data[i].empname) {
                    document.getElementById('txtempid2').value = empname_data[i].empsno;
                    document.getElementById('txtempcode2').value = empname_data[i].empnum;
                }
            }
        }
        function save_edit_tds() {
            var employeid = document.getElementById('txtempid').value;
            var empcode = document.getElementById('txtempcode').value;
            if (employeid == "") {
                alert("Select Employee Name");
                $('#selct_employe').focus();
                return false;
            }
            var date = document.getElementById('txt_Dateoff').value;
            var amount = document.getElementById('txt_amount').value;
            if (amount == "") {
                alert("Enter Amount");
                $('#txt_amount').focus();
                return false;
            }
            var remarks = document.getElementById('txt_remarks').value;
            var sno = document.getElementById('lbl_sno').innerHTML;
            var btnval = document.getElementById('btn_save').innerHTML;
            var data = { 'op': 'save_edit_tds', 'employeid': employeid, 'empcode': empcode, 'date': date, 'amount': amount, 'remarks': remarks, 'sno': sno, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_tds_details();
                        $('#div_tdsdata').show();
                        $('#fillform').css('display', 'none');
                        $('#showlogs').css('display', 'block');
                        forclearall1();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
      
        function get_tds_details() {
            var data = { 'op': 'get_tds_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                        forclearall1(msg);
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
            var results = '<div  style="overflow:auto;"><table id= "tbl_empmaster" class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >EmployeeCode</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">TDS Amount</th><th scope="col">Date</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td>' + k++ + '</td>';
                results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
                results += '<td data-title="Code" class="9">' + msg[i].fullname + '</td>';
                //results += '<td  class="4">' + msg[i].NameofPerson + '</td>';
                results += '<td   class="5">' + msg[i].AmountOffine + '</td>';
//                results += '<td   class="3">' + msg[i].month + '</td>';
                results += '<td  class="7">' + msg[i].date + '</td>';
                //results += '<td  style="display:none"  class="6">' + msg[i].Finestatus + '</td>';
                results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
                //results += '<td style="display:none" class="7">' + msg[i].daterelised + '</td>';
                results += '<td style="display:none" class="8">' + msg[i].sno + '</td>';
                results += '<td style="display:none" class="10">' + msg[i].remarks + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
            }
            results += '</table></div>';
            $("#div_tdsdata").html(results);
        }
        function getme(thisid) {
            var fullname = $(thisid).parent().parent().children('.9').html();
            var employeid = $(thisid).parent().parent().children('.2').html();
            var date = $(thisid).parent().parent().children('.7').html();
            //var date = $(thisid).parent().parent().children('.3').html();
            //var Finestatus = $(thisid).parent().parent().children('.6').html();
            //var NameofPerson = $(thisid).parent().parent().children('.4').html();
            var AmountOffine = $(thisid).parent().parent().children('.5').html();
            //var daterelised = $(thisid).parent().parent().children('.7').html();
            var sno = $(thisid).parent().parent().children('.8').html();
            var remarks = $(thisid).parent().parent().children('.10').html();
            var empcode = $(thisid).parent().parent().children('.1').html();

            document.getElementById('selct_employe').value = fullname;
            document.getElementById('txtempid').value = employeid;
            document.getElementById('txt_Dateoff').value = date;
           // document.getElementById('txt_Act').value = Actwhichfine;
           // document.getElementById('ddlfine').value = Finestatus;
           // document.getElementById('txt_nameperson').value = NameofPerson;
            document.getElementById('txt_amount').value = AmountOffine;
           // document.getElementById('txt_dateRelised').value = daterelised;
            document.getElementById('txtempcode').value = empcode;
            document.getElementById('txt_remarks').value = remarks;
            document.getElementById('lbl_sno').innerHTML = sno;
            document.getElementById('btn_save').innerHTML = "Modify";
            $("#div_tdsdata").hide();
            $("#fillform").show();
            $('#showlogs').hide();
        }

        function forclearall1() {
            document.getElementById('selct_employe').value = "";
            document.getElementById('txtempid').value = "";
            document.getElementById('txt_Dateoff').value = "";
            //document.getElementById('txt_Act').value = "";
            //document.getElementById('ddlfine').value = "";
            //document.getElementById('txt_nameperson').value = "";
            document.getElementById('txt_amount').value = "";
            //document.getElementById('txt_dateRelised').value = "";
            document.getElementById('txtempcode').value = "";
            //document.getElementById('txt_remarks').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('btn_save').innerHTML = "save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
        }


        function save_edit_travell() {

            var employeid = document.getElementById('txtempid2').value;
            if (employeid == "") {
                alert("Select Employee Name  ");
                $('#selct_employe1').focus();
                return false;
            }
            var empcode = document.getElementById('txtempcode2').value;
            var date = document.getElementById('txttraveldate').value;
            var AmountOfDeduction = document.getElementById('txttamt').value;
            if (AmountOfDeduction == "") {
                alert("Select Amount");
                $('#txt_Amountdedu').focus();
                return false;
            }
            var remarks = document.getElementById('txttrmks').value;
            var flag = document.getElementById('txttflag').value;
            var sno = document.getElementById('lbltmsg').innerHTML;
            var btnval = document.getElementById('btn_savedamge2').innerHTML;
            var data = { 'op': 'save_edit_travel', 'employeid': employeid, 'date': date, 'AmountOfDeduction': AmountOfDeduction, 'remarks': remarks, 'empcode': empcode, 'flag': flag, 'btnval': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                       // get_trval_details();
                        $('#div_mediclaimdata').css('display', 'none');
                        $('#div_fillmedicliam').css('display', 'none');
                        $('#show_logs_Damage').css('display', 'none');
                        $('#show_logs_travel').css('display', 'block');
                        $('#div_travalingdata').show();
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



        function save_edit_medicliems() {
            
            var employeid = document.getElementById('txtempid1').value;
            if (employeid == "") {
                alert("Select Employee Name  ");
                $('#selct_employe1').focus(); 
                return false;
            }
            var empcode = document.getElementById('txtempcode1').value;
            var date = document.getElementById('txt_Datedamge').value;
            var AmountOfDeduction = document.getElementById('txt_Amountdedu').value;
            if (AmountOfDeduction == "") {
                alert("Select Amount");
                $('#txt_Amountdedu').focus();
                return false;
            }
            var remarks = document.getElementById('txt_Remarks').value;
            var flag = document.getElementById('txt_flag').value;
            var sno = document.getElementById('lbl_sno').innerHTML;
            var btnval = document.getElementById('btn_savedamge').innerHTML;
            var data = { 'op': 'save_edit_medicliems', 'employeid': employeid, 'date': date, 'AmountOfDeduction': AmountOfDeduction, 'remarks': remarks, 'empcode': empcode,'flag':flag, 'btnval': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_medicliem_details();
                        $('#div_mediclaimdata').show();
                        $('#div_fillmedicliam').css('display', 'none');
                        $('#show_logs_Damage').css('display', 'block');
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
        function get_medicliem_details() {
            var data = { 'op': 'get_medicliem_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillmedicliemdetails(msg);
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
        function fillmedicliemdetails(msg) {
            var k = 1;
            var results = '<div  style="overflow:auto;"><table id="tbl_empmaster1" class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >EmployeeCode</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Amount</th><th scope="col">Date</th><th scope="col">Flag</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td>' + k++ + '</td>';
                results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
                results += '<td data-title="Code" class="2">' + msg[i].fullname + '</td>';
                results += '<td  class="4">' + msg[i].AmountOfDeduction + '</td>';
//                results += '<td   class="9">' + msg[i].month + '</td>';
                results += '<td  class="3">' + msg[i].date + '</td>';
                results += '<td  style="display:none" class="5">' + msg[i].employeid + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].sno + '</td>';
                results += '<td style="display:none" class="8">' + msg[i].remarks + '</td>';
                results += '<td  class="9">' + msg[i].flag + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getmee(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
            }
            results += '</table></div>';
            $("#div_mediclaimdata").html(results);
        }
        function getmee(thisid) {
            var fullname = $(thisid).parent().parent().children('.2').html();
            var employeid = $(thisid).parent().parent().children('.5').html();
            var date = $(thisid).parent().parent().children('.3').html();
            var AmountOfDeduction = $(thisid).parent().parent().children('.4').html();
            var sno = $(thisid).parent().parent().children('.7').html();
            var empcode = $(thisid).parent().parent().children('.1').html();
            var remarks = $(thisid).parent().parent().children('.8').html();
            var flag = $(thisid).parent().parent().children('.9').html();
            document.getElementById('selct_employe1').value = fullname;
            document.getElementById('txtempid1').value = employeid;
            document.getElementById('txt_Datedamge').value = date;
            document.getElementById('txt_Amountdedu').value = AmountOfDeduction;
            document.getElementById('txtempcode1').value = empcode;
            document.getElementById('txt_Remarks').value = remarks;
            document.getElementById('txt_flag').value = flag;
            document.getElementById('lbl_sno').innerHTML = sno;
            document.getElementById('btn_savedamge').innerHTML = "Modify";
            $("#div_mediclaimdata").hide();
            $("#div_fillmedicliam").show();
            $('#show_logs_Damage').hide();
        }
        function forclearall() {
            canceldetails();
            document.getElementById('selct_employe1').value = "";
            document.getElementById('txtempid1').value = "";
            document.getElementById('txt_Datedamge').value = "";
            document.getElementById('txt_Amountdedu').value = "";
            document.getElementById('txtempcode1').value = "";
            document.getElementById('txt_Remarks').value = "";
            document.getElementById('btn_savedamge').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
        }
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
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
            Deductions
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Deductions</a></li>
        </ol>
    </section>
    <section>
        <section class="content">
            <div class="box box-info">
                <div>
                    <ul class="nav nav-tabs">
                        <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showdivtds()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;TDS Deduction</a></li>
                        <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showdivmidicliam()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Mediclaim Deduction</a></li>
                        <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="showdivtraval()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Travaling Expences</a></li>
                    </ul>
                </div>
                <div id="div_tds">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>TDS Details
                        </h3>
                    </div>

                    <div class="box-body">
                      
                           <div class="input-group" id="showlogs" style="width: 10%;padding-left:90%;">
                                    <div class="input-group-addon"  id="btn_addbank"  >
                                            <span class="glyphicon glyphicon-plus-sign" ></span> <span  onclick="showdesign()">Add TDS</span>
                                    </div>
                                </div>
                         
                         <div id="div_tdsdata">
                        </div>
                         
                       
                        
                        <div id='fillform' style="display: none;">
                            <table  align="center" style="width: 60%;">
                                <tr>
                                    <td>
                                      <label class="control-label" >
                                        Employee Name
                                        </label>
                                    </td>
                                    <td>
                                        <input type="text" class="form-control" id="selct_employe" placeholder="Enter Employe Name"
                                            onkeypress="return ValidateAlpha(event);" />
                                    </td>
                                    <td style="display: none">
                                        <input id="txtempid" type="hidden" class="form-control" name="hiddenempid" />
                                    </td>
                                    <td style="display: none">
                                        <input id="txtempcode" type="hidden" class="form-control" name="hiddenempid" />
                                    </td>
                                    <td>
                                      <label class="control-label" >
                                        Date of Tds
                                        </label>
                                    </td>
                                    <td>
                                         <input type="date" class="form-control" id="txt_Dateoff"  />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                      <label class="control-label" >
                                       Amount
                                       </label>
                                    </td>
                                    <td>
                                        <input type="text" class="form-control" id="txt_amount" placeholder="Enter Amount of deduction" />
                                    </td>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Remark
                                        </label>
                                    </td>
                                    <td colspan="3">
                                        <textarea name="comments" class="form-control" id="txt_remarks" placeholder="Enter Remarks"></textarea>
                                    </td>
                                </tr>
                                
                                <tr style="display: none;">
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <table align="center">
                            <tr >
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-ok" id="btn_save1"  onclick="save_edit_tds()"></span><span id="btn_save" onclick="save_edit_tds()">Save</span>
                                        </div>
                                    </div>
                                </td>
                                <td style="width:10px;"></td>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id="btn_close1" onclick="canceldetails()"></span><span id="btn_close" onclick="canceldetails()">Close</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        </div>
                    </div>
                </div>
                <div id="div_Medicliem" style="display: none;">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Mediclaim Details
                        </h3>
                    </div>
                    <div class="box-body">
                        <div class="input-group" id="show_logs_Damage" style="width: 10%;padding-left:85%;">
                                    <div class="input-group-addon"   >
                                            <span class="glyphicon glyphicon-plus-sign" ></span> <span  onclick="showdamgedesign()">Add Medicliem</span>
                                    </div>
                                </div>
                        <div id="div_mediclaimdata">
                        </div>
                        
                        <div id='div_fillmedicliam'style="display: none;">
                            <table align="center" style="width: 60%;">
                                <tr>
                                    <td>
                                      <label class="control-label" >
                                        Employee Name
                                        </label>
                                    </td>
                                    <td>
                                        <input type="text" class="form-control" id="selct_employe1" placeholder="Enter Employe Name"
                                            onkeypress="return ValidateAlpha(event);" />
                                    </td>
                                    <td style="display: none">
                                        <input id="txtempid1" type="hidden" class="form-control" name="hiddenempid" />
                                    </td>
                                    <td style="display: none">
                                        <input id="txtempcode1" type="hidden" class="form-control" name="hiddenempid" />
                                    </td>
                                    <td>
                                      <label class="control-label" >
                                        Date of Mediclaim
                                        </label>
                                    </td>
                                    <td>
                                        <input type="date" class="form-control" id="txt_Datedamge"  />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                      <label class="control-label" >
                                        Amount 
                                        </label>
                                    </td>
                                    <td>
                                        <input type="text" class="form-control" id="txt_Amountdedu" placeholder="Enter Amount of deduction" />
                                    </td>
                                      <td style="height: 40px;">
                                        <label class="control-label" >
                                        Remarks
                                        </label>
                                    </td>
                                    <td colspan="3">
                                        <textarea name="comments" class="form-control" id="txt_Remarks" placeholder="Enter Bank address"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                <td>
                                      <label class="control-label" >
                                       Flag
                                       </label>
                                    </td>
                                    <td>
                                        <input type="text" class="form-control" id="txt_flag" placeholder="Enter Flag Number" />
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
                            <tr >
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-ok" id="btn_savedamge1"  onclick="save_edit_medicliems()"></span><span id="btn_savedamge" onclick="save_edit_medicliems()">Save</span>
                                        </div>
                                    </div>
                                </td>
                                <td style="width:10px;"></td>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id="Button31" onclick="canceldamagedetails()"></span><span id="Button3" onclick="canceldamagedetails()">Close</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        </div>
                    </div>
                </div>


                <div id="div_travel" style="display: none;">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Travaling Details
                        </h3>
                    </div>
                    <div class="box-body">
                        <div class="input-group" id="show_logs_travel" style="width: 10%;padding-left:85%;">
                                    <div class="input-group-addon"   >
                                            <span class="glyphicon glyphicon-plus-sign" ></span> <span  onclick="showtravaldesign()">Add Travaling</span>
                                    </div>
                                </div>
                        <div id="div_travalingdata">
                        </div>
                        
                        <div id="div_filltravel" style="display: none;">
                            <table align="center" style="width: 60%;">
                                <tr>
                                    <td>
                                      <label class="control-label" >
                                        Employee Name
                                        </label>
                                    </td>
                                    <td>
                                        <input type="text" class="form-control" id="selct_employe2" placeholder="Enter Employe Name"
                                            onkeypress="return ValidateAlpha(event);" />
                                    </td>
                                    <td style="display: none">
                                        <input id="txtempcode2" type="hidden" class="form-control" name="hiddenempid" />
                                    </td>
                                    <td style="display: none">
                                        <input id="txtempid2" type="hidden" class="form-control" name="hiddenempid" />
                                    </td>
                                    <td>
                                      <label class="control-label" >
                                        Date of Effect
                                        </label>
                                    </td>
                                    <td>
                                        <input type="date" class="form-control" id="txttraveldate"  />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                      <label class="control-label" >
                                        Amount 
                                        </label>
                                    </td>
                                    <td>
                                        <input type="text" class="form-control" id="txttamt" placeholder="Enter Amount of deduction" />
                                    </td>
                                      <td style="height: 40px;">
                                        <label class="control-label" >
                                        Remarks
                                        </label>
                                    </td>
                                    <td colspan="3">
                                        <textarea name="comments" class="form-control" id="txttrmks" placeholder="Enter Bank address"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                <td>
                                      <label class="control-label" >
                                       Flag
                                       </label>
                                    </td>
                                    <td>
                                        <input type="text" class="form-control" id="txttflag" placeholder="Enter Flag Number" />
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td>
                                        <label id="lbltmsg">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <table align="center">
                            <tr >
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-ok" id="btn_savedamge3"  onclick="save_edit_travell()"></span><span id="btn_savedamge2" onclick="save_edit_travell()">Save</span>
                                        </div>
                                    </div>
                                </td>
                                <td style="width:10px;"></td>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id="Span3" onclick="canceltraveldetails()"></span><span id="Span4" onclick="canceltraveldetails()">Close</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </section>
</asp:Content>

