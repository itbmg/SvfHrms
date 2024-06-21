using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class compensationconsolidedstatement : System.Web.UI.Page
{
    ///string BranchID = "";
    SqlCommand cmd;
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
                DateTime dtfrom = DateTime.Now.AddMonths(-1);
                //dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                //dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
                PopulateYear();
                PopulateMonth();
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

    private void PopulateMonth()
    {
        ddlfrompayroll.Items.Clear();
        DateTime ddt = DateTime.Now;
        string year = ddt.Year.ToString();
        ListItem lt = new ListItem();
        lt.Text = "Select Period";
        lt.Value = "0";
        ddlfrompayroll.Items.Add(lt);
        for (int i = 1; i <= 12; i++)
        {
            lt = new ListItem();
            lt.Text = Convert.ToDateTime(i.ToString() + "/1/" + year + "").ToString("MMM-yyyy");
            lt.Value = i.ToString();
            ddlfrompayroll.Items.Add(lt);
        }
        ddlfrompayroll.Items.FindByValue(DateTime.Now.Month.ToString()).Selected = true;
    }

    private void PopulateYear()
    {
        ddltopayroll.Items.Clear();
        DateTime ddt = DateTime.Now;
        string year = ddt.Year.ToString();
        ListItem lt = new ListItem();
        lt.Text = "Select Period";
        lt.Value = "0";
        ddltopayroll.Items.Add(lt);
        for (int i = 1; i <= 12; i++)
        {
            lt = new ListItem();
            lt.Text = Convert.ToDateTime(i.ToString() + "/1/" + year + "").ToString("MMM-yyyy");
            lt.Value = i.ToString();
            ddltopayroll.Items.Add(lt);
        }
        ddltopayroll.Items.FindByValue(DateTime.Now.Month.ToString()).Selected = true;
    }

    DataTable Report = new DataTable();

    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            string amonth = "";
            string ayear = "";
            DateTime dtfrom = DateTime.Now;
            string frmdate = dtfrom.ToString("MM/dd/yyyy");
            string[] str = frmdate.Split('/');
            amonth = str[0];
            string day = (dtfrom.Day).ToString();
            ayear = str[2];
            string date = amonth + "/" + day + "/" + ayear;
            Report.Columns.Add("Sno");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            Report.Columns.Add("Join Date");
            Report.Columns.Add("Amount").DataType = typeof(double);
            vdm = new DBManager();
            string noofmonths = "1";
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            lblHeading.Text = " Compensation item statement-Consolidated" + " " + ddlfrompayroll.SelectedItem.Text + " - " + ddltopayroll.SelectedItem.Text;
            Session["filename"] = " Compensation item statement-Consolidated" + " " + ddlfrompayroll.SelectedItem.Text + " - " + ddltopayroll.SelectedItem.Text;
            Session["title"] = " Compensation item statement-Consolidated" + " " + ddlfrompayroll.SelectedItem.Text + " - " + ddltopayroll.SelectedItem.Text;
           //paystrur
            string mainbranch = Session["mainbranch"].ToString(); 
            //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.empid, employedetails.fullname, pay_structure.salaryperyear, employedetails.joindate FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch  INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid WHERE (branchmapping.mainbranch = @m)");
           cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.empid, employedetails.fullname, employedetails.joindate, salaryappraisals.gross, salaryappraisals.salaryperyear FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid WHERE (branchmapping.mainbranch = @m) AND (employedetails.status = 'NO') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (branchmapping.mainbranch = @m) AND (employedetails.status = 'NO') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
           cmd.Parameters.Add("@m", mainbranch);
           cmd.Parameters.Add("@d1", date);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            int i = 1;
            foreach (DataRow dr in routes.Rows)
            {
                DataRow newrow = Report.NewRow();
                newrow["Sno"] = i++;
                string empid = dr["empid"].ToString();
                string empsno = empid;
                string empname = dr["fullname"].ToString();
                //string joidate = dr["joindate"].ToString();
                string salary = dr["salaryperyear"].ToString();
                string employeid = dr["employee_num"].ToString();
                double grosssal = Convert.ToDouble(dr["salaryperyear"].ToString());
                newrow["Employee Code"] = employeid;
                newrow["Name"] = empname;
                newrow["Amount"] = grosssal;
                string jondate = dr["joindate"].ToString();
                DateTime fdate = Convert.ToDateTime(jondate);
                string joindate = fdate.ToString("dd-MMM-yyyy");
                newrow["Join Date"] = joindate;
                Report.Rows.Add(newrow);
            }
            grdReports.DataSource = Report;
            grdReports.DataBind();
            Session["xportdata"] = Report;
            hidepanel.Visible = true;
        }
        catch (Exception ex)
        {
            throw ex;
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
            //{ddlcompantype
            //    e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
            //    e.Row.Font.Size = FontUnit.Large;
            //    e.Row.Font.Bold = true;
            //}
        }
    }
}