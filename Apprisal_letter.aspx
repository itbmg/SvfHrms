<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="Apprisal_letter.aspx.cs" Inherits="Apprisal_letter" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<script>
    function CallPrint(strid) {
        var divToPrint = document.getElementById(strid);
        var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
        newWin.document.open();
        newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
        newWin.document.close();
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Apprisal/Hike Letter
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Apprisal/Hike Letter</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Apprisal/Hike Details
                </h3>
            </div>
            <div class="box-body">

            </div>
            <div id="divPrint">

            <div style="font-size: 23px; font-weight: bold;" align="center">
                Apprisal/Hike Letter
            </div>
            <br />
            Dear <strong><span id="spnappointment_empname"></span>,</strong>
            <br />
            <br />
            <br />
            <p>
                In recognition of your performance and contribution to the organization during the
                appraisal period One Year, your monthly CTC is being revised to Rs.<strong><span
                    id="spnapprisal_ctc"></span>,</strong> /- (<strong><span id="spnapprisal_ctc_wards"></span>,</strong>)w.e.f.
                <strong><span id="spnapprisal_date"></span>,</strong>.
            </p>
            <br />
            <p>
                Your revised Compensation and Benefits Structure is given below for your reference.
            </p>
            <div id="div_salaryhike">
            </div>
            <br />
            <p>
                Kindly sign and return the duplicate of this letter as a token of your acceptance.
            </p>
            <p>
                Wishing you the best for the next year. Do keep up your good performance.
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
    </section>
</asp:Content>
