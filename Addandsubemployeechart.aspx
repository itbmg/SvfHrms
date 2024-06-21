<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="Addandsubemployeechart.aspx.cs" Inherits="Addandsubemployeechart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
      <script src="Kendo/jquery.min.js" type="text/javascript"></script>
    <script src="Kendo/kendo.all.min.js" type="text/javascript"></script>
    <link href="Kendo/kendo.common.min.css" rel="stylesheet" type="text/css" />
    <link href="Kendo/kendo.default.min.css" rel="stylesheet" type="text/css" />
    <script src="js/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript" src="js/jscharts.js"></script>
<script type="text/javascript">
 $(function () {
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            var hrs = today.getHours();
            var mnts = today.getMinutes();
            $('#ddlmonth').val(mm);
//            $('#year1').val(yyyy);
               var myselect = document.getElementById('year1'), year = new Date().getFullYear();
                var gen = function (max) { do { myselect.add(new Option(year++, max--), null); } while (max > 0); } ();
                        var year = 1980;
                        var min = new Date().getFullYear(),
                        max = min + 9
                        for (i = 0; i < 100; i++) {
                            $("#year1").get(0).options[$("#year1").get(0).options.length] = new Option(year, year);
                            year = year + 1;
                        }
                        $('#year1').val(yyyy);
            get_Branch_details();
        });
         
        function ddlTypeChange() {
//            var type = document.getElementById('slct_type').value;
            var ChartType = document.getElementById('ddlChartType').value;
            if (ChartType == "All Location") {
                $("#bname").css("display", "none");
                $("#Slect_Name").css("display", "none");
                //get_Branch_details();
            }
            if (ChartType == "Location Wise") {
                $("#bname").css("display", "block");
                $("#Slect_Name").css("display", "block");
                get_Branch_details();
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

        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranch(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillbranch(msg) {
            var data = document.getElementById('Slect_Name');
            var length = data.options.length;
            document.getElementById('Slect_Name').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branchname";
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

        function Getemployeedetailsclick() {
            var name = "";
            var tmonth = "";
            var ChartType = document.getElementById('ddlChartType').value;
            if (ChartType == "All Location") {
                name = document.getElementById('Slect_Name').value;

            }

            if (ChartType == "Location Wise") {
                name = document.getElementById('Slect_Name').value;
                if (name == "" || name == "Select name ") {
                    alert("Please Select name ");
                    return false;
                }
            }
            Month = document.getElementById('ddlmonth').value;
            if (Month == "Select Month") {

                alert("Please Select name ");
                return false;

            }
            Year = document.getElementById('year1').value;
            if (Year == "") {
                alert("Please Select name ");
                return false;
            }
            var salarywiseLinechart = "salarywiseLinechart";
            var data = { 'op': 'employee_relieving_joingcount_details',  'Month': Month, 'Year': Year, 'name': name, 'ChartType': ChartType, 'FormName': salarywiseLinechart };
            var s = function (msg) {
                if (msg == "No data Found") {
                    $('#divChart').css('display', 'none');
                }
                else if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        filldetails(msg);
                        Getemployeedetailsbarchart(msg);
                        $('#divChart').css('display', 'block');
                        $('#divHide').css('display', 'block');
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


        var totalemployeein = [];
        var totalemployeeout = [];
        function filldetails(msg) {
            totalemployeein = msg[0].EmployeDetalis;
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;"><th scope="col" ></th><th scope="col" >BRANCH NAME</th><th scope="col">Joining Employes</th><th scope="col">Relieving Employes</th></tr></thead></tbody>';
            for (var i = 0; i < totalemployeein.length; i++) {//<input id="btn_poplate" type="button"  onclick="viewdept_details(this)" name="submit" class="btn btn-primary" value="ViewDept" />
                results += '<tr style="background-color:' + COLOR[l] + '"><td></td>';
                results += '<th style="display:none" scope="row" class="1" style="text-align:center;">' + totalemployeein[i].branchname + '</th>';
                results += '<th scope="row" class="1" style="text-align:center;">' + totalemployeein[i].branchname + '</th>';
                results += '<td data-title="Code" class="2">' + totalemployeein[i].countgen + '</td>';
                results += '<td  class="4">' + totalemployeein[i].countgen1 + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divChart").html(results);
        }


        function Getemployeedetailsbarchart() {
            var name = "";
            var tmonth = "";
            var ChartType = document.getElementById('ddlChartType').value;
            if (ChartType == "All Location") {
                name = document.getElementById('Slect_Name').value;

            }

            if (ChartType == "Location Wise") {
                name = document.getElementById('Slect_Name').value;
                if (name == "" || name == "Select name ") {
                    alert("Please Select name ");
                    return false;
                }
            }
            Month = document.getElementById('ddlmonth').value;
            if (Month == "Select Month") {

                alert("Please Select name ");
                return false;

            }
            Year = document.getElementById('year1').value;
            if (Year == "") {
                alert("Please Select name ");
                return false;
            }
            var salarywiseLinechart = "salarywiseLinechart";
            var data = { 'op': 'employee_relieving_joingcount_barChartValues', 'Month': Month, 'Year': Year, 'name': name, 'ChartType': ChartType, 'FormName': salarywiseLinechart };
            var s = function (msg) {
                if (msg == "No data Found") {
                    $('#graph').css('display', 'none');
                }
                else if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        createbarChart(msg);
                        $('#graph').css('display', 'block');
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

    var datainXSeries = 0;
        var datainYSeries = 0;
        var newXarray = [];
        var newYarray = [];
        function createbarChart(databind) {
          var  xbranchname = databind[0].branchname;
         var   xcountgen = databind[0].countgen;
         var   xcountgen1 = databind[0].countgen1;
//            var xbranchname = new Array(['Asia'], ['name']);
//            var xcountgen = new Array(['10'], ['20']);
//            var xcountgen1 = new Array(['5'], ['10']);
            var newYarray = [];
            var newXarray = [];
            var myData = [];
            if (databind.length > 0) {
                for (var k = 0; k < databind.length; k++) {
                    var BranchName = [];
                    xbranchname = databind[0].branchname;
                    xcountgen = databind[0].countgen;
                    xcountgen1 = databind[0].countgen1;
//                    var branchname = databind[k].xbranchname;
//                    var countgen = databind[k].xcountgen;
//                    var countgen1 = databind[k].xcountgen1;
                    //                    newXarray = xbranchname.split(',');


                    for (var i = 0; i < xbranchname.length; i++) {

                        myData.push([xbranchname[i].toString(), parseInt(xcountgen[i]), parseInt(xcountgen1[i])]);
//                        var myData = new Array(xbranchname[i], xcountgen[i], xcountgen1[i]);
                    }
                }
                                    }

//var myData = new Array(['Asia', 47, 520], ['Europe', 322, 390], ['North America', 233, 286], ['Latin America', 110, 162], ['Africa', 34, 49], ['Middle East', 20, 31], ['Aus/Oceania', 19, 22]);
            var myChart = new JSChart('graph', 'bar');
            myChart.setDataArray(myData);
            myChart.setTitle('Employee Joining and Reliveing Count');
            myChart.setTitleColor('#8E8E8E');
            myChart.setAxisNameX('');
            myChart.setAxisNameY('');
            myChart.setAxisNameFontSize(16);
            myChart.setAxisNameColor('#999');
            myChart.setAxisValuesAngle(30);
            myChart.setAxisValuesColor('#777');
            myChart.setAxisColor('#B5B5B5');
            myChart.setAxisWidth(1);
            myChart.setBarValuesColor('#2F6D99');
            myChart.setAxisPaddingTop(60);
            myChart.setAxisPaddingBottom(60);
            myChart.setAxisPaddingLeft(45);
            myChart.setTitleFontSize(11);
            myChart.setBarColor('#2D6B96', 1);
            myChart.setBarColor('#9CCEF0', 2);
            myChart.setBarBorderWidth(0);
            myChart.setBarSpacingRatio(50);
            myChart.setBarOpacity(0.9);
            myChart.setFlagRadius(6);
//            myChart.setTooltip(['North America', 'Click me', 1], callback);
//            myChart.setTooltipPosition('nw');
//            myChart.setTooltipOffset(3);
            myChart.setLegendShow(true);
            myChart.setLegendPosition('right top');
            myChart.setLegendForBar(1, 'Joiningcount');
            myChart.setLegendForBar(2, 'Relievingcount');
            myChart.setSize(616, 321);
            myChart.setGridColor('#C6C6C6');
            myChart.draw();

        
//            var textname = "Employee Joining and Reliveing Count";
//            $("#divChart").kendoChart({
//                title: {
//                   
//                    text: textname,
//                    color: "#006600",
//                    font: "bold italic 18px Arial,Helvetica,sans-serif"
//                },
//                legend: {
//                    position: "bottom"
//                },
//                chartArea: {
//                    background: ""
//                },
//                seriesDefaults: {
//                    type: "bar",
//                    style: "smooth"
//                },
//                series: newYarray,
//                valueAxis: {
//                    labels: {
//                        format: "{0}"
//                    },
//                    line: {
//                        visible: false
//                    },
//                    axisCrossingValue: -10
//                },
//                categoryAxis: {
//                    categories: newXarray,
//                    //                        categories: [2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011],
//                    majorGridLines: {
//                        visible: false
//                    },
//                    labels: {
//                        rotation: 65
//                    }
//                },
//                tooltip: {
//                    visible: true,
//                    format: "{0}%",
//                    template: "#= series.name #: #= value #"
//                }
//            });
        }
         


    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Pie Chart<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-pie-chart"></i>Chart Reports</a></li>
            <li><a href="#">Pie Chart</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Totaly Employee Joining&Relieving Details
                </h3>
            </div>
            <div class="box-body">
                <div style="width: 100%;" align="center">
                    <table>
                        <tr>
                            <td>
                                <span>Chart Type</span>
                            </td>
                            <td >
                                <select id="ddlChartType" class="form-control" onchange="ddlTypeChange(this);">
                                    <option>Select Type</option>
                                     <option>All Location</option>
                                    <option>Location Wise</option>
                                </select>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <span id="bname">Branch Name</span>
                            </td>
                            <td>
                                <select id="Slect_Name" class="form-control">
                                </select>
                            </td>
                           <td>
                             <label>
                             Month
                             </label>
                             <select  id="ddlmonth">
                                 <option value="00">Select Month</option>
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
                            <td style="width: 6px;">
                            </td>
                            <td style="width: 90px; height: 50px;">
                                <span> Year</span>
                              <select  id="year1"></select>
                            </td>
                            <td>
                                <input type="button" id="submit" value="Generate" class="btn btn-primary" onclick="Getemployeedetailsclick()" />
                            </td>
                        </tr>
                    </table>
                </div>
                <table>
                <tr>
                <td>
                 <div id="divChart" style="height: 500px;float:left">
                </div></td><td>
                 <div id="graph" style="height: 500px;float:right"></div></td></tr></table>
               
              
            </div>
    
    
        </div>
    </section>
</asp:Content>

