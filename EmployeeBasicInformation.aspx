<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin.master" CodeFile="EmployeeBasicInformation.aspx.cs" Inherits="test" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">

        $(function () {
            get_employee_info();
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
        function callHandler_nojson_post(d, s, e) {
            $.ajax({
                url: 'EmployeeManagementHandler.axd',
                type: "POST",
                contentType: false,
                processData: false,
                data: d,
                success: s,
                error: e
            });
        }
        $(document).keyup(function (e) {
            if (e.keyCode === 27) {
                dep_closepopup(dep_close);
            }
        });
        function dep_closepopup(msg) {
            $("#div_getempdata").css("display", "block");
            $("#divshowgrid").css("display", "none");
        }

        var empdetails = [];
        function get_employee_info() {
            var data = { 'op': 'get_employebasicinfo' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        employeinfo(msg);
                        empdetails = msg;
                        $('#div_getempdata').css('display', 'block');

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
        function employeinfo(msg) {
            for (var i = 0; i < msg.length; i++) {
                var rndmnum = Math.floor((Math.random() * 10) + 1);
                var employeeimgurl = msg[i].photos;
                var img = "images/Vyshnavilogo.png";
                if (employeeimgurl != "") {
                    img = msg[i].ftplocation + employeeimgurl + '?v=' + rndmnum;
                }
                if (employeeimgurl != "") {
                    $('#div_getempdata').append(' <div class="col-sm-12 col-md-6"><div class="box box-solid"><div class="box-body"><div class="media" onclick="getmeempdetails(' + msg[i].empid + ')"><div class="media-left"><a href="#" class="ad-click-event"><img src="' + img + '" alt="Employee Image" class="media-object" style="width: 84px;height: auto;border-radius: 4px;box-shadow: 0 1px 3px rgba(0,0,0,.15);"></a></div><div class="media-body"><div class="clearfix"><br><h4 style="margin-top: 0">' + msg[i].fullname + '</h4><strong>Employe Number:</strong> &nbsp; <span style="color: red;">' + msg[i].employee_num + '</span><br><strong>Designation:</strong> &nbsp; <span >' + msg[i].designation + '</span><br><strong>Phone Number:</strong> &nbsp; <span >' + msg[i].cellphone + '</span><br><strong>Location:</strong> &nbsp; <span >' + msg[i].branchname + '</span></div></div></div></div></div></div>');
                }
                else {
                    $('#div_getempdata').append(' <div class="col-sm-12 col-md-6"><div class="box box-solid"><div class="box-body"><div class="media" onclick="getmeempdetails(' + msg[i].empid + ')"><div class="media-left"><a href="#" class="ad-click-event"><img src="' + img + '" alt="Employee Image" class="media-object" style="width: 84px;height: auto;border-radius: 4px;box-shadow: 0 1px 3px rgba(0,0,0,.15);"></a></div><div class="media-body"><div class="clearfix"><br><h4 style="margin-top: 0">' + msg[i].fullname + '</h4><strong>Employe Number:</strong> &nbsp; <span style="color: red;">' + msg[i].employee_num + '</span><br><strong>Designation:</strong> &nbsp; <span >' + msg[i].designation + '</span><br><strong>Phone Number:</strong> &nbsp; <span >' + msg[i].cellphone + '</span><br><strong>Location:</strong> &nbsp; <span >' + msg[i].branchname + '</span></div></div></div></div></div></div>');
                }
            }
        }
        //------------test---------------//

        function getmeempdetails(empid) {
            var empids = empid;
            var data = { 'op': 'btn_apprisal_Click', 'empids': empids };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        var employee_details = msg;
                        $('#div_getempdata').css('display', 'none');
                        $('#divshowgrid').css('display', 'block');
                        document.getElementById('lblempname').innerHTML = employee_details[0].fullname;
                        document.getElementById('lblempfullname').innerHTML = employee_details[0].fullname;
                        document.getElementById('lblbranch').innerHTML = employee_details[0].branchname;
                        document.getElementById('lblEmpID').innerHTML = employee_details[0].employee_num;
                        document.getElementById('lblFathersName').innerHTML = employee_details[0].fathername;
                        document.getElementById('lblAdress').innerHTML = employee_details[0].presentaddress;
                        document.getElementById('lblperementaddress').innerHTML = employee_details[0].emprefaddress1;
                        document.getElementById('lblContactNumber').innerHTML = employee_details[0].cellphone;
                        document.getElementById('spncontactno').innerHTML = employee_details[0].cellphone;
                        document.getElementById('lblDOB').innerHTML = employee_details[0].dob;
                        document.getElementById('lblspouse').innerHTML = employee_details[0].spousename;
                        document.getElementById('lblemail').innerHTML = employee_details[0].fullname;
                        //                        document.getElementById('lblname2').innerHTML = employee_details[0].fullname;
                        document.getElementById('lbljoindate1').innerHTML = employee_details[0].joindate;
                        document.getElementById('lblDesgnation1').innerHTML = employee_details[0].designation;
                        document.getElementById('spndesignation').innerHTML = employee_details[0].designation;
                        document.getElementById('lblbackname').innerHTML = employee_details[0].bankname;
                        document.getElementById('lblaccount').innerHTML = employee_details[0].bankaccountno;
                        document.getElementById('lblbankbranch').innerHTML = employee_details[0].bankbranchname;
                        document.getElementById('lblifsc').innerHTML = employee_details[0].ifsccode;
                        //                        if (employee_details[0].appraisal != "") {
                        //                            document.getElementById('lblapprisals').innerHTML = employee_details[0].appraisal;

                        //                        }
                        //                        else {
                        //                            document.getElementById('lblapprisals').innerHTML = '0';
                        //                        }
                        //                        document.getElementById('lblchangedpkg').innerHTML = employee_details[0].changedpackage;
                        document.getElementById('lblsalperyr').innerHTML = employee_details[0].salaryperyear;
                        document.getElementById('lblgross').innerHTML = employee_details[0].gross;
                        document.getElementById('lblearnbasic').innerHTML = employee_details[0].erningbasic;
                        document.getElementById('lblnet').innerHTML = employee_details[0].netpay;
                        document.getElementById('spnempid').innerHTML = employee_details[0].empid;
                        document.getElementById('spnemprefnum1').innerHTML = employee_details[0].empid;
                        document.getElementById('lblhra').innerHTML = employee_details[0].hra;
                        document.getElementById('lblconvi').innerHTML = employee_details[0].conveyance;
                        document.getElementById('lblwashing').innerHTML = employee_details[0].washingallowance;
                        document.getElementById('lblmedical').innerHTML = employee_details[0].medicalerning;
                        document.getElementById('lblesi').innerHTML = employee_details[0].esi;
                        document.getElementById('lblpfscheme').innerHTML = employee_details[0].pfscheme;
                        document.getElementById('lblpf').innerHTML = employee_details[0].providentfund;
                        document.getElementById('lblpt').innerHTML = employee_details[0].profitionaltax;
                        document.getElementById('lblpfjdate').innerHTML = employee_details[0].pfjoindate;
                        document.getElementById('lblpfnum').innerHTML = employee_details[0].pfnumber;
                        document.getElementById('lbluannum').innerHTML = employee_details[0].uannumber;


                        var status = employee_details[0].pfeligible;
                        if (status == "Yes") {
                            status = "Active";
                            document.getElementById('spnstatus').innerHTML = status;
                        }
                        else {
                            status = "InActive"
                            document.getElementById('spnstatus').innerHTML = status;
                        }
                        document.getElementById('spnempdept1').innerHTML = employee_details[0].department;
                        if (employee_details[0].experience != "") {
                            document.getElementById('spnexpemp1').innerHTML = employee_details[0].experience;
                        }
                        else {
                            document.getElementById('spnexpemp1').innerHTML = "0";
                        }
                        var rndmnum = Math.floor((Math.random() * 10) + 1);
                        img_url = employee_details[0].ftplocation + employee_details[0].photos + '?v=' + rndmnum;

                        var empphoto = employee_details[0].photos;
                        if (empphoto === undefined || empphoto === "") {
                            $('#main_img').attr('src', 'Images/Vyshnavilogo.png').width(200).height(200);
                        }
                        else {

                            $('#main_img').attr('src', img_url).width(200).height(200);
                        }
                        //                        document.getElementById('spn_Company').innerHTML = employee_details[0].companyname;
                        //                        document.getElementById('spn_Address').innerHTML = employee_details[0].address;
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
          Employee Basic Information <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Employee master</a></li>
        </ol>
    </section>
    <body>
        <section class="content">
        <div id="div_Documents" >
       <div class="docs-premium-template" >
      <div id="div_getempdata" style="display: none;">
       </div>
        </div>
        </div>
         <div id="divshowgrid" style="display: none; width:100%;">
        <section class="content">
      <div class="row">
        <div class="col-md-3">
          <!-- Profile Image -->
          <div class="box box-primary">
            <div class="box-body box-profile">
              <img class="profile-user-img img-responsive img-circle" src="" id="main_img" alt="User profile picture">

              <h3 class="profile-username text-center" id="lblempname"></h3>

              <p class="text-muted text-center" id="lblDesgnation1"></p>

              <ul class="list-group list-group-unbordered">
                <li class="list-group-item">
                  <b>Location</b> <a class="pull-right" id="lblbranch"></a>
                </li>
                <li class="list-group-item">
                  <b>Contact No</b> <a class="pull-right" id="lblContactNumber"></a>
                </li>
                <li class="list-group-item">
                  <b>Employee ID</b> <a class="pull-right" id="spnempid"></a>
                </li>
              </ul>
              <a href="#" class="btn btn-primary btn-block" ><b>PF</b>&nbsp &nbsp<span id="spnstatus" style="color: red;"></span></a>
            </div>
            <!-- /.box-body -->
          </div>
          <!-- /.box -->
        </div>
        <!-- /.col -->
        <div class="col-md-9">
          <div class="nav-tabs-custom">
            <ul class="nav nav-tabs">
              <li class="active"><a href="#activity" data-toggle="tab" aria-expanded="true">Basic Information</a></li>
              <li class=""><a href="#timeline" data-toggle="tab" aria-expanded="false">Bank And PF Details</a></li>
              <li class=""><a href="#settings" data-toggle="tab" aria-expanded="false">Salary And Other Details</a></li>
            </ul>
            <div class="tab-content">
              <div class="tab-pane active" id="activity" style="height: 412px;">
              <div class="row">
              <div class="col-md-6" style="padding-left:  0px !important;padding-right: 0px !important;">
              <ul class="list-group list-group-unbordered">
                <li class="list-group-item">
                  <b>Full Name</b> <a class="pull-right" id="lblempfullname"></a>
                </li>
                <li class="list-group-item">
                  <b>Employee code</b> <a class="pull-right" id="lblEmpID"></a>
                </li>
                <li class="list-group-item">
                  <b>Employee ID</b> <a class="pull-right" id="spnemprefnum1"></a>
                </li>
                <li class="list-group-item">
                  <b>Department</b> <a class="pull-right" id="spnempdept1"></a>
                </li>
                <li class="list-group-item">
                  <b>Disignation</b> <a class="pull-right" id="spndesignation"></a>
                </li>
                <li class="list-group-item">
                  <b>Contact number</b> <a class="pull-right" id="spncontactno"></a>
                </li>
                <li class="list-group-item" style="height: 100px;">
                  <b>Permanant Address</b> <a class="pull-right" id="lblperementaddress"></a>
                </li>
                </ul>
               </div>
                <div class="col-md-6" style="padding-left:  0px !important;padding-right: 0px !important;">
              <ul class="list-group list-group-unbordered">
              <li class="list-group-item">
                  <b>Joining Date</b> <a class="pull-right" id="lbljoindate1"></a>
                </li>
                <li class="list-group-item">
                  <b>Experiance</b> <a class="pull-right" id="spnexpemp1"></a>
                </li>
                <li class="list-group-item">
                  <b>DOB</b> <a class="pull-right" id="lblDOB"></a>
                </li>
                <%--<li class="list-group-item">
                  <b>ID Type</b> <a class="pull-right" id="A18"></a>
                </li>
                <li class="list-group-item">
                  <b>Id Number</b> <a class="pull-right" id="A19"></a>
                </li>--%>
                <li class="list-group-item">
                  <b>Fathers name</b> <a class="pull-right" id="lblFathersName"></a>
                </li>
                <li class="list-group-item">
                  <b>Spouse name</b> <a class="pull-right" id="lblspouse"></a>
                </li>
                <li class="list-group-item">
                  <b>Email </b> <a class="pull-right" id="lblemail"></a>
                </li>
                <li class="list-group-item" style="height: 100px;">
                  <b>Prasent Address</b> <a class="pull-right" id="lblAdress"></a>
                </li>
              </ul>
              </div>
              </div>
              </div>
              <!-- /.tab-pane -->
              <div class="tab-pane" id="timeline" style="height: 458px;" >
                <!-- The timeline -->
              <a href="#" class="btn btn-primary btn-block" ><b>Bank Details</b></a>
                <ul class="list-group list-group-unbordered" style="height: 150px;">
                <li class="list-group-item">
                  <b>Bank Name</b> <a class="pull-right" id="lblbackname"></a>
                </li>
                <li class="list-group-item">
                  <b>Account Number</b> <a class="pull-right" id="lblaccount"></a>
                </li>
                <li class="list-group-item">
                  <b>Ifsc Code</b> <a class="pull-right" id="lblifsc"></a>
                </li>
                <li class="list-group-item">
                  <b>Branch</b> <a class="pull-right" id="lblbankbranch"></a>
                </li>
              </ul>
              <a href="#" class="btn btn-primary btn-block" ><b>PF Details</b></a>

                <ul class="list-group list-group-unbordered" style="height: 148px;">
                 <li class="list-group-item">
                  <b>PF Scheme</b> <a class="pull-right" id="lblpfscheme"></a>
                </li>
                <li class="list-group-item">
                  <b>PF</b> <a class="pull-right" id="lblpf"></a>
                </li>
                <li class="list-group-item">
                  <b>PT</b> <a class="pull-right" id="lblpt"></a>
                </li>
                <li class="list-group-item">
                  <b>PF Join Date</b> <a class="pull-right" id="lblpfjdate"></a>
                </li>
                <li class="list-group-item">
                  <b>PF Number</b> <a class="pull-right" id="lblpfnum"></a>
                </li>
                <li class="list-group-item">
                  <b>Uan Number</b> <a class="pull-right" id="lbluannum"></a>
                </li>
                <%--<li class="list-group-item">
                  <b>Salary Per Year</b> <a class="pull-right" id="lblsalperyr"></a>
                </li>
                <li class="list-group-item">
                  <b>Gross</b> <a class="pull-right" id="lblgross"></a>
                </li>
                <li class="list-group-item">
                  <b>Earning Basic</b> <a class="pull-right" id="lblearnbasic"></a>
                </li>
                <li class="list-group-item">
                  <b>Net </b> <a class="pull-right" id="lblnet"></a>
                </li>--%>
              </ul>
              </div>
              <!-- /.tab-pane -->

              <div class="tab-pane" id="settings" style="height: 412px;">
               <ul class="list-group list-group-unbordered" >
               <%--  <li class="list-group-item">
                  <b>PF Scheme</b> <a class="pull-right" id="lblpfscheme"></a>
                </li>
                <li class="list-group-item">
                  <b>PF</b> <a class="pull-right" id="lblpf"></a>
                </li>
                <li class="list-group-item">
                  <b>PT</b> <a class="pull-right" id="lblpt"></a>
                </li>
                <li class="list-group-item">
                  <b>PF Join Date</b> <a class="pull-right" id="lblpfjdate"></a>
                </li>
                <li class="list-group-item">
                  <b>PF Number</b> <a class="pull-right" id="lblpfnum"></a>
                </li>--%>
                 <li class="list-group-item">
                <b>Salary Per Year</b> <a class="pull-right" id="lblsalperyr"></a>
                </li>
                <li class="list-group-item">
                  <b>Gross</b> <a class="pull-right" id="lblgross"></a>
                </li>
                <li class="list-group-item">
                  <b>Earning Basic</b> <a class="pull-right" id="lblearnbasic"></a>
                </li>
                <li class="list-group-item">
                  <b>Net </b> <a class="pull-right" id="lblnet"></a>
                </li>
                
              </ul> 
               <ul class="list-group list-group-unbordered">
               <li class="list-group-item">
                  <b>HRA</b> <a class="pull-right" id="lblhra"></a>
                </li>
                <li class="list-group-item">
                  <b>Conveyance</b> <a class="pull-right" id="lblconvi"></a>
                </li>
                <li class="list-group-item">
                  <b>Washing Allowances</b> <a class="pull-right" id="lblwashing"></a>
                </li>
                <li class="list-group-item">
                  <b>Medical Allowances</b> <a class="pull-right" id="lblmedical"></a>
                </li>
                <li class="list-group-item">
                  <b>Esi</b> <a class="pull-right" id="lblesi"></a>
                </li>
              </ul> 

              </div>
              <!-- /.tab-pane -->
            </div>
            <!-- /.tab-content -->
          </div>
          <!-- /.nav-tabs-custom -->
        </div>
        <!-- /.col -->
      </div>
      <!-- /.row -->
       </section>
    <div id="div1" style="width: 56px; top: 20%; right: 2%; position: absolute; z-index: 99999;
                        cursor: pointer;">
                        <img src="Images/Close.png" alt="close" onclick="dep_closepopup();" />
                    </div>
             <div style="text-align:  center;">
                <button type="button" class="btn btn-danger" id="dep_close" onclick="dep_closepopup();">
                    Close </button>
                </div>
          </div>
    </section>
    </body>
</asp:Content>
