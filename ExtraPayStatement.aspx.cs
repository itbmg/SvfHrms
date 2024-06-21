using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class ExtraPayStatement : System.Web.UI.Page
{
    SqlCommand cmd;
    string BranchID = "";
    DBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["branchid"] == null)
            Response.Redirect("Login.aspx");
        else
        {
            BranchID = Session["branchid"].ToString();
            vdm = new DBManager();
            if (!Page.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    DateTime dtfrom = DateTime.Now.AddMonths(0);
                    DateTime dtyear = DateTime.Now.AddYears(0);
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    PopulateYear();
                    fillbranch();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    ddlmonth.SelectedValue = str[1];
                    string fryear = dtyear.ToString("dd/MM/yyyy");
                    string[] str1 = fryear.Split('/');
                    ddlyear.SelectedValue = str1[2];
                    bindemployeetype();
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
    void fillbranch()
    {
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m) and ((branchtype='SalesOffice') or (branchtype='plant') or (branchtype='IFD plant'))");
        cmd.Parameters.Add("@m", mainbranch);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlbranches.DataSource = dttrips;
        ddlbranches.DataTextField = "branchname";
        ddlbranches.DataValueField = "branchid";
        ddlbranches.DataBind();

    }
    private void bindemployeetype()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT employee_type FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch where (employee_type<>'') AND (branchmapping.mainbranch = @bid) GROUP BY employee_type");
        cmd.Parameters.Add("@bid", Session["mainbranch"].ToString());
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlemptype.DataSource = dttrips;
        ddlemptype.DataTextField = "employee_type";
        ddlemptype.DataValueField = "employee_type";
        ddlemptype.DataBind();
        ddlemptype.ClearSelection();
        ddlemptype.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Type--", Selected = true });
        ddlemptype.SelectedValue = "0";
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
            hidepanel.Visible = true;
            hidepanel.Visible = true;
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            string currentyear = (mydate.Year).ToString();
            string year = ddlyear.SelectedItem.Value;
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
            //string day = (mydate.Day).ToString();
            string d = "00";
            string date = mymonth + "/" + day + "/" + year;
            lblFromDate.Text = mymonth;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblHeading.Text = ddlbranches.SelectedItem.Text + " Extra pay Statement Report" + " " + ddlmonth.SelectedItem.Text + str[2];
            Session["filename"] = ddlbranches.SelectedItem.Text + " Extra pay Statement " + " " + ddlmonth.SelectedItem.Text + str[2];
            Session["title"] = ddlbranches.SelectedItem.Text + " Extra pay Statement " + " " + ddlmonth.SelectedItem.Text + str[2];
            Report.Columns.Add("Sno");
            Report.Columns.Add("EmployeeCode");
            Report.Columns.Add("Name");
            Report.Columns.Add("Designation");
            Report.Columns.Add("Gross").DataType = typeof(double);
            Report.Columns.Add("Extra Days").DataType = typeof(double);
            Report.Columns.Add("Extra Days Pay").DataType = typeof(double);
            Report.Columns.Add("BankAccNo");
            string employee_type = ddlemptype.SelectedItem.Value;
            cmd = new SqlCommand("SELECT employedetails.employee_type,employedetails.empid, employedetails.employee_num, employedetails.fullname,employebankdetails.accountno,monthly_attendance.month, monthly_attendance.year, salaryappraisals.gross,monthly_attendance.clorwo, salaryappraisals.salaryperyear, monthly_attendance.extradays,monthly_attendance.numberofworkingdays,designation.designation FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
            //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.fromdate, branchmaster.todate, monthly_attendance.extradays, monthly_attendance.clorwo, designation.designation, monthly_attendance.numberofworkingdays, monthly_attendance.lop, departments.department, salaryappraisals.gross, salaryappraisals.salaryperyear FROM departments INNER JOIN monthly_attendance INNER JOIN designation INNER JOIN employedetails ON designation.designationid = employedetails.designationid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid ON monthly_attendance.empid = employedetails.empid ON  departments.deptid = employedetails.employee_dept INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON monthly_attendance.empid = employebankdetails.employeid WHERE (monthly_attendance.extradays <> 0) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.employee_type <> 'Driver') AND (employedetails.employee_type <> 'Cleaner') AND (employedetails.employee_type <> 'Canteen') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (monthly_attendance.extradays <> 0) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)  AND (employedetails.employee_type <> 'Driver') AND (employedetails.employee_type <> 'Cleaner') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)ORDER BY departments.department");
            cmd.Parameters.Add("@month", mymonth);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@branchid", ddlbranches.SelectedItem.Value);
            cmd.Parameters.Add("@emptype", employee_type);
            cmd.Parameters.Add("@d1", date);
            DataTable dtAdvance = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtAdvance.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtAdvance.Rows)
                {
                    double daysot = Convert.ToDouble(dr["extradays"].ToString());
                    if (daysot > 0)
                    {
                        //string from = dr["fromdate"].ToString();
                        //string to = dr["todate"].ToString();
                        DataRow newrow = Report.NewRow();
                        newrow["Sno"] = i++.ToString();
                        newrow["EmployeeCode"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        newrow["Designation"] = (dr["designation"].ToString());
                        // newrow["Designation"] = dr["designation"].ToString();
                        newrow["BankAccNo"] = dr["accountno"].ToString();
                        string ot = dr["extradays"].ToString();
                        double otdays = 0;
                        double daysinmonth = 0;
                        double numberofworkingdays = Convert.ToDouble(dr["numberofworkingdays"].ToString());
                        double clorwo = 0;
                        double.TryParse(dr["clorwo"].ToString(), out clorwo);
                        daysinmonth = numberofworkingdays + clorwo;
                        if (numberofworkingdays == 0.0)
                        {
                            numberofworkingdays = 1;
                        }
                        if (ot == null || ot == "")
                        {
                            otdays = 0;
                        }
                        else
                        {
                            if (ddlbranches.SelectedItem.Text == "Chennai SO")
                            {
                                otdays = Convert.ToDouble(dr["extradays"].ToString());
                            }
                            else
                            {
                                otdays = Convert.ToDouble(dr["extradays"].ToString());
                            }
                        }
                        double monthsal = Convert.ToDouble(dr["gross"].ToString());
                        double perdayamt = 0;
                        double otvalue = 0;
                        if (ddlemptype.SelectedItem.Text == "Driver" && ddlbranches.SelectedValue == "6")
                        {
                            perdayamt = 800;
                            otvalue = monthsal * otdays;
                        }
                        else
                        {
                            perdayamt = monthsal / daysinmonth;
                            otvalue = perdayamt * otdays;
                        }
                        newrow["Extra Days"] = otdays;
                        newrow["Extra Days Pay"] = Math.Round(otvalue, 0);
                        if (ddlemptype.SelectedItem.Text == "Driver" && ddlbranches.SelectedValue == "6")
                        {
                            newrow["Gross"] = dr["gross"].ToString();
                        }
                        else
                        {
                            newrow["Gross"] = dr["gross"].ToString();
                        }
                        Report.Rows.Add(newrow);
                    }
                }
                DataRow newTotal = Report.NewRow();
                newTotal["DESIGNATION"] = "Total";
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
                    lblmsg.Text = "No data were found";
                    hidepanel.Visible = false;
                }
            }

            
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }
    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (e.Row.Cells[3].Text == "Total")
            {
                e.Row.BackColor = System.Drawing.Color.Aquamarine;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
        }
    }

    protected void btn_save_extrapay(object sender, EventArgs e)
    {
        DataTable dtlogs = new DataTable();
        dtlogs = (DataTable)Session["xportdata"];
        string mainbranch = Session["mainbranch"].ToString();
        cmd = new SqlCommand("SELECT employedetails.empid, employedetails.employee_num, employedetails.fullname, departments.department, departments.deptid, designation.designation, designation.designationid FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN departments ON employedetails.employee_dept = departments.deptid INNER JOIN designation ON employedetails.designationid = designation.designationid WHERE(branchmapping.mainbranch = @m) AND (employedetails.status = 'No')");
        cmd.Parameters.Add("@m", mainbranch);
        DataTable dtemployee = vdm.SelectQuery(cmd).Tables[0];
        if (dtlogs.Rows.Count > 0)
        {
            foreach (DataRow dr in dtlogs.Rows)
            {
                string employeeid = "";
                string employeno = dr["EmployeeCode"].ToString();
                foreach (DataRow dremployee in dtemployee.Select("employee_num='" + employeno + "'"))
                {
                    employeeid = dremployee["empid"].ToString();
                }
                string extradays = dr["Extra Days"].ToString();
                string extrapay = dr["Extra Days Pay"].ToString();
                string year = ddlyear.SelectedItem.Value;
                string month = ddlmonth.SelectedItem.Value;
                cmd = new SqlCommand("UPDATE monthlysalarystatement SET extrapay=@extrapay, extradays=@extradays WHERE empid=@empid AND month=@month AND year=@year");
                cmd.Parameters.Add("@empid", employeeid);
                cmd.Parameters.Add("@extrapay", extrapay);
                cmd.Parameters.Add("@extradays", extradays);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@month", month);
                vdm.Update(cmd);
                lblmsg.Text = " Employee Extrapay successfully saved";   
            }
        }
    }
}