using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class NightDutyAllowance : System.Web.UI.Page
{
    SqlCommand cmd;
    ///string BranchID = "";
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
                DateTime dtfrom = DateTime.Now.AddMonths(0);
                DateTime dtyear = DateTime.Now.AddYears(0);
                PopulateYear();
                bindemployeetype();
                FillBranches();
                string frmdate = dtfrom.ToString("dd/MM/yyyy");
                string[] str = frmdate.Split('/');
                ddlmonth.SelectedValue = str[1];
                string fryear = dtyear.ToString("dd/MM/yyyy");
                string[] str1 = fryear.Split('/');
                ddlyear.SelectedValue = str1[2];
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
    void FillBranches()
    {
        DBManager SalesDB = new DBManager();
        //branchwise
        // cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='2' ");
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
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
        cmd = new SqlCommand("SELECT employee_type FROM employedetails where (employee_type<>'') and employee_type='Staff' OR  employee_type='Casuals'  GROUP BY employee_type");
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
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            string year = ddlyear.SelectedItem.Value;
            string mymonth = ddlmonth.SelectedItem.Value;
            string day = (mydate.Day).ToString();
            string d = "00";
            string date = mymonth + "/" + day + "/" + year;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth;
            fromdate = Convert.ToDateTime(date);
            lblHeading.Text = ddlemptype.SelectedItem.Text + " " + ddlbranches.SelectedItem.Text + " Night Duty Allowance " + ddlmonth.SelectedItem.Text + " " + year;
            Session["filename"] = ddlemptype.SelectedItem.Text + " " + ddlbranches.SelectedItem.Text + " Night Duty Allowance " + ddlmonth.SelectedItem.Text + " " + year;
            Session["title"] = ddlemptype.SelectedItem.Text + " " + ddlbranches.SelectedItem.Text + " Night Duty Allowance " + ddlmonth.SelectedItem.Text + " " + year;
            cmd = new SqlCommand("SELECT company_master.address, company_master.companyname FROM branchmaster INNER JOIN company_master ON branchmaster.company_code = company_master.sno WHERE (branchmaster.branchid = @BranchID)  ");
            cmd.Parameters.Add("@BranchID", ddlbranches.SelectedValue);

            DataTable dtcompany = vdm.SelectQuery(cmd).Tables[0];
            if (dtcompany.Rows.Count > 0)
            {
                lblAddress.Text = dtcompany.Rows[0]["address"].ToString();
                lblTitle.Text = dtcompany.Rows[0]["companyname"].ToString();
            }
            else
            {
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
            }

            cmd.Parameters.Add("@BranchID", ddlbranches.SelectedValue);
            Report.Columns.Add("Sno");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            Report.Columns.Add("Designation");
            Report.Columns.Add("Night Working Days").DataType = typeof(double);
            Report.Columns.Add("Shift Amount Per Day").DataType = typeof(double);
            Report.Columns.Add("Shift Allowance").DataType = typeof(double);
            Report.Columns.Add("Bank Acc No");
            Report.Columns.Add("IFSC Code");
            if (ddlemptype.SelectedItem.Text == "Staff" || ddlemptype.SelectedItem.Text == "Casuals")
            {
                //salaryapprisal
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, designation.designation, employedetails.empid, employebankdetails.ifsccode,employebankdetails.accountno, branchmaster.night_allowance, employedetails.branchid, monthly_attendance.month, monthly_attendance.year,monthly_attendance.night_days, salaryappraisals.gross, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid WHERE (employedetails.branchid = @BranchID) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.employee_type = @emptype) AND (monthly_attendance.night_days <> '0') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.branchid = @BranchID) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.employee_type = @emptype) AND (monthly_attendance.night_days <> '0') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                //paystructre
                //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, designation.designation,employedetails.empid, pay_structure.gross,  employebankdetails.ifsccode, employebankdetails.accountno, branchmaster.night_allowance, employedetails.branchid, monthly_attendance.month, monthly_attendance.year, monthly_attendance.night_days FROM employedetails INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid WHERE (employedetails.branchid = @BranchID) and (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) And (employedetails.employee_type = @emptype) AND (monthly_attendance.night_days <>'0')");
                cmd.Parameters.Add("@BranchID", ddlbranches.SelectedValue);
                cmd.Parameters.Add("@emptype", ddlemptype.SelectedValue);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@d1", date);
                DataTable dtAdvance = SalesDB.SelectQuery(cmd).Tables[0];
                if (dtAdvance.Rows.Count > 0)
                {
                    var i = 1;
                    foreach (DataRow dr in dtAdvance.Rows)
                    {
                        DataRow newrow = Report.NewRow();
                        newrow["Sno"] = i++.ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        newrow["Designation"] = dr["designation"].ToString();
                        newrow["Bank Acc No"] = dr["accountno"].ToString();
                        newrow["IFSC Code"] = dr["ifsccode"].ToString();
                        Report.Rows.Add(newrow);
                        foreach (DataRow dra in dtAdvance.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                        {

                            double nightdays = 0;
                            double.TryParse(dr["night_days"].ToString(), out nightdays);
                            double totamount = 0;
                            double perdaycost = 0;
                            double.TryParse(dra["night_allowance"].ToString(), out perdaycost);
                            totamount = nightdays * perdaycost;
                            totamount = Math.Ceiling(totamount);
                            newrow["Night Working Days"] = nightdays.ToString();
                            newrow["Shift Amount Per Day"] = perdaycost.ToString();
                            newrow["Shift Allowance"] = totamount.ToString();
                        }
                    }
                    DataRow newTotal = Report.NewRow();
                    newTotal["Name"] = "Total Amount";
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
            if (e.Row.Cells[2].Text == "Total Amount")
            {
                e.Row.BackColor = System.Drawing.Color.Aquamarine;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
        }
    }
}