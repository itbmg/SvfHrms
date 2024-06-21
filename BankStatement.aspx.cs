using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class BankStatement : System.Web.UI.Page
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
                    DateTime dtyear = DateTime.Now.AddYears(-1);
                    //dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    //dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    //lblAddress.Text = Session["Address"].ToString();
                    //lblTitle.Text = Session["TitleName"].ToString();
                    PopulateYear();
                    bindcompany();
                    bindbank();
                    string mainbranch = Session["mainbranch"].ToString();
                    if (mainbranch == "42")
                    {
                        ddlemptype.Visible = true;
                        Label5.Visible = true;
                        bindemployeetype();
                    }
                    else
                    {
                        ddlemptype.Visible = true;
                        Label5.Visible = true;
                        bindemployeetype();
                    }
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    ddlmonth.SelectedValue = str[1];
                    string fryear = dtyear.ToString("dd/MM/yyyy");
                    string[] str1 = fryear.Split('/');
                    ddlyear.SelectedValue = str1[2];
                    //bindemployeetype();
                }
            }
        }
    }
    private void PopulateYear()
    {

        ddlyear.Items.Clear();
        ListItem lt = new ListItem();
        lt.Text = "YYYY";
        lt.Value = "0";
        ddlyear.Items.Add(lt);
        for (int i = DateTime.Now.Year; i >= 1970; i--)
        {
            lt = new ListItem();
            lt.Text = i.ToString();
            lt.Value = i.ToString();
            ddlyear.Items.Add(lt);
        }
        ddlyear.Items.FindByValue(DateTime.Now.Year.ToString()).Selected = true;
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

    private void bindcompany()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT sno, companyname FROM company_master");
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlCompanytype.DataSource = dttrips;
        ddlCompanytype.DataTextField = "companyname";
        ddlCompanytype.DataValueField = "sno";
        ddlCompanytype.DataBind();
        ddlCompanytype.ClearSelection();
        ddlCompanytype.Items.Insert(0, new ListItem { Value = "0", Text = "Select Branch", Selected = true });
        ddlCompanytype.SelectedValue = "0";
    }

    private void bindbank()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT sno, bankname FROM bankmaster");
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlbank.DataSource = dttrips;
        ddlbank.DataTextField = "bankname";
        ddlbank.DataValueField = "sno";
        ddlbank.DataBind();
        ddlbank.ClearSelection();
        ddlbank.Items.Insert(0, new ListItem { Value = "0", Text = "Select Bank", Selected = true });
        ddlbank.SelectedValue = "0";
    }

    private void bindemployeetype()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT employee_type FROM employedetails   where (employee_type<>'')  GROUP BY employedetails.employee_type");
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlemptype.DataSource = dttrips;
        ddlemptype.DataTextField = "employee_type";
        ddlemptype.DataValueField = "employee_type";
        ddlemptype.DataBind();
        ddlemptype.ClearSelection();
        ddlemptype.Items.Insert(0, new ListItem { Value = "0", Text = "Select Type", Selected = true });
        ddlemptype.SelectedValue = "0";
    }

    DataTable Report = new DataTable();
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {

            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            string empbranchid = string.Empty;
            string mainbranch = Session["mainbranch"].ToString();
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            string currentyear = (mydate.Year).ToString();
            string year = ddlyear.SelectedItem.Value;
            string mymonth = ddlmonth.SelectedItem.Value;
            int month = Convert.ToInt32(mymonth);
            int years = Convert.ToInt32(year);
            string day = "";
            if (mymonth == "02")
            {
                day = "28";
            }
            else
            {
                day = (mydate.Day).ToString();
                int days = DateTime.DaysInMonth(years, month);
                int cmdays = Convert.ToInt32(day);
                if (cmdays > days)
                {
                    day = days.ToString();
                }
            }
            //string day = (mydate.Day).ToString();
            string date = mymonth + "/" + day + "/" + year;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth;
            fromdate = Convert.ToDateTime(date);
            lblHeading.Text = ddlbank.SelectedItem.Text + "  Statement " + ddlmonth.SelectedItem.Text + " " + year; 
            Session["filename"] = ddlbank.SelectedItem.Text + "  Statement " + ddlmonth.SelectedItem.Text + " " + year;
            Session["title"] = ddlbank.SelectedItem.Text + "  Statement " + ddlmonth.SelectedItem.Text + " " + year;
            if (ddlbranchtype.SelectedItem.Text == "SalesOffice" || ddlbranchtype.SelectedItem.Text == "CC" || ddlbranchtype.SelectedItem.Text == "Plant" || ddlbranchtype.SelectedItem.Text == "IFD Plant")
            {
                Report.Columns.Add("Location");
                if (mainbranch == "42")
                {
                    Report.Columns.Add("EMPTYPE");
                }
                //if (ddlCompanytype.SelectedValue == "1" || ddlCompanytype.SelectedValue=="2")
                //{
                Report.Columns.Add("SNO");
                //}
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Employee Name");
                Report.Columns.Add("Gross").DataType = typeof(double);
                Report.Columns.Add("Net pay").DataType = typeof(double);

                //svds start
                if (mainbranch == "6")
                {
                    if (ddlCompanytype.SelectedValue == "1")
                    {
                        //if (ddlbranchtype.SelectedItem.Text == "SalesOffice" || ddlbranchtype.SelectedItem.Text == "CC" || ddlbranchtype.SelectedItem.Text == "Plant")
                        if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Staff")
                        {
                            Report.Columns.Add("Extra Pay").DataType = typeof(double);
                            Report.Columns.Add("CONVEYANCE").DataType = typeof(double);
                        }
                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                        {
                            Report.Columns.Add("Shift Allowance").DataType = typeof(double);
                            Report.Columns.Add("CONVEYANCE").DataType = typeof(double);
                        }
                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                        {
                            Report.Columns.Add("Shift Allowance").DataType = typeof(double);
                        }
                        if (ddlbranchtype.SelectedItem.Text == "Plant" || ddlbranchtype.SelectedItem.Text == "IFD Plant" & ddlemptype.SelectedItem.Text == "Staff")
                        {
                            Report.Columns.Add("Extra Pay").DataType = typeof(double);
                        }
                    }
                    //svds end
                    //svd start
                    else
                    {
                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                        {
                            Report.Columns.Add("Shift Allowance").DataType = typeof(double);
                            Report.Columns.Add("CONVEYANCE").DataType = typeof(double);
                        }
                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                        {
                            Report.Columns.Add("Shift Allowance").DataType = typeof(double);
                            //Report.Columns.Add("CONVEYANCE").DataType = typeof(double);
                        }
                    }
                    //svd end

                }
                //svf start
                else
                {
                    if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Permanent")
                    {
                        Report.Columns.Add("Extra Pay").DataType = typeof(double);

                    }
                    if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Casual worker")
                    {
                        Report.Columns.Add("OT Amount").DataType = typeof(double);

                    }

                }
                //svf end


                //if (ddlCompanytype.SelectedValue == "2")
                //if (ddlCompanytype.SelectedValue == "2" || ddlCompanytype.SelectedValue == "1" || ddlCompanytype.SelectedValue=="3")
                //{
                //    Report.Columns.Add("Shift Allowance").DataType = typeof(double);
                //}

                Report.Columns.Add("Net Amount").DataType = typeof(double);
                Report.Columns.Add("Bank Acc No");
                Report.Columns.Add("IFSC Code");
                cmd = new SqlCommand("SELECT address, companyname FROM company_master WHERE (sno = @sno)");
                cmd.Parameters.Add("@sno", ddlCompanytype.SelectedValue);
                DataTable dtcompany = vdm.SelectQuery(cmd).Tables[0];
                if (dtcompany.Rows.Count > 0)
                {
                    lblAddress.Text = dtcompany.Rows[0]["address"].ToString();
                    lblTitle.Text = dtcompany.Rows[0]["companyname"].ToString();
                    Session["TitleName"] = dtcompany.Rows[0]["companyname"].ToString();
                    Session["Address"] = dtcompany.Rows[0]["address"].ToString();
                }
                else
                {
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                }
                double totalextrapay = 0;
                mainbranch = Session["mainbranch"].ToString();
                string bankid = ddlbank.SelectedItem.Value;
                string branchtype = ddlbranchtype.SelectedItem.Text;
                if (ddlbranchtype.SelectedItem.Text == "CC")
                {
                    //branchmapping
                    if (mainbranch == "42")
                    {

                        cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.branchid,employedetails.employee_type, employedetails.status, employedetails.esieligible, employedetails.empid, employedetails.fullname,employedetails.employee_num, employedetails.fullname AS Expr2, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode,branchmaster.branchname, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi,salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance,salaryappraisals.salaryperyear, salaryappraisals.travelconveyance FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)ORDER BY employedetails.employee_type, branchmaster.branchname, employedetails.pfeligible");
                        //paystrure
                        //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num, pay_structure.erningbasic,pay_structure.travelconveyance, pay_structure.esi, pay_structure.providentfund, employedetails.fullname AS Expr2, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid  LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid=employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno=employebankdetails.bankid WHERE (branchmaster.branchtype =@branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code=@company_code) and (employedetails.employee_type=@employee_type) ORDER BY branchmaster.branchname");
                        cmd.Parameters.Add("@m", mainbranch);
                        cmd.Parameters.Add("@d1", date);
                    }
                    else
                    {
                         //paystrue
                        //cmd = new SqlCommand("SELECT employedetails.pfeligible,  employedetails.status, employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num, pay_structure.erningbasic, pay_structure.travelconveyance, pay_structure.esi, pay_structure.providentfund, employedetails.fullname AS Expr2, designation.designation,  pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning,  pay_structure.profitionaltax, pay_structure.gross, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND  (employedetails.employee_type = @employee_type) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No')  ORDER BY branchmaster.branchname");
                        cmd = new SqlCommand("SELECT employedetails.pfeligible,employedetails.branchid, employedetails.status, employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num, employedetails.fullname AS Expr2, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.endingdate, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = @employee_type) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = @employee_type) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1) ORDER BY branchmaster.branchname");
                        cmd.Parameters.Add("@employee_type", ddlemptype.SelectedItem.Text);
                        cmd.Parameters.Add("@m", mainbranch);
                        cmd.Parameters.Add("@d1", date);
                    }
                }
                else
                {
                    //branchmapping
                    if (mainbranch == "42")
                    {
                        if (ddlemptype.SelectedItem.Text == "Casual worker" || ddlemptype.SelectedItem.Text == "Permanent")
                        {
                            cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.branchid, employedetails.gender, employedetails.employee_type, employedetails.esieligible, employedetails.empid, employedetails.fullname,employedetails.employee_num, employedetails.fullname AS Expr2, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance,salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = @employee_type) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR(branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = @employee_type) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1) ORDER BY branchmaster.branchname, employedetails.employee_type, employedetails.pfeligible");
                            //paystrure
                           // cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.gender,employedetails.employee_type, employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num, pay_structure.erningbasic, pay_structure.gross, pay_structure.travelconveyance, pay_structure.esi, pay_structure.providentfund, employedetails.fullname AS Expr2, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND  (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = @employee_type) ORDER BY branchmaster.branchname, employedetails.employee_type,employedetails.pfeligible");
                            cmd.Parameters.Add("@m", mainbranch);
                            cmd.Parameters.Add("@employee_type", ddlemptype.SelectedItem.Text);
                            cmd.Parameters.Add("@d1", date);
                        }
                        else
                        {

                        }
                    }
                    else
                    {
                        if (ddlemptype.SelectedItem.Text == "Retainers" || ddlemptype.SelectedItem.Text == "Staff")
                        {
                            if (ddlbank.SelectedItem.Text == "All")
                            {
                                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.branchid,employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num,employedetails.fullname AS Expr2, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund,salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance,salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE (branchmaster.branchtype = @branchtype) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = 'Staff' OR employedetails.employee_type = 'Retainers') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (branchmaster.branchtype = @branchtype) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = 'Staff' OR employedetails.employee_type = 'Retainers') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)ORDER BY branchmaster.branchname");
                                //paystrure
                                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num, pay_structure.erningbasic, pay_structure.travelconveyance, pay_structure.gross, pay_structure.esi, pay_structure.providentfund, employedetails.fullname AS Expr2, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND  (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND ((employedetails.employee_type = 'Staff') OR (employedetails.employee_type = 'Retainers')) ORDER BY branchmaster.branchname");
                                cmd.Parameters.Add("@m", mainbranch);
                                cmd.Parameters.Add("@d1", date);
                            }
                            else
                            {
                                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.branchid,employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num,employedetails.fullname AS Expr2, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund,salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance,salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = 'Staff' OR employedetails.employee_type = 'Retainers') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = 'Staff' OR employedetails.employee_type = 'Retainers') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)ORDER BY branchmaster.branchname");
                                //paystrure
                                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num, pay_structure.erningbasic, pay_structure.travelconveyance, pay_structure.gross, pay_structure.esi, pay_structure.providentfund, employedetails.fullname AS Expr2, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND  (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND ((employedetails.employee_type = 'Staff') OR (employedetails.employee_type = 'Retainers')) ORDER BY branchmaster.branchname");
                                cmd.Parameters.Add("@m", mainbranch);
                                cmd.Parameters.Add("@d1", date);
                            }
                        }
                        else
                        {
                            cmd = new SqlCommand("SELECT employedetails.pfeligible,employedetails.branchid, employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num, employedetails.fullname AS Expr2, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = @employee_type) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = @employee_type) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)ORDER BY branchmaster.branchname");
                            //paysrture
                            //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num, pay_structure.erningbasic, pay_structure.travelconveyance, pay_structure.gross, pay_structure.esi, pay_structure.providentfund, employedetails.fullname AS Expr2, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND  (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = @employee_type) ORDER BY branchmaster.branchname");
                            cmd.Parameters.Add("@m", mainbranch);
                            cmd.Parameters.Add("@employee_type", ddlemptype.SelectedItem.Text);
                            cmd.Parameters.Add("@d1", date);
                        }
                    }
                }
                cmd.Parameters.Add("@branchtype", branchtype);
                cmd.Parameters.Add("@company_code", ddlCompanytype.SelectedValue);
                if (ddlbank.SelectedItem.Text == "All")
                {
                    
                }
                else
                {
                    cmd.Parameters.Add("@bankid", ddlbank.SelectedItem.Value);
                }
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];







                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.convenancedays, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, monthly_attendance.extradays, employedetails.employee_num, branchmaster.fromdate,branchmaster.night_allowance,monthly_attendance.night_days, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where  (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.month FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where  (loan_request.month = @month) AND (loan_request.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where  (mobile_deduction.month = @month) AND (mobile_deduction.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where  (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtcanteen = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, mediclaimdeduction.medicliamamount FROM employedetails INNER JOIN mediclaimdeduction ON employedetails.empid = mediclaimdeduction.empid WHERE (mediclaimdeduction.flag='1')");
                //cmd.Parameters.Add("@month", mymonth);
                //cmd.Parameters.Add("@year", str[2]);
                DataTable dtmedicliam = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, otherdeduction.otherdeductionamount FROM employedetails INNER JOIN otherdeduction ON employedetails.empid = otherdeduction.empid WHERE  (otherdeduction.month = @month) AND (otherdeduction.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtotherdeduction = vdm.SelectQuery(cmd).Tables[0];

                cmd = new SqlCommand("SELECT sno, employecode, tdsdeduction, month, year FROM monthlysalarystatement WHERE month=@prmonth and year=@pryear");
                cmd.Parameters.Add("@prmonth", mymonth);
                cmd.Parameters.Add("@pryear", year);
                DataTable dtprevtds = vdm.SelectQuery(cmd).Tables[0];

                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, tds_deduction.tdsamount FROM employedetails INNER JOIN tds_deduction ON employedetails.empid = tds_deduction.empid");
                //cmd.Parameters.Add("@branchid", branchid);
                //cmd.Parameters.Add("@month", mymonth);
                //cmd.Parameters.Add("@year", str[2]);
                DataTable dttdsdeduction = vdm.SelectQuery(cmd).Tables[0];

                if (dtsalary.Rows.Count > 0)
                {
                    var i = 1;
                    string prevlocation = "";
                    double netpaytotal = 0;
                    double netamounttotal = 0;
                    double netcontotal = 0;
                    double netextragrandtotal = 0;
                    double netextratotal = 0;
                    double netotgrandtotal = 0;
                    double netottotal = 0;
                    double netcongrandtotal = 0;
                    double netamountgrandtotal = 0;
                    double netpaygrandtotal = 0;
                    double shifttotal = 0;
                    double shiftgrandtotal = 0;
                    double mnthdays = 0;
                    string testempcode = "";
                    foreach (DataRow dr in dtsalary.Rows)
                     {
                        testempcode = "";
                        double otvalue = 0;
                        double extravalue = 0;
                        double conveyancedays = 0;
                        double totalpresentdays = 0;
                        double profitionaltax = 0;
                        double salaryadvance = 0;
                        double otherdeduction = 0;
                        double tdsdeduction = 0;
                        double loan = 0;
                        double medicliamdeduction = 0;
                        double canteendeduction = 0;
                        double mobilededuction = 0;
                        double totaldeduction;
                        double totalearnings;
                        double providentfund = 0;
                        double medicalerning = 0;
                        double washingallowance = 0;
                        double convenyance = 0;
                        double esi = 0;
                        double daysinmonth = 0;
                        double loseamount = 0;
                        double loseofconviyance = 0;
                        double loseofwashing = 0;
                        double loseofmedical = 0;
                        double losofprofitionaltax = 0;
                        DataRow newrow = Report.NewRow();
                        newrow["SNO"] = i++.ToString();
                        string location = dr["branchname"].ToString();
                        empbranchid = dr["branchid"].ToString();
                        if (location == prevlocation)
                        {
                            if (location != "M")
                            {
                                newrow["Location"] = dr["branchname"].ToString();
                                newrow["Employee Code"] = dr["employee_num"].ToString();
                                newrow["Employee Name"] = dr["fullname"].ToString();
                                if (mainbranch == "42")
                                {
                                    newrow["EMPTYPE"] = dr["employee_type"].ToString();
                                }
                                double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                                double permonth = 0;
                                if (mainbranch == "42")
                                {
                                    string etype = dr["employee_type"].ToString();
                                    if (etype == "Permanent" || etype == "Staff")
                                    {
                                        permonth = peryanam / 12;
                                        newrow["Gross"] = peryanam / 12;
                                    }
                                    //      if (ddlemptype.SelectedItem.Text == "Casual worker")
                                    //{
                                    //    permonth = Convert.ToDouble(dr["gross"].ToString());
                                    //    permonth = peryanam / 12;
                                    //    newrow["Gross"] = peryanam / 12;
                                    //      }
                                    else
                                    {
                                        permonth = Convert.ToDouble(dr["gross"].ToString());
                                        double gross = permonth * mnthdays;
                                       // newrow["Gross"] = peryanam / 12;
                                        newrow["Gross"] = gross;
                                    }
                                }
                                else
                                {
                                    if (location == "Arani CC")
                                    {
                                        permonth = Convert.ToDouble(dr["gross"].ToString());
                                        newrow["Gross"] = permonth;
                                    }
                                    //if (ddlemptype.SelectedItem.Text == "Casual worker")
                                    //{
                                    //    permonth = Convert.ToDouble(dr["gross"].ToString());
                                    //    permonth = peryanam / 12;
                                    //    newrow["Gross"] = peryanam / 12;
                                    //}
                                    else
                                    {
                                        permonth = peryanam / 12;
                                        newrow["Gross"] = peryanam / 12;
                                    }
                                }

                                double HRA = Convert.ToDouble(dr["hra"].ToString());
                                double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                                convenyance = Convert.ToDouble(dr["conveyance"].ToString());
                                //newrow["PT"] = dr["profitionaltax"].ToString();
                                profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                                medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
                                washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
                                newrow["Bank Acc No"] = "'" + dr["accountno"].ToString() + "";
                                newrow["IFSC Code"] = dr["ifsccode"].ToString();

                                double travelconveyance = 0;
                                double shiftamount = 0;
                                double travaltotamount = 0;
                                double paydays = 0;
                                double paybledays = 0;
                                string employetype = "";
                                testempcode = dr["employee_num"].ToString();
                                if (dtattendence.Rows.Count > 0)
                                {
                                    foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                    {

                                        double numberofworkingdays = 0;
                                        double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                        double clorwo = 0;
                                        double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                        daysinmonth = numberofworkingdays + clorwo;
                                        //newrow["Attendence Days"] = dra["numberofworkingdays"].ToString();
                                        double lop = 0;
                                        double.TryParse(dra["lop"].ToString(), out lop);
                                        paydays = numberofworkingdays - lop;
                                        double holidays = 0;
                                        holidays = daysinmonth - numberofworkingdays;
                                        numberofworkingdays = paydays;
                                        paybledays = numberofworkingdays + clorwo;
                                        // newrow["Payable Days"] = numberofworkingdays + clorwo;
                                        //newrow["CL HOLIDAY AND OFF"] = clorwo;
                                        totalpresentdays = holidays + paydays;
                                        double.TryParse(dra["convenancedays"].ToString(), out conveyancedays);
                                        double totalpdays = permonth / daysinmonth;
                                        loseamount = lop * totalpdays;
                                        double perdayconveyance = convenyance / daysinmonth;
                                        loseofconviyance = lop * perdayconveyance;
                                        double perdaywashing = washingallowance / daysinmonth;
                                        loseofwashing = lop * perdaywashing;
                                        double perdaymedical = medicalerning / daysinmonth;
                                        loseofmedical = lop * perdaymedical;
                                        double perdaybasic = BASIC / daysinmonth;
                                        string extrdays = dra["extradays"].ToString();
                                        double perdayextr = permonth / daysinmonth;
                                        string ot = dra["otdays"].ToString();
                                        //double perdayot = permonth / daysinmonth;
                                        if (ddlemptype.SelectedItem.Text == "Casuals")
                                        {
                                            profitionaltax = 0;
                                        }
                                        double perdaprofitionaltax = profitionaltax / daysinmonth;
                                        losofprofitionaltax = lop * perdaprofitionaltax;

                                        //svds1 start
                                        double.TryParse(dr["travelconveyance"].ToString(), out travelconveyance);
                                        double perdaycost = 0;
                                        double nightallawancecost = 0;
                                        double nightdays = 0;
                                        double.TryParse(dra["night_days"].ToString(), out nightdays);
                                        double.TryParse(dra["night_allowance"].ToString(), out nightallawancecost);
                                        double extradays = 0;
                                        if (mainbranch == "6")
                                        {
                                            if (ddlCompanytype.SelectedValue == "1")
                                            {
                                                if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Staff")
                                                {


                                                    if (extrdays == "" || extrdays == "0")
                                                    {
                                                        extradays = 0;
                                                    }
                                                    else
                                                    {
                                                        extradays = Convert.ToDouble(dra["extradays"].ToString());
                                                        extravalue = perdayextr * extradays;
                                                        newrow["Extra Pay"] = Math.Round(extravalue);
                                                        netextratotal += Math.Round(extravalue);
                                                        netextragrandtotal += Math.Round(extravalue);
                                                    }
                                                    perdaycost = travelconveyance / daysinmonth;
                                                    travaltotamount = conveyancedays * perdaycost;
                                                    newrow["CONVEYANCE"] = Math.Round(travaltotamount);
                                                    netcontotal += Math.Round(travaltotamount);
                                                    netcongrandtotal += Math.Round(travaltotamount);
                                                }
                                                if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                                                {
                                                    perdaycost = travelconveyance / daysinmonth;
                                                    travaltotamount = conveyancedays * perdaycost;
                                                    newrow["CONVEYANCE"] = Math.Round(travaltotamount);
                                                    netcontotal += Math.Round(travaltotamount);
                                                    netcongrandtotal += Math.Round(travaltotamount);

                                                    shiftamount = nightdays * nightallawancecost;
                                                    shiftamount = Math.Round(shiftamount);
                                                    newrow["Shift Allowance"] = shiftamount;
                                                    shifttotal += Math.Round(shiftamount);
                                                    shiftgrandtotal += Math.Round(shiftamount);

                                                }
                                                if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                                                {
                                                    shiftamount = nightdays * nightallawancecost;
                                                    shiftamount = Math.Round(shiftamount);
                                                    newrow["Shift Allowance"] = shiftamount;
                                                    shifttotal += Math.Round(shiftamount);
                                                    shiftgrandtotal += Math.Round(shiftamount);
                                                }
                                                if (ddlbranchtype.SelectedItem.Text == "Plant" || ddlbranchtype.SelectedItem.Text == "IFD Plant" & ddlemptype.SelectedItem.Text == "Staff")
                                                {
                                                    if (extrdays == "" || extrdays == "0")
                                                    {
                                                        extradays = 0;
                                                    }
                                                    else
                                                    {
                                                        extradays = Convert.ToDouble(dra["extradays"].ToString());
                                                        extravalue = perdayextr * extradays;
                                                        newrow["Extra Pay"] = Math.Round(extravalue);
                                                        netextratotal += Math.Round(extravalue);
                                                        netextragrandtotal += Math.Round(extravalue);
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                                                {

                                                    perdaycost = travelconveyance / daysinmonth;
                                                    travaltotamount = conveyancedays * perdaycost;
                                                    newrow["CONVEYANCE"] = Math.Round(travaltotamount);
                                                    netcontotal += Math.Round(travaltotamount);
                                                    netcongrandtotal += Math.Round(travaltotamount);

                                                    shiftamount = nightdays * nightallawancecost;
                                                    shiftamount = Math.Round(shiftamount);
                                                    newrow["Shift Allowance"] = shiftamount;
                                                    shifttotal += Math.Round(shiftamount);
                                                    shiftgrandtotal += Math.Round(shiftamount);
                                                }
                                                if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                                                {
                                                    shiftamount = nightdays * nightallawancecost;
                                                    shiftamount = Math.Round(shiftamount);
                                                    newrow["Shift Allowance"] = shiftamount;
                                                    shifttotal += Math.Round(shiftamount);
                                                    shiftgrandtotal += Math.Round(shiftamount);

                                                }
                                            }
                                        }
                                        //svds1 end
                                        else
                                        {
                                            if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Permanent")
                                            {
                                                if (extrdays == "" || extrdays == "0")
                                                {
                                                    extradays = 0;
                                                }
                                                else
                                                {
                                                    extradays = Convert.ToDouble(dra["extradays"].ToString());
                                                    extravalue = perdayextr * extradays;
                                                    newrow["Extra Pay"] = Math.Round(extravalue);
                                                    netextratotal += Math.Round(extravalue);
                                                    netextragrandtotal += Math.Round(extravalue);
                                                }
                                            }
                                            if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Casual worker")
                                            {
                                                double otdays = 0;
                                                double othours = 0;
                                                if (ot == "" || ot == "0")
                                                {
                                                    otdays = 0;
                                                }
                                                else
                                                {
                                                    permonth = Convert.ToDouble(dr["gross"].ToString());
                                                    otdays = Convert.ToDouble(dra["otdays"].ToString());
                                                    otvalue = permonth * otdays;
                                                    othours = otdays * 8;
                                                    //otvalue = perdayot * otdays;
                                                    // newrow["Extra Pay"] = Math.Round(otvalue);
                                                    newrow["OT Amount"] = Math.Round(otvalue);
                                                    netottotal += Math.Round(otvalue);
                                                    netotgrandtotal += Math.Round(otvalue);
                                                }

                                            }

                                        }

                                    }
                                }
                                double totalpfdays = 0;
                                double rate = 0;
                                double bonusamount = 0;
                                double perdaysal = permonth / daysinmonth;
                                double basic = 50;
                                double basicsalary = (permonth * 50) / 100;
                                double basicpermonth = basicsalary / daysinmonth;
                                double bs = basicpermonth * totalpresentdays;
                                double basicsal = Math.Round(basicsalary - loseamount);
                                double conve = Math.Round(convenyance - loseofconviyance);
                                double medical = Math.Round(medicalerning - loseofmedical);
                                double washing = Math.Round(washingallowance - loseofwashing);
                                double tt = bs + conve + medical + washing;
                                double pay = 0;
                                if (mainbranch != "42")
                                {
                                    if (ddlemptype.SelectedItem.Text == "Staff")
                                    {
                                        pay = perdaysal * paybledays;
                                    }
                                    else
                                    {
                                        if (location == "Arani CC")
                                        {
                                            pay = perdaysal * paydays;
                                            newrow["Gross"] = perdaysal * daysinmonth;
                                        }
                                        else
                                        {
                                            pay = perdaysal * paydays;
                                        }
                                    }
                                }
                                else
                                {
                                    if (ddlemptype.SelectedItem.Text == "Casuals")
                                    {
                                        pay = permonth * paydays;
                                    }
                                    //else if (ddlemptype.SelectedItem.Text == "Casual worker")
                                    //{
                                    //    pay = permonth * paydays;
                                    //}
                                    else if (ddlemptype.SelectedItem.Text == "Casual worker")
                                    {
                                        //pay = permonth * paydays;

                                        double gr = Convert.ToDouble(dr["gross"].ToString());
                                        rate = gr;
                                        double bonus;
                                        string gender = dr["gender"].ToString();
                                        if (gender == "Male")
                                        {
                                            if (empbranchid == "1044")
                                            {
                                                bonus = 10;
                                            }
                                            else
                                            {
                                                bonus = 30;
                                            }
                                        }
                                        else
                                        {
                                            if (empbranchid == "1044")
                                            {
                                                bonus = 15;
                                            }
                                            else
                                            {
                                                bonus = 35;
                                            }
                                        }
                                        double rateperday = 0;
                                        double amount = 0;
                                        if (paydays >= 24)
                                        {
                                            rateperday = rate + bonus;
                                            amount = bonus * paydays;
                                            //newrow["AttendanceBonus>=24days@rs.30"] = amount;
                                        }
                                        else
                                        {
                                            // newrow["AttendanceBonus>=24days@rs.30"] = 0;
                                            rate = gr;
                                        }
                                        bonusamount = rate * paydays + amount;
                                    }

                                    else
                                    {
                                        pay = perdaysal * paybledays;
                                    }
                                }
                                double thra = permonth - loseamount;
                                double hra = Math.Round(thra - tt);
                                if (ddlbranchtype.SelectedItem.Text == "CC")
                                {
                                    totalearnings = Math.Round(pay);
                                }
                                else if (ddlemptype.SelectedItem.Text == "Casual worker")
                                {

                                    totalearnings = Math.Round(bonusamount);
                                }
                                else
                                {
                                    totalearnings = Math.Round(hra + tt);
                                }
                                //totalearnings = thra;
                                //newrow["HRA"] = hra;
                                //newrow["Gross Earnings"] = totalearnings;
                                string pfeligible = dr["pfeligible"].ToString();
                                if (pfeligible == "Yes")
                                {
                                    if (ddlemptype.SelectedItem.Text == "Casual worker")
                                    {
                                        totalpfdays = rate * paydays;
                                        providentfund = (totalpfdays * 6) / 100;
                                        if (providentfund > 1800)
                                        {
                                            providentfund = 1800;
                                        }
                                        providentfund = Math.Round(providentfund);
                                        // newrow["PF"] = providentfund;
                                    }
                                    else
                                    {
                                        providentfund = (totalearnings * 6) / 100;
                                        if (providentfund > 1800)
                                        {
                                            providentfund = 1800;
                                        }
                                        providentfund = Math.Round(providentfund);
                                    }
                                    // newrow["PF"] = providentfund;
                                }
                                else
                                {
                                    providentfund = 0;
                                    // newrow["PF"] = providentfund;
                                }
                                if (testempcode == "SVF500")
                                {

                                }
                                string esieligible = dr["esieligible"].ToString();
                                if (mainbranch == "42")
                                {
                                    if (empbranchid == "1043" || empbranchid == "1055" || empbranchid == "1049" || empbranchid == "1048" || empbranchid == "1047" || empbranchid=="1070")
                                    {
                                        if (esieligible == "Yes")
                                        {

                                            if (empbranchid == "1043" || empbranchid == "1055" || empbranchid=="1070")
                                            {
                                                if (ddlemptype.SelectedItem.Text == "Permanent" || ddlemptype.SelectedItem.Text == "Staff")
                                                {
                                                    if (totalearnings < 21001)
                                                    {
                                                        // double esiamount = perdaysal * 5;
                                                        //double esiamount = totalearnings / 10;
                                                        esi = (totalearnings * 0.75) / 100;
                                                        esi = Math.Round(esi, 0);
                                                    }
                                                }
                                                else
                                                {
                                                    //double esiamount = rate * 5;
                                                    //double esiamount = totalearnings / 10;
                                                    if (esieligible == "Yes")
                                                    {
                                                        double es = rate * paydays;
                                                        esi = (es * 0.75) / 100;
                                                        esi = Math.Round(esi, 0);
                                                    }
                                                }
                                                //newrow["ESI"] = esi;
                                            }
                                            if (empbranchid == "1049" || empbranchid == "1047")
                                            {
                                                if (ddlemptype.SelectedItem.Text == "Permanent" || ddlemptype.SelectedItem.Text == "Staff")
                                                {
                                                    if (totalearnings < 21001)
                                                    {
                                                        //double esiamount = perdaysal * 5;
                                                        //double esiamount = totalearnings / 10;
                                                        esi = (totalearnings * 0.75) / 100;
                                                        esi = Math.Round(esi, 0);
                                                    }
                                                }
                                                else
                                                {
                                                    // double esiamount = rate * 5;
                                                    //double esiamount = totalearnings / 10;
                                                    if (esieligible == "Yes")
                                                    {
                                                        double es = rate * paydays;
                                                        esi = (es * 0.75) / 100;
                                                        esi = Math.Round(esi, 0);
                                                    }
                                                }
                                            }
                                            if (empbranchid == "1048")
                                            {
                                                if (ddlemptype.SelectedItem.Text == "Permanent" || ddlemptype.SelectedItem.Text == "Staff")
                                                {
                                                    if (totalearnings < 21001)
                                                    {
                                                        // double esiamount = perdaysal * 5;
                                                        //double esiamount = totalearnings / 10;
                                                        esi = (totalearnings * 0.75) / 100;
                                                        esi = Math.Round(esi, 0);
                                                    }
                                                }
                                                else
                                                {
                                                    //double esiamount = rate * 5;
                                                    //double esiamount = totalearnings / 10;
                                                    if (esieligible == "Yes")
                                                    {
                                                        double es = rate * paydays;
                                                        esi = (es * 0.75) / 100;
                                                        esi = Math.Round(esi, 0);
                                                    }
                                                }
                                                //newrow["ESI"] = esi;
                                            }
                                        }
                                        else
                                        {
                                            esi = 0;
                                            //newrow["ESI"] = esi;
                                        }
                                    }
                                    else
                                    {

                                        if (esieligible == "Yes")
                                        {
                                            if (empbranchid == "1044")
                                            {
                                                if (ddlemptype.SelectedItem.Text == "Permanent" || ddlemptype.SelectedItem.Text == "Staff")
                                                {
                                                    if (totalearnings < 21001)
                                                    {
                                                        // double esiamount = perdaysal * 4;
                                                        // double esiamount = totalearnings / 10;
                                                        esi = (totalearnings * 0.75) / 100;
                                                        esi = Math.Round(esi, 0);
                                                    }
                                                }
                                                else
                                                {
                                                    // double esiamount = rate * 4;
                                                    // double esiamount = totalearnings / 10;
                                                    if (esieligible == "Yes")
                                                    {
                                                        double es = rate * paydays;
                                                        esi = (es * 0.75) / 100;
                                                        esi = Math.Round(esi, 0);
                                                    }

                                                }
                                                //this month only Calucate 10days(Nxtmonth asuseually monthly deduction)
                                                // esi = (totalearnings * 1) / 100;

                                                //newrow["ESI"] = esi;
                                            }
                                            if (empbranchid == "43" || empbranchid == "1046")
                                            {
                                                if (ddlemptype.SelectedItem.Text == "Permanent" || ddlemptype.SelectedItem.Text == "Staff")
                                                {
                                                    if (empbranchid == "43")
                                                    {
                                                        if (totalearnings < 21001)
                                                        {
                                                            //double esiamount = perdaysal * 12;
                                                            esi = (totalearnings * 0.75) / 100;
                                                            esi = Math.Round(esi, 0);
                                                        }
                                                    }
                                                    else
                                                    {
                                                        if (totalearnings < 21001)
                                                        {
                                                            //double esiamount = perdaysal * 12;
                                                            esi = (totalearnings * 0.75) / 100;
                                                            esi = Math.Round(esi, 0);
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    // double esiamount = rate * 12;
                                                    if (empbranchid == "43")
                                                    {
                                                        if (esieligible == "Yes")
                                                        {
                                                            double es = rate * paydays;
                                                            esi = (es * 0.75) / 100;
                                                            esi = Math.Round(esi, 0);
                                                        }
                                                    }
                                                    else
                                                    {
                                                        if (esieligible == "Yes")
                                                        {
                                                            double es = rate * paydays;
                                                            esi = (es * 0.75) / 100;
                                                            esi = Math.Round(esi, 0);
                                                        }
                                                    }
                                                }
                                                //this month only Calucate 10days(Nxtmonth asuseually monthly deduction)
                                                // esi = (totalearnings * 1) / 100;

                                                //newrow["ESI"] = esi;
                                            }
                                        }
                                        else
                                        {
                                            esi = 0;
                                            //newrow["ESI"] = esi;
                                        }

                                    }
                                    
                                }
                                
                                else
                                {

                                    if (empbranchid == "41" || empbranchid == "8" || empbranchid == "11")
                                    {
                                        if (esieligible == "Yes")
                                        {
                                            esi = (totalearnings * 0.75) / 100;
                                            esi = Math.Round(esi, 0);
                                           // newrow["ESI"] = esi;
                                        }
                                        else
                                        {
                                            esi = 0;
                                           // newrow["ESI"] = esi;
                                        }
                                    }
                                    else
                                    {
                                        if (esieligible == "Yes")
                                        {
                                            esi = (totalearnings * 1.75) / 100;
                                            esi = Math.Round(esi, 0);
                                           // newrow["ESI"] = esi;
                                        }
                                        else
                                        {
                                            esi = 0;
                                           // newrow["ESI"] = esi;
                                        }
                                    }
                                }
                               
                                if (dtsa.Rows.Count > 0)
                                {
                                    DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double amount = 0;
                                            double.TryParse(drsa["amount"].ToString(), out amount);
                                            //newrow["SALARY ADVANCE"] = amount.ToString();
                                            salaryadvance = Convert.ToDouble(amount);
                                            salaryadvance = Math.Round(amount);
                                        }
                                    }
                                    else
                                    {
                                        salaryadvance = 0;
                                        //newrow["SALARY ADVANCE"] = salaryadvance;
                                    }
                                }
                                else
                                {
                                    salaryadvance = 0;
                                    //newrow["SALARY ADVANCE"] = salaryadvance;
                                }
                                if (dtloan.Rows.Count > 0)
                                {
                                    DataRow[] drr = dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drloan in dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double loanemimonth = 0;
                                            double.TryParse(drloan["loanemimonth"].ToString(), out loanemimonth);
                                            // newrow["Loan"] = loanemimonth.ToString();
                                            loan = Convert.ToDouble(loanemimonth);
                                            loan = Math.Round(loanemimonth);
                                        }
                                    }
                                    else
                                    {
                                        loan = 0;
                                        // newrow["Loan"] = loan;
                                    }
                                }
                                else
                                {
                                    loan = 0;
                                    // newrow["Loan"] = loan;
                                }
                                mobilededuction = 0;
                                if (dtmobile.Rows.Count > 0)
                                {
                                    DataRow[] drr = dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drmobile in dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double deductionamount = 0;
                                            double.TryParse(drmobile["deductionamount"].ToString(), out deductionamount);
                                            //newrow["MOBILE DEDUCTION"] = deductionamount.ToString();
                                            string st = deductionamount.ToString();
                                            if (st == "0.0")
                                            {
                                                mobilededuction = 0;
                                                //newrow["MOBILE DEDUCTION"] = mobilededuction;
                                            }
                                            else
                                            {
                                                mobilededuction = Convert.ToDouble(deductionamount);
                                                mobilededuction = Math.Round(deductionamount);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        mobilededuction = 0;
                                        //newrow["MOBILE DEDUCTION"] = mobilededuction;
                                    }
                                }
                                else
                                {
                                    mobilededuction = 0;
                                    //newrow["MOBILE DEDUCTION"] = mobilededuction;
                                }
                                canteendeduction = 0;
                                if (dtcanteen.Rows.Count > 0)
                                {
                                    DataRow[] drr = dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drcanteen in dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double deductionamount = 0;
                                            double.TryParse(drcanteen["amount"].ToString(), out deductionamount);
                                            //newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                            string st = deductionamount.ToString();
                                            canteendeduction = Convert.ToDouble(deductionamount);
                                            canteendeduction = Math.Round(deductionamount);
                                        }
                                    }
                                    else
                                    {
                                        canteendeduction = 0;
                                        //newrow["CANTEEN DEDUCTION"] = canteendeduction;
                                    }
                                }
                                else
                                {
                                    canteendeduction = 0;
                                    // newrow["CANTEEN DEDUCTION"] = canteendeduction;
                                }

                                medicliamdeduction = 0;
                                if (dtmedicliam.Rows.Count > 0)
                                {
                                    DataRow[] drr = dtmedicliam.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drmedicliam in dtmedicliam.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double amount = 0;
                                            double.TryParse(drmedicliam["medicliamamount"].ToString(), out amount);
                                            //newrow["MEDICLAIM DEDUCTION"] = amount.ToString();
                                            string st = amount.ToString();
                                            medicliamdeduction = Convert.ToDouble(amount);
                                            medicliamdeduction = Math.Round(amount, 0);
                                        }
                                    }
                                    else
                                    {
                                        medicliamdeduction = 0;
                                        //newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
                                    }
                                }
                                else
                                {
                                }
                                otherdeduction = 0;
                                if (dtotherdeduction.Rows.Count > 0)
                                {
                                    DataRow[] drr = dtotherdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drotherdeduction in dtotherdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double amount = 0;
                                            double.TryParse(drotherdeduction["otherdeductionamount"].ToString(), out amount);
                                            //newrow["OTHER DEDUCTION"] = amount.ToString();
                                            string st = amount.ToString();
                                            otherdeduction = Convert.ToDouble(amount);
                                            otherdeduction = Math.Round(amount, 0);
                                        }
                                    }
                                    else
                                    {
                                        otherdeduction = 0;
                                        //newrow["OTHER DEDUCTION"] = otherdeduction;
                                    }
                                }
                                else
                                {
                                }
                                tdsdeduction = 0;
                                if (dttdsdeduction.Rows.Count > 0)
                                {
                                    DataRow[] drprevtds = dtprevtds.Select("employecode='" + dr["employee_num"].ToString() + "'");
                                    if (drprevtds.Length > 0)
                                    {
                                        foreach (DataRow drprevtdsdeduction in dtprevtds.Select("employecode='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double amount = 0;
                                            double.TryParse(drprevtdsdeduction["tdsdeduction"].ToString(), out amount);
                                            if (amount == 0)
                                            {
                                            }
                                            else
                                            {
                                                //newrow["Tds DEDUCTION"] = amount.ToString();
                                                string st = amount.ToString();
                                                tdsdeduction = Convert.ToDouble(amount);
                                                tdsdeduction = Math.Round(amount, 0);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        DataRow[] drr = dttdsdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                        if (drr.Length > 0)
                                        {
                                            foreach (DataRow drtdsdeduction in dttdsdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                            {
                                                double amount = 0;
                                                double.TryParse(drtdsdeduction["tdsamount"].ToString(), out amount);
                                                //newrow["Tds DEDUCTION"] = amount.ToString();
                                                string st = amount.ToString();
                                                tdsdeduction = Convert.ToDouble(amount);
                                                tdsdeduction = Math.Round(amount, 0);
                                            }
                                        }
                                        else
                                        {
                                            tdsdeduction = 0;
                                            //newrow["Tds DEDUCTION"] = tdsdeduction;
                                        }
                                    }
                                }
                                else
                                {
                                    tdsdeduction = 0;
                                    //  newrow["Tds DEDUCTION"] = tdsdeduction;
                                }
                                //newrow["TOTAL DEDUCTIONS"] = Math.Ceiling(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi);
                                double ptax = 0;
                                ptax = profitionaltax - losofprofitionaltax;
                                int companyid = Convert.ToInt32(ddlCompanytype.SelectedItem.Value);
                                if (ddlbranchtype.SelectedItem.Text == "Plant")
                                {
                                    if (companyid == 4)
                                    {

                                    }
                                    else
                                    {

                                        if (totalearnings >= 15000)
                                        {
                                        }
                                        else
                                        {
                                            profitionaltax = 0;
                                        }
                                    }
                                }
                                if (totalearnings >= 15000)
                                {

                                }
                                if (mainbranch == "42")
                                {
                                    totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                                }
                                else
                                {
                                    if (ddlemptype.SelectedItem.Text == "Staff" || ddlemptype.SelectedItem.Text == "Permanent")
                                    {
                                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                                    }

                                    else
                                    {
                                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + esi + medicliamdeduction + otherdeduction);
                                    }
                                }
                                double netpay = 0;
                                netpay = totalearnings - totaldeduction;
                                netpay = Math.Round(netpay, 2);

                                string stramount = "0";
                                stramount = netpay.ToString();
                                if (stramount == "NaN")
                                {
                                }
                                else
                                {

                                    newrow["Net pay"] = netpay;

                                    netpaytotal += netpay;
                                    netpaygrandtotal += netpay;
                                    netpay = netpay + travaltotamount + shiftamount;
                                    // double NEGATIVE = Math.Round(netpay + extravalue);
                                    double NEGATIVE = 0;
                                    NEGATIVE = Math.Round(netpay + extravalue);
                                    if (ddlemptype.SelectedItem.Text == "Staff" || ddlemptype.SelectedItem.Text == "Permanent")
                                    {
                                        NEGATIVE = Math.Round(netpay + extravalue);
                                    }
                                    else if (ddlemptype.SelectedItem.Text == "Casual worker")
                                    {
                                        NEGATIVE = Math.Round(netpay + otvalue);
                                    }
                                    if (NEGATIVE > 0)
                                    {
                                        newrow["Net Amount"] = NEGATIVE;
                                        netamounttotal += NEGATIVE;
                                        netamountgrandtotal += NEGATIVE;
                                        Report.Rows.Add(newrow);
                                    }
                                    else
                                    {
                                       // newrow["Net Amount"] = "0";
                                        netamounttotal += 0;
                                        netamountgrandtotal += 0;
                                      //  Report.Rows.Add(newrow);
                                    }
                                }
                            }
                            // equal end
                        }
                        else
                        {
                            if (netpaytotal > 0)
                            {
                                DataRow newvartical2 = Report.NewRow();
                                newvartical2["Employee Name"] = "Total";
                                newvartical2["Net pay"] = netpaytotal;
                                newvartical2["Net Amount"] = netamounttotal;

                                //svds1 start
                                if (mainbranch == "6")
                                {
                                    if (ddlCompanytype.SelectedValue == "1")
                                    {
                                        if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Staff")
                                        {
                                            newvartical2["Extra Pay"] = netextratotal;
                                            newvartical2["CONVEYANCE"] = netcontotal;
                                        }
                                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")

                                        {
                                            newvartical2["Shift Allowance"] = shifttotal;
                                            newvartical2["CONVEYANCE"] = netcontotal;
                                        }
                                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                                        {
                                            newvartical2["Shift Allowance"] = shifttotal;
                                        }
                                        if (ddlbranchtype.SelectedItem.Text == "Plant" || ddlbranchtype.SelectedItem.Text == "IFD Plant" & ddlemptype.SelectedItem.Text == "Staff")
                                        {
                                            newvartical2["Extra Pay"] = netextratotal;
                                        }
                                    }
                                    else
                                    {
                                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                                        {
                                            newvartical2["CONVEYANCE"] = netcontotal;
                                            newvartical2["Shift Allowance"] = shifttotal;
                                        }
                                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                                        {
                                            //newvartical2["CONVEYANCE"] = netcontotal; ;
                                            newvartical2["Shift Allowance"] = shifttotal;
                                        }
                                    }

                                }
                                else
                                {
                                    if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Permanent")
                                    {
                                        newvartical2["Extra Pay"] = netextratotal;

                                    }
                                    if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Casual worker")
                                    {
                                        newvartical2["OT Amount"] = netottotal;
                                    }
                                }
                                //svds1 end                           


                                Report.Rows.Add(newvartical2);
                                netamounttotal = 0;
                                netpaytotal = 0;
                                netcontotal = 0;
                                netextratotal = 0;
                                shifttotal = 0;
                            }
                            //Grand Total
                            prevlocation = location;
                            if (location != "M")
                            {
                                newrow["Location"] = dr["branchname"].ToString();
                                newrow["Employee Code"] = dr["employee_num"].ToString();
                                newrow["Employee Name"] = dr["fullname"].ToString();
                                if (mainbranch == "42")
                                {
                                    newrow["EMPTYPE"] = dr["employee_type"].ToString();
                                }
                                double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                                double permonth = 0;
                                if (mainbranch == "42")
                                {
                                    string etype = dr["employee_type"].ToString();
                                    if (etype == "Permanent" || etype == "Staff")
                                    {
                                        permonth = peryanam / 12;
                                        newrow["Gross"] = peryanam / 12;
                                    }
                                    else if (ddlemptype.SelectedItem.Text == "Casual worker")
                                    {
                                        permonth = Convert.ToDouble(dr["gross"].ToString());
                                        double gross = permonth * daysinmonth;
                                    }
                                    else
                                    {
                                        permonth = Convert.ToDouble(dr["gross"].ToString());
                                    }
                                }
                                else
                                {
                                    if (location == "Arani CC")
                                    {
                                        permonth = Convert.ToDouble(dr["gross"].ToString());
                                        newrow["Gross"] = permonth;
                                    }
                                    else
                                    {
                                        permonth = peryanam / 12;
                                        newrow["Gross"] = peryanam / 12;
                                    }
                                }
                                double HRA = Convert.ToDouble(dr["hra"].ToString());
                                double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                                convenyance = Convert.ToDouble(dr["conveyance"].ToString());
                                //newrow["PT"] = dr["profitionaltax"].ToString();
                                profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                                medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
                                washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
                                newrow["Bank Acc No"] = "'" + dr["accountno"].ToString() + "";
                                newrow["IFSC Code"] = dr["ifsccode"].ToString();

                                double travelconveyance = 0;
                                double shiftamount = 0;
                                double travaltotamount = 0;
                                double paydays = 0;
                                double paybledays = 0;
                                string employetype = "";
                                if (dtattendence.Rows.Count > 0)
                                {
                                    foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                    {
                                        double numberofworkingdays = 0;
                                        double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                        double clorwo = 0;
                                        double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                        daysinmonth = numberofworkingdays + clorwo;
                                        //newrow["Attendence Days"] = dra["numberofworkingdays"].ToString();
                                        double lop = 0;
                                        double.TryParse(dra["lop"].ToString(), out lop);
                                        paydays = numberofworkingdays - lop;
                                        double holidays = 0;
                                        holidays = daysinmonth - numberofworkingdays;
                                        numberofworkingdays = paydays;
                                        paybledays = numberofworkingdays + clorwo;
                                        // newrow["Payable Days"] = numberofworkingdays + clorwo;
                                        //newrow["CL HOLIDAY AND OFF"] = clorwo;
                                        totalpresentdays = holidays + paydays;
                                        double totalpdays = permonth / daysinmonth;
                                        loseamount = lop * totalpdays;
                                        double perdayconveyance = convenyance / daysinmonth;
                                        loseofconviyance = lop * perdayconveyance;
                                        double perdaywashing = washingallowance / daysinmonth;
                                        loseofwashing = lop * perdaywashing;
                                        double perdaymedical = medicalerning / daysinmonth;
                                        loseofmedical = lop * perdaymedical;
                                        double perdaybasic = BASIC / daysinmonth;
                                        string extrdays = dra["extradays"].ToString();
                                        double perdayextr = permonth / daysinmonth;
                                        string ot = dra["otdays"].ToString();
                                        double perdayot = permonth / daysinmonth;
                                        double perdaprofitionaltax = profitionaltax / daysinmonth;
                                        losofprofitionaltax = lop * perdaprofitionaltax;
                                        //svds1 start
                                        double.TryParse(dra["convenancedays"].ToString(), out conveyancedays);
                                        double.TryParse(dr["travelconveyance"].ToString(), out travelconveyance);
                                        double perdaycost = 0;
                                        double nightallawancecost = 0;
                                        double nightdays = 0;
                                        double.TryParse(dra["night_days"].ToString(), out nightdays);
                                        double.TryParse(dra["night_allowance"].ToString(), out nightallawancecost);
                                        double extradays = 0;
                                        if (mainbranch == "6")
                                        {
                                            //svds start
                                            if (ddlCompanytype.SelectedValue == "1")
                                            {
                                                //if (ddlbranchtype.SelectedItem.Text == "SalesOffice" || ddlbranchtype.SelectedItem.Text == "CC" || ddlbranchtype.SelectedItem.Text == "Plant")
                                                if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Staff")
                                                {
                                                    if (extrdays == "" || extrdays == "0")
                                                    {
                                                        extradays = 0;
                                                    }
                                                    else
                                                    {
                                                        extradays = Convert.ToDouble(dra["extradays"].ToString());
                                                        extravalue = perdayextr * extradays;
                                                        newrow["Extra Pay"] = Math.Round(extravalue);
                                                        netextratotal += Math.Round(extravalue);
                                                        netextragrandtotal += Math.Round(extravalue);
                                                    }
                                                    perdaycost = travelconveyance / daysinmonth;
                                                    travaltotamount = conveyancedays * perdaycost;
                                                    newrow["CONVEYANCE"] = Math.Round(travaltotamount);
                                                    netcontotal += Math.Round(travaltotamount);
                                                    netcongrandtotal += Math.Round(travaltotamount);
                                                }
                                                if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                                                {
                                                    perdaycost = travelconveyance / daysinmonth;
                                                    travaltotamount = conveyancedays * perdaycost;
                                                    newrow["CONVEYANCE"] = Math.Round(travaltotamount);
                                                    netcontotal += Math.Round(travaltotamount);
                                                    netcongrandtotal += Math.Round(travaltotamount);

                                                    shiftamount = nightdays * nightallawancecost;
                                                    shiftamount = Math.Round(shiftamount);
                                                    newrow["Shift Allowance"] = shiftamount;
                                                    shifttotal += Math.Round(shiftamount);
                                                    shiftgrandtotal += Math.Round(shiftamount);
                                                }
                                                if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                                                {
                                                    shiftamount = nightdays * nightallawancecost;
                                                    shiftamount = Math.Round(shiftamount);
                                                    newrow["Shift Allowance"] = shiftamount;
                                                    shifttotal += Math.Round(shiftamount);
                                                    shiftgrandtotal += Math.Round(shiftamount);
                                                }
                                                if (ddlbranchtype.SelectedItem.Text == "Plant" || ddlbranchtype.SelectedItem.Text == "IFD Plant" & ddlemptype.SelectedItem.Text == "Staff")
                                                {
                                                    if (extrdays == "" || extrdays == "0")
                                                    {
                                                        extradays = 0;
                                                    }
                                                    else
                                                    {
                                                        extradays = Convert.ToDouble(dra["extradays"].ToString());
                                                        extravalue = perdayextr * extradays;
                                                        newrow["Extra Pay"] = Math.Round(extravalue);
                                                        netextratotal += Math.Round(extravalue);
                                                        netextragrandtotal += Math.Round(extravalue);
                                                    }
                                                }
                                            }
                                            //svds1 end
                                            //svd start
                                            else
                                            {
                                                if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                                                {

                                                    perdaycost = travelconveyance / daysinmonth;
                                                    travaltotamount = conveyancedays * perdaycost;
                                                    newrow["CONVEYANCE"] = Math.Round(travaltotamount);
                                                    netcontotal += Math.Round(travaltotamount);
                                                    netcongrandtotal += Math.Round(travaltotamount);

                                                    shiftamount = nightdays * nightallawancecost;
                                                    shiftamount = Math.Round(shiftamount);
                                                    newrow["Shift Allowance"] = shiftamount;
                                                    shifttotal += Math.Round(shiftamount);
                                                    shiftgrandtotal += Math.Round(shiftamount);
                                                }
                                                if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                                                {
                                                    shiftamount = nightdays * nightallawancecost;
                                                    shiftamount = Math.Round(shiftamount);
                                                    newrow["Shift Allowance"] = shiftamount;
                                                    shifttotal += Math.Round(shiftamount);
                                                    shiftgrandtotal += Math.Round(shiftamount);

                                                }

                                            }
                                        }
                                        //svd end
                                        //svf start
                                        else
                                        {
                                            if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Permanent")
                                            {
                                                if (extrdays == "" || extrdays == "0")
                                                {
                                                    extradays = 0;
                                                }
                                                else
                                                {
                                                    extradays = Convert.ToDouble(dra["extradays"].ToString());
                                                    extravalue = perdayextr * extradays;
                                                    newrow["Extra Pay"] = Math.Round(extravalue);
                                                    netextratotal += Math.Round(extravalue);
                                                    netextragrandtotal += Math.Round(extravalue);
                                                }

                                            }
                                            if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Casual worker")
                                            {
                                                double otdays = 0;
                                                double othours = 0;
                                                if (ot == "" || ot == "0")
                                                {
                                                    otdays = 0;
                                                }
                                                else
                                                {
                                                    permonth = Convert.ToDouble(dr["gross"].ToString());
                                                    otdays = Convert.ToDouble(dra["otdays"].ToString());
                                                    otvalue = permonth * otdays;
                                                    othours = otdays * 8;
                                                    //otvalue = perdayot * otdays;
                                                    // newrow["Extra Pay"] = Math.Round(otvalue);
                                                    newrow["OT Amount"] = Math.Round(otvalue);
                                                    netottotal += Math.Round(otvalue);
                                                    netotgrandtotal += Math.Round(otvalue);
                                                }

                                            }

                                        }
                                        //svf end
                                    }
                                }
                                double totalpfdays = 0;
                                double rate = 0;
                                double bonusamount = 0;
                                double perdaysal = permonth / daysinmonth;
                                double basic = 50;
                                double basicsalary = (permonth * 50) / 100;
                                double basicpermonth = basicsalary / daysinmonth;
                                double bs = basicpermonth * totalpresentdays;
                                double basicsal = Math.Round(basicsalary - loseamount);
                                double conve = Math.Round(convenyance - loseofconviyance);
                                double medical = Math.Round(medicalerning - loseofmedical);
                                double washing = Math.Round(washingallowance - loseofwashing);
                                double tt = bs + conve + medical + washing;
                                double pay = 0;
                                if (mainbranch != "42")
                                {
                                    if (ddlemptype.SelectedItem.Text == "Staff")
                                    {
                                        pay = perdaysal * paybledays;
                                    }
                                    else
                                    {
                                        if (location == "Arani CC")
                                        {
                                            //pay = permonth * paydays;
                                            pay = perdaysal * paydays;
                                            newrow["Gross"] = perdaysal * daysinmonth;
                                        }
                                        else
                                        {
                                            pay = perdaysal * paydays;
                                        }
                                    }
                                }
                                else
                                {
                                    string etype = dr["employee_type"].ToString();
                                    if (etype == "Permanent" || etype == "Staff")
                                    {
                                        permonth = peryanam / 12;
                                        newrow["Gross"] = peryanam / 12;
                                    }
                                    else if (ddlemptype.SelectedItem.Text == "Casual worker")
                                    {
                                        permonth = Convert.ToDouble(dr["gross"].ToString());
                                        double gross = permonth * daysinmonth;
                                        // newrow["Gross"] = peryanam / 12;
                                        newrow["Gross"] = gross;
                                        // permonth = Convert.ToDouble(dr["gross"].ToString());
                                        //  permonth = peryanam / 12;
                                        //newrow["Gross"] = peryanam;
                                        mnthdays = daysinmonth;
                                    }
                                    else
                                    {
                                        permonth = Convert.ToDouble(dr["gross"].ToString());

                                    }
                                    if (ddlemptype.SelectedItem.Text == "Casuals")
                                    {
                                        pay = permonth * paydays;
                                    }
                                    else if (ddlemptype.SelectedItem.Text == "Casual worker")
                                    {
                                        //pay = permonth * paydays;


                                        double gr = Convert.ToDouble(dr["gross"].ToString());
                                        rate = gr;
                                        double bonus;
                                        string gender = dr["gender"].ToString();
                                        if (gender == "Male")
                                        {
                                            if (empbranchid == "1044")
                                            {
                                                bonus = 10;
                                            }
                                            else
                                            {
                                                bonus = 30;
                                            }
                                        }
                                        else
                                        {
                                            if (empbranchid == "1044")
                                            {
                                                bonus = 15;
                                            }
                                            else
                                            {
                                                bonus = 35;
                                            }
                                        }
                                        double rateperday = 0;
                                        double amount = 0;
                                        if (paydays >= 24)
                                        {
                                            rateperday = rate + bonus;
                                            amount = bonus * paydays;
                                            //newrow["AttendanceBonus>=24days@rs.30"] = amount;
                                        }
                                        else
                                        {
                                            // newrow["AttendanceBonus>=24days@rs.30"] = 0;
                                            rate = gr;
                                        }
                                        bonusamount = rate * paydays + amount;
                                    }
                                    else
                                    {
                                        pay = perdaysal * paybledays;
                                    }
                                }
                                double thra = permonth - loseamount;
                                double hra = Math.Round(thra - tt);
                                if (ddlbranchtype.SelectedItem.Text == "CC")
                                {
                                    //totalearnings = Math.Round(hra + tt);
                                    totalearnings = Math.Round(pay);
                                }
                                else if (ddlemptype.SelectedItem.Text == "Casual worker")
                                {

                                    totalearnings = Math.Round(bonusamount);
                                }
                                else
                                {
                                    totalearnings = Math.Round(hra + tt);
                                }
                                //totalearnings = thra;
                                //newrow["HRA"] = hra;
                                //newrow["Gross Earnings"] = totalearnings;
                                string pfeligible = dr["pfeligible"].ToString();
                                if (pfeligible == "Yes")
                                {
                                    if (ddlemptype.SelectedItem.Text == "Casual worker")
                                    {
                                        totalpfdays = rate * paydays;
                                        providentfund = (totalpfdays * 6) / 100;
                                        if (providentfund > 1800)
                                        {
                                            providentfund = 1800;
                                        }
                                        providentfund = Math.Round(providentfund);
                                        // newrow["PF"] = providentfund;
                                    }
                                    else
                                    {
                                        providentfund = (totalearnings * 6) / 100;
                                        if (providentfund > 1800)
                                        {
                                            providentfund = 1800;
                                        }
                                        providentfund = Math.Round(providentfund);
                                    }
                                }
                                else
                                {
                                    providentfund = 0;
                                    // newrow["PF"] = providentfund;
                                }
                                
                                string esieligible = dr["esieligible"].ToString();
                                if (mainbranch == "42")
                                {
                                    if (empbranchid == "1043" || empbranchid == "1049" || empbranchid == "1048" || empbranchid == "1047")
                                    {
                                        if (esieligible == "Yes")
                                        {
                                            if (ddlemptype.SelectedItem.Text == "Permanent" || ddlemptype.SelectedItem.Text == "Staff")
                                            {
                                                double esiamount = perdaysal * paydays;
                                                //double esiamount = totalearnings / 10;
                                                esi = (esiamount * 0.75) / 100;
                                                esi = Math.Round(esi, 0);
                                            }
                                            else
                                            {
                                                double esiamount = rate * paydays;
                                                //double esiamount = totalearnings / 10;
                                                esi = (esiamount * 0.75) / 100;
                                                esi = Math.Round(esi, 0);
                                            }
                                        }
                                        else
                                        {
                                            esi = 0;
                                            //newrow["ESI"] = esi;
                                        }
                                    }
                                    else
                                    {
                                        if (esieligible == "Yes")
                                        {

                                            if (ddlemptype.SelectedItem.Text == "Permanent" || ddlemptype.SelectedItem.Text == "Staff")
                                            {
                                                if (empbranchid == "43")
                                                {
                                                    double esiamount = perdaysal * paydays;
                                                    // double esiamount = totalearnings / 10;
                                                    esi = (esiamount * 0.75) / 100;
                                                    esi = Math.Round(esi, 0);
                                                }
                                                else
                                                {
                                                    double esiamount = perdaysal * paydays;
                                                    // double esiamount = totalearnings / 10;
                                                    esi = (esiamount * 0.75) / 100;
                                                    esi = Math.Round(esi, 0);
                                                }
                                            }
                                            else
                                            {
                                                if (empbranchid == "43")
                                                {
                                                    double esiamount = rate * paydays;
                                                    // double esiamount = totalearnings / 10;
                                                    esi = (esiamount * 0.75) / 100;
                                                    esi = Math.Round(esi, 0);
                                                }
                                                else
                                                {
                                                    double esiamount = rate * paydays;
                                                    // double esiamount = totalearnings / 10;
                                                    esi = (esiamount * 0.75) / 100;
                                                    esi = Math.Round(esi, 0);
                                                }
                                            }
                                        }
                                        else
                                        {
                                            esi = 0;
                                            //newrow["ESI"] = esi;
                                        }
                                    }
                                }
                                else
                                {
                                    if (empbranchid == "41" || empbranchid == "8" || empbranchid == "11")
                                    {
                                        if (esieligible == "Yes")
                                        {
                                            esi = (totalearnings * 0.75) / 100;
                                            esi = Math.Round(esi, 0);
                                            //newrow["ESI"] = esi;
                                        }
                                        else
                                        {
                                            esi = 0;
                                            //newrow["ESI"] = esi;
                                        }
                                    }
                                    else
                                    {
                                        if (esieligible == "Yes")
                                        {
                                            esi = (totalearnings * 1.75) / 100;
                                            esi = Math.Round(esi, 0);
                                            //newrow["ESI"] = esi;
                                        }
                                        else
                                        {
                                            esi = 0;
                                           // newrow["ESI"] = esi;
                                        }
                                    }
                                }
                                
                                if (dtsa.Rows.Count > 0)
                                {
                                    DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double amount = 0;
                                            double.TryParse(drsa["amount"].ToString(), out amount);
                                            //newrow["SALARY ADVANCE"] = amount.ToString();
                                            salaryadvance = Convert.ToDouble(amount);
                                            salaryadvance = Math.Round(amount);
                                        }
                                    }
                                    else
                                    {
                                        salaryadvance = 0;
                                        //newrow["SALARY ADVANCE"] = salaryadvance;
                                    }
                                }
                                else
                                {
                                    salaryadvance = 0;
                                    //newrow["SALARY ADVANCE"] = salaryadvance;
                                }
                                if (dtloan.Rows.Count > 0)
                                {
                                    DataRow[] drr = dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drloan in dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double loanemimonth = 0;
                                            double.TryParse(drloan["loanemimonth"].ToString(), out loanemimonth);
                                            // newrow["Loan"] = loanemimonth.ToString();
                                            loan = Convert.ToDouble(loanemimonth);
                                            loan = Math.Round(loanemimonth);
                                        }
                                    }
                                    else
                                    {
                                        loan = 0;
                                        // newrow["Loan"] = loan;
                                    }
                                }
                                else
                                {
                                    loan = 0;
                                    // newrow["Loan"] = loan;
                                }
                                mobilededuction = 0;
                                if (dtmobile.Rows.Count > 0)
                                {
                                    DataRow[] drr = dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drmobile in dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double deductionamount = 0;
                                            double.TryParse(drmobile["deductionamount"].ToString(), out deductionamount);
                                            //newrow["MOBILE DEDUCTION"] = deductionamount.ToString();
                                            string st = deductionamount.ToString();
                                            if (st == "0.0")
                                            {
                                                mobilededuction = 0;
                                                //newrow["MOBILE DEDUCTION"] = mobilededuction;
                                            }
                                            else
                                            {
                                                mobilededuction = Convert.ToDouble(deductionamount);
                                                mobilededuction = Math.Round(deductionamount);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        mobilededuction = 0;
                                        //newrow["MOBILE DEDUCTION"] = mobilededuction;
                                    }
                                }
                                else
                                {
                                    mobilededuction = 0;
                                    //newrow["MOBILE DEDUCTION"] = mobilededuction;
                                }
                                canteendeduction = 0;
                                if (dtcanteen.Rows.Count > 0)
                                {
                                    DataRow[] drr = dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drcanteen in dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double deductionamount = 0;
                                            double.TryParse(drcanteen["amount"].ToString(), out deductionamount);
                                            //newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                            string st = deductionamount.ToString();
                                            canteendeduction = Convert.ToDouble(deductionamount);
                                            canteendeduction = Math.Round(deductionamount);
                                        }
                                    }
                                    else
                                    {
                                        canteendeduction = 0;
                                        //newrow["CANTEEN DEDUCTION"] = canteendeduction;
                                    }
                                }
                                else
                                {
                                    canteendeduction = 0;
                                    // newrow["CANTEEN DEDUCTION"] = canteendeduction;
                                }

                                medicliamdeduction = 0;
                                if (dtmedicliam.Rows.Count > 0)
                                {
                                    DataRow[] drr = dtmedicliam.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drmedicliam in dtmedicliam.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double amount = 0;
                                            double.TryParse(drmedicliam["medicliamamount"].ToString(), out amount);
                                            //newrow["MEDICLAIM DEDUCTION"] = amount.ToString();
                                            string st = amount.ToString();
                                            medicliamdeduction = Convert.ToDouble(amount);
                                            medicliamdeduction = Math.Round(amount, 0);
                                        }
                                    }
                                    else
                                    {
                                        medicliamdeduction = 0;
                                        //newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
                                    }
                                }
                                else
                                {
                                }
                                otherdeduction = 0;
                                if (dtotherdeduction.Rows.Count > 0)
                                {
                                    DataRow[] drr = dtotherdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drotherdeduction in dtotherdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double amount = 0;
                                            double.TryParse(drotherdeduction["otherdeductionamount"].ToString(), out amount);
                                            //newrow["OTHER DEDUCTION"] = amount.ToString();
                                            string st = amount.ToString();
                                            otherdeduction = Convert.ToDouble(amount);
                                            otherdeduction = Math.Round(amount, 0);
                                        }
                                    }
                                    else
                                    {
                                        otherdeduction = 0;
                                        //newrow["OTHER DEDUCTION"] = otherdeduction;
                                    }
                                }
                                else
                                {
                                }
                                tdsdeduction = 0;
                                if (dttdsdeduction.Rows.Count > 0)
                                {
                                    DataRow[] drr = dttdsdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drtdsdeduction in dttdsdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double amount = 0;
                                            double.TryParse(drtdsdeduction["tdsamount"].ToString(), out amount);
                                            //newrow["Tds DEDUCTION"] = amount.ToString();
                                            string st = amount.ToString();
                                            tdsdeduction = Convert.ToDouble(amount);
                                            tdsdeduction = Math.Round(amount, 0);
                                        }
                                    }
                                    else
                                    {
                                        tdsdeduction = 0;
                                        //newrow["Tds DEDUCTION"] = tdsdeduction;
                                    }
                                }
                                else
                                {
                                    tdsdeduction = 0;
                                    //  newrow["Tds DEDUCTION"] = tdsdeduction;
                                }
                                //newrow["TOTAL DEDUCTIONS"] = Math.Ceiling(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi);
                                double ptax = 0;
                                ptax = profitionaltax - losofprofitionaltax;
                                int companyid = Convert.ToInt32(ddlCompanytype.SelectedItem.Value);
                                if (ddlbranchtype.SelectedItem.Text == "Plant" ||  ddlemptype.SelectedItem.Text == "Casuals")
                                {
                                    if (companyid == 4)
                                    {
                                      //  profitionaltax = ptax;
                                    }
                                    else
                                    {
                                        if (totalearnings >= 15000)
                                        {
                                        }
                                        else
                                        {
                                            profitionaltax = 0;
                                        }
                                    }
                                }
                                if (totalearnings >= 15000)
                                {

                                }
                                if (mainbranch == "42")
                                {
                                    totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                                }
                                else
                                {
                                    if (ddlemptype.SelectedItem.Text == "Staff" || ddlemptype.SelectedItem.Text == "Permanent")
                                    {
                                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                                    }
                                    else
                                    {
                                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + esi + medicliamdeduction + otherdeduction);
                                    }
                                }
                                double netpay = 0;
                                netpay = totalearnings - totaldeduction;
                                netpay = Math.Round(netpay, 2);

                                string stramount = "0";
                                stramount = netpay.ToString();
                                if (stramount == "NaN")
                                {
                                }
                                else
                                {
                                    newrow["Net pay"] = netpay;
                                    netpaytotal += netpay;
                                    netpaygrandtotal += netpay;
                                    netpay = netpay + travaltotamount + shiftamount;
                                    double NEGATIVE = 0;
                                    NEGATIVE = Math.Round(netpay + extravalue);
                                    if (ddlemptype.SelectedItem.Text == "Staff" || ddlemptype.SelectedItem.Text == "Permanent")
                                    {
                                        NEGATIVE = Math.Round(netpay + extravalue);
                                    }
                                    else if (ddlemptype.SelectedItem.Text == "Casual worker")
                                    {
                                        NEGATIVE = Math.Round(netpay + otvalue);
                                    }
                                    if (NEGATIVE > 0)
                                    {
                                        newrow["Net Amount"] = NEGATIVE;
                                        netamounttotal += NEGATIVE;
                                        netamountgrandtotal += NEGATIVE;
                                        Report.Rows.Add(newrow);
                                    }
                                    else
                                    {
                                       // newrow["Net Amount"] = "0";
                                        netamounttotal += 0;
                                       // Report.Rows.Add(newrow);
                                    }
                                }
                            }
                        }
                    }
                    DataRow newvartical3 = Report.NewRow();
                    newvartical3["Employee Name"] = "Total";
                    newvartical3["Net pay"] = netpaytotal;
                    newvartical3["Net Amount"] = netamounttotal;
                    //svds1 start
                    if (mainbranch == "6")
                    {
                        if (ddlCompanytype.SelectedValue == "1")
                        {

                            if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Staff")
                            {
                                newvartical3["Extra Pay"] = netextratotal;
                                newvartical3["CONVEYANCE"] = netcontotal;
                            }
                            if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                            {
                                newvartical3["CONVEYANCE"] = netcontotal;
                                newvartical3["Shift Allowance"] = shifttotal;
                            }
                            if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                            {
                                newvartical3["Shift Allowance"] = shifttotal;
                            }
                            if (ddlbranchtype.SelectedItem.Text == "Plant"||ddlbranchtype.SelectedItem.Text == "IFD Plant" & ddlemptype.SelectedItem.Text == "Staff")
                            {
                                newvartical3["Extra Pay"] = netextratotal;
                            }
                        }
                        //svds end
                        //svd start
                        else
                        {
                            if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                            {
                                newvartical3["CONVEYANCE"] = netcontotal;
                                newvartical3["Shift Allowance"] = shifttotal;
                            }
                            if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                            {
                                // newvartical3["CONVEYANCE"] = netcontotal;
                                newvartical3["Shift Allowance"] = shifttotal;
                            }

                        }
                        //svd end
                    }
                    //svf start
                    else
                    {
                        if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Permanent")
                        {
                            newvartical3["Extra Pay"] = netextratotal;

                        }
                        if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Casual worker")
                        {
                            newvartical3["OT Amount"] = netottotal;

                        }
                        //svf end

                    }
                    Report.Rows.Add(newvartical3);
                    DataRow newTotal = Report.NewRow();
                    newTotal["Employee Name"] = "Grand Total";
                    newTotal["Net pay"] = netpaygrandtotal;
                    newTotal["Net Amount"] = netamountgrandtotal;
                    //svds1 start
                    if (mainbranch == "6")
                    {

                        if (ddlCompanytype.SelectedValue == "1")
                        {

                            if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Staff")
                            {
                                newTotal["Extra Pay"] = netextragrandtotal;
                                newTotal["CONVEYANCE"] = netcongrandtotal;
                            }
                            if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                            {
                                newTotal["CONVEYANCE"] = netcongrandtotal;
                                newTotal["Shift Allowance"] = shiftgrandtotal;
                            }
                            if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                            {
                                newTotal["Shift Allowance"] = shiftgrandtotal;
                            }
                            if (ddlbranchtype.SelectedItem.Text == "Plant" || ddlbranchtype.SelectedItem.Text == "IFD Plant" & ddlemptype.SelectedItem.Text == "Staff")
                            {
                                newTotal["Extra Pay"] = netextragrandtotal;
                            }
                        }
                        //svds start
                        //svd start
                        else
                        {

                            if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                            {
                                newTotal["CONVEYANCE"] = netcongrandtotal;
                                newTotal["Shift Allowance"] = shiftgrandtotal;
                            }
                            if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                            {
                                // newTotal["CONVEYANCE"] = netcongrandtotal;
                                newTotal["Shift Allowance"] = shiftgrandtotal;
                            }
                        }
                        //svd end


                    }
                    //svf start
                    else
                    {
                        if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Permanent")
                        {
                            newTotal["Extra Pay"] = netextragrandtotal;
                        }
                        if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Casual worker")
                        {
                            newTotal["OT Amount"] = netotgrandtotal;

                        }

                    }
                    //svf end
                    double val = 0.0;
                    Report.Rows.Add(newTotal);
                }
                grdReports.DataSource = Report;
                if(Report.Rows.Count>2)
                {
                    grdReports.DataBind();
                    Session["xportdata"] = Report;
                    hidepanel.Visible = true;
                }              
                else{
                    hidepanel.Visible = false;
                    lblmsg.Text = "No Data Found";
                }

            }
            else if (ddlbranchtype.SelectedItem.Text == "Driver")
            {
                Report.Columns.Add("SNO");
                Report.Columns.Add("Location");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Employee Name");
                Report.Columns.Add("DESIGNATION");
                Report.Columns.Add("OTHER DEDUCTIONS");
                Report.Columns.Add("Gross Earnings");
                Report.Columns.Add("Net pay").DataType = typeof(double);
                Report.Columns.Add("Extra pay").DataType = typeof(double);
                Report.Columns.Add("Net Amount").DataType = typeof(double);
                Report.Columns.Add("Bank Acc No");
                Report.Columns.Add("IFSC Code");
                cmd = new SqlCommand("SELECT address, companyname FROM company_master WHERE (sno = @sno)");
                cmd.Parameters.Add("@sno", ddlCompanytype.SelectedValue);
                DataTable dtcompany = vdm.SelectQuery(cmd).Tables[0];
                if (dtcompany.Rows.Count > 0)
                {
                    lblAddress.Text = dtcompany.Rows[0]["address"].ToString();
                    lblTitle.Text = dtcompany.Rows[0]["companyname"].ToString();
                }
                else
                {
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                }

                int branchid = Convert.ToInt32(mainbranch);
                string employee_type = ddlemptype.SelectedItem.Value;
                if (ddlemptype.SelectedItem.Text == "Cleaner")
                {
                    cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.branchid,employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num,employedetails.fullname AS Expr2, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund,salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance,salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE  (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = 'Cleaner') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = 'Driver' OR employedetails.employee_type = 'Cleaner') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)ORDER BY branchmaster.branchname");
                }
                else
                {
                    if (ddlbank.SelectedItem.Text == "All")
                    {
                       cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.branchid,employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num,employedetails.fullname AS Expr2, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund,salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance,salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE   (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = 'Driver') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR  (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = 'Driver' OR employedetails.employee_type = 'Cleaner') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)ORDER BY branchmaster.branchname");
                    }
                    else
                    {
                        cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.branchid,employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num,employedetails.fullname AS Expr2, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund,salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance,salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE  (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = 'Driver') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employebankdetails.bankid = @bankid) AND (branchmaster.company_code = @company_code) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = 'Driver' OR employedetails.employee_type = 'Cleaner') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)ORDER BY branchmaster.branchname");
                    }

                }

               // employedetails.employee_type = 'Cleaner'

                cmd.Parameters.Add("@m", mainbranch);
                cmd.Parameters.Add("@d1", date);
                if (ddlbank.SelectedItem.Text == "All")
                {

                }
                else
                {
                    cmd.Parameters.Add("@bankid", ddlbank.SelectedItem.Value);
                }
                //cmd.Parameters.Add("@branchtype", ddlbranchtype.SelectedItem.Text);
                cmd.Parameters.Add("@company_code", ddlCompanytype.SelectedValue);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];



                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.extradays, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.month FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (loan_request.month = @month) AND (loan_request.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where (mobile_deduction.month = @month) AND (mobile_deduction.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where  (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtcanteen = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, otherdeduction.otherdeductionamount FROM employedetails INNER JOIN otherdeduction ON employedetails.empid = otherdeduction.empid WHERE (employedetails.branchid = @branchid) AND (otherdeduction.month = @month) AND (otherdeduction.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtotherdeduction = vdm.SelectQuery(cmd).Tables[0];
                if (dtsalary.Rows.Count > 0)
                {
                    var i = 1;
                    foreach (DataRow dr in dtsalary.Rows)
                    {
                        double totalpresentdays = 0;
                        double profitionaltax = 0;
                        double salaryadvance = 0;
                        double loan = 0;
                        double canteendeduction = 0;
                        double mobilededuction = 0;
                        double totaldeduction;
                        double numberofworkingdays = 0;
                        double extradays = 0;
                         double extravalue=0;
                        double totalearnings = 0;
                        double providentfund = 0;
                        double daysinmonth = 0;
                        string statename = "";
                        DataRow newrow = Report.NewRow();
                        newrow["SNO"] = i++.ToString();
                        newrow["Location"] = dr["branchname"].ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Employee Name"] = dr["fullname"].ToString();
                        newrow["DESIGNATION"] = dr["designation"].ToString();
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        
                        double rateper = Convert.ToDouble(dr["gross"].ToString());
                        newrow["Bank Acc No"] = "'" + dr["accountno"].ToString() + "";
                        newrow["IFSC Code"] = dr["ifsccode"].ToString();
                        if (dtattendence.Rows.Count > 0)
                        {
                            foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                            {
                                double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double clorwo = 0;
                                double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                daysinmonth = numberofworkingdays + clorwo;
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = daysinmonth - lop;
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                double.TryParse(dra["extradays"].ToString(), out extradays);
                               
                                totalpresentdays = holidays + paydays;
                                double rate = Convert.ToDouble(dr["gross"].ToString());
                                extravalue = extradays * rate;
                                double batta = 0;
                                if (ddlbranchtype.SelectedItem.Text == "Driver")
                                {

                                    if (ddlemptype.SelectedItem.Text == "Cleaner")
                                    {
                                        batta = 80;
                                        string empnumber = dr["employee_num"].ToString();
                                        if (empnumber == "SVDS080135" || empnumber == "SVDS100095")
                                        {
                                            batta = 0;
                                        }
                                        else
                                        {
                                        }
                                    }
                                    else
                                    {

                                        batta = 0;
                                        double GROSSSAL = rateper * 15;
                                        if (lop > 15)
                                        {
                                            lop = lop - 15;
                                        }

                                        double loss = lop * rateper;
                                        double gainsal = GROSSSAL - loss;
                                        double BasicSAL = 50;
                                        BasicSAL = (gainsal * 50) / 100;
                                        double CONALLAWANCE = 1600;
                                        double perdayconveyance = CONALLAWANCE / 15;
                                        double loseofconviyance = lop * perdayconveyance;
                                        double MEDICALALLAWANCE = 1250;
                                        double perdayMEDICALALLAWANCE = MEDICALALLAWANCE / 15;
                                        double loseofMEDICALALLAWANCE = lop * perdayMEDICALALLAWANCE;
                                        double WASHINGALLAWANCE = 1000;
                                        double perdayWASHINGALLAWANCE = WASHINGALLAWANCE / 15;
                                        double loseofWASHINGALLAWANCE = lop * perdayWASHINGALLAWANCE;
                                        CONALLAWANCE = Math.Round(CONALLAWANCE - loseofconviyance, 0);
                                        MEDICALALLAWANCE = Math.Round(MEDICALALLAWANCE - loseofMEDICALALLAWANCE, 0);
                                        WASHINGALLAWANCE = Math.Round(WASHINGALLAWANCE - loseofWASHINGALLAWANCE, 0);
                                        double totalerngs = BasicSAL + CONALLAWANCE + MEDICALALLAWANCE + WASHINGALLAWANCE;
                                        double thra = gainsal;
                                        double hra = Math.Round(thra - totalerngs);
                                        double HRA = hra;
                                    }
                                }
                                else
                                {
                                    
                                        batta = 80;
                                        //newrow["Work Days"] = daysinmonth.ToString();
                                        //newrow["Rate/Day"] = rateper;
                                        string empnumber = dr["employee_num"].ToString();
                                        if (empnumber == "SVDS080135" || empnumber == "SVDS100095")
                                        {
                                            // newrow["Batta/Day"] = "0";
                                            batta = 0;
                                        }
                                        else
                                        {
                                            //newrow["Batta/Day"] = batta;
                                        }
                                   
                                }
                                double rateperday = rate + batta;
                                totalearnings = rateperday * paydays;
                                double totalpdays = numberofworkingdays - lop;
                                totalearnings = Math.Round(totalearnings);
                                newrow["Gross Earnings"] = totalearnings;
                                newrow["Extra pay"] = extravalue;
                                string pfeligible = dr["pfeligible"].ToString();
                                if (pfeligible == "Yes")
                                {
                                    providentfund = (totalearnings * 6) / 100;
                                    if (providentfund > 1800)
                                    {
                                        providentfund = 1800;
                                    }
                                    providentfund = Math.Round(providentfund, 0);
                                   // newrow["PF"] = Math.Round(providentfund, 0);
                                }
                                else
                                {
                                    providentfund = 0;
                                    //newrow["PF"] = providentfund;
                                }
                                if (statename == "AndraPrdesh")
                                {
                                    if (totalearnings > 1000 && totalearnings <= 15000)
                                    {
                                        profitionaltax = 0;
                                    }
                                    else if (totalearnings >= 15001 && totalearnings <= 20000)
                                    {
                                        profitionaltax = 150;
                                    }
                                    else if (totalearnings >= 20001)
                                    {
                                        profitionaltax = 200;
                                    }
                                }
                                if (statename == "Tamilnadu")
                                {
                                    if (totalearnings < 7000)
                                    {
                                        profitionaltax = 0;
                                    }
                                    else if (totalearnings >= 7001 && totalearnings <= 10000)
                                    {
                                        profitionaltax = 115;
                                    }
                                    else if (totalearnings >= 10001 && totalearnings <= 11000)
                                    {
                                        profitionaltax = 171;
                                    }
                                    else if (totalearnings >= 11001 && totalearnings <= 12000)
                                    {
                                        profitionaltax = 171;
                                    }
                                    else if (totalearnings >= 12001)
                                    {
                                        profitionaltax = 208;
                                    }
                                }
                                if (statename == "karnataka")
                                {
                                    if (totalearnings <= 15000 && totalearnings <= 15001)
                                    {
                                        profitionaltax = 0;
                                    }
                                    else if (totalearnings >= 15001)
                                    {
                                        profitionaltax = 200;
                                    }
                                }
                            }
                        }
                        if (dtsa.Rows.Count > 0)
                        {
                            DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double amount = 0;
                                    double.TryParse(drsa["amount"].ToString(), out amount);
                                    //newrow["SALARY ADVANCE"] = amount.ToString();
                                    salaryadvance = Convert.ToDouble(amount);
                                    salaryadvance = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                salaryadvance = 0;
                                // newrow["SALARY ADVANCE"] = salaryadvance;
                            }
                        }
                        if (dtloan.Rows.Count > 0)
                        {
                            DataRow[] drr = dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drloan in dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double loanemimonth = 0;
                                    double.TryParse(drloan["loanemimonth"].ToString(), out loanemimonth);
                                    //newrow["Loan"] = loanemimonth.ToString();
                                    loan = Convert.ToDouble(loanemimonth);
                                    loan = Math.Round(loanemimonth, 0);
                                }
                            }
                            else
                            {
                                loan = 0;
                                //newrow["Loan"] = loan;
                            }
                        }
                        mobilededuction = 0;
                        if (dtmobile.Rows.Count > 0)
                        {
                            DataRow[] drr = dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drmobile in dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double deductionamount = 0;
                                    double.TryParse(drmobile["deductionamount"].ToString(), out deductionamount);
                                    //newrow["MOBILE DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    if (st == "0.0")
                                    {
                                        mobilededuction = 0;
                                        //newrow["MOBILE DEDUCTION"] = mobilededuction;

                                    }
                                    else
                                    {
                                        mobilededuction = Convert.ToDouble(deductionamount);
                                        mobilededuction = Math.Round(deductionamount, 0);
                                    }
                                }
                            }
                            else
                            {
                                mobilededuction = 0;
                                //newrow["MOBILE DEDUCTION"] = mobilededuction;
                            }
                        }
                        canteendeduction = 0;
                        if (dtcanteen.Rows.Count > 0)
                        {
                            DataRow[] drr = dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drcanteen in dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double deductionamount = 0;
                                    double.TryParse(drcanteen["amount"].ToString(), out deductionamount);
                                    //newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    canteendeduction = Convert.ToDouble(deductionamount);
                                    canteendeduction = Math.Round(deductionamount, 0);
                                }
                            }
                            else
                            {
                                canteendeduction = 0;
                                //newrow["CANTEEN DEDUCTION"] = canteendeduction;
                            }
                        }
                        double otherdeduction = 0;
                        if (dtotherdeduction.Rows.Count > 0)
                        {
                            DataRow[] drr = dtotherdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drotherdeduction in dtotherdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double amount = 0;
                                    double.TryParse(drotherdeduction["otherdeductionamount"].ToString(), out amount);
                                    newrow["OTHER DEDUCTIONS"] = amount.ToString();
                                    string st = amount.ToString();
                                    otherdeduction = Convert.ToDouble(amount);
                                    otherdeduction = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                otherdeduction = 0;
                                newrow["OTHER DEDUCTIONS"] = otherdeduction;
                            }
                        }
                        else
                        {
                        }
                        // newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction);
                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + otherdeduction + providentfund);
                        double netpay = 0;
                        netpay = Math.Round(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 0);

                        double netamt = 0;
                        netamt = extravalue + netpay;

                        string stramount = "";
                        stramount = netpay.ToString();
                        if (stramount == "NaN" || stramount == "" || numberofworkingdays == 0)
                        {
                        }
                        else
                        {
                            newrow["Net pay"] = Math.Round(netpay, 0);
                            newrow["Net Amount"] = Math.Round(netamt, 0);
                            Report.Rows.Add(newrow);
                        }
                        //newrow["Net pay"] = Math.Ceiling(netpay);
                    }
                }
                DataRow newTotal = Report.NewRow();
                newTotal["Employee Name"] = "Grand Total";
                double val = 0.0;
                foreach (DataColumn dc in Report.Columns)
                {
                    if (dc.DataType == typeof(Double))
                    {
                        val = 0.0;
                        double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out val);
                        if (val == 0)
                        {
                        }
                        else
                        {
                            newTotal[dc.ToString()] = val;
                        }
                    }
                }
                Report.Rows.Add(newTotal);
                grdReports.DataSource = Report;
                grdReports.DataBind();
                Session["xportdata"] = Report;
                hidepanel.Visible = true;
            }
            else
            {
                hidepanel.Visible = false;
                lblmsg.Text = "No data were found";                
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
            string mainb = Session["mainbranch"].ToString();
            if (mainb == "42")
            {
                GridViewGroup First = new GridViewGroup(grdReports, null, "Location");
                GridViewGroup seconf = new GridViewGroup(grdReports, First, "EMPTYPE");
                // GridViewGroup three = new GridViewGroup(grdReports, seconf, "PF");
            }
            else
            {
                GridViewGroup First = new GridViewGroup(grdReports, null, "Location");
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        string mainbb = Session["mainbranch"].ToString();
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (mainbb == "42")
            {
                if (e.Row.Cells[4].Text == "Grand Total")
                {
                    e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
                    e.Row.Font.Size = FontUnit.Large;
                    e.Row.Font.Bold = true;
                }
            }
            else
            {
                if (e.Row.Cells[3].Text == "Grand Total")
                {
                    e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
                    e.Row.Font.Size = FontUnit.Large;
                    e.Row.Font.Bold = true;
                }

            }

            if (mainbb == "42")
            {
                if (e.Row.Cells[4].Text == "Total")
                {
                    e.Row.BackColor = System.Drawing.Color.Aquamarine;
                    e.Row.Font.Size = FontUnit.Large;
                    e.Row.Font.Bold = true;
                }
            }
            else
            {
                if (ddlemptype.SelectedItem.Text != "Driver")
                {
                    if (e.Row.Cells[3].Text == "Total")
                    {
                        e.Row.BackColor = System.Drawing.Color.Aquamarine;
                        e.Row.Font.Size = FontUnit.Large;
                        e.Row.Font.Bold = true;
                    }

                }
            }
        }
    }

}