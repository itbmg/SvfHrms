<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="PTConsolidated_Report.aspx.cs" Inherits="PTConsolidated_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">

function onchangebranch() {

        var type = document.getElementById("slct_type").value;
        if (type == "1") {
            $('#slct_location').css('display', 'block');
            $('#branchname').css('display', 'block');
            get_branch_details();
        }
        else {
            $('#slct_location').css('display', 'none');
            $('#branchname').css('display', 'none');

        }
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
        var data = document.getElementById('slct_locname');
        var length = data.options.length;
        document.getElementById('slct_locname').options.length = null;
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
    function get_professionaltax_details() {
        var type = document.getElementById('slct_type').value;
        var branchid = document.getElementById('slct_locname').value;
        var month = document.getElementById('slct_month').value;
        var year = document.getElementById('slct_year').value;
        var data = { 'op': 'get_professionaltax_details', 'type': type, 'branchid': branchid, 'month': month, 'year': year };
        var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillprofessionaltaxdetails(msg);
                        $('#btn_retireprint').css('display', 'block');
                        $('#divPrint').css('display', 'block');
                        $('#printbtn').css('display', 'block');
                        document.getElementById('lblTitle').innerHTML = msg[0].title;
                        document.getElementById('lblAddress').innerHTML = msg[0].address;
                        document.getElementById('lblHeading').innerHTML = "Professional Tax Details";
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
        function fillprofessionaltaxdetails(msg) {
            var k = 1;
            var l = 0;
            var type = document.getElementById('slct_type').value;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            if (type == "1") {
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">EmployeeCode</th><th scope="col">Name</th><th scope="col">ProfessionalTax</th></tr></thead></tbody>';
                var totalpttax = 0;
                for (var i = 0; i < msg.length; i++) {
                    var pttax = parseFloat(msg[i].pttax) || 0;
                    totalpttax += pttax;
                    results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                    results += '<th scope="row" class="1">' + msg[i].empnum + '</th>';
                    results += '<th scope="row" class="2">' + msg[i].fullname + '</th>';
                    results += '<th scope="row" class="3">' + parseFloat(pttax).toFixed(2) + '</th></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0; 
                    }
                }
                var Total="Total";
                results += '<tr style="background-color: skyblue;">';
                results += '<th scope="row" class="1"></th>';
                results += '<th scope="row" class="1"></th>';
                results += '<th scope="row" class="2">' + Total + '</th>';
                results += '<th scope="row" class="3">' + parseFloat(totalpttax).toFixed(2) + '</th></tr>';
            }
            else {
                results += '<thead><tr><th scope="col">Sno</th><th scope="col">BranchName</th><th scope="col">ProfessionalTax</th></tr></thead></tbody>';
                var totalpttax = 0;
                for (var i = 0; i < msg.length; i++) {
                    var pttax = parseFloat(msg[i].pttaxsum) || 0;
                    totalpttax += pttax;
                    results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                    results += '<th scope="row" class="4">' + msg[i].branchid + '</th>';
                    results += '<th scope="row" class="5">' + parseFloat(pttax).toFixed(2) + '</th></tr>';
                    l = l + 1; 
                    if (l == 4) {
                        l = 0;
                    }
                }
                var Total = "Total";
                results += '<tr style="background-color: skyblue;">';
                results += '<th scope="row" class="1"></th>';
                results += '<th scope="row" class="2">' + Total + '</th>';
                results += '<th scope="row" class="3">' + parseFloat(totalpttax).toFixed(2) + '</th></tr>';
            }
            results += '</table></div>';
            $("#div_emppfdetails").html(results);
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
         Professional Tax<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#"> Professional Tax Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i> Professional Tax Details
                </h3>
            </div>
            <div class="box-body">
             <div id="div_dup">
                   <div id='fillform' >
                      <table align="center">
                            <tr>
                                <td style="height:40px;">
                                <label>Category</label>
                                        
                                </td> 
                                
                                <td style="height: 40px;">
                                    <select id="slct_type" class="form-control" type="text" onchange="onchangebranch()">
                                    <option selected disabled value>Select One</option>
                                    <option value="1">Branch Wise</option>
                                    <option value="2">Consolidated Data</option>
                                    </select>
                               </td>
                               <td style="width: 5px;"></td>
                               <td id="branchname"  style="display:none;">
                                    <label>
                                      Branch Name</label>
                                </td>
                                <td style="width: 5px;"></td>
                                <td style=" height: 40px; display:none;" id="slct_location">
                                    <select id="slct_locname" class="form-control" type="text" ></select>
                               </td>

                               <td style="width: 5px;"></td>
                               <td style="height:40px;"></td>

                               <td style="height: 40px;">
                            <label>Month</label>
                            </td>
                               <td style="width: 5px;"></td>
                            <td style="height: 40px;">
                                    <select id="slct_month" class="form-control" type="text" >
                                    <option selected disabled value>Select One</option>
                                    <option value="01">January</option>
                                    <option value="02">February</option>
                                    <option value="03">March</option>
                                    <option value="04">April</option>
                                    <option value="05">May</option>
                                    <option value="06">June</option>
                                    <option value="07">July</option>
                                    <option value="08">August</option>
                                    <option value="09">September</option>
                                    <option value="10">October</option>
                                    <option value="11">November</option>
                                    <option value="12">December</option>
                                    </select>
                            </td>
                               <td style="width: 5px;"></td>
                            <td style="height: 40px;">
                            <label>Year</label>
                            </td>
                               <td style="width: 5px;"></td>
                            <td style="height: 40px;">
                                    <select id="slct_year" class="form-control" type="text" >
                                    <option selected disabled value>Select One</option>
                                    <option value="2016">2016</option>
                                    <option value="2017">2017</option>
                                    <option value="2018">2018</option>
                                    <option value="2019">2019</option>
                                    <option value="2020">2020</option>
                                    <option value="2021">2021</option>
                                    <option value="2022">2022</option>
                                    <option value="2023">2023</option>
                                    <option value="2024">2024</option>
                                    <option value="2025">2025</option>
                                    <option value="2026">2026</option>
                                    <option value="2027">2027</option>
                                    </select>
                            </td>
                               <td style="width: 5px;"></td>
                               <td style="height:40px;"></td>
                               <td colspan="2" align="center" style="height:40px;">
                              <input id="btn_generate" type="button" class="btn btn-primary" name="Generate" value='Generate' onclick="get_professionaltax_details()" />
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
     <div id="divPrint" style="display:none">
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
                                                <%--<span style="font-size: 18px; font-weight: bold; color: #0252aa;">Bank  Salary Statement
                                                    Report</span><br />--%>
                                            </div>
                             <div id ="div_emppfdetails" ></div>
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



