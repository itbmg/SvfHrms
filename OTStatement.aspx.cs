using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;



public partial class OTStatement : System.Web.UI.Page
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
        //if (BranchID == "1")
        // {
        //branchwise
       // cmd = new SqlCommand("SELECT  branchid, branchname, address, phone, emailid, statename FROM  branchmaster where branchmaster.branchtype='Plant' ");
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        if (mainbranch != "42")
        {
            cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m) and branchmaster.branchtype='Plant'");
        }
        else
        {
            cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
        }
        cmd.Parameters.Add("@m", mainbranch); 
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlbranches.DataSource = dttrips;
        ddlbranches.DataTextField = "branchname";
        ddlbranches.DataValueField = "branchid";
        ddlbranches.DataBind();
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
            string branchid = Session["mainbranch"].ToString();
            hidepanel.Visible = true;
            hidepanel.Visible = true;
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            // lblmsg.Text = "";
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            string dept = "";
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
            lblHeading.Text = ddlbranches.SelectedItem.Text + " OT Statement Report " + ddlmonth.SelectedItem.Text + " " + year;
            Session["filename"] = ddlbranches.SelectedItem.Text + " OT Salary Statement " + ddlmonth.SelectedItem.Text + year;
            Session["title"] = ddlbranches.SelectedItem.Text + "  OT Salary Statement " + ddlmonth.SelectedItem.Text + year;
            Report.Columns.Add("Department");
            Report.Columns.Add("Sno");
            Report.Columns.Add("EmployeeCode");
            Report.Columns.Add("Name");
            Report.Columns.Add("Designation");
            Report.Columns.Add("Gross").DataType = typeof(double);
            Report.Columns.Add("OT Hours").DataType = typeof(double);
            Report.Columns.Add("OT Days").DataType = typeof(double);
            Report.Columns.Add("OT Days Value").DataType = typeof(double);
            Report.Columns.Add("BankAccNo");
            Report.Columns.Add("IFSCCode");
            cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.fromdate, branchmaster.todate, monthly_attendance.otdays, monthly_attendance.clorwo, designation.designation, monthly_attendance.numberofworkingdays,monthly_attendance.lop, departments.department, salaryappraisals.gross, salaryappraisals.salaryperyear FROM departments INNER JOIN monthly_attendance INNER JOIN designation INNER JOIN employedetails ON designation.designationid = employedetails.designationid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid ON monthly_attendance.empid = employedetails.empid ON departments.deptid = employedetails.employee_dept INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON monthly_attendance.empid = employebankdetails.employeid WHERE (monthly_attendance.otdays <> 0) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.employee_type <> 'Driver') AND (employedetails.employee_type <> 'Cleaner') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (monthly_attendance.otdays <> 0) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.employee_type <> 'Driver') AND (employedetails.employee_type <> 'Cleaner') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1) ORDER BY departments.department");
            cmd.Parameters.Add("@month", mymonth);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@branchid", ddlbranches.SelectedItem.Value);
            cmd.Parameters.Add("@d1", date);
           
            DataTable dtOT = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtOT.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtOT.Rows)
                {
                    string from = dr["fromdate"].ToString();
                    string to = dr["todate"].ToString();
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    dept = dr["department"].ToString();
                    newrow["Department"] = dr["department"].ToString();
                    //newrow["Department"] = (dr["department"].ToString() + " " + dr["designation"].ToString());
                    newrow["EmployeeCode"] = dr["employee_num"].ToString();
                    newrow["Name"] = dr["fullname"].ToString();
                    newrow["Designation"] = (dr["department"].ToString() + " " + dr["designation"].ToString());
                    string designation = dr["designation"].ToString();
                    newrow["BankAccNo"] = dr["accountno"].ToString();
                    newrow["IFSCCode"] = dr["ifsccode"].ToString();
                    string ot = dr["otdays"].ToString();
                    int premonth = 0;
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
                        otdays = Convert.ToDouble(dr["otdays"].ToString());
                    }
                    double monthsal = 0;
                    if (branchid == "42")
                    {
                        if (designation == "Casual Worker")
                        {
                            monthsal = Convert.ToDouble(dr["gross"].ToString());
                            monthsal = monthsal * daysinmonth;
                        }
                        else
                        {
                            monthsal = Convert.ToDouble(dr["gross"].ToString());
                        }
                    }
                    else
                    {
                         monthsal = Convert.ToDouble(dr["gross"].ToString());
                    }
                    double perdayamt = monthsal / daysinmonth;
                    double otvalue=0;
                    double othours = 0;
                    if (dept == "Casuals")
                    {
                         otvalue = monthsal * otdays;
                         othours = otdays * 12;
                    }
                    else
                    {
                       otvalue = perdayamt * otdays;
                       othours = otdays * 8;
                    }
                    
                    othours = Math.Round(othours, 0);
                    newrow["OT Hours"] = othours;
                    newrow["OT Days"] = otdays;
                    newrow["OT Days Value"] = Math.Round(otvalue);
                    newrow["Gross"] = dr["gross"].ToString();
                    Report.Rows.Add(newrow);
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
                grdReports.DataBind();
                Session["xportdata"] = Report;
                hidepanel.Visible = true;
            }

            else
            {
                lblmsg.Text = "No data found";
                hidepanel.Visible = false;
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }
    protected void gvMenu_DataBinding(object sender, EventArgs e)
    {
        try
        {
            GridViewGroup First = new GridViewGroup(grdReports, null, "Department");
           // GridViewGroup seconf = new GridViewGroup(grdReports, First, "Department");
            //GridViewGroup seconf = new GridViewGroup(grdReports, First, "Location");
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
            if (e.Row.Cells[4].Text == "Total")
            {
                e.Row.BackColor = System.Drawing.Color.Aquamarine;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
        }
    }
   
}