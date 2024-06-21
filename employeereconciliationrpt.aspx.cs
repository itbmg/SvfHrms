using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class employeereconciliationrpt : System.Web.UI.Page
{
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
        ddlmonth.Items.Clear();
        ListItem lt = new ListItem();
        lt.Text = "Select Period";
        lt.Value = "0";
        ddlmonth.Items.Add(lt);
        for (int i = 1; i <= 12; i++)
        {
            lt = new ListItem();
            lt.Text = Convert.ToDateTime(i.ToString() + "/1/2016").ToString("MMM-yyyy");
            lt.Value = i.ToString();
            ddlmonth.Items.Add(lt);
        }
        ddlmonth.Items.FindByValue(DateTime.Now.Month.ToString()).Selected = true;
    }

    DataTable Report = new DataTable();

    protected void btn_genarate_click(object sender, EventArgs e)
    {
        try
        {

            DBManager SalesDB = new DBManager();
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            string year = (mydate.Year).ToString();
            string mymonth = ddlmonth.SelectedItem.Value;
            string day = (mydate.Day).ToString();
            string d = "00";
            string date = mymonth + "/" + day + "/" + year;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            fromdate = Convert.ToDateTime(date);
            int cmonth = Convert.ToInt32(mymonth);
            int lmonth = cmonth - 1;
            int pmonth = lmonth - 1;
           
            Report.Columns.Add("SNO");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Employee Name");
            cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, CONVERT(VARCHAR(20), employedetails.joindate, 103) AS joindate, employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, monthly_attendance.month, monthly_attendance.year FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE  (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
           // cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@month", lmonth);
            cmd.Parameters.Add("@year", str[2]);
            DataTable dtcurrentmonth = vdm.SelectQuery(cmd).Tables[0];

            cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, monthly_attendance.month, monthly_attendance.year FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
            //cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@month", pmonth);
            cmd.Parameters.Add("@year", str[2]);

            DataTable priviasmonth = vdm.SelectQuery(cmd).Tables[0];
            int currentcount = dtcurrentmonth.Rows.Count;
            int priviascount = priviasmonth.Rows.Count;
            lblmay.Text = priviascount.ToString();
            Label1.Text = currentcount.ToString();
            if (dtcurrentmonth.Rows.Count > 0)
            {
                int i = 1;
                int j = 1;
                int count = 0;
                int lastcount = 0;
                foreach (DataRow dr in dtcurrentmonth.Rows)
                {
                    string jod = dr["joindate"].ToString();
                    if (jod != "")
                    {
                        DateTime dtjoindate = Convert.ToDateTime(jod);
                        string joindate = dtjoindate.ToString("MM-yyyy");

                        DateTime dtcurrntdate = ServerDateCurrentdate.AddMonths(-1);
                        string sdate = dtcurrntdate.ToString("MM-yyyy");

                        DateTime dtlastmonth = ServerDateCurrentdate.AddMonths(-2);
                        string lastmonth = dtlastmonth.ToString("MM-yyyy");
                        string empcode = dr["employee_num"].ToString();
                        string fullname = dr["fullname"].ToString();
                        if (joindate == sdate)
                        {
                            DataRow newrow = Report.NewRow();
                            newrow["SNO"] = i++;
                            newrow["Employee Code"] = empcode;
                            newrow["Employee Name"] = fullname;
                            count = i++;
                            Label2.Text = count.ToString();
                            Report.Rows.Add(newrow);
                        }
                        if (joindate == lastmonth)
                        {
                            DataRow newrow = Report.NewRow();
                            newrow["SNO"] = i++;
                            newrow["Employee Code"] = empcode;
                            newrow["Employee Name"] = fullname;
                            lastcount = i++;
                            Label3.Text = count.ToString();
                            Report.Rows.Add(newrow);
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            

        }
    }
}