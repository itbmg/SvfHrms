<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="BulletinBoardReport.aspx.cs" Inherits="BulletinBoardReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function () {
        get_bullentin_details();
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
    function get_bullentin_details() {
        var data = { 'op': 'get_bullentin_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    filldetails(msg);
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
    //var content = document.getElementById("txt_descrption").textContent;
    function filldetails(msg) {
        var k = 1;
        var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" boarder="0">';
        var l = 0;
        var color = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + color[l] + '"><td>' + k++ + '</td>';
            results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].title + '</th>';
            results += '<td data-title="brandstatus" class="2">' + msg[i].description + '</td>';
            results += '<td data-title="brandstatus" style="display:none" class="3">' + msg[i].sno + '</td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
        }
        results += '</table></div>';
        $("#div_bulentdata").html(results);
    }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content-header">
        <h1>
            Bulletin DashBoard
        </h1>
        <ol class="breadcrumb" >
            <li><a href="#"><i class="fa fa-dashboard"></i>Dash Board</a></li>
            <li><a href="#">Bulletin DashBoard</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Bulletin DashBoard 
                </h3>
                <h3 class="box-title">
                    <label id="lblsessionname">
                    </label>
                </h3>
            </div>
            <div class="box-body">
                <div>
                    <table>
                        <tr>
                            <td>
                                <marquee id="txt_descrption" behavior="scroll" onMouseOver="this.stop()" onMouseOut="this.start()" scrollamount="3" direction="up">
                   <div id="div_bulentdata"></div>
                    </marquee>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </section>
</asp:Content>

