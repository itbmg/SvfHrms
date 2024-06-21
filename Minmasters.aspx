<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="Minmasters.aspx.cs" Inherits="Minmasters" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_group_details();
            get_bank_details();
            get_Dept_details();
            get_Desgnation_details();
            get_IDProof_details();
            get_CompanyMaster_details();
            get_All_Holiday_details();
            get_bullentin_details();
            showDepartmaster();
            get_Shift_details();
        });
        function showDepartmaster() {
            $("#div_depftment").show();
            $("#div_designation").hide();
            $("#div_Bankdetails").hide();
            $("#div_idmaster").hide();
            $("#div_company").hide();
            $('#div_holiday').hide()
            $('#div_shiftData').hide()
            $('#div_bullten').hide()
            forclearalldepart();

        }
        function showDesignationMaster() {
            $("#div_depftment").hide();
            $("#div_designation").show();
            $("#div_Bankdetails").hide();
            $("#div_idmaster").hide();
            $("#div_company").hide();
            $('#div_holiday').hide()
            $('#div_shiftData').hide()
            $('#div_bullten').hide()
            forclearalldesign();

        }
        function showbankmaster() {
            $("#div_depftment").hide();
            $("#div_designation").hide();
            $("#div_Bankdetails").show();
            $("#div_idmaster").hide();
            $("#div_company").hide();
            $('#div_holiday').hide()
            $('#div_shiftData').hide()
            $('#div_bullten').hide()

        }
        function showIDmaster() {
            $("#div_depftment").hide();
            $("#div_designation").hide();
            $("#div_Bankdetails").hide();
            $("#div_idmaster").show(); ;
            $("#div_company").hide();
            $('#div_holiday').hide()
            $('#div_shiftData').hide()
            $('#div_bullten').hide()
            forclearallid();
        }
        function showcompanymaster() {
            $('#div_depftment').hide()
            $("#div_designation").hide();
            $("#div_Bankdetails").hide();
            $("#div_idmaster").hide();
            $("#div_company").show();
            $('#div_holiday').hide();
            $('#div_shiftData').hide();
            $('#div_bullten').hide();
            companycanceldetails();
        }

        function showsHolidaymasters() {
            $('#div_depftment').hide()
            $("#div_designation").hide();
            $("#div_Bankdetails").hide();
            $("#div_idmaster").hide();
            $("#div_company").hide();
            $("#div_holiday").show();
            $('#div_shiftData').hide();
            $('#div_bullten').hide();
            forclearallholiday();
        }

        function showshiftmasters() {

            $('#div_depftment').hide()
            $('#div_designation').hide()
            $("#div_Bankdetails").hide();
            $("#div_idmaster").hide();
            $("#div_company").hide();
            $("#div_holiday").hide();
            $("#div_shiftData").show();
            $('#div_bullten').hide();
            forclearallshift();
        }

        function showbulltenmasters() {

            $('#div_depftment').hide()
            $('#div_designation').hide()
            $('#div_Bankdetails').hide()
            $("#div_idmaster").hide();
            $("#div_company").hide();
            $("#div_holiday").hide();
            $("#div_shiftData").hide();
            $("#div_bullten").show();
            forclearallbullten();
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

        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
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

        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

        function for_save_edit_Dept() {
            var groupid = document.getElementById('Slect_group').value;
            var Department = document.getElementById('txtDeportment').value;
            if (Department == "") {
                $("#txtDeportment").focus();
                alert("Enter Department");
                return false;
            }
            var status = document.getElementById('ddldepstatus').value;
            if (status == "") {
                $("#ddldepstatus").focus();
                alert("select Status");
            }
            var Deptid = document.getElementById('lbl_depsno').innerHTML;
            var btnval = document.getElementById('btn_savedepart').innerHTML;
            var flag = false;
            if (Department == "") {
                $("#lbl_code_error_msg").show();
                flag = true;
            }

            if (flag) {
                return;
            }
            var data = { 'op': 'save_Department_click', 'Department': Department, 'status': status, 'btnval': btnval, 'Deptid': Deptid, 'groupid': groupid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_Dept_details();
                        forclearalldepart();
                    }

                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function forclearalldepart() {
            document.getElementById('txtDeportment').value = "";
            document.getElementById('ddldepstatus').selectedIndex = 0;
            document.getElementById('btn_savedepart').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            get_Dept_details();
        }

        function get_group_details() {
            var data = { 'op': 'get_group_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillgropdetails(msg);
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

        function fillgropdetails(msg) {
            var data = document.getElementById('Slect_group');
            var length = data.options.length;
            document.getElementById('Slect_group').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Group";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].groupname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].groupname;
                    option.value = msg[i].groupid;
                    data.appendChild(option);
                }
            }
        }


        function get_Dept_details() {
            var data = { 'op': 'get_Dept_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldeptdetails(msg);
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
        function filldeptdetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;text-align:left"><table style="text-align:left" class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col" >Sno</th><th scope="col" >Department Name</th><th scope="col" >Status</th><th scope="col" ></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                var status = msg[i].status;
                if (status == "0") {

                    status = "Inactive";
                }
                else {
                    status = "Active";
                }
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row" class="1" style="display:none">' + msg[i].Department + '</th>';
                results += '<th data-title="brandstatus" class="1"><span class="glyphicon glyphicon-triangle-right" style="color: cadetblue;"></span>  <span id="1" class="1">  ' + msg[i].Department + ' </span></th>';
                results += '<td data-title="brandstatus" class="2"><span class="fa fa-adn" style="color: cadetblue;"></span>  <span id="2" class="2">' + status + '</span></td>';
                results += '<td style="display:none" class="3">' + msg[i].Deptid + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="deptgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_Deptdata").html(results);
        } 
        function deptgetme(thisid) {
            var DepartmentId = $(thisid).parent().parent().children('.3').html();
            var Department = $(thisid).parent().parent().find('#1').html();
            var statuscode = $(thisid).parent().parent().find('#2').html();
//            var statuscode = $(thisid).parent().parent().children('.2').html();
            if (statuscode == "Active") {

                status = "1";
            }
            else {
                status = "0";
            }
            document.getElementById('ddldepstatus').value = status
            document.getElementById('txtDeportment').value = Department;
            document.getElementById('lbl_depsno').innerHTML = DepartmentId;
            document.getElementById('btn_savedepart').innerHTML = "Modify";
        }



        function save_Desigination_click() {
            var desigination = document.getElementById('txtDesignation').value;
            if (desigination == "") {
                $("#txtDesignation").focus();
                alert("Enter Desigination");
                return false;
            }
            var status = document.getElementById('ddldesnstatus').value;
            if (status == "") {
                $("#ddldesnstatus").focus();
                alert("Select Status");
            }
            var designationid = document.getElementById('lbl_designsno').innerHTML;
            var btnval = document.getElementById('btn_savedesign').innerHTML;
            var flag = false;
            if (desigination == "") {
                
                $("#lbl_code_error_msg").show();
                flag = true;
            }

            if (flag) {
                return;
            }
            var data = { 'op': 'save_Desigination_click', 'desigination': desigination, 'status': status, 'btnval': btnval, 'designationid': designationid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearalldesign();
                        get_Desgnation_details();
                    }
                    
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function forclearalldesign() {
            document.getElementById('txtDesignation').value = "";
            document.getElementById('ddldesnstatus').selectedIndex = 0;
            document.getElementById('btn_savedesign').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
        }

        function get_Desgnation_details() {
            var data = { 'op': 'get_Desgnation_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldesigdetails(msg);
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

        function filldesigdetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th  scope="col">Sno</th><th scope="col">Designation</th><th scope="col" >Status</th><th scope="col" ></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                var status = msg[i].status;
                if (status == "0") {

                    status = "Inactive";
                }
                else {
                    status = "Active";
                }
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row" style="display:none" class="1" >' + msg[i].designation + '</th>';
                results += '<th data-title="brandstatus" class="1"><span class="glyphicon glyphicon-triangle-right" style="color: cadetblue;"></span>  <span id="1" class="1">  ' + msg[i].designation + ' </span></th>';
                results += '<td data-title="brandstatus" class="2">' + status + '</td>';
                results += '<td style="display:none" class="3">' + msg[i].designationid + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="desingetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_designdata").html(results);
        }
        function desingetme(thisid) {
            var designationid = $(thisid).parent().parent().children('.3').html();
            var designation = $(thisid).parent().parent().find('#1').html();
            var statuscode = $(thisid).parent().parent().children('.2').html();
            if (statuscode == "Active") {

                status = "1";
            }
            else {
                status = "0";
            }
            document.getElementById('ddldesnstatus').value = status
            document.getElementById('txtDesignation').value = designation;
            document.getElementById('lbl_designsno').innerHTML = designationid;
            document.getElementById('btn_savedesign').innerHTML = "Modify";
            get_Desgnation_details();
        }

        function canceldetailsbank() {
            $("#div_BankData").show();
            $("#fillform").hide();
            $('#showlogs').show();
        }


        function saveBankDetails() {
            var name = document.getElementById('txtBName').value;
            if (name == "") {
                $("#txtBName").focus();
                alert("Enter Name ");
                return false;

            }
            var code = document.getElementById('txtBcode').value;
            if (code == "") {
                $("#txtBcode").focus();
                alert("Enter Code ");
                return false;
            }

            var status = document.getElementById('ddlbankstatus').value;
            if (status == "") {
                $("#ddlbankstatus").focus();
                alert("Select Status");
            }
            var btnval = document.getElementById('btn_savebank').innerHTML;
            var sno = document.getElementById('lbl_banksno').value;
            var data = { 'op': 'saveBankDetails', 'Name': name, 'Code': code, 'status': status, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_bank_details();
                        $('#div_BankData').show();
                        $('#fillform').css('display', 'none');
                        $('#showlogs').css('display', 'block');
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
            document.getElementById('txtBcode').value = "";
            document.getElementById('txtBName').value = "";
            document.getElementById('lbl_banksno').value = "";
            document.getElementById('ddlbankstatus').selectedIndex = 0;
            document.getElementById('btn_savebank').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            get_bank_details();
        }
        function showdesign() {
            $("#div_BankData").hide();
            $("#fillform").show();
            $('#showlogs').hide();
            forclearall();
        }
        function get_bank_details() {
            var data = { 'op': 'get_bank_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbankdetails(msg);
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
        function fillbankdetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th></th><th  scope="col"><i class="fa fa-university"></i>Name</th><th scope="col" >Code</th><th scope="col" >Status</th><th   scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                var status = msg[i].status;
                if (status == "0") {
                    status = "Inactive";

                }
                else {
                    status = "Active";
                }
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1" ><span class="fa fa-university" style="color: cadetblue;"></span>  <span id="1" class="1"> ' + msg[i].name + '</span</th>';
                results += '<td data-title="code" class="2">' + msg[i].code + '</td>';
                results += '<td data-title="status" class="3">' + status + '</td>';
                results += '<td style="display:none" class="4">' + msg[i].sno + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="bankgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_BankData").html(results);
        }
        function bankgetme(thisid) {
            var name = $(thisid).parent().parent().find('#1').html();
            var Code = $(thisid).parent().parent().children('.2').html();
            var sno = $(thisid).parent().parent().children('.4').html();
            var statuscode = $(thisid).parent().parent().children('.3').html();
            if (statuscode == "Active") {

                status = "1";
            }
            else {
                status = "0";
            }
            document.getElementById('txtBName').value = name;
            document.getElementById('txtBcode').value = Code;
            document.getElementById('btn_savebank').innerHTML = "Modify";
            document.getElementById('lbl_banksno').value = sno;
            document.getElementById('ddlbankstatus').value = status;
            $("#div_BankData").hide();
            $("#fillform").show();
            $('#showlogs').hide();
        }

        function for_save_edit_IDProof() {
            var IDProof = document.getElementById('txtidproof').value;
            if (IDProof == "") {
                $("#txtidproof").focus();
                alert("Enter IDProof");
                return false;
            }
            var status = document.getElementById('ddlidstatus').value;
            if (status == "") {
                $("#ddlidstatus").focus();
                alert("select Status");
            }
            var IDProofId = document.getElementById('lbl_idsno').innerHTML;
            var btnval = document.getElementById('btn_saveID').innerHTML;
            var flag = false;
            if (IDProof == "") {
                $("#lbl_code_error_msg").show();
                flag = true;
            }

            if (flag) {
                return;
            }
            var data = { 'op': 'save_IDProof_click', 'IDProof': IDProof, 'status': status, 'btnval': btnval, 'IDProofId': IDProofId };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert("New IDProof Successfully Created");
                        get_IDProof_details();
                        forclearallid();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function forclearallid() {
            document.getElementById('txtidproof').value = "";
            document.getElementById('ddlidstatus').selectedIndex = 0;
            document.getElementById('btn_saveID').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            get_IDProof_details();
        }

        function get_IDProof_details() {
            var data = { 'op': 'get_IDProof_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filliddetails(msg);
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
        function filliddetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"  >Sno</th><th   scope="col" >ID Proof</th><th scope="col" >Status</th><th scope="col"  ></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                var status = msg[i].status;
                if (status == "0") {

                    status = "Inactive";
                }
                else {
                    status = "Active";
                }
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row" class="1" ><span class="glyphicon glyphicon-triangle-right" style="color: cadetblue;"></span>  <span id="1" class="1">' + msg[i].IDProof + '</span></th>';
                results += '<td data-title="Code" class="2">' + status + '</td>';
                results += '<td style="display:none" class="3">' + msg[i].IDProofId + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="idgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_idprooftdata").html(results);
        }
        function idgetme(thisid) {
            var IDProofId = $(thisid).parent().parent().children('.3').html();
            var IDProof = $(thisid).parent().parent().find('#1').html();
            var statuscode = $(thisid).parent().parent().children('.2').html();
            if (statuscode == "Active") {

                status = "1";
            }
            else {
                status = "0";
            }
            document.getElementById('txtidproof').value = IDProof;
            document.getElementById('ddlidstatus').value = status;
            document.getElementById('lbl_idsno').innerHTML = IDProofId;
            document.getElementById('btn_saveID').innerHTML = "Modify";
        }

        function save_CompanyMaster_click() {
            var CompanyName = document.getElementById('txt_CompanyName').value;
            var Add = document.getElementById('txt_CompanyAdd').value;
            var PhoneNo = document.getElementById('txt_PhoneNo').value;
            var mailId = document.getElementById('txt_CompanyMailId').value;
            var TINNo = document.getElementById('txt_TINNo').value;
            if (CompanyName == "") {
                $("#txt_CompanyName").focus();
                alert("Enter CompanyName");
                return false;
            }
            if (Add == "") {
                $("#txt_CompanyAdd").focus();
                alert("Enter Address");
                return false;
            }
            if ((PhoneNo == "") || (PhoneNo.length != 10)) {
                $("#txt_PhoneNo").focus();
                alert("PhoneNo should not be Empty and it Should be of 10 digits");
                PhoneNo.focus();
                return false;
            }

            var CompanyCode = document.getElementById('lbl_CompanyCode').value;
            var btnSave = document.getElementById('btn_savecompany').innerHTML;
            var data = { 'op': 'saveCompanyMasterdetails', 'CompanyName': CompanyName, 'Add': Add, 'PhoneNo': PhoneNo, 'btnVal': btnSave, 'CompanyCode': CompanyCode, 'mailId': mailId, 'TINNo': TINNo };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        companycanceldetails();
                        get_CompanyMaster_details();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            callHandler(data, s, e);
        }

        function get_CompanyMaster_details() {
            var data = { 'op': 'get_CompanyMaster_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcompanydetails(msg);
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

        function fillcompanydetails(msg) {
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col" >Company Name</th><th scope="col">Address</th><th scope="col" >Phone No</th><th scope="col" >Mail Id</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<th data-title="CompanyName"  class="2">' + msg[i].CompanyName + '</th>';
                results += '<td data-title="Add" class="3">' + msg[i].Add + '</td>';
                results += '<td data-title="PhoneNo" class="4">' + msg[i].PhoneNo + '</td>';
                results += '<td data-title="mailId" class="5">' + msg[i].mailId + '</td>';
                results += '<td data-title="TINNo" class="6" style="display:none" >' + msg[i].TINNo + '</td>';
                results += '<td data-title="CompanyCode" style="display:none" class="8">' + msg[i].CompanyCode + '</td>';
                results += '<td ><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="companygetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_comanydata").html(results);
        }
        function companygetme(thisid) {
            var CompanyName = $(thisid).parent().parent().children('.2').html();
            var Add = $(thisid).parent().parent().children('.3').html();
            var PhoneNo = $(thisid).parent().parent().children('.4').html();
            var mailId = $(thisid).parent().parent().children('.5').html();
            var TINNo = $(thisid).parent().parent().children('.6').html();
            var CompanyCode = $(thisid).parent().parent().children('.8').html();
            document.getElementById('txt_CompanyName').value = CompanyName;
            document.getElementById('txt_CompanyAdd').value = Add;
            document.getElementById('txt_PhoneNo').value = PhoneNo;
            document.getElementById('txt_CompanyMailId').value = mailId;
            document.getElementById('txt_TINNo').value = TINNo;
            document.getElementById('lbl_CompanyCode').value = CompanyCode;
            document.getElementById('btn_savecompany').innerHTML = "Modify";
            $("#fillform").show();
            $('#showlogs').hide();
        }

        function companycanceldetails() {
            var CompanyName = document.getElementById('txt_CompanyName').value = "";
            var Add = document.getElementById('txt_CompanyAdd').value = "";
            var PhoneNo = document.getElementById('txt_PhoneNo').value = "";
            var mailId = document.getElementById('txt_CompanyMailId').value = "";
            var TINNo = document.getElementById('txt_TINNo').value = "";
            document.getElementById('btn_savecompany').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
        }



        function save_edit_holiday() {
            var Holidayname = document.getElementById('txt_Holiday').value;
            if (Holidayname == "") {
                $("#txt_Holiday").focus();
                alert("Enter Holiday Name ");
                return false;
            }
            var optional = document.getElementById('Slct_otional').value;
            if (optional == "") {
                $("#Slct_otional").focus();
                alert("Select Optional");
            }


            var date = document.getElementById('txt_date').value;
            if (date == "") {
                $("#txt_date").focus();
                alert("Select Date");
            }
            var sno = document.getElementById('lbl_holidaysno').innerHTML;
            var btnval = document.getElementById('btn_saveholiday').innerHTML;
            var flag = false;
            var data = { 'op': 'save_edit_holiday', 'Holidayname': Holidayname, 'optional': optional, 'date': date, 'btnval': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        if (btnval == "Save"){
                        alert(" Holiday Successfully Saved");
                        }
                        else{
                           alert("Modified or changes updated Successfully");
                        }
                        forclearallholiday();
                        get_All_Holiday_details();
                    }

                }

                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function forclearallholiday() {
            document.getElementById('txt_Holiday').value = "";
            document.getElementById('Slct_otional').selectedIndex = 0;
            document.getElementById('txt_date').value = "";
            document.getElementById('btn_saveholiday').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            get_All_Holiday_details();
        }

        function get_All_Holiday_details() {
            var data = { 'op': 'get_All_Holiday_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillholidaydetails(msg);
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
        function fillholidaydetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col" >Sno</th><th scope="col" >Title</th><th scope="col" >Description</th><th scope="col" >Date</th><th scope="col" ></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                var optional = msg[i].optional;
                if (optional == "0") {

                    optional = "National Holidays";
                }
                else {
                    optional = "Festival Holidays";
                }
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row" class="1" >' + msg[i].Holidayname + '</th>';
                results += '<td data-title="brandstatus" class="2">' + optional + '</td>';
                results += '<td data-title="brandstatus" class="4">' + msg[i].date + '</td>';
                results += '<td data-title="brandstatus" style="display:none" class="3">' + msg[i].sno + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="holidaygetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_holidaydata").html(results);
        }
        function holidaygetme(thisid) {
            var optional = $(thisid).parent().parent().children('.2').html();
            if (optional == "National Holidays") {

                optional = "1";
            }
            else {
                optional = "0";
            }
            var Holidayname = $(thisid).parent().parent().children('.1').html();
            var date = $(thisid).parent().parent().children('.4').html();
            var sno = $(thisid).parent().parent().children('.3').html();
            document.getElementById('txt_Holiday').value = Holidayname
            document.getElementById('txt_date').value = date;
            document.getElementById('Slct_otional').value = optional;
            document.getElementById('lbl_holidaysno').innerHTML = sno;
            document.getElementById('btn_saveholiday').innerHTML = "Modify";
        }




        function for_save_edit_shifttype() {
            var shifttype = document.getElementById('txtshifttype').value;
            if (shifttype == "") {
                $("#txtshifttype").focus();
                alert("Enter Shifttype");
                return false;
            }
            var status = document.getElementById('ddlshiftstatus').value;
            if (status == "") {
                $("#ddlshiftstatus").focus();
                alert("Select Status");
            }
            var shifttypeid = document.getElementById('lbl_shiftsno').innerHTML;
            var btnval = document.getElementById('btn_shiftsave').innerHTML;
            var flag = false;
            if (shifttype == "") {
                
                $("#lbl_code_error_msg").show();
                flag = true;
            }

            if (flag) {
                return;
            }
            var data = { 'op': 'for_save_edit_shifttype', 'shifttype': shifttype, 'status': status, 'btnval': btnval, 'shifttypeid': shifttypeid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert("New Shift Successfully Created");
                        get_Shift_details();
                        forclearallshift();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function forclearallshift() {
            document.getElementById('txtshifttype').value = "";
            document.getElementById('ddlshiftstatus').selectedIndex = 0;
            document.getElementById('btn_shiftsave').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            get_Shift_details();
        }

        function get_Shift_details() {
            var data = { 'op': 'get_Shift_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillshiftdetails(msg);
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
        function fillshiftdetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col" >Sno</th><th  scope="col" >Shift Type</th><th scope="col">Status</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                var status = msg[i].status;
                if (status == "0") {

                    status = "Inactive";
                }
                else {
                    status = "Active";
                }
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row" class="1" >' + msg[i].shifttype + '</th>';
                results += '<td data-title="Code" class="2">' + status + '</td>';
                results += '<td style="display:none" class="3">' + msg[i].shiftid + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="shiftgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_shiftdata").html(results);
        }
        function shiftgetme(thisid) {
            var shifttypeid = $(thisid).parent().parent().children('.3').html();
            var shifttype = $(thisid).parent().parent().children('.1').html();
            var statuscode = $(thisid).parent().parent().children('.2').html();
            if (statuscode == "Active") {

                status = "1";
            }
            else {
                status = "0";
            }
            document.getElementById('txtshifttype').value = shifttype;
            document.getElementById('ddlshiftstatus').value = status;
            document.getElementById('lbl_shiftsno').innerHTML = shifttypeid;
            document.getElementById('btn_shiftsave').innerHTML = "Modify";
        }



        function save_edit_bulletin() {
            var title = document.getElementById('txt_Title').value;
            if (title == "") {
                $("#txt_Title").focus();
                alert("Enter Title ");
                return false;
            }
            var description = document.getElementById('txt_Descrtn').value;
            if (description == "") {
                $("#txt_Descrtn").focus();
                alert("Select Description");
            }
            var sno = document.getElementById('lbl_bulltensno').innerHTML;
            var btnval = document.getElementById('btn_savebullten').innerHTML;
            var flag = false;
            var data = { 'op': 'save_edit_bulletin', 'title': title, 'description': description, 'btnval': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearallbullten();
                        get_bullentin_details();
                    }

                }

                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function forclearallbullten() {
            document.getElementById('txt_Title').value = "";
            document.getElementById('txt_Descrtn').value = "";
            document.getElementById('btn_savebullten').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            get_bullentin_details();
        }

        function get_bullentin_details() {
            var data = { 'op': 'get_bullentin_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbulltendetails(msg);
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
        function fillbulltendetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Title</th><th scope="col">Description</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row" class="1" >' + msg[i].title + '</th>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].description + '</td>';
                results += '<td data-title="brandstatus" style="display:none" class="3">' + msg[i].sno + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getmebullten(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_bulentdata").html(results);
        }
        function getmebullten(thisid) {
            var description = $(thisid).parent().parent().children('.2').html();
            var title = $(thisid).parent().parent().children('.1').html();
            var sno = $(thisid).parent().parent().children('.3').html();
            document.getElementById('txt_Descrtn').value = description
            document.getElementById('txt_Title').value = title;
            document.getElementById('lbl_bulltensno').innerHTML = sno;
            document.getElementById('btn_savebullten').innerHTML = "Modify";
        }
      
        function validate_email(txt_CompanyMailId) {
            var x = document.getElementById("txt_CompanyMailId").value;
            var atpos = x.indexOf("@");
            var dotpos = x.lastIndexOf(".");
            if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= x.length) {
                alert("Not a valid e-mail address");

            }
        }
    </script>
    <style type="text/css">
         /*this style effect in antor style sheet*/
     .form_control 
     {
         margin: 0px;
    height: 34px;
    width: 86%;
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

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content">
        <!-- Small boxes (Stat box) -->
        <div class="row">
            <section class="content-header">
                <h1>
                    Mini Masters
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
                    <li><a href="#">Masters</a></li>
                </ol>
            </section>
            <section class="content">
                <div class="box box-info">
                    <div class="box-header with-border">
                    </div>
                    <div class="box-body">
                        <div>
                            <ul class="nav nav-tabs">
                                <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showDepartmaster()">
                                    <i class="fa fa-building-o" aria-hidden="true"></i>&nbsp;&nbsp;Department</a></li>
                                <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showDesignationMaster()">
                                    <i class="fa fa-user" aria-hidden="true"></i>&nbsp;&nbsp;Designation</a></li>
                                <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="showbankmaster()"><i
                                    class="fa fa-university"></i>&nbsp;&nbsp;Bank</a></li>
                                <li id="Li2" class=""><a data-toggle="tab" href="#" onclick="showIDmaster()"><i
                                    class="icon-money"></i>&nbsp;&nbsp;IDProof Master</a></li>
                                <li id="Li3" class=""><a data-toggle="tab" href="#" onclick="showcompanymaster()"><i
                                    class="fa fa-bar-chart"></i>&nbsp;&nbsp;Company</a></li>
                                <li id="Li4" class=""><a data-toggle="tab" href="#" onclick="showsHolidaymasters()"><i
                                    class="fa fa-taxi"></i>&nbsp;&nbsp;Holiday</a></li>
                                <li id="Li5" class=""><a data-toggle="tab" href="#" onclick="showshiftmasters()"><i
                                    class="fa fa-tasks"></i>&nbsp;&nbsp;Shift</a></li>
                                <li id="Li6" class=""><a data-toggle="tab" href="#" onclick="showbulltenmasters()"><i
                                    class="fa fa-list-alt"></i>&nbsp;&nbsp;Bulletin</a></li>
                            </ul>
                        </div>
                        <div id="div_depftment" style="display: none;">
                            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Department Master Details
                </h3>
            </div>
            <div class="box-body">
            <div id="departfill">
                <table id="tbl_department" align="center">
                 
                  <tr>
                        <td style="height: 40px;">
                          <label class="control-label" >  Group Name</label>
                        </td>
                        <td>
                           <select id="Slect_group" class="form-control">
                           </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 40px;">
                          <label class="control-label" >  Department Name</label>
                        </td>
                        <td>
                            <input type="text" class="form-control" id="txtDeportment" style="text-transform: capitalize;"  placeholder="Enter Depatment"/>
                        </td>
                    </tr>
                       <tr>
                             <td    style="height:40px;">
                            <label class="control-label" > Status</label><span style="color: red;font-weight:bold;">*</span>     
                            </td>
                             <td>
                             <select id="ddldepstatus"  class="form-control">
                             <option value="1">Active</option>
                             <option value="0">InActive</option>
                             </select>
                             </td>
                      </tr>
                    <tr>
                        <td>
                        </td>
                       
                    </tr>
                    <tr hidden>
                        <td>
                            <label id="lbl_depsno">
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
                                <span class="glyphicon glyphicon-ok" id="btn_savedepart1" onclick="for_save_edit_Dept()"></span> <span id="btn_savedepart" onclick="for_save_edit_Dept()">save</span>
                             </div>
                    </td>
                    <td width="2%"></td>
                    <td >
                      <div class="input-group">
                                <div class="input-group-close" >
                                 <span class="glyphicon glyphicon-remove" id='btn_closedepart1' onclick="forclearalldepart()"></span> <span id='btn_closedepart' onclick="forclearalldepart()">Close</span>
                          </div>
                    </td>
                 </tr>
                    
                    </table>
                </div>
                <div id="div_Deptdata">
                </div>
                </div>
                        </div>
                        <div id="div_designation" style="display: none;">
                            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Designation Master Details
                </h3>
            </div>
            <div class="box-body">
                                <div id="Disignafill">
                <table id="tbl_designation" align="center">
                    <tr>
                        <td style="height: 40px;">
                          <label class="control-label" >  Designation Name</label>
                        </td>
                        <td>
                            <input type="text" class="form-control" id="txtDesignation" placeholder="Enter Designation" style="text-transform: capitalize;"/>
                                
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 40px;">
                            <label class="control-label" >Status</label><span style="color: red;font-weight:bold">*</span>
                        </td>
                        <td>
                            <select id="ddldesnstatus" class="form-control">
                                <option value="1">Active</option>
                                <option value="0">InActive</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        
                    </tr>
                    <tr hidden>
                        <td>
                            <label id="lbl_designsno">
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
                                <span class="glyphicon glyphicon-ok" id="btn_savedesign1" onclick="save_Desigination_click()"></span> <span id="btn_savedesign" onclick="save_Desigination_click()">save</span>
                             </div>
                    </td>
                    <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                 <span class="glyphicon glyphicon-remove" id='btn_closedisgn1' onclick="forclearalldesign()"></span> <span id='btn_closedisgn' onclick="forclearalldesign()">Close</span>
                          </div>
                    </td>
                </tr>
                    
                    </table>
            </div>
                <div id="div_designdata">
                </div>
            </div>
            </div>
                        <div id="div_Bankdetails" style="display: none;">
                             <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>BankDetails
                    </h3>
                </div>
                <div class="box-body">
                    <div id="showlogs"align="center">
                     <table>
                <tr>
                 <td style="width: 89%">
                            </td>
                <td>
                <div class="input-group">
                                <div class="input-group-addon" >
                                <span id="btn_addbank" class="glyphicon glyphicon-plus-sign"  onclick="showdesign()"></span> <span  onclick="showdesign()">Add Bank</span>
                          </div>
                          </div>
               
                </td>
                </tr>
                </table>
                       
                    </div>
                    <div id='fillform' style="display: none;">
                        <table align="center" style="width: 60%;">
                            <tr>
                                <th>
                                </th>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                   <label class="control-label" > Name</label><span style="color: red;height: 34px!important;font-weight:bold">*</span>
                                </td>
                                <td>
                                    <input id="txtBName" type="text" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder="Enter Name" onkeypress="return ValidateAlpha(event);" style="text-transform: capitalize;" /><label id="lbl_code_error_msg" class="errormessage">* Please
                                            Enter Name</label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label class="control-label" >Code</label>
                                </td>
                                <td>
                                    <input id="txtBcode" type="text" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder="Enter code" /><label id="lbl_code_error_msg" class="errormessage">* Please
                                            Enter code</label>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                   <label class="control-label" > Status</label><span style="color: red;font-weight:bold">*</span>
                                </td>
                                <td>
                                    <select id="ddlbankstatus"  class="form-control">
                                        <option value="1">Active</option>
                                        <option value="0">InActive</option>
                                    </select>
                                </td>
                            </tr>
                            <tr style="display:none;"><td>
                            <label id="lbl_banksno"></label>
                            </td>
                            </tr>
                            <tr>
                                
                            </tr>
                        </table>
                        <br />
                        <table align="center">
                        <tr>
                         <td>
                    <div class="input-group">
                                <div class="input-group-addon" >
                                <span class="glyphicon glyphicon-ok" id="btn_savebank1" onclick="saveBankDetails()"></span> <span id="btn_savebank" onclick="saveBankDetails()">save</span>
                             </div>
                    </td>
                      <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                 <span class="glyphicon glyphicon-remove" id='btn_closebank1' onclick="canceldetailsbank()"></span> <span id='btn_closebank' onclick="canceldetailsbank()">Close</span>
                          </div>
                    </td></tr>
                   
                    </table>
                        </div>
                         <div id="div_BankData">
                    </div>
                </div>
                        </div>
                        <div id="div_idmaster" style="display: none;">
                             <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>ID Proof Details
                </h3>
            </div>
        <div class="box-body">
                                <div id="diidprof">

            <table align="center" id="tbl_leavemanagement" >
               
                <tr>
                    <td style="height: 40px;">
                        <label class="control-label" >ID Proof Name</label>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="txtidproof"  placeholder="Enter ID Proof" style="text-transform: capitalize;" onkeypress="return ValidateAlpha(event);"/>
                    </td>
                </tr>
                 <tr>
                    <td style="height: 40px;">
                       <label class="control-label" > Status</label><span style="color: red;font-weight:bold">*</span>
                    </td>
                    <td>
                        <select id="ddlidstatus" class="form-control">
                            <option value="1">Active</option>
                            <option value="0">InActive</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    
                </tr>
                <tr hidden>
                    <td>
                        <label id="lbl_idsno">
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
                                <span class="glyphicon glyphicon-ok" id="btn_saveID1" onclick="for_save_edit_IDProof()"></span> <span id="btn_saveID" onclick="for_save_edit_IDProof()">save</span>
                             </div>
                    </td>
                      <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close">
                                <span class="glyphicon glyphicon-remove" id='btn_closeID1' onclick="forclearallid()"></span> <span id='btn_closeID' onclick="forclearallid()">Close</span>
                          </div>
                    </td></tr>
                   
                    </table>
            </div>
            <div id="div_idprooftdata">
            </div>
        </div>
                        </div>
                        <div id="div_company" style="display: none;">
                            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Company Master
                </h3>
            </div>
            <div class="box-body">
            <div id="companyfills"> 
                <table align="center" style="width: 60%;">
                    <tr>
                    <td>
                        <label class="control-label" >
                            Company Name</label>
                            </td>
                        <td style="height: 40px;">
                            <input type="text" class="form_control" id="txt_CompanyName" placeholder=" Enter Company Name" style="text-transform: capitalize;" style="margin: 0px; height: 47px; width: 312px;" />
                        </td>
                    </tr>
                    <tr>
                        <td >
                           <label class="control-label" >  Address</label>
                        </td>
                        <td style="height: 40px;">
                            <textarea type="text" id="txt_CompanyAdd" class="form_control" placeholder="Enter Address" style="margin: 0px; height: 47px; width: 312px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td>
                           <label class="control-label">  Phone No</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text"  class="form-control" id="txt_PhoneNo" placeholder="Enter Phone No"
                                onkeypress="return isNumber(event)" style="margin: 0px; height: 35px; width: 312px; border-color: darkgray;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                         <label class="control-label" >   Mail Id</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text" class="form_control" id="txt_CompanyMailId" placeholder="Enter Mail Id" onblur="return validate_email(txt_CompanyMailId);" style="margin: 0px; height: 35px; width: 312px;"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                           <label class="control-label" >  TIN No</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text" class="form_control" id="txt_TINNo" placeholder="Enter TIN No" onkeypress="return isNumber(event);" style="margin: 0px; height: 35px; width: 312px;"/>
                        </td>
                    </tr>
                </table>
                
                <table align="center">
                <tr style="display: none;">
                <td>
                    <label id="lbl_CompanyCode">
                    </label>
                </td>
            </tr>
            <br />
                        <tr>
                         <td >
                    <div class="input-group">
                                <div class="input-group-addon" >
                                <span class="glyphicon glyphicon-ok" id="btn_savecompany1" onclick="save_CompanyMaster_click()"></span> <span id="btn_savecompany" onclick="save_CompanyMaster_click()">save</span>
                             </div>
                    </td>
                      <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                <span class="glyphicon glyphicon-remove" id='close_id1' onclick="companycanceldetails()"></span> <span id='close_id' onclick="companycanceldetails()">Close</span>
                          </div>
                    </td></tr>
                   
                    </table>
                </div>
                <div id="div_comanydata"></div>
            </div>
                        </div>
                        <div id="div_holiday" style="display: none;">
                            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Holiday Master Details
                </h3>
            </div>
            <div class="box-body">
            <div id="holidayfill">  
                <table id="tbl_holiday" align="center">
                 
                    <tr>
                        <td style="height: 40px;">
                         <label class="control-label" > Holiday Name</label>
                        </td>
                        <td>
                            <input type="text" class="form-control" id="txt_Holiday"  placeholder="Enter Holiday" style="text-transform: capitalize;"/>
                        </td>
                    </tr>
                       <tr>
                             <td style="height:40px;">
                             <label class="control-label" >Optional</label><span style="color: red;font-weight:bold">*</span>     
                            </td>
                             <td>
                             <select ID="Slct_otional"  class="form-control">
                             <option value="1">National Holidays</option>
                             <option value="0">Festival Holidays</option>
                             </select>
                             </td>
                      </tr>
                    <tr>
                        <td style="height: 40px;">
                           <label class="control-label" > Date</label> <span style="color: red;font-weight:bold">*</span>
                        </td>
                        <td>
                           <input type="Date" class="form-control" id="txt_date"/>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        
                    </tr>
                    <tr hidden>
                        <td>
                            <label id="lbl_holidaysno">
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
                                <span class="glyphicon glyphicon-ok" id="btn_saveholiday1" onclick="save_edit_holiday()"></span> <span id="btn_saveholiday" onclick="save_edit_holiday()">save</span>
                             </div>
                    </td>
                    <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                <span class="glyphicon glyphicon-remove" id='btn_close1' onclick="forclearallholiday()"></span> <span id='btn_close' onclick="forclearallholiday()">Close</span>
                          </div>
                    </td></tr>
                   
                    </table>
            </div>
                <div id="div_holidaydata">
                </div>
            </div>
                        </div>
                        <div id="div_shiftData" style="display: none;">
                             <div class="box-header with-border">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i>Shift Master Details
            </h3>
        </div>
        <div class="box-body">
        <div id="shiftfills">
            <table id="tbl_shift" align="center">
               
                <tr>
                    <td style="height: 40px;">
                        <label class="control-label" >Shift Type</label>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="txtshifttype"  placeholder="Enter Shift Type" style="text-transform: capitalize;" onkeypress="return ValidateAlpha(event);"/>
                    </td>
                </tr>
                 <tr>
                    <td style="height: 40px;">
                       <label class="control-label" > Status</label><span style="color: red;font-weight:bold">*</span>
                    </td>
                    <td>
                        <select id="ddlshiftstatus" class="form-control">
                            <option value="1">Active</option>
                            <option value="0">InActive</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    
                </tr>
                <tr hidden>
                    <td>
                        <label id="lbl_shiftsno">
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
                                <span class="glyphicon glyphicon-ok" id="btn_shiftsave1" onclick="for_save_edit_shifttype()"></span> <span id="btn_shiftsave" onclick="for_save_edit_shifttype()">save</span>
                             </div>
                    </td>
                      <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                <span class="glyphicon glyphicon-remove" id='btn_closeshift1' onclick="forclearallshift()"></span> <span id='btn_closeshift' onclick="forclearallshift()">Close</span>
                          </div>
                    </td></tr>
                   
                    </table>
        </div>
            <div id="div_shiftdata">
            </div>
    </div>
                        </div>
                          <div id="div_bullten" style="display: none;">
                            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Bulletin Master Details
                </h3>
            </div>
            <div class="box-body">
            <div id="bulltenfill">
                <table id="tbl_buullten" align="center">
                 
                    <tr>
                        <td style="height: 40px;">
                           <label class="control-label" > Title </label>
                        </td>
                        <td>
                            <input type="text" class="form-control" id="txt_Title"  placeholder="Enter Title" style="text-transform: capitalize;" />
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 40px;">
                           <label class="control-label" > Description</label> <span style="color: red;font-weight:bold">*</span>
                        </td>
                        <td>
                            <textarea cols="35" rows="3" id="txt_Descrtn" class="form-control"  placeholder="Enter Content" ></textarea>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        
                    </tr>
                    <tr hidden>
                        <td>
                            <label id="lbl_bulltensno">
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
                             <span class="glyphicon glyphicon-ok" id="btn_savebullten1" onclick="save_edit_bulletin()"></span> <span id="btn_savebullten" onclick="save_edit_bulletin()">save</span>
                             </div>
                    </td>
                      <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                    <span class="glyphicon glyphicon-remove" id='btn_closebullten1' onclick="forclearallbullten()"></span> <span id='btn_closebullten' onclick="forclearallbullten()">Close</span>
                          </div>
                    </td></tr>
                   
                    </table>
            </div>
            
                <div id="div_bulentdata">
                </div>
                </div>
                </div>
                        </div>
                    </div>
                </div>
    </section>
</asp:Content>
