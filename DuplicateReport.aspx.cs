using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class Duplicate : System.Web.UI.Page
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
                    DateTime dtfrom = DateTime.Now.AddMonths(-1);
                    //dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    //bindbranchs();
                    //string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    //string[] str = frmdate.Split('/');
                    //ddlmonth.SelectedValue = str[1];
                }
            }
        }
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

    //private void bindbranchs()
    //{

    //    DBManager SalesDB = new DBManager();
    //    cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='1'");
    //    DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
    //    ddlbranch.DataSource = dttrips;
    //    ddlbranch.DataTextField = "branchname";
    //    ddlbranch.DataValueField = "branchid";
    //    ddlbranch.DataBind();
    //    ddlbranch.ClearSelection();
    //    ddlbranch.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
    //    ddlbranch.SelectedValue = "0";
    //}

    DataTable Report = new DataTable();
    protected void btn_Generate_Click(object sender, EventArgs e)
    {

        try
        {
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            //string year = (mydate.Year).ToString();
            string type = ddlbranch.SelectedItem.Value;
            lblHeading.Text = ddlbranch.SelectedItem.Text + " Duplicate Report";
            string mainbranch = Session["mainbranch"].ToString();
            Session["filename"] = ddlbranch.SelectedItem.Text + "Duplicate Report ";
            Session["title"] = ddlbranch.SelectedItem.Text + " Duplicate Report ";
            if (ddlbranch.SelectedItem.Text == "Bank Account Number")
            {
                Report.Columns.Add("SNO");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("Bank Account Number");
                Report.Columns.Add("Employee Status");
                Report.Columns.Add("Leaving Date");
                //branchwise
                //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employebankdetails.accountno, employebankdetails.employeid, employedetails.joindate, employedetails.status FROM employedetails INNER JOIN  employebankdetails ON employedetails.empid = employebankdetails.employeid GROUP BY employedetails.employee_num, employedetails.fullname, employebankdetails.accountno, employebankdetails.employeid, employedetails.joindate, employedetails.status Having (COUNT(employebankdetails.accountno) > 1)");
                //branchmapping
                //string mainbranch = Session["mainbranch"].ToString(); 
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employebankdetails.accountno, employebankdetails.employeid, employedetails.joindate, employedetails.status FROM  employedetails INNER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)GROUP BY employedetails.employee_num, employedetails.fullname, employebankdetails.accountno, employebankdetails.employeid, employedetails.joindate,  employedetails.status HAVING  (COUNT(employebankdetails.accountno) > 1)");
                cmd.Parameters.Add("@m", mainbranch);
                //cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
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
                        newrow["Bank Account Number"] = dr["accountno"].ToString();
                        newrow["Employee Status"] = dr["status"].ToString();
                        newrow["Leaving Date"] = dr["joindate"].ToString();
                        Report.Rows.Add(newrow);
                    }
                }
                
            }
            if (ddlbranch.SelectedItem.Text == "PAN Number")
            {
                Report.Columns.Add("SNO");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("PAN Number");
                Report.Columns.Add("Employee Status");
                Report.Columns.Add("Leaving Date");
                //branchwise
                //cmd = new SqlCommand("SELECT  employee_num, fullname, joindate, status, pancard FROM  employedetails GROUP BY employee_num, fullname, joindate, status, pancard Having (COUNT(employee_num) > 1)");
                //branchmapping
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employedetails.pancard FROM  employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)GROUP BY employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employedetails.pancard HAVING(COUNT(employedetails.employee_num) > 1)");
                //cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@m", mainbranch);
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
                        newrow["PAN Number"] = dr["pancard"].ToString();
                        newrow["Employee Status"] = dr["status"].ToString();
                        newrow["Leaving Date"] = ((DateTime)dr["joindate"]).ToString("dd/MMM/yyyy");//dr["joindate"].ToString();
                        Report.Rows.Add(newrow);
                    }
                }
                
            }

            else if (ddlbranch.SelectedItem.Text == "ESI Number")
            {
                Report.Columns.Add("SNO");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("ESI Number");
                Report.Columns.Add("Employee Status");
                Report.Columns.Add("Leaving Date");
                // branchwise
                // cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employepfdetails.estnumber FROM  employedetails INNER JOIN  employepfdetails ON employedetails.empid = employepfdetails.employeid GROUP BY employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employepfdetails.estnumber Having (COUNT(employepfdetails.estnumber) > 1)");
                //branchmapping
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employepfdetails.estnumber FROM employedetails INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch where (branchmapping.mainbranch = @m)GROUP BY employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employepfdetails.estnumber HAVING (COUNT(employepfdetails.estnumber) > 1)");
                //cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
                cmd.Parameters.Add("@m", mainbranch);
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
                        newrow["ESI Number"] = dr["estnumber"].ToString();
                        newrow["Employee Status"] = dr["status"].ToString();
                        newrow["Leaving Date"] = ((DateTime)dr["joindate"]).ToString("dd/MMM/yyyy"); // dr["joindate"].ToString();
                        Report.Rows.Add(newrow);
                    }
                }
                

            }
            else if (ddlbranch.SelectedItem.Text == "PF Number")
            {
                Report.Columns.Add("SNO");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("PF Number");
                Report.Columns.Add("Employee Status");
                Report.Columns.Add("Leaving Date");
                //branchwise
                //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employepfdetails.pfnumber FROM employedetails INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid GROUP BY employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employepfdetails.pfnumber Having (COUNT(employepfdetails.pfnumber) > 1)");
                //branchmapping
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employepfdetails.pfnumber FROM  employedetails INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m) GROUP BY employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employepfdetails.pfnumber HAVING (COUNT(employepfdetails.pfnumber) > 1)");
                cmd.Parameters.Add("@m", mainbranch);
                //cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
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
                        newrow["PF Number"] = dr["pfnumber"].ToString();
                        newrow["Employee Status"] = dr["status"].ToString();
                        newrow["Leaving Date"] = ((DateTime)dr["joindate"]).ToString("dd/MMM/yyyy"); //dr["joindate"].ToString();
                        Report.Rows.Add(newrow);
                    }
                }
                

            }
            else if (ddlbranch.SelectedItem.Text == "UAN Number")
            {
                Report.Columns.Add("SNO");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("UAN Number");
                Report.Columns.Add("Employee Status");
                Report.Columns.Add("Leaving Date");
                //branchwise
                //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employepfdetails.uannumber FROM employedetails INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid GROUP BY employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employepfdetails.uannumber Having (COUNT(employepfdetails.uannumber) > 1)");
                //branchmapping
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employepfdetails.uannumber FROM  employedetails INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid INNER JOIN  branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)GROUP BY employedetails.employee_num, employedetails.fullname, employedetails.joindate, employedetails.status, employepfdetails.uannumber HAVING (COUNT(employepfdetails.uannumber) > 1)");
                cmd.Parameters.Add("@m", mainbranch);
                //cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
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
                        newrow["UAN Number"] = dr["uannumber"].ToString();
                        newrow["Employee Status"] = dr["status"].ToString();
                        newrow["Leaving Date"] = ((DateTime)dr["joindate"]).ToString("dd/MMM/yyyy");// dr["joindate"].ToString();
                        Report.Rows.Add(newrow);
                    }
                }
                

            }
            hidepanel.Visible = true;
            grdReports.DataSource = Report;
            if (Report.Rows.Count > 1)
            {
                grdReports.DataBind();
                Session["xportdata"] = Report;
                hidepanel.Visible = true;
            }
            else
            {
                hidepanel.Visible = false;
                lblmsg.Text = "No Data Found";
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
            if (e.Row.Cells[3].Text == "Total")
            {
                e.Row.BackColor = System.Drawing.Color.Aquamarine;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
            //if (e.Row.Cells[3].Text == "Grand Total")
            //{
            //    e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
            //    e.Row.Font.Size = FontUnit.Large;
            //    e.Row.Font.Bold = true;
            //}
        }
    }
}