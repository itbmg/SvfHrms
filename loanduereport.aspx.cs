using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class loanduereport : System.Web.UI.Page
{
    SqlCommand cmd;
    ///string BranchID = "";
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
                DateTime dtyear = DateTime.Now.AddMonths(0);
               
                fillloanduedetails();
              
            }
        }
    }
   
   
    DataTable Report = new DataTable();
    public void fillloanduedetails()
    {

        try
        {
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            DateTime fromdate = DateTime.Now;
            DateTime todate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            Report.Columns.Add("Sno");
            Report.Columns.Add("Employee Name");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Designation");
            Report.Columns.Add("Exp");
            Report.Columns.Add("Date");
            Report.Columns.Add("Loan No");
            Report.Columns.Add("Loan Amount");
            Report.Columns.Add("Loan Bal Amount");
            Report.Columns.Add("EMI Amount");
            Report.Columns.Add("EMI Date");
            Report.Columns.Add("Total Instalments");
            Report.Columns.Add("Paid");
            Report.Columns.Add("Remaining Months");
            Report.Columns.Add("Balance").DataType = typeof(double);

            cmd = new SqlCommand("SELECT loan_request_form.loanamount, loan_request_form.loanbalamount, loan_request_form.months, loan_request_form.loanemimonth, SUM(ISNULL(CAST(loan_request.loanemimonth AS float), 0)) AS Amt, loan_request.empid,loan_request.loanrefno FROM   loan_request INNER JOIN loan_request_form ON loan_request.loanrefno = loan_request_form.sno WHERE (loan_request.status = 'C') GROUP BY loan_request_form.loanamount, loan_request_form.loanbalamount, loan_request.empid, loan_request.loanrefno,loan_request_form.months, loan_request_form.loanemimonth ORDER BY loan_request.loanrefno");
            DataTable dtloandue = SalesDB.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT  employedetails.joindate, employedetails.fullname, designation.designation, employedetails.employee_num, employedetails.empid   FROM  employedetails INNER JOIN  designation ON employedetails.designationid = designation.designationid");
            DataTable dtAdvance = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtloandue.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtloandue.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    string empid = dr["empid"].ToString();
                    foreach (DataRow dra in dtAdvance.Select("empid='" + empid + "'"))
                    {
                        newrow["Employee Code"] = dra["employee_num"].ToString();
                        newrow["Employee Name"] = dra["fullname"].ToString();
                        newrow["Designation"] = dra["designation"].ToString();
                        string joindate = dra["joindate"].ToString();
                        if (joindate != "")
                        {
                            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
                            DateTime dtjoindate = Convert.ToDateTime(joindate);
                            int days = (ServerDateCurrentdate - dtjoindate).Days;
                            double year = days / 365;
                            newrow["Exp"] = year.ToString();
                        }

                    }
                    newrow["Date"] = "";
                    newrow["Loan No"] = dr["loanrefno"].ToString();
                    newrow["Loan Amount"] = dr["loanamount"].ToString();
                    newrow["Loan Bal Amount"] = dr["loanbalamount"].ToString();
                    string balamount = dr["loanbalamount"].ToString();
                    double bamt = Convert.ToDouble(balamount);
                    newrow["EMI Amount"] = dr["loanemimonth"].ToString();
                    string loanemi = dr["loanemimonth"].ToString();
                    double emided = Convert.ToDouble(loanemi);
                    newrow["EMI Date"] = "";
                    newrow["Total Instalments"] = dr["months"].ToString();
                    string paidamount = dr["Amt"].ToString();
                    double pamt = Convert.ToDouble(paidamount);
                    double diffamt = bamt - pamt;
                    double emi = diffamt / emided;
                    double totalinstalments = Convert.ToDouble(dr["months"].ToString());
                    newrow["Paid"] = totalinstalments - Math.Round(emi);
                    newrow["Remaining Months"] = Math.Round(emi).ToString();
                    newrow["Balance"] = diffamt.ToString();
                    Report.Rows.Add(newrow);
                }
                DataRow newTotal = Report.NewRow();
                newTotal["Employee Name"] = "Total Amount";
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
                if (Report.Rows.Count > 1)
                {
                    grdReports.DataBind();
                    Session["xportdata"] = Report;
                    hidepanel.Visible = true;
                }
                else
                {
                    lblmsg.Text = "No data  found";
                    hidepanel.Visible = false;
                }
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
            //if (e.Row.Cells[3].Text == "Grand Total")
            //{
            //    e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
            //    e.Row.Font.Size = FontUnit.Large;
            //    e.Row.Font.Bold = true;
            //}
        }
    }
}