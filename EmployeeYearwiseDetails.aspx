<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="EmployeeYearwiseDetails.aspx.cs" Inherits="EmployeeYearwiseDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            GetEmployeeDeatails();
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
        var arraymsg = [];
        function GetEmployeeDeatails() {
            //        var branchid = document.getElementById('slct_branch').value;
            var data = { 'op': 'get_all_dash_employeedetails' };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        arraymsg = msg;
                    }
                    else {
                    }
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillConfirmation_Due_employee() {
            var msg = arraymsg;
            var branchid = document.getElementById('slct_branch').value;
            var table = document.getElementById("tbl_Confirmation_Due");
            $('#btn_retireprint').css('display', 'block');
            $('#divPrint').css('display', 'block');
            $('#printbtn').css('display', 'block');
            for (var i = table.rows.length - 1; i > 0; i--) {
                table.deleteRow(i);
            }
            var j = 1;
            var k = 0;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:#3f91c1"><th scope="col">EmployeeCode</th><th scope="col">Name</th><th scope="col">No Of Years</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                if (branchid == msg[i].branchid) {
                    var tablerowcnt = document.getElementById("tbl_Confirmation_Due").rows.length;
                    var jyears = msg[i].joingyears;
                    var joingyears = parseInt(jyears);
                    if (joingyears >= 5) {
                        results += '<tr>';
                        results += '<th scope="row" class="1">' + msg[i].empnum + '</th>';
                        results += '<th scope="row" class="2">' + msg[i].empname + '</th>';
                        results += '<th scope="row" class="4">' + joingyears + '</th></tr>';
                        k = k + 1;
                        if (k == 4) {
                            k = 0;
                        }
                    }
                }
            }
            results += '</table></div>';
            $("#tbl_Confirmation_Due").html(results);
        }
    </script>
    <script type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
        
    </script>
</asp:Content>
<asp:content id="Content2" contentplaceholderid="ContentPlaceHolder1" runat="Server">
    <section class="content-header" style="overflow: inherit !important;">
        <h1>
            Employee Years Of Service Details <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
        </ol>
    </section>
    <!-- Main content -->
    <section class="content" style="overflow: inherit !important;">
<div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Years Of Service Details</h3>                        
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
                              <input id="btn_generate" type="button" class="btn btn-primary" name="Generate" value='Generate' onclick="fillConfirmation_Due_employee()" />
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
    <div id="divPrint" style="width:100%;">
                    <div class="box-body">
                        <div class="box-body no-padding">
                            <table   id="tbl_Confirmation_Due" class="table">
                             </table>
                        </div>
                    </div>
                <br />
                </div>
                 
                       
                                        
                                        <div align="center" id="printbtn" style="display:none">
                                        <table>
                                        <tr>
                                        <td>
                                         <button type="button" id="btn_retireprint" class="btn btn-success"   onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                                        </td>
                                        <td>
                                        <%--<input type="button" class="btntogglecls" style="height: 28px; opacity: 1.0; width: 100px;
                                        background-color: #d5d5d5; color: Blue;" onclick="tableToExcel('divPrint', 'W3C Example Table')"
                                        value="Export to Excel" />--%>
                                        </td>                                      
                                        </tr>
                                        </table>
                                         </div>
               
                </section>
</asp:content>
