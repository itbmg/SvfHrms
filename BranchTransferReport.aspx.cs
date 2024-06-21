using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class BranchTransferReport : System.Web.UI.Page
{
    SqlCommand cmd;
    string userid = "";
    DBManager vdm;

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

    DataTable Report = new DataTable();
    protected void ddlemployee_SelectedIndexChanged(object sender, EventArgs e)
    {
        DBManager SalesDB = new DBManager();
        if (ddlEmployeeType.SelectedValue == "All")
        {
            hideemployee.Visible = false;
        }
        if (ddlEmployeeType.SelectedValue == "Employee Wise")
        {
            hideemployee.Visible = true;
            cmd = new SqlCommand("SELECT empid, employee_num, fullname FROM employedetails ");
            //cmd.Parameters.Add("@BranchID", BranchID);
            DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
            ddlemployee.DataSource = dttrips;
            ddlemployee.DataTextField = "fullname";
            ddlemployee.DataValueField = "empid";
            ddlemployee.DataBind();
        }
    }
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            //string empid = txtsupid.Text;
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            //string year = (mydate.Year).ToString();
            //string type = ddlbranch.SelectedItem.Value;
            //string mymonth = ddlmonth.SelectedItem.Value;
            //string day = (mydate.Day).ToString();
            //string d = "00";
            //string date = mymonth + "/" + day + "/" + year;
            lblHeading.Text = " Employee Branch Transfer  Details";
            //DateTime dtfrom = fromdate;
            //string frmdate = dtfrom.ToString("dd/MM/yyyy");
            //string[] str = frmdate.Split('/');
            //lblFromDate.Text = mymonth;
            //fromdate = Convert.ToDateTime(date);
            Session["filename"] = "Employee Branch Transfer Details ";
            Session["title"] = " Employee Branch Transfer  Details ";
            Report.Columns.Add("SNO");
            Report.Columns.Add("Name");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("From Branch");
            Report.Columns.Add("To Branch");
            Report.Columns.Add("Date");
            if (ddlEmployeeType.SelectedValue == "Employee Wise")
            {
                //lblemployeename.Text = "Batch Name " + ddlemployee.SelectedItem.Text;
                cmd = new SqlCommand("SELECT employedetails.fullname, employee_branchtransfer.sno, employee_branchtransfer.empid, employee_branchtransfer.empcode, employee_branchtransfer.date, branchmaster.branchname, branchmaster_1.branchname AS tobranch FROM  employee_branchtransfer INNER JOIN  employedetails ON employee_branchtransfer.empid = employedetails.empid INNER JOIN branchmaster AS branchmaster_1 ON employee_branchtransfer.tobranch = branchmaster_1.branchid INNER JOIN branchmaster ON employee_branchtransfer.frombranch = branchmaster.branchid WHERE (employedetails.empid = @empid)");
                //cmd.Parameters.Add("@empid", empid);
                cmd.Parameters.Add("@empid", ddlemployee.SelectedValue);
            }

            else
            {
                cmd = new SqlCommand("SELECT  employedetails.fullname, employee_branchtransfer.sno, employee_branchtransfer.empid, employee_branchtransfer.empcode, employee_branchtransfer.date, branchmaster.branchname, branchmaster_1.branchname AS tobranch FROM  employee_branchtransfer INNER JOIN employedetails ON employee_branchtransfer.empid = employedetails.empid INNER JOIN  branchmaster AS branchmaster_1 ON employee_branchtransfer.tobranch = branchmaster_1.branchid INNER JOIN branchmaster ON employee_branchtransfer.frombranch = branchmaster.branchid ");
            }
            //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, salaryadvance.amount, employebankdetails.paymenttype, employebankdetails.employeid, pay_structure.profitionaltax, pay_structure.gross, pay_structure.salaryperyear FROM employedetails INNER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid WHERE (employedetails.branchid = @BranchID)");
            //cmd.Parameters.Add("@empid", empid);
            DataTable dtAdvance = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtAdvance.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtAdvance.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["SNO"] = i++.ToString();
                    newrow["Name"] = dr["fullname"].ToString();
                    newrow["Employee Code"] = dr["empcode"].ToString();
                    string date = dr["date"].ToString();
                    DateTime fdate = Convert.ToDateTime(date);
                    string transfedate = fdate.ToString("dd-MMM-yyyy");
                    newrow["Date"] = transfedate;
                    newrow["From Branch"] = dr["branchname"].ToString();
                    newrow["To Branch"] = dr["tobranch"].ToString();
                    Report.Rows.Add(newrow);
                }
                grdReports.DataSource = Report;
                grdReports.DataBind();
                Session["xportdata"] = Report;
                hidepanel.Visible = true;
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }
}