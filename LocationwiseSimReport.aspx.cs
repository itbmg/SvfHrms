using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class LocationwiseSimReport : System.Web.UI.Page
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

                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                }
            }
        }
    }
    DataTable Report = new DataTable();
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            lblHeading.Text = ddltype.SelectedItem.Text + " location Wise Sime Report ";
            DataTable dtDriver = new DataTable();
            Session["title"] = ddltype.SelectedItem.Text + " location Wise Sime Report ";
            Session["filename"] = ddltype.SelectedItem.Text + " location Wise Sime Report ";
            string mainbranch = Session["mainbranch"].ToString();
            if (ddltype.SelectedItem.Text == "Location")
            {
                Report.Columns.Add("Sno");
                Report.Columns.Add("Location");
                Report.Columns.Add("Network");
                Report.Columns.Add("NO OF sims").DataType = typeof(double);
                //branchmapping
                cmd = new SqlCommand("SELECT COUNT(employedetails.empid) AS Count, branchmaster.branchname, issue_simcarddetails.networktype, issue_simcarddetails.phoneno FROM branchmaster INNER JOIN employedetails ON branchmaster.branchid = employedetails.branchid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN issue_simcarddetails ON employedetails.empid = issue_simcarddetails.empid WHERE (branchmapping.mainbranch = @m) AND (employedetails.status = 'NO')GROUP BY branchmaster.branchname, issue_simcarddetails.networktype, issue_simcarddetails.phoneno");
                cmd.Parameters.Add("@m", mainbranch);
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
                        newrow["Location"] = dr["branchname"].ToString();
                        newrow["Network"] = dr["networktype"].ToString();
                        newrow["NO OF sims"] = dr["Count"].ToString();
                        Report.Rows.Add(newrow);

                    }
                }
                DataRow newTotal = Report.NewRow();
                newTotal["Location"] = "Total";
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
            }

            else if (ddltype.SelectedItem.Text == "Department")
            {
                Report.Columns.Add("Sno");
                Report.Columns.Add("Department");
                Report.Columns.Add("Salary").DataType = typeof(double);
                Report.Columns.Add("NO OF Employees").DataType = typeof(double);
                //branchwise
                //cmd = new SqlCommand("SELECT COUNT(employedetails.empid) AS Count, SUM(pay_structure.gross) AS gros, departments.department FROM employedetails INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN departments ON employedetails.employee_dept = departments.deptid GROUP BY departments.department ");
                //branchmapping
                cmd = new SqlCommand("SELECT  COUNT(employedetails.empid) AS Count, SUM(pay_structure.gross) AS gros, departments.department FROM employedetails INNER JOIN departments ON employedetails.employee_dept = departments.deptid INNER JOIN  branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN  pay_structure ON employedetails.empid = pay_structure.empid WHERE (branchmapping.mainbranch = @m) AND (employedetails.status = 'No')GROUP BY departments.department ");
                cmd.Parameters.Add("@m", mainbranch);
                dtDriver = vdm.SelectQuery(cmd).Tables[0];
                if (dtDriver.Rows.Count > 0)
                {
                    int i = 1;
                    foreach (DataRow dr in dtDriver.Rows)
                    {
                        DataRow newrow = Report.NewRow();
                        newrow["Sno"] = i++.ToString();
                        newrow["Department"] = dr["department"].ToString();
                        newrow["Salary"] = dr["gros"].ToString();
                        newrow["NO OF Employees"] = dr["Count"].ToString();
                        Report.Rows.Add(newrow);
                    }
                }
                DataRow newTotal = Report.NewRow();
                newTotal["Department"] = "Total";
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