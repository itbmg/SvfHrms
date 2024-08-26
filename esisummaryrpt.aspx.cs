using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class esisummaryrpt : System.Web.UI.Page
{
    ///string BranchID = "";
    SqlCommand cmd;
    DBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        vdm = new DBManager();
        if (Session["fullname"] == null)
        {
            Response.Redirect("login.aspx");
        }
        if (!IsPostBack)
        {
            if (!Page.IsCallback)
            {
                DateTime dtfrom = DateTime.Now.AddMonths(-1);
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
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

    DataTable Report = new DataTable();
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            string Type = ddlcompantype.SelectedItem.Value;
            Report.Columns.Add("SNO");
            Report.Columns.Add("Type");
            Report.Columns.Add("Employee Count");
            Report.Columns.Add("Gross Salary");
            Report.Columns.Add("Employee Contribution");
            Report.Columns.Add("Employer Contribution");
            Report.Columns.Add("Total");

            vdm = new DBManager();
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            DateTime dtfromdate = ServerDateCurrentdate;
            DateTime dttodate = ServerDateCurrentdate;
            string amonth = "";
            string ayear = "";

            DateTime fromdate = ServerDateCurrentdate;
            DateTime dtfrom = fromdate.AddMonths(-1);
            string frmdate = dtfrom.ToString("MM/dd/yyyy");
            string frommonth = dtfrom.ToString("MMM");
            string[] str = frmdate.Split('/');
            //string day = (mydate.Day).ToString();
            //string date = mymonth + "/" + day + "/" + year;
            int lastmonth = 24;
            int years = Convert.ToInt32(str[2]);
            int months = Convert.ToInt32(str[0]);
            dtfromdate = new DateTime(years, months, lastmonth);
            amonth = str[0];
            string day = "";
            if (amonth == "02")
            {
                day = "28";
            }
            else
            {
                day = (fromdate.Day).ToString();
            }
            ayear = str[2];
            int pday = Convert.ToInt32(day);
            int nodays = DateTime.DaysInMonth(years, months);
            if (pday > nodays)
            {
                day = nodays.ToString();
            }
            string date = amonth + "/" + day + "/" + ayear;
            DateTime dtto = fromdate;
            string todate = dtto.ToString("MM/dd/yyyy");
            string[] strto = todate.Split('/');
            int prasentdate = 10;
            int prasentyears = Convert.ToInt32(strto[2]);
            int prasentmonths = Convert.ToInt32(strto[0]);
            dttodate = new DateTime(prasentyears, prasentmonths, prasentdate);

            lblHeading.Text = "ESI statement-For" + " " + amonth;
            Session["filename"] = "ESI statement-For" + " " + amonth;
            Session["title"] = "ESI statement-For" + " " + amonth;
            if (Type == "1")
            {
                cmd = new SqlCommand("SELECT branchid, branchname from branchmaster");
            }
            else if (Type == "2")
            {
                cmd = new SqlCommand("SELECT  deptid, department FROM  departments");
            }
            else
            {
                cmd = new SqlCommand("SELECT designationid, designation FROM designation");
            }
            DataTable dtbranches = vdm.SelectQuery(cmd).Tables[0];
            if (dtbranches.Rows.Count > 0)
            {
                int i = 1;
                //paystrure
                string mainbranch = Session["mainbranch"].ToString();
                //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.branchid, employedetails.empid, employedetails.fullname, monthly_attendance.lop, pay_structure.salaryperyear, employedetails.joindate FROM employedetails INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (employedetails.esieligible = 'Yes') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.status = 'no') AND (branchmapping.mainbranch = @m)");
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.branchid, employedetails.empid, employedetails.fullname, monthly_attendance.lop, employedetails.joindate, salaryappraisals.gross, salaryappraisals.salaryperyear,designation.designation, departments.department FROM employedetails INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN departments ON employedetails.employee_dept = departments.deptid WHERE (employedetails.status = 'No') AND (employedetails.esieligible = 'Yes') AND (branchmapping.mainbranch = @m) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (employedetails.esieligible = 'Yes') AND (branchmapping.mainbranch = @m) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                cmd.Parameters.Add("@month", amonth);
                cmd.Parameters.Add("@m", mainbranch);
                cmd.Parameters.Add("@year", ayear);
                cmd.Parameters.Add("@d1", date);
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                foreach (DataRow dr in dtbranches.Rows)
                {
                    int count = 0;
                    int totalcount = 0;
                    double basictotal = 0;
                    double esiemployetotal = 0;
                    double esiemployertotal = 0;
                    string branchname = "";
                    string department = "";
                    string designation = "";
                    if (routes.Rows.Count > 0)
                    {
                        DataRow newrow = Report.NewRow();
                        newrow["SNO"] = i++;
                        if (Type == "1")
                        {
                            foreach (DataRow dremp in routes.Select("branchid='" + dr["branchid"].ToString() + "'"))
                            {

                                string salary = dremp["salaryperyear"].ToString();
                                double grosssal = Convert.ToDouble(dremp["salaryperyear"].ToString());
                                double monthsal = grosssal / 12;
                                if (monthsal < 15000)
                                {
                                    branchname = dr["branchname"].ToString();
                                    string empid = dremp["empid"].ToString();
                                    string empsno = empid;
                                    string empname = dremp["fullname"].ToString();
                                    string employeid = dremp["employee_num"].ToString();

                                    string lossofdays = dremp["lop"].ToString();
                                    double days = 0;
                                    if (lossofdays == "")
                                    {
                                        days = 0;
                                    }
                                    else
                                    {
                                        days = Convert.ToDouble(lossofdays);
                                    }
                                    TimeSpan t = dttodate - dtfromdate;
                                    double NrOfDays = t.TotalDays;
                                    string daysinmonth = NrOfDays.ToString();
                                    double attandancedays = NrOfDays - days;
                                    double msal = Convert.ToDouble(monthsal);
                                    double perdayamount = msal / NrOfDays;
                                    double lossofamount = days * perdayamount;
                                    double totalsal = msal - lossofamount;
                                    double basic = 40;
                                    double grossbasic = (msal * basic) / 100;
                                    double erbasic = Math.Round(totalsal * basic) / 100;
                                    basictotal += erbasic;
                                    double esiper = 0.75;
                                    double employeesi = Math.Round(totalsal * esiper) / 100;
                                    esiemployetotal += employeesi;
                                    double esi = 3.25;
                                    double employeresi = Math.Round(totalsal * esi) / 100;
                                    esiemployertotal += employeresi;
                                    totalcount = count++;
                                }
                            }
                            if (totalcount != 0)
                            {
                                newrow["Type"] = branchname;
                                newrow["Employee Count"] = count++;
                                newrow["Gross Salary"] = basictotal;
                                newrow["Employee Contribution"] = esiemployetotal;
                                newrow["Employer Contribution"] = esiemployertotal;
                                newrow["Total"] = esiemployetotal + esiemployertotal;
                                Report.Rows.Add(newrow);
                            }
                        }
                        else if (Type == "2")
                        {
                            foreach (DataRow dremp in routes.Select("department='" + dr["department"].ToString() + "'"))
                            {
                                string salary = dremp["salaryperyear"].ToString();
                                double grosssal = Convert.ToDouble(dremp["salaryperyear"].ToString());
                                double monthsal = grosssal / 12;
                                if (monthsal < 15000)
                                {
                                    department = dr["department"].ToString();
                                    string empid = dremp["empid"].ToString();
                                    string empsno = empid;
                                    string empname = dremp["fullname"].ToString();
                                    string employeid = dremp["employee_num"].ToString();

                                    string lossofdays = dremp["lop"].ToString();
                                    double days = 0;
                                    if (lossofdays == "")
                                    {
                                        days = 0;
                                    }
                                    else
                                    {
                                        days = Convert.ToDouble(lossofdays);
                                    }
                                    TimeSpan t = dttodate - dtfromdate;
                                    double NrOfDays = t.TotalDays;
                                    string daysinmonth = NrOfDays.ToString();
                                    double attandancedays = NrOfDays - days;
                                    double msal = Convert.ToDouble(monthsal);
                                    double perdayamount = msal / NrOfDays;
                                    double lossofamount = days * perdayamount;
                                    double totalsal = msal - lossofamount;
                                    double basic = 40;
                                    double grossbasic = (msal * basic) / 100;
                                    double erbasic = Math.Round(totalsal * basic) / 100;
                                    basictotal += erbasic;
                                    double esiper = 0.75;
                                    double employeesi = Math.Round(totalsal * esiper) / 100;
                                    esiemployetotal += employeesi;
                                    double esi = 3.25;
                                    double employeresi = Math.Round(totalsal * esi) / 100;
                                    esiemployertotal += employeresi;
                                    totalcount = count++;
                                }
                            }
                            if (totalcount != 0)
                            {
                                newrow["Type"] = department;
                                newrow["Employee Count"] = count++;
                                newrow["Gross Salary"] = basictotal;
                                newrow["Employee Contribution"] = esiemployetotal;
                                newrow["Employer Contribution"] = esiemployertotal;
                                newrow["Total"] = esiemployetotal + esiemployertotal;
                                Report.Rows.Add(newrow);
                            }
                        }
                        else
                        {
                            foreach (DataRow dremp in routes.Select("designation='" + dr["designation"].ToString() + "'"))
                            {
                                string salary = dremp["salaryperyear"].ToString();
                                double grosssal = Convert.ToDouble(dremp["salaryperyear"].ToString());
                                double monthsal = grosssal / 12;
                                if (monthsal < 15000)
                                {
                                    designation = dr["designation"].ToString();
                                    string empid = dremp["empid"].ToString();
                                    string empsno = empid;
                                    string empname = dremp["fullname"].ToString();
                                    string employeid = dremp["employee_num"].ToString();

                                    string lossofdays = dremp["lop"].ToString();
                                    double days = 0;
                                    if (lossofdays == "")
                                    {
                                        days = 0;
                                    }
                                    else
                                    {
                                        days = Convert.ToDouble(lossofdays);
                                    }
                                    TimeSpan t = dttodate - dtfromdate;
                                    double NrOfDays = t.TotalDays;
                                    string daysinmonth = NrOfDays.ToString();
                                    double attandancedays = NrOfDays - days;
                                    double msal = Convert.ToDouble(monthsal);
                                    double perdayamount = msal / NrOfDays;
                                    double lossofamount = days * perdayamount;
                                    double totalsal = msal - lossofamount;
                                    double basic = 40;
                                    double grossbasic = (msal * basic) / 100;
                                    double erbasic = Math.Round(totalsal * basic) / 100;
                                    basictotal += erbasic;
                                    double esiper = 0.75;
                                    double employeesi = Math.Round(totalsal * esiper) / 100;
                                    esiemployetotal += employeesi;
                                    double esi = 3.25;
                                    double employeresi = Math.Round(totalsal * esi) / 100;
                                    esiemployertotal += employeresi;
                                    totalcount = count++;
                                }
                            }
                            if (totalcount != 0)
                            {
                                newrow["Type"] = designation;
                                newrow["Employee Count"] = count++;
                                newrow["Gross Salary"] = basictotal;
                                newrow["Employee Contribution"] = esiemployetotal;
                                newrow["Employer Contribution"] = esiemployertotal;
                                newrow["Total"] = esiemployetotal + esiemployertotal;
                                Report.Rows.Add(newrow);
                            }
                        }
                    }
                }
            }
            grdReports.DataSource = Report;
            grdReports.DataBind();
            Session["xportdata"] = Report;
            hidepanel.Visible = true;

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (e.Row.Cells[2].Text == "Total Amount")
            {
                e.Row.BackColor = System.Drawing.Color.Aquamarine;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
            //if (e.Row.Cells[3].Text == "Grand Total")
            //{ddlcompantype
            //    e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
            //    e.Row.Font.Size = FontUnit.Large;
            //    e.Row.Font.Bold = true;
            //}
        }
    }
}