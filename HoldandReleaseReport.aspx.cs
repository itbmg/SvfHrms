using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class HoldandReleaseReport : System.Web.UI.Page
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
                    DateTime dtfrom = DateTime.Now.AddMonths(-1);
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    ddlmonth.SelectedValue = str[1];
                    PopulateYear();
                    bindbranchs();
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

    private void bindbranchs()
    {
        DBManager SalesDB = new DBManager();
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
        cmd.Parameters.Add("@m", mainbranch); 
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlbranch.DataSource = dttrips;
        ddlbranch.DataTextField = "branchname";
        ddlbranch.DataValueField = "branchid";
        ddlbranch.DataBind();
        ddlbranch.ClearSelection();
        ddlbranch.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        ddlbranch.SelectedValue = "0";
    }

    DataTable Report = new DataTable();
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            string year = ddlyear.SelectedItem.Value;
            string mymonth = ddlmonth.SelectedItem.Value;
            string day = "";
            if (mymonth == "02")
            {
                day = "28";
            }
            else
            {
                day = (mydate.Day).ToString();
            }
            string d = "00";
            string date = mymonth + "/" + day + "/" + year;

            lblHeading.Text = ddlbranch.SelectedItem.Text + " Hold and Release Report" + " " + ddlmonth.SelectedItem.Text + year;
            lblFromDate.Text = mymonth;
            fromdate = Convert.ToDateTime(date);
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string hmonth = dtfrom.ToString("MMM/yyyy");
            Session["filename"] = ddlbranch.SelectedItem.Text + " Hold And Release Report" + " " + ddlmonth.SelectedItem.Text + year;
            Session["title"] = ddlbranch.SelectedItem.Text + " Hold And Release Report" + " " + ddlmonth.SelectedItem.Text + year;
            Report.Columns.Add("SNO");
            Report.Columns.Add("Employeeid");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            Report.Columns.Add("DESIGNATION");
            Report.Columns.Add("HoldMonth");
            Report.Columns.Add("Relese Month");
            Report.Columns.Add("Is Released");
            Report.Columns.Add("Hold Remarks");
            Report.Columns.Add("Release Remarks");
            Report.Columns.Add("Hold Reason");
            Report.Columns.Add("Release Reason");
            Report.Columns.Add("Holded Salary").DataType = typeof(double);
            Report.Columns.Add("Released Salary");
            Report.Columns.Add("Bank Name(As On Released Month)");
            Report.Columns.Add("Bank Account No(As On Released Month)");
            string[] str = frmdate.Split('/');
            int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
            cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employedetails.employee_num, employedetails.fullname, designation.designation, employebankdetails.accountno, payrolldetails.status, monthly_attendance.month, monthly_attendance.year, bankmaster.bankname, salaryappraisals.gross,  salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM payrolldetails LEFT OUTER JOIN salaryappraisals INNER JOIN employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid ON salaryappraisals.empid = employedetails.empid ON payrolldetails.empid = employedetails.empid LEFT OUTER JOIN bankmaster INNER JOIN employebankdetails ON bankmaster.sno = employebankdetails.bankid ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.status = 'No') AND (employedetails.branchid = @branchid) AND (payrolldetails.status = 'Hold') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR(employedetails.status = 'No') AND (employedetails.branchid = @branchid) AND (payrolldetails.status = 'Hold') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
           //paystrure
            // cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employedetails.empid, employedetails.employee_num, employedetails.fullname, designation.designation, employebankdetails.accountno, payrolldetails.status, pay_structure.erningbasic, pay_structure.esi, pay_structure.profitionaltax, pay_structure.hra, pay_structure.conveyance, pay_structure.medicalerning, pay_structure.providentfund, pay_structure.washingallowance, pay_structure.salaryperyear, pay_structure.mediclaimdeduction, monthly_attendance.month, monthly_attendance.year, bankmaster.bankname FROM  bankmaster INNER JOIN employebankdetails ON bankmaster.sno = employebankdetails.bankid RIGHT OUTER JOIN monthly_attendance INNER JOIN employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN payrolldetails ON employedetails.empid = payrolldetails.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid ON monthly_attendance.empid = employedetails.empid ON employebankdetails.employeid = employedetails.empid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (payrolldetails.status = 'Hold') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@month", str[1]);
            cmd.Parameters.Add("@d1", date);
            cmd.Parameters.Add("@year", year);
            DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.clorwo,monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
            cmd.Parameters.Add("@month", str[1]);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid)");
            cmd.Parameters.Add("@month", str[1]);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.months, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid)");
            cmd.Parameters.Add("@month", str[1]);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where (employedetails.branchid=@branchid)");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where (employedetails.branchid=@branchid)");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable dtcanteen = vdm.SelectQuery(cmd).Tables[0];
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
                    DataRow newrow = Report.NewRow();
                    newrow["SNO"] = i++.ToString();
                    newrow["Employeeid"] = dr["empid"].ToString();
                    newrow["Employee Code"] = dr["employee_num"].ToString();
                    newrow["Name"] = dr["fullname"].ToString();
                    newrow["DESIGNATION"] = dr["designation"].ToString();
                    newrow["HoldMonth"] = hmonth; 
                    string status= dr["status"].ToString();
                    if(status=="Hold"){
                        status="No";
                    }
                    else if (status == "completed")
                    {
                         status="Yes";
                    }
                    newrow["Is Released"] = status;
                    double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                    //newrow["GROSS"] = peryanam / 12;
                    double permonth = peryanam / 12;
                    double HRA = Convert.ToDouble(dr["hra"].ToString());
                    double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                    convenyance = Convert.ToDouble(dr["conveyance"].ToString());
                    //newrow["PT"] = dr["profitionaltax"].ToString();
                    profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                    medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
                    washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
                    newrow["Bank Name(As On Released Month)"] = dr["bankname"].ToString();
                    newrow["Bank Account No(As On Released Month)"] = dr["accountno"].ToString();
                    Report.Rows.Add(newrow);
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
                            double paydays = 0;
                            double lop = 0;
                            double.TryParse(dra["lop"].ToString(), out lop);
                            paydays = numberofworkingdays - lop;
                            //newrow["Payable Days"] = paydays;
                            double holidays = 0;
                            holidays = daysinmonth - numberofworkingdays;
                            //newrow["CL HOLIDAY AND OFF"] = holidays;
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
                        }
                    }
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
                    double thra = permonth - loseamount;
                    double hra = Math.Round(thra - tt);
                    totalearnings = Math.Round(hra + tt);
                    string pfeligible = dr["pfeligible"].ToString();
                    if (pfeligible == "Yes")
                    {
                        providentfund = (totalearnings * 6) / 100;
                        if (providentfund > 1800)
                        {
                            providentfund = 1800;
                        }
                        providentfund = Math.Ceiling(providentfund);
                        //newrow["PF"] = providentfund;
                    }
                    else
                    {
                        providentfund = 0;
                        //newrow["PF"] = providentfund;
                    }
                    string esieligible = dr["esieligible"].ToString();
                    if (esieligible == "Yes")
                    {
                        esi = (totalearnings * 1.75) / 100;
                        esi = Math.Ceiling(esi);
                        //newrow["ESI"] = esi;
                    }
                    else
                    {
                        esi = 0;
                        //newrow["ESI"] = esi;
                    }
                    if (dtsa.Rows.Count > 0)
                    {
                        foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                        {
                            double amount = 0;
                            double.TryParse(drsa["amount"].ToString(), out amount);
                            //newrow["SALARY ADVANCE"] = amount.ToString();
                            salaryadvance = Convert.ToDouble(amount);
                            salaryadvance = Math.Ceiling(amount);
                        }
                    }
                    else
                    {
                        salaryadvance = 0;
                    }

                    if (dtloan.Rows.Count > 0)
                    {
                        foreach (DataRow drloan in dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                        {
                            double loanemimonth = 0;
                            double.TryParse(drloan["loanemimonth"].ToString(), out loanemimonth);
                            //newrow["Loan"] = loanemimonth.ToString();
                            loan = Convert.ToDouble(loanemimonth);
                            loan = Math.Ceiling(loanemimonth);
                        }
                    }
                    else
                    {
                        loan = 0;
                    }
                    mobilededuction = 0;

                    if (dtmobile.Rows.Count > 0)
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
                            }
                            else
                            {
                                mobilededuction = Convert.ToDouble(deductionamount);
                                mobilededuction = Math.Ceiling(deductionamount);
                            }
                        }
                    }
                    canteendeduction = 0;

                    if (dtmobile.Rows.Count > 0)
                    {
                        foreach (DataRow drcanteen in dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                        {
                            double deductionamount = 0;
                            double.TryParse(drcanteen["amount"].ToString(), out deductionamount);
                            //newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                            string st = deductionamount.ToString();
                            if (st == "0.0")
                            {
                                canteendeduction = 0;
                            }
                            else
                            {
                                canteendeduction = Convert.ToDouble(deductionamount);
                                canteendeduction = Math.Ceiling(deductionamount);
                            }
                        }
                    }
                    //newrow["TOTAL DEDUCTIONS"] = Math.Ceiling(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi);
                    totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi);
                    double netpay = 0;
                    netpay = Math.Ceiling(totalearnings - totaldeduction);
                    netpay = Math.Round(netpay, 2);
                    newrow["Holded Salary"] = Math.Ceiling(netpay);
                }
            }
            DataRow newTotal = Report.NewRow();
            newTotal["DESIGNATION"] = "Total";
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
            if (Report.Rows.Count > 2)
            {
                grdReports.DataBind();
                Session["xportdata"] = Report;
                hidepanel.Visible = true;
            }
            else
            {
                hidepanel.Visible = false;
                lblmsg.Text = "No Data Found";
            }
        }
        catch
        {
        }
    }
}