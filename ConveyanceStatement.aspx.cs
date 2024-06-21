using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class ConveyanceStatement : System.Web.UI.Page
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
                    DateTime dtyear = DateTime.Now.AddYears(-1);
                    PopulateYear();
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
        //cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='1'");
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m) ");
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
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
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
            int pday = Convert.ToInt32(day);
            int nodays = DateTime.DaysInMonth(Convert.ToInt32(year), Convert.ToInt32(mymonth));
            if (pday > nodays)
            {
                day = nodays.ToString();
            }
            string date = mymonth + "/" + day + "/" + year;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth.ToString();
            fromdate = Convert.ToDateTime(date);
            Report.Columns.Add("SNO");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            Report.Columns.Add("Designation");
            Report.Columns.Add("Attendance Days");
            Report.Columns.Add("Fixed Conveyance").DataType = typeof(double);
            Report.Columns.Add("Conveyance").DataType = typeof(double);
            Report.Columns.Add("Bank Acc No");
            Report.Columns.Add("IFSC Code");
            //cmd = new SqlCommand("SELECT company_master.address, company_master.companyname FROM branchmaster INNER JOIN company_master ON branchmaster.company_code = company_master.sno WHERE (branchmaster.branchid = @BranchID)");
            cmd = new SqlCommand("SELECT  company_master.address, company_master.companyname, employedetails.employee_type FROM branchmaster INNER JOIN company_master ON branchmaster.company_code = company_master.sno INNER JOIN employedetails ON branchmaster.branchid = employedetails.branchid WHERE        (branchmaster.branchid = @BranchID) AND (employedetails.employee_type <> 'Casuals ')  AND (employedetails.employee_type <> '') GROUP BY company_master.address, company_master.companyname, employedetails.employee_type");
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

            Session["filename"] = dtcompany.Rows[0]["employee_type"].ToString() +" "+ ddlbranches.SelectedItem.Text + " Conveyance Statement " + ddlmonth.SelectedItem.Text + year;
            Session["title"] = dtcompany.Rows[0]["employee_type"].ToString() +" " +ddlbranches.SelectedItem.Text + " Conveyance Statement " + ddlmonth.SelectedItem.Text + year;
            lblHeading.Text = ddlbranches.SelectedItem.Text +" "+ dtcompany.Rows[0]["employee_type"].ToString() + " " + " Conveyance Statement" + ddlmonth.SelectedItem.Text + year;
            //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname,employedetails.employee_type, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode, monthly_attendance.convenancedays, monthly_attendance.numberofworkingdays, monthly_attendance.clorwo, monthly_attendance.lop, monthly_attendance.month, monthly_attendance.year, salaryappraisals.travelconveyance, departments.department FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid INNER JOIN departments ON employedetails.employee_dept = departments.deptid WHERE (employedetails.status = 'NO') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchID)  AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) AND (salaryappraisals.travelconveyance > 0) OR (employedetails.status = 'NO') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchID) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1) AND (salaryappraisals.travelconveyance > 0)");
            cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname,employedetails.employee_type, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode, monthly_attendance.convenancedays, monthly_attendance.numberofworkingdays, monthly_attendance.clorwo, monthly_attendance.lop, monthly_attendance.month, monthly_attendance.year, salaryappraisals.travelconveyance, departments.department FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid INNER JOIN departments ON employedetails.employee_dept = departments.deptid WHERE (employedetails.status = 'NO') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchID)  AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) AND (salaryappraisals.travelconveyance > 0) OR (employedetails.status = 'NO') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchID) AND  (salaryappraisals.startingdate <= @d1) AND (salaryappraisals.travelconveyance > 0)");
            //paystrure
            cmd.Parameters.Add("@branchID", ddlbranches.SelectedValue);
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
                    newrow["SNO"] = i++.ToString();
                    newrow["Employee Code"] = dr["employee_num"].ToString();
                    newrow["Name"] = dr["fullname"].ToString();
                    newrow["Designation"] = (dr["department"].ToString() + " " + dr["designation"].ToString());
                    //newrow["Designation"] = dr["designation"].ToString();
                    //newrow["Conveyance"] = dr["travelconveyance"].ToString();
                    newrow["Bank Acc No"] = dr["accountno"].ToString();
                    newrow["IFSC Code"] = dr["ifsccode"].ToString();
                    //newrow["REMARKS"] = dr["remarks"].ToString();
                    Report.Rows.Add(newrow);
                    foreach (DataRow dra in dtAdvance.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                    {
                        double totamount = 0;
                        double convenancedays = 0;
                        double travelconveyance = 0;
                        double.TryParse(dr["convenancedays"].ToString(), out convenancedays);
                        double numberofworkingdays = 0;
                        double.TryParse(dr["numberofworkingdays"].ToString(), out numberofworkingdays);
                        double clorwo = 0;
                        double.TryParse(dr["clorwo"].ToString(), out clorwo);
                        double totldays = 0;
                        double.TryParse(dr["travelconveyance"].ToString(), out travelconveyance);
                        double lop = 0;
                        double.TryParse(dra["lop"].ToString(), out lop);
                        double days = 0;
                        days = numberofworkingdays + clorwo;

                        totldays = days - lop;
                        newrow["Fixed Conveyance"] = travelconveyance.ToString();

                        if (convenancedays == 0)
                        {
                            double perdaycost = 0;
                            perdaycost = travelconveyance / days;
                            double presentdays = numberofworkingdays - lop;
                            newrow["Attendance Days"] = totldays.ToString();
                            totamount = totldays * perdaycost;
                        }
                        else
                        {
                            newrow["Fixed Conveyance"] = travelconveyance.ToString();
                            newrow["Attendance Days"] = convenancedays.ToString();
                            double perdaycost = 0;
                            perdaycost = travelconveyance / days;
                            totamount = convenancedays * perdaycost;
                        }
                        //double convency = 0;
                        //convency = travelconveyance - lop;
                        newrow["Conveyance"] = Math.Round(totamount);
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