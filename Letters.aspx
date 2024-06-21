<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="Letters.aspx.cs" Inherits="Letters" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
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





        $(function () {
            get_Employee_details();
        });
        var employeedetails = [];
        function get_Employee_details() {
            var data = { 'op': 'get_Employee_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        employeedetails = msg;
                        var empnameList = [];
                        for (var i = 0; i < msg.length; i++) {
                            var empname = msg[i].employee_name;
                            var mobilenumbr = msg[i].mobilenumbr;
                            empnameList.push(empname);
                        }
                        $('#txt_employee_name').autocomplete({
                            source: empnameList,
                            change: employeenamechange,
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
        function employeenamechange() {
            var employee_name = document.getElementById('txt_employee_name').value;
            var mobilenumbr = document.getElementById('spnmobilenumbr').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (employee_name == employeedetails[i].employee_name) {
                    document.getElementById('txtempid').value = employeedetails[i].empsno;
                    document.getElementById('spnmobilenumbr').value = employeedetails[i].home_phone;
                    document.getElementById('spn_Adressdate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_apprdate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_Exprdate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_offerdate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_Relivingdate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_welcomedate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_Newbrondate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_Wlcomedate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_Incrementdate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_offerltrdate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_departdate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_transfdate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spntdt').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_redesidate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_Welcomkitdate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_Termdate').innerHTML = employeedetails[i].doe;
                    document.getElementById('spn_Sericedate').innerHTML = employeedetails[i].doe;


                    document.getElementById('spnletr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('spn_appltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('spn_Expltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('spn_ofrltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('spn_reltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('spn_welcomeciruclarltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('spn_newbnltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('Spn_Welcmeltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('Spn_Incrmltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('Spn_Ofrtainltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('spn_Depotrltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('spn_Tansltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('spn_Redesltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('spn_welcometltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('spn_Termltr').innerHTML = employeedetails[i].doe1;
                    document.getElementById('spn_serivltr').innerHTML = employeedetails[i].doe1;
                }
            }
        }
        function btn_generate_click() {
            var lettertype = document.getElementById('Slct_letter').value;
            var txtempid = document.getElementById('txtempid').value;
            var txt_employee_name = document.getElementById('txt_employee_name').value;
            if (txt_employee_name == "") {
                alert("Please Enter Employee Name");
                return false;
            }
            if (lettertype == "Offer Letter") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'block');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        var ctc = document.getElementById('txt_ctc').value;
                        if (ctc == "") {
                            alert("Please Enter CTC");
                            return false;
                        }
                        document.getElementById('spnOffer_empname').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('spnOffer_ctc').innerHTML = ctc;
                        document.getElementById('spn_offerdoj').innerHTML = employeedetails[i].joindate;
                    }
                }
            }
            if (lettertype == "Appointment Letter") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'block');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        var ctc = document.getElementById('txt_ctc').value;
                        if (ctc == "") {
                            alert("Please Enter CTC");
                            return false;
                        }
                        document.getElementById('spnappointment_ctc').innerHTML = ctc;
                        document.getElementById('spnappointment_empname').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('spnappointment_designation').innerHTML = employeedetails[i].designation;
                        document.getElementById('spnappointment_doj').innerHTML = employeedetails[i].joindate;
                    }
                }

            }
            if (lettertype == "Experience Letter") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'block');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divctc').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_Transferletr').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        document.getElementById('spnexperience_empname').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('spnaddress_doj').innerHTML = employeedetails[i].joindate;
                        document.getElementById('spnexperience_empcode').innerHTML = employeedetails[i].employee_num;
                        document.getElementById('spnexperience_empname1').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('spnexperience_empname2').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('spnexperience_designation').innerHTML = employeedetails[i].designation;
                        document.getElementById('spnexperience_designation1').innerHTML = employeedetails[i].designation;
                        document.getElementById('spnexperience_doj').innerHTML = employeedetails[i].joindate;
                        
                    }
                }
            }
            if (lettertype == "Address Proof Letter") {
                $('#divaddress').css('display', 'block');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_Transferletr').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        document.getElementById('spnaddress_empname').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('spnaddress_doj').innerHTML = employeedetails[i].joindate;
                        document.getElementById('spnaddress_empname1').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('spnaddress_empname2').innerHTML = employeedetails[i].employee_name;
                    }
                }
            }
            if (lettertype == "Relieving Letter") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'block');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_Transferletr').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        document.getElementById('spnrelieving_empname').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('spnmobilenumbr').innerHTML = employeedetails[i].home_phone;


                    }
                }
            }
            if (lettertype == "Welcome circular") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'block');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_Transferletr').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        document.getElementById('spncriclr_empname').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('Spnclr_empname1').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('Spnclr_empname2').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('Spnclr_design').innerHTML = employeedetails[i].designation;
                    }
                }
            }
            if (lettertype == "Service Certificate") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'block');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_Transferletr').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        document.getElementById('spnService_empname').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('spnService_doj').innerHTML = employeedetails[i].joindate;
                        document.getElementById('spnService_empname1').innerHTML = employeedetails[i].employee_name;
                    }
                }
            }
            if (lettertype == "New Born Child Wishes") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'block');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_Transferletr').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        document.getElementById('spnnewbron_empname').innerHTML = employeedetails[i].employee_name;

                    }
                }
            }
            if (lettertype == "Welcoming Letter") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'block');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_Transferletr').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        document.getElementById('Span_welcomeempname').innerHTML = employeedetails[i].employee_name;

                    }
                }
            }
            if (lettertype == "Increment Letter") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'block');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_Transferletr').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none'); 
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        var ctc = document.getElementById('txt_ctc').value;
                        if (ctc == "") {
                            alert("Please Enter CTC");
                            return false;
                        }
                        document.getElementById('Span_Incremtname').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('Span_Incremtname1').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('Span_hike').innerHTML = ctc;


                    }
                }
            }
            if (lettertype == "Offer Letter For Trainees") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'block');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_Transferletr').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        var ctc = document.getElementById('txt_ctc').value;
                        if (ctc == "") {
                            alert("Please Enter CTC");
                            return false;
                        }
                        document.getElementById('Spnoffertrainame').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('spn_traineeCtc').innerHTML = ctc;

                    }
                }
            }
            if (lettertype == "Department Transfer Letter") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_deptransferletter').css('display', 'block');
                $('#div_Transferletr').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        document.getElementById('Spn_DeptTrnfname').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('spn_depdesignation').innerHTML = employeedetails[i].designation;
                    }
                }
            }
            if (lettertype == "Transfer Letter") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_Transferletr').css('display', 'block');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        document.getElementById('Spn_tranfname').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('spnloaction').innerHTML = employeedetails[i].Location;
                    }
                }
            }
            if (lettertype == "Re-designation Letter") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_Transferletr').css('display', 'none');
                $('#div_redesigna').css('display', 'block');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        document.getElementById('Spn_desgname').innerHTML = employeedetails[i].employee_name;
                        document.getElementById('spn_redesign').innerHTML = employeedetails[i].designation;
                    }
                }
            }
            if (lettertype == "Welcome kit") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_Transferletr').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'block');
                $('#div_Termorder').css('display', 'none');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        document.getElementById('Spn_Wlckitname').innerHTML = employeedetails[i].employee_name;
                        //document.getElementById('spnloaction').innerHTML = employeedetails[i].Location;
                    }
                }
            }
            if (lettertype == "Termination Order") {
                $('#divaddress').css('display', 'none');
                $('#divappointment').css('display', 'none');
                $('#divexperience').css('display', 'none');
                $('#divOffer').css('display', 'none');
                $('#divrelieving').css('display', 'none');
                $('#divwelcomecircular').css('display', 'none');
                $('#divSeriviceCerticate').css('display', 'none');
                $('#div_Newbronbabywishes').css('display', 'none');
                $('#div_Welcomletter').css('display', 'none');
                $('#div_IncrementLetter').css('display', 'none');
                $('#div_Offerlettertraines').css('display', 'none');
                $('#div_deptransferletter').css('display', 'none');
                $('#div_Transferletr').css('display', 'none');
                $('#div_redesigna').css('display', 'none');
                $('#div_welcomekit').css('display', 'none');
                $('#div_Termorder').css('display', 'block');
                for (i = 0; i < employeedetails.length; i++) {
                    if (txt_employee_name == employeedetails[i].employee_name) {
                        document.getElementById('Spn_termname').innerHTML = employeedetails[i].employee_name;
                        //document.getElementById('spnloaction').innerHTML = employeedetails[i].Location;
                    }
                }
            }
        }
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
        function letterchangeclick() {
            var lettertype = document.getElementById('Slct_letter').value;
            var txt_employee_name = document.getElementById('txt_employee_name').value;
            if (lettertype == "Appointment Letter") {
                $('#divctc').css('display', 'table-row');

            }
            if (lettertype == "Offer Letter") {
                
                $('#divctc').css('display', 'table-row');

            }
            if (lettertype == "Relieving Letter") {
                $('#divctc').css('display', 'none');

            }
            if (lettertype == "Experience Letter") {
                $('#divctc').css('display', 'none');

            }
            if (lettertype == "Address Proof Letter") {
                $('#divctc').css('display', 'none');

            }
            if (lettertype == "Welcome circular") {
                $('#divctc').css('display', 'none');

            }
            if (lettertype == "Welcome circular") {
                $('#divctc').css('display', 'none');

            }
            if (lettertype == "Service Certificate") {
                $('#divctc').css('display', 'none');

            }
            if (lettertype == "New Born Child Wishes") {
                $('#divctc').css('display', 'none');
            }
            if (lettertype == "Welcoming Letter") {
                $('#divctc').css('display', 'none');
            }
            if (lettertype == "Increment Letter") {
                $('#divctc').css('display', 'show');

            }
            if (lettertype == "Offer Letter For Trainees") {
                $('#divctc').css('display', 'table-row');
            }
            if (lettertype == "Department Transfer Letter") {
                $('#divctc').css('display', 'none');
            }
            if (lettertype == "Transfer Letter") {
                $('#divctc').css('display', 'none');
            }
            if (lettertype == "Re-designation Letter") {
                $('#divctc').css('display', 'none');
            }

            if (lettertype == "Welcome kit") {
                $('#divctc').css('display', 'none');
            }
            if (lettertype == "Termination Order") {
                $('#divctc').css('display', 'none');
            }
        }
        //
        
    </script>
    <style type="text/css">
        
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            letter<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">letter Management</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>letter Details
                </h3>
            </div>
            <div>
                <table id="tbl_leavemanagement" class="inputstable" align="center">
                    <tr>
                        <td style="height: 40px;">
                            letter Template
                        </td>
                        <td>
                            <select class="form-control" id="Slct_letter" onchange="letterchangeclick();">
                                <option>Select letter Type</option>
                                <option>Offer Letter</option>
                                <option>Appointment Letter</option>
                                <option>Experience Letter</option>
                                <option>Address Proof Letter</option>
                                <option>Relieving Letter</option>
                                <option>Welcome circular</option>
                                <option>Service Certificate</option>
                                <option>New Born Child Wishes</option>
                                <option>Welcoming Letter</option>
                                <option>Increment Letter</option>
                                <option>Offer Letter For Trainees</option>
                                <option>Department Transfer Letter</option>
                                <option>Transfer Letter</option>
                                <option>Re-designation Letter</option>
                                <option>Welcome kit</option>
                                <option>Termination Order</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 40px;">
                            Employee Name <span style="color: red;">*</span>
                        </td>
                        <td>
                            <input type="text" id="txt_employee_name" class="form-control" placeholder="Enter Employe Name"
                                value="" onkeypress="return ValidateAlpha(event);">
                            <input id="txtempid" type="hidden" class="form-control" name="hiddenempid" />
                        </td>
                    </tr>
                    <tr id="divctc" style="display: none;">
                        <td style="height: 40px;">
                            CTC <span style="color: red;">*</span>
                        </td>
                        <td>
                            <input type="text" id="txt_ctc" class="form-control" placeholder="Enter CTC" value=""
                                onkeypress="return isNumber(event)">
                        </td>
                    </tr>
                        <tr id="divdate" style="display: none;">
                        <td style="height: 40px;">
                            Date <span style="color: red;">*</span>
                        </td>
                        <td>
                            <input type="date" id="txt_date" class="form-control" placeholder="Enter CTC" value=""
                                onkeypress="return isNumber(event)">
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                            <input type="button" id="btn_generate" class="btn btn-primary" onclick="btn_generate_click();"
                                value="Generate Letter">
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divPrint" style="border-style: ridge;">
                <div id="divaddress" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                                <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_Adressdate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                 Ref: LTER<span class="datecls" id="spnletr">
                               </span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        Address Proof Letter
                    </div>
                    <div style="font-size: 15px; font-weight: bold;" align="center">
                        TO WHOMSOEVER IT MAY CONCERN
                    </div>
                    <br />
                    <br />
                    <p>
                        This is to certify that Mr. <strong><span id="spnaddress_empname"></span></strong>
                        bearing <strong><span id="spnadd_empcode"></span></strong>has been employed as Manager
                        at SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd with effect from <span id="spnaddress_doj">
                        </span>
                    </p>
                    <p>
                        As per our organizational records, the residential address is as follows:
                    </p>
                    <div align="center">
                        <span id="spnaddress_empname1"></span>
                    </div>
                    <br />
                    <p>
                        This letter has been issued upon request from <span id="spnaddress_empname2"></span>
                        . The organization shall not be liable for verification of accuracy of the record
                        under any circumstances.
                    </p>
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                </div>
                <div id="divappointment" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                                  <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_apprdate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Ref: LTER<span class="datecls" id="spn_appltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        Appointment Order
                    </div>
                    <br />
                    Dear <strong><span id="spnappointment_empname"></span>,</strong>
                    <br />
                    <br />
                    <p>
                        We are pleased to appoint you as<strong> <span id="spnappointment_designation"></span>
                        </strong>with effect from <strong><span id="spnappointment_doj"></span>.</strong>
                    </p>
                    <p>
                        Your employment in our organisation shall be governed by the following terms and
                        conditions, which may be amended from time to time at the discretion of the Management.
                    </p>
                    <p>
                        You shall be initially on probation for a period of days, before being considered
                        for absorption as a regular employee. However, the organisation reserves the right
                        to extend the probation, if required.
                    </p>
                    <p>
                        During your probation, your services can be terminated without assigning any reason
                        with one month notice or gross salary in lieu of notice on either side.</p>
                    <p>
                        Unless it is communicated to you that you are confirmed in writing, you will be
                        deemed to be under probation.
                    </p>
                    <p>
                        You shall perform with diligence such duties as the position you hold and such other
                        duties that may be assigned to you depending on the exigencies of work.</p>
                    <p>
                        You are liable for transfer or deputation to any of our office location in India
                        presently established or in future at the discretion of the Management.</p>
                    <p>
                        You shall be paid a total remuneration (CTC) of Indian Rupees <span id="spnappointment_ctc">
                        </span>/-</p>
                    <p>
                        Apart from the above, you are also eligible for Paid Offs, Performance Incentives,
                        Food Coupons, Medical Insurance etc., as per the set practices.</p>
                    <p>
                        You shall attain superannuation at the age of 58 years.</p>
                    <p>
                        Termination of your services by the management without notice would arise in the
                        event of :</p>
                    <p>
                        1. You are being found medically unfit during pre-medical test</p>
                    <p>
                        2. Any contravention of the rules mentioned in standing orders</p>
                    <p>
                        3.Any other proven misconduct as per standing orders</p>
                    <p>
                        You shall not disclose any confidential and proprietary information to anyone who
                        is not authorised to obtain the same. You would be required to sign a Non-Disclosure
                        Agreement (NDA) in this regard at the time of your joining the organisation.</p>
                    <p>
                        The organisation reserves its right to amend the grade, designation, and salary
                        structure offered to you from time to time.
                    </p>
                    <p>
                        You shall be governed by the rules and regulations of the organisation as stipulated
                        in the standing orders, employee handbook, or in any other manner that are currently
                        in force or amended in future from time to time.</p>
                    <p>
                        The appointment is made on the understanding that the information given by you is
                        correct / true and complete. If found incorrect, this appointment may be withdrawn
                        before you join service with us, or your services may be terminated at any time
                        after you have taken up employment with us.
                    </p>
                    <p>
                        If, for a period of 5 consecutive working days you are absent without sanction of
                        leave or overstay, you shall lose your lien on your employment, and shall be deemed
                        to have abandoned employment voluntarily.</p>
                    <p>
                        You shall take excellent care of and be responsible for the work equipment, official
                        documents, tools, and other items/materials entrusted to you.</p>
                    <p>
                        This offer is made in duplicate. Please return the duplicate copy duly signed by
                        you as a token of your having read, understood, and accepted the terms & conditions
                        of this appointment offer.</p>
                    <br />
                    <p>
                        SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd welcomes you and offers a pleasant atmosphere
                        to work and hope that the association will be mutually beneficial and meaningful.</p>
                    <br />
                    <p>
                        With best wishes,</p>
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd,</strong><br />
                    <br />
                    <br />
                    <br />
                    <p style="border-top-style: dotted;">
                        <br />
                        <br />
                        <br />
                        I hereby accept the terms and conditions of the employment mentioned in this order.</p>
                    <p>
                        Name of Employee :</p>
                    <p>
                        Signature :</p>
                    <p>
                        Date :</p>
                </div>
               <div id="divexperience" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                           <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_Exprdate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                               Ref: LTER<span class="datecls" id="spn_Expltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        Experience Letter
                    </div>
                    <br />
                    <div style="font-size: 15px; font-weight: bold;" align="center">
                        TO WHOMSOEVER IT MAY CONCERN
                    </div>
                    <br />
                    <br />
                    <p>
                        This is to certify that Mr<strong> <span id="spnexperience_empname"></span></strong>
                         bearing employee ID <strong><span id="spnexperience_empcode"></span></strong> has
                         worked with <strong>SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd.</strong> from <strong><span id="spnexperience_doj">
                        </span></strong> to till date.
                    </p>
                    <p>
                        <strong><span id="spnexperience_empname1"></span></strong> has joined as  <strong><span
                            id="spnexperience_designation1"></span></strong> . At the time of leaving
                        the organization, <strong><span id="spnexperience_empname2"></span></strong> was designated as <strong><span
                            id="spnexperience_designation"></span></strong>.
                    </p>
                    <br />
                    <p>
                        The employee's performance was satisfactory and we appreciate the services rendered
                        to our organization. We wish them all the best in their future career.
                    </p>
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                </div>
                <div id="divOffer" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                                  <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_offerdate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Ref: LTER<span class="datecls" id="spn_ofrltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        Offer Letter
                    </div>
                    <br />
                    Dear <strong><span id="spnOffer_empname"></span>,</strong>
                    <br />
                    <br />
                    <p>
                        We are pleased to offer you employment as Manager on the following terms and conditions:</p>
                    <p>
                        Your total compensation package (CTC) shall be Indian Rupees <strong><span id="spnOffer_ctc">
                        </span>.</strong>  This includes Basic, Allowances, Statutory contributions and other benefits
                        as governed by company policies, subject to Income Tax regulations in force from
                        time to time.</p>
                    <p>
                        A detailed appointment order, outlining the break-up of your salary and terms and
                        conditions shall be issued when you join the organization.</p>
                    <p>
                        You will be on probation for a period of days from <strong><span id="spn_offerdoj"></span></strong>. Probation period
                        may be extended, at the sole discretion of the management.</p>
                    <p>
                        This offer is subject to acceptance from your end, clearances of your reference
                        check and pre-employment medical test.</p>
                    <p>
                        Please sign and return duplicate copy of this letter in acceptance of the above.
                        You are required to join our organization with in one week from issue of this offer,
                        failing which this offer stands withdrawn.</p>
                    <br />
                    <p>
                        We look forward to your joining our organization.</p>
                    <br />
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                    <br />
                    <br />
                    <br />
                    <p style="border-top-style: dotted;">
                        <br />
                        <br />
                        <br />
                        I accept the offer and shall report for duty on or before __________________</p>
                    <br />
                    <br />
                    <br />
                    <p>
                        Signature of the Candidate :</p>
                </div>
                <div id="divrelieving" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                                  <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_Relivingdate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Ref: LTER<span class="datecls" id="spn_reltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        Relieving Letter
                    </div>
                    <br />
                    Dear <strong><span id="spnrelieving_empname"></span>,</strong>
                    <br />
                    <br />
                    <strong><span id="spnmobilenumbr"></span></strong>
                    <br />
                    <p>
                        This is with reference to your resignation request.
                    </p>
                    <p>
                        The management has accepted your request and you are relieved from the services
                        of our organization with effect from the close of office hours on till Date. We also certify
                        that you have no dues with us.
                    </p>
                    <p>
                        You may please get in touch with HR/Service Desk for all your future correspondence
                        on tax papers and final settlement.
                    </p>
                    <p>
                        We thank you for your services and wish the very best in all your future endeavors.
                    </p>
                    <br />
                    <br />
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                </div>
                <div id="divwelcomecircular" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                           
                                   <lable>
                            Date
                            </lable>
                                <span class="datecls" value="datevalue" id="spn_welcomedate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                               Ref: LTER<span class="datecls" id="spn_welcomeciruclarltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        welcome circular
                    </div>
                    <br />
                    Dear <strong><span id="spncriclr_empname"></span>,</strong>
                    <br />
                    <br />
                    <br />
                    <p>
                        I am pleased to announce that <strong><span id="Spnclr_empname1"></span></strong>
                        has joined us as <strong><span id="Spnclr_design"></span>,</strong> from September
                        00, 20 reporting to Mr XYZ.
                    </p>
                    <p>
                        Mr <strong><span id="Spnclr_empname2"></span></strong>holds an --- Degree from University/Board
                        of --------- and has an experience of around ---- year with SRI VYSHNAVI DAIRY SPECIALITIES
                        (P) Ltd., Chennai
                    </p>
                    <p>
                        You may please get in touch with HR/Service Desk for all your future correspondence
                        on tax papers and final settlement.
                    </p>
                    <p>
                        We thank you for your services and wish the very best in all your future endeavors.
                    </p>
                    <br />
                    <br />
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                </div>
                <div id="divSeriviceCerticate" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                        <td>
                             <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_Sericedate">
                                </span>
                                </td>
                        </tr>
                        <tr>
                            <td>
                                Ref: LTER<span class="datecls" id="spn_serivltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        service certificate
                    </div>
                    <div style="font-size: 15px; font-weight: bold;" align="center">
                        TO WHOMSOEVER IT MAY CONCERN
                    </div>
                    <br />
                    <br />
                    <p>
                        This is to certify that Mr. <strong><span id="spnService_empname"></span></strong>
                        bearing <strong><span id="spnService_empcode"></span></strong>has been employed
                        as Manager at SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd with effect from <span id="spnService_doj">
                        </span>
                    </p>
                    <p>
                        As per our organizational records, the residential address is as follows:
                    </p>
                    <div align="center">
                        <span id="spnService_empname1"></span>
                    </div>
                    <br />
                    <p>
                        During his working period his performance was found satisfactory.
                    </p>
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                    <br />
                    <br />
                    <br />
                    <p style="border-top-style: dotted;">
                        <br />
                        <br />
                        <br />
                        Manger:
                    </p>
                    <p>
                        Signature :</p>
                    <p>
                        Date :</p>
                </div>
                <div id="div_Newbronbabywishes" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                                  <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_Newbrondate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Ref: LTER<span class="datecls" id="spn_newbnltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        New Born Child Wishes
                    </div>
                    <br />
                    Dear <strong><span id="spnnewbron_empname"></span>,</strong>
                    <br />
                    <br />
                    <br />
                    <p>
                        Nice to hear a good news from you. Congratulations!! A hearty welcome to the new
                        born into your family. May the baby get showered with good health, happiness, love
                        and prosperity all through life.
                    </p>
                    <br />
                    <br />
                    With warm wishes
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                </div>
                <div id="div_Welcomletter" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                                  <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_Wlcomedate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                               Ref: LTER<span class="datecls" id="Spn_Welcmeltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        Welcoming Letter
                    </div>
                    <br />
                    Dear <strong><span id="Span_welcomeempname"></span>,</strong>
                    <br />
                    <br />
                    <br />
                    <p>
                        We are delighted you have joined us! Your contribution is important to ensure our
                        sustained success and growth. We hope that your career here will be a gratifying
                        one. You would get maximum support from the whole of our team and we look forward
                        to having the best relations with you.
                    </p>
                    <p>
                        I welcome to u on the behalf of SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd I hope you
                        will find (SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd) as a cool place to work with
                        !!!
                    </p>
                    <p>
                        Please let me know in case of any problem.
                    </p>
                    <br />
                    <br />
                    Thanks and Regards,
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                </div>
                <div id="div_IncrementLetter" style="display: none; font-family: serif;padding-left: 70px;">
                <div style="font-size: 23px; font-weight: bold; text-decoration:underline;" align="center">
                        Increment Letter
                    </div>
                    <table style="float: right;">
                        <tr>
                            <td>
                                  <lable>
                            Date
                            </lable>
                          <%--  25-12-2016--%>
                                <span class="datecls" id="spn_Incrementdate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Ref: LTER25122016<%--<span class="datecls" id="Spn_Incrmltr"></span>--%>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    
                    <div>
                        <table>
                            <tr>
                                <td>
                                   <b> Name: <span id="Span_Incremtname1"></span> </b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                   <b> Company:  Sri Vyshnavi Dairy Specialities (P).Ltd. </b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                   <b> Employee Number: SVDS070303. </b>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <br />
                    <br />
                    <br />
                    <br />
                    Dear <strong><span id="Span_Incremtname"></span>,</strong>
                    <br />
                    <br />
                    <p>
                        Congratulations!
                    </p>
                    <br />
                    <p>
                        Your performance during the year was exemplary! You were rated as <b> 3.5/5 </b> by your
                        management. Accordingly, we have decided to upward revise your compensation and increase
                        your CTC by <b><strong><span id="Span_hike"></span></strong>/-</b> w.e.f. <b> 1<sup>st</sup> Jan 2017.</b>
                    </p>
                    <%--<p>
                        A one time performance award of Rs.________ is also being given to you.
                    </p>--%>
                    <p>
                        Whilst appreciating your dedication and performance, we look forward to your sustained
                        performance in the year ahead and wish you a bright career with our company.
                    </p>
                    <br />
                    <br />
                    Best Regards
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                </div>
                <div id="div_Offerlettertraines" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                                   <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_offerltrdate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                              Ref: LTER<span class="datecls" id="Spn_Ofrtainltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        Offer Letter For Trainees
                    </div>
                    <div>
                        To:
                    </div>
                    <br />
                    Dear <strong><span id="Spnoffertrainame"></span>,</strong>
                    <br />
                    <br />
                    <div style="font-size: 20px; font-weight: bold;" align="Left">
                        Sub: Campus Interview –Issuance of Offer Letter – Reg.
                        <br />
                        Ref: Personal Interview conducted on 20/04/2016.
                    </div>
                    <br />
                    <br />
                    <br />
                    <p>
                        With reference to the above cited subject and subsequent interview we had with you
                        on 20/04/2016,at Sri Venkateswara College, we are pleased to offer you the position
                        of “PRODUCTION - TRAINEE” at Our Processing Plant -1, at Punabaka,Srikalahasthi,
                        as per the following terms::</p>
                    <p>
                        (A) SALARY: <span id="spn_traineeCtc"></span>Rs./- Consolidated per Month.* *Besides
                        free accommodation shall be provided at our Plant. *Breakfast / Lunch & Dinner shall
                        be provided at our processing at subsidized rates. (B) TRAINING PERIOD: 3 months.
                    </p>
                    <p>
                        After the successful completion of 3 months training period, your performance is
                        subjected to review by the Management, informing you in writing either for suitable
                        Grade & Position or for further extension of training period or termination of service..</p>
                    <p>
                        You will be on probation for a period of days from 27 Jul 2015. Probation period
                        may be extended, at the sole discretion of the management.</p>
                    <p>
                        The following documents are required to be produced at the time of joining. Please
                        provide originals and self attested Photostat copies; originals will be returned
                        after verification.</p>
                    <p>
                        1. Referral Letter from College authorities, concerned department.
                    </p>
                    <p>
                        2. Internship Certificates – If any.
                    </p>
                    <p>
                        3....
                    </p>
                    <p>
                        4. Proof of Academic Qualification (Class 10th Equivalent and above):
                    </p>
                    <p>
                        • 10th & 12th mark lists
                    </p>
                    <p>
                        • Under graduate / degree mark list and degree certificates
                    </p>
                    <p>
                        • Post graduation mark list and degree certificates (if any)
                    </p>
                    <p>
                        • Other Technical qualifications - mark lists and certificates (if any)
                    </p>
                    <p>
                        5. Proof of identity i.e. PAN card, driving license, Electoral card,Ration card.
                    </p>
                    <p>
                        6. Photographs (3 copies) You are advised to confirm the acceptance of our offer
                        and join duty on or before 01-05-2016. The regular appointment order will be issued
                        after your joining. .</p>
                    <br />
                    <p>
                        We wish All the Success in your Endeavour.</p>
                    <br />
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                    <br />
                    <br />
                    <br />
                    <p style="border-top-style: dotted;">
                        <br />
                        <br />
                        <br />
                        I accept the offer and shall report for duty on or before __________________</p>
                    <br />
                    <br />
                    <br />
                    <p>
                        Signature of the Candidate :</p>
                </div>
                <div id="div_deptransferletter" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                                  <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_departdate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                               Ref: LTER<span class="datecls" id="spn_Depotrltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        Department Transfer Letter
                    </div>
                    <br />
                    Dear <strong><span id="Spn_DeptTrnfname"></span>,</strong>
                    <br />
                    <br />
                    <br />
                    <p>
                        This is to inform you that you are transferred to <strong><span id="spn_depdesignation">
                        </span></strong>Accounts with effect from and you will be reporting to <strong><span
                            id="spn_reprtname"></span></strong>
                    </p>
                    <p>
                        You can expect whole hearted support from management and your reporting manager.
                        Your manager will explain in detail the nature of your new responsibilities.
                    </p>
                    <p>
                        All other terms & conditions of your employment shall remain unchanged.
                    </p>
                    <p>
                        With best wishes
                    </p>
                    <br />
                    <br />
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                    <br />
                    <br />
                    <strong>HR Manger </strong>
                </div>
                <div id="div_Transferletr" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                                   <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_transfdate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                               Ref: LTER<span class="datecls" id="spn_Tansltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        Transfer Letter
                    </div>
                    <br />
                    Dear <strong><span id="Spn_tranfname"></span>,</strong>
                    <br />
                    <br />
                    <br />
                    <p>
                        We hereby inform you that you are transferred to <strong><span id="spnloaction"></span>
                        </strong>Arani with effect from <strong><span id="spntdt"></span>
                        </strong>
                    </p>
                    <p>
                        You can expect whole hearted support from management and your reporting manager,
                        Thomas Edison, will explain the nature of your responsibilities.
                    </p>
                    <p>
                        All other terms & conditions of your employment shall remain unchanged
                    </p>
                    <p>
                        With best wishes
                    </p>
                    <br />
                    <br />
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                    <br />
                    <br />
                    <strong>HR Manger </strong>
                    <br />
                    <p>
                        P.S: In case of any change, the same will be intimated separately.
                    </p>
                </div>
                <div id="div_redesigna" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                                  <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_redesidate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                               Ref: LTER<span class="datecls" id="spn_Redesltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        Re-designation Letter
                    </div>
                    <br />
                    Dear <strong><span id="Spn_desgname"></span>,</strong>
                    <br />
                    <br />
                    <br />
                    <p>
                        We are pleased to inform you that you are re-designated as <strong><span id="spn_redesign">
                        </span></strong>Accountant with effect from .
                    </p>
                    <p>
                        All other terms & conditions of your employment shall remain unchanged
                    </p>
                    <p>
                        With best wishes
                    </p>
                    <br />
                    <br />
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                    <br />
                    <br />
                    <strong>HR Manger </strong>
                    <br />
                    <p>
                        P.S: In case of any change, the same will be intimated separately.
                    </p>
                </div>
                <div id="div_welcomekit" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                                   <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_Welcomkitdate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Ref: LTER<span class="datecls" id="spn_welcometltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        Welcome kit
                    </div>
                    <br />
                    Dear <strong><span id="Spn_Wlckitname"></span>,</strong>
                    <br />
                    <br />
                    <br />
                    <p>
                        We welcome you to please note the following:
                    </p>
                    <p>
                        1) Your employee code is:
                    </p>
                    <p>
                        2) Your E-mail ID is:
                    </p>
                    <p>
                        3) While sending emails please ensure that the following details are captured in
                        the Signature’ portion of your emails:
                    </p>
                    <p>
                        Name :
                    </p>
                    <p>
                        Designation :
                    </p>
                    <p>
                        Business Line / Support :
                    </p>
                    <p>
                        Company Name :
                    </p>
                    <p>
                        Company Address :
                    </p>
                    <p>
                        Landline Phone number(s) :
                    </p>
                    <p>
                        Fax number :
                    </p>
                    <p>
                        Mobile number :
                    </p>
                    <p>
                        Website :
                    </p>
                    <p>
                        Email ID :
                    </p>
                    <p>
                        Thanks & Regards
                    </p>
                    <br />
                    <br />
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                    <br />
                    <br />
                    <strong>HR Manger </strong>
                    <p>
                        Website :
                    </p>
                    <p>
                        Email ID :
                    </p>
                    <br />
                </div>
                <div id="div_Termorder" style="display: none; font-family: serif;padding-left: 70px;">
                    <table style="float: right;">
                        <tr>
                            <td>
                                  <lable>
                            Date
                            </lable>
                                <span class="datecls" id="spn_Termdate">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                               Ref: LTER<span class="datecls" id="spn_Termltr"></span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <p>
                        TO,
                    </p>
                    <br />
                    <div style="font-size: 23px; font-weight: bold;" align="center">
                        Termination Order
                    </div>
                    <br />
                    Dear <strong><span id="Spn_termname"></span>,</strong>
                    <br />
                    <br />
                    <br />
                    <p>
                        This is with reference to the mutually agreed upon terms and conditions of employment.
                    </p>
                    <p>
                        The management has decided to terminate your employment with SRI VYSHNAVI DAIRY
                        SPECIALITIES (P) Ltd with immediate effect from 31 Dec 2013.
                    </p>
                    <p>
                        We hereby certify that you have no dues with the organization. HR/Service Desk shall
                        dispatch tax papers and/or final settlement to you within 30 days.
                    </p>
                    <br />
                    <br />
                    <p>
                        We thank you for your services.
                    </p>
                    <br />
                    <strong>For SRI VYSHNAVI DAIRY SPECIALITIES (P) Ltd </strong>
                    <br />
                    <br />
                    <strong>HR Manger </strong>
                    <br />
                    <p>
                        P.S: In case of any change, the same will be intimated separately.
                    </p>
                </div>
                
            </div>
            <br />
            <table align="center">
                <tr>
                    <td>
                        <input type="button" id="Button1" class="btn btn-primary" onclick="javascript:CallPrint('divPrint');"
                            value="Print">
                    </td>
                </tr>
            </table>
        </div>
    </section>
</asp:Content>
