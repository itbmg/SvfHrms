using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class ApproveSimReport : System.Web.UI.Page
{
    SqlCommand cmd;
    string BranchID = "";
    DBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["branchid"] == null)
            Response.Redirect("Login.aspx");
        else
        {
            BranchID = Session["branchid"].ToString();
            vdm = new DBManager();
            if (!Page.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    GetReport();
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                }
            }
        }
    }
    DataTable Report = new DataTable();
    void GetReport()
    {
        try
        {
            lblmsg.Text = "";
            lblHeading.Text = " Approve Sim Report ";
            DataTable dtDriver = new DataTable();
            Session["title"] = " Approve Sim Report";
            Session["filename"] = " Approve Sim Report ";
            string mainbranch = Session["mainbranch"].ToString();
            //if (ddltype.SelectedItem.Text == "Location")
            //{
            Report.Columns.Add("Sno");
            Report.Columns.Add("Employe Name");
            Report.Columns.Add("Phone Number");
            Report.Columns.Add("Aprrove By");
            //branchmapping
            cmd = new SqlCommand("SELECT employedetails.fullname, issue_simcarddetails.aprovedby, issue_simcarddetails.networktype, issue_simcarddetails.phoneno,employedetails_1.fullname AS Expr1 FROM employedetails INNER JOIN issue_simcarddetails ON employedetails.empid = issue_simcarddetails.empid INNER JOIN employedetails AS employedetails_1 ON issue_simcarddetails.aprovedby = employedetails_1.empid");
           
            //breanch wise
            //cmd = new SqlCommand("SELECT count(employedetails.empid) as Count, branchmaster.branchname, SUM(pay_structure.gross) AS gros FROM branchmaster INNER JOIN employedetails ON branchmaster.branchid = employedetails.branchid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid  Group BY branchmaster.branchname ");
            dtDriver = vdm.SelectQuery(cmd).Tables[0];
            if (dtDriver.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow dr in dtDriver.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    newrow["Employe Name"] = dr["fullname"].ToString();
                    newrow["Phone Number"] = dr["phoneno"].ToString();
                    newrow["Aprrove By"] = dr["Expr1"].ToString();
                    Report.Rows.Add(newrow);

                }
                //}
                //DataRow newTotal = Report.NewRow();
                //newTotal["Employe Name"] = "Total";
                //double val = 0.0;
                //foreach (DataColumn dc in Report.Columns)
                //{
                //    if (dc.DataType == typeof(Double))
                //    {
                //        val = 0.0;
                //        double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out val);
                //        newTotal[dc.ToString()] = val;
                //    }
                //}
                //Report.Rows.Add(newTotal);
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
            if (e.Row.Cells[1].Text == "Total")
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