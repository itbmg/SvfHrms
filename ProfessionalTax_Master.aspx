<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="ProfessionalTax_Master.aspx.cs" Inherits="ProfessionalTax_Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<script type="text/javascript">
    $(function () {
        get_ProfessionalTax_details();
    });
    function save_ProfessionalTax_Details() {
        var statename = document.getElementById("txt_state").value;
        var operation = document.getElementById("txt_Operator").value;
        var salary = document.getElementById("txt_salary").value;
        var amount = document.getElementById("txt_amount").value;
        var btnval = document.getElementById('btn_save').value;
        var Sno = document.getElementById('lbl_cansno').innerHTML;
        var data = { 'op': 'save_ProfessionalTax_Details', 'statename': statename, 'operation': operation, 'salary': salary, 'amount': amount, 'btnval': btnval, 'Sno': Sno };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_ProfessionalTax_details();
                    forclearall();
                }
            }
            else {
            }
        };
        var e = function (x, h, e) {
        }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
    }
    function forclearall() {
        document.getElementById('txt_state').value = "";
        document.getElementById('txt_Operator').value = "";
        document.getElementById('txt_salary').value = "";
        document.getElementById('txt_amount').value = "";
        document.getElementById('btn_save').value = "Save";
        $("#get_professionaltax").show();

    }

    function get_ProfessionalTax_details() {
        var statename = document.getElementById("txt_state").value;
        var data = { 'op': 'get_ProfessionalTax_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillProfessionalTaxdetails(msg);
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
    function fillProfessionalTaxdetails(msg) {
        var k = 1;
        var l = 0;
        var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
        var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col">State Name</th></th><th  scope="col"><i class="fa fa-university"></i>Operator</th><th scope="col">Salary</th></th><th scope="col" >Amount</th><th   scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '">';
            results += '<td>' + k++ + '</td>';
            results += '<th scope="row" class="1" ><span class="fa fa-university" style="color: cadetblue;"></span>  <span id="1" class="1"> ' + msg[i].statename + '</span</th>';
            results += '<td data-title="operation" class="2">' + msg[i].operation + '</td>';
            results += '<td data-title="salary" class="3">' + msg[i].salary + '</td>';
            results += '<td  class="5">' + msg[i].amount + '</td>';
            results += '<td style="display:none" class="6">' + msg[i].Sno + '</td>';
            results += '<td style="display:none" class="10">' + msg[i].operation1 + '</td>';
            results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="pttaxgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
        }
        results += '</table></div>';
        $("#get_professionaltax").html(results);
    }
    function pttaxgetme(thisid) {
        var statename = $(thisid).parent().parent().find('#1').html();
        var operation = $(thisid).parent().parent().children('.10').html();
       
        var salary = $(thisid).parent().parent().children('.3').html();        
        var amount = $(thisid).parent().parent().children('.5').html();
        var Sno = $(thisid).parent().parent().children('.6').html();
        document.getElementById('txt_state').value = statename;
        document.getElementById('txt_Operator').value = operation;
        document.getElementById('txt_salary').value = salary;
        document.getElementById('txt_amount').value = amount;
        document.getElementById('lbl_cansno').innerHTML = Sno;
        document.getElementById('btn_save').value = "Modify";
        $("#get_professionaltax").hide();
    }
    
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            ProfessionalTax Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Basic Information</a></li>
            <li><a href="#">ProfessionalTax Master</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
           <div class="box-header with-border">
              <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-user-plus"></i>ProfessionalTax Details
              </h3>   
            </div>
            <table align="center">
            <tr style="display:none;"><td>
                            <label id="lbl_cansno"></label>
                            </td>
                            </tr>
            <tr>
            <td style="height: 40px;">
                         <label class="control-label" >State Name </label>
            </td>
            <td>
            <select class="form-control" id="txt_state" style="width: 250px;">
                                                    <option selected disabled value="Select State Name" >Select State Name</option>
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
            </td>
            </tr>
            <tr>
            <td>
                        <label class="control-label" for="txt_type">
                          Operator</label>
                          </td>
            <td>
            <select class="form-control" id="txt_Operator" style="width: 250px;">
                                                    <option selected disabled value="Select Operator"  >Select Operator</option>
                                                        <option value="1">equal to</option>
                                                        <option value="2">not equal</option>
                                                        <option value="3">greater than</option>
                                                        <option value="4">less than</option>
                                                        <option value="5">greater than or equal to</option>
                                                        <option value="6">less than or equal to</option>
                                                        <option value="7">greater than or equal to and less than or equal to</option>
                                                        <option value="8">less than or equal to and greater than or equal to</option>
                                                    </select>
            </td>
            </tr>
            <tr>     
                    <td style="height: 40px;">
                        <label class="control-label" >
                            Salary
                            </label>
                        </td>
                        <td>
                        <input type="text" class="form-control" id="txt_salary" placeholder="Enter Salary " />                        
                    </td>
                    </tr>
                    <tr>     
                    <td style="height: 40px;">
                        <label class="control-label" >
                            Amount:
                            </label>
                        </td>
                        <td>
                        <input type="text" class="form-control" id="txt_amount" placeholder="Enter Amount " />
                    </td>
                    </tr>
                    <tr >
                    <td style="height: 40px;" >
                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                            onclick="save_ProfessionalTax_Details();">
                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Cancel"
                            onclick="forclearall();" >
                    </td>                   
                </tr>
            </table>
            <div id="get_professionaltax"></div>
                 </div> 
          
    </section>
</asp:Content>
