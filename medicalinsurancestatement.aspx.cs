using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class medicalinsurancestatement : System.Web.UI.Page
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
                DateTime dtfrom = DateTime.Now.AddMonths(-1);
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
                FillBranches();
                string frmdate = dtfrom.ToString("dd/MM/yyyy");
                string[] str = frmdate.Split('/');
                //ddlmonth.SelectedValue = str[1];
                DateTime dtyear = DateTime.Now.AddYears(0);
                string fryear = dtyear.ToString("dd/MM/yyyy");
                string[] str1 = fryear.Split('/');
                //ddlyear.SelectedValue = str1[2];

            }
        }
    }
    void FillBranches()
    {
        DBManager SalesDB = new DBManager();
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
        cmd.Parameters.Add("@m", mainbranch); 
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlbranches.DataSource = dttrips;
        ddlbranches.DataTextField = "branchname";
        ddlbranches.DataValueField = "branchid";
        ddlbranches.DataBind();
        ddlbranches.Items.Insert(0, new ListItem { Value = "0", Text = "All", Selected = true });
        ddlbranches.SelectedValue = "0";
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
            string day = (mydate.Day).ToString();
            string d = "00";
            lblHeading.Text = ddlbranches.SelectedItem.Text + " Medical Report" ;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            Session["filename"] = ddlbranches.SelectedItem.Text + " Medical Report ";
            Session["title"] = ddlbranches.SelectedItem.Text + " Medical Report ";
            //lbltodate.Text = todate.ToString("dd/MMM/yyyy");
            Report.Columns.Add("Sno");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            Report.Columns.Add("Amount").DataType = typeof(double);
            string mainbranch = Session["mainbranch"].ToString(); 
            if (ddlbranches.SelectedItem.Text == "All")
            {
                //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, mediclaimdeduction.medicliamamount FROM mediclaimdeduction INNER JOIN employedetails ON mediclaimdeduction.empid = employedetails.empid where (mediclaimdeduction.month = @month) AND (mediclaimdeduction.year = @year)");
                cmd = new SqlCommand("SELECT  employedetails.employee_num, employedetails.fullname, mediclaimdeduction.medicliamamount FROM mediclaimdeduction INNER JOIN employedetails ON mediclaimdeduction.empid = employedetails.empid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
                cmd.Parameters.Add("@m", mainbranch);
            }
            else
            {
                //branchwise
                //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, mediclaimdeduction.medicliamamount FROM mediclaimdeduction INNER JOIN employedetails ON mediclaimdeduction.empid = employedetails.empid where (employedetails.branchID=@BranchID) and (mediclaimdeduction.month = @month) AND (mediclaimdeduction.year = @year)");
                //branchmapping
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, mediclaimdeduction.medicliamamount FROM  mediclaimdeduction INNER JOIN employedetails ON mediclaimdeduction.empid = employedetails.empid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (employedetails.branchid = @BranchID) AND  (branchmapping.mainbranch = @m)");
                cmd.Parameters.Add("@m", mainbranch);
            }
            cmd.Parameters.Add("@BranchID", ddlbranches.SelectedValue);
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
                    //newrow["DEPARTMENT"] = dr["department"].ToString();
                    newrow["Amount"] = dr["medicliamamount"].ToString();
                    //newrow["REMARKS"] = dr["remarks"].ToString();
                    Report.Rows.Add(newrow);
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