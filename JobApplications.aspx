<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="JobApplications.aspx.cs" Inherits="JobApplications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <link href="css/font-awesome.min.css" rel="stylesheet" />
    <script src="JSF/jquery.blockUI.js" type="text/javascript"></script>
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<link href="css/schoolcustomcss.css?v=3002" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        get_job_application_details();
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
    var employeedetails=[];
    function get_job_application_details() {
        var data = { 'op': 'get_job_application_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    filljobdetails(msg);
                    filldata(msg);
                   // fillappliedfor(msg);
                    fillqualification(msg);
                    employeedetails = msg;
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
    function filljobdetails(msg) {
        var k = 1;
        var l = 0;
        var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" style="height: 100px;">';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col">Name</th><th scope="col">Surname</th><th scope="col">BirthDate</th><th scope="col">PhoneNo</th><th scope="col">Email</th><th scope="col">View</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>'
            results += '<th scope="row" class="1">' + msg[i].name + '</th>';
            results += '<th scope="row" class="2">' + msg[i].surname + '</th>';
            results += '<th scope="row" class="3">' + msg[i].birthdate + '</th>';
            results += '<th scope="row" class="5">' + msg[i].cellphone + '</th>';
            results += '<th scope="row" class="6">' + msg[i].email + '</th>';
          //  results += '<th scope="row" class="7">' + msg[i].qualification + '</th>';
          //  results += '<th scope="row" class="7">' + msg[i].Skills + '</th>';
//            results += '<th scope="row" class="8">' + msg[i].experience + '</th>';
         //   results += '<th scope="row" class="8">' + msg[i].Appliedfor + '</th>'; 
            results += '<td  style="display:none" class="9">' + msg[i].sno + '</td>';
            results += '<td><input id="btn_poplate" type="button"  data-toggle="modal" data-target="#myModal" onclick="getresume(this)" name="submit" class="btn btn-primary" value="View"/></td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
        }
        results += '</table></div>';
        $("#div_jobapplication").html(results);
    }
    function getresume(thisid) {
       
        var sno = $(thisid).parent().parent().children('.9').html();
        var data = { 'op': 'getresume', 'sno': sno };
        var s = function (msg) {
            if (msg) {
                fill_Uploaded_Documents(msg);
            }
            else {
            }
        };
        var e = function (x, h, e) {
        }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
    }
    function fill_Uploaded_Documents(msg) {

        var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col">Photo</th><th scope="col">Download</th></tr></thead></tbody>';
        var k = 1;
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td>' + k++ + '</td>';
            var path = img_url = msg[i].ftplocation + msg[i].resume;
            results += '<td data-title="brandstatus" class="2"><iframe src=' + img_url + ' style="width:400px; height:400px;" frameborder="0"></iframe></td>';
            results += '<th scope="row" class="1" ><a  target="_blank" href=' + path + '><i class="fa fa-download" aria-hidden="true"></i> Download</a></th>';
            results += '</tr>';
        }
        results += '</table></div>';
        $("#div_resumes").html(results);
    }
    var compiledList = [];
    function filldata(msg) {
        var compiledList = [];
        for (var i = 0; i < msg.length; i++) {
            var Skills = msg[i].Skills;
            compiledList.push(Skills);
        }
        $('#txt_skills').autocomplete({
            source: compiledList,
            change: Skillschange,
            autoFocus: true
        });
    }
    function Skillschange() {
        var Skills = document.getElementById('txt_skills').value;
        if (Skills == "") {
            var results = '<div  style="overflow:auto;"><table class="responsive-table" id="example"style="height: 100px;">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Name</th><th scope="col">Surname</th><th scope="col">BirthDate</th><th scope="col">PhoneNo</th><th scope="col">Email</th><th scope="col">Qualification</th><th scope="col">Skills</th><th scope="col">Experience</th><th scope="col">Applied for</th><th scope="col"></th></tr></thead></tbody>';
                var k = 1;
                var l = 0;
                var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
                for (var i = 0; i < employeedetails.length; i++) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + employeedetails[i].sno + '</th>';
                    results += '<td   class="2">' + employeedetails[i].name + '</td>';
                    results += '<td   class="2">' + employeedetails[i].surname + '</td>';
                    results += '<td   class="3">' + employeedetails[i].birthdate + '</td>';
                    results += '<td   class="4">' + employeedetails[i].cellphone + '</td>';
                    results += '<td   class="5">' + employeedetails[i].email + '</td>';
                    results += '<td   class="6">' + employeedetails[i].qualification + '</td>';
                    results += '<td   class="7">' + employeedetails[i].Skills + '</td>';
                    results += '<td   class="8">' + employeedetails[i].experience + '</td>';
                    results += '<td   class="9">' + employeedetails[i].Appliedfor + '</td>';
                    results += '<td><input id="btn_poplate" type="button"  onclick="getresume(this)" name="submit" class="btn btn-primary" value="View" /></td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
                results += '</table></div>';
            }
            else {
                var results = '<div  style="overflow:auto;"><table class="responsive-table" id="example"style="height: 100px;">';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">Name</th><th scope="col">Surname</th><th scope="col">BirthDate</th><th scope="col">PhoneNo</th><th scope="col">Email</th><th scope="col">Qualification</th><th scope="col">Skills</th><th scope="col">Experience</th><th scope="col">Applied for</th><th scope="col"></th></tr></thead></tbody>';
                var k = 1;
                var l = 0;
                var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
                for (var i = 0; i < employeedetails.length; i++) {
                    if (Skills == employeedetails[i].Skills) {
                        results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + employeedetails[i].sno + '</th>';
                        results += '<td   class="2">' + employeedetails[i].name + '</td>';
                        results += '<td   class="2">' + employeedetails[i].surname + '</td>';
                        results += '<td   class="3">' + employeedetails[i].birthdate + '</td>';
                        results += '<td   class="4">' + employeedetails[i].cellphone + '</td>';
                        results += '<td   class="5">' + employeedetails[i].email + '</td>';
                        results += '<td   class="6">' + employeedetails[i].qualification + '</td>';
                        results += '<td   class="7">' + employeedetails[i].Skills + '</td>';
                        results += '<td  class="8">' + employeedetails[i].experience + '</td>';
                        results += '<td   class="9">' + employeedetails[i].Appliedfor + '</td>';
                        results += '<td><input id="btn_poplate" type="button" onclick="getresume(this)" name="submit" class="btn btn-primary" value="View" /></td></tr>';
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }
                results += '</table></div>';
            }
            $("#div_jobapplication").html(results);
        }
    var compiledList1 = [];
    function fillappliedfor(msg) {
        var compiledList = [];
        for (var i = 0; i < msg.length; i++) {
            var Appliedfor = msg[i].Appliedfor;
            compiledList.push(Appliedfor);
        }
        $('#txt_appliedfor').autocomplete({
            source: compiledList,
            change: appliedforchange,
            autoFocus: true
        });
    }
    function appliedforchange() {
        var appliedfor = document.getElementById('txt_appliedfor').value;
        if (appliedfor == "") {
            var results = '<div  style="overflow:auto;"><table class="responsive-table" id="example"style="height: 100px;">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Name</th><th scope="col">Surname</th><th scope="col">BirthDate</th><th scope="col">PhoneNo</th><th scope="col">Email</th><th scope="col">Qualification</th><th scope="col">Skills</th><th scope="col">Experience</th><th scope="col">Applied for</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < employeedetails.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + employeedetails[i].sno + '</th>';
                results += '<td   class="2">' + employeedetails[i].name + '</td>';
                results += '<td   class="2">' + employeedetails[i].surname + '</td>';
                results += '<td   class="3">' + employeedetails[i].birthdate + '</td>';
                results += '<td   class="4">' + employeedetails[i].cellphone + '</td>';
                results += '<td   class="5">' + employeedetails[i].email + '</td>';
                results += '<td   class="6">' + employeedetails[i].qualification + '</td>';
                results += '<td   class="7">' + employeedetails[i].Skills + '</td>';
                results += '<td   class="8">' + employeedetails[i].experience + '</td>';
                results += '<td   class="9">' + employeedetails[i].Appliedfor + '</td>';
                results += '<td><input id="btn_poplate" type="button"  onclick="getresume(this)" name="submit" class="btn btn-primary" value="View" /></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
        }
        else {
            var results = '<div  style="overflow:auto;"><table class="responsive-table" id="example"style="height: 100px;">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Name</th><th scope="col">Surname</th><th scope="col">BirthDate</th><th scope="col">PhoneNo</th><th scope="col">Email</th><th scope="col">Qualification</th><th scope="col">Skills</th><th scope="col">Experience</th><th scope="col">Applied for</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < employeedetails.length; i++) {
                if (appliedfor == employeedetails[i].appliedfor) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + employeedetails[i].sno + '</th>';
                    results += '<td   class="2">' + employeedetails[i].name + '</td>';
                    results += '<td   class="2">' + employeedetails[i].surname + '</td>';
                    results += '<td   class="3">' + employeedetails[i].birthdate + '</td>';
                    results += '<td   class="4">' + employeedetails[i].cellphone + '</td>';
                    results += '<td   class="5">' + employeedetails[i].email + '</td>';
                    results += '<td   class="6">' + employeedetails[i].qualification + '</td>';
                    results += '<td   class="7">' + employeedetails[i].Skills + '</td>';
                    results += '<td  class="8">' + employeedetails[i].experience + '</td>';
                    results += '<td   class="9">' + employeedetails[i].Appliedfor + '</td>';
                    results += '<td><input id="btn_poplate" type="button" onclick="getresume(this)" name="submit" class="btn btn-primary" value="View" /></td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
        }
        $("#div_jobapplication").html(results);
    }
    var compiledList2 = [];
    function  fillqualification(msg) {
        var compiledList = [];
        for (var i = 0; i < msg.length; i++) {
            var qualification  = msg[i].qualification;
            compiledList.push(qualification);
        }
        $('#txt_qualification').autocomplete({
            source: compiledList,
            change:qualificationchange,
            autoFocus: true
        });
    }
    function qualificationchange() {
        var qualification = document.getElementById('txt_appliedfor').value;
        if (qualification == "") {
            var results = '<div  style="overflow:auto;"><table class="responsive-table" id="example"style="height: 100px;">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Name</th><th scope="col">Surname</th><th scope="col">BirthDate</th><th scope="col">PhoneNo</th><th scope="col">Email</th><th scope="col">Qualification</th><th scope="col">Skills</th><th scope="col">Experience</th><th scope="col">Applied for</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < employeedetails.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + employeedetails[i].sno + '</th>';
                results += '<td   class="2">' + employeedetails[i].name + '</td>';
                results += '<td   class="2">' + employeedetails[i].surname + '</td>';
                results += '<td   class="3">' + employeedetails[i].birthdate + '</td>';
                results += '<td   class="4">' + employeedetails[i].cellphone + '</td>';
                results += '<td   class="5">' + employeedetails[i].email + '</td>';
                results += '<td   class="6">' + employeedetails[i].qualification + '</td>';
                results += '<td   class="7">' + employeedetails[i].Skills + '</td>';
                results += '<td   class="8">' + employeedetails[i].experience + '</td>';
                results += '<td   class="9">' + employeedetails[i].Appliedfor + '</td>';
                results += '<td><input id="btn_poplate" type="button"  onclick="getresume(this)" name="submit" class="btn btn-primary" value="View" /></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
        }
        else {
            var results = '<div  style="overflow:auto;"><table class="responsive-table" id="example"style="height: 100px;">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Name</th><th scope="col">Surname</th><th scope="col">BirthDate</th><th scope="col">PhoneNo</th><th scope="col">Email</th><th scope="col">Qualification</th><th scope="col">Skills</th><th scope="col">Experience</th><th scope="col">Applied for</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < employeedetails.length; i++) {
                if (qualification == employeedetails[i].qualification) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><th scope="row" class="1" style="text-align:center;">' + employeedetails[i].sno + '</th>';
                    results += '<td   class="2">' + employeedetails[i].name + '</td>';
                    results += '<td   class="2">' + employeedetails[i].surname + '</td>';
                    results += '<td   class="3">' + employeedetails[i].birthdate + '</td>';
                    results += '<td   class="4">' + employeedetails[i].cellphone + '</td>';
                    results += '<td   class="5">' + employeedetails[i].email + '</td>';
                    results += '<td   class="6">' + employeedetails[i].qualification + '</td>';
                    results += '<td   class="7">' + employeedetails[i].Skills + '</td>';
                    results += '<td  class="8">' + employeedetails[i].experience + '</td>';
                    results += '<td   class="9">' + employeedetails[i].Appliedfor + '</td>';
                    results += '<td><input id="btn_poplate" type="button" onclick="getresume(this)" name="submit" class="btn btn-primary" value="View" /></td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
        }
        $("#div_jobapplication").html(results);
    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <section class="content-header">
        <h1>
            Job Applications<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">DashBoard</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Job Applications
                </h3>
                
            </div>
            <div class="box-body">
              <div id="emp_showlogs" style="text-align: center;">
                        <table>
                            <tr>
                                <td style="width: 50px">
                                </td>
                                <td>
                                    <input id="txt_skills" type="text" style="height: 28px; opacity: 1.0; width: 150px;"
                                        class="form-control" placeholder="Search skills"  />
                                </td>
                                <td style="width: 35px">
                                    OR
                                </td>
                                <td>
                                    <input id="txt_appliedfor" type="text" style="height: 28px; opacity: 1.0; width: 150px;"
                                        class="form-control" placeholder="Search applied for"/>
                                </td>
                                <td style="width: 35px">
                                    OR
                                </td>
                                <td>
                                    <input id="txt_qualification" type="text" style="height: 28px; opacity: 1.0; width: 150px;"
                                        class="form-control" placeholder="Search qualification" />
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td>
                                    <i class="fa fa-search" aria-hidden="true" >Search</i>
                                </td>
                                <td style="width: 50px">
                                </td>
                                
                            </tr>
                        </table>
                    </div>
             </div>
            <div>
            <div id="div_jobapplication">
            </div>
                <div id="myModal" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            &times;</button>
                        <h4 class="modal-title">
                            <b>Resume</b></h4>
                    </div>
                    <div class="modal-body">
                       <table align="center">
                       <tr>
                            <td colspan="2">
                                <div id="div_resumes">
                                </div>
                            </td>
                        </tr>
                        <tr hidden>
                            <td>
                                <label id="lbl_sno"></label>
                            </td>
                        </tr>
                    </table>
                  <%--  <table align="center">
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                                <input id="btn_approve" type="button" class="btn btn-success" name="submit" value='Approve'
                                    onclick="save_approvalbill_click()" />
                                <input id='btn_reject' type="button" class="btn btn-danger" name="Close" value='Reject'
                                    onclick="save_rejectbill_click()" />
                            </td>
                        </tr>
                    </table>--%>
                    </div>
                    <div class="modal-footer" align="center">
                        <button id="btnaclose" type="button" class="btn btn-danger" data-dismiss="modal">
                            Close</button>
                    </div>
                </div>
            </div>
        </div>
            </div>
        </div>
    </section>
</asp:Content>

