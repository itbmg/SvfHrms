using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class PFcalculationReport : System.Web.UI.Page
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
                    DateTime dtyear = DateTime.Now.AddYears(0);
                    //dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    //bindbranchs();
                    PopulateYear();
                    bindcompany();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    ddlmonth.SelectedValue = str[1];
                    string fryear = dtyear.ToString("dd/MM/yyyy");
                    string[] str1 = fryear.Split('/');
                    ddlyear.SelectedValue = str1[2];
                   // bindbranchs();
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
    private void bindbranchs()
    {

        DBManager SalesDB = new DBManager();
        //branchwise
        //cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='1'");
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname,branchmaster.fromdate,branchmaster.todate, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
        cmd.Parameters.Add("@m", mainbranch);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        //ddlbranch.DataSource = dttrips;
        //ddlbranch.DataTextField = "branchname";
        //ddlbranch.DataValueField = "branchid";
        //ddlbranch.DataBind();
        //ddlbranch.ClearSelection();
        //ddlbranch.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        //ddlbranch.SelectedValue = "0";
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
 
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            //string empid = txtsupid.Text;
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            string year = ddlyear.SelectedItem.Value;
            string currentyear = (mydate.Year).ToString();
            string mymonth = ddlmonth.SelectedItem.Value;
            string day = (mydate.Day).ToString();
            string date = mymonth + "/" + day + "/" + year;
            double totalpresentdays = 0;
            double profitionaltax = 0;
            double salaryadvance = 0;
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
            double lop = 0;
            double losofprofitionaltax = 0;
            //string type = ddlbranch.SelectedItem.Value;
            lblHeading.Text = "ECR PF Challan  Details" + " " + ddlmonth.SelectedItem.Text + " " + ddlyear.SelectedItem.Text;
            Session["filename"] = "ECR PF Challan  Details" + " " + ddlmonth.SelectedItem.Text + " " + ddlyear.SelectedItem.Text;
            Session["title"] = "ECR PF Challan  Details" + " " + ddlmonth.SelectedItem.Text + " " + ddlyear.SelectedItem.Text;
            Report.Columns.Add("Sno");
            Report.Columns.Add("UAN");
            Report.Columns.Add("Member Name");
            Report.Columns.Add("Gross Wages");
            Report.Columns.Add("EPF Wages");
            Report.Columns.Add("EPS Wages");
            Report.Columns.Add("EDLI Wages");
            Report.Columns.Add("EPF Contri Remitted");
            Report.Columns.Add("EPS Contri Remitted");
            Report.Columns.Add("EPF EPS Diff Remitted");
            Report.Columns.Add("NCP Days");
            Report.Columns.Add("Refund of Advances");
            string mainbranch = Session["mainbranch"].ToString();
            cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.employee_num, employedetails.fullname, branchmaster.company_code, employepfdetails.uannumber, salaryappraisals.gross, salaryappraisals.salaryperyear, salaryappraisals.providentfund, salaryappraisals.erningbasic, monthly_attendance.lop, monthly_attendance.month, monthly_attendance.year, monthly_attendance.numberofworkingdays, monthly_attendance.clorwo, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance FROM  employedetails INNER JOIN  branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN  employepfdetails ON employedetails.empid = employepfdetails.employeid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmaster.company_code = @companycode) AND (employedetails.pfeligible = 'yes') AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'NO')  AND (employepfdetails.uannumber <> '0') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)  AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) AND (employedetails.pfstate=@pfstate) OR (branchmaster.company_code = @companycode) AND (employedetails.pfeligible = 'yes') AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'NO') AND (employepfdetails.uannumber <> '0') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)  AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1) AND (employedetails.pfstate=@pfstate)");
            //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.employee_num, employedetails.fullname, branchmaster.company_code, employepfdetails.uannumber,salaryappraisals.gross, salaryappraisals.salaryperyear,salaryappraisals.providentfund, salaryappraisals.erningbasic, monthly_attendance.lop, monthly_attendance.month, monthly_attendance.year, monthly_attendance.numberofworkingdays, monthly_attendance.clorwo, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance FROM employedetails INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmaster.company_code = @companycode) AND (employedetails.pfeligible = 'yes') AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'NO') AND (employepfdetails.uannumber <> '0') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) and branchmaster.branchid=@branch");
            cmd.Parameters.Add("@m", mainbranch);
            //cmd.Parameters.Add("@branch", ddlbranch.SelectedItem.Value);
            cmd.Parameters.Add("@companycode", ddlCompanytype.SelectedValue);
            cmd.Parameters.Add("@month", ddlmonth.SelectedValue);
            cmd.Parameters.Add("@year", ddlyear.SelectedValue);
            cmd.Parameters.Add("@d1", date);
            cmd.Parameters.Add("@pfstate", ddlstate.SelectedValue);

            DataTable dtAdvance = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtAdvance.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtAdvance.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    newrow["UAN"] = dr["uannumber"].ToString();
                    newrow["Member Name"] = dr["fullname"].ToString();
                    newrow["Gross Wages"] = dr["gross"].ToString();
                    double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                    double permonth = peryanam / 12;
                    double HRA = Convert.ToDouble(dr["hra"].ToString());
                    double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                    convenyance = Convert.ToDouble(dr["conveyance"].ToString());
                    profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                    medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
                    washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
                    foreach (DataRow dra in dtAdvance.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                    {
                        double numberofworkingdays = 0;
                        double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                        double clorwo = 0;
                        double.TryParse(dra["clorwo"].ToString(), out clorwo);
                        daysinmonth = numberofworkingdays + clorwo;
                        //newrow["DAYS MONTH"] = daysinmonth.ToString();
                        double paydays = 0;
                        
                        double.TryParse(dra["lop"].ToString(), out lop);
                        paydays = numberofworkingdays - lop;
                        //newrow["Attendance Days"] = paydays.ToString();
                        double holidays = 0;
                        holidays = daysinmonth - numberofworkingdays;
                        if (lop != 0)
                        {
                            double totaldays = paydays + clorwo;
                            //newrow["Payable Days"] = totaldays;
                        }
                        else
                        {
                            //newrow["Payable Days"] = paydays + clorwo;
                        }
                        if (clorwo == 0)
                        {
                        }
                        else
                        {
                            //newrow["CL HOLIDAY AND OFF"] = clorwo;
                        }
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
                        double perdaprofitionaltax = profitionaltax / daysinmonth;
                        losofprofitionaltax = lop * perdaprofitionaltax;
                    }
                    double perdaysal = permonth / daysinmonth;
                    double basic = 50;
                    double basicsalary = (permonth * 50) / 100;
                    double basicpermonth = basicsalary / daysinmonth;
                    double bs = basicpermonth * totalpresentdays;
                    //newrow["BASIC"] = Math.Round(bs);
                    //newrow["CONVEYANCE ALLOWANCE"] = Math.Round(convenyance - loseofconviyance);
                    //newrow["MEDICAL ALLOWANCE"] = Math.Round(medicalerning - loseofmedical);
                    //newrow["WASHING ALLOWANCE"] = Math.Round(washingallowance - loseofwashing);
                    double basicsal = Math.Round(basicsalary - loseamount);
                    double conve = Math.Round(convenyance - loseofconviyance);
                    double medical = Math.Round(medicalerning - loseofmedical);
                    double washing = Math.Round(washingallowance - loseofwashing);
                    double tt = bs + conve + medical + washing;
                    double thra = permonth - loseamount;
                    double hra = Math.Round(thra - tt);
                    totalearnings = Math.Round(hra + tt);
                    double ephwage = 15000;
                    if (totalearnings >= 30000)
                    {

                        newrow["EPF Wages"] = 15000;
                        newrow["EPS Wages"] = 15000;
                        newrow["EDLI Wages"] = 15000;
                    }
                    else
                    {
                        newrow["EPF Wages"] = Math.Round(bs, 0);
                        newrow["EPS Wages"] = Math.Round(bs, 0);
                        newrow["EDLI Wages"] = Math.Round(bs, 0);
                    }
                    double epfconrrl = bs;
                    double providentfundepf = 0;
                    double providentfundeps = 0;
                    string pfeligible = dr["pfeligible"].ToString();
                    if (pfeligible == "Yes")
                    {
                        providentfundepf = (epfconrrl * 12) / 100;
                        providentfundepf = Math.Round(providentfundepf, 0);
                        newrow["EPF Contri Remitted"] = Math.Round(providentfundepf, 0);
                    }
                    else
                    {
                        providentfundepf = 0;
                        newrow["EPF Contri Remitted"] = providentfundepf;
                    }
                    providentfundeps = (epfconrrl * 8.33) / 100;
                    newrow["EPF Contri Remitted"] = Math.Round(providentfundepf, 0);
                    newrow["EPS Contri Remitted"] = Math.Round(providentfundeps, 0);
                    newrow["EPF EPS Diff Remitted"] = Math.Round(providentfundepf - providentfundeps);
                    newrow["NCP Days"] = dr["lop"].ToString();
                    // newrow["NCP Days"] = dr["lop"].ToString();
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