using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class EmployeeFamilyDetailsReport : System.Web.UI.Page
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
            lblemp.Visible = true;
            lblSelectedValue.Text = ddlemployee.SelectedValue;
            string mainbranch = Session["mainbranch"].ToString();
            cmd = new SqlCommand("SELECT employedetails.empid, employedetails.employee_num, employedetails.fullname FROM employedetails INNER JOIN  branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
            //cmd.Parameters.Add("@BranchID", BranchID);
            cmd.Parameters.Add("@m", mainbranch);
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
            lblHeading.Text = " Employee Family Details";
            //DateTime dtfrom = fromdate;
            //string frmdate = dtfrom.ToString("dd/MM/yyyy");
            //string[] str = frmdate.Split('/');
            //lblFromDate.Text = mymonth;
            //fromdate = Convert.ToDateTime(date);
            Session["filename"] = "Employee Family Details ";
            Session["title"] = " Employee Family Details ";
            Report.Columns.Add("Name");
            Report.Columns.Add("SNO");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Joined On");
            Report.Columns.Add("Member Name");
            Report.Columns.Add("Relation");
            Report.Columns.Add("Date Of Birth");
            Report.Columns.Add("Gender");
            Report.Columns.Add("Bloodgroup");
            Report.Columns.Add("Nationality");
            Report.Columns.Add("Profession");
            string mainbranch = Session["mainbranch"].ToString(); 
            if (ddlEmployeeType.SelectedValue == "Employee Wise")
            {
                //lblemployeename.Text = "Batch Name " + ddlemployee.SelectedItem.Text;
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.joindate, employeefamilydetailes.relation, employeefamilydetailes.relationname, employeefamilydetailes.relationdob, employeefamilydetailes.gender, employeefamilydetailes.nationality, employeefamilydetailes.profession, employeefamilydetailes.bloodgroup FROM employedetails INNER JOIN employeefamilydetailes ON employedetails.empid = employeefamilydetailes.empid WHERE (employedetails.empid = @empid) ORDER BY employedetails.fullname");
                //cmd.Parameters.Add("@empid", empid);
                cmd.Parameters.Add("@empid", ddlemployee.SelectedValue);
            }

            else
            {
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.joindate, employeefamilydetailes.relation, employeefamilydetailes.relationname,  employeefamilydetailes.relationdob, employeefamilydetailes.gender, employeefamilydetailes.nationality, employeefamilydetailes.profession,  employeefamilydetailes.bloodgroup FROM employedetails INNER JOIN employeefamilydetailes ON employedetails.empid = employeefamilydetailes.empid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m) AND (employedetails.status = 'no') ORDER BY employedetails.fullname");
                cmd.Parameters.Add("@m", mainbranch);
                //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.joindate, employeefamilydetailes.relation, employeefamilydetailes.relationname, employeefamilydetailes.relationdob, employeefamilydetailes.gender, employeefamilydetailes.nationality, employeefamilydetailes.profession,employeefamilydetailes.bloodgroup FROM employedetails INNER JOIN employeefamilydetailes ON employedetails.empid = employeefamilydetailes.empid  ORDER BY employedetails.fullname");
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
                    newrow["Employee Code"] = dr["employee_num"].ToString();
                    string jondate = dr["joindate"].ToString();
                    DateTime fdate = Convert.ToDateTime(jondate);
                    string joindate = fdate.ToString("dd-MMM-yyyy");
                    newrow["Joined On"] = joindate;
                    newrow["Member Name"] = dr["relationname"].ToString();
                    newrow["Relation"] = dr["relation"].ToString();
                    newrow["Date Of Birth"] = dr["relationdob"].ToString();
                    newrow["Gender"] = dr["gender"].ToString();
                    newrow["Bloodgroup"] = dr["bloodgroup"].ToString();
                    newrow["Nationality"] = dr["nationality"].ToString();
                    newrow["Profession"] = dr["profession"].ToString();
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

    protected void gvMenu_DataBinding(object sender, EventArgs e)
    {
        try
        {
            GridViewGroup First = new GridViewGroup(grdReports, null, "Name");
            // GridViewGroup seconf = new GridViewGroup(grdReports, First, "Location");
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}