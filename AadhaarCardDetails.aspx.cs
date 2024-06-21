using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class AadhaarCardDetails : System.Web.UI.Page
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
            string mainbranch = Session["mainbranch"].ToString(); 
            cmd = new SqlCommand("SELECT employedetails.empid, employedetails.employee_num, employedetails.fullname FROM employedetails INNER JOIN  branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
            //cmd.Parameters.Add("@BranchID", BranchID);
            cmd.Parameters.Add("@m", mainbranch);
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
            lblHeading.Text = " AadhaarCardDetails";
            Session["filename"] = "AadhaarCardDetails ";
            Session["title"] = " AadhaarCardDetails ";
            Report.Columns.Add("SNO");
            Report.Columns.Add("PFNumber");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            Report.Columns.Add("Aadhaar Enrolment No");
            Report.Columns.Add("Name (As on Aadhaar Card)");
            Report.Columns.Add("Aadhaar Card Number");
            Report.Columns.Add("Bank Account Number");
            Report.Columns.Add("IFSC Code");
            string mainbranch = Session["mainbranch"].ToString();
            if (ddlEmployeeType.SelectedValue == "Employee Wise")
            {
                //lblemployeename.Text = "Batch Name " + ddlemployee.SelectedItem.Text;
                //branchwise
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employebankdetails.accountno, employepfdetails.pfnumber, employebankdetails.ifsccode, employedetails.nameasforaadhar, employedetails.aadarenrollnumber, employedetails.aadhaar_id FROM employedetails INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid INNER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE(employedetails.empid = @empid) AND (employedetails.pfeligible = 'Yes') AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'NO')");
                cmd.Parameters.Add("@empid", ddlemployee.SelectedValue);
            }
            else
            {
                //branchwise
                //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employebankdetails.accountno, employepfdetails.pfnumber, employebankdetails.ifsccode, employedetails.nameasforaadhar, employedetails.aadarenrollnumber, employedetails.aadhaar_id FROM employedetails INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid INNER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.pfeligible = 'Yes')");
                //branchmapping
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employebankdetails.accountno, employepfdetails.pfnumber, employebankdetails.ifsccode, employedetails.nameasforaadhar, employedetails.aadarenrollnumber, employedetails.aadhaar_id, employedetails.bloodgroup FROM employedetails INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid INNER JOIN  employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (employedetails.pfeligible = 'Yes') AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'NO')");
            }
            cmd.Parameters.Add("@m", mainbranch); 
            DataTable dtAdvance = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtAdvance.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtAdvance.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["SNO"] = i++.ToString();
                    newrow["PFNumber"] = dr["pfnumber"].ToString();
                    newrow["Employee Code"] = dr["employee_num"].ToString();
                    newrow["Name"] = dr["fullname"].ToString();
                    newrow["Aadhaar Enrolment No"] = dr["aadarenrollnumber"].ToString();
                    newrow["Name (As on Aadhaar Card)"] = dr["nameasforaadhar"].ToString();
                    newrow["Aadhaar Card Number"] = dr["aadhaar_id"].ToString();
                    newrow["Bank Account Number"] = dr["accountno"].ToString();
                    newrow["IFSC Code"] = dr["ifsccode"].ToString();
                    Report.Rows.Add(newrow);
                }

                grdReports.DataSource = Report;
                grdReports.DataBind();
                Session["xportdata"] = Report;
                hidepanel.Visible = true;
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
}