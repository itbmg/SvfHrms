using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class PFWagelimitincreaseReport : System.Web.UI.Page
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
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    bindbranchs();
                    PopulateYear();
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
    private void PopulateYear()
    {

        ddlyear.Items.Clear();
        ListItem lt = new ListItem();
        lt.Text = "YYYY";
        lt.Value = "0";
        ddlyear.Items.Add(lt);
        for (int i = DateTime.Now.Year; i >= 1970; i--)
        {
            lt = new ListItem();
            lt.Text = i.ToString();
            lt.Value = i.ToString();
            ddlyear.Items.Add(lt);
        }
        ddlyear.Items.FindByValue(DateTime.Now.Year.ToString()).Selected = true;
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
            HeaderCell.Text = "Current Month PF Calculation";
            HeaderCell.ColumnSpan = 6;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderRow.Cells.Add(HeaderCell);
            HeaderCell = new TableCell();
            HeaderCell.Text = "Previous Month PF Calculation";
            HeaderCell.ColumnSpan = 4;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "Difference";
            HeaderCell.ColumnSpan = 4;
            HeaderCell.HorizontalAlign = HorizontalAlign.Center;
            HeaderRow.Cells.Add(HeaderCell);
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
            string mymonth = ddlmonth.SelectedItem.Value;
            string myyear = ddlyear.SelectedItem.Value;
            string day = (mydate.Day).ToString();
            string d = "00";
            string date = mymonth + "/" + day + "/" + myyear;
            lblHeading.Text = ddlbranch.SelectedItem.Text + " PF Wage limitincrease Report" + " " + ddlmonth.SelectedItem.Text + myyear;
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

            Session["filename"] = ddlbranch.SelectedItem.Text + " PF Wagelimitincrease  Report" + " " + ddlmonth.SelectedItem.Text + myyear;
            Session["title"] = ddlbranch.SelectedItem.Text + " PF Wagelimitincrease  Report " + " " + ddlmonth.SelectedItem.Text + myyear;
            Report.Columns.Add("SNO");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            Report.Columns.Add("PF No.");
            Report.Columns.Add("PF BASIC " + mymonth);
            Report.Columns.Add("PF" + mymonth).DataType = typeof(double);
            Report.Columns.Add("Employer PF" + mymonth).DataType = typeof(double);
            Report.Columns.Add("EPS" + mymonth).DataType = typeof(double);
            Report.Columns.Add("PF BASIC "+ mymonth1);
            Report.Columns.Add("PF" + mymonth1).DataType = typeof(double);
            Report.Columns.Add("Employer PF" + mymonth1).DataType = typeof(double);
            Report.Columns.Add("EPS" + mymonth1).DataType = typeof(double);
            Report.Columns.Add("Extra Deduction for the employee").DataType = typeof(double);
            Report.Columns.Add("Extra Payout for the Employer").DataType = typeof(double);
            int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
            cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, branchmaster.fromdate, branchmaster.todate, employedetails.empid, employedetails.employee_num,pay_structure.providentfund, monthly_attendance.clorwo, monthly_attendance.otdays, pay_structure.erningbasic, pay_structure.esi, employedetails.fullname, monthly_attendance.month, monthly_attendance.lop, monthly_attendance.numberofworkingdays, monthly_attendance.year, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employepfdetails.pfnumber FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.pfeligible = 'Yes')");
            //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employedetails.empid, employedetails.employee_num, pay_structure.providentfund, pay_structure.erningbasic, pay_structure.esi, employedetails.fullname, monthly_attendance.month, monthly_attendance.year, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employepfdetails.pfnumber FROM  employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.pfeligible = 'Yes') AND (employedetails.employee_type = 'Staff')");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@month", mymonth);
            cmd.Parameters.Add("@year", myyear);
            DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, branchmaster.fromdate, branchmaster.todate, employedetails.empid, employedetails.employee_num, pay_structure.providentfund, monthly_attendance.clorwo, monthly_attendance.otdays, pay_structure.erningbasic, pay_structure.esi, employedetails.fullname, monthly_attendance.month, monthly_attendance.lop, monthly_attendance.numberofworkingdays, monthly_attendance.year, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning,pay_structure.profitionaltax, employebankdetails.accountno, employepfdetails.pfnumber FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.pfeligible = 'Yes')");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@month", mymonth1);
            cmd.Parameters.Add("@year", myyear);
            DataTable dtsalary1 = vdm.SelectQuery(cmd).Tables[0];
            if (dtsalary.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtsalary.Rows)
                {
                    double totalpresentdays = 0;
                    double profitionaltax = 0;
                    double salaryadvance = 0;
                    double loan = 0;
                    double canteendeduction = 0;
                    double mobilededuction = 0;
                    double totaldeduction;
                    double totalearnings;
                    double otherdeduction = 0;
                    double medicliamdeduction = 0;
                    double prevprovidentfund = 0;
                    double presntprovidentfund = 0;
                    double medicalerning = 0;
                    double washingallowance = 0;
                    double convenyance = 0;
                    double esi = 0;
                    double daysinmonth = 0;
                    double loseamount = 0;
                    double loseofconviyance = 0;
                    double loseofwashing = 0;
                    double loseofmedical = 0;
                    DataRow newrow = Report.NewRow();
                    newrow["SNO"] = i++.ToString();
                    //newrow["Employeeid"] = dr["empid"].ToString();
                    newrow["Employee Code"] = dr["employee_num"].ToString();
                    newrow["Name"] = dr["fullname"].ToString();
                    newrow["PF No."] = dr["pfnumber"].ToString();
                    double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                    //newrow["GROSS"] = peryanam / 12;
                    double permonth = peryanam / 12;
                    double HRA = Convert.ToDouble(dr["hra"].ToString());
                    double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                    convenyance = Convert.ToDouble(dr["conveyance"].ToString());
                    //newrow["PT"] = dr["profitionaltax"].ToString();
                    profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                    medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
                    washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
                    double numberofworkingdays = 0;
                    double.TryParse(dr["numberofworkingdays"].ToString(), out numberofworkingdays);
                    double clorwo = 0;
                    double.TryParse(dr["clorwo"].ToString(), out clorwo);
                    daysinmonth = numberofworkingdays + clorwo;
                    double paydays = 0;
                    double lop = 0;
                    double.TryParse(dr["lop"].ToString(), out lop);
                    paydays = numberofworkingdays - lop;
                    double holidays = 0;
                    holidays = daysinmonth - numberofworkingdays;
                    totalpresentdays = holidays + paydays;
                    double totalpdays = permonth / daysinmonth;
                    loseamount = lop * totalpdays;
                    double perdayconveyance = convenyance / daysinmonth;
                    loseofconviyance = lop * perdayconveyance;
                    double perdaywashing = washingallowance / daysinmonth;
                    loseofwashing = lop * perdaywashing;
                    double perdaymedical = medicalerning / daysinmonth;
                    loseofmedical = lop * perdaymedical;
                    double perdaybasic = BASIC / daysinmonth;
                    double perdaysal = permonth / daysinmonth;
                    double basic = 50;
                    double basicsalary = (permonth * 50) / 100;
                    double basicpermonth = basicsalary / daysinmonth;
                    double bs = basicpermonth * totalpresentdays;
                    newrow["PF BASIC " + mymonth] = Math.Round(bs,0);
                    double basicsal = Math.Round(basicsalary - loseamount);
                    double conve = Math.Round(convenyance - loseofconviyance);
                    double medical = Math.Round(medicalerning - loseofmedical);
                    double washing = Math.Round(washingallowance - loseofwashing);
                    double tt = bs + conve + medical + washing;
                    double thra = permonth - loseamount;
                    double hra = Math.Round(thra - tt);
                    totalearnings = Math.Round(hra + tt);
                    double employerPF = 0;
                    string pfeligible = dr["pfeligible"].ToString();
                    if (pfeligible == "Yes")
                    {
                        prevprovidentfund = (totalearnings * 6) / 100;
                        prevprovidentfund = Math.Round(prevprovidentfund);
                        newrow["PF" + mymonth] = prevprovidentfund;
                        double eps = 0;
                        eps = (bs * 8.33) / 100;
                        newrow["EPS" + mymonth] = Math.Round(eps, 0);

                        employerPF = (bs * 3.67) / 100;
                        newrow["Employer PF" + mymonth] = Math.Round(employerPF, 0);
                    }
                    else
                    {
                        prevprovidentfund = 0;
                        newrow["PF" + mymonth] = prevprovidentfund;
                    }
                 

                    string esieligible = dr["esieligible"].ToString();
                    if (esieligible == "Yes")
                    {
                        esi = (totalearnings * 1.75) / 100;
                        esi = Math.Ceiling(esi);
                        //newrow["ESI"] = esi;
                    }
                    else
                    {
                        esi = 0;
                        //newrow["ESI"] = esi;
                    }
                    foreach (DataRow dra in dtsalary1.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                    {
                        totaldeduction = Math.Round(prevprovidentfund + esi);
                        profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                        medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
                        washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
                        double numberofworkingdays1 = 0;
                        double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays1);
                        double clorwo1 = 0;
                        double.TryParse(dra["clorwo"].ToString(), out clorwo1);
                        daysinmonth = numberofworkingdays + clorwo;
                        double paydays1 = 0;
                        double lop1 = 0;
                        double.TryParse(dr["lop"].ToString(), out lop1);
                        paydays1 = numberofworkingdays - lop;
                        double holidays1 = 0;
                        holidays1 = daysinmonth - numberofworkingdays1;
                        totalpresentdays = holidays + paydays;
                        double totalpdays1 = permonth / daysinmonth;
                        loseamount = lop * totalpdays1;
                        double perdayconveyance1 = convenyance / daysinmonth;
                        loseofconviyance = lop * perdayconveyance1;
                        double perdaywashing1 = washingallowance / daysinmonth;
                        loseofwashing = lop * perdaywashing1;
                        double perdaymedical1 = medicalerning / daysinmonth;
                        loseofmedical = lop * perdaymedical1;
                        double perdaybasic1 = BASIC / daysinmonth;
                        double perdaysal1 = permonth / daysinmonth;
                        double basic1 = 50;
                        double basicsalary1 = (permonth * 50) / 100;
                        double basicpermonth1 = basicsalary1 / daysinmonth;
                        double bs1 = basicpermonth1 * totalpresentdays;
                        newrow["PF BASIC " + mymonth1] = Math.Round(bs1,0);
                        double basicsal1 = Math.Round(basicsalary1 - loseamount);
                        double conve1 = Math.Round(convenyance - loseofconviyance);
                        double medical1 = Math.Round(medicalerning - loseofmedical);
                        double washing1 = Math.Round(washingallowance - loseofwashing);
                        double tt1 = bs1 + conve1 + medical1 + washing1;
                        double thra1 = permonth - loseamount;
                        double hra1 = Math.Round(thra1 - tt1);
                        totalearnings = Math.Round(hra1 + tt1);
                        if (pfeligible == "Yes")
                        {
                            presntprovidentfund = (totalearnings * 6) / 100;
                            presntprovidentfund = Math.Round(presntprovidentfund, 0);
                            newrow["PF" + mymonth1] = Math.Round(presntprovidentfund, 0);
                            double eps = 0;
                            eps = (bs1 * 8.33) / 100;
                            newrow["EPS" + mymonth1] = Math.Round(eps, 0);
                            //double employerPF = 0;
                            employerPF = (bs1 * 3.67) / 100;
                            newrow["Employer PF" + mymonth1] = Math.Round(employerPF, 0);
                        }
                        else
                        {
                            presntprovidentfund = 0;
                            newrow["PF" + mymonth1] = Math.Round(presntprovidentfund,0);
                        }
                        double extrapayout = 0;
                        extrapayout = presntprovidentfund - prevprovidentfund;
                        newrow["Extra Deduction for the employee"] = Math.Round(extrapayout, 0);
                        newrow["Extra Payout for the Employer"] = Math.Round(extrapayout, 0);
                        Report.Rows.Add(newrow);
                    }
                }
            }
             
            DataRow newTotal = Report.NewRow();
            newTotal["Name"] = "Total";
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
            if (Report.Rows.Count > 1)
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
        }
    }
}
