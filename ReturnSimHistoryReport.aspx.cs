using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class ReturnSimHistoryReport : System.Web.UI.Page
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
            lblHeading.Text = " Return Sim History Report ";
            DataTable dtDriver = new DataTable();
            Session["title"] = " Return Sim History Report";
            Session["filename"] = " Return Sim History Report ";
            string mainbranch = Session["mainbranch"].ToString();
            Report.Columns.Add("Sno");
            Report.Columns.Add("Employee Name");
            Report.Columns.Add("Phone Number");
            Report.Columns.Add("Returndate");
            //branchmapping
            cmd = new SqlCommand("SELECT return_simcarddetails.sno, return_simcarddetails.empid, return_simcarddetails.empcode, return_simcarddetails.phoneno, return_simcarddetails.returndate, employedetails.fullname FROM return_simcarddetails INNER JOIN employedetails ON return_simcarddetails.empid = employedetails.empid");
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
                    newrow["Employee Name"] = dr["fullname"].ToString();
                    newrow["Phone Number"] = dr["phoneno"].ToString();

                    DateTime returndate = Convert.ToDateTime(dr["returndate"].ToString());
                    string dreturndate = returndate.ToString("dd/MMM/yyyy");
                    newrow["Returndate"] = dreturndate;
                    //newrow["Returndate"] = dr["returndate"].ToString();
                    Report.Rows.Add(newrow);

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