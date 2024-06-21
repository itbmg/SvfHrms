using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class PayrollReconciliationReport_ : System.Web.UI.Page
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
                    DateTime dtto = DateTime.Now.AddMonths(-1);
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    bindbranchs();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    ddlmonth.SelectedValue = str[1];
                    string todate = dtto.ToString("dd/MM/yyyy");
                    string[] srt = todate.Split('/');
                    ddlmonth1.SelectedValue = srt[0];
                }
            }
        }
    }
    private void bindbranchs()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT branchid, branchname FROM branchmaster");
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlbranches.DataSource = dttrips;
        ddlbranches.DataTextField = "branchname";
        ddlbranches.DataValueField = "branchid";
        ddlbranches.DataBind();
        ddlbranches.ClearSelection();
        ddlbranches.Items.Insert(0, new ListItem { Value = "0", Text = "Select Branch", Selected = true });
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
            Report.Columns.Add("sno");
            Report.Columns.Add("Components");
            Report.Columns.Add("Head Count");
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();

            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            string year = (mydate.Year).ToString();
            string mymonth = ddlmonth.SelectedItem.Value;
            string day = (mydate.Day).ToString();
            string d = "00";
            string date = mymonth + "/" + day + "/" + year;
            lblFromDate.Text = mymonth;
            //fromdate = Convert.ToDateTime(date);
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");

            DateTime todate = DateTime.Now;
            DateTime mydate1 = DateTime.Now;
            string year1 = (mydate.Year).ToString();
            string mymonth1 = ddlmonth1.SelectedItem.Value;
            string day1 = (mydate.Day).ToString();
            string d1 = "00";
            string date1 = mymonth1 + "/" + day1 + "/" + year1;
            lblFromDate.Text = mymonth;
            //fromdate = Convert.ToDateTime(date);
            DateTime dtto = todate;
            string toodate = dtto.ToString("dd/MM/yyyy");
            cmd = new SqlCommand("SELECT  count(employedetails.empid) as count, employedetails.employee_num, employedetails.joindate,branchmaster.branchname, employedetails.fullname, employedetails.empid, branchmaster.todate, branchmaster.fromdate, employedetails.doe FROM employedetails INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid where employedetails.doe between @frommonth and @tomonth  ORDER BY branchmaster.branchname");
            cmd.Parameters.Add("@frommonth", mymonth);
            cmd.Parameters.Add("@tomonth",mymonth1);
            DataTable dtemployee = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtemployee.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtemployee.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["sno"] = i++.ToString();
                    newrow["Components"] = dr["branchmaster"].ToString();
                    newrow["Head Count"] = dr["count"].ToString();
                    Report.Rows.Add(newrow);
                }

                DataRow newtotal = Report.NewRow();
                Report.Rows.Add(newtotal);
                grdReports.DataSource = Report;
                grdReports.DataBind();
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

}