using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
public partial class sumaryrpt : System.Web.UI.Page
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
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    bindbranchs();
                    PopulateYear();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    ddlmonth.SelectedValue = str[1];
                }
            }
        }
    }

    private void PopulateMonth()
    {

        ddlmonth.Items.Clear();
        ListItem lt = new ListItem();
        lt.Text = "MM";
        lt.Value = "00";
        ddlmonth.Items.Add(lt);
        for (int i = 1; i <= 12; i++)
        {
            lt = new ListItem();
            lt.Text = Convert.ToDateTime(i.ToString() + "/1/1900").ToString("MMMM");
            lt.Value = i.ToString();
            ddlmonth.Items.Add(lt);
        }
        ddlmonth.Items.FindByValue(DateTime.Now.Month.ToString()).Selected = true;
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

        DBManager SalesDB = new DBManager();
        //branchwise
        //cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='1'");
        string mainbranch = Session["mainbranch"].ToString();

        string sbranchid = Session["branchid"].ToString();
        string scmpcode = Session["company_code"].ToString();
        if (sbranchid == "1" || sbranchid == "6")
        {
            cmd = new SqlCommand("SELECT sno,companyname,address,phoneno,mailid,tinno FROM company_master");
        }
        else
        {
            cmd = new SqlCommand("SELECT sno,companyname,address,phoneno,mailid,tinno FROM company_master where sno=@sno");
            cmd.Parameters.Add("@sno", scmpcode);
        }
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlcompany.DataSource = dttrips;
        ddlcompany.DataTextField = "companyname";
        ddlcompany.DataValueField = "sno";
        ddlcompany.DataBind();
        ddlcompany.ClearSelection();
        ddlcompany.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Company--", Selected = true });
        ddlcompany.SelectedValue = "0";
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
            //string year = "2016";
            string year = ddlyear.SelectedItem.Value;
            //string currentyear = (mydate.Year).ToString();
            string mymonth = ddlmonth.SelectedItem.Value;
            int month = Convert.ToInt32(mymonth);
            int years = Convert.ToInt32(year);
            string day = "";
            if (mymonth == "02")
            {
                day = "28";
            }
            else
            {
                day = (mydate.Day).ToString();
                int days = DateTime.DaysInMonth(years, month);
                int cmdays = Convert.ToInt32(day);
                if (cmdays > days)
                {
                    day = days.ToString();
                }
            }
            string date = mymonth + "/" + day + "/" + year;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth;
            fromdate = Convert.ToDateTime(date);
            lblHeading.Text = "Summary Statement For The Month Of " + " " + ddlmonth.SelectedItem.Text + " " + year;
            Session["filename"] =  " Summary Statement " + " " + ddlmonth.SelectedItem.Text + " " + year;
            Session["title"] =  " Summary Statement " + " " + ddlmonth.SelectedItem.Text + " " + year;
            if (ddlcompany.SelectedValue == "0")
            {
                cmd = new SqlCommand("SELECT company_master.address, sno, company_master.companyname FROM company_master");
            }
            else
            {
                cmd = new SqlCommand("SELECT company_master.address, sno, company_master.companyname FROM company_master  WHERE (sno = @cmpid)");
                cmd.Parameters.Add("@cmpid", ddlcompany.SelectedValue);

            }
            DataTable dtcompany = vdm.SelectQuery(cmd).Tables[0];
            if (dtcompany.Rows.Count > 0)
            {
                //Session["Address"] = "Kanumaladoddi Village, 7th Mile,K.G.F Road,Santhipuram Mandal, CHITTOOR DISTRICT 517423";
               // lblAddress.Text = "Kanumaladoddi Village, 7th Mile,K.G.F Road,Santhipuram Mandal, CHITTOOR DISTRICT 517423";
                lblTitle.Text = dtcompany.Rows[0]["companyname"].ToString();
                Session["TitleName"] = dtcompany.Rows[0]["companyname"].ToString();
            }
            else
            {
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
            }
            Report.Columns.Add("Sno");
            Report.Columns.Add("Company Name");
            Report.Columns.Add("Total Salary");
            Report.Columns.Add("Gross Erening");
            Report.Columns.Add("Net Pay");

            if (dtcompany.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow drr in dtcompany.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    newrow["Company Name"] = drr["companyname"].ToString();
                    cmd = new SqlCommand("SELECT SUM(salary) AS totSALARY, SUM(gross) AS GrossErening, SUM(netpay) AS NetPay  FROM   monthlysalarystatement WHERE (cmpid = @ccmpid) AND (month = @month) AND (year = @year) AND (emptype <> 'Casual')");
                    cmd.Parameters.Add("@ccmpid", drr["sno"].ToString());
                    cmd.Parameters.Add("@month", month);
                    cmd.Parameters.Add("@year", year);
                    DataTable dtcompanysal = vdm.SelectQuery(cmd).Tables[0];
                    if (dtcompanysal.Rows.Count > 0)
                    {
                        
                        foreach (DataRow dr in dtcompanysal.Rows)
                        {
                            
                            newrow["Total Salary"] = dr["totSALARY"].ToString();
                            newrow["Gross Erening"] = dr["GrossErening"].ToString();
                            newrow["Net Pay"] = dr["NetPay"].ToString();
                            Report.Rows.Add(newrow);
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
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }

    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //e.Row.Cells[4].Visible = false;
            if (e.Row.Cells.Count > 2)
            {
                if (e.Row.Cells[3].Text == "Total Amount")
                {
                    e.Row.BackColor = System.Drawing.Color.Aquamarine;
                    e.Row.Font.Size = FontUnit.Large;
                    e.Row.Font.Bold = true;

                }
            }
        }
    }

    protected void grdReports_DataBinding(object sender, EventArgs e)
    {
        
    }

    protected void btnlogssave_click(object sender, EventArgs e)
    {
       
    }  
}