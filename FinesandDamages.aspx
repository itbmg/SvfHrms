<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="FinesandDamages.aspx.cs" Inherits="FinesandDamages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_Employeedetails();
            get_fine_details();
            get_Damage_details();
            $("#showdivfines").css("display", "block");
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
        function showdivfines() {
            $("#div_Damages").css("display", "none");
            $("#div_fines").css("display", "block");
        }
        function showdivDamges() {
            $("#div_Damages").css("display", "block");
            $("#div_fines").css("display", "none");
        }

        function showdamgedesign() {
            forclearall();
            $("#div_Damagedata").hide();
            $("#div_filldamage").show();
            $('#show_logs_Damage').hide();
        }


        function showdesign() {
            forclearall1();
            $("#div_Finedata").hide();
            $("#fillform").show();
            $('#showlogs').hide();
           
        }

        function canceldetails() {
            forclearall1();
            $("#div_Finedata").show();
            $("#fillform").hide();
            $('#showlogs').show();
        }

        function canceldamagedetails() {
            forclearall();
            $("#div_Damagedata").show();
            $("#div_filldamage").hide();
            $('#show_logs_Damage').show();
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
                    $('#selct_damageemploye').autocomplete({
                        source: empnameList,
                        change: employeechange2,
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
            var empname = document.getElementById('selct_damageemploye').value;
            for (var i = 0; i < empname_data.length; i++) {
                if (empname == empname_data[i].empname) {
                    document.getElementById('txt_Damagempid').value = empname_data[i].empsno;
                    document.getElementById('txt_Damgempcode').value = empname_data[i].empnum;
                }
            }
        }


        function save_edit_Fines() {
            
            var employeid = document.getElementById('txtempid').value;
            var empcode = document.getElementById('txtempcode').value;
            if (employeid == "") {
                alert("Select Employee Name ");
                document.getElementById('selct_employe').focus();
                return false;
            }
            var dateofOfference = document.getElementById('txt_Dateoff').value;
            var Actwhichfine = document.getElementById('txt_Act').value;
            var Finestatus = document.getElementById('ddlfine').value;
            var NameofPerson = document.getElementById('txt_nameperson').value;
            var AmountOffine = document.getElementById('txt_Amount').value;
            var daterelised = document.getElementById('txt_dateRelised').value;
            var remarks = document.getElementById('txt_remarks').value;
            var sno = document.getElementById('lbl_snof').innerHTML;
            var btnval = document.getElementById('btn_save').innerHTML;
            var data = { 'op': 'save_edit_Fines', 'employeid': employeid, 'dateofOfference': dateofOfference, 'Actwhichfine': Actwhichfine, 'Finestatus': Finestatus, 'NameofPerson': NameofPerson, 'daterelised': daterelised, 'AmountOffine': AmountOffine, 'remarks': remarks, 'empcode': empcode, 'btnval': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_fine_details();
                        $('#div_Finedata').show();
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
        function get_fine_details() {
            var data = { 'op': 'get_fine_details' };
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
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Name of Person</th><th scope="col">Date of Offence</th><th scope="col">Actwhichfine</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
                results += '<td data-title="Code" class="9">' + msg[i].fullname + '</td>';
                results += '<td  class="4">' + msg[i].NameofPerson + '</td>';
                results += '<td  class="15">' + msg[i].dateofOfference + '</td>';
                results += '<td   class="3">' + msg[i].Actwhichfine + '</td>';
                results += '<td  style="display:none"  class="6">' + msg[i].Finestatus + '</td>';
                results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
                results += '<td  style="display:none" class="5">' + msg[i].AmountOffine + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].daterelised + '</td>';
                results += '<td style="display:none" class="8">' + msg[i].sno + '</td>';
                results += '<td style="display:none" class="10">' + msg[i].remarks + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 3) {
                    l = 0;
                }
            }

            results += '</table></div>';
            $("#div_Finedata").html(results);
        }
        function getme(thisid) {
            var fullname = $(thisid).parent().parent().children('.9').html();
            var employeid = $(thisid).parent().parent().children('.2').html();
            var dateofOfference = $(thisid).parent().parent().children('.7').html();
            var Actwhichfine = $(thisid).parent().parent().children('.3').html();
            var Finestatus = $(thisid).parent().parent().children('.6').html();
            var NameofPerson = $(thisid).parent().parent().children('.4').html();
            var AmountOffine = $(thisid).parent().parent().children('.5').html();
            var daterelised = $(thisid).parent().parent().children('.7').html();
            var sno = $(thisid).parent().parent().children('.8').html();
            var remarks = $(thisid).parent().parent().children('.10').html();
            var empcode = $(thisid).parent().parent().children('.1').html();

            document.getElementById('selct_employe').value = fullname;
            document.getElementById('txtempid').value = employeid;
            document.getElementById('txt_Dateoff').value = dateofOfference;
            document.getElementById('txt_Act').value = Actwhichfine;
            document.getElementById('ddlfine').value = Finestatus;
            document.getElementById('txt_nameperson').value = NameofPerson;
            document.getElementById('txt_Amount').value = AmountOffine;
            document.getElementById('txt_dateRelised').value = daterelised;
            document.getElementById('txtempcode').value = empcode;
            document.getElementById('txt_remarks').value = remarks;
            document.getElementById('lbl_snof').innerHTML = sno;
            document.getElementById('btn_save').innerHTML = "Modify";
            $("#div_Finedata").hide();
            $("#fillform").show();
            $('#showlogs').hide();
        }

        function forclearall1() {
            document.getElementById('selct_employe').value = "";
            document.getElementById('txtempid').value = "";
            document.getElementById('txt_Dateoff').value = "";
            document.getElementById('txt_Act').value = "";
            document.getElementById('ddlfine').value = "";
            document.getElementById('txt_nameperson').value = "";
            document.getElementById('txt_Amount').value = "";
            document.getElementById('txt_dateRelised').value = "";
            document.getElementById('txtempcode').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('txt_Remarks').value = "";
            document.getElementById('btn_save').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
         
        }


        function save_damages() {
            var employeid = document.getElementById('txt_Damagempid').value;
            if (employeid == "") {
                alert("Select Employee Name ");
                document.getElementById('selct_damageemploye').focus();
                return false;
            }
            var empcode = document.getElementById('txt_Damgempcode').value;
            var dateofdamages = document.getElementById('txt_Datedamge').value;
            var Partculkardamage = document.getElementById('txt_Patloss').value;
            var againstsatus = document.getElementById('selct_Status').value;
            var NameofPerson = document.getElementById('txt_Nameexpl').value;
            var AmountOfDeduction = document.getElementById('txt_Amountdedu').value;
            var Noofinstaliments = document.getElementById('txt_NoInstal').value;
            if (Noofinstaliments == "") {
                $("#txt_NoInstal").focus();
                alert("Select No of installments ");
                return false;
            }
            var dateofrecoryfirst = document.getElementById('txt_DateRecoveryFirst').value;
            var dateofrecorylast = document.getElementById('txt_DateRecoveryLast').value;
            var remarks = document.getElementById('txt_Remarks').value;
            var sno = document.getElementById('lbl_sno').innerHTML;
            var btnval = document.getElementById('btn_savedamge').innerHTML;
            var data = { 'op': 'save_damages', 'employeid': employeid, 'dateofdamages': dateofdamages, 'Partculkardamage': Partculkardamage, 'againstsatus': againstsatus, 'NameofPerson': NameofPerson, 'AmountOfDeduction': AmountOfDeduction, 'dateofrecorylast':dateofrecorylast,'Noofinstaliments': Noofinstaliments, 'dateofrecoryfirst':dateofrecoryfirst, 'remarks': remarks, 'empcode': empcode, 'btnval': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_Damage_details();
                        $('#div_Damagedata').show();
                        $('#div_filldamage').css('display', 'none');
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
        function get_Damage_details() {
            var data = { 'op': 'get_Damage_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldamgedetails(msg);
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
        function filldamgedetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Name of Person</th><th scope="col">No of Installments</th><th scope="col">Date of Damages</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
                results += '<td data-title="Code" class="11">' + msg[i].fullname + '</td>';
                results += '<td  class="6">' + msg[i].NameofPerson + '</td>';
                results += '<td class="12">' + msg[i].Noofinstaliments + '</td>';
                results += '<td  class="7">' + msg[i].dateofdamages + '</td>';
                results += '<td   style="display:none" class="3">' + msg[i].Partculkardamage + '</td>';
                results += '<td  style="display:none" class="8">' + msg[i].againstsatus + '</td>';
                results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
                results += '<td style="display:none" class="4">' + msg[i].AmountOfDeduction + '</td>';
                results += '<td  style="display:none" class="5">' + msg[i].dateofrecoryfirst + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].sno + '</td>';
                results += '<td style="display:none" class="10">' + msg[i].dateofrecorylast + '</td>';
                results += '<td style="display:none" class="13">' + msg[i].remarks + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getmee(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 3) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_Damagedata").html(results);
        }
        function getmee(thisid) {
            var fullname = $(thisid).parent().parent().children('.11').html();
            var employeid = $(thisid).parent().parent().children('.2').html();
            var dateofdamages = $(thisid).parent().parent().children('.7').html();
            var Partculkardamage = $(thisid).parent().parent().children('.3').html();
            var againstsatus = $(thisid).parent().parent().children('.8').html();
            var NameofPerson = $(thisid).parent().parent().children('.6').html();
            var AmountOfDeduction = $(thisid).parent().parent().children('.4').html();
            var dateofrecoryfirst = $(thisid).parent().parent().children('.5').html();
            var sno = $(thisid).parent().parent().children('.9').html();
            var dateofrecorylast = $(thisid).parent().parent().children('.10').html();
            var Noofinstaliments = $(thisid).parent().parent().children('.12').html();
            var empcode = $(thisid).parent().parent().children('.1').html();
            var remarks = $(thisid).parent().parent().children('.13').html();

            document.getElementById('selct_damageemploye').value = fullname;
            document.getElementById('txt_Damagempid').value = employeid;
            document.getElementById('txt_Datedamge').value = dateofdamages;
            document.getElementById('txt_Patloss').value = Partculkardamage;
            document.getElementById('selct_Status').value = againstsatus;
            document.getElementById('txt_Nameexpl').value = NameofPerson;
            document.getElementById('txt_Amountdedu').value = AmountOfDeduction;
            document.getElementById('txt_DateRecoveryFirst').value = dateofrecoryfirst;
            document.getElementById('txt_Damgempcode').value = empcode;
            document.getElementById('txt_DateRecoveryLast').value = dateofrecorylast;
            document.getElementById('txt_NoInstal').value = Noofinstaliments;
            document.getElementById('txt_Remarks').value = remarks;
            document.getElementById('lbl_sno').innerHTML = sno;
            document.getElementById('btn_savedamge').innerHTML = "Modify";
            $("#div_Damagedata").hide();
            $("#div_filldamage").show();
            $('#show_logs_Damage').hide();
        }
        function forclearall() {
            canceldetails();
            document.getElementById('selct_damageemploye').value = "";
            document.getElementById('txt_Damagempid').value = "";
            document.getElementById('txt_Datedamge').value = "";
            document.getElementById('txt_Patloss').value = "";
            document.getElementById('selct_Status').value = "";
            document.getElementById('txt_Nameexpl').value = "";
            document.getElementById('txt_Amountdedu').value = "";
            document.getElementById('txt_DateRecoveryFirst').value = "";
            document.getElementById('txt_Damgempcode').value = "";
            document.getElementById('txt_DateRecoveryLast').value = ""; 
            document.getElementById('txt_NoInstal').value = "";
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
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Fines
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Fines</a></li>
        </ol>
    </section>
    <section>
        <section class="content">
            <div class="box box-info">
                <div>
                    <ul class="nav nav-tabs">
                        <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showdivfines()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;Fines</a></li>
                        <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showdivDamges()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Damages</a></li>
                    </ul>
                </div>
                <div id="div_fines">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Fines Details
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="showlogs" style="text-align: -webkit-right;">
                        <table>
                <tr>
                 <td>
                            </td>
                <td>
                <div class="input-group">
                                <div class="input-group-addon" >
                                <span class="glyphicon glyphicon-plus-sign"  onclick="showdesign()"></span> <span  onclick="showdesign()">Add Fines</span>
                          </div>
                          </div>
               
                </td>
                </tr>
                </table>
                           
                        </div>
                        <div id="div_Finedata">
                        </div>
                        
                        <div id='fillform' style="display: none;">
                         <div style="float:left; padding-left:20px">
          <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img"
                                                                    src="Iconimages/fines.png" alt="your image" style="border-radius: 5px; width: 200px;
                                                                    height: 200px; border-radius: 50%;" />
                                                                    </div>
                            <table align="center" style="width: 60%;">
                                <tr>
                                    <td>
                                      <label class="control-label" >
                                        Employe Name
                                        </label>
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
                                        Date of Offence
                                        </label>
                                        <input type="date" class="form-control" id="txt_Dateoff"
                                           />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                      <label class="control-label" >
                                        Act/Omission For Which Fine Imposed
                                        </label>
                                        <input type="text" class="form-control" id="txt_Act" placeholder="Enter Act/Omission For Which Fine Imposed"
                                            onkeypress="return isNumber(event)" />
                                    </td>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Whether Workman Showed Cause Against Fine
                                   </label>
                                        <select id="ddlfine" class="form-control">
                                            <option value="Yes">Yes</option>
                                            <option value="NO">NO</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                      <label class="control-label" >
                                        Name Of The Person In Whose Presence Employee's Explanations Was Heard
                                        </label>
                                        <input type="text" class="form-control" id="txt_nameperson" style="text-transform: capitalize;" placeholder="Enter Name Of The Person In Whose Presence Employee's Explanations Was Heard"
                                           />
                                    </td>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Amount Of Fine Imposed
                                        </label>
                                        <input type="text" class="form-control" id="txt_Amount" placeholder="Enter Amount Of Fine Imposed" onkeypress="return isNumber(event)" 
                                            />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                      <label class="control-label" >
                                        Date On Which Fine Realized
                                        </label>
                                        <input type="Date" class="form-control" id="txt_dateRelised"  />
                                    </td>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Remarks
                                        </label>
                                        <textarea name="comments" class="form-control" id="txt_remarks" placeholder="Enter Remarks"></textarea>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td>
                                        <label id="lbl_snof">
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
                                <span id="btn_save1"  class="glyphicon glyphicon-ok"  onclick="save_edit_Fines()"> </span> <span  id="btn_save" onclick="save_edit_Fines()"></span>
                             </div>
                    </td>
                    <td  style="width:2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                <span   class="glyphicon glyphicon-remove"  onclick="canceldetails()"></span><span  id="btn_close" onclick="canceldetails()">Close</span>
                          </div>
                    </td>
                            </tr>
                  
                    </table>
                        </div>
                    </div>
                </div>
                <div id="div_Damages" style="display: none;">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Damages Details
                        </h3>
                    </div>
                    <div class="box-body">
                        <div id="show_logs_Damage"  style="text-align: -webkit-right;">
                        <table>
                <tr>
                <td>
                <div class="input-group">
                                <div class="input-group-addon" ">
                                <span class="glyphicon glyphicon-plus-sign"  onclick="showdamgedesign()"></span><span  onclick="showdamgedesign()">Add Damage</span>
                          </div>
                          </div>
               
                </td>
                </tr>
                </table>
                            
                        </div>
                        <div id="div_Damagedata">
                        </div>
                        <div id='div_filldamage'style="display: none;">
                        <div style="float:left; padding-left:20px">
          <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="Img1"
                                                                    src="Iconimages/dames.png" alt="your image" style="border-radius: 5px; width: 200px;
                                                                    height: 200px; border-radius: 50%;" />
                                                                    </div>
                            <table align="center" style="width: 60%;">
                                <tr>
                                    <td>
                                      <label class="control-label" >
                                        Employe Name
                                        </label>
                                        <input type="text" class="form-control" id="selct_damageemploye" placeholder="Enter Employee Name"
                                            onkeypress="return ValidateAlpha(event);" />
                                    </td>
                                    <td style="display: none">
                                        <input id="txt_Damagempid" type="hidden" class="form-control" name="hiddenempid" />
                                    </td>
                                    <td style="display: none">
                                        <input id="txt_Damgempcode" type="hidden" class="form-control" name="hiddenempid" />
                                    </td>
                                    <td>
                                      <label class="control-label" >
                                        Date of damage/loss
                                        </label>
                                        <input type="date" class="form-control" id="txt_Datedamge"  onkeypress="return isNumber(event)" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                      <label class="control-label" >
                                        Particulars Of Damage/Loss
                                        </label>
                                        <input type="text" class="form-control" id="txt_Patloss" placeholder="Enter Particulars Of Damage/Loss"  />
                                    </td>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        Whether Workman Showed Cause Against Deduction
                                        </label>
                                        <select id="selct_Status" class="form-control">
                                             <option value="Yes">Yes</option>
                                            <option value="NO">NO</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                         Name Of The Person In Whose Presence Employee's Explanations Was Heard
                                         </label>
                                        <input type="text" class="form-control" id="txt_Nameexpl" placeholder="Enter Name Of The Person In Whose Presence Employee's Explanations Was Heard"  />
                                    </td>
                                    <td>
                                      <label class="control-label" >
                                        Amount Of Deduction Imposed
                                        </label>
                                        <input type="text" class="form-control" id="txt_Amountdedu" placeholder="Enter Amount Of Deduction Imposed" onkeypress="return isNumber(event)"  />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 40px;">
                                      <label class="control-label" >
                                        No Of Installments
                                        </label>
                                        <input type="text" class="form-control" id="txt_NoInstal" placeholder="No Of Installments" />
                                    </td>
                                    <td>
                                      <label class="control-label" >
                                        Date Of Recovery-First Installment
                                        </label>
                                        <input type="date" class="form-control" id="txt_DateRecoveryFirst"  />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                      <label class="control-label" >
                                        Date Of Recovery-Last Installment
                                        </label>
                                        <input type="date" class="form-control" id="txt_DateRecoveryLast"  />
                                    </td>
                                    <td style="height: 40px;">
                                      <label class="control-label">
                                        Remarks
                                        </label>
                                        <textarea name="comments" class="form-control" id="txt_Remarks" placeholder="Enter Remarks"></textarea>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    
                                </tr>
                            </table>
                            <br />
                            <table align="center">
                            <tr>
                              <td >
                    <div class="input-group">
                                <div class="input-group-addon" >
                              <span class="glyphicon glyphicon-ok" id="btn_savedamge1" onclick="save_damages()"></span> <span id="btn_savedamge" onclick="save_damages()">save</span>
                             </div>
                    </td>
                    <td  style="width:2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close">
                                <span class="glyphicon glyphicon-remove" id='Button31' onclick="canceldamagedetails()"></span> <span id='Button3' onclick="canceldamagedetails()">Close</span>
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
