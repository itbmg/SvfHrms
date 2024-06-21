using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Data.SqlClient;
using System.IO;
using System.Drawing;
using System.Text;
using System.Data.Odbc;
using System.Data.OleDb;
using System.Threading;


public partial class bankfileformat : System.Web.UI.Page
{
    public string ccode;
    public string pcode;
    public string managmobNo;
    public string pname;
    public string cname;

    public int rid;
    public int flag = 0;
    public int flag1 = 0;
    SqlDataReader dr;
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DateTime dtm = new DateTime();
    SqlConnection con = new SqlConnection();
    public static int roleid;
    DataTable dttt = new DataTable();
    DataTable dtttq = new DataTable();

    double getamt = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["userid"] == null)
                Response.Redirect("Login.aspx");
            else
            {
               string userid = Session["userid"].ToString();
               DBManager vdm = new DBManager();
               // rid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                btn_Check.Visible = false;
                bindbranchs();
                LoadBankId();
                PopulateYear();
                bindemployeetype();
                if (chk_OldFileName.Checked == true)
                {
                    ddl_oldfilename.Visible = false;
                    txt_FileName.Visible = true;
                    txt_FileName.Text = "ddl";
                    // Loadoldfilename();
                }
                else
                {
                    ddl_oldfilename.Visible = false;
                    txt_FileName.Visible = true;
                    txt_FileName.Text = " ";
                }
                // AllRoute();
                lbl_ErrorMsg.Visible = false;
                Chk_Cash.Visible = false;
                ddl_BankName.Visible = false;
                lbl_RouteName.Visible = true;
                //ddl_RouteName.Visible = true;
                //chk_Allroute.Visible = true;
            }

        }
    }

    private void bindbranchs()
    {

        DBManager SalesDB = new DBManager();
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        SqlCommand  cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
        cmd.Parameters.Add("@m", mainbranch);
        DataTable dttrips = SalesDB.SelectQuery(cmd).Tables[0];
        ddlbranch.DataSource = dttrips;
        ddlbranch.DataTextField = "branchname";
        ddlbranch.DataValueField = "branchid";
        ddlbranch.DataBind();
        ddlbranch.ClearSelection();
        ddlbranch.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        ddlbranch.SelectedValue = "0";
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
    private void bindemployeetype()
    {
        DBManager SalesDB = new DBManager();
        SqlCommand cmd = new SqlCommand("SELECT employee_type FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch where (employee_type<>'') AND (branchmapping.mainbranch = @bid) GROUP BY employee_type");
        cmd.Parameters.Add("@bid", Session["mainbranch"].ToString());
        DataTable dttrips = SalesDB.SelectQuery(cmd).Tables[0];
        ddlemptype.DataSource = dttrips;
        ddlemptype.DataTextField = "employee_type";
        ddlemptype.DataValueField = "employee_type";
        ddlemptype.DataBind();
        ddlemptype.ClearSelection();
        ddlemptype.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Type--", Selected = true });
        ddlemptype.SelectedValue = "0";
    }
    private void LoadBankId()
    {
        try
        {
            ddl_BankName.Items.Clear();
            ddchkCountry.Items.Clear();
            DBManager SalesDB = new DBManager();
            string mainbranch = Session["mainbranch"].ToString();
            //branch mapping
            SqlCommand cmd = new SqlCommand("SELECT bankmaster.bankname, bankmaster.code, bankmaster.sno FROM bankmaster INNER JOIN employebankdetails ON bankmaster.sno = employebankdetails.bankid GROUP BY bankmaster.bankname, bankmaster.sno, bankmaster.code ORDER BY bankmaster.sno");
            cmd.Parameters.Add("@m", mainbranch);
            DataTable dtBANKS = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtBANKS.Rows.Count > 0)
            {
                ddl_BankName.DataSource = dtBANKS;
                ddl_BankName.DataTextField = "bankname";
                ddl_BankName.DataValueField = "sno";
                ddl_BankName.DataBind();
                ddl_BankName.ClearSelection();

                ddchkCountry.DataSource = dtBANKS;
                ddchkCountry.DataTextField = "bankname";
                ddchkCountry.DataValueField = "sno";
                ddchkCountry.DataBind();
                
            }
            if (ddl_BankName.Items.Count > 0)
            {
                ddl_BankName.SelectedIndex = 0;
            }
        }
        catch (Exception em)
        {

        }
    }

    private void GetPlantAllottedAmount()
    {
        //try
        //{
        //    pcode = ddl_Plantcode.SelectedItem.Value;
        //    SqlDataReader dr = null;
        //    dr = Bllusers.GetPlantAllottedAmount(ccode, pcode);
        //    if (dr.HasRows)
        //    {
        //        while (dr.Read())
        //        {
        //            txt_Allotamount.Text = dr["TotAmount"].ToString();
        //        }
        //    }

        //}
        //catch (Exception ex)
        //{
        //    WebMsgBox.Show(ex.ToString());
        //}
    }

    protected void btn_load_Click(object sender, EventArgs e)
    {
        //rid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
        BindBankPaymentData();
        //txt_balance.Text = "";
        //rid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
        //BindBank();
        //txt_balance.Text = "";
    }

    private void LoadPlantcode()
    {
        
    }


    private void loadrouteid()
    {
      
    }

    private void Bdate()
    {
      
    }

    

    protected void ddl_Plantname_SelectedIndexChanged(object sender, EventArgs e)
    {
       
        BindBank();
        Loadoldfilename();
        GETTOTBILLAMOUNT();
        GETbankassignamount();

    }
    protected void ddl_RouteName_SelectedIndexChanged(object sender, EventArgs e)
    {
       
    }


    private void BindBankPaymentData()
    {
        try
        {
            SqlCommand cmd = new SqlCommand();
            DataTable custDT = DisplayselectedBankid();
            DBManager SalesDB = new DBManager();
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            string month = ddlmonth.SelectedItem.Value;
            string year = ddlyear.SelectedItem.Value;
            string employetype = ddlemptype.SelectedItem.Value;
            string branch = ddlbranch.SelectedItem.Value;
            int count = custDT.Rows.Count;
            if (count > 36)
            {
                cmd = new SqlCommand("SELECT bankid, empid, branchid, designation, ifsccode, branchname, fullname, employee_num, netpay, bankaccountno, Expr1, emptype, gross, basic, salary, deptid, cellphone,extrapay FROM            (SELECT        TOP (100) PERCENT employebankdetails.bankid, employedetails.empid, monthlysalarystatement.branchid, monthlysalarystatement.designation, employebankdetails.ifsccode,  branchmaster.branchname, employedetails.fullname, employedetails.employee_num, monthlysalarystatement.netpay, monthlysalarystatement.bankaccountno,    monthlysalarystatement.ifsccode AS Expr1, monthlysalarystatement.emptype, monthlysalarystatement.gross, monthlysalarystatement.basic, monthlysalarystatement.salary,  monthlysalarystatement.deptid, employedetails.cellphone, monthlysalarystatement.extrapay FROM   bankmaster INNER JOIN employebankdetails ON bankmaster.sno = employebankdetails.bankid INNER JOIN monthlysalarystatement ON employebankdetails.accountno = monthlysalarystatement.bankaccountno INNER JOIN branchmaster ON monthlysalarystatement.branchid = branchmaster.branchid INNER JOIN employedetails ON monthlysalarystatement.empid = employedetails.empid WHERE (monthlysalarystatement.branchid = @branchid) AND (monthlysalarystatement.month = @month) AND (monthlysalarystatement.year = @year) AND (monthlysalarystatement.emptype=@emptype) AND (employedetails.status = 'NO') AND (monthlysalarystatement.bankaccountno <> '') GROUP BY bankmaster.sno, monthlysalarystatement.branchid, branchmaster.branchname, employedetails.fullname, employedetails.employee_num, monthlysalarystatement.netpay, employedetails.empid,  employebankdetails.bankid, employebankdetails.ifsccode, monthlysalarystatement.bankaccountno, monthlysalarystatement.ifsccode, monthlysalarystatement.emptype,  monthlysalarystatement.gross,  monthlysalarystatement.basic, monthlysalarystatement.salary, monthlysalarystatement.deptid, monthlysalarystatement.designation, employedetails.cellphone, monthlysalarystatement.extrapay ORDER BY employedetails.empid) AS A WHERE  (NOT EXISTS (SELECT        B.sno, B.Companyid, B.branchid, B.empid, B.employecode, B.empname, B.designation, B.netpay, B.bankaccountno, B.ifsccode, B.emptype, B.bankid, B.deptid, B.refno FROM  subbankformatmaster AS B INNER JOIN bankformatmaster ON B.refno = bankformatmaster.sno WHERE (A.empid = B.empid) AND (bankformatmaster.month = @month) AND (bankformatmaster.year = @year)))");
                cmd.Parameters.Add("@branchid", branch);
                cmd.Parameters.Add("@month", month);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@emptype", employetype);
                DataTable Branchdata = SalesDB.SelectQuery(cmd).Tables[0];

                //
                cmd = new SqlCommand("SELECT sno, empid, deptid, amount, remarks, doe, monthofpaid, employee_num, month, year, status, entry_by, modify_by  FROM   salessalaryadvance  WHERE   (month = @MNTH) AND (year = @YEAR)");
                cmd.Parameters.Add("@MNTH", month);
                cmd.Parameters.Add("@YEAR", year);
                DataTable dtsaladvance = SalesDB.SelectQuery(cmd).Tables[0];

                if (Branchdata.Rows.Count > 0)
                {
                    DataTable Report = new DataTable();
                    Report.Columns.Add("bankid");
                    Report.Columns.Add("empid");
                    Report.Columns.Add("fullname");
                    Report.Columns.Add("netpay");
                    foreach (DataRow dr in custDT.Rows)
                    {
                        string bankid = dr["Bankid"].ToString();
                        foreach (DataRow dra in Branchdata.Select("bankid='" + bankid + "'"))
                        {
                            double netpay = 0;
                            double.TryParse(dra["netpay"].ToString(), out netpay);
                            double extrapay = 0;
                            double.TryParse(dra["extrapay"].ToString(), out extrapay);
                            double totamt = netpay + extrapay;
                            string bnkid = dra["bankid"].ToString();
                            string empid = dra["empid"].ToString();
                            double saladvance = 0;
                            foreach (DataRow drs in dtsaladvance.Select("empid='" + empid + "'"))
                            {
                                string saladv = drs["amount"].ToString();
                                double totsaladv = Convert.ToDouble(saladv);
                                saladvance += totsaladv;
                            }

                            double totalamount = totamt - saladvance;

                            string fullname = dra["fullname"].ToString();
                            DataRow newrow = Report.NewRow();
                            newrow["bankid"] = bnkid;
                            newrow["empid"] = empid;
                            newrow["fullname"] = fullname;
                            newrow["netpay"] = totalamount.ToString();
                            Report.Rows.Add(newrow);
                        }
                    }
                    CheckBoxList1.DataSource = Report;
                    CheckBoxList1.DataTextField = "fullname";
                    CheckBoxList1.DataValueField = "empid";
                    CheckBoxList1.DataBind();

                    CheckBoxList2.DataSource = Report;
                    CheckBoxList2.DataTextField = "netpay";
                    CheckBoxList2.DataValueField = "netpay";
                    CheckBoxList2.DataBind();
                }
                else
                {
                    CheckBoxList1.DataSource = Branchdata;
                    CheckBoxList1.DataTextField = "fullname";
                    CheckBoxList1.DataValueField = "empid";
                    CheckBoxList1.DataBind();

                    CheckBoxList2.DataSource = Branchdata;
                    CheckBoxList2.DataTextField = "netpay";
                    CheckBoxList2.DataValueField = "netpay";
                    CheckBoxList2.DataBind();
                }
            }
            else
            {
                DataTable Report = new DataTable();
                Report.Columns.Add("bankid");
                Report.Columns.Add("empid");
                Report.Columns.Add("fullname");
                Report.Columns.Add("netpay");
                if (custDT.Rows.Count > 0)
                {
                    cmd = new SqlCommand("SELECT bankid, empid, branchid, designation, ifsccode, branchname, fullname, employee_num, netpay, bankaccountno, Expr1, emptype, gross, basic, salary, deptid, cellphone,extrapay FROM (SELECT TOP (100) PERCENT employebankdetails.bankid, employedetails.empid, monthlysalarystatement.branchid, monthlysalarystatement.designation, employebankdetails.ifsccode,  branchmaster.branchname, employedetails.fullname, employedetails.employee_num, monthlysalarystatement.netpay, monthlysalarystatement.bankaccountno,    monthlysalarystatement.ifsccode AS Expr1, monthlysalarystatement.emptype, monthlysalarystatement.gross, monthlysalarystatement.basic, monthlysalarystatement.salary,  monthlysalarystatement.deptid, employedetails.cellphone, monthlysalarystatement.extrapay FROM   bankmaster INNER JOIN employebankdetails ON bankmaster.sno = employebankdetails.bankid INNER JOIN monthlysalarystatement ON employebankdetails.accountno = monthlysalarystatement.bankaccountno INNER JOIN branchmaster ON monthlysalarystatement.branchid = branchmaster.branchid INNER JOIN employedetails ON monthlysalarystatement.empid = employedetails.empid WHERE (monthlysalarystatement.branchid = @branchid) AND (monthlysalarystatement.month = @month) AND (monthlysalarystatement.year = @year) AND (monthlysalarystatement.emptype=@emptype) AND  (employedetails.status = 'NO')  AND (monthlysalarystatement.bankaccountno <> '') GROUP BY bankmaster.sno, monthlysalarystatement.branchid, branchmaster.branchname, employedetails.fullname, employedetails.employee_num, monthlysalarystatement.netpay, employedetails.empid,  employebankdetails.bankid, employebankdetails.ifsccode, monthlysalarystatement.bankaccountno, monthlysalarystatement.ifsccode, monthlysalarystatement.emptype,  monthlysalarystatement.gross,  monthlysalarystatement.basic, monthlysalarystatement.salary, monthlysalarystatement.deptid, monthlysalarystatement.designation, employedetails.cellphone, monthlysalarystatement.extrapay ORDER BY employedetails.empid) AS A WHERE  (NOT EXISTS (SELECT        B.sno, B.Companyid, B.branchid, B.empid, B.employecode, B.empname, B.designation, B.netpay, B.bankaccountno, B.ifsccode, B.emptype, B.bankid, B.deptid, B.refno FROM  subbankformatmaster AS B INNER JOIN bankformatmaster ON B.refno = bankformatmaster.sno WHERE (A.empid = B.empid) AND (bankformatmaster.month = @month) AND (bankformatmaster.year = @year)))");
                    cmd.Parameters.Add("@branchid", branch);
                    cmd.Parameters.Add("@month", month);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@emptype", employetype);
                    DataTable saldata = SalesDB.SelectQuery(cmd).Tables[0];
                    if (saldata.Rows.Count > 0)
                    {
                        foreach (DataRow dr in custDT.Rows)
                        {
                            string bankid = dr["Bankid"].ToString();
                            foreach (DataRow dra in saldata.Select("bankid='" + bankid + "'"))
                            {
                                double netpay = 0;
                                double.TryParse(dra["netpay"].ToString(), out netpay);
                                double extrapay = 0;
                                double.TryParse(dra["extrapay"].ToString(), out extrapay);
                                double totamt = netpay + extrapay;
                                string bnkid = dra["bankid"].ToString();
                                string empid = dra["empid"].ToString();
                                string fullname = dra["fullname"].ToString();
                                DataRow newrow = Report.NewRow();
                                newrow["bankid"] = bnkid;
                                newrow["empid"] = empid;
                                newrow["fullname"] = fullname;
                                newrow["netpay"] = totamt.ToString();
                                Report.Rows.Add(newrow);
                            }
                        }
                        CheckBoxList1.DataSource = Report;
                        CheckBoxList1.DataTextField = "fullname";
                        CheckBoxList1.DataValueField = "empid";
                        CheckBoxList1.DataBind();

                        CheckBoxList2.DataSource = Report;
                        CheckBoxList2.DataTextField = "netpay";
                        CheckBoxList2.DataValueField = "netpay";
                        CheckBoxList2.DataBind();
                    }
                    else
                    {
                        CheckBoxList1.DataSource = Report;
                        CheckBoxList1.DataTextField = "fullname";
                        CheckBoxList1.DataValueField = "empid";
                        CheckBoxList1.DataBind();

                        CheckBoxList2.DataSource = Report;
                        CheckBoxList2.DataTextField = "netpay";
                        CheckBoxList2.DataValueField = "netpay";
                        CheckBoxList2.DataBind();
                    }
                }
            }
            
            //ds = LoadBankPaymentDatas(ccode, pcode, d1, d2, rid.ToString(), ddl_BankName.SelectedItem.Value.Trim());
            //if (ds != null)
            //{
            //    CheckBoxList1.DataSource = ds;
            //    CheckBoxList1.DataTextField = "Agent_Name";
            //    CheckBoxList1.DataValueField = "proAid";
            //    CheckBoxList1.DataBind();

            //    CheckBoxList2.DataSource = ds;
            //    CheckBoxList2.DataTextField = "Netpay";
            //    CheckBoxList2.DataValueField = "Netpay";
            //    CheckBoxList2.DataBind();

            //}
            //else
            //{
            //    //WebMsgBox.Show("Agents Not Available in this Selection...");
            //}
        }
        catch (Exception ex)
        {

        }
    }

    private void CheckData()
    {
        try
        {
            double orgamount = 0.0;
            orgamount = Convert.ToDouble(txt_Allotamount.Text);
            if (orgamount > 0)
            {

                DateTime dt1 = new DateTime();
                DateTime dt2 = new DateTime();
              //  dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
              //  dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);
                double TotalSelectAmount = 0.0;
                double TotalSelectAmount1 = 0.0;
                double TotalSelectAmount2 = 0.0;



                string d1 = dt1.ToString("MM/dd/yyyy");
                string d2 = dt2.ToString("MM/dd/yyyy");
                int count = 0;


                // dt =LoadBankPaymentDatas1(ccode, pcode, d1, d2, rid.ToString(),ddl_BankName.SelectedItem.Value.Trim());
               // dt = LoadBank2(ccode, pcode, d1, d2, rid.ToString(), ddl_BankName.SelectedItem.Value.Trim());
                count = dt.Rows.Count;
                if (count > 0)
                {
                    DataTable custDT = new DataTable();
                    DataColumn col = null;

                    col = new DataColumn("Agent_id");
                    custDT.Columns.Add(col);
                    col = new DataColumn("NetPay");
                    custDT.Columns.Add(col);


                    for (int i = 0; i <= CheckBoxList1.Items.Count - 1; i++)
                    {
                        DataRow dr = null;
                        dr = custDT.NewRow();


                        if (CheckBoxList2.Items[i].Selected == true)
                        {
                            dr[1] = CheckBoxList2.Items[i].Value;
                            TotalSelectAmount1 = Convert.ToDouble(CheckBoxList2.Items[i].Value);
                            TotalSelectAmount = TotalSelectAmount1 + TotalSelectAmount;

                            getamt = getamt + TotalSelectAmount1;
                            if (getamt > 0)
                            {
                               // txt_assignamt1.Text = (getamt).ToString("f2");

                            }
                            else
                            {
                             //   txt_assignamt1.Text = "0";

                            }
                            flag1 = 1;
                        }
                        custDT.Rows.Add(dr);
                    }
                    TotalSelectAmount2 = Convert.ToDouble(txt_Allotamount.Text) - TotalSelectAmount;
                    if (TotalSelectAmount2 >= 0)
                    {
                      //  txt_balance.Text = (Convert.ToDouble(txt_Allotamount.Text) - TotalSelectAmount).ToString();
                        flag = 1;
                        if (flag1 == 1)
                        {
                            flag1 = 0;
                            btn_save.Visible = true;
                        }
                        else
                        {
                            flag1 = 0;
                            btn_save.Visible = false;
                        }
                        // WebMsgBox.Show("Please Select the Agents for Remaining Amounts...");
                    }
                    else
                    {
                        txt_Allotamount.Text = orgamount.ToString();
                        flag = 0;
                        btn_save.Visible = false;
                        // WebMsgBox.Show("Please Select the Agents for Givent Amounts Only...");
                    }

                }
            }
            else
            {
               // WebMsgBox.Show("Please Check the Allotment Amounts...");
            }

        }
        catch (Exception ex)
        {

        }
    }

   

    private void SaveCheckData()
    {
        try
        {
            double TotalSelectAmount = 0.0;
            double TotalSelectAmount1 = 0.0;
            double TotalSelectAmount2 = 0.0;
            DataTable custDT = new DataTable();
            DataColumn col = null;
            col = new DataColumn("Employe_id");
            custDT.Columns.Add(col);
            col = new DataColumn("NetPay");
            custDT.Columns.Add(col);
            for (int i = 0; i <= CheckBoxList1.Items.Count - 1; i++)
            {
                DataRow dr = null;
                dr = custDT.NewRow();
                if (CheckBoxList2.Items[i].Selected == true)
                {
                    dr[0] = CheckBoxList1.Items[i].Value;
                    dr[1] = CheckBoxList2.Items[i].Value;
                    TotalSelectAmount1 = Convert.ToDouble(CheckBoxList2.Items[i].Value);
                    TotalSelectAmount = TotalSelectAmount1 + TotalSelectAmount;
                    flag1 = 1;
                    custDT.Rows.Add(dr);
                }
            }

            string filename = "";
            string branchid = "";

          

        }
        catch (Exception ex)
        {

        }
    }

    protected void MChk_Menu1_CheckedChanged(object sender, EventArgs e)
    {
        Menu1();
    }
    protected void MChk_Menu2_CheckedChanged(object sender, EventArgs e)
    {
        Menu2();
    }
    private void Menu1()
    {
        if (MChk_Menu1.Checked == true)
        {
            for (int i = 0; i <= CheckBoxList1.Items.Count - 1; i++)
            {
                CheckBoxList1.Items[i].Selected = true;
            }
        }
        else
        {
            for (int i = 0; i <= CheckBoxList1.Items.Count - 1; i++)
            {
                CheckBoxList1.Items[i].Selected = false;
            }
        }
    }

    private void Menu2()
    {
        if (MChk_Menu2.Checked == true)
        {
            for (int i = 0; i <= CheckBoxList2.Items.Count - 1; i++)
            {
                CheckBoxList2.Items[i].Selected = true;
            }
        }
        else
        {
            for (int i = 0; i <= CheckBoxList2.Items.Count - 1; i++)
            {
                CheckBoxList2.Items[i].Selected = false;
            }
        }
    }

    protected void btn_Check_Click(object sender, EventArgs e)
    {

        CheckData();
    }

  
    protected void btn_save_Click(object sender, EventArgs e)
    {
        try
        {
            //Check the Same FileName Avail or Not

            DBManager SalesDB = new DBManager();
            string month = ddlmonth.SelectedItem.Value;
            string year = ddlyear.SelectedItem.Value;
            string branchid = ddlbranch.SelectedItem.Value;
            string filename = txt_FileName.Text;
            string userid = Session["userid"].ToString();
            DateTime ServerDateCurrentdate = DBManager.GetTime(SalesDB.conn);
            if (chk_OldFileName.Checked == true)
            {
                filename = ddl_oldfilename.SelectedItem.Value;
            }



            double TotalSelectAmount = 0.0;
            double TotalSelectAmount1 = 0.0;
            double TotalSelectAmount2 = 0.0;
            DataTable custDT = new DataTable();
            DataColumn col = null;
            col = new DataColumn("Employe_id");
            custDT.Columns.Add(col);
            col = new DataColumn("NetPay");
            custDT.Columns.Add(col);
            for (int i = 0; i <= CheckBoxList1.Items.Count - 1; i++)
            {
                DataRow dr = null;
                dr = custDT.NewRow();
                if (CheckBoxList2.Items[i].Selected == true)
                {
                    dr[0] = CheckBoxList1.Items[i].Value;
                    dr[1] = CheckBoxList2.Items[i].Value;
                    TotalSelectAmount1 = Convert.ToDouble(CheckBoxList2.Items[i].Value);
                    TotalSelectAmount = TotalSelectAmount1 + TotalSelectAmount;
                    flag1 = 1;
                    custDT.Rows.Add(dr);
                }
            }
             
            SqlCommand cmd = new SqlCommand("SELECT filename, branchid, month, year, doe, status, userid FROM bankformatmaster WHERE  (filename=@filename) AND (month=@fmonth) AND (year=@fyear) GROUP BY filename, branchid, month, year, doe, status, userid");
            cmd.Parameters.Add("@fyear", year);
            cmd.Parameters.Add("@fmonth", month);
            cmd.Parameters.Add("@filename", filename);
            DataTable Branchdata = SalesDB.SelectQuery(cmd).Tables[0];

            cmd = new SqlCommand("SELECT  employedetails.empid, employedetails.fullname, employedetails.employee_num, employedetails.designationid, employedetails.company_id, employebankdetails.accountno, employebankdetails.ifsccode, employebankdetails.bankid,  employedetails.employee_type, employedetails.employee_dept, employedetails.cellphone  FROM  employedetails INNER JOIN  employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.status = 'NO') AND (employedetails.branchid = @branchid)");
            cmd.Parameters.Add("@branchid", branchid);
            DataTable DTEMPDTA = SalesDB.SelectQuery(cmd).Tables[0];
            int coun = 0;
            if (txt_FileName.Text != "")
            {
                int filecount = Branchdata.Rows.Count;
                if (filecount > 0)
                {
                    lbl_ErrorMsg.Visible = true;
                    lbl_ErrorMsg.Text = "FileName Already Exists...";
                    return;
                }
            }
            else
            {
               coun = Branchdata.Rows.Count;
            }
            if (coun == 0)
            {
                cmd = new SqlCommand("insert into bankformatmaster (filename, branchid, month, year, doe, status, userid ) values (@filename,@branchid,@month,@year,@doe,@status,@userid)");
                cmd.Parameters.Add("@filename", filename);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", month);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@status", "1");
                cmd.Parameters.Add("@userid", userid);
                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                SalesDB.insert(cmd);
                cmd = new SqlCommand("Select max(sno) as sno From bankformatmaster");
                DataTable dtcollection = SalesDB.SelectQuery(cmd).Tables[0];
                string refsno = dtcollection.Rows[0]["sno"].ToString();
                if (custDT.Rows.Count > 0)
                {
                    foreach (DataRow dr in custDT.Rows)
                    {
                        string empid = dr["Employe_id"].ToString();
                        string NetPay = dr["NetPay"].ToString();
                        string myflag = "0";
                        foreach (DataRow dra in DTEMPDTA.Select("empid='" + empid + "'"))
                        {
                            cmd = new SqlCommand("insert into subbankformatmaster ( Companyid, branchid, empid, employecode, empname, designation, netpay, bankaccountno, ifsccode, emptype, bankid, deptid, mobileno, refno,  month, year, flag) values (@Companyid,@branchid,@empid,@employecode,@empname,@designation,@netpay,@bankaccountno,@ifsccode,@emptype,@bankid,@deptid,@empphonnum,@refno, @cmonth, @cyear, @flag)");
                            cmd.Parameters.Add("@Companyid", dra["company_id"].ToString());
                            cmd.Parameters.Add("@branchid", branchid);
                            cmd.Parameters.Add("@empid", empid);
                            cmd.Parameters.Add("@employecode", dra["employee_num"].ToString());
                            cmd.Parameters.Add("@empname", dra["fullname"].ToString());
                            cmd.Parameters.Add("@designation", dra["designationid"].ToString());
                            cmd.Parameters.Add("@netpay", NetPay);
                            cmd.Parameters.Add("@bankaccountno", dra["accountno"].ToString());
                            cmd.Parameters.Add("@ifsccode", dra["ifsccode"].ToString());
                            cmd.Parameters.Add("@emptype", dra["employee_type"].ToString());
                            cmd.Parameters.Add("@bankid", dra["bankid"].ToString());
                            cmd.Parameters.Add("@deptid", dra["employee_dept"].ToString());
                            cmd.Parameters.Add("@empphonnum", dra["cellphone"].ToString());
                            cmd.Parameters.Add("@refno", refsno);
                            cmd.Parameters.Add("@cmonth", ddlmonth.SelectedItem.Value);
                            cmd.Parameters.Add("@cyear", ddlyear.SelectedItem.Value);
                            cmd.Parameters.Add("@flag", myflag);
                            SalesDB.insert(cmd);
                        }
                    }
                    lbl_ErrorMsg.Visible = true;
                    lbl_ErrorMsg.Text = "Saved Success Fully";
                    BindBankPaymentData();
                }
            }
            else
            {
                cmd = new SqlCommand("Select max(sno) as sno From bankformatmaster WHERE filename=@filename");
                cmd.Parameters.Add("@filename", filename);
                DataTable dtcollection = SalesDB.SelectQuery(cmd).Tables[0];
                string refsno = dtcollection.Rows[0]["sno"].ToString();
                if (custDT.Rows.Count > 0)
                {
                    foreach (DataRow dr in custDT.Rows)
                    {
                        string empid = dr["Employe_id"].ToString();
                        string NetPay = dr["NetPay"].ToString();
                        string myflag = "0";
                        foreach (DataRow dra in DTEMPDTA.Select("empid='" + empid + "'"))
                        {
                            cmd = new SqlCommand("insert into subbankformatmaster ( Companyid, branchid, empid, employecode, empname, designation, netpay, bankaccountno, ifsccode, emptype, bankid, deptid, mobileno, refno, month, year, flag) values (@Companyid,@branchid,@empid,@employecode,@empname,@designation,@netpay,@bankaccountno,@ifsccode,@emptype,@bankid,@deptid,@empphonnum,@refno, @cmonth, @cyear, @flag)");
                            cmd.Parameters.Add("@Companyid", dra["company_id"].ToString());
                            cmd.Parameters.Add("@branchid", branchid);
                            cmd.Parameters.Add("@empid", empid);
                            cmd.Parameters.Add("@employecode", dra["employee_num"].ToString());
                            cmd.Parameters.Add("@empname", dra["fullname"].ToString());
                            cmd.Parameters.Add("@designation", dra["designationid"].ToString());
                            cmd.Parameters.Add("@netpay", NetPay);
                            cmd.Parameters.Add("@bankaccountno", dra["accountno"].ToString());
                            cmd.Parameters.Add("@ifsccode", dra["ifsccode"].ToString());
                            cmd.Parameters.Add("@emptype", dra["employee_type"].ToString());
                            cmd.Parameters.Add("@bankid", dra["bankid"].ToString());
                            cmd.Parameters.Add("@deptid", dra["employee_dept"].ToString());
                            cmd.Parameters.Add("@empphonnum", dra["cellphone"].ToString());
                            cmd.Parameters.Add("@refno", refsno);
                            cmd.Parameters.Add("@cmonth", ddlmonth.SelectedItem.Value);
                            cmd.Parameters.Add("@cyear", ddlyear.SelectedItem.Value);
                            cmd.Parameters.Add("@flag", myflag);
                            SalesDB.insert(cmd);
                        }
                    }

                    lbl_ErrorMsg.Visible = true;
                    lbl_ErrorMsg.Text = "Saved Success Fully";
                    BindBankPaymentData();
                }
            }
            
        }
        catch (Exception ex)
        {
            lbl_ErrorMsg.Visible = true;
            lbl_ErrorMsg.Text = ex.ToString().Trim();
        }
    }


    protected void chk_OldFileName_CheckedChanged(object sender, EventArgs e)
    {
        if (chk_OldFileName.Checked == true)
        {
            ddl_oldfilename.Visible = true;
            txt_FileName.Visible = false;
            txt_FileName.Text = "";
            Loadoldfilename();
        }
        else
        {
            ddl_oldfilename.Visible = false;
            txt_FileName.Visible = true;
            txt_FileName.Text = " ";
        }
    }

    private void Loadoldfilename()
    {
        try
        {
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            DBManager vdm = new DBManager();
            SqlCommand cmd = new SqlCommand("SELECT filename, branchid, month, year, doe, status, userid FROM bankformatmaster WHERE (month=@month) AND (year=@year) GROUP BY filename, branchid, month, year, doe, status, userid");
            cmd.Parameters.Add("@branchid", ddlbranch.SelectedItem.Value);
            cmd.Parameters.Add("@month", ddlmonth.SelectedItem.Value);
            cmd.Parameters.Add("@year", ddlyear.SelectedItem.Value);
            DataTable Branchdata = vdm.SelectQuery(cmd).Tables[0];
            if (Branchdata.Rows.Count > 0)
            {
                ddl_oldfilename.DataSource = Branchdata;
                ddl_oldfilename.DataTextField = "filename";
                ddl_oldfilename.DataValueField = "filename";
                ddl_oldfilename.DataBind();
            }
        }
        catch (Exception ex)
        {

        }
    }
    public void GETTOTBILLAMOUNT()
    {

        //try
        //{
        //    DateTime dt1 = new DateTime();
        //    DateTime dt2 = new DateTime();
        //  //  dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
        //  //  dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);
        //    ddl_oldfilename.Items.Clear();
        //    string d1 = dt1.ToString("MM/dd/yyyy");
        //    string d2 = dt2.ToString("MM/dd/yyyy");
        //    con = dbaccess.GetConnection();
        //    string STTY = "";
        //    STTY = "select totnetamount,banknetamount,cashnetamount    from ( select totnetamount,banknetamount,totplantcode  from (SELECT ISNULL(SUM(NetAmount),0) as totnetamount,Plant_code as totplantcode FROM Paymentdata Where Plant_code='" + pcode + "' AND   Frm_date='" + d1 + "' AND To_date='" + d2 + "'  group by Plant_code   ) as tot left join (SELECT  ISNULL(SUM(NetAmount),0) as banknetamount,Plant_code as bankplant FROM Paymentdata Where Plant_code='" + pcode + "' AND   Frm_date='" + d1 + "' AND To_date='" + d2 + "' and Payment_mode='bank' group by Plant_code ) as bank on tot.totplantcode=bank.bankplant) as totbank left join (SELECT  ISNULL(SUM(NetAmount),0) as cashnetamount,plant_code as cashplantcode FROM Paymentdata Where Plant_code='" + pcode + "' AND   Frm_date='" + d1 + "' AND To_date='" + d2 + "' and Payment_mode='CASH'  group by Plant_code) as cash on totbank.totplantcode=cash.cashplantcode";
        //    SqlCommand cmd = new SqlCommand(STTY, con);
        //    DataTable dttt = new DataTable();
        //    SqlDataAdapter dss = new SqlDataAdapter(cmd);
        //    dss.Fill(dttt);
        //    txt_totbillamount.Text = dttt.Rows[0][0].ToString();
        //    txt_bank.Text = dttt.Rows[0][1].ToString();
        //    txt_cash.Text = dttt.Rows[0][2].ToString();


        //    ViewState["txttotbankbillamount"] = txt_bank.Text.ToString();

        //}
        //catch
        //{

        //    txt_cash.Text = "0";

        //}

    }





    public void GETbankassignamount()
    {

        //try
        //{
        //    DateTime dt1 = new DateTime();
        //    DateTime dt2 = new DateTime();
        //    dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
        //    dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);
        //    ddl_oldfilename.Items.Clear();
        //    string d1 = dt1.ToString("MM/dd/yyyy");
        //    string d2 = dt2.ToString("MM/dd/yyyy");
        //    con = dbaccess.GetConnection();
        //    string STTYq = "";
        //    STTYq = "SELECT  SUM(NetAmount) AS NATAMT    FROM  BankPaymentllotment    WHERE   Plant_code='" + pcode + "'    AND Billfrmdate='" + d1 + "' AND Billtodate='" + d2 + "'";
        //    SqlCommand cmdq = new SqlCommand(STTYq, con);
        //    DataTable dtttq = new DataTable();
        //    SqlDataAdapter dssq = new SqlDataAdapter(cmdq);
        //    dssq.Fill(dtttq);
        //    // txt_assignamt.Text = dtttq.Rows[0][0].ToString("F2");
        //    double Tempvar = Convert.ToDouble(dtttq.Rows[0][0]);
        //    txt_assignamt.Text = Tempvar.ToString("f2");
        //    ViewState["txtassignamt"] = txt_assignamt.Text;
        //}
        //catch
        //{



        //}

    }


 



   

   

    

    protected void ddl_BankName_SelectedIndexChanged(object sender, EventArgs e)
    {
      //  rid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
        BindBankPaymentData();

    }

    protected void Chk_Cash_CheckedChanged(object sender, EventArgs e)
    {
        //AllCash();
     //   rid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
        //BindBankPaymentData();
        BindBank();

    }
   

    private void BindBank()
    {
        try
        {
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
           // dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
           // dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);


            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            //ds = LoadBank1(ccode, pcode, d1, d2, rid.ToString(), ddl_BankName.SelectedItem.Value.Trim());
            //if (ds != null)
            //{
            //    CheckBoxList1.DataSource = ds;
            //    CheckBoxList1.DataTextField = "Agent_Name";
            //    CheckBoxList1.DataValueField = "proAid";
            //    CheckBoxList1.DataBind();
            //    CheckBoxList2.DataSource = ds;
            //    CheckBoxList2.DataTextField = "Netpay";
            //    CheckBoxList2.DataValueField = "Netpay";
            //    CheckBoxList2.DataBind();

            //}
            //else
            //{
            //   // WebMsgBox.Show("Agents Not Available in this Selection...");
            //}
        }
        catch (Exception ex)
        {

        }
    }
    private DataTable DisplayselectedBankid()
    {
        DataTable DtBid = new DataTable();
        try
        {
            DataColumn DcBid = new DataColumn();
            DataRow ksdr = null;
            DcBid = new DataColumn("Bankid");
            DtBid.Columns.Add(DcBid);

            foreach (System.Web.UI.WebControls.ListItem item in ddchkCountry.Items)
            {
                if (item.Selected)
                {
                    ksdr = DtBid.NewRow();
                    ksdr[0] = item.Value.ToString();
                    DtBid.Rows.Add(ksdr);
                }
            }
            return DtBid;
        }
        catch (Exception ex)
        {
            return DtBid;
        }
    }


    


    protected void ddchkCountry_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void btn_updatestatus_Click(object sender, EventArgs e)
    {
        updatefilestatus();
    }


    public void getassignedamt()
    {
        try
        {

            //DateTime dt1 = new DateTime();
            //DateTime dt2 = new DateTime();
            //dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
            //dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);
            //string d1 = dt1.ToString("MM/dd/yyyy");
            //string d2 = dt2.ToString("MM/dd/yyyy");
            //string assignamt = "";
            //assignamt = "Select top 1 Amount    FROM  AdminAmountAllottoplant    WHERE   Plant_code='" + pcode + "'    AND Billfrmdate='" + d1 + "' AND Billtodate='" + d2 + "' order by Tid desc ";
            //con = dbaccess.GetConnection();
            //SqlCommand cmd = new SqlCommand(assignamt, con);
            //SqlDataAdapter dsp = new SqlDataAdapter(cmd);
            //DataSet dfr = new DataSet();
            //dsp.Fill(dfr);
            //txt_assignamt1.Text = dfr.Tables[0].Rows[0][0].ToString();
        }
        catch
        {


        }

    }
    private void updatefilestatus()
    {
        try
        {
            //DateTime dt1 = new DateTime();
            //DateTime dt2 = new DateTime();
            //dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
            //dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);

            //string d1 = dt1.ToString("MM/dd/yyyy");
            //string d2 = dt2.ToString("MM/dd/yyyy");

            //string sqlstr = "Update  BankPaymentllotment set PStatus=1 WHERE Company_code='" + ccode + "' AND Plant_code='" + pcode + "' AND Billfrmdate='" + d1.ToString().Trim() + "' AND Billtodate='" + d2.ToString().Trim() + "' AND BankFileName='" + ddl_oldfilename.SelectedItem.Value.ToString().Trim() + "'";
            //dbaccess.ExecuteNonquorey(sqlstr);
            //lbl_ErrorMsg.Visible = true;
            //lbl_ErrorMsg.Text = "File Status Updated and Closed...";
        }
        catch (Exception ex)
        {
            lbl_ErrorMsg.Visible = true;
            lbl_ErrorMsg.Text = ex.ToString().Trim();
        }
    }

    
    private void DeleteProblemFiles()
    {
        //try
        //{
        //    DateTime dt1 = new DateTime();
        //    DateTime dt2 = new DateTime();
        //    dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
        //    dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);

        //    string d1 = dt1.ToString("MM/dd/yyyy");
        //    string d2 = dt2.ToString("MM/dd/yyyy");
        //    string deletefilename = ddl_oldfilename.SelectedItem.Value.ToString().Trim();
        //    string sqlstr1 = "SELECT count(*) From BankPaymentllotment WHERE Company_code='" + ccode + "' AND Plant_code='" + pcode + "' AND Billfrmdate='" + d1.ToString().Trim() + "' AND Billtodate='" + d2.ToString().Trim() + "' AND BankFileName='" + ddl_oldfilename.SelectedItem.Value.ToString().Trim() + "' AND PStatus=1";
        //    int count = dbaccess.ExecuteScalarint(sqlstr1);
        //    if (count > 0)
        //    {
        //        lbl_ErrorMsg.Visible = true;
        //        lbl_ErrorMsg.Text = "File Already Closed...FileName[" + deletefilename + "]";
        //    }
        //    else
        //    {
        //        string sqlstr = "DELETE From BankPaymentllotment WHERE Company_code='" + ccode + "' AND Plant_code='" + pcode + "' AND Billfrmdate='" + d1.ToString().Trim() + "' AND Billtodate='" + d2.ToString().Trim() + "' AND BankFileName='" + ddl_oldfilename.SelectedItem.Value.ToString().Trim() + "' AND PStatus=0";
        //        dbaccess.ExecuteNonquorey(sqlstr);
        //        lbl_ErrorMsg.Visible = true;
        //        lbl_ErrorMsg.Text = "File Deleted Successfully...FileName[" + deletefilename + "]";
        //    }

        //}
        //catch (Exception ex)
        //{
        //    lbl_ErrorMsg.Visible = true;
        //    lbl_ErrorMsg.Text = ex.ToString().Trim();
        //}
    }
    protected void btn_delete_Click(object sender, EventArgs e)
    {
        DeleteProblemFiles();
        Loadoldfilename();
    }
    protected void ddl_oldfilename_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void ddl_Plantcode_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void txt_assignamt_TextChanged(object sender, EventArgs e)
    {

    }
}