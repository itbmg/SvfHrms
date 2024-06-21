using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class Finalsalary_statement : System.Web.UI.Page
{
    SqlCommand cmd;
    string userid = "";
    DBManager vdm;
    int i = 0;
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
                    PopulateYear();
                    bindbranchs();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    ddlmonth.SelectedValue = str[1];
                    DateTime dtyear = DateTime.Now.AddYears(0);
                    string fryear = dtyear.ToString("dd/MM/yyyy");
                    string[] str1 = fryear.Split('/');
                    ddlyear.SelectedValue = str1[2];
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
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m) ");
        cmd.Parameters.Add("@m", mainbranch); 
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlbranches.DataSource = dttrips;
        ddlbranches.DataTextField = "branchname";
        ddlbranches.DataValueField = "branchid";
        ddlbranches.DataBind();
        ddlbranches.ClearSelection();
        ddlbranches.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        ddlbranches.SelectedValue = "0";
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
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            //string year = "2016";
            string year = ddlyear.SelectedItem.Value;
            string currentyear = (mydate.Year).ToString();
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
            //string day = (mydate.Day).ToString();
            string date = mymonth + "/" + day + "/" + year;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth;
            Session["filename"] = ddlbranches.SelectedItem.Text + "Final Salary Statement " + " " + ddlmonth.SelectedItem.Text + year;
            Session["title"] = ddlbranches.SelectedItem.Text + " Final Salary Statement " + " " + ddlmonth.SelectedItem.Text + year;
            Report.Columns.Add("Department");
            Report.Columns.Add("Sno");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            Report.Columns.Add("Designation");
            Report.Columns.Add("Gross");
            Report.Columns.Add("Days Month");
            Report.Columns.Add("Attendance Days");
            Report.Columns.Add("CL Holiday And Off");
            Report.Columns.Add("Payable Days");

            Report.Columns.Add("Basic");
            Report.Columns.Add("HRA");
            Report.Columns.Add("Conveyance Allowance");
            Report.Columns.Add("Washing Allowance");
            Report.Columns.Add("Medical Allowance");
            Report.Columns.Add("Gross Earnings");
            Report.Columns.Add("PT");
            Report.Columns.Add("PF");
            Report.Columns.Add("ESI");
            Report.Columns.Add("Salary Advance");
            Report.Columns.Add("Loan");
            Report.Columns.Add("Canteen Deduction");
            Report.Columns.Add("Mobile Deduction");
            Report.Columns.Add("Mediclaim Deduction");
            Report.Columns.Add("Tds Deduction");
            Report.Columns.Add("Other Deductions");
            Report.Columns.Add("Total Deductions");
            Report.Columns.Add("Net Pay");
            Report.Columns.Add("Bank Acc No");
            Report.Columns.Add("Extra Days");
            Report.Columns.Add("Extra Days Value");
            Report.Columns.Add("Total Days Value");
            int branchid = Convert.ToInt32(ddlbranches.SelectedItem.Value);
            string mainbranch = Session["mainbranch"].ToString();
            cmd = new SqlCommand("SELECT company_master.address, company_master.companyname FROM branchmaster INNER JOIN company_master ON branchmaster.company_code = company_master.sno WHERE (branchmaster.branchid = @BranchID)");
            cmd.Parameters.Add("@BranchID", ddlbranches.SelectedValue);
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
            cmd = new SqlCommand("SELECT designationid, designation, status, createdby, createdon, editedby, editedon, reason FROM designation");
            DataTable dtdesignation = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT   deptid, department, status, reason, createdby, createdon, editedby, editedon FROM    departments");
            DataTable dtdept = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT sno, employecode, empname, designation, daysmonth, attandancedays, clandholidayoff, payabledays, salary, basic, hra, conveyance, medical, washing, gross, pt, pf, esi, salaryadvance, loan, canteendeduction, mobilededuction, mediclim, otherdeduction, totaldeduction, netpay, bankaccountno, ifsccode, emptype, branchid, month, dateofclosing, closedby, year, deptid, tdsdeduction, betaperday, attendancebonus, type, empid, extrapay, extradays  FROM  monthlysalarystatement WHERE year=@year and month=@month and branchid=@branchid AND (deptid IS NOT NULL) ORDER BY deptid");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@month", mymonth);
            cmd.Parameters.Add("@year", year);
            DataTable dtmonthsalary = vdm.SelectQuery(cmd).Tables[0];
            double grndnetpaytot = 0;
            double grndextrapaytot = 0;
            double totalpay = 0;
            string prevdepartment = "";
            double grstot = 0;
            double grndgrosstotal = 0;
            double basictotal = 0;
            double grndbasictotal = 0;
            double netpaystot = 0;
            double pttotal = 0;
            double grndpttotal = 0;
            double totalpf = 0;
            double grndtotalpf = 0;
            double totalexdays = 0;
            double totextradaysval = 0;
            double grndtotalexdays = 0;
            double grndtotdaysval = 0;
            double totalgrosseasrn = 0;
            double grndtotalgrosseasrn = 0;
            if (dtmonthsalary.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtmonthsalary.Rows)
                {
                    string designation = "";
                    string department = "";
                    string DESI = dr["designation"].ToString();
                    double deptid = Convert.ToDouble(dr["deptid"].ToString());
                    double num;
                    if (double.TryParse(DESI, out num))
                    {
                        foreach (DataRow dremployee in dtdesignation.Select("designationid='" + DESI + "'"))
                        {
                            designation = dremployee["designation"].ToString();
                        }
                    }
                    foreach (DataRow dremployee in dtdept.Select("deptid='" + deptid + "'"))
                    {
                        department = dremployee["department"].ToString();
                    }
                    DataRow newrow = Report.NewRow();
                    if (department == prevdepartment)
                    {
                        newrow["Sno"] = i++.ToString();
                        newrow["Employee Code"] = dr["employecode"].ToString();
                        newrow["Name"] = dr["empname"].ToString();
                        newrow["Department"] = department;
                        if (designation == "")
                        {
                            newrow["Designation"] = DESI;
                        }
                        else
                        {
                            newrow["Designation"] = designation;
                        }
                        newrow["Gross"] = dr["salary"].ToString();
                        double gross = Convert.ToDouble(dr["salary"].ToString());
                        grstot += gross;
                        grndgrosstotal += gross;
                        newrow["Days Month"] = dr["daysmonth"].ToString();
                        newrow["Attendance Days"] = dr["attandancedays"].ToString();
                        newrow["CL Holiday And Off"] = dr["clandholidayoff"].ToString();
                        newrow["Payable Days"] = dr["payabledays"].ToString();

                        newrow["Basic"] = dr["basic"].ToString();
                        double basictot = Convert.ToDouble(dr["basic"].ToString());
                        basictotal += basictot;
                        grndbasictotal += basictot;
                        newrow["HRA"] = dr["hra"].ToString();
                        newrow["Conveyance Allowance"] = dr["conveyance"].ToString();

                        newrow["Washing Allowance"] = dr["washing"].ToString();
                        newrow["Medical Allowance"] = dr["medical"].ToString();
                        newrow["Gross Earnings"] = dr["gross"].ToString();
                        double totgrossearn = Convert.ToDouble(dr["gross"].ToString());
                        totalgrosseasrn += totgrossearn;
                        grndtotalgrosseasrn += totgrossearn;

                        newrow["PT"] = dr["pt"].ToString();
                        double pttot = Convert.ToDouble(dr["pt"].ToString());
                        pttotal += pttot;
                        grndpttotal += pttot;
                        newrow["PF"] = dr["pf"].ToString();
                        double totpf = Convert.ToDouble(dr["pf"].ToString());
                        totalpf += totpf;
                        grndtotalpf += totpf;
                        newrow["ESI"] = dr["esi"].ToString();
                        newrow["Salary Advance"] = dr["salaryadvance"].ToString();
                        newrow["Loan"] = dr["loan"].ToString();
                        newrow["Canteen Deduction"] = dr["canteendeduction"].ToString();
                        newrow["Mobile Deduction"] = dr["mobilededuction"].ToString();
                        newrow["Mediclaim Deduction"] = dr["mediclim"].ToString();
                        newrow["Tds Deduction"] = dr["tdsdeduction"].ToString();
                        newrow["Other Deductions"] = dr["otherdeduction"].ToString();
                        newrow["Total Deductions"] = dr["totaldeduction"].ToString();
                        newrow["Net Pay"] = dr["netpay"].ToString();
                        double netpay = Convert.ToDouble(dr["netpay"].ToString());
                        netpaystot += netpay;
                        grndnetpaytot += netpay;
                        newrow["Bank Acc No"] = dr["bankaccountno"].ToString();
                        newrow["Extra Days"] = dr["extradays"].ToString();
                        string extdays = dr["extradays"].ToString();
                        double totexdays = 0;
                        if (extdays != "")
                        {
                            totexdays = Convert.ToDouble(extdays);
                        }
                        totalexdays += totexdays;
                        grndtotalexdays += totexdays;
                        newrow["Extra Days Value"] = dr["extrapay"].ToString();
                        double extradaysval = 0;
                        if (dr["extrapay"].ToString() != "")
                        {
                            extradaysval = Convert.ToDouble(dr["extrapay"].ToString());
                        }
                        totextradaysval += extradaysval;
                        grndextrapaytot += extradaysval;
                        newrow["Total Days Value"] = netpay + extradaysval;
                        totalpay += netpay + extradaysval;
                        grndtotdaysval += netpay + extradaysval;
                        Report.Rows.Add(newrow);
                    }
                    else
                    {
                        if (grstot > 0)
                        {
                            DataRow newvartical2 = Report.NewRow();
                            newvartical2["Name"] = "Total";
                            newvartical2["Gross"] = grstot;
                            grstot = 0;

                            if (basictotal > 0)
                            {
                                newvartical2["Basic"] = basictotal;
                                basictotal = 0;
                            }
                            if (totalgrosseasrn > 0)
                            {
                                newvartical2["Gross Earnings"] = totalgrosseasrn;
                                totalgrosseasrn = 0;
                            }
                            if (pttotal > 0)
                            {
                                newvartical2["pt"] = pttotal;
                                pttotal = 0;

                            }
                            if (totalpf > 0)
                            {
                                newvartical2["pf"] = totalpf;
                                totalpf = 0;
                            }
                            if (netpaystot > 0)
                            {
                                newvartical2["Net Pay"] = netpaystot;
                                netpaystot = 0;
                            }

                            if (totalexdays > 0)
                            {
                                newvartical2["Extra Days"] = totalexdays;
                                totalexdays = 0;
                            }
                            if (totextradaysval > 0)
                            {
                                newvartical2["Extra Days Value"] = totextradaysval;
                                totextradaysval = 0;
                            }
                            if (totalpay > 0)
                            {
                                newvartical2["Total Days Value"] = totalpay;
                                totalpay = 0;
                            }
                            Report.Rows.Add(newvartical2);
                        }

                        prevdepartment = department;
                        newrow["Department"] = department;
                        newrow["Sno"] = i++.ToString();
                        newrow["Employee Code"] = dr["employecode"].ToString();
                        newrow["Name"] = dr["empname"].ToString();
                        if (designation == "")
                        {
                            newrow["Designation"] = DESI;
                        }
                        else
                        {
                            newrow["Designation"] = designation;
                        }
                        newrow["Gross"] = dr["salary"].ToString();
                        double gross = Convert.ToDouble(dr["salary"].ToString());
                        grstot += gross;
                        grndgrosstotal += gross;
                        newrow["Days Month"] = dr["daysmonth"].ToString();
                        newrow["Attendance Days"] = dr["attandancedays"].ToString();
                        newrow["CL Holiday And Off"] = dr["clandholidayoff"].ToString();
                        newrow["Payable Days"] = dr["payabledays"].ToString();

                        newrow["Basic"] = dr["basic"].ToString();
                        double basictot = Convert.ToDouble(dr["basic"].ToString());
                        basictotal += basictot;
                        grndbasictotal += basictot;
                        newrow["HRA"] = dr["hra"].ToString();
                        newrow["Conveyance Allowance"] = dr["conveyance"].ToString();

                        newrow["Washing Allowance"] = dr["washing"].ToString();
                        newrow["Medical Allowance"] = dr["medical"].ToString();
                        newrow["Gross Earnings"] = dr["gross"].ToString();
                        double totgrossearn = Convert.ToDouble(dr["gross"].ToString());
                        totalgrosseasrn += totgrossearn;
                        grndtotalgrosseasrn += totgrossearn;

                        newrow["PT"] = dr["pt"].ToString();
                        double pttot = Convert.ToDouble(dr["pt"].ToString());
                        pttotal += pttot;
                        grndpttotal += pttot;
                        newrow["PF"] = dr["pf"].ToString();
                        double totpf = Convert.ToDouble(dr["pf"].ToString());
                        totalpf += totpf;
                        grndtotalpf += totpf;
                        newrow["ESI"] = dr["esi"].ToString();
                        newrow["Salary Advance"] = dr["salaryadvance"].ToString();
                        newrow["Loan"] = dr["loan"].ToString();
                        newrow["Canteen Deduction"] = dr["canteendeduction"].ToString();
                        newrow["Mobile Deduction"] = dr["mobilededuction"].ToString();
                        newrow["Mediclaim Deduction"] = dr["mediclim"].ToString();
                        newrow["Tds Deduction"] = dr["tdsdeduction"].ToString();
                        newrow["Other Deductions"] = dr["otherdeduction"].ToString();
                        newrow["Total Deductions"] = dr["totaldeduction"].ToString();
                        newrow["Net Pay"] = dr["netpay"].ToString();
                        double netpay = Convert.ToDouble(dr["netpay"].ToString());
                        netpaystot += netpay;
                        grndnetpaytot += netpay;
                        newrow["Bank Acc No"] = dr["bankaccountno"].ToString();
                        newrow["Extra Days"] = dr["extradays"].ToString();
                        string extdays = dr["extradays"].ToString();
                        double totexdays = 0;
                        if (extdays != "")
                        {
                            totexdays = Convert.ToDouble(extdays);
                        }
                        totalexdays += totexdays;
                        grndtotalexdays += totexdays;
                        newrow["Extra Days Value"] = dr["extrapay"].ToString();
                        double extradaysval = 0;
                        if (dr["extrapay"].ToString() != "")
                        {
                            extradaysval = Convert.ToDouble(dr["extrapay"].ToString());
                        }
                        totextradaysval += extradaysval;
                        grndextrapaytot += extradaysval;
                        newrow["Total Days Value"] = netpay + extradaysval;
                        totalpay += netpay + extradaysval;
                        grndtotdaysval += netpay + extradaysval;
                        Report.Rows.Add(newrow);
                    }
                }
                DataRow newTotal = Report.NewRow();
                newTotal["Name"] = "Total";
                newTotal["Gross"] = grstot;
                newTotal["Basic"] = basictotal;
                newTotal["Net Pay"] = netpaystot;
                newTotal["Total Days Value"] = totalpay;
                newTotal["PT"] = pttotal;
                newTotal["PF"] = totalpf;
                newTotal["Extra Days"] = totalexdays;
                newTotal["Extra Days Value"] = totextradaysval;
                newTotal["Gross Earnings"] = totalgrosseasrn;
                Report.Rows.Add(newTotal);

                DataRow newgrndTotal = Report.NewRow();
                newgrndTotal["Name"] = "Grand Total";
                newgrndTotal["Gross"] = grndgrosstotal;
                newgrndTotal["Basic"] = grndbasictotal;
                newgrndTotal["PT"] = grndpttotal;
                newgrndTotal["PF"] = grndtotalpf;
                newgrndTotal["Department"] = "";
                newgrndTotal["Net Pay"] = grndnetpaytot;
                newgrndTotal["Extra Days"] = grndtotalexdays;
                newgrndTotal["Extra Days Value"] = grndextrapaytot;
                newgrndTotal["Total Days Value"] = grndtotdaysval;
                newgrndTotal["Gross Earnings"] = grndtotalgrosseasrn;
                Report.Rows.Add(newgrndTotal);

                grdReports.DataSource = Report;
                grdReports.DataBind();
                Session["xportdata"] = Report;
                hidepanel.Visible = true;
            }
            else
            {
                lblmsg.Text = "No Data Found";
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
            if (e.Row.Cells.Count > 2)
            {
                if (e.Row.Cells[3].Text == "Total")
                {
                    e.Row.BackColor = System.Drawing.Color.CadetBlue;
                    e.Row.Font.Size = FontUnit.Large;
                    e.Row.Font.Bold = true;

                }
                if (e.Row.Cells[3].Text == "Grand Total")
                {
                    e.Row.BackColor = System.Drawing.Color.Aquamarine;
                    e.Row.Font.Size = FontUnit.Large;
                    e.Row.Font.Bold = true;
                }
            }
        }
    }
    protected void grdReports_DataBinding(object sender, EventArgs e)
    {
        try
        {
            //string s = grdReports.Columns[0].HeaderText;
            GridViewGroup First = new GridViewGroup(grdReports, null, "Department");
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}