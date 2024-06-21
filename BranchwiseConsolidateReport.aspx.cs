using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class BranchwiseConsolidateReport : System.Web.UI.Page
{
    SqlCommand cmd;
    string userid = "";
    DBManager vdm;

    double netpay = 0;

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
                    DateTime dtfrom = DateTime.Now.AddMonths(0);
                    DateTime dtyear = DateTime.Now.AddYears(0);
                    PopulateYear();
                    bindbranchs();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                }
            }
        }
    }

    
    private void PopulateYear()
    {

        slct_year.Items.Clear();
        ListItem lt = new ListItem();
        lt.Text = "YYYY";
        lt.Value = "0";
        slct_year.Items.Add(lt);
        for (int i = DateTime.Now.Year; i >= 1970; i--)
        {
            lt = new ListItem();
            lt.Text = i.ToString();
            lt.Value = i.ToString();
            slct_year.Items.Add(lt);
        }
        slct_year.Items.FindByValue(DateTime.Now.Year.ToString()).Selected = true;
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
        DBManager vdm = new DBManager();
        string mainbranch = Session["mainbranch"].ToString();
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
        cmd.Parameters.Add("@m", mainbranch);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        slct_branch.DataSource = dttrips;
        slct_branch.DataTextField = "branchname";
        slct_branch.DataValueField = "branchid";
        slct_branch.DataBind();
        slct_branch.ClearSelection();
        slct_branch.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        slct_branch.SelectedValue = "0";
    }
    DataTable Report = new DataTable();
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            DataTable empid = Session["empid"] as DataTable;
            string mainbranch = Session["mainbranch"].ToString();
            string year = slct_year.SelectedItem.Value;
            string branch = slct_branch.SelectedItem.Value;
            cmd = new SqlCommand("SELECT    branchmaster.branchname, SUM(monthlysalarystatement.gross) AS Gross, SUM(monthlysalarystatement.netpay) AS Netpay   FROM    monthlysalarystatement INNER JOIN  branchmaster ON monthlysalarystatement.branchid = branchmaster.branchid   WHERE (monthlysalarystatement.year = @year) AND (monthlysalarystatement.branchid = @branch) GROUP BY branchmaster.branchname");
            cmd.Parameters.Add("@branch", branch);
            cmd.Parameters.Add("@year", year);
            DataTable dtemployee = vdm.SelectQuery(cmd).Tables[0];
            if (dtemployee.Rows.Count > 0)
            {
                grdReports.DataSource = dtemployee;
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

    protected void grdReports_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = grdReports.Rows[rowIndex];
            string ReceiptNo = row.Cells[1].Text;
            Report.Columns.Add("sno");
            Report.Columns.Add("Month");
            Report.Columns.Add("GrossPay");
            Report.Columns.Add("NetPay");
            lblmsg.Text = "";
            int i = 1;
            string year = slct_year.SelectedItem.Value;
            DBManager vdm = new DBManager();
            cmd = new SqlCommand("SELECT  branchid, branchname, address, phone, emailid, statename, fromdate, todate, night_allowance, branchtype, company_code, branchcode, sapcode, estdyear, incharge, lat, long FROM branchmaster WHERE (branchname = @branchname)");
            cmd.Parameters.Add("@branchname", ReceiptNo);
            DataTable dtbranchid = vdm.SelectQuery(cmd).Tables[0];
            if (dtbranchid.Rows.Count > 0)
            {
                cmd = new SqlCommand("SELECT   SUM(monthlysalarystatement.gross) AS gross, SUM(monthlysalarystatement.netpay) AS Netpay, monthlysalarystatement.month FROM  monthlysalarystatement INNER JOIN branchmaster ON monthlysalarystatement.branchid = branchmaster.branchid WHERE (monthlysalarystatement.year = @year) AND (monthlysalarystatement.branchid = @branch) GROUP BY branchmaster.branchname, monthlysalarystatement.month");
                cmd.Parameters.Add("@branch", dtbranchid.Rows[0]["branchid"].ToString());
                cmd.Parameters.Add("@year", year);
                DataTable dtemployee = vdm.SelectQuery(cmd).Tables[0];

                foreach (DataRow dr in dtemployee.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["sno"] = i++.ToString();
                    //newrow["Month"] = dr["month"].ToString();
                    int m = Convert.ToInt32(dr["month"].ToString());
                    string month = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(m);
                    newrow["Month"] = month;
                    newrow["GrossPay"] = dr["gross"].ToString();
                    newrow["NetPay"] = dr["Netpay"].ToString();
                    Report.Rows.Add(newrow);
                }
                GrdProducts.DataSource = Report;
                GrdProducts.DataBind();
                hidepanel.Visible = true;
            }

            ScriptManager.RegisterStartupScript(Page, GetType(), "JsStatus", "PopupOpen();", true);
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }
}