using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;



public partial class LoanRequestInFormation : System.Web.UI.Page
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
                    LBLADD.Text = Session["Address"].ToString();
                    Fillemployee();
                    lblTitle.Text = Session["TitleName"].ToString();
                }
            }
        }
    }
    void Fillemployee()
    {
        cmd = new SqlCommand("SELECT empid, fullname FROM employedetails");
        cmd.Parameters.Add("@BranchID", BranchID);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlEmployeeName.DataSource = dttrips;
        ddlEmployeeName.DataTextField = "fullname";
        ddlEmployeeName.DataValueField = "empid";
        ddlEmployeeName.DataBind();
    }
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            vdm = new DBManager();
            cmd = new SqlCommand("SELECT loan_request.sno, employedetails.employee_num, loan_request.empid, loan_request.doe, employedetails.fullname, employedetails.cellphone, loan_request.experience, loan_request.age,loan_request.salarydate, loan_request.purpose_of_loan, loan_request.previousloan, loan_request.loanamount, loan_request.months, loan_request.refemp1,loan_request.designation1, loan_request.mobno1, loan_request.refemp2, loan_request.designation2, loan_request.mobno2, loan_request.fathername, loan_request.address1, loan_request.address2, loan_request.status, loan_request.rejectremarks, loan_request.startdate, employedetails.dob, employedetails.home_address, employedetails.presentaddress, employedetails.nameasforaadhar, employedetails.designationid, designation.designation FROM loan_request INNER JOIN  employedetails ON loan_request.empid = employedetails.empid INNER JOIN designation ON employedetails.designationid = designation.designationid");
            cmd.Parameters.Add("@EmpSno", ddlEmployeeName.SelectedValue);
            cmd.Parameters.Add("@BranchID", BranchID);
            DataTable dtDriver = vdm.SelectQuery(cmd).Tables[0];
            if (dtDriver.Rows.Count > 0)
            {
                lblDriverName.Text = dtDriver.Rows[0]["fullname"].ToString();
                lblEmpID.Text = dtDriver.Rows[0]["employee_num"].ToString();
                lblFathersName.Text = dtDriver.Rows[0]["fathername"].ToString();
                lblAdress.Text = dtDriver.Rows[0]["home_address"].ToString();
                lblperementaddress.Text = dtDriver.Rows[0]["presentaddress"].ToString();
                lblContactNumber.Text = dtDriver.Rows[0]["cellphone"].ToString();
                lblDOB.Text = dtDriver.Rows[0]["dob"].ToString();
                lblDesignation.Text = dtDriver.Rows[0]["designation"].ToString();
                lblExprnceCompany.Text = dtDriver.Rows[0]["experience"].ToString();
                lblSalaryPaydate.Text = dtDriver.Rows[0]["salarydate"].ToString();
                lblPuposeloan.Text = dtDriver.Rows[0]["purpose_of_loan"].ToString();
                lblAnyprivoesloan.Text = dtDriver.Rows[0]["previousloan"].ToString();
                lblLoanAmount.Text = dtDriver.Rows[0]["loanamount"].ToString();
                lblLoanNomonth.Text = dtDriver.Rows[0]["months"].ToString();
                lblstartmonthpdate.Text = dtDriver.Rows[0]["startdate"].ToString();
                lblname1.Text = dtDriver.Rows[0]["refemp1"].ToString();
                lblDesgnation1.Text = dtDriver.Rows[0]["designation"].ToString();
                lblAddress1.Text = dtDriver.Rows[0]["address1"].ToString();
                lblname2.Text = dtDriver.Rows[0]["refemp2"].ToString();
                lblDesgnation2.Text = dtDriver.Rows[0]["designation"].ToString();
                lblAddress2.Text = dtDriver.Rows[0]["address2"].ToString();
            }
            else
            {
                lblmsg.Text = "No Information Found";
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
    }
    void GetReport()
    {

    }

}