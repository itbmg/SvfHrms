<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="Employee.aspx.cs" Inherits="Employee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="css/schoolcustomcss.css?v=3002" rel="stylesheet" type="text/css" />
    <link href="autocomplete/jquery-ui.css?v=3002" rel="stylesheet" type="text/css" />
    
    <script type="text/javascript">
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
        //Function for only no
        function only_no() {
            $("#txt_experience").keydown(function (event) {
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
        $(document).unbind('keydown').bind('keydown', function (event) {
            var doPrevent = false;
            if (event.keyCode === 8) {
                var d = event.srcElement || event.target;
                if ((d.tagName.toUpperCase() === 'INPUT' && (d.type.toUpperCase() === 'TEXT' || d.type.toUpperCase() === 'PASSWORD'))
            || d.tagName.toUpperCase() === 'TEXTAREA') {
                    doPrevent = d.readOnly || d.disabled;
                } else {
                    doPrevent = true;
                }
            }

            if (doPrevent) {
                event.preventDefault();
            }
        });
        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranch(msg);
                        fillbranchname(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillbranch(msg) {
            var data = document.getElementById('Slect_Name');
            var length = data.options.length;
            document.getElementById('Slect_Name').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branchname";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].branchname;
                    option.value = msg[i].branchid;
                    data.appendChild(option);
                }
            }
        }
        function get_Desgnation_details() {
            var data = { 'op': 'get_Desgnation_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillroles(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillroles(msg) {
            var data = document.getElementById('slct_emprole');
            var length = data.options.length;
            document.getElementById('slct_emprole').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Desgnation";
            opt.value = "Select Desgnation";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].designation != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].designation;
                    option.value = msg[i].designationid;
                    data.appendChild(option);
                }
            }
        }
        function changedate() {
            var joindate = document.getElementById('dtp_joindate').value;
            document.getElementById('txt_confdate').value = joindate;
            document.getElementById('txt_CurrLocation').value = joindate;
            document.getElementById('txt_CurrDesignation').value = joindate;
            document.getElementById('txt_CurrDepartment').value = joindate;
            document.getElementById('txt_CurrEmployee').value = joindate;
        }

        function changeaddress() {
            var homeaddress = document.getElementById('txt_homeaddress').value;
            document.getElementById('txt_prsntads').value = homeaddress;
        }

        function get_IDProof_details() {
            var data = { 'op': 'get_IDProof_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillIDProofdetails(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillIDProofdetails(msg) {
            var data = document.getElementById('ddl_documenttype');
            var length = data.options.length;
            document.getElementById('ddl_documenttype').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Document ";
            opt.value = "Select Document";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].IDProof != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].IDProof;
                    option.value = msg[i].IDProofId;
                    data.appendChild(option);
                }
            }
        }
        function get_all_departments() {
            var data = { 'op': 'get_Dept_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        document.getElementById("slct_empdept").options.length = null;
                        var ddl_specialization = document.getElementById('slct_empdept');
                        var length = ddl_specialization.options.length;
                        ddl_specialization.options.length = null;
                        var opt1 = document.createElement('option');
                        opt1.innerHTML = "Select Department";
                        opt1.value = "Select Department";
                        ddl_specialization.appendChild(opt1);
                        for (var i = 0; i < msg.length; i++) {
                            var opt = document.createElement('option');
                            opt.innerHTML = msg[i].Department;
                            opt.value = msg[i].Deptid;
                            ddl_specialization.appendChild(opt);
                            $('#departmets').append('<tr><td><label name="dept_sno" style="display:none;">' + msg[i].Deptid + '</label><label><input name="department_checks" onchange="check_login(this)" type="checkbox" id="' + msg[i].Deptid + '"/>&nbsp;&nbsp;&nbsp;' + msg[i].Department + '</label></td></tr>');
                        }
                    }
                    else {

                    }
                }
                else {
                    document.location = "Default.aspx";
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function check_login(thisid) {
            var btnval = document.getElementById('save_employee').innerHTML;
            if (btnval == "Save") {
                if (document.getElementById('chk_add_login').checked == false) {
                    $(thisid).attr('checked', false);
                    alert("Please Give Login to this person to assign departments");
                }
            }
        }
        var employee_data = [];
        function get_all_Employeedetails() {
            var table = document.getElementById("tbl_empmaster");
            for (var i = table.rows.length - 1; i > 0; i--) {
                table.deleteRow(i);
            }
            var emp_status = document.getElementById("slct_Empfilter").value;
            var employee_type = document.getElementById("txt_empcode1").value;
            var data = { 'op': 'get_all_Employeedetails', 'emp_status': emp_status, 'employee_type': employee_type };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        employee_data = msg;
                        filldata(msg);
                        fillempcode(msg);
                        fillempname(msg);
                    }
                    else {
                    }
                }
                else {
                    document.location = "Default.aspx";
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function filldata(results) {
            var table = document.getElementById("tbl_empmaster");
            var j = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < results.length; i++) {
                if (results[i].empnum != null) {
                    var emp_sno = results[i].empsno;
                    var empnum = results[i].empnum;
                    var empname = results[i].empname;
                    var joindate = results[i].joindate;
                    var initials = results[i].initials;
                    var title = results[i].title;
                    var birthdate = results[i].birthdate;
                    var gender = results[i].gender;
                    var maritalstatus = results[i].maritalstatus;
                    var spousename = results[i].spousename;
                    var country = results[i].country;
                    var homeaddress = results[i].homeaddress;
                    var presentaddress = results[i].presentaddress;
                    var homephone = results[i].homephone;
                    var cellphone = results[i].cellphone;
                    var email = results[i].email;
                    var city = results[i].city;
                    var state = results[i].state;
                    var zipcode = results[i].zipcode;
                    var degree = results[i].degree;
                    var specification = results[i].specification;
                    var experience = results[i].experience;
                    var experiencedet = results[i].experiencedet;
                    var deptid = results[i].deptid;
                    var designationid = results[i].designationid;
                    var branchname = results[i].branchid;
                    var institute = results[i].institute;
                    var university = results[i].university;
                    var graders = results[i].graders;
                    var duration = results[i].duration;
                    var remarks = results[i].remarks;
                    var conformdate = results[i].conformdate;
                    var physicalchalnge = results[i].physicalchalnge;
                    var bloodgroup = results[i].bloodgroup;
                    var aadarenrollnumber = results[i].aadarenrollnumber;
                    var nameasforaadhar = results[i].nameasforaadhar;
                    var salarymode = results[i].salarymode;
                    var pancard = results[i].pancard;
                    var marriagedate = results[i].marriagedate;
                    var password = results[i].password;
                    var username = results[i].username;
                    var re_password = results[i].re_password;
                    var age = results[i].age;
                    var fathername = results[i].fathername;
                    var photo = results[i].photo;
                    var ftplocation = results[i].ftplocation;
                    var employeetype = results[i].employeetype;
                    var currentlocationsince = results[i].currentlocationsince;
                    var currentdesignationsince = results[i].currentdesignationsince;
                    var currentdepartmentsince = results[i].currentdepartmentsince;
                    var currentemployeesince = results[i].currentemployeesince;
                    var pfeligible = results[i].pfeligible;
                    var esieligible = results[i].esieligible;
                    var caste = results[i].caste;
                    var emergencynumber = results[i].emergencynumber;
                    var drivinglicense = results[i].drivinglicense;
                    var dateofvalidilty = results[i].dateofvalidilty;
                    var ledgercode = results[i].ledgercode;
                    var ledgername = results[i].ledgername;
                    var status = "";
                    if (results[i].status == 'No') {
                        status = "Active";
                    }
                    else {
                        status = "InActive";
                    }
                    var tablerowcnt = document.getElementById("tbl_empmaster").rows.length;
                    $('#tbl_empmaster').append('<tr style="background-color:' + COLOR[l] + '"><td>' + j++ + '</td><td data-title="empsno" >' + emp_sno + '</td><td data-title="Employee Number">' + empnum + '</td><td data-title="Title" style="display:none;" >' + title + '</td><th scope="row">' + empname + '</th><th scope="row">' + employeetype + '</th><td data-title="Join Date" >' + joindate + '</td><td data-title="Cell Phone">' + cellphone + '</td><td data-title="Status">' + status + '</td><td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background: #f44336 !important;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;color: #ffffff !important;border-color: #f44336 !important;"  onclick="updateclick(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>');
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
        }
        var empsno;
        var empcode;
        var prev_pass = "";
        function updateclick(thisid) {
            $('#div_addemp').css('display', 'block');
            $('#emp_showlogs').css('display', 'none');
            $('#div_empmaster_table').css('display', 'none');
            var selectedrow = $(thisid).closest('tr');
            var Empsno = selectedrow[0].cells[1].innerHTML;
            prev_pass = "";
            $('#tablerow_id').hide();
            $('#login_details').css('display', 'none');
            document.getElementById('chk_add_login').checked = false;
            for (var i = 0; i < employee_data.length; i++) {
                if (Empsno == employee_data[i].empsno) {
                    empsno = employee_data[i].empsno;
                    empcode = employee_data[i].empnum;

                    document.getElementById('lbl_topempname').innerHTML = employee_data[i].empname;
                    document.getElementById('lbl_topemployeeid').innerHTML = employee_data[i].empnum;
                    document.getElementById('lbl_topempemailid').innerHTML = employee_data[i].email;
                    document.getElementById('lbl_topempmobno').innerHTML = employee_data[i].cellphone;
                    document.getElementById('txt_empnum').value = employee_data[i].empnum;
                    document.getElementById('txt_empname').value = employee_data[i].empname;
                    document.getElementById('dtp_joindate').value = employee_data[i].joindate;
                    document.getElementById('txt_initials').value = employee_data[i].initials;
                    if (employee_data[i].title != "") {
                        document.getElementById('slct_title').value = employee_data[i].title;
                    }
                    else {
                        document.getElementById('slct_title').selectedIndex = "2";
                    }
                    document.getElementById('dtp_birthdate').value = employee_data[i].birthdate;
                    var date = new Date(document.getElementById("dtp_birthdate").value);
                    var today = new Date();
                    var timeDiff = Math.abs(today.getTime() - date.getTime());
                    var age1 = Math.ceil(timeDiff / (1000 * 3600 * 24)) / 365;
                    document.getElementById('txt_Age').value = parseFloat(age1).toFixed(0);
                    if (employee_data[i].gender != "") {
                        document.getElementById('slct_gender').value = employee_data[i].gender;
                    }
                    else {
                        document.getElementById('slct_gender').selectedIndex = "2";
                    }
                    if (employee_data[i].maritalstatus != "") {
                        document.getElementById('slct_maritalstatus').value = employee_data[i].maritalstatus;
                    }
                    else {
                        document.getElementById('slct_maritalstatus').selectedIndex = "0";
                    }
                    document.getElementById('txt_spousename').value = employee_data[i].spousename;
                    if (employee_data[i].country != "") {
                        document.getElementById('slct_country').value = employee_data[i].country;
                    }
                    else {
                        document.getElementById('slct_country').selectedIndex = "0";
                    }
                    document.getElementById('txt_homeaddress').value = employee_data[i].homeaddress;
                    document.getElementById('txt_prsntads').value = employee_data[i].presentaddress;
                    document.getElementById('txt_homephone').value = employee_data[i].homephone;
                    document.getElementById('txt_cellphone').value = employee_data[i].cellphone;
                    document.getElementById('txt_email').value = employee_data[i].email;
                    document.getElementById('txt_city').value = employee_data[i].city;
                    document.getElementById('txt_state').value = employee_data[i].state;
                    document.getElementById('txt_zipcode').value = employee_data[i].zipcode;
                    document.getElementById('txt_degree').value = employee_data[i].degree;
                    document.getElementById('txt_specification').value = employee_data[i].specification;
                    document.getElementById('txt_experience').value = employee_data[i].experience;
                    document.getElementById('txt_experiencedetails').value = employee_data[i].experiencedet;
                    document.getElementById('Slect_Name').value = employee_data[i].branchid;
                    document.getElementById('Slect_Name').readonly;
                    document.getElementById('slct_emprole').value = employee_data[i].designationid;
                    if (employee_data[i].deptid != "") {
                        document.getElementById('slct_empdept').value = employee_data[i].deptid;
                    }
                    else {
                        document.getElementById('slct_empdept').selectedIndex = "0";
                    }
                    if (employee_data[i].status != "") {
                        document.getElementById('slct_status').value = employee_data[i].status;
                        document.getElementById('slct_status').readonly;
                    }
                    else {
                        document.getElementById('slct_status').selectedIndex = "0";
                        document.getElementById('slct_status').readonly;
                    }
                    document.getElementById('save_employee').innerHTML = "Modify";
                    document.getElementById('txt_aboutme').value = employee_data[i].aboutus;
                    document.getElementById('txt_spousedetails').value = employee_data[i].spouse_details;
                    document.getElementById('txt_voterid').value = employee_data[i].voter_id;
                    document.getElementById('txt_aadharno').value = employee_data[i].aadhaar_id;
                    document.getElementById('txt_Institute').value = employee_data[i].institute;
                    document.getElementById('txt_University').value = employee_data[i].university;
                    document.getElementById('txt_Graders').value = employee_data[i].graders;
                    document.getElementById('txt_Duration').value = employee_data[i].duration;
                    document.getElementById('txt_remarks').value = employee_data[i].remarks;
                    document.getElementById('txt_Bloodgroup').value = employee_data[i].bloodgroup;
                    document.getElementById('txt_Pancard').value = employee_data[i].pancard;
                    document.getElementById('txt_aadharenrollno').value = employee_data[i].aadarenrollnumber;
                    document.getElementById('txt_nameasforaadhar').value = employee_data[i].nameasforaadhar;
                    document.getElementById('txt_confdate').value = employee_data[i].conformdate;
                    document.getElementById('slct_physical').value = employee_data[i].physicalchalnge;
                    document.getElementById('select_Salarymode').value = employee_data[i].salarymode;
                    document.getElementById('txt_Marrigedate').value = employee_data[i].marriagedate;
                    document.getElementById('txt_Fathername').value = employee_data[i].fathername;
                    document.getElementById('slct_employeetype').value = employee_data[i].employeetype;
                    document.getElementById('txt_CurrLocation').value = employee_data[i].currentlocationsince;
                    document.getElementById('txt_CurrDesignation').value = employee_data[i].currentdesignationsince;
                    document.getElementById('txt_CurrDepartment').value = employee_data[i].currentdepartmentsince;
                    document.getElementById('txt_CurrEmployee').value = employee_data[i].currentemployeesince;
                    document.getElementById('slct_PFeligible').value = employee_data[i].pfeligible;
                    document.getElementById('slct_Esieligible').value = employee_data[i].esieligible;
                    document.getElementById('txt_Emergencynum').value = employee_data[i].emergencynumber;
                    document.getElementById('txt_caste').value = employee_data[i].caste;
                    document.getElementById('txt_drvinglicence').value = employee_data[i].drivinglicense;
                    document.getElementById('txt_licencedate').value = employee_data[i].dateofvalidilty;
                    document.getElementById('txtusername').value = employee_data[i].username;
                    document.getElementById('txt_password').value = employee_data[i].passsword;
                    document.getElementById('txt_repassword').value = employee_data[i].re_password;
                    document.getElementById('txt_ledgercode').value = employee_data[i].ledgercode;
                    document.getElementById('txt_ledgername').value = employee_data[i].ledgername;

                    document.getElementById('lbl_emploginsno').innerHTML = "";
                    document.getElementById('lbl_emploginsno').innerHTML = employee_data[i].pass_sno;
                    if (employee_data[i].password != "" && employee_data[i].password != null && typeof employee_data[i].password != "undefined") {
                        prev_pass = employee_data[i].password;
                        $('#tablerow_id').show();
                        if (employee_data[i].pass_sno != "" && employee_data[i].pass_sno != null && typeof employee_data[i].pass_sno != "undefined") {
                            document.getElementById('add_login').innerHTML = "Change Password";
                        }
                    }
                    var rndmnum = Math.floor((Math.random() * 10) + 1);
                    img_url = employee_data[i].ftplocation + employee_data[i].photo + '?v=' + rndmnum;
                    if (employee_data[i].photo != "") {
                        $('#main_img').attr('src', img_url).width(200).height(200);
                    }
                    else {
                        $('#main_img').attr('src', 'Images/Employeeimg.jpg').width(200).height(200);
                    }
                    getemployee_Uploaded_Documents(empsno);
                }
            }
        }
        function getemployee_Uploaded_Documents(empsno) {
            var data = { 'op': 'getemployee_Uploaded_Documents', 'empsno': empsno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillemployee_Uploaded_Documents(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillemployee_Uploaded_Documents(msg) {

            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Document Name</th><th scope="col">Photo</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td>' + k++ + '</td>';
                var path = img_url = msg[i].ftplocation + msg[i].photo;
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].documentname + '</th>';
                results += '<td data-title="brandstatus" class="2"><img src=' + path + '  style="cursor:pointer;height:200px;width:200px;border-radius: 5px;"/></td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#div_documents_table").html(results);
        }
        function clearcontrols() {
            document.getElementById('txt_empnum').value = "";
            document.getElementById('txt_empname').value = "";
            document.getElementById('dtp_joindate').value = "";
            document.getElementById('txt_initials').value = "";
            document.getElementById('slct_title').selectedIndex = "0";
            document.getElementById('dtp_birthdate').value = "";
            document.getElementById('slct_gender').selectedIndex = "0";
            document.getElementById('slct_maritalstatus').selectedIndex = "0";
            document.getElementById('txt_spousename').value = "";
            document.getElementById('slct_country').selectedIndex = "0";
            document.getElementById('txt_homeaddress').value = "";
            document.getElementById('txt_prsntads').value = "";
            document.getElementById('txt_homephone').value = "";
            document.getElementById('txt_cellphone').value = "";
            document.getElementById('txt_email').value = "";
            document.getElementById('txt_city').value = "";
            document.getElementById('txt_state').value = "";
            document.getElementById('txt_zipcode').value = "";
            document.getElementById('txt_degree').value = "";
            document.getElementById('txt_specification').value = "";
            document.getElementById('txt_experience').value = "";
            document.getElementById('txt_experiencedetails').value = "";
            document.getElementById('slct_empdept').selectedIndex = "0";
            document.getElementById('slct_emprole').selectedIndex = "0";
            document.getElementById('slct_status').selectedIndex = "0";
            document.getElementById('txt_confdate').value = "";
            document.getElementById('slct_physical').selectedIndex = "0";
            document.getElementById('Slect_Name').selectedIndex = "0";
            document.getElementById('txt_Institute').value = "";
            document.getElementById('txt_University').value = "";
            document.getElementById('txt_Graders').value = "";
            document.getElementById('txt_Duration').value = "";
            document.getElementById('txt_remarks').value = "";
            document.getElementById('txt_Bloodgroup').value = "";
            document.getElementById('txt_Pancard').value = "";
            document.getElementById('txt_aadharenrollno').value = "";
            document.getElementById('txt_nameasforaadhar').value = "";
            document.getElementById('select_Salarymode').selectedIndex = "0";
            document.getElementById('txt_Age').value = "";
            document.getElementById('txt_Fathername').value = "";
            document.getElementById('txt_Marrigedate').value = "";
            document.getElementById('slct_employeetype').value = "";
            document.getElementById('txt_CurrLocation').value = "";
            document.getElementById('txt_CurrDesignation').value = "";
            document.getElementById('txt_CurrDepartment').value = "";
            document.getElementById('txt_CurrEmployee').value = "";
            document.getElementById('slct_PFeligible').value = "";
            document.getElementById('slct_Esieligible').value = "";
            document.getElementById('txt_Emergencynum').value = "";
            document.getElementById('txt_caste').value = "";
            document.getElementById('txt_drvinglicence').value = "";
            document.getElementById('txt_licencedate').value = "";
            document.getElementById('txtusername').value = "";
            document.getElementById('txt_repassword').value = "";
            document.getElementById('txt_password').value = "";
            document.getElementById('lbl_topemployeeid').innerHTML = "";
            document.getElementById('lbl_topempname').innerHTML = "";
            document.getElementById('lbl_topempemailid').innerHTML = "";
            document.getElementById('lbl_topempmobno').innerHTML = "";
            document.getElementById('lbl_topempmobno').innerHTML = "";
            document.getElementById('txt_ledgercode').value = "";
            document.getElementById('txt_ledgername').value = "";
            document.getElementById('main_img').src = "Images / Employeeimg.jpg";
            document.getElementById('save_employee').innerHTML = "Save";
            document.getElementById('add_login').innerHTML = "Add Login";
            $('#departmets').find('tr').each(function () {
                $(this).find('[name=department_checks]').prop("checked", false);
            });
            empsno = null;
            empcode = null;
            document.getElementById('txt_aboutme').value = "";
            document.getElementById('txt_spousedetails').value = "";
            document.getElementById('txt_voterid').value = "";
            document.getElementById('txt_aadharno').value = "";
        }
        $(function () {
            get_all_departments();
            get_Branch_details();
            get_Desgnation_details();
            get_all_Employeedetails();
            get_IDProof_details();
            $("#chk_add_login").click(function () {
                if (this.checked == true) {
                    $("#login_details").css("display", "block");
                    if (prev_pass != "" && prev_pass != null && typeof prev_pass != "undefined") {
                        $('#tablerow_id').show();
                    }
                    else {
                        $('#tablerow_id').hide();
                    }
                }
                else {
                    $("#login_details").css("display", "none");
                }
            });
            $('#add_employee').click(function () {
                clearcontrols();
                $('#div_addemp').css('display', 'block');
                $('#emp_showlogs').css('display', 'none');
                $('#div_empmaster_table').css('display', 'none');
                prev_pass = "";
                $('#tablerow_id').hide();
                $('#login_details').css('display', 'none');
                document.getElementById('chk_add_login').checked = false;
            });
            $('#close_empdiv').click(function () {
                clearcontrols();
                $('#div_addemp').css('display', 'none');
                $('#emp_showlogs').css('display', 'block');
                $('#div_empmaster_table').css('display', 'block');
            });
            $('#save_employee').click(function () {
                var empnum = document.getElementById('txt_empnum').value;
                if (empnum == "") {
                    $("#txt_empnum").focus();
                    alert("Please Enter Employee Number ");
                    return false;
                }
                var empname = document.getElementById('txt_empname').value;
                if (empname == "") {
                    $("#txt_empname").focus();
                    alert("Please Enter Employee Name");
                    return;
                }
                var joindate = document.getElementById('dtp_joindate').value;
                if (joindate == "") {
                    $("#dtp_joindate").focus();
                    alert("Please Enter joindate ");
                    return false;
                }
                var initials = document.getElementById('txt_initials').value;
                var title = document.getElementById('slct_title').value;
                if (title == "") {
                    $("#slct_title").focus();
                    alert("Please Enter title ");
                    return false;
                }
                var birthdate = document.getElementById('dtp_birthdate').value;
                if (birthdate == "") {
                    $("#dtp_birthdate").focus();
                    alert("Please Enter birthdate ");
                    return false;
                }
                var gender = document.getElementById('slct_gender').value;
                if (gender == "") {
                    $("#slct_gender").focus();
                    alert("Please Select gender ");
                    return false;
                }
                var maritalstatus = document.getElementById('slct_maritalstatus').value;
                var spousename = document.getElementById('txt_spousename').value;
                var country = document.getElementById('slct_country').value;
                var homeaddress = document.getElementById('txt_homeaddress').value;
                var presentaddress = document.getElementById('txt_prsntads').value;
                var homephone = document.getElementById('txt_homephone').value;
                var cellphone = document.getElementById('txt_cellphone').value;
                var email = document.getElementById('txt_email').value;
                var city = document.getElementById('txt_city').value;
                var state = document.getElementById('txt_state').value;
                var zipcode = document.getElementById('txt_zipcode').value;
                var degree = document.getElementById('txt_degree').value;
                if (degree == "") {
                    $("#txt_degree").focus();
                    alert("Please Enter degree ");
                    return false;
                }
                var specification = document.getElementById('txt_specification').value;
                var institute = document.getElementById('txt_Institute').value;
                var university = document.getElementById('txt_University').value;
                var graders = document.getElementById('txt_Graders').value;
                var duration = document.getElementById('txt_Duration').value;
                var remarks = document.getElementById('txt_remarks').value;
                var experience = document.getElementById('txt_experience').value;
                var experiencedetails = document.getElementById('txt_experiencedetails').value;
                var deptid = document.getElementById('slct_empdept').value;
                if (deptid == "") {
                    $("#slct_empdept").focus();
                    alert("Please Select Employee Department ");
                    return false;
                }
                var branchname = document.getElementById('Slect_Name').value;
                if (branchname == "Select Branchname") {
                    $("#Slect_Name").focus();
                    alert("Please Enter Branch Name ");
                    return false;
                }
                var employeetype = document.getElementById('slct_employeetype').value;
                if (employeetype == "Select Employeetype") {
                    $("#slct_employeetype").focus();
                    alert("Please Select Employeetype");
                    return;
                }
                var designationid = document.getElementById('slct_emprole').value;
                if (designationid == "Select Designation") {
                    $("#slct_emprole").focus();
                    alert("Please Select Designation");
                    return;
                }
                var conformdate = document.getElementById('txt_confdate').value;
                if (conformdate == "") {
                    $("#txt_confdate").focus();
                    alert("Please Select conformdate");
                    return;
                }
                var currentlocationsince = document.getElementById('txt_CurrLocation').value;
                var currentdesignationsince = document.getElementById('txt_CurrDesignation').value;
                var currentdepartmentsince = document.getElementById('txt_CurrDepartment').value;
                var currentemployeesince = document.getElementById('txt_CurrEmployee').value;
                var physicalchalnge = document.getElementById('slct_physical').value;
                var bloodgroup = document.getElementById('txt_Bloodgroup').value;
                var pancard = document.getElementById('txt_Pancard').value;
                var aadarenrollnumber = document.getElementById('txt_aadharenrollno').value;
                var aadhar_id = document.getElementById('txt_aadharno').value;
                var pfeligible = document.getElementById('slct_PFeligible').value;
                if (pfeligible == "") {
                    $("#slct_PFeligible").focus();
                    alert("Please Select PF Eligible");
                    return;
                }
                var esieligible = document.getElementById('slct_Esieligible').value;
                if (esieligible == "") {
                    $("#slct_Esieligible").focus();
                    alert("Please Select ESI Eligible");
                    return;
                }
                var nameasforaadhar = document.getElementById('txt_nameasforaadhar').value;
                var status = document.getElementById('slct_status').value;
                var drivinglicense = document.getElementById('txt_drvinglicence').value;
                var dateofvalidilty = document.getElementById('txt_licencedate').value;
                var ledgercode = document.getElementById('txt_ledgercode').value;
                var ledgername = document.getElementById('txt_ledgername').value;
                var emp_login_sno = document.getElementById('lbl_emploginsno').innerHTML;
                var login_check = "";
                var password = "";
                var username = "";
                var re_password = "";
                var prev_password = "";
                var leveltype = "";
                if (document.getElementById('chk_add_login').checked == true) {
                    username = document.getElementById('txtusername').value;
                    password = document.getElementById('txt_password').value;
                    leveltype = document.getElementById('slct_leveltype').value;
                    if (username == "") {
                        $("#txtusername").focus();
                        alert("Please Enter UserName");
                        return;
                    }
                    if (password == "") {
                        alert("Please Enter Password");
                        return;
                    }
                    if (leveltype == "") {
                        alert("Please Enter leveltype");
                        return;
                    }
                    re_password = document.getElementById('txt_repassword').value;
                    if (re_password == "") {
                        alert("Please Verify your password");
                        return;
                    }
                    prev_password = document.getElementById('txt_prevpassword').value;
                    login_check = "checked";
                }
                var departments = "";
                $('#departmets').find('tr').each(function () {
                    if ($(this).find('[name=department_checks]').is(":checked")) {
                        departments += $(this).find('[name=dept_sno]').text() + ",";
                    }
                });
                departments = departments.substring(0, departments.length - 1);
                var btnval = document.getElementById('save_employee').innerHTML;
                if (empnum == "") {
                    alert("Please Enter Employee Number");
                    return false;
                }
                if (empname == "") {
                    alert("Please Enter Employee Name");
                    return false;
                }
                var about_me = document.getElementById('txt_aboutme').value;

                var pfstate = document.getElementById('slctpfstate').value;

                var spouse_details = document.getElementById('txt_spousedetails').value;
                var voterid = document.getElementById('txt_voterid').value;
                var fathername = document.getElementById('txt_Fathername').value;
                var age = document.getElementById('txt_Age').value;
                var marriagedate = document.getElementById('txt_Marrigedate').value;
                var caste = document.getElementById('txt_caste').value;
                var emergencynumber = document.getElementById('txt_Emergencynum').value;
                var salarymode = document.getElementById('select_Salarymode').value;
                if (salarymode == "Select salarymode") {
                    alert("Please Select salarymode");
                    return;
                }
                if (btnval == "Save") {
                    if (document.getElementById('chk_add_login').checked == false) {
                        if (departments.length > 0) {
                            alert("Please Give Login to this person to assign departments");
                            return;
                        }
                    }
                    confi = confirm("Do you want to SAVE Employee Details ?");
                }
                else {
                    if (empsno == null) {
                        alert("Something went wrong,please try again");
                        return;
                    }
                    if (document.getElementById('chk_add_login').checked == true) {
                        if (prev_pass != prev_password) {
                            alert("Previous Passwords Not Matched");
                            return;
                        }
                    }
                    confi = confirm("Do you want to EDIT  Employee Details ?");
                }
                if (confi) {
                    var Data = { 'op': 'Employee_details_save', 'empnum': empnum, 'empname': empname, 'joindate': joindate, 'initials': initials, 'title': title,
                        'birthdate': birthdate, 'gender': gender, 'maritalstatus': maritalstatus, 'spousename': spousename, 'country': country,
                        'homeaddress': homeaddress, 'presentaddress': presentaddress, 'homephone': homephone, 'cellphone': cellphone, 'email': email, 'city': city, 'state': state, 'zipcode': zipcode,
                        'degree': degree, 'specification': specification, 'experience': experience, 'experiencedetails': experiencedetails, 'deptid': deptid, 'designationid': designationid, 'status': status,
                        'btnval': btnval, 'empsno': empsno, 'username': username, 'password': password, 're_password': re_password, 'leveltype': leveltype, 'login_check': login_check, 'departments': departments,
                        'emp_login_sno': emp_login_sno, 'about_me': about_me, 'spouse_details': spouse_details, 'voterid': voterid, 'aadhar_id': aadhar_id, 'conformdate': conformdate,
                        'physicalchalnge': physicalchalnge, 'bloodgroup': bloodgroup, 'pancard': pancard, 'aadarenrollnumber': aadarenrollnumber, 'nameasforaadhar': nameasforaadhar,
                        'institute': institute, 'university': university, 'graders': graders, 'duration': duration, 'remarks': remarks, 'branchname': branchname, 'salarymode': salarymode, 'marriagedate': marriagedate, 'age': age, 'fathername': fathername, 'employeetype': employeetype,
                        'currentlocationsince': currentlocationsince, 'currentdesignationsince': currentdesignationsince, 'currentdepartmentsince': currentdepartmentsince, 'currentemployeesince': currentemployeesince, 'pfeligible': pfeligible, 'esieligible': esieligible, 'caste': caste, 'emergencynumber': emergencynumber, 'drivinglicense': drivinglicense, 'dateofvalidilty': dateofvalidilty, 'ledgercode': ledgercode, 'ledgername': ledgername, 'pfstate': pfstate
                    };
                    var s = function (msg) {
                        if (msg) {
                            alert(msg);
                            get_all_Employeedetails();
                            $('#div_addemp').css('display', 'block');
                            $('#emp_showlogs').css('display', 'none');
                            $('#div_empmaster_table').css('display', 'none');
                        }
                        else {
                            document.location = "Default.aspx";
                        }
                    };
                    var e = function (x, h, e) {
                    };
                    callHandler(Data, s, e);
                }
            });
        });

        //-------------> allow only required extention
        function hasExtension(fileName, exts) {
            return (new RegExp('(' + exts.join('|').replace(/\./g, '\\.') + ')$')).test(fileName);
        }

        function readURL(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#main_img,#img_1').attr('src', e.target.result).width(200).height(200);
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function getFile() {
            document.getElementById("file").click();
        }
        //----------------> convert base 64 to file
        function dataURItoBlob(dataURI) {
            // convert base64/URLEncoded data component to raw binary data held in a string
            var byteString;
            if (dataURI.split(',')[0].indexOf('base64') >= 0)
                byteString = atob(dataURI.split(',')[1]);
            else
                byteString = unescape(dataURI.split(',')[1]);
            // separate out the mime component
            var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];
            // write the bytes of the string to a typed array
            var ia = new Uint8Array(byteString.length);
            for (var i = 0; i < byteString.length; i++) {
                ia[i] = byteString.charCodeAt(i);
            }
            return new Blob([ia], { type: 'image/jpeg' });
        }
        function upload_profile_pic() {
            var dataURL = document.getElementById('main_img').src;
            var div_text = $('#yourBtn').text().trim();
            var blob = dataURItoBlob(dataURL);
            var Data = new FormData();
            Data.append("op", "emp_profile_pic_files_upload");
            Data.append("empsno", empsno);
            Data.append("empcode", empcode);
            Data.append("canvasImage", blob);
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    document.getElementById('btn_upload_profilepic').disabled = true;
                }
                else {
                    document.location = "Default.aspx";
                }
            };
            var e = function (x, h, e) {
            };
            callHandler_nojson_post(Data, s, e);
        }

        function callHandler_nojson_post(d, s, e) {
            $.ajax({
                url: 'EmployeeManagementHandler.axd',
                type: "POST",
                // dataType: "json",
                contentType: false,
                processData: false,
                data: d,
                success: s,
                error: e
            });
        }
        function change_Documents() {
            $("li").removeClass("active");
            $("li").addClass("");
            $("#id_tab_documents").removeClass("");
            $("#id_tab_documents").addClass("active");
            $("#div_basic_details").css("display", "none");
            $("#btn_modify").css("display", "none");
            $("#div_Documents").css("display", "block");
        }
        function change_Personal() {
            $("li").removeClass("active");
            $("li").addClass("");
            $("#id_tab_documents").removeClass("");
            $("#id_tab_documents").addClass("active");
            $("#div_basic_details").css("display", "block");
            $("#btn_modify").css("display", "block");
            $("#div_Documents").css("display", "none");
        }
        function getFile_doc() {
            document.getElementById("FileUpload1").click();
        }
        function upload_Employee_Document_Info() {
            var documentid = document.getElementById('ddl_documenttype').value;
            var documentname = document.getElementById('ddl_documenttype').selectedOptions[0].innerText;
            if (documentid == null || documentid == "" || documentid == "Select Document Type") {
                document.getElementById("ddl_documenttype").focus();
                alert("Please select Document Type");
                return false;
            }
            var documentExists = 0;
            $('#tbl_documents tr').each(function () {
                var selectedrow = $(this);
                var document_manager_id = selectedrow[0].cells[0].innerHTML;
                if (document_manager_id == documentid) {
                    alert(documentname + "  Already Exist For This Employee");
                    documentExists = 1;
                    return false;
                }

            });
            if (documentExists == 1) {
                return false;
            }
            var Data = new FormData();
            Data.append("op", "save_employeeDocument");
            Data.append("empsno", empsno);
            Data.append("empcode", empcode);
            Data.append("documentname", documentname);
            Data.append("documentid", documentid);
            var fileUpload = $("#FileUpload1").get(0);
            var files = fileUpload.files;
            for (var i = 0; i < files.length; i++) {
                Data.append(files[i].name, files[i]);
            }

            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    getemployee_Uploaded_Documents(empsno);
                }
            };
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler_nojson_post(Data, s, e);
        }
        function readURL_doc(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.readAsDataURL(input.files[0]);
                document.getElementById("FileUpload_div").innerHTML = input.files[0].name;
            }
        }
        var branchnameList = [];
        function fillbranchname(msg) {
            for (var i = 0; i < msg.length; i++) {
                var branchname = msg[i].branchname;
                branchnameList.push(branchname);
            }
            $('#txt_Branch1').autocomplete({
                source: branchnameList,
                change: brnachnamechange,
                autoFocus: true
            });
        }
        var emp_sno = 0;
        function brnachnamechange() {
            var table = document.getElementById("tbl_empmaster");
            for (var i = table.rows.length - 1; i > 0; i--) {
                table.deleteRow(i);
            }
            var results = employee_data;
            var employeetype = document.getElementById('txt_empcode1').value;
            var branchname = document.getElementById('txt_Branch1').value;
            if (branchname == "") {
                var k = 1;
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                for (var i = 0; i < results.length; i++) {
                    if (results[i].empnum != null) {
                        var emp_sno = results[i].empsno;
                        var empnum = results[i].empnum;
                        var empname = results[i].empname;
                        var joindate = results[i].joindate;
                        var initials = results[i].initials;
                        var title = results[i].title;
                        var birthdate = results[i].birthdate;
                        var gender = results[i].gender;
                        var maritalstatus = results[i].maritalstatus;
                        var spousename = results[i].spousename;
                        var country = results[i].country;
                        var homeaddress = results[i].homeaddress;
                        var presentaddress = results[i].presentaddress;
                        var homephone = results[i].homephone;
                        var cellphone = results[i].cellphone;
                        var email = results[i].email;
                        var city = results[i].city;
                        var state = results[i].state;
                        var zipcode = results[i].zipcode;
                        var degree = results[i].degree;
                        var specification = results[i].specification;
                        var experience = results[i].experience;
                        var experiencedet = results[i].experiencedet;
                        var deptid = results[i].deptid;
                        var designationid = results[i].designationid;
                        var branchname = results[i].branchid;
                        var institute = results[i].institute;
                        var university = results[i].university;
                        var graders = results[i].graders;
                        var duration = results[i].duration;
                        var remarks = results[i].remarks;
                        var conformdate = results[i].conformdate;
                        var physicalchalnge = results[i].physicalchalnge;
                        var bloodgroup = results[i].bloodgroup;
                        var aadarenrollnumber = results[i].aadarenrollnumber;
                        var nameasforaadhar = results[i].nameasforaadhar;
                        var salarymode = results[i].salarymode;
                        var pancard = results[i].pancard;
                        var marriagedate = results[i].marriagedate;
                        var age = results[i].age;
                        var fathername = results[i].fathername;
                        var employeetype = results[i].employeetype;
                        var currentlocationsince = results[i].currentlocationsince;
                        var currentdesignationsince = results[i].currentdesignationsince;
                        var currentdepartmentsince = results[i].currentdepartmentsince;
                        var currentemployeesince = results[i].currentemployeesince;
                        var pfeligible = results[i].pfeligible;
                        var esieligible = results[i].esieligible;
                        var caste = results[i].caste;
                        var password = results[i].password;
                        var username = results[i].username;
                        var re_password = results[i].re_password;
                        var emergencynumber = results[i].emergencynumber;
                        var photo = results[i].photo;
                        var ftplocation = results[i].ftplocation;
                        var drivinglicense = results[i].drivinglicense;
                        var dateofvalidilty = results[i].dateofvalidilty;
                        var ledgercode = results[i].ledgercode;
                        var ledgername = results[i].ledgername;
                        var status = "";
                        if (results[i].status == 'No') {
                            status = "Active";
                        }
                        else {
                            status = "InActive";
                        }
                        var tablerowcnt = document.getElementById("tbl_empmaster").rows.length;
                        $('#tbl_empmaster').append('<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td><td data-title="empsno"  >' + emp_sno + '</td><td data-title="Employee Number">' + empnum + '</td><th scope="row">' + empname + '</th><td data-title="Title" style="display:none;" >' + title + '</td><th scope="row">' + employeetype + '</th><td data-title="Join Date">' + joindate + '</td><td data-title="Cell Phone">' + cellphone + '</td><td data-title="Status">' + status + '</td><td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background: #f44336 !important;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;color: #ffffff !important;border-color: #f44336 !important;"  onclick="updateclick(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>');
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
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                for (var i = 0; i < results.length; i++) {
                    if (branchname == results[i].branchname) {
                        var emp_sno = results[i].empsno;
                        var empnum = results[i].empnum;
                        var empname = results[i].empname;
                        var joindate = results[i].joindate;
                        var initials = results[i].initials;
                        var title = results[i].title;
                        var birthdate = results[i].birthdate;
                        var gender = results[i].gender;
                        var maritalstatus = results[i].maritalstatus;
                        var spousename = results[i].spousename;
                        var country = results[i].country;
                        var homeaddress = results[i].homeaddress;
                        var presentaddress = results[i].presentaddress;
                        var homephone = results[i].homephone;
                        var cellphone = results[i].cellphone;
                        var email = results[i].email;
                        var city = results[i].city;
                        var state = results[i].state;
                        var zipcode = results[i].zipcode;
                        var degree = results[i].degree;
                        var specification = results[i].specification;
                        var experience = results[i].experience;
                        var experiencedet = results[i].experiencedet;
                        var deptid = results[i].deptid;
                        var designationid = results[i].designationid;
                        var Branchname = results[i].branchid;
                        var institute = results[i].institute;
                        var university = results[i].university;
                        var graders = results[i].graders;
                        var duration = results[i].duration;
                        var remarks = results[i].remarks;
                        var conformdate = results[i].conformdate;
                        var physicalchalnge = results[i].physicalchalnge;
                        var bloodgroup = results[i].bloodgroup;
                        var aadarenrollnumber = results[i].aadarenrollnumber;
                        var nameasforaadhar = results[i].nameasforaadhar;
                        var salarymode = results[i].salarymode;
                        var pancard = results[i].pancard;
                        var marriagedate = results[i].marriagedate;
                        var age = results[i].age;
                        var password = results[i].password;
                        var username = results[i].username;
                        var re_password = results[i].re_password;
                        var fathername = results[i].fathername;
                        var employeetype = results[i].employeetype;
                        var photo = results[i].photo;
                        var currentlocationsince = results[i].currentlocationsince;
                        var currentdesignationsince = results[i].currentdesignationsince;
                        var currentdepartmentsince = results[i].currentdepartmentsince;
                        var currentemployeesince = results[i].currentemployeesince;
                        var pfeligible = results[i].pfeligible;
                        var esieligible = results[i].esieligible;
                        var caste = results[i].caste;
                        var emergencynumber = results[i].emergencynumber;
                        var ftplocation = results[i].ftplocation;
                        var drivinglicense = results[i].drivinglicense;
                        var dateofvalidilty = results[i].dateofvalidilty;
                        var ledgercode = results[i].ledgercode;
                        var ledgername = results[i].ledgername;
                        var status = "";
                        if (results[i].status == 'No') {
                            status = "Active";
                        }
                        else {
                            status = "InActive";
                        }
                        var tablerowcnt = document.getElementById("tbl_empmaster").rows.length;
                        $('#tbl_empmaster').append('<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td><td data-title="empsno"  >' + emp_sno + '</td><td data-title="Employee Number">' + empnum + '</td><th scope="row">' + empname + '</th><td data-title="Title" style="display:none;" >' + title + '</td><th scope="row">' + employeetype + '</th><td data-title="Join Date">' + joindate + '</td><td data-title="Cell Phone">' + cellphone + '</td><td data-title="Status">' + status + '</td><td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background: #f44336 !important;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;color: #ffffff !important;border-color: #f44336 !important;"  onclick="updateclick(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>');
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }
            }
        }

        function calculateAge() {
            var date = new Date(document.getElementById("dtp_birthdate").value);
            var today = new Date();
            var timeDiff = Math.abs(today.getTime() - date.getTime());
            var age1 = Math.ceil(timeDiff / (1000 * 3600 * 24)) / 365;
            document.getElementById('txt_Age').value = parseFloat(age1).toFixed(0); 
        }

        function validationemail() {
            var x = document.getElementById("txt_email").value;
            var atpos = x.indexOf("@");
            var dotpos = x.lastIndexOf(".");
            if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= x.length) {
                alert("Not a valid e-mail address");

            }
        }
        var empnameList = [];
        function fillempname(msg) {
            for (var i = 0; i < msg.length; i++) {
                var empname = msg[i].empname;
                empnameList.push(empname);
            }
            $('#txt_empname1').autocomplete({
                source: empnameList,
                change: empnamechange,
                autoFocus: true
            });
        }
        function empnamechange() {
            var table = document.getElementById("tbl_empmaster");
            for (var i = table.rows.length - 1; i > 0; i--) {
                table.deleteRow(i);
            }
            var results = employee_data;
            var empname = document.getElementById('txt_empname1').value;
            if (empname == "") {
                var k = 1;
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                for (var i = 0; i < results.length; i++) {
                    if (results[i].empnum != null) {
                        var emp_sno = results[i].empsno;
                        var empnum = results[i].empnum;
                        var empname = results[i].empname;
                        var joindate = results[i].joindate;
                        var initials = results[i].initials;
                        var title = results[i].title;
                        var birthdate = results[i].birthdate;
                        var gender = results[i].gender;
                        var maritalstatus = results[i].maritalstatus;
                        var spousename = results[i].spousename;
                        var country = results[i].country;
                        var homeaddress = results[i].homeaddress;
                        var presentaddress = results[i].presentaddress;
                        var homephone = results[i].homephone;
                        var cellphone = results[i].cellphone;
                        var email = results[i].email;
                        var city = results[i].city;
                        var state = results[i].state;
                        var zipcode = results[i].zipcode;
                        var degree = results[i].degree;
                        var specification = results[i].specification;
                        var experience = results[i].experience;
                        var experiencedet = results[i].experiencedet;
                        var deptid = results[i].deptid;
                        var designationid = results[i].designationid;
                        var branchname = results[i].branchid;
                        var institute = results[i].institute;
                        var university = results[i].university;
                        var graders = results[i].graders;
                        var duration = results[i].duration;
                        var remarks = results[i].remarks;
                        var conformdate = results[i].conformdate;
                        var physicalchalnge = results[i].physicalchalnge;
                        var bloodgroup = results[i].bloodgroup;
                        var aadarenrollnumber = results[i].aadarenrollnumber;
                        var nameasforaadhar = results[i].nameasforaadhar;
                        var salarymode = results[i].salarymode;
                        var pancard = results[i].pancard;
                        var marriagedate = results[i].marriagedate;
                        var age = results[i].age;
                        var password = results[i].password;
                        var username = results[i].username;
                        var re_password = results[i].re_password;
                        var fathername = results[i].fathername;
                        var employeetype = results[i].employeetype;
                        var currentlocationsince = results[i].currentlocationsince;
                        var currentdesignationsince = results[i].currentdesignationsince;
                        var currentdepartmentsince = results[i].currentdepartmentsince;
                        var currentemployeesince = results[i].currentemployeesince;
                        var pfeligible = results[i].pfeligible;
                        var esieligible = results[i].esieligible;
                        var caste = results[i].caste;
                        var emergencynumber = results[i].emergencynumber;
                        var photo = results[i].photo;
                        var ftplocation = results[i].ftplocation;
                        var drivinglicense = results[i].drivinglicense;
                        var dateofvalidilty = results[i].dateofvalidilty;
                        var ledgercode = results[i].ledgercode;
                        var ledgername = results[i].ledgername;
                        var status = "";
                        if (results[i].status == 'No') {
                            status = "Active";
                        }
                        else {
                            status = "InActive";
                        }
                        var tablerowcnt = document.getElementById("tbl_empmaster").rows.length;
                        $('#tbl_empmaster').append('<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td><td data-title="empsno" >' + emp_sno + '</td><td data-title="Employee Number">' + empnum + '</td><th scope="row">' + empname + '</th><td data-title="Title" style="display:none;" >' + title + '</td><th scope="row">' + employeetype + '</th><td data-title="Join Date">' + joindate + '</td><td data-title="Cell Phone">' + cellphone + '</td><td data-title="Status">' + status + '</td><td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background: #f44336 !important;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;color: #ffffff !important;border-color: #f44336 !important;"  onclick="updateclick(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>');
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
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                for (var i = 0; i < results.length; i++) {
                    if (empname == results[i].empname) {
                        var emp_sno = results[i].empsno;
                        var empnum = results[i].empnum;
                        var empname = results[i].empname;
                        var joindate = results[i].joindate;
                        var initials = results[i].initials;
                        var title = results[i].title;
                        var birthdate = results[i].birthdate;
                        var gender = results[i].gender;
                        var maritalstatus = results[i].maritalstatus;
                        var spousename = results[i].spousename;
                        var country = results[i].country;
                        var homeaddress = results[i].homeaddress;
                        var presentaddress = results[i].presentaddress;
                        var homephone = results[i].homephone;
                        var cellphone = results[i].cellphone;
                        var email = results[i].email;
                        var city = results[i].city;
                        var state = results[i].state;
                        var zipcode = results[i].zipcode;
                        var degree = results[i].degree;
                        var specification = results[i].specification;
                        var experience = results[i].experience;
                        var experiencedet = results[i].experiencedet;
                        var deptid = results[i].deptid;
                        var designationid = results[i].designationid;
                        var branchname = results[i].branchid;
                        var institute = results[i].institute;
                        var university = results[i].university;
                        var graders = results[i].graders;
                        var duration = results[i].duration;
                        var remarks = results[i].remarks;
                        var conformdate = results[i].conformdate;
                        var physicalchalnge = results[i].physicalchalnge;
                        var bloodgroup = results[i].bloodgroup;
                        var aadarenrollnumber = results[i].aadarenrollnumber;
                        var nameasforaadhar = results[i].nameasforaadhar;
                        var salarymode = results[i].salarymode;
                        var pancard = results[i].pancard;
                        var marriagedate = results[i].marriagedate;
                        var age = results[i].age;
                        var password = results[i].password;
                        var username = results[i].username;
                        var re_password = results[i].re_password;
                        var fathername = results[i].fathername;
                        var employeetype = results[i].employeetype;
                        var photo = results[i].photo;
                        var currentlocationsince = results[i].currentlocationsince;
                        var currentdesignationsince = results[i].currentdesignationsince;
                        var currentdepartmentsince = results[i].currentdepartmentsince;
                        var currentemployeesince = results[i].currentemployeesince;
                        var pfeligible = results[i].pfeligible;
                        var esieligible = results[i].esieligible;
                        var caste = results[i].caste;
                        var emergencynumber = results[i].emergencynumber;
                        var ftplocation = results[i].ftplocation;
                        var drivinglicense = results[i].drivinglicense;
                        var dateofvalidilty = results[i].dateofvalidilty;
                        var ledgercode = results[i].ledgercode;
                        var ledgername = results[i].ledgername;
                        var status = "";
                        if (results[i].status == 'No') {
                            status = "Active";
                        }
                        else {
                            status = "InActive";
                        }
                        var tablerowcnt = document.getElementById("tbl_empmaster").rows.length;
                        $('#tbl_empmaster').append('<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td><td data-title="empsno" >' + emp_sno + '</td><td data-title="Employee Number">' + empnum + '</td><th scope="row">' + empname + '</th><td data-title="Title" style="display:none;" >' + title + '</td><th scope="row">' + employeetype + '</th><td data-title="Join Date">' + joindate + '</td><td data-title="Cell Phone">' + cellphone + '</td><td data-title="Status">' + status + '</td><td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background: #f44336 !important;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;color: #ffffff !important;border-color: #f44336 !important;"  onclick="updateclick(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>');
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }
            }
        }
        var emplist = [];
        var compiledList = [];
        function fillempcode(msg) {
            for (var i = 0; i < msg.length; i++) {
                var employeetype = msg[i].employeetype;
                if (emplist.indexOf(employeetype) == -1) {
                    compiledList.push(employeetype);
                    emplist.push(employeetype);
                }
            }
            $('#txt_empcode1').autocomplete({
                source: compiledList,
                change: empcodechange,
                autoFocus: true
            });
        }

        function empcodechange() {
            var branchid = document.getElementById('txt_Branch1').value;
            document.getElementById('txt_Branch1').value = branchid;
            var table = document.getElementById("tbl_empmaster");
            for (var i = table.rows.length - 1; i > 0; i--) {
                table.deleteRow(i);
            }
            var results = employee_data;
            var employeetype = document.getElementById('txt_empcode1').value;
            if (employeetype == "" ) {
                var k = 1;
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                for (var i = 0; i < results.length; i++) {
                    if (results[i].empnum != null) {
                        var emp_sno = results[i].empsno;
                        var empnum = results[i].empnum;
                        var empname = results[i].empname;
                        var joindate = results[i].joindate;
                        var initials = results[i].initials;
                        var title = results[i].title;
                        var birthdate = results[i].birthdate;
                        var gender = results[i].gender;
                        var maritalstatus = results[i].maritalstatus;
                        var spousename = results[i].spousename;
                        var country = results[i].country;
                        var homeaddress = results[i].homeaddress;
                        var presentaddress = results[i].presentaddress;
                        var homephone = results[i].homephone;
                        var cellphone = results[i].cellphone;
                        var email = results[i].email;
                        var city = results[i].city;
                        var state = results[i].state;
                        var zipcode = results[i].zipcode;
                        var degree = results[i].degree;
                        var specification = results[i].specification;
                        var experience = results[i].experience;
                        var experiencedet = results[i].experiencedet;
                        var deptid = results[i].deptid;
                        var designationid = results[i].designationid;
                        var branchname = results[i].branchid;
                        var institute = results[i].institute;
                        var university = results[i].university;
                        var graders = results[i].graders;
                        var duration = results[i].duration;
                        var remarks = results[i].remarks;
                        var conformdate = results[i].conformdate;
                        var physicalchalnge = results[i].physicalchalnge;
                        var bloodgroup = results[i].bloodgroup;
                        var aadarenrollnumber = results[i].aadarenrollnumber;
                        var nameasforaadhar = results[i].nameasforaadhar;
                        var salarymode = results[i].salarymode;
                        var pancard = results[i].pancard;
                        var marriagedate = results[i].marriagedate;
                        var age = results[i].age;
                        var password = results[i].password;
                        var username = results[i].username;
                        var re_password = results[i].re_password;
                        var fathername = results[i].fathername;
                        var employeetype = results[i].employeetype;
                        var photo = results[i].photo;
                        var currentlocationsince = results[i].currentlocationsince;
                        var currentdesignationsince = results[i].currentdesignationsince;
                        var currentdepartmentsince = results[i].currentdepartmentsince;
                        var currentemployeesince = results[i].currentemployeesince;
                        var pfeligible = results[i].pfeligible;
                        var esieligible = results[i].esieligible;
                        var caste = results[i].caste;
                        var emergencynumber = results[i].emergencynumber;
                        var ftplocation = results[i].ftplocation;
                        var drivinglicense = results[i].drivinglicense;
                        var dateofvalidilty = results[i].dateofvalidilty;
                        var ledgercode = results[i].ledgercode;
                        var ledgername = results[i].ledgername;
                        var status = "";
                        if (results[i].status == 'No') {
                            status = "Active";
                        }
                        else {
                            status = "InActive";
                        }
                        var tablerowcnt = document.getElementById("tbl_empmaster").rows.length;
                        $('#tbl_empmaster').append('<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td><td data-title="empsno" >' + emp_sno + '</td><td data-title="Employee Number">' + empnum + '</td><th scope="row">' + empname + '</th><td data-title="Title" style="display:none;" >' + title + '</td><th scope="row">' + employeetype + '</th><td data-title="Join Date">' + joindate + '</td><td data-title="Cell Phone">' + cellphone + '</td><td data-title="Status">' + status + '</td><td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background: #f44336 !important;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;color: #ffffff !important;border-color: #f44336 !important;"  onclick="updateclick(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>');
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
                var branchid = document.getElementById('txt_Branch1').value;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                for (var i = 0; i < results.length; i++) {
                    if (employeetype == results[i].employeetype && branchid == results[i].branchname) {
                        var emp_sno = results[i].empsno;
                        var empnum = results[i].empnum;
                        var empname = results[i].empname;
                        var joindate = results[i].joindate;
                        var initials = results[i].initials;
                        var title = results[i].title;
                        var birthdate = results[i].birthdate;
                        var gender = results[i].gender;
                        var maritalstatus = results[i].maritalstatus;
                        var spousename = results[i].spousename;
                        var country = results[i].country;
                        var homeaddress = results[i].homeaddress;
                        var presentaddress = results[i].presentaddress;
                        var homephone = results[i].homephone;
                        var cellphone = results[i].cellphone;
                        var email = results[i].email;
                        var city = results[i].city;
                        var state = results[i].state;
                        var zipcode = results[i].zipcode;
                        var degree = results[i].degree;
                        var specification = results[i].specification;
                        var experience = results[i].experience;
                        var experiencedet = results[i].experiencedet;
                        var deptid = results[i].deptid;
                        var designationid = results[i].designationid;
                        var branchname = results[i].branchid;
                        var institute = results[i].institute;
                        var university = results[i].university;
                        var graders = results[i].graders;
                        var duration = results[i].duration;
                        var remarks = results[i].remarks;
                        var conformdate = results[i].conformdate;
                        var physicalchalnge = results[i].physicalchalnge;
                        var bloodgroup = results[i].bloodgroup;
                        var aadarenrollnumber = results[i].aadarenrollnumber;
                        var nameasforaadhar = results[i].nameasforaadhar;
                        var salarymode = results[i].salarymode;
                        var pancard = results[i].pancard;
                        var marriagedate = results[i].marriagedate;
                        var age = results[i].age;
                        var password = results[i].password;
                        var username = results[i].username;
                        var re_password = results[i].re_password;
                        var fathername = results[i].fathername;
                        var employeetype = results[i].employeetype;
                        var photo = results[i].photo;
                        var currentlocationsince = results[i].currentlocationsince;
                        var currentdesignationsince = results[i].currentdesignationsince;
                        var currentdepartmentsince = results[i].currentdepartmentsince;
                        var currentemployeesince = results[i].currentemployeesince;
                        var pfeligible = results[i].pfeligible;
                        var esieligible = results[i].esieligible;
                        var caste = results[i].caste;
                        var emergencynumber = results[i].emergencynumber;
                        var ftplocation = results[i].ftplocation;
                        var drivinglicense = results[i].drivinglicense;
                        var dateofvalidilty = results[i].dateofvalidilty;
                        var ledgercode = results[i].ledgercode;
                        var ledgername = results[i].ledgername;
                        var status = "";
                        if (results[i].status == 'No') {
                            status = "Active";
                        }
                        else {
                            status = "InActive";
                        }
                        var tablerowcnt = document.getElementById("tbl_empmaster").rows.length;
                        $('#tbl_empmaster').append('<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td><td data-title="empsno" >' + emp_sno + '</td><td data-title="Employee Number">' + empnum + '</td><th scope="row">' + empname + '</th><td data-title="Title" style="display:none;" >' + title + '</td><th scope="row">' + employeetype + '</th><td data-title="Join Date">' + joindate + '</td><td data-title="Cell Phone">' + cellphone + '</td><td data-title="Status">' + status + '</td><td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="background: #f44336 !important;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;color: #ffffff !important;border-color: #f44336 !important;"  onclick="updateclick(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>');
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }
            }
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

        function checkLength() {
            var textbox = document.getElementById("txt_cellphone");
            if (textbox.value.length == 10) {
            }
            else {
                alert("mobile number must be 10 digits long");
                textbox.focus();
                return false;
            }
        }
        function checkLength2() {
            var textbox = document.getElementById("txt_Emergencynum");
            if (textbox.value.length == 10) {
                
            }
            else {
                alert("mobile number must be 10 digits long");
                textbox.focus();
                return false;
            }
        }
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Employee Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Basic Information</a></li>
            <li><a href="#">Employee Master</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-user-plus"></i>Employee Details
                </h3>
                <h3 class="box-title">
                    <label id="lblsessionname"></label>
                </h3>
            </div>
            <div class="box-body">
                <div class="maindiv">
                    <div id="emp_showlogs" style="text-align: center;">
                        <table>
                            <tr>
                              <td>
                                    <select class="form-control" id="slct_Empfilter" onchange="get_all_Employeedetails();">
                                        <option value="No">Current Employees</option>
                                        <option value="Yes">Resigined Employees</option>
                                    </select>
                                <td>
                                 <td style="width: 5px;">
                                </td>
                                <td>
                                    <input id="txt_Branch1" type="text" class="form-control"
                                        class="form-control" placeholder="Search Branch Name"  />
                                </td>
                                <td style="width: 35px">
                                    OR
                                </td>
                                <td>
                                    <input id="txt_empcode1" type="text" class="form-control"
                                        class="form-control" placeholder="Search EMP Type"/>
                                </td>
                                <td style="width: 35px">
                                    OR
                                </td>
                                <td>
                                    <input id="txt_empname1" type="text" class="form-control"
                                        class="form-control" placeholder="Search EMP Name" />
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td>
                                    <i class="fa fa-search" aria-hidden="true">Search</i>
                                </td>
                                <td style="width: 50px">
                                </td>
                                <td>
                                <div class="input-group">
                                <div class="input-group-addon" style="border-color: #3c8dbc;background-color: #3c8dbc;border-radius: 4px;color: whitesmoke;">
                                <span class="glyphicon glyphicon-plus-sign"  ></span> <span id="add_employee" ">Add Employee</span>
                          </div>
                          </div>
                                    <%--<input id="add_employee" type="button" class="btn btn-primary" name="submit" value="Add Employee">--%>
                                </td>
                                <td style="width: 10px">
                                </td>
                                <td>
                                    <input type="button" class="btntogglecls" style="height: 28px; opacity: 1.0; width: 100px;
                                        background-color: #d5d5d5; color: Blue;" onclick="tableToExcel('tbl_empmaster', 'W3C Example Table')"
                                        value="Export to Excel">
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="div_addemp" style="display: none;">
                        <div class="box-body">
                            <div class="row">
                                <div class="col-sm-12 col-xs-12">
                                    <div class="well panel panel-default" style="padding: 0px;">
                                        <div class="panel-body">
                                            <div class="row">
                                                <div class="col-sm-4" style="width: 100%;">
                                                    <div class="row">
                                                        <div class="col-xs-12 col-sm-3 text-center">
                                                            <div class="pictureArea1">
                                                                <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img"
                                                                    src="Images/Employeeimg.jpg" alt="your image" style="border-radius: 5px; width: 200px;
                                                                    height: 200px; border-radius: 50%;" />
                                                                <div class="photo-edit-admin">
                                                                    <a onclick="getFile();" class="photo-edit-icon-admin" href="/employee/emp-master/emp-photo?eid=3"
                                                                        title="Change Profile Picture" data-toggle="modal" data-target="#photoup"><i class="fa fa-pencil">
                                                                        </i></a>
                                                                </div>
                                                                <div id="yourBtn" class="img_btn" onclick="getFile();" style="margin-top: 5px; display: none;">
                                                                    Click to Choose Image
                                                                </div>
                                                                <div style="height: 0px; width: 0px; overflow: hidden;">
                                                                    <input id="file" type="file" name="files[]" onchange="readURL(this);">
                                                                </div>
                                                                <div>
                                                                    <input type="button" id="btn_upload_profilepic" class="btn btn-primary" onclick="upload_profile_pic();"
                                                                        style="margin-top: 5px;" value="Upload Profile Pic">
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-xs-12 col-sm-9">
                                                            <h2 class="text-primary">
                                                                <b><span class="glyphicon glyphicon-user"></span>
                                                                    <label id="lbl_topempname">
                                                                    </label>
                                                                </b>
                                                            </h2>
                                                            <p>
                                                                <strong>Employee ID : <span style="color: Red;font-weight:bold">*</span></strong>
                                                                <label style="padding-left: 20px; font-weight: 700;" id="lbl_topemployeeid">
                                                                </label>
                                                            </p>
                                                            <p>
                                                                <strong>Email ID : <span style="color: Red;font-weight:bold">*</span></strong>
                                                                <label id="lbl_topempemailid">
                                                                </label>
                                                            </p>
                                                            <p>
                                                                <strong>Mobile No :<span style="color: Red;font-weight:bold">*</span> </strong>
                                                                <label id="lbl_topempmobno">
                                                                </label>
                                                            </p>
                                                        </div>
                                                        <!--/col-->
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <ul class="nav nav-tabs">
                                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="change_Personal()">
                                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Basic Details</a></li>
                                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="change_Documents()">
                                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Documents</a></li>
                                </ul>
                            </div>
                            <div id="div_basic_details" style="display: block;">
                                <div class="box box-danger">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">
                                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Basic Details</h3>
                                    </div>
                                    <div class="box-body">
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Employee Number</label>
                                                <span style="color: Red;font-weight: bold;">*</span>
                                                <input type="text" id="txt_empnum" class="form-control" value="" placeholder="Enter Employee Number">
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Title</label>
                                                <select class="form-control" id="slct_title">
                                                    <option>Mr</option>
                                                    <option>Ms</option>
                                                    <option>Mrs</option>
                                                </select>
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Employee Name</label>
                                                <span style="color: Red;font-weight: bold;">*</span>
                                                <input type="text" id="txt_empname" style="text-transform:capitalize;" class="form-control" value="" placeholder="Enter Name" />
                                                    
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Initials</label>
                                                <input type="text" id="txt_initials" class="form-control" value="" placeholder="Enter Initials"
                                                    onkeypress="return ValidateAlpha(event);">
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Gender</label>
                                                     <span style="color: Red;font-weight: bold;">*</span>
                                                <select class="form-control" id="slct_gender">
                                                    <option>Male</option>
                                                    <option>Female</option>
                                                </select>
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Birth Date</label>
                                                     <span style="color: Red;font-weight: bold;">*</span>
                                                <input type="date" id="dtp_birthdate" class="form-control" value="" onchange="calculateAge();">
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Father Name (or) Mother Name</label>
                                                <span style="color: Red;font-weight: bold;">*</span>
                                                <input type="text" id="txt_Fathername" style="text-transform:capitalize;" class="form-control" value="" placeholder="Enter Father Name (or) Mother Name"
                                                    onkeypress="return ValidateAlpha(event);">
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Whether Physically Challenge</label>
                                                <select class="form-control" id="slct_physical">
                                                    <option>No</option>
                                                    <option>Yes</option>
                                                </select>
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Join Date</label>
                                                <input type="date" id="dtp_joindate" class="form-control" onchange="changedate();">
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Confirmation Date</label>
                                                <input type="date" id="txt_confdate" class="form-control" value="">
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Blood Group</label>
                                                <select id="txt_Bloodgroup" class="form-control">
                                                    <option value="Select Blood Group" disabled selected>Select Blood Group</option>
                                                    <option value="A +VE">A +VE</option>
                                                    <option value="A -VE">A -VE</option>
                                                    <option value="B +VE">B +VE</option>
                                                    <option value="B -VE">B -VE</option>
                                                    <option value="AB +VE">AB +VE</option>
                                                    <option value="AB -VE">AB -VE</option>
                                                    <option value="O +VE">O +VE</option>
                                                    <option value="O -VE">O -VE</option>
                                                </select>
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Age</label>
                                                <input type="text" id="txt_Age" placeholder="Enter Age" class="form-control">
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Marital Status</label>
                                                <select class="form-control" id="slct_maritalstatus">
                                                    <option>Single</option>
                                                    <option>Married</option>
                                                    <option>Widower</option>
                                                    <option>Widow</option>
                                                    <option>Divorced</option>
                                                    <option>Separated</option>
                                                    <option>Unknown</option>
                                                </select>
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Marriage Date</label>
                                                <input type="date" id="txt_Marrigedate" class="form-control" value="">
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Spouse Full Name</label>
                                                <input type="text" id="txt_spousename" style="text-transform:capitalize;" class="form-control" value="" placeholder="Enter Spouse Full Name"
                                                    >
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Spouse Details</label>
                                                <textarea class="form-control" style="text-transform:capitalize;" id="txt_spousedetails" rows="2" placeholder="Enter Spouse Details"
                                                    cols="30"></textarea>
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Pan Card</label>
                                                <input type="text" id="txt_Pancard" class="form-control" value="" placeholder="Enter Pan Card Number">
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Voter Id</label>
                                                <input type="text" id="txt_voterid" class="form-control" value="" placeholder="Enter Voter Id">
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Nationality</label>
                                                <select class="form-control" id="slct_country">
                                                    <option id="India" selected="selected">India</option>
                                                </select>
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Caste</label>
                                                <input type="text" id="txt_caste" class="form-control" value="" placeholder="Enter Caste">
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Driving Licence Number</label>
                                                <input type="text" id="txt_drvinglicence" class="form-control" value="" placeholder="Enter Driving Licence Number">
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Date Of Validity Driving License</label>
                                                <input type="date" id="txt_licencedate" class="form-control" value="" placeholder="Enter Date Of Validity Driving License">
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Branch Name</label> <span style="color: Red;font-weight: bold;">*</span>
                                                <select class="form-control"  id="Slect_Name">
                                                    <option selected disabled value="Select Branch">Select Branch</option>
                                                </select>
                                            </div>
                                            <div class="col-sm-3">
                                                <label class="control-label" for="txt_empname">
                                                    Salary Mode</label>
                                                <select class="form-control" id="select_Salarymode">
                                                    <option value="0">Percentage</option>
                                                    <option value="1">Fixed</option>
                                                </select>
                                            </div>
                                            <div class="col-sm-3">
                                                <label class="control-label" for="txt_empname">
                                                    Employee Type</label>
                                                <select class="form-control" id="slct_employeetype">
                                                    <option>Staff</option>
                                                    <option>Casuals</option>
                                                    <option>Driver</option>
                                                    <option>Retainers</option>
                                                    <option>Cleaner</option>
                                                    <option>KMM Casuals</option>
                                                    <option>Permanent</option>
                                                    <option>Casual worker</option>
                                                    <option>Security</option>
                                                    <option>Canteen</option>
                                                    <option>Agri Workers</option>
                                                     
                                                </select>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-8">
                                                <label class="control-label" for="txt_empname">
                                                    About Me</label>
                                                <textarea class="form-control" style="text-transform:capitalize;" id="txt_aboutme" rows="3" placeholder="Enter About Me"
                                                    cols="55"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="box box-danger">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">
                                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Aadhaar Details</h3>
                                    </div>
                                    <div class="box-body">
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Aadhaar Enroll Number</label>
                                                <input class="form-control" id="txt_aadharenrollno" placeholder="Enter Aadhaar Enroll Number" />
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Name As Per Aadhaar Card</label>
                                                <input class="form-control" style="text-transform:capitalize;" id="txt_nameasforaadhar" placeholder="Enter  Name As Per Aadhaar Card" />
                                            </div>
                                            <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    Aadhaar Number</label>
                                                <input type="text" id="txt_aadharno" class="form-control" value="" placeholder="Enter Aadhaar Number"
                                                    onkeypress="return isNumber(event)">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="box box-danger">
                                        <div class="box-header with-border">
                                            <h3 class="box-title">
                                                <i style="padding-right: 5px;" class="fa fa-cog"></i>Contact Details</h3>
                                        </div>
                                        <div class="box-body">
                                            <div class="row">
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Permanent Address</label>
                                                    <textarea class="form-control" id="txt_homeaddress" style="text-transform:capitalize;" rows="3" placeholder="Enter Permanent Address" onchange="changeaddress();"
                                                        style="height: 63px;"></textarea>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Present Address</label>
                                                    <textarea class="form-control" style="text-transform:capitalize;" id="txt_prsntads" rows="3" placeholder="Enter  Present Address"
                                                        style="height: 63px;"></textarea>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Home Phone</label>
                                                    <input type="text" id="txt_homephone" class="form-control" value="" placeholder="Enter Home Phone"  
                                                        onkeypress="return isNumber(event)">
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Cell Phone</label>
                                                    <input type="text" id="txt_cellphone" class="form-control" value="" placeholder="Enter Cell Phone" onchange="checkLength();" 
                                                        onkeypress="return isNumber(event)">
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Emergency Contact Number</label>
                                                    <input type="text" id="txt_Emergencynum" class="form-control" onchange="checkLength2();"  return false;" value="" placeholder="Enter Emergency Number ">
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        City</label>
                                                    <input type="text" id="txt_city" style="text-transform:capitalize;" class="form-control" value=""  onkeypress="return ValidateAlpha(event);"
                                                        placeholder="Enter City">
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        State</label>
                                                    <select class="form-control" id="txt_state">
                                                    <option selsected value disabled >Select State Name</option>
                                                        <option value="Andhra Pradesh">Andhra Pradesh</option>
                                                        <option value="Arunachal Pradesh">Arunachal Pradesh</option>
                                                        <option value="Assam">Assam</option>
                                                        <option value="Bihar">Bihar</option>
                                                        <option value="Chandigarh">Chandigarh</option>
                                                        <option value="Chhattisgarh">Chhattisgarh</option>
                                                        <option value="Dadra and Nagar Haveli">Dadra and Nagar Haveli</option>
                                                        <option value="Daman and Diu">Daman and Diu</option>
                                                        <option value="Delhi">Delhi</option>
                                                        <option value="Goa">Goa</option>
                                                        <option value="Gujarat">Gujarat</option>
                                                        <option value="Haryana">Haryana</option>
                                                        <option value="Himachal Pradesh">Himachal Pradesh</option>
                                                        <option value="Jammu and Kashmir">Jammu and Kashmir</option>
                                                        <option value="Jharkhand">Jharkhand</option>
                                                        <option value="Karnataka">Karnataka</option>
                                                        <option value="Kerala">Kerala</option>
                                                        <option value="Lakshadweep">Lakshadweep</option>
                                                        <option value="Madhya Pradesh">Madhya Pradesh</option>
                                                        <option value="Maharashtra">Maharashtra</option>
                                                        <option value="Manipur">Manipur</option>
                                                        <option value="Meghalaya">Meghalaya</option>
                                                        <option value="Mizoram">Mizoram</option>
                                                        <option value="Nagaland">Nagaland</option>
                                                        <option value="Orissa">Orissa</option>
                                                        <option value="Pondicherry">Pondicherry</option>
                                                        <option value="Punjab">Punjab</option>
                                                        <option value="Rajasthan">Rajasthan</option>
                                                        <option value="Sikkim">Sikkim</option>
                                                        <option value="Tamil Nadu">Tamil Nadu</option>
                                                         <option value="Telangana">Telangana</option>
                                                        <option value="Tripura">Tripura</option>
                                                        <option value="Uttaranchal">Uttaranchal</option>
                                                        <option value="Uttar Pradesh">Uttar Pradesh</option>
                                                        <option value="West Bengal">West Bengal</option>
                                                    </select>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Email Id</label>
                                                    <input type="text" id="txt_email" class="form-control" value="" placeholder="Enter Email Id"
                                                        onchange="validationemail();">
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        ZIP/PIN code</label>
                                                    <input type="text" id="txt_zipcode" class="form-control" value="" placeholder="Enter ZIP/PIN "
                                                        onkeypress="return isNumber(event)">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="box box-danger">
                                        <div class="box-header with-border">
                                            <h3 class="box-title">
                                                <i style="padding-right: 5px;" class="fa fa-cog"></i>Study &amp; Experience Details</h3>
                                        </div>
                                        <div class="box-body">
                                            <div class="row">
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Qualification</label>
                                                         <span style="color: Red;font-weight: bold;">*</span>
                                                    <select class="form-control" id="txt_degree">
                                                     <option selected value disabled>Select Qualification</option>
                                                    <option value="SSC">SSC</option>
                                                        <option value="B.Tech">B.Tech</option>
                                                        <option value="B.A">B.A</option>
                                                        <option value="BBA">BBA</option>
                                                        <option value="BSC Dairy Technology">BSC Dairy Technology</option>
                                                        <option value="DEGREE">DEGREE</option>
                                                        <option value="INTER">INTER</option>
                                                        <option value="M.B.A">M.B.A</option>
                                                        <option value="PG">PG</option>
                                                        <option value="M.com">M.com</option>
                                                        <option value="SSLC">SSLC</option>
                                                        <option value="SSLC">ICWA</option>
                                                        <option value="M.Tech">M.Tech</option>
                                                        <option value="Uneducated">Uneducated</option>
                                                        </select>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Specification</label>
                                                    <textarea class="form-control" id="txt_specification" style="text-transform:capitalize;" rows="1" placeholder="Enter Specification"
                                                        style="height: 35px;" ></textarea>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Institute</label>
                                                    <textarea class="form-control" id="txt_Institute" style="text-transform:capitalize;" rows="1" placeholder="Enter Institute"
                                                        style="height: 35px;" onkeypress="return ValidateAlpha(event);"></textarea>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        University</label>
                                                    <textarea class="form-control" style="text-transform:capitalize;" id="txt_University"  rows="1" placeholder="Enter University"
                                                        style="height: 35px;" onkeypress="return ValidateAlpha(event);"></textarea>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Duration of Course</label>
                                                         <select class="form-control" id="txt_Duration">
                                                         <option selected value disabled>Select Duration of Cours</option>
                                                        <option value="1 Year">1 Year</option>
                                                        <option value="2 Year">2 Year</option>
                                                        <option value="3 Year">3 Year</option>
                                                        <option value="4 Year">4 Year</option>
                                                        <option value="5 Year">5 Year</option>
                                                        <option value="6 Year">6 Year</option>
                                                        </select>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Percentage & Grade</label>
                                                    <input class="form-control" id="txt_Graders" rows="1" placeholder="Enter Percentage & Grade"
                                                        style="height: 35px;" />
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Remarks</label>
                                                    <textarea class="form-control" style="text-transform:capitalize;" id="txt_remarks" rows="1" placeholder="Enter Remarks"
                                                        style="height: 35px;"></textarea>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Experience (In Years)</label>
                                                    <input type="text" id="txt_experience" class="form-control" value="" placeholder="Ex:2.5" />
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Experience Details</label>
                                                    <textarea class="form-control" id="txt_experiencedetails" rows="1" placeholder="Enter Experience Details"
                                                        style="height: 35px;"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="box box-danger">
                                        <div class="box-header with-border">
                                            <h3 class="box-title">
                                                <i style="padding-right: 5px;" class="fa fa-cog"></i>Other Details</h3>
                                        </div>
                                        <div class="box-body">
                                            <div class="row">
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Employee Department</label> <span style="color: Red;font-weight: bold;">*</span>
                                                    <select class="form-control" id="slct_empdept">
                                                    </select>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Employee Designation
                                                    </label>
                                                   <span style="color: Red;font-weight: bold;">*</span>
                                                    <select class="form-control" id="slct_emprole">
                                                        <option value="Select Designation " selected="" disabled="">Select Designation </option>
                                                    </select>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Curr. Location Since
                                                    </label>
                                                  <span style="color: Red;font-weight: bold;">*</span>
                                                    <input type="date" id="txt_CurrLocation" class="form-control" value="" />
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Curr.Employee Type Since</label>
                                                    <input type="date" id="txt_CurrEmployee" class="form-control" value="" />
                                                    <label id="Label1" style="display: none;">
                                                    </label>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Curr. Department Since</label>
                                                    <input type="date" id="txt_CurrDepartment" class="form-control" value="" />
                                                    <label id="Label2" style="display: none;">
                                                    </label>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Curr. Designation Since</label>
                                                    <input type="date" id="txt_CurrDesignation" class="form-control" value="" />
                                                    <label id="Label3" style="display: none;">
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Status</label>
                                                    <select class="form-control" id="slct_status">
                                                        <option value="No">Active</option>
                                                        <option value="Yes">Inactive</option>
                                                    </select>
                                                    <label id="lbl_emploginsno" style="display: none;">
                                                    </label>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        PF Eligible</label>
                                                    <select class="form-control" id="slct_PFeligible">
                                                     <option selected value disabled>Select PF Eligible</option>
                                                        <option value="Yes" >Yes</option>
                                                        <option value="No" >No</option>
                                                    </select>
                                                </div>
                                                <div class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        ESI Eligible</label>
                                                    <select class="form-control" id="slct_Esieligible">
                                                    <option selected value disabled>Select ESI Eligible</option>
                                                         <option value="Yes">Yes</option>
                                                        <option value="No" >No</option>
                                                    </select>
                                                </div>
                                               <div class="col-sm-4">
                                                <label class="control-label" for="txt_empname">
                                                    PF State</label>
                                                <select class="form-control" id="slctpfstate">
                                                    <option>AP</option>
                                                    <option>TN</option>
                                                    <option>TS</option>
                                                    <option>KA</option>
                                                </select>
                                            </div>
                                            </div>
                                            <div class="row">
                                            <div  class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Ledger Code </label>
                                                    <input type="text" id="txt_ledgercode" class="form-control" value="" placeholder="Enter Ledger Code" />
                                                </div>
                                                <div  class="col-sm-4">
                                                    <label class="control-label" for="txt_empname">
                                                        Ledger Name</label>
                                                   <input type="text" id="txt_ledgername" class="form-control" value="" placeholder="Enter Ledger Name" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="panelWidget">
                                            <input type="checkbox" id="chk_add_login" name="add_login" value="add_login">
                                            <label for="chk_add_login" id="add_login" title="Check">
                                                Add Login</label>
                                            <div class="queryPanelWidget" id="login_details" style="display: none;">
                                                <table class="qpwTable">
                                                    <tbody>
                                                        <tr id="tablerow_id" style="display: none;">
                                                            <td class="tableLabel" width="100px" style="padding: 8px 5px 15px 0px;">
                                                                Previous Password
                                                            </td>
                                                            <td class="tableValue" colspan="1">
                                                                <input type="password" class="form-control" id="txt_prevpassword" style="height: 35px;" placeholder="Enter Previous Password">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="tableLabel"  style="padding: 8px 5px 15px 0px;">
                                                                User Name
                                                            </td>
                                                            <td class="tableValue" colspan="1">
                                                                <input type="text" class="form-control" id="txtusername" placeholder="Enter User Name"
                                                                    style="height: 35px;">
                                                            </td>
                                                            <td class="tableLabel"  placeholder="Enter Password" style="padding: 8px 5px 15px 0px;">
                                                                Password
                                                            </td>
                                                            <td class="tableValue" colspan="1">
                                                                <input type="password" class="form-control" id="txt_password" placeholder="Enter Password"
                                                                    style="height: 35px;">
                                                            </td>
                                                            <td class="tableLabel"  style="padding-left: 20px;">
                                                                Re Type Password
                                                            </td>
                                                            <td class="tableValue" colspan="1">
                                                                <input type="password" class="form-control" id="txt_repassword" placeholder="Enter Re Type Password"  style="height: 35px;">
                                                            </td>
                                                            <td class="tableLabel" >
                                                               Level Type
                                                            </td>
                                                            <td class="tableValue" colspan="1">
                                                                <select class="form-control" id="slct_leveltype" style="height: 35px;"> 
                                                                <option selected value disabled>Select Level Type</option>
                                                                <option value="SuperAdmin">SuperAdmin</option>
                                                                <option value="Admin">Admin</option>
                                                                <option value="accounts">accounts</option>
                                                                <option value="user">user</option>
                                                                <option value="dailyactivity">dailyactivity</option>
                                                                <option value="Operations">Operations</option>
                                                                <option value="manager">manager</option>
                                                                </select>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="div_Documents" class="box box-danger" style="display: none;">
                                <div class="box-header with-border">
                                    <h3 class="box-title">
                                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Documents Upload</h3>
                                </div>
                                <div class="box-body">
                                    <div class="row">
                                        <div>
                                            <br>
                                            <div class="box-body">
                                                <div class="row">
                                                    <div class="col-sm-4">
                                                        <label class="control-label">
                                                            Document Type</label>
                                                        <select id="ddl_documenttype" class="form-control">
                                                            <option selected value disabled>Select Document Type</option>
                                                            <option value="1">DrivingLicence</option>
                                                            <option value="2">Adarcard</option>
                                                            <option value="3">voterid</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <table class="table table-bordered table-striped">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <div id="FileUpload_div" class="img_btn" onclick="getFile_doc()" style="height: 50px;
                                                                            width: 100%">
                                                                            Choose Document To Upload
                                                                        </div>
                                                                        <div style="height: 0px; width: 0px; overflow: hidden;">
                                                                            <input id="FileUpload1" type="file" name="files[]" onchange="readURL_doc(this);">
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <input id="btn_upload_document" type="button" class="btn btn-primary" name="submit"
                                                            value="UPLOAD" onclick="upload_Employee_Document_Info();" style="width: 120px;
                                                            margin-top: 25px;">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="box-body">
                                                <div id="div_documents_table">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="btn_modify" style="width: 8%; text-align: center; display: block;margin-left: 42%;">
                            <table align="center">
                            <tr>
                            <td>
                            <div class="input-group">
                                <div class="input-group-addon" style="border-color: #3c8dbc;background-color: #3c8dbc;border-radius: 4px;height: 30px!important;color: whitesmoke;">
                                <span id="save_employee1"  class="glyphicon glyphicon-ok-sign" > </span> <span  id="save_employee" >Save</span>
                             </div>
                             </div>
                            </td>
                            <td  style="padding-left: 2%;"> 
                            <div class="input-group">
                                <div class="input-group-addon" style="border-color:#D9534F;background-color: #D9534F;border-radius: 4px;color: whitesmoke;">
                                <span   class="glyphicon glyphicon-remove-sign"  ></span> <span  id="close_empdiv">Close</span>
                          </div>
                          </div>
                            </td>
                            </tr>
                            </table>
                            
                                 
                            </div>
                        </div>
                    </div>
                </div>
                <div id="div_empmaster_table" >
                    <table id="tbl_empmaster" class="table table-bordered table-hover dataTable no-footer">
                        <thead>
                            <tr style="background:#cbc6dd;">
                                <th scope="col">
                                    Sno
                                </th>
                                <th scope="col" >
                                   Employee Id
                                </th>
                                <th scope="col">
                                    Employee Code
                                </th>
                                <th scope="col" style="display: none;">
                                    Title
                                </th>
                                <th scope="col">
                                    <i class="fa fa-user"></i>Employee Name
                                </th>
                                <th scope="col">
                                    <i class="fa fa-asterisk"></i>Employee Type
                                </th>
                                <th scope="col">
                                    <i class="fa fa-calendar"></i>Join Date
                                </th>
                                <th scope="col">
                                    <i class="fa fa-phone"></i>Mobile No
                                </th>
                                <th scope="col">
                                    Status
                                </th>
                                <th scope="col">
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
