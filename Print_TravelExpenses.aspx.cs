using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class Print_TravelExpenses : System.Web.UI.Page
{
    SqlCommand cmd;
    string userid = "";
    DBManager vdm;
   
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["TitleName"] == null)
        {
            Response.Redirect("Login.aspx");
        }
        if (!this.IsPostBack)
        {
            if (!Page.IsCallback)
            {
                lblTitle.Text = Session["TitleName"].ToString();
                if (Session["ReceiptNo"] == null)
                {
                }
                else
                {
                    txtVoucherNo.Text = Session["ReceiptNo"].ToString();
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
    void getdet()
    {
        try
        {
            vdm = new DBManager();
            cmd = new SqlCommand("SELECT sub_travelexpenses.amount, travel_expenses.reportingname, travel_expenses.sno, travel_expenses.fromdate, travel_expenses.todate,travel_expenses.approvedby, travel_expenses.instructionby, travel_expenses.purpose, travel_expenses.tolocation, travel_expenses.fromlocation,travel_expenses.doe, travel_expenses.empid, travel_expenses.empcode, travel_expenses.totalamount, travel_expenses.branchid, travel_expenses.status, travel_expenses.entryby, sub_travelexpenses.ledger_id, employedetails.fullname, employedetails_1.fullname AS approvename FROM travel_expenses INNER JOIN sub_travelexpenses ON travel_expenses.sno = sub_travelexpenses.refno INNER JOIN employedetails ON travel_expenses.empid = employedetails.empid INNER JOIN employedetails AS employedetails_1 ON travel_expenses.approvedby = employedetails_1.empid WHERE (sub_travelexpenses.refno = @refno)");
            cmd.Parameters.Add("@refno", txtVoucherNo.Text);
            DataTable dtCash = vdm.SelectQuery(cmd).Tables[0];
            string voucherid = "";
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            DateTime dtapril = new DateTime();
            DateTime dtmarch = new DateTime();
            int currentyear = ServerDateCurrentdate.Year;
            int nextyear = ServerDateCurrentdate.Year + 1;
            int currntyearnum = 0;
            int nextyearnum = 0;
            if (ServerDateCurrentdate.Month > 3)
            {
                string apr = "4/1/" + currentyear;
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + nextyear;
                dtmarch = DateTime.Parse(march);
                currntyearnum = currentyear;
                nextyearnum = nextyear;
            }
            if (ServerDateCurrentdate.Month <= 3)
            {
                string apr = "4/1/" + (currentyear - 1);
                dtapril = DateTime.Parse(apr);
                string march = "3/31/" + (nextyear - 1);
                dtmarch = DateTime.Parse(march);
                currntyearnum = currentyear - 1;
                nextyearnum = nextyear - 1;
            }
            if (dtCash.Rows.Count > 0)
            {
                //lblVoucherno.Text = txtVoucherNo.Text;
                voucherid = "SVDS/VOC/" + dtapril.ToString("yy") + "-" + dtmarch.ToString("yy") + "/" + dtCash.Rows[0]["sno"].ToString();
                lblVoucherno.Text = voucherid;
                string DOE = dtCash.Rows[0]["doe"].ToString();
                DateTime dtDOE = Convert.ToDateTime(DOE);
                //lblApprove.Text = dtCash.Rows[0]["EmpName"].ToString();
                string ChangedTime = dtDOE.ToString("dd/MMM/yyyy");
                lblDate.Text = ChangedTime;
                lblPayCash.Text = dtCash.Rows[0]["reportingname"].ToString();
                lblfromlocation.Text = dtCash.Rows[0]["fromlocation"].ToString();
                lbltolocation.Text = dtCash.Rows[0]["tolocation"].ToString();
                string frmdate = dtCash.Rows[0]["fromdate"].ToString();
                DateTime dtfrm = Convert.ToDateTime(frmdate);
                string fromTime = dtfrm.ToString("dd/MMM/yyyy");
                lblfromdate.Text = fromTime;
                lblInstuby.Text = dtCash.Rows[0]["instructionby"].ToString();
                lbl_employee.Text = dtCash.Rows[0]["fullname"].ToString();
                string todate = dtCash.Rows[0]["todate"].ToString();
                DateTime dtto = Convert.ToDateTime(todate);
                string ToTime = dtto.ToString("dd/MMM/yyyy");
                lblTodate.Text = ToTime;
                //lblTodate.Text = dtCash.Rows[0]["todate"].ToString();
                lblAproveby.Text = dtCash.Rows[0]["approvename"].ToString();
                lblTowards.Text = dtCash.Rows[0]["purpose"].ToString();
                string Amont = dtCash.Rows[0]["totalamount"].ToString();
                string[] Ones = { "", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Ninteen" };

                string[] Tens = { "Ten", "Twenty", "Thirty", "Fourty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninty" };

                int Num = int.Parse(Amont);

                lblReceived.Text = NumToWordBD(Num) + " Rupees Only";
            }

        }
        catch (Exception ex)
        {
            lblReceived.Text = ex.Message;
        }
    }
    public static string NumToWordBD(Int64 Num)
    {
        string[] Below20 = { "", "One ", "Two ", "Three ", "Four ", 
      "Five ", "Six " , "Seven ", "Eight ", "Nine ", "Ten ", "Eleven ", 
    "Twelve " , "Thirteen ", "Fourteen ","Fifteen ", 
      "Sixteen " , "Seventeen ","Eighteen " , "Nineteen " };
        string[] Below100 = { "", "", "Twenty ", "Thirty ", 
      "Forty ", "Fifty ", "Sixty ", "Seventy ", "Eighty ", "Ninety " };
        string InWords = "";
        if (Num >= 1 && Num < 20)
            InWords += Below20[Num];
        if (Num >= 20 && Num <= 99)
            InWords += Below100[Num / 10] + Below20[Num % 10];
        if (Num >= 100 && Num <= 999)
            InWords += NumToWordBD(Num / 100) + " Hundred " + NumToWordBD(Num % 100);
        if (Num >= 1000 && Num <= 99999)
            InWords += NumToWordBD(Num / 1000) + " Thousand " + NumToWordBD(Num % 1000);
        if (Num >= 100000 && Num <= 9999999)
            InWords += NumToWordBD(Num / 100000) + " Lakh " + NumToWordBD(Num % 100000);
        if (Num >= 10000000)
            InWords += NumToWordBD(Num / 10000000) + " Crore " + NumToWordBD(Num % 10000000);
        return InWords;
    }
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        getdet();
        ScriptManager.RegisterStartupScript(Page, GetType(), "JsStatus", "PopupOpen(" + txtVoucherNo.Text + ");", true);

    }
}