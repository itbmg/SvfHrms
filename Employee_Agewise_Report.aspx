<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="Employee_Agewise_Report.aspx.cs" Inherits="Employee_Agewise_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function () {
        get_branch_details();
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
    function get_branch_details() {
        var data = { 'op': 'get_branch_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillbranch(msg);
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
    function fillbranch(msg) {
        var data = document.getElementById('slct_branch');
        var length = data.options.length;
        document.getElementById('slct_branch').options.length = null;
        var opt = document.createElement('option');
        opt.innerHTML = "Select Branch";
        opt.value = "Select Branch";
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
    function get_employeeage_details() {
        var branchid = document.getElementById('slct_branch').value;
        var data = { 'op': 'get_employeeage_details',  'branchid': branchid };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillemployeeagedetails(msg);
                    $('#btn_retireprint').css('display', 'block');
                    $('#divPrint').css('display', 'block');
                    $('#printbtn').css('display', 'block');
                    document.getElementById('lblTitle').innerHTML = msg[0].title;
                    document.getElementById('lblAddress').innerHTML = msg[0].address;
                    document.getElementById('lblHeading').innerHTML = "Employee Agewise Details";
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
    function fillemployeeagedetails(msg) {
        var k = 1;
        var l = 0;
        var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';        
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">EmployeeCode</th><th scope="col">Name</th><th scope="col">Employee_Type</th><th scope="col">Age</th></tr></thead></tbody>';            
            for (var i = 0; i < msg.length; i++) {                
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row" class="1">' + msg[i].empnum + '</th>';
                results += '<th scope="row" class="2">' + msg[i].fullname + '</th>';
                results += '<th scope="row" class="3">' + msg[i].employee_type + '</th>';
                results += '<th scope="row" class="4">' + msg[i].age + '</th></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
        results += '</table></div>';
        $("#div_empagedetails").html(results);
    }

</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
         Employee Agewise Deatils<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#"> Employee Agewise Report </a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i> Employee Agewise Deatils 
                </h3>
            </div>
            <div class="box-body">
             <div id="div_dup">
                   <div id='fillform' >
                      <table align="center">
                            <tr>                                
                               <td style="width: 5px;"></td>
                               <td>
                                    <label>
                                      Branch Name</label>
                                </td>
                                <td style="width: 5px;"></td>
                                <td style=" height: 40px; ">
                                    <select id="slct_branch" class="form-control" type="text" ></select>
                               </td>

                               <td style="width: 5px;"></td>
                               <td style="height:40px;"></td>
                               
                               <td colspan="2" align="center" style="height:40px;">
                              <input id="btn_generate" type="button" class="btn btn-primary" name="Generate" value='Generate' onclick="get_employeeage_details()" />
                            </td> 
                             </tr>

                              <tr style="display:none;">
                              <td>
                            <label id="lbl_sno"></label>
                            </td>                            
                            </tr>
                           </table>
        </div>
        </div>
    </div>
     <div id="divPrint" style="display:none; margin:2%">
    <div align="center">
                                                <label id="lblTitle"  Font-Bold="true" Font-Size="20px" ForeColor="#0252aa" style="color:#0252AA !important;font-size:16px!important;font-weight: bold!important";
                                                    ></label>
                                                <br />
                                                <label id="lblAddress"  Font-Bold="true" Font-Size="12px" ForeColor="#0252aa" style="color:#0252AA !important;font-size:16px!important;font-weight: bold!important";
                                                    ></label>
                                                <br />
                                                 <label id="lblHeading"  Font-Bold="true" Font-Size="15px" ForeColor="#0252aa" style="color:#0252AA !important;font-size:16px!important;font-weight: bold!important";
                                                    ></label>
                                                    <br />                                               
                                            </div>
                             <div id ="div_empagedetails" ></div>
                                   <br />
                                   
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">Prepared By</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">Audit By</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">A.O</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">GM</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">Director</span>
                                                </td>
                                            </tr>
                                        </table>
                                        </div>
                                        <div align="center" id="printbtn" style="display:none">
                                        <table>
                                        <tr>
                                        <td>
                                         <button type="button" id="btn_retireprint" class="btn btn-success"   onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                                        </td>                                       
                                        </tr>
                                        </table>
                                         </div>
</div>
    </section>
</asp:Content>

