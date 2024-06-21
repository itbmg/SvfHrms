using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class Appraisalsreport : System.Web.UI.Page
{
    SqlCommand cmd;
    ///string BranchID = "";
    DBManager vdm;

    double Deductions = 0;
    double Income = 0;
    //double DEDUCTIONS = 0;

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
                //dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                //dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
                FillBranches();
                string frmdate = dtfrom.ToString("dd/MM/yyyy");
                string[] str = frmdate.Split('/');
                //ddlmonth.SelectedValue = str[1];

            }
        }
    }
    void FillBranches()
    {
        DBManager SalesDB = new DBManager();
        //branchwise
        //cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='1'");
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
            DataTable dtapprisal = new DataTable();
            Report.Columns.Add("Sno");
            Report.Columns.Add("Department");
            Report.Columns.Add("EmployeeName");
            Report.Columns.Add("Previous Salary").DataType = typeof(double);
            Report.Columns.Add("Appraisal");
            Report.Columns.Add("Present Salary").DataType = typeof(double);
            int branchid = Convert.ToInt32(ddlbranches.SelectedItem.Value);
            string mainbranch = Session["mainbranch"].ToString();
            cmd = new SqlCommand("SELECT salaryappraisals.empid, salaryappraisals.departmentid, departments.department,salaryappraisals.appraisal, salaryappraisals.gross, salaryappraisals.changedpackage,salaryappraisals.totaldeduction, salaryappraisals.totalearnings, salaryappraisals.netpay, employedetails.fullname, employedetails.joindate, branchmaster.branchname FROM salaryappraisals INNER JOIN  employedetails ON salaryappraisals.empid = employedetails.empid INNER JOIN  branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch  INNER JOIN departments ON salaryappraisals.departmentid  = departments.deptid WHERE (employedetails.branchid = @branchid) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No')");
            cmd.Parameters.Add("@m", mainbranch);
            cmd.Parameters.Add("@branchid", branchid);
            dtapprisal = vdm.SelectQuery(cmd).Tables[0];
            if (dtapprisal.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow dr in dtapprisal.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    newrow["Department"] = dr["department"].ToString();
                    newrow["EmployeeName"] = dr["fullname"].ToString();
                    newrow["Previous Salary"] = dr["changedpackage"].ToString();
                    newrow["Appraisal"] = dr["appraisal"].ToString();
                    double salary = 0;
                    double.TryParse(dr["gross"].ToString(), out salary);
                    double apprasial = 0;
                    //double.TryParse(dr["appraisal"].ToString(), out apprasial);
                    double increment = salary + apprasial;
                    newrow["Present Salary"] = increment;
                    Report.Rows.Add(newrow);

                }
                DataRow newTotal = Report.NewRow();
                newTotal["Department"] = "Total";
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
            }

            grdReports.DataSource = Report;
            grdReports.DataBind();
            Session["xportdata"] = Report;
            hidepanel.Visible = true;
        }

        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;

        }
    }
    //protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    //{
    //    if (e.Row.RowType == DataControlRowType.DataRow)
    //    {
    //        if (e.Row.Cells[2].Text == "Total Amount")
    //        {
    //            e.Row.BackColor = System.Drawing.Color.Aquamarine;
    //            e.Row.Font.Size = FontUnit.Large;
    //            e.Row.Font.Bold = true;
    //        }
    //        //if (e.Row.Cells[3].Text == "Grand Total")
    //        //{
    //        //    e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
    //        //    e.Row.Font.Size = FontUnit.Large;
    //        //    e.Row.Font.Bold = true;
    //        //}
    //    }
    //}
}