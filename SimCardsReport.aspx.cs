using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class SimCardsReport : System.Web.UI.Page
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
            lblHeading.Text =  " Sim Cards Report ";
            DataTable dtDriver = new DataTable();
            Session["title"] = " Sim Cards Report";
            Session["filename"] =  " Sim Cards Report ";
            string mainbranch = Session["mainbranch"].ToString();
            //if (ddltype.SelectedItem.Text == "Location")
            //{
                Report.Columns.Add("Sno");
                Report.Columns.Add("Network");
                Report.Columns.Add("Type Of Sim");
                Report.Columns.Add("Phone Number");
                //branchmapping
                cmd = new SqlCommand("SELECT  typeofsim, phoneno, networktype FROM sim_carddetails GROUP BY typeofsim, phoneno, networktype");
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
                        newrow["Network"] = dr["networktype"].ToString();
                        newrow["Type Of Sim"] = dr["typeofsim"].ToString();
                        newrow["Phone Number"] = dr["phoneno"].ToString();
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
        }
    }
}