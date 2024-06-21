using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
public partial class MobileDeductionReport : System.Web.UI.Page
{
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
                DateTime dtfrom = DateTime.Now.AddMonths(0);
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
                PopulateYear();
                FillBranches();
                string frmdate = dtfrom.ToString("dd/MM/yyyy");
                string[] str = frmdate.Split('/');
                ddlmonth.SelectedValue = str[1];
                DateTime dtyear = DateTime.Now.AddYears(0);
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
            string day = (mydate.Day).ToString();
            string d = "00";
            int pday = Convert.ToInt32(day);
            int nodays = DateTime.DaysInMonth(Convert.ToInt32(year), Convert.ToInt32(mymonth));
            if (pday > nodays)
            {
                day = nodays.ToString();
            }
            string date = mymonth + "/" + day + "/" + year;
            lblHeading.Text = ddlbranches.SelectedItem.Text + " Mobile Deduction Report" + ddlmonth.SelectedItem.Text +  year;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth;
            fromdate = Convert.ToDateTime(date);
            Session["filename"] = ddlbranches.SelectedItem.Text + " Salary Statement " + ddlmonth.SelectedItem.Text + year;
            Session["title"] = ddlbranches.SelectedItem.Text + " Salary Statement " + ddlmonth.SelectedItem.Text + year;
            Report.Columns.Add("Sno");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            Report.Columns.Add("Amount").DataType = typeof(double);
            cmd = new SqlCommand("SELECT mobile_deduction.employee_num, employedetails.fullname,  mobile_deduction.deductionamount FROM mobile_deduction INNER JOIN employedetails ON mobile_deduction.empid = employedetails.empid where (mobile_deduction.deductionamount>0) and (employedetails.branchID=@BranchID) AND (mobile_deduction.month = @month) AND (mobile_deduction.year = @year) ");
            cmd.Parameters.Add("@month", mymonth);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@BranchID", ddlbranches.SelectedValue);
            DataTable dtMobileDeduction = vdm.SelectQuery(cmd).Tables[0];
            if (dtMobileDeduction.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtMobileDeduction.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    newrow["Employee Code"] = dr["employee_num"].ToString();
                    newrow["Name"] = dr["fullname"].ToString();
                    newrow["Amount"] = dr["deductionamount"].ToString();
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