<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="DashBoard_alerts.aspx.cs" Inherits="DashBoard_alerts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="js/JTemplate.js" type="text/javascript"></script>
    <script src="js/utility.js" type="text/javascript"></script>
    <%-- <link href="bootstrap/bootstrap.css" rel="stylesheet" type="text/css" />
    <link href="bootstrap/RouteWiseTimeLine.css" rel="stylesheet" type="text/css" />--%>
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

        function btn_Generate_Click() {
            var month = document.getElementById("select_month").value;
            var year = document.getElementById("select_year").value;
            var data = { 'op': 'GetFinalizesalaryDeatails', 'month': month, 'year': year };
            var s = function (msg) {
                if (msg) {
                    if (msg == "No data found") {
                    }
                    else {
                        $('#divFillScreen').removeTemplate();
                        $('#divFillScreen').processTemplate(msg);
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
        function filldetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Branch Name</th><th scope="col">Sataus</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].statusalert == "Complete") {
                    results += '<tr><td style="text-align:center;">' + k++ + '</td>';
                    results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].branchname + '</th>';
                    results += '<td style="text-align:center; background-color:green; color:white;" class="2">' + msg[i].statusalert + '</td></tr>';
                }
                else {
                    var incom = "Pending";
                    results += '<tr><td style="text-align:center;" >' + k++ + '</td>';
                    results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].branchname + '</th>';
                    results += '<td style="text-align:center; background-color:red;color:white;" class="2">' + incom + '</td></tr>';
                }
            }
            results += '</table></div>';
            $("#divFillScreen").html(results);

        }
        //        var vehicleList = [];
        //        function fillVehicledetails(msg) {
        //            for (var i = 0; i < msg.length; i++) {
        //                var vehicleno = msg[i].vehicleno;
        //                vehicleList.push(vehicleno);
        //            }
        //            $('#txt_VehicleNo').autocomplete({
        //                source: vehicleList,
        //                change: vehiclenochange,
        //                autoFocus: true
        //            });
        //        }
        function vehiclenochange() {
        }
        function blinkFont() {
            $('.statusalert').each(function (i, obj) {
                var qtyclass = $(this).text();
                if (qtyclass == "            " || qtyclass == "") {
                    $(this).parent().css('background', 'green');
                    $(this).parent().css('color', 'white');
                }
            });
            setTimeout("setblinkFont()", 100)
        }
        function setblinkFont() {
            $('.Ins_exp').each(function (i, obj) {
                var qtyclass = $(this).text();
                if (qtyclass == "            ") {
                    $(this).parent().css('background', 'blue');
                    $(this).parent().css('color', 'white ');
                }
            });
            setTimeout("blinkFont()", 100)
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Salary Details
                </h3>
            </div>            
            <div class="box-body">
            <table align="center">
            <tr>
            <td style="width: 5px;">
                        </td>
            <td style="height: 40px;">
                           Month
                        
                            <select id="select_month" class="form-control" style="width: 200px;" >
                                <option selected disabled value="Select Month">Month</option>
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
                            <td style="width: 5px;">
                        </td>
            <td style="height: 40px;">
                           Year
                        
                            <select id="select_year" class="form-control" style="width: 200px;" >
                                <option selected disabled value="Select Year">Year</option>
                                <option value="2013">2013</option>
                                <option value="2014">2014</option>
                                <option value="2015">2015</option>
                                <option value="2016">2016</option>
                                <option value="2017">2017</option>
                                <option value="2018">2018</option>
                                <option value="2019">2019</option>
                                <option value="2020">2020</option>
                                
                            </select>
                            </td>
                            <td style="width: 5px;">
                        </td>
                        <td style="height: 40px;">

                            <input id="btn_Students" type="button" class="btn btn-primary" name="submit" value="Generate"
                                onclick="btn_Generate_Click();" style="width: 100px;">
                        </td>
                            </tr>
                            </table>

            </div>

            <div class="box-body">
              <%--  <table align="center">
                    <tr>
                        <td>
                            <input id="txt_VehicleNo" type="text" style="height: 28px; opacity: 1.0; width: 180px;"
                                class="form-control" placeholder="Search Vehicle Number" />
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td>
                            <i class="fa fa-search" aria-hidden="true">Search</i>
                        </td>
                    </tr>
                </table>--%>
                <div id="divFillScreen" style="height: 8000px;">
                </div>
            </div>
        </div>
    </section>
</asp:Content>
