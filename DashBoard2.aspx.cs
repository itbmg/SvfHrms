using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class DashBoard2 : System.Web.UI.Page
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
                    //branchanddepartmentwisesalary();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    string fryear = dtyear.ToString("dd/MM/yyyy");
                    string[] str1 = fryear.Split('/');
                }
            }
        }
    }
    //protected void grdReports_DataBinding(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        string mainb = Session["mainbranch"].ToString();
           
    //            GridViewGroup First = new GridViewGroup(grdReports, null, "DEPT");
    //            // GridViewGroup three = new GridViewGroup(grdReports, seconf, "PF");
           
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //}
    //DataTable Report = new DataTable();
    //protected void branchanddepartmentwisesalary()
    //{
    //    try
    //    {
    //        DBManager SalesDB = new DBManager();
    //        DateTime mydate = DateTime.Now;
    //        //Report.Columns.Add("NET PAY").DataType = typeof(double);
    //        Report.Columns.Add("Branchname");
    //        //Report.Columns.Add("Department");
    //        DateTime dt = DateTime.Now;
    //        dt = dt.AddMonths(-2);
    //        int month = dt.Month;
    //        int Year = mydate.Year;
    //        string mainbranch = Session["mainbranch"].ToString();
    //        cmd = new SqlCommand("SELECT SUM(CAST(monthlysalarystatement.netpay AS numeric(9, 2))) AS Netpay, departments.department, branchmaster.branchname FROM monthlysalarystatement INNER JOIN branchmapping ON monthlysalarystatement.branchid = branchmapping.subbranch INNER JOIN branchmaster ON monthlysalarystatement.branchid = branchmaster.branchid INNER JOIN departments ON monthlysalarystatement.deptid = departments.deptid WHERE (monthlysalarystatement.month = @month) AND (monthlysalarystatement.year = @year) AND (branchmapping.mainbranch = @m) GROUP BY departments.department, branchmaster.branchname");
    //        cmd.Parameters.Add("@m", mainbranch);
    //        cmd.Parameters.Add("@month", month);
    //        cmd.Parameters.Add("@year", Year);
    //        DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
    //        if (dtsalary.Rows.Count > 0)
    //        {
    //            var i = 1;
    //            foreach (DataRow dr in dtsalary.Rows)
    //            {
    //                string depart=dr["department"].ToString();
    //                DataRow newrow = Report.NewRow();
    //                Report.Columns.Add(dr["department"].ToString(), typeof(System.Int32));
    //                newrow["Branchname"] = dr["branchname"].ToString();
    //                if (depart == depart)
    //                {
    //                    //newrow[dr["department"].ToString()] = dr["Netpay"].ToString();
    //                }
                    
                    
    //                Report.Rows.Add(newrow);
    //            }
    //        }
    //        DataRow newTotal = Report.NewRow();
    //        newTotal["Branchnames"] = "Total Amount";
    //        double val = 0.0;
    //        foreach (DataColumn dc in Report.Columns)
    //        {
    //            if (dc.DataType == typeof(Double))
    //            {
    //                val = 0.0;
    //                double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out val);
    //                if (val == 0.0)
    //                {
    //                }
    //                else
    //                {
    //                    newTotal[dc.ToString()] = val;
    //                }
    //            }
    //        }
    //        Report.Rows.Add(newTotal);
    //        foreach (var column in Report.Columns.Cast<DataColumn>().ToArray())
    //        {
    //            if (Report.AsEnumerable().All(dr => dr.IsNull(column)))
    //                Report.Columns.Remove(column);
    //        }
    //        grdReports.DataSource = Report;
    //        grdReports.DataBind();
    //        Session["xportdata"] = Report;
    //    }

    //    catch (Exception ex)
    //    {
    //    }
    //}

    //protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    //{
    //    if (e.Row.RowType == DataControlRowType.DataRow)
    //    {
    //        //e.Row.Cells[4].Visible = false;
    //        if (e.Row.Cells.Count > 2)
    //        {
    //            if (e.Row.Cells[3].Text == "Total Amount")
    //            {
    //                e.Row.BackColor = System.Drawing.Color.Aquamarine;
    //                e.Row.Font.Size = FontUnit.Large;
    //                e.Row.Font.Bold = true;

    //            }
    //        }

    //    }
    //}
}