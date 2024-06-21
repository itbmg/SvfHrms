using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class Arrearreport : System.Web.UI.Page
{
    SqlCommand cmd;
    string userid = "";
    DBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["userid"] == null)
            Response.Redirect("Login.aspx");
        else
        {
            userid = Session["userid"].ToString();
            vdm = new DBManager();
            if (!Page.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    DateTime dtfrom = DateTime.Now.AddMonths(-1);
                    DateTime dtfrom1 = DateTime.Now.AddMonths(-2);
                    //dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    //dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    bindbranchs();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string frmdate1 = dtfrom1.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    string[] str1 = frmdate1.Split('/');
                    ddlmonth.SelectedValue = str[1];
                    ddlmonth1.SelectedValue = str1[1];
                }
            }
        }
    }

    private DateTime GetLowDate(DateTime dt)
    {
        double Hour, Min, Sec;
        DateTime DT = DateTime.Now;
        DT = dt;
        Hour = -dt.Hour;
        Min = -dt.Minute;
        Sec = -dt.Second;
        DT = DT.AddHours(Hour);
        DT = DT.AddMinutes(Min);
        DT = DT.AddSeconds(Sec);
        return DT;
    }

    private DateTime GetHighDate(DateTime dt)
    {
        double Hour, Min, Sec;
        DateTime DT = DateTime.Now;
        Hour = 23 - dt.Hour;
        Min = 59 - dt.Minute;
        Sec = 59 - dt.Second;
        DT = dt;
        DT = DT.AddHours(Hour);
        DT = DT.AddMinutes(Min);
        DT = DT.AddSeconds(Sec);
        return DT;
    }

    private void bindbranchs()
    {
        DBManager SalesDB = new DBManager();
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
        cmd.Parameters.Add("@m", mainbranch); 
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlbranch.DataSource = dttrips;
        ddlbranch.DataTextField = "branchname";
        ddlbranch.DataValueField = "branchid";
        ddlbranch.DataBind();
        ddlbranch.ClearSelection();
        ddlbranch.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        ddlbranch.SelectedValue = "0";
    }

    DataTable Report = new DataTable();
    protected void grdReports_RowCreated(object sender, GridViewRowEventArgs dtpfdate)
    {
        if (dtpfdate.Row.RowType == DataControlRowType.Header)
        {
            GridViewRow HeaderRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);
            TableCell HeaderCell = new TableCell();
            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.ColumnSpan = 4;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "To be paid in current month payroll";
            HeaderCell.ColumnSpan = 6;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderRow.Cells.Add(HeaderCell);
            //HeaderCell = new TableCell();
            //HeaderCell.Text = "Previous Month PF Calculation";
            //HeaderCell.ColumnSpan = 4;
            //HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            //HeaderRow.Cells.Add(HeaderCell);

            //HeaderCell = new TableCell();
            //HeaderCell.Text = "Difference";
            //HeaderCell.ColumnSpan = 4;
            //HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            //HeaderRow.Cells.Add(HeaderCell);

            //HeaderCell = new TableCell();
            //HeaderCell.Text = "RECHILLING PM SECTION";
            //HeaderCell.ColumnSpan = 4;
            //HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            //HeaderRow.Cells.Add(HeaderCell);
            grdReports.Controls[0].Controls.AddAt(0, HeaderRow);
        }
    }


    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            string year = (mydate.Year).ToString();
            string mymonth = ddlmonth.SelectedItem.Value;
            string day = "";
            if (mymonth == "02")
            {
                day = "28";
            }
            else
            {
                day = (mydate.Day).ToString();
            }
            string d = "00";
            string date = mymonth + "/" + day + "/" + year;
            lblHeading.Text = ddlbranch.SelectedItem.Text + " Arrear Report " + " " + ddlmonth.SelectedItem.Text + year + " To " + " " + ddlmonth1.SelectedItem.Text + " " + year;
            //string[] datestrig = dtp_FromDate.Text.Split(' ');
            //if (datestrig.Length > 1)
            //{
            //    if (datestrig[0].Split('-').Length > 0)
            //    {
            //        string[] dates = datestrig[0].Split('-');
            //        string[] times = datestrig[1].Split(':');
            //        fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
            //    }
            //}
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth;
            fromdate = Convert.ToDateTime(date);

            DateTime fromdate1 = DateTime.Now;
            DateTime mydate1 = DateTime.Now;
            string year1 = (mydate.Year).ToString();
            string mymonth1 = ddlmonth1.SelectedItem.Value;
            string day1 = (mydate.Day).ToString();
            string d1 = "00";
            string date1 = mymonth1 + "/" + day1 + "/" + year1;
            DateTime dtfrom1 = fromdate1;
            string frmdate1 = dtfrom1.ToString("dd/MM/yyyy");
            string[] str1 = frmdate1.Split('/');
            lblFromDate1.Text = mymonth1;
            fromdate1 = Convert.ToDateTime(date1);
            Session["filename"] = ddlbranch.SelectedItem.Text + " Arrear Report " + " " + ddlmonth.SelectedItem.Text + year + " " + "To" + " " + ddlmonth1.SelectedItem.Text + " " + year1;
            Session["title"] = ddlbranch.SelectedItem.Text + " Arrear  Report " + " " + ddlmonth.SelectedItem.Text + year + " " + "To" + " " + ddlmonth1.SelectedItem.Text + " " + year1;
            Report.Columns.Add("SNO");
            //Report.Columns.Add("Employeeid");
            Report.Columns.Add("Pay Item");
            Report.Columns.Add("To be Paid");
            Report.Columns.Add("Paid Till Date");
            Report.Columns.Add("Current Value");
            Report.Columns.Add("Arrear Value").DataType = typeof(double);
            Report.Columns.Add("Total" + mymonth).DataType = typeof(double);
            //int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
            //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, branchmaster.fromdate, branchmaster.todate, employedetails.empid, employedetails.employee_num,pay_structure.providentfund, monthly_attendance.clorwo, monthly_attendance.otdays, pay_structure.erningbasic, pay_structure.esi, employedetails.fullname, monthly_attendance.month, monthly_attendance.lop, monthly_attendance.numberofworkingdays, monthly_attendance.year, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employepfdetails.pfnumber FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.pfeligible = 'Yes')");
            ////cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employedetails.empid, employedetails.employee_num, pay_structure.providentfund, pay_structure.erningbasic, pay_structure.esi, employedetails.fullname, monthly_attendance.month, monthly_attendance.year, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employepfdetails.pfnumber FROM  employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.pfeligible = 'Yes') AND (employedetails.employee_type = 'Staff')");
            //cmd.Parameters.Add("@branchid", branchid);
            //cmd.Parameters.Add("@month", mymonth);
            //cmd.Parameters.Add("@year", str[2]);
            //DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
            //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, branchmaster.fromdate, branchmaster.todate, employedetails.empid, employedetails.employee_num, pay_structure.providentfund, monthly_attendance.clorwo, monthly_attendance.otdays, pay_structure.erningbasic, pay_structure.esi, employedetails.fullname, monthly_attendance.month, monthly_attendance.lop, monthly_attendance.numberofworkingdays, monthly_attendance.year, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning,pay_structure.profitionaltax, employebankdetails.accountno, employepfdetails.pfnumber FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.pfeligible = 'Yes')");
            //cmd.Parameters.Add("@branchid", branchid);
            //cmd.Parameters.Add("@month", mymonth1);
            //cmd.Parameters.Add("@year", str[2]);
            //DataTable dtsalary1 = vdm.SelectQuery(cmd).Tables[0];
            //if (dtsalary.Rows.Count > 0)
            //{
            //    var i = 1;
            //    foreach (DataRow dr in dtsalary.Rows)
            //    {
            //        double totalpresentdays = 0;
            //        double profitionaltax = 0;
            //        double salaryadvance = 0;
            //        double loan = 0;
            //        double canteendeduction = 0;
            //        double mobilededuction = 0;
            //        double totaldeduction;
            //        double totalearnings;
            //        double otherdeduction = 0;
            //        double medicliamdeduction = 0;
            //        double prevprovidentfund = 0;
            //        double presntprovidentfund = 0;
            //        double medicalerning = 0;
            //        double washingallowance = 0;
            //        double convenyance = 0;
            //        double esi = 0;
            //        int daysinmonth = 0;
            //        double loseamount = 0;
            //        double loseofconviyance = 0;
            //        double loseofwashing = 0;
            //        double loseofmedical = 0;
            //        //foreach (DataRow dra in dtsalary.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
            //        //{
            //        DataRow newrow = Report.NewRow();
            //        newrow["SNO"] = i++.ToString();
            //        //newrow["Employeeid"] = dr["empid"].ToString();
            //        newrow["Employee Code"] = dr["employee_num"].ToString();
            //        newrow["Name"] = dr["fullname"].ToString();
            //        newrow["PF No."] = dr["pfnumber"].ToString();
            //        double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
            //        //newrow["GROSS"] = peryanam / 12;
            //        double permonth = peryanam / 12;
            //        double HRA = Convert.ToDouble(dr["hra"].ToString());
            //        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
            //        convenyance = Convert.ToDouble(dr["conveyance"].ToString());
            //        //newrow["PT"] = dr["profitionaltax"].ToString();
            //        profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
            //        medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
            //        washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
            //        string from = dr["fromdate"].ToString();
            //        string to = dr["todate"].ToString();
            //        int month = 0;
            //        int.TryParse(mymonth, out month);
            //        month = month - 1;
            //        string strfromdate = month + "/" + from + "/" + str[2];
            //        string strtodate = mymonth + "/" + to + "/" + str[2];
            //        DateTime dtfromdate = Convert.ToDateTime(strfromdate);
            //        DateTime dttodate = Convert.ToDateTime(strtodate);
            //        TimeSpan days;
            //        days = dttodate - dtfromdate;
            //        daysinmonth = Convert.ToInt32(days.TotalDays);
            //        //newrow["DAYS MONTH"] = daysinmonth.ToString();
            //        double numberofworkingdays = 0;
            //        double.TryParse(dr["numberofworkingdays"].ToString(), out numberofworkingdays);
            //        double paydays = 0;
            //        double lop = 0;
            //        double.TryParse(dr["lop"].ToString(), out lop);
            //        paydays = numberofworkingdays - lop;
            //        //newrow["Attendance Days"] = paydays.ToString();
            //        double holidays = 0;
            //        holidays = daysinmonth - numberofworkingdays;
            //        double clorwo = 0;
            //        double.TryParse(dr["clorwo"].ToString(), out clorwo);
            //        //newrow["Payable Days"] = paydays + clorwo;
            //        //newrow["CL HOLIDAY AND OFF"] = clorwo;
            //        totalpresentdays = holidays + paydays;
            //        double totalpdays = permonth / daysinmonth;
            //        loseamount = lop * totalpdays;
            //        double perdayconveyance = convenyance / daysinmonth;
            //        loseofconviyance = lop * perdayconveyance;
            //        double perdaywashing = washingallowance / daysinmonth;
            //        loseofwashing = lop * perdaywashing;
            //        double perdaymedical = medicalerning / daysinmonth;
            //        loseofmedical = lop * perdaymedical;
            //        double perdaybasic = BASIC / daysinmonth;
            //        double perdaysal = permonth / daysinmonth;
            //        double basic = 50;
            //        double basicsalary = (permonth * 50) / 100;
            //        double basicpermonth = basicsalary / daysinmonth;
            //        double bs = basicpermonth * totalpresentdays;
            //        newrow["PF BASIC " + mymonth] = Math.Round(bs, 0);
            //        double basicsal = Math.Round(basicsalary - loseamount);
            //        double conve = Math.Round(convenyance - loseofconviyance);
            //        double medical = Math.Round(medicalerning - loseofmedical);
            //        double washing = Math.Round(washingallowance - loseofwashing);
            //        double tt = bs + conve + medical + washing;
            //        double thra = permonth - loseamount;
            //        double hra = Math.Round(thra - tt);
            //        totalearnings = Math.Round(hra + tt);
            //        double employerPF = 0;
            //        // newrow["HRA"] = hra;
            //        //newrow["GROSS Earnings"] = totalearnings;
            //        string pfeligible = dr["pfeligible"].ToString();
            //        if (pfeligible == "Yes")
            //        {
            //            prevprovidentfund = (totalearnings * 6) / 100;
            //            //if (providentfund > 1800)
            //            //{
            //            //    providentfund = 1800;
            //            //}
            //            prevprovidentfund = Math.Round(prevprovidentfund);
            //            newrow["PF" + mymonth] = prevprovidentfund;
            //            double eps = 0;
            //            eps = (bs * 8.33) / 100;
            //            newrow["EPS" + mymonth] = Math.Round(eps, 0);

            //            employerPF = (bs * 3.67) / 100;
            //            newrow["Employer PF" + mymonth] = Math.Round(employerPF, 0);
            //        }
            //        else
            //        {
            //            prevprovidentfund = 0;
            //            newrow["PF" + mymonth] = prevprovidentfund;
            //        }


            //        string esieligible = dr["esieligible"].ToString();
            //        if (esieligible == "Yes")
            //        {
            //            esi = (totalearnings * 1.75) / 100;
            //            esi = Math.Ceiling(esi);
            //            //newrow["ESI"] = esi;
            //        }
            //        else
            //        {
            //            esi = 0;
            //            //newrow["ESI"] = esi;
            //        }
            //        foreach (DataRow dra in dtsalary1.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
            //        {
            //            totaldeduction = Math.Round(prevprovidentfund + esi);
            //            //int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
            //            //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
            //            ////cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
            //            //cmd.Parameters.Add("@month", mymonth1);
            //            //cmd.Parameters.Add("@year", str[2]);
            //            //cmd.Parameters.Add("@branchid", branchid);
            //            //DataTable dtattendence1 = vdm.SelectQuery(cmd).Tables[0];
            //            //  if (dtsalary1.Rows.Count > 0)
            //            //{

            //            ////foreach (DataRow dr in dtsalary1.Rows)
            //            ////{
            //            //DataRow newrow = Report.NewRow();
            //            //double totalpresentdays = 0;
            //            //double profitionaltax = 0;
            //            //double salaryadvance = 0;
            //            //double loan = 0;
            //            //double canteendeduction = 0;
            //            //double mobilededuction = 0;
            //            //double totaldeduction;
            //            //double totalearnings;
            //            //double otherdeduction = 0;
            //            //double medicliamdeduction = 0;
            //            //double providentfund = 0;
            //            //double medicalerning = 0;
            //            //double washingallowance = 0;
            //            //double convenyance = 0;
            //            //double esi = 0;
            //            //int daysinmonth = 0;
            //            //double loseamount = 0;
            //            //double loseofconviyance = 0;
            //            //double loseofwashing = 0;
            //            //double loseofmedical = 0;
            //            //double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
            //            ////newrow["GROSS"] = peryanam / 12;
            //            //double permonth = peryanam / 12;
            //            //double HRA = Convert.ToDouble(dr["hra"].ToString());
            //            //double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
            //            //convenyance = Convert.ToDouble(dr["conveyance"].ToString());
            //            //newrow["PT"] = dr["profitionaltax"].ToString();
            //            profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
            //            medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
            //            washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
            //            //newrow["Bank Acc NO"] = dr["accountno"].ToString();
            //            //Report.Rows.Add(newrow);
            //            //if (dtattendence1.Rows.Count > 0)
            //            //{
            //            //    foreach (DataRow dra in dtattendence1.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
            //            //    {
            //            string from1 = dr["fromdate"].ToString();
            //            string to1 = dr["todate"].ToString();
            //            int month1 = 0;
            //            int.TryParse(mymonth1, out month);
            //            month = month - 1;
            //            string strfromdate1 = month + "/" + from1 + "/" + str[2];
            //            string strtodate1 = mymonth1 + "/" + to1 + "/" + str[2];
            //            DateTime dtfromdate1 = Convert.ToDateTime(strfromdate1);
            //            DateTime dttodate1 = Convert.ToDateTime(strtodate1);
            //            TimeSpan day1s;
            //            day1s = dttodate1 - dtfromdate1;
            //            daysinmonth = Convert.ToInt32(day1s.TotalDays);
            //            //newrow["DAYS MONTH"] = daysinmonth.ToString();
            //            double numberofworkingdays1 = 0;
            //            double.TryParse(dr["numberofworkingdays"].ToString(), out numberofworkingdays1);
            //            double paydays1 = 0;
            //            double lop1 = 0;
            //            double.TryParse(dr["lop"].ToString(), out lop1);
            //            paydays1 = numberofworkingdays - lop;
            //            //newrow["Attendance Days"] = paydays.ToString();
            //            double holidays1 = 0;
            //            holidays1 = daysinmonth - numberofworkingdays1;
            //            double clorwo1 = 0;
            //            double.TryParse(dr["clorwo"].ToString(), out clorwo1);
            //            //newrow["Payable Days"] = paydays + clorwo;
            //            //newrow["CL HOLIDAY AND OFF"] = clorwo;
            //            totalpresentdays = holidays + paydays;
            //            double totalpdays1 = permonth / daysinmonth;
            //            loseamount = lop * totalpdays1;
            //            double perdayconveyance1 = convenyance / daysinmonth;
            //            loseofconviyance = lop * perdayconveyance1;
            //            double perdaywashing1 = washingallowance / daysinmonth;
            //            loseofwashing = lop * perdaywashing1;
            //            double perdaymedical1 = medicalerning / daysinmonth;
            //            loseofmedical = lop * perdaymedical1;
            //            double perdaybasic1 = BASIC / daysinmonth;
            //            //    }
            //            //}
            //            double perdaysal1 = permonth / daysinmonth;
            //            double basic1 = 50;
            //            double basicsalary1 = (permonth * 50) / 100;
            //            double basicpermonth1 = basicsalary1 / daysinmonth;
            //            double bs1 = basicpermonth1 * totalpresentdays;
            //            newrow["PF BASIC " + mymonth1] = Math.Round(bs1, 0);
            //            //newrow["CONVEYANCE ALLOWANCE"] = Math.Round(convenyance - loseofconviyance);
            //            //newrow["MEDICAL ALLOWANCE"] = Math.Round(medicalerning - loseofmedical);
            //            //newrow["WASHING ALLOWANCE"] = Math.Round(washingallowance - loseofwashing);
            //            double basicsal1 = Math.Round(basicsalary1 - loseamount);
            //            double conve1 = Math.Round(convenyance - loseofconviyance);
            //            double medical1 = Math.Round(medicalerning - loseofmedical);
            //            double washing1 = Math.Round(washingallowance - loseofwashing);
            //            double tt1 = bs1 + conve1 + medical1 + washing1;
            //            double thra1 = permonth - loseamount;
            //            double hra1 = Math.Round(thra1 - tt1);
            //            totalearnings = Math.Round(hra1 + tt1);
            //            // newrow["HRA"] = hra;
            //            //newrow["GROSS Earnings"] = totalearnings;
            //            //string pfeligible = dr["pfeligible"].ToString();
            //            if (pfeligible == "Yes")
            //            {
            //                presntprovidentfund = (totalearnings * 6) / 100;
            //                //if (providentfund > 1800)
            //                //{
            //                //    providentfund = 1800;
            //                //}
            //                presntprovidentfund = Math.Round(presntprovidentfund, 0);
            //                newrow["PF" + mymonth1] = Math.Round(presntprovidentfund, 0);
            //                double eps = 0;
            //                eps = (bs1 * 8.33) / 100;
            //                newrow["EPS" + mymonth1] = Math.Round(eps, 0);
            //                //double employerPF = 0;
            //                employerPF = (bs1 * 3.67) / 100;
            //                newrow["Employer PF" + mymonth1] = Math.Round(employerPF, 0);
            //            }
            //            else
            //            {
            //                presntprovidentfund = 0;
            //                newrow["PF" + mymonth1] = Math.Round(presntprovidentfund, 0);
            //            }
            //            //string esieligible = dr["esieligible"].ToString();
            //            //if (esieligible == "Yes")
            //            //{
            //            //    esi = (totalearnings * 1.75) / 100;
            //            //    esi = Math.Ceiling(esi);
            //            //    //newrow["ESI"] = esi;
            //            //}
            //            //else
            //            //{
            //            //    esi = 0;
            //            //    //newrow["ESI"] = esi;
            //            //}
            //            //double extrapayout = 0;
            //            //double employeepfmonth1;
            //            //double employeepfmonth2;
            //            //double amount = 0;
            //            //double.TryParse(mymonth, out amount);
            //            ////double mymonth = Convert.ToInt32(days.TotalDays);
            //            //employeepfmonth1 = employerPF + (amount);

            //            //double amount1 = 0;
            //            //double.TryParse(mymonth1, out amount1);
            //            ////double mymonth = Convert.ToInt32(days.TotalDays);
            //            //employeepfmonth2 = (employerPF + (amount1));
            //            //extrapayout = employeepfmonth1 - employeepfmonth2;
            //            double extrapayout = 0;
            //            extrapayout = presntprovidentfund - prevprovidentfund;
            //            newrow["Extra Deduction for the employee"] = Math.Round(extrapayout, 0);
            //            newrow["Extra Payout for the Employer"] = Math.Round(extrapayout, 0);
                    //    Report.Rows.Add(newrow);
                    //}
                //}
            //}
            // }
            //}
            DataRow newTotal = Report.NewRow();
            newTotal["Pay Item"] = "Total";
            double val = 0.0;
            foreach (DataColumn dc in Report.Columns)
            {
                if (dc.DataType == typeof(Double))
                {
                    val = 0.0;
                    double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out val);
                    newTotal[dc.ToString()] = val;
                }
            }
            Report.Rows.Add(newTotal);
            grdReports.DataSource = Report;
            if (Report.Rows.Count > 2)
            {
                grdReports.DataBind();
                Session["xportdata"] = Report;
                hidepanel.Visible = true;
            }
            else
            {
                hidepanel.Visible = false;
                lblmsg.Text = "No Data Found";
            }
        }
        catch
        {
        }

    }

    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (e.Row.Cells[2].Text == "Total")
            {
                e.Row.BackColor = System.Drawing.Color.Aquamarine;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
            //if (e.Row.Cells[3].Text == "Grand Total")
            //{
            //    e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
            //    e.Row.Font.Size = FontUnit.Large;
            //    e.Row.Font.Bold = true;
            //}
        }
    }
}