using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class DashBoard_alerts : System.Web.UI.Page
{
    //SqlCommand cmd;
    //string userid = "";
    //DBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    //private void PopulateMonth()
    //{

    //    ddlmonth.Items.Clear();
    //    ListItem lt = new ListItem();
    //    lt.Text = "MM";
    //    lt.Value = "00";
    //    ddlmonth.Items.Add(lt);
    //    for (int i = 1; i <= 12; i++)
    //    {
    //        lt = new ListItem();
    //        lt.Text = Convert.ToDateTime(i.ToString() + "/1/1900").ToString("MMMM");
    //        lt.Value = i.ToString();
    //        ddlmonth.Items.Add(lt);
    //    }
    //    ddlmonth.Items.FindByValue(DateTime.Now.Month.ToString()).Selected = true;
    //}

    //private void PopulateYear()
    //{

    //    ddlyear.Items.Clear();
    //    ListItem lt = new ListItem();
    //    lt.Text = "YYYY";
    //    lt.Value = "0";
    //    ddlyear.Items.Add(lt);
    //    for (int i = DateTime.Now.Year; i >= 1970; i--)
    //    {
    //        lt = new ListItem();
    //        lt.Text = i.ToString();
    //        lt.Value = i.ToString();
    //        ddlyear.Items.Add(lt);
    //    }
    //    ddlyear.Items.FindByValue(DateTime.Now.Year.ToString()).Selected = true;
    //}
    //private void bindbranchs()
    //{

    //    DBManager SalesDB = new DBManager();
    //    //branchwise
    //    //cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='1'");
    //    string mainbranch = Session["mainbranch"].ToString();
    //    //branch mapping
    //    cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
    //    cmd.Parameters.Add("@m", mainbranch);
    //    DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
    //    ddlbranch.DataSource = dttrips;
    //    ddlbranch.DataTextField = "branchname";
    //    ddlbranch.DataValueField = "branchid";
    //    ddlbranch.DataBind();
    //    ddlbranch.ClearSelection();
    //    ddlbranch.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
    //    ddlbranch.SelectedValue = "0";
    //}

    //protected void btn_Generate_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        DBManager SalesDB = new DBManager();
    //        DateTime fromdate = DateTime.Now;
    //        DateTime mydate = DateTime.Now;
    //        //string year = "2016";
    //        string year = ddlyear.SelectedItem.Value;
    //        //string currentyear = (mydate.Year).ToString();
    //        string mymonth = ddlmonth.SelectedItem.Value;
    //        int month = Convert.ToInt32(mymonth);
    //        int years = Convert.ToInt32(year);
    //        string day = "";
    //        if (mymonth == "02")
    //        {
    //            day = "28";
    //        }
    //        else
    //        {
    //            day = (mydate.Day).ToString();
    //            int days = DateTime.DaysInMonth(years, month);
    //            int cmdays = Convert.ToInt32(day);
    //            if (cmdays > days)
    //            {
    //                day = days.ToString();
    //            }
    //        }
    //        string date = mymonth + "/" + day + "/" + year;
    //        DateTime dtfrom = fromdate;
    //        string frmdate = dtfrom.ToString("dd/MM/yyyy");
    //        string[] str = frmdate.Split('/');
    //        lblFromDate.Text = mymonth;
    //        string mainbranch = ddlbranch.SelectedItem.Value;
    //        cmd = new SqlCommand("SELECT branchmaster.branchname, monthlysalarystatement.branchid, monthlysalarystatement.month FROM branchmaster INNER JOIN monthlysalarystatement ON branchmaster.branchid = monthlysalarystatement.branchid INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE(monthlysalarystatement.month = @month) AND (monthlysalarystatement.year = @year) AND (branchmapping.mainbranch = @m)GROUP BY monthlysalarystatement.branchid, branchmaster.branchname,monthlysalarystatement.month ");
    //        cmd.Parameters.Add("@month", month);
    //        cmd.Parameters.Add("@year", year);
    //        cmd.Parameters.Add("@m", mainbranch);
    //        DataTable dtVehicles = vdm.SelectQuery(cmd).Tables[0];

    //        cmd = new SqlCommand("SELECT branchmaster.branchname, branchmaster.branchid FROM branchmaster INNER JOIN branchmapping ON branchmapping.subbranch = branchmaster.branchid WHERE branchmapping.mainbranch = @mainbranch ");
    //        cmd.Parameters.Add("@mainbranch", mainbranch);
    //        DataTable dtbranches = vdm.SelectQuery(cmd).Tables[0];
    //    }
    //    catch (Exception ex)
    //    {
    //        lblmsg.Text = ex.Message;            
    //    }
    //}
    
}