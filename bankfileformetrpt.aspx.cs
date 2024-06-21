using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Text;
using System.Configuration;
using System.Data.OleDb;
using System.Drawing;
using System.Xml;
using System.IO;

public partial class bankfileformetrpt : System.Web.UI.Page
{
    public string ccode;
    public string pcode;
    public string managmobNo;
    public string pname;
    public string cname;
    public string filename;
    //
    string currentId = string.Empty;
    decimal subTotal = 0;
    decimal total = 0;
    int subTotalRowIndex = 0;
    SqlDataReader dr;
    DateTime dtm = new DateTime();
    SqlConnection con = new SqlConnection();
    string planttype;
    string planttypehdfc;
    string d1, d2;
    public static int roleid;
    string getid;
    int GETID;
    string Agent_Id;
    DataTable dtaddamount = new DataTable();
    string paymode;
    string ptype;
    string statement;
    string accountnu;
    string companyname;
    DataTable showreport = new DataTable();
    double milkpayamt;
    double excesspayamt;

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
                PopulateYear();
                bindbranchs();
                if (chk_All.Checked == true)
                {
                    lbl_PlantName.Visible = false;
                    ddlbranch.Visible = false;
                    lbl_addeddate.Visible = false;
                    ddl_filename.Visible = false;
                    ddlmonth.Visible = false;
                    ddlyear.Visible = false;
                    Label2.Visible = false;
                    Label4.Visible = false;
                    btnfilesload.Visible = false;
                }
                this.BindGrid();
                GridView8.Visible = false;
                Button2.Visible = false;
                btn_kotack.Visible = false;
                btn_kotackexport.Visible = false;
                GridView9.Visible = false;
                lbl_ktk.Visible = false;
                ddl_kotack.Visible = false;
                lbl_totamt.Visible = false;


            }
        }
    }


    private void bindbranchs()
    {

        DBManager vdm = new DBManager();
        //branchwise
        //cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='1'");
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        SqlCommand cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
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


    private void Bdate()
    {
       
    }

    protected void chk_All_CheckedChanged(object sender, EventArgs e)
    {

        if (chk_All.Checked == true)
        {
            lbl_PlantName.Visible = false;
            ddlbranch.Visible = false;
            lbl_addeddate.Visible = false;
            ddl_filename.Visible = false;
            ddlmonth.Visible = false;
            ddlyear.Visible = false;
            Label2.Visible = false;
            Label4.Visible = false;
            btnfilesload.Visible = false;
        }
        else
        {
            lbl_PlantName.Visible = true;
            ddlbranch.Visible = true;
            lbl_addeddate.Visible = true;
            ddl_filename.Visible = true;
            ddlmonth.Visible = true;
            ddlyear.Visible = true;
            Label2.Visible = true;
            Label4.Visible = true;
            btnfilesload.Visible = true;
        }
    }

    protected void btnfilesload_click(object sender, EventArgs e)
    {
        DBManager vdm = new DBManager();
        string branch = ddlbranch.SelectedItem.Value;
        string month = ddlmonth.SelectedItem.Value;
        string year = ddlyear.SelectedItem.Value;
        //branch mapping
        SqlCommand cmd = new SqlCommand("SELECT sno, filename, branchid, month, year, doe, status, userid FROM bankformatmaster where branchid=@branchid AND month=@month AND year=@year");
        cmd.Parameters.Add("@branchid", branch);
        cmd.Parameters.Add("@month", month);
        cmd.Parameters.Add("@year", year);
        DataTable dtfiletrips = vdm.SelectQuery(cmd).Tables[0];
        ddl_filename.DataSource = dtfiletrips;
        ddl_filename.DataTextField = "filename";
        ddl_filename.DataValueField = "sno";
        ddl_filename.DataBind();
        ddl_filename.ClearSelection();
        ddl_filename.Items.Insert(0, new ListItem { Value = "0", Text = "--Select File--", Selected = true });
        ddl_filename.SelectedValue = "0";

        LoadUploadedFilesDetails();
    }

    private void Adddate()
    {
        try
        {
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
            dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);
            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            SqlDataReader dr = null;
            ddl_filename.Items.Clear();
            //dr = Adddate(ccode, pcode, d1, d2);
            //if (dr.HasRows)
            //{
            //    while (dr.Read())
            //    {
            //        ddl_filename.Items.Add(dr["BankFileName"].ToString());
            //    }
            //}
            //else
            //{
            //    ddl_filename.Items.Add("--select date--");
            //}
        }
        catch (Exception ex)
        {
          //  WebMsgBox.Show(ex.ToString());
        }
    }
   // public SqlDataReader Adddate(string ccode, string pcode, string d1, string d2)
    //{
      //  SqlDataReader dr = null;
      //  string sqlstr = "Select DISTINCT(ISNULL(BankFileName,'')) As adddate,BankFileName from BankPaymentllotment WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "' AND billfrmdate='" + d1 + "' AND billtodate='" + d2 + "' ORDER BY adddate";
      //  dr = dbaccess.GetDatareader(sqlstr);
      //  return dr;

   // }

  
    protected void ddl_Plantname_SelectedIndexChanged(object sender, EventArgs e)
    {
        
        pcode = ddl_Plantcode.SelectedItem.Value;
        Bdate();
        Adddate();
        LoadUploadedFilesDetails();
        Button2.Visible = false;
        GridView8.Visible = false;
        lbl_totamt.Visible = false;
        GridView9.Visible = false;
    }
    protected void ddl_Plantcode_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    private void AllData()
    {
        //try
        //{
        //    string strDownloadFileName = "";
        //    string strExcelConn = "";
        //    DateTime curdate = System.DateTime.Now;
        //    string dd = curdate.ToString("dd");
        //    string mm = curdate.ToString("MM");
        //    string yy = curdate.ToString("yyyy");
        //    string fname = "SVD" + dd + mm + yy;
        //    strDownloadFileName = @"C:/BILL VYSHNAVI/" + fname + ".xls";
        //    string MFileName = @"C:/BILL VYSHNAVI/" + fname + ".xls";
        //    string path = @"C:/BILL VYSHNAVI/";
        //    if (!Directory.Exists(path))
        //    {
        //        Directory.CreateDirectory(path);
        //    }
        //    System.IO.FileInfo file = new System.IO.FileInfo(MFileName);
        //    if (File.Exists(strDownloadFileName.ToString()))
        //    {
        //        //File.Delete(file.FullName.ToString());
        //    }
        //    if (File.Exists(strDownloadFileName.ToString()))
        //    {
        //        // File.Delete(file.FullName.ToString());
        //        strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strDownloadFileName + ";Extended Properties='Excel 8.0;HDR=Yes'";
        //    }
        //    else
        //    {
        //        strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strDownloadFileName + ";Extended Properties='Excel 8.0;HDR=Yes'";
        //    }
        //    // Retrieve data from SQL Server table.
        //    DataTable dtSQL = RetrieveDataAll();
        //    // Export data to an Excel spreadsheet.
        //    ExportToExcelAll(strExcelConn, dtSQL);

        //    if (File.Exists(MFileName.ToString()))
        //    {
        //        //
        //        FileStream sourceFile = new FileStream(file.FullName, FileMode.Open);
        //        float FileSize;
        //        FileSize = sourceFile.Length;
        //        byte[] getContent = new byte[(int)FileSize];
        //        sourceFile.Read(getContent, 0, (int)sourceFile.Length);
        //        sourceFile.Close();
        //        //
        //        Response.ClearContent(); // neded to clear previous (if any) written content
        //        Response.AddHeader("Content-Disposition", "attachment; filename=" + file.Name);
        //        Response.AddHeader("Content-Length", file.Length.ToString());
        //        Response.ContentType = "text/plain";
        //        Response.BinaryWrite(getContent);
        //        File.Delete(file.FullName.ToString());
        //        Response.Flush();
        //        Response.End();

        //    }

        //}
        //catch (Exception ex)
        //{
        //}
    }

    protected void btn_ok_Click(object sender, EventArgs e)
    {
        ExportExcel();
        //AllData();


    }
    protected void btn_Export_Click(object sender, EventArgs e)
    {
       
    }

    


    protected void btn_Exportcsv_Click(object sender, EventArgs e)
    {
        ExportGridToText();
    }
    private void ExportGridToText()
    {
        pcode = ddlbranch.SelectedItem.Value;
        LoadSBIWhileListGrid();
        Response.Clear();
        Response.Buffer = true;
        Response.AddHeader("content-disposition", "attachment;filename=bms.txt");
        Response.Charset = "";
        Response.ContentType = "application/text";
        GridView1.AllowPaging = false;
        GridView1.DataBind();
        StringBuilder Rowbind = new StringBuilder();

        for (int k = 0; k < GridView1.Columns.Count; k++)
        {
            // Rowbind.Append(GridView1.Columns[k].HeaderText + ' ');
        }
        // Rowbind.Append("\r\n");


        for (int i = 0; i < GridView1.Rows.Count; i++)
        {
            int s = GridView1.Columns.Count;
            int j = 1;
            for (int k = 0; k < GridView1.Columns.Count; k++)
            {
                if (j == s)
                {
                    Rowbind.Append(GridView1.Rows[i].Cells[k].Text);
                }
                else
                {
                    Rowbind.Append(GridView1.Rows[i].Cells[k].Text + '#');
                }
                j++;

            }

            Rowbind.Append("\r\n");
        }
        Response.Output.Write(Rowbind.ToString());
        Response.Flush();
        Response.End();

    }
    public void LoadSBIWhileListGrid()
    {

        try
        {
            DataTable Report = new DataTable();
            Report.Columns.Add("Agent_Name");
            Report.Columns.Add("Account_no");
            Report.Columns.Add("Standard");
            Report.Columns.Add("Ifsccode");
            Report.Columns.Add("NetAmount");
            Report.Columns.Add("PStatus");
            Report.Columns.Add("Agent_id");
            Report.Columns.Add("Bank_Id");
            Report.Columns.Add("BankName");
            Report.Columns.Add("Pmail");
            DBManager vdm = new DBManager();
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            string branch = ddlbranch.SelectedItem.Value;
            string month = ddlmonth.SelectedItem.Value;
            string year = ddlyear.SelectedItem.Value;
            string get;
            string fileid = "";
            string d3 = ddl_filename.SelectedItem.Value.ToString();
            SqlCommand cmd = new SqlCommand("SELECT subbankformatmaster.bankid,subbankformatmaster.empid, subbankformatmaster.empname,  subbankformatmaster.Companyid, subbankformatmaster.bankaccountno, subbankformatmaster.ifsccode, CONVERT(int, subbankformatmaster.netpay) AS AMOUNT,  bankmaster.bankname FROM  subbankformatmaster INNER JOIN bankmaster ON  subbankformatmaster.bankid = bankmaster.sno WHERE subbankformatmaster.branchid=@branchid AND month=@month AND year=@year AND refno=@refno");
            cmd.Parameters.Add("@branchid", branch);
            cmd.Parameters.Add("@month", month);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@refno", d3);
            DataTable dt = vdm.SelectQuery(cmd).Tables[0];
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    string empname = dr["empname"].ToString();
                    string accountno = dr["bankaccountno"].ToString();
                    string standard = "0";
                    string ifsccode = dr["ifsccode"].ToString();
                    string netpay = dr["AMOUNT"].ToString();
                    string pstatus = "False";
                    string empid = dr["empid"].ToString();
                    string bankid = dr["bankid"].ToString();
                    string bankname = dr["bankname"].ToString();
                    string pmail = "hr@vyshnavi.in";
                    DataRow newrow = Report.NewRow();
                    newrow["Agent_Name"] = empname;
                    newrow["Account_no"] = accountno;
                    newrow["Standard"] = standard;
                    newrow["Ifsccode"] = ifsccode;
                    newrow["NetAmount"] = netpay;
                    newrow["PStatus"] = pstatus;
                    newrow["Agent_id"] = empid;
                    newrow["Bank_Id"] = bankid;
                    newrow["BankName"] = bankname;
                    newrow["Pmail"] = pmail;
                    Report.Rows.Add(newrow);
                }
                if (Report.Rows.Count > 0)
                {
                    GridView1.DataSource = Report;
                    GridView1.DataBind();
                }
                else
                {
                    GridView1.DataSource = null;
                    GridView1.DataBind();
                }
            }
        }
        catch
        {

        }
    }

    private void ExportGridToTextSBIPaymentAllotmentList()
    {
        pcode = ddl_Plantcode.SelectedItem.Value;
        LoadSBIPaymentAllotmentListGrid();
        Response.Clear();
        Response.Buffer = true;
        Response.AddHeader("content-disposition", "attachment;filename=bms1.txt");
        Response.Charset = "";
        Response.ContentType = "application/text";
        GridView2.AllowPaging = false;
        GridView2.DataBind();
        StringBuilder Rowbind = new StringBuilder();

        for (int k = 0; k < GridView2.Columns.Count; k++)
        {
            // Rowbind.Append(GridView1.Columns[k].HeaderText + ' ');
        }
        // Rowbind.Append("\r\n");


        for (int i = 0; i < GridView2.Rows.Count; i++)
        {
            int s = GridView2.Columns.Count;
            int j = 1;
            int B = 3;
            for (int k = 0; k < GridView2.Columns.Count; k++)
            {
                if (j == s)
                {
                    Rowbind.Append(GridView2.Rows[i].Cells[k].Text);
                }
                else if (j == B)
                {
                    Rowbind.Append(GridView2.Rows[i].Cells[k].Text + "##");
                }
                else
                {
                    Rowbind.Append(GridView2.Rows[i].Cells[k].Text + '#');
                }
                j++;

            }

            Rowbind.Append("\r\n");
        }
        Response.Output.Write(Rowbind.ToString());
        Response.Flush();
        Response.End();

    }

    public void LoadSBIPaymentAllotmentListGrid()
    {

        try
        {
            DataTable Report = new DataTable();
            Report.Columns.Add("Account_no");
            Report.Columns.Add("NetAmount");
            Report.Columns.Add("Adate");
            Report.Columns.Add("NetAmount");
            Report.Columns.Add("Agent_id");
            Report.Columns.Add("Standards");
            DBManager vdm = new DBManager();
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            string branch = ddlbranch.SelectedItem.Value;
            string month = ddlmonth.SelectedItem.Value;
            string year = ddlyear.SelectedItem.Value;
            string get;
            string fileid = "";
            string d3 = ddl_filename.SelectedItem.Value.ToString();
            SqlCommand cmd = new SqlCommand("SELECT subbankformatmaster.bankid,subbankformatmaster.empid, subbankformatmaster.empname,  subbankformatmaster.Companyid, subbankformatmaster.bankaccountno, subbankformatmaster.ifsccode, CONVERT(int, subbankformatmaster.netpay) AS AMOUNT,  bankmaster.bankname FROM  subbankformatmaster INNER JOIN bankmaster ON  subbankformatmaster.bankid = bankmaster.sno WHERE subbankformatmaster.branchid=@branchid AND month=@month AND year=@year AND refno=@refno");
            cmd.Parameters.Add("@branchid", branch);
            cmd.Parameters.Add("@month", month);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@refno", d3);
            DataTable dt = vdm.SelectQuery(cmd).Tables[0];
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    string empname = dr["empname"].ToString();
                    string accountno = dr["bankaccountno"].ToString();
                    string standard = "0";
                    string ifsccode = dr["ifsccode"].ToString();
                    string netpay = dr["AMOUNT"].ToString();
                    string pstatus = "False";
                    string empid = dr["empid"].ToString();
                    string bankid = dr["bankid"].ToString();
                    string bankname = dr["bankname"].ToString();
                    string pmail = "hr@vyshnavi.in";
                    DataRow newrow = Report.NewRow();
                    newrow["Account_no"] = accountno;
                    newrow["NetAmount"] = netpay;
                    newrow["Adate"] = ServerDateCurrentdate.ToString("dd/MM/yyyy");
                    newrow["Agent_id"] = empid;
                    newrow["NetAmount"] = bankid;
                    newrow["Standards"] = "Salary";
                    Report.Rows.Add(newrow);
                }
                if (Report.Rows.Count > 0)
                {
                    GridView2.DataSource = Report;
                    GridView2.DataBind();
                }
                else
                {
                    GridView2.DataSource = null;
                    GridView2.DataBind();
                }
            }
        }
        catch
        {

        }
    }

    public void LoadINGListGrid()
    {

        try
        {
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            DateTime dt3 = new DateTime();
            dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
            dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);
            dt3 = DateTime.ParseExact(ddl_filename.SelectedItem.Value, "dd/MM/yyyy", null);

            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            string d3 = dt3.ToString("MM/dd/yyyy");

            string connStr = ConfigurationManager.ConnectionStrings["AMPSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sqlstr = "Select UPPER(REPLACE(AgentName,'.',' ')) AS BeneficiaryName,BankName AS BeneficiaryBankName,Account_no AS AccountNo,BankName AS BeneficiaryAccountType,Ifsccode AS IFSCCode,NetAmount AS Amount,BankName AS SendertoReceiverInfo ,agent_id AS OwnReferenceNumber,BankName AS Remarks,PStatus,Bank_Id,Pm.Pmail AS Pmail,pnumber from (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName,Bank_Id,Bd.Bankname AS BankName,plant_code,Pnumber from (SELECT agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName AS AgentName,Bank_Id,plant_code,phone_number AS Pnumber FROM (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,plant_code from BankPaymentllotment WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "' AND billfrmdate='" + d1 + "' AND billtodate='" + d2 + "' AND Added_date='" + d3 + "' ) AS Bp LEFT JOIN  (SELECT Agent_Id AS Aid,Agent_Name AS AgentName,Bank_Id,phone_number FROM Agent_Master WHERE  Company_code='" + ccode + "' AND Plant_code='" + pcode + "') AS Am ON bp.agent_id=Am.Aid ) AS t1 INNER JOIN  (Select Bank_id AS Bid,Bank_Name AS Bankname from Bank_Details WHERE Company_code='" + ccode + "') AS Bd ON t1.Bank_Id=Bd.Bid ) AS t2 LEFT JOIN  (Select plant_code,pmail from Plant_Master WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "') AS Pm ON t2.plant_code=Pm.Plant_Code ORDER BY t2.agent_id ";

                SqlCommand cmd = new SqlCommand(sqlstr, conn);
                DataTable dt = new DataTable();
                SqlDataAdapter sqlDa = new SqlDataAdapter(cmd);
                sqlDa.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    GridView3.DataSource = dt;
                    GridView3.DataBind();
                }
                else
                {
                    GridView3.DataSource = null;
                    GridView3.DataBind();
                }
            }
        }
        catch
        {

        }
    }


    protected void btn_SbipaymentListcsv0_Click(object sender, EventArgs e)
    {
        ExportGridToTextSBIPaymentAllotmentList();
    }
    protected void btn_ExportIng_Click(object sender, EventArgs e)
    {
        Ing();
    }
    protected DataTable RetrieveData1()
    {
        DataTable dt = new DataTable();
        try
        {
            SqlDataAdapter da = new SqlDataAdapter();
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();

            dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
            dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);


            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            string d3 = ddl_filename.SelectedItem.Value.ToString();

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AMPSConnectionString"].ToString()))
            {
                da = new SqlDataAdapter("Select UPPER(REPLACE(AgentName,'.',' ')) AS BeneficiaryName,BankName AS BeneficiaryBankName,Account_no AS AccountNo,BankName AS BeneficiaryAccountType,Ifsccode AS IFSCCode,NetAmount AS Amount,BankName AS SendertoReceiverInfo ,agent_id AS OwnReferenceNumber,BankName AS Remarks,PStatus,Bank_Id,Pm.Pmail AS Pmail,pnumber from (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName,Bank_Id,Bd.Bankname AS BankName,plant_code,Pnumber from (SELECT agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName AS AgentName,Bank_Id,plant_code,phone_number AS Pnumber FROM (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,plant_code from BankPaymentllotment WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "' AND billfrmdate='" + d1 + "' AND billtodate='" + d2 + "' AND BankFileName='" + d3 + "' ) AS Bp LEFT JOIN  (SELECT Agent_Id AS Aid,Agent_Name AS AgentName,Bank_Id,phone_number FROM Agent_Master WHERE  Company_code='" + ccode + "' AND Plant_code='" + pcode + "') AS Am ON bp.agent_id=Am.Aid ) AS t1 INNER JOIN  (Select Bank_id AS Bid,Bank_Name AS Bankname from Bank_Details WHERE Company_code='" + ccode + "') AS Bd ON t1.Bank_Id=Bd.Bid ) AS t2 LEFT JOIN  (Select plant_code,pmail from Plant_Master WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "') AS Pm ON t2.plant_code=Pm.Plant_Code ORDER BY t2.agent_id ", conn);
                // Fill the DataTable with data from SQL Server table.
                da.Fill(dt);
            }

            return dt;
        }
        catch (Exception ex)
        {
            return dt;
        }
    }
    protected void ExportToExcel(string strConn, System.Data.DataTable dtSQL)
    {
        try
        {
            using (OleDbConnection conn = new OleDbConnection(strConn))
            {
                // Create a new sheet in the Excel spreadsheet.
                OleDbCommand cmd = new OleDbCommand("create table INGBULK(BeneficiaryName  Varchar(28),BeneficiaryBankName Varchar(80),AccountNo Varchar(25),BeneficiaryAccountType Varchar(10),IFSCCode Varchar(15),Amount Double,SendertoReceiverInfo Varchar(60),OwnReferenceNumber Varchar(20),Remarks Varchar(80))", conn);

                // Open the connection.
                conn.Open();

                // Execute the OleDbCommand.
                cmd.ExecuteNonQuery();

                cmd.CommandText = "INSERT INTO INGBULK (BeneficiaryName,BeneficiaryBankName,AccountNo,BeneficiaryAccountType,IFSCCode,Amount,SendertoReceiverInfo,OwnReferenceNumber,Remarks) values (?,?,?,?,?,?,?,?,?)";

                // Add the parameters.
                // cmd.Parameters.Add("Tid", OleDbType.Integer);              
                cmd.Parameters.Add("BeneficiaryName", OleDbType.VarChar, 28, "BeneficiaryName");
                cmd.Parameters.Add("BeneficiaryBankName", OleDbType.VarChar, 80, "BeneficiaryBankName");
                cmd.Parameters.Add("AccountNo", OleDbType.VarChar, 25, "AccountNo");
                cmd.Parameters.Add("BeneficiaryAccountType", OleDbType.VarChar, 10, "BeneficiaryAccountType");
                cmd.Parameters.Add("IFSCCode", OleDbType.VarChar, 15, "IFSCCode");
                cmd.Parameters.Add("Amount", OleDbType.Double, 8, "Amount");
                cmd.Parameters.Add("SendertoReceiverInfo", OleDbType.VarChar, 60, "SendertoReceiverInfo");
                cmd.Parameters.Add("OwnReferenceNumber", OleDbType.VarChar, 20, "OwnReferenceNumber");
                cmd.Parameters.Add("Remarks", OleDbType.VarChar, 20, "Remarks");

                // Initialize an OleDBDataAdapter object.
                OleDbDataAdapter da = new OleDbDataAdapter("select * from INGBULK", conn);

                // Set the InsertCommand of OleDbDataAdapter, 
                // which is used to insert data.
                da.InsertCommand = cmd;
                // Changes the Rowstate()of each DataRow to Added,
                // so that OleDbDataAdapter will insert the rows.
                foreach (DataRow dr in dtSQL.Rows)
                {
                    dr.SetAdded();
                }
                // Insert the data into the Excel spreadsheet.
                da.Update(dtSQL);

            }

        }
        catch (Exception ex)
        {
        }
    }

    protected DataTable RetrieveData2()
    {
        DataTable dt = new DataTable();
        try
        {
            SqlDataAdapter da = new SqlDataAdapter();
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            // DateTime dt3 = new DateTime();
            dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
            dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);
            // dt3 = DateTime.ParseExact(ddl_filename.SelectedItem.Value, "dd/MM/yyyy", null);

            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            //string d3 = dt3.ToString("MM/dd/yyyy");
            string d3 = ddl_filename.SelectedItem.Value.ToString();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AMPSConnectionString"].ToString()))
            {
                da = new SqlDataAdapter("Select Account_no AS AccountNo,REPLACE(AgentName,'.',' ') AS Name,NetAmount AS Amount,BankName AS Narration,BankName AS BeneficiaryBankName,BankName AS BeneficiaryAccountType,Ifsccode AS IFSCCode,BankName AS SendertoReceiverInfo ,agent_id AS OwnReferenceNumber,BankName AS Remarks,PStatus,Bank_Id,Pm.Pmail AS Pmail,pnumber from (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName,Bank_Id,Bd.Bankname AS BankName,plant_code,Pnumber from (SELECT agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName AS AgentName,Bank_Id,plant_code,phone_number AS Pnumber FROM (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,plant_code from BankPaymentllotment WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "' AND billfrmdate='" + d1 + "' AND billtodate='" + d2 + "' AND bankFileName='" + d3 + "' ) AS Bp LEFT JOIN  (SELECT Agent_Id AS Aid,Agent_Name AS AgentName,Bank_Id,phone_number FROM Agent_Master WHERE  Company_code='" + ccode + "' AND Plant_code='" + pcode + "') AS Am ON bp.agent_id=Am.Aid ) AS t1 INNER JOIN  (Select Bank_id AS Bid,Bank_Name AS Bankname from Bank_Details WHERE Company_code='" + ccode + "') AS Bd ON t1.Bank_Id=Bd.Bid ) AS t2 LEFT JOIN  (Select plant_code,pmail from Plant_Master WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "') AS Pm ON t2.plant_code=Pm.Plant_Code ORDER BY t2.agent_id ", conn);
                // Fill the DataTable with data from SQL Server table.
                da.Fill(dt);
            }

            return dt;
        }
        catch (Exception ex)
        {
            return dt;
        }
    }

    protected void ExportToExcel2(string strConn, System.Data.DataTable dtSQL)
    {
        try
        {
            using (OleDbConnection conn = new OleDbConnection(strConn))
            {
                // Create a new sheet in the Excel spreadsheet.
                OleDbCommand cmd = new OleDbCommand("create table INGBULKSVD(AccountNo Varchar(25),Name  Varchar(28),Amount Double,Narration Varchar(100))", conn);
                // Open the connection.
                conn.Open();

                // Execute the OleDbCommand.
                cmd.ExecuteNonQuery();

                cmd.CommandText = "INSERT INTO INGBULKSVD (AccountNo,Name,Amount,Narration) values (?,?,?,?)";

                // Add the parameters.
                // cmd.Parameters.Add("Tid", OleDbType.Integer);  
                cmd.Parameters.Add("AccountNo", OleDbType.VarChar, 25, "AccountNo");
                cmd.Parameters.Add("Name", OleDbType.VarChar, 28, "Name");
                cmd.Parameters.Add("Amount", OleDbType.Double, 8, "Amount");
                cmd.Parameters.Add("Narration", OleDbType.VarChar, 28, "Narration");

                // Initialize an OleDBDataAdapter object.
                OleDbDataAdapter da = new OleDbDataAdapter("select * from INGBULKSVD", conn);

                // Set the InsertCommand of OleDbDataAdapter, 
                // which is used to insert data.
                da.InsertCommand = cmd;
                // Changes the Rowstate()of each DataRow to Added,
                // so that OleDbDataAdapter will insert the rows.
                foreach (DataRow dr in dtSQL.Rows)
                {
                    dr.SetAdded();
                }
                // Insert the data into the Excel spreadsheet.
                da.Update(dtSQL);

            }

        }
        catch (Exception ex)
        {
        }
    }

    protected DataTable RetrieveDataAll()
    {
        DataTable dt = new DataTable();
        try
        {
            SqlDataAdapter da = new SqlDataAdapter();
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            DateTime dt3 = new DateTime();
            dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
            dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);
            dt3 = DateTime.ParseExact(ddl_filename.SelectedItem.Value, "dd/MM/yyyy", null);

            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            string d3 = dt3.ToString("MM/dd/yyyy");

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AMPSConnectionString"].ToString()))
            {
                da = new SqlDataAdapter("Select agent_id,REPLACE(AgentName,'.',' ') AS Name,NetAmount AS Amount,Account_no AS AccountNo,BankName AS Narration,BankName AS BeneficiaryBankName,BankName AS BeneficiaryAccountType,Ifsccode AS IFSCCode,BankName AS SendertoReceiverInfo ,BankName AS Remarks,PStatus,Bank_Id,Pm.Pmail AS Pmail,pnumber from (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName,Bank_Id,Bd.Bankname AS BankName,plant_code,Pnumber from (SELECT agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName AS AgentName,Bank_Id,plant_code,phone_number AS Pnumber FROM (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,plant_code from BankPaymentllotment WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "' AND billfrmdate='" + d1 + "' AND billtodate='" + d2 + "') AS Bp LEFT JOIN  (SELECT Agent_Id AS Aid,Agent_Name AS AgentName,Bank_Id,phone_number FROM Agent_Master WHERE  Company_code='" + ccode + "' AND Plant_code='" + pcode + "') AS Am ON bp.agent_id=Am.Aid ) AS t1 INNER JOIN  (Select Bank_id AS Bid,Bank_Name AS Bankname from Bank_Details WHERE Company_code='" + ccode + "') AS Bd ON t1.Bank_Id=Bd.Bid ) AS t2 LEFT JOIN  (Select plant_code,pmail from Plant_Master WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "') AS Pm ON t2.plant_code=Pm.Plant_Code ORDER BY t2.agent_id ", conn);
                // Fill the DataTable with data from SQL Server table.
                da.Fill(dt);
            }

            return dt;
        }
        catch (Exception ex)
        {
            return dt;
        }
    }

    protected void ExportToExcelAll(string strConn, System.Data.DataTable dtSQL)
    {
        try
        {
            using (OleDbConnection conn = new OleDbConnection(strConn))
            {
                // Create a new sheet in the Excel spreadsheet.
                OleDbCommand cmd = new OleDbCommand("create table ALLData(agent_id Varchar(28),Name Varchar(28),Amount Double)", conn);

                // Open the connection.
                conn.Open();

                // Execute the OleDbCommand.
                cmd.ExecuteNonQuery();

                cmd.CommandText = "INSERT INTO ALLData(agent_id,Name,Amount) values (?,?,?)";

                // Add the parameters.
                // cmd.Parameters.Add("Tid", OleDbType.Integer);  
                cmd.Parameters.Add("agent_id", OleDbType.VarChar, 28, "agent_id");
                cmd.Parameters.Add("Name", OleDbType.VarChar, 28, "Name");
                cmd.Parameters.Add("Amount", OleDbType.Double, 8, "Amount");

                // Initialize an OleDBDataAdapter object.
                OleDbDataAdapter da = new OleDbDataAdapter("select * from ALLData", conn);

                // Set the InsertCommand of OleDbDataAdapter, 
                // which is used to insert data.
                da.InsertCommand = cmd;
                // Changes the Rowstate()of each DataRow to Added,
                // so that OleDbDataAdapter will insert the rows.
                foreach (DataRow dr in dtSQL.Rows)
                {
                    dr.SetAdded();
                }
                // Insert the data into the Excel spreadsheet.
                da.Update(dtSQL);

            }

        }
        catch (Exception ex)
        {
        }
    }

    protected void btn_ExportIngcsv_Click(object sender, EventArgs e)
    {

        Ingcsv();
    }


    public override void VerifyRenderingInServerForm(Control control)
    {
        //required to avoid the runtime error "
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."
    }


    private void BindGrid()
    {
        DateTime dt1 = new DateTime();
        DateTime dt2 = new DateTime();

        

        //string query = "SELECT CONVERT(NVARCHAR(20),Added_Date,103) AS OrderID,Agent_Id,Agent_Name AS ProductName,NetAmount AS Price FROM BankPaymentllotment where Plant_Code='" + ddl_Plantcode.SelectedItem.Value + "' And Billfrmdate='" + d1.ToString() + "' AND Billtodate='" + d2.ToString() + "' Order By Added_Date,Agent_Id";
        //string query = "SELECT t1.OrderID,t1.Agent_Id,t1.ProductName,t1.Price,UPPER(Bd.Bankname) AS Bankname FROM (SELECT CONVERT(NVARCHAR(20),Added_Date,103) AS OrderID,Agent_Id,UPPER(REPLACE(Agent_Name,'.',' ')) AS ProductName,NetAmount AS Price,Bank_Id FROM BankPaymentllotment where Plant_Code='" + ddlbranch.SelectedItem.Value + "' And Billfrmdate='" + d1.ToString() + "' AND Billtodate='" + d2.ToString() + "' ) AS t1 INNER JOIN  (Select Bank_id AS Bid,Bank_Name AS Bankname from Bank_Details WHERE Company_code='" + ccode + "') AS Bd ON t1.Bank_Id=Bd.Bid Order By t1.OrderID,Agent_Id";
        //string conString = ConfigurationManager.ConnectionStrings["AMPSConnectionString"].ConnectionString;
        //using (SqlConnection con = new SqlConnection(conString))
        //{
        //    using (SqlCommand cmd = new SqlCommand(query))
        //    {
        //        using (SqlDataAdapter sda = new SqlDataAdapter())
        //        {
        //            cmd.Connection = con;
        //            sda.SelectCommand = cmd;
        //            using (DataTable dt = new DataTable())
        //            {
        //                sda.Fill(dt);
        //                GridView4.DataSource = dt;
        //                GridView4.DataBind();
        //            }
        //        }
        //    }
        //}
    }

    protected void OnRowCreated(object sender, GridViewRowEventArgs e)
    {
        try
        {
            subTotal = 0;
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataTable dt = (e.Row.DataItem as DataRowView).DataView.Table;
                //int orderId = Convert.ToInt32(dt.Rows[e.Row.RowIndex]["OrderID"]);
                string orderId = dt.Rows[e.Row.RowIndex]["OrderID"].ToString();
                total += Convert.ToDecimal(dt.Rows[e.Row.RowIndex]["Price"]);
                if (orderId != currentId)
                {
                    if (e.Row.RowIndex > 0)
                    {
                        for (int i = subTotalRowIndex; i < e.Row.RowIndex; i++)
                        {
                            subTotal += Convert.ToDecimal(GridView4.Rows[i].Cells[2].Text);
                        }

                        this.AddTotalRow("Sub Total", subTotal.ToString("N2"));
                        subTotalRowIndex = e.Row.RowIndex;
                    }
                    this.AddTitleRow("File Name", orderId.ToString());
                    currentId = orderId;
                }
            }
        }
        catch (Exception ex)
        {
        }

    }
    private void AddTitleRow(string labelText, string value)
    {
        try
        {
            GridViewRow row = new GridViewRow(0, 0, DataControlRowType.DataRow, DataControlRowState.Normal);
            row.BackColor = ColorTranslator.FromHtml("#F9F9F9");
            // row.Cells.AddRange(new TableCell[1] {new TableCell { Text = labelText+'_'+value, HorizontalAlign = HorizontalAlign.Right},});
            TableCell cell = new TableCell();
            cell.Text = labelText + '_' + value;
            cell.HorizontalAlign = HorizontalAlign.Center;
            cell.ColumnSpan = 3;
            cell.CssClass = "GroupHeaderStyle";
            row.Cells.Add(cell);
            GridView4.Controls[0].Controls.Add(row);
        }
        catch (Exception ex)
        {
        }
    }

    private void AddTotalRow(string labelText, string value)
    {
        try
        {
            GridViewRow row = new GridViewRow(0, 0, DataControlRowType.DataRow, DataControlRowState.Normal);
            row.BackColor = ColorTranslator.FromHtml("#F9F9F9");
            row.Cells.AddRange(new TableCell[3] { new TableCell (), //Empty Cell
                                        new TableCell { Text = labelText, HorizontalAlign = HorizontalAlign.Right},
                                        new TableCell { Text = value, HorizontalAlign = HorizontalAlign.Right } });
            GridView4.Controls[0].Controls.Add(row);
        }
        catch (Exception ex)
        {
        }
    }
    private void AddAllottedRow(string labelText, string value)
    {
        try
        {
            GridViewRow row = new GridViewRow(0, 0, DataControlRowType.DataRow, DataControlRowState.Normal);
            row.BackColor = ColorTranslator.FromHtml("#F9F9F9");

            TableCell cell = new TableCell();
            cell.Text = labelText;
            cell.HorizontalAlign = HorizontalAlign.Left;
            cell.ColumnSpan = 2;
            row.Cells.Add(cell);
            TableCell cell1 = new TableCell();
            cell1.Text = value;
            cell1.HorizontalAlign = HorizontalAlign.Right;
            row.Cells.Add(cell1);
            GridView4.Controls[0].Controls.Add(row);
        }
        catch (Exception ex)
        {
        }
    }
    private void AddGrandTotalAllottedRow(string labelText, string value)
    {
        try
        {
            GridViewRow row = new GridViewRow(0, 0, DataControlRowType.DataRow, DataControlRowState.Normal);
            row.BackColor = ColorTranslator.FromHtml("#F9F9F9");

            TableCell cell = new TableCell();
            cell.Text = labelText;
            cell.HorizontalAlign = HorizontalAlign.Left;
            cell.ColumnSpan = 2;
            row.Cells.Add(cell);
            TableCell cell1 = new TableCell();
            cell1.Text = value;
            cell1.HorizontalAlign = HorizontalAlign.Right;
            row.Cells.Add(cell1);
            GridView4.Controls[0].Controls.Add(row);
        }
        catch (Exception ex)
        {
        }
    }

    protected void OnDataBound(object sender, EventArgs e)
    {
        try
        {
            for (int i = subTotalRowIndex; i < GridView4.Rows.Count; i++)
            {
                subTotal += Convert.ToDecimal(GridView4.Rows[i].Cells[2].Text);
            }
            this.AddTotalRow("Sub Total", subTotal.ToString("N2"));
            this.AddTotalRow("Total", total.ToString("N2"));
            LoadAllotmentDetails();
        }
        catch (Exception ex)
        {
        }
    }
    private void LoadAllotmentDetails()
    {
        DateTime dt1 = new DateTime();
        DateTime dt2 = new DateTime();

        dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
        dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);

        string d1 = dt1.ToString("MM/dd/yyyy");
        string d2 = dt2.ToString("MM/dd/yyyy");
        string query = "Select CONVERT(NVARCHAR(10),Date,103) AS AllotedDate,Time,CAST(Amount AS DECIMAL(18,2)) AS AllotAmt from AdminAmountAllotToPlant  Where Plant_code='" + ddl_Plantcode.SelectedItem.Value + "' And Billfrmdate='" + d1.ToString() + "' AND Billtodate='" + d2.ToString() + "'  Order By  Date";
        string conString = ConfigurationManager.ConnectionStrings["AMPSConnectionString"].ConnectionString;
        using (SqlConnection con = new SqlConnection(conString))
        {
            con.Open();
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.HasRows)
                    {
                        decimal Gtotal = 0;
                        while (dr.Read())
                        {
                            string mes = dr["AllotedDate"].ToString() + '_' + dr["Time"].ToString();
                            decimal val = Convert.ToDecimal(dr["AllotAmt"]);
                            Gtotal = Gtotal + val;
                            this.AddAllottedRow(mes, val.ToString("N2"));
                        }
                        this.AddGrandTotalAllottedRow("Total Allotted Amount", Gtotal.ToString("N2"));
                    }

                }
            }
        }
    }

    private void ExportExcel()
    {
        try
        {
            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", "AllData.xls"));
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            GridView4.AllowPaging = false;
            // BindGrid();
            GridView4.HeaderRow.Style.Add("background-color", "#FFFFFF");//#3AC0F2.#FFFFFF,#507CD1
            for (int a = 0; a < GridView4.HeaderRow.Cells.Count; a++)
            {
                GridView4.HeaderRow.Cells[a].Style.Add("background-color", "#3AC0F2");
            }
            int j = 1;
            foreach (GridViewRow gvrow in GridView4.Rows)
            {
                gvrow.BackColor = Color.White;
                if (j <= GridView4.Rows.Count)
                {
                    if (j % 2 != 0)
                    {
                        for (int k = 0; k < gvrow.Cells.Count; k++)
                        {
                            gvrow.Cells[k].Style.Add("background-color", "#EFF3FB");
                        }
                    }
                }
                j++;
            }
            GridView4.RenderControl(htw);
            Response.Write(sw.ToString());
            Response.End();
        }
        catch (Exception ex)
        {
        }

    }

    protected void GridView4_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void btn_Hdfc_Click(object sender, EventArgs e)
    {
        HdfcExcel();
    }

    protected DataTable RetrieveDataHdfc()
    {
        DataTable dt = new DataTable();
        try
        {
            SqlDataAdapter da = new SqlDataAdapter();
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            //DateTime dt3 = new DateTime();
            dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
            dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);
            // dt3 = DateTime.ParseExact(ddl_filename.SelectedItem.Value, "dd/MM/yyyy", null);

            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            //string d3 = dt3.ToString("MM/dd/yyyy");
            string d3 = ddl_filename.SelectedItem.Value.ToString();

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AMPSConnectionString"].ToString()))
            {
                SqlCommand sqlCmd = new SqlCommand("dbo.[Get_HdfcUploadFile]");
                conn.Open();
                sqlCmd.Connection = conn;
                sqlCmd.CommandType = CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@spccode", ccode);
                sqlCmd.Parameters.AddWithValue("@sppcode", pcode);
                sqlCmd.Parameters.AddWithValue("@spfrmdate", d1.Trim());
                sqlCmd.Parameters.AddWithValue("@sptodate", d2.Trim());
                sqlCmd.Parameters.AddWithValue("@spdate", d3);
                da = new SqlDataAdapter(sqlCmd);
                // Fill the DataTable with data from SQL Server table.
                da.Fill(dt);
            }

            return dt;
        }
        catch (Exception ex)
        {
            return dt;
        }
    }
    protected void ExportToExcelHdfc(string strConn, System.Data.DataTable dtSQL)
    {
        try
        {
            using (OleDbConnection conn = new OleDbConnection(strConn))
            {
                //// Create a new sheet in the Excel spreadsheet.
                OleDbCommand cmd = new OleDbCommand("create table SALARY(ACCOUNT Varchar(25),C  Varchar(28),AMOUNT Double,NARRATION Varchar(100))", conn);

                // Open the connection.
                conn.Open();

                // Execute the OleDbCommand.
                cmd.ExecuteNonQuery();

                cmd.CommandText = "INSERT INTO SALARY(ACCOUNT,C,AMOUNT,NARRATION) values (?,?,?,?)";

                //// Add the parameters.
                //// cmd.Parameters.Add("Tid", OleDbType.Integer);  
                cmd.Parameters.Add("ACCOUNT", OleDbType.VarChar, 25, "ACCOUNT");
                cmd.Parameters.Add("C", OleDbType.VarChar, 28, "C");
                cmd.Parameters.Add("AMOUNT", OleDbType.Double, 8, "AMOUNT");
                cmd.Parameters.Add("NARRATION", OleDbType.VarChar, 28, "NARRATION");

                // Initialize an OleDBDataAdapter object.
                OleDbDataAdapter da = new OleDbDataAdapter("select * from SALARY", conn);

                // Set the InsertCommand of OleDbDataAdapter, 
                // which is used to insert data.
                da.InsertCommand = cmd;
                // Changes the Rowstate()of each DataRow to Added,
                // so that OleDbDataAdapter will insert the rows.
                foreach (DataRow dr in dtSQL.Rows)
                {
                    dr.SetAdded();
                }
                // Insert the data into the Excel spreadsheet.
                da.Update(dtSQL);
            }

        }
        catch (Exception ex)
        {
        }
    }
    private void Ing()
    {
        try
        {
            string strDownloadFileName = "";
            string strExcelConn = "";
            strDownloadFileName = @"C:/SAL VYSHNAVI/" + "INGBulkFileUpload" + ".xls";
            string MFileName = @"C:/SAL VYSHNAVI/" + "INGBulkFileUpload" + ".xls";
            string path = @"C:/SAL VYSHNAVI/";
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            System.IO.FileInfo file = new System.IO.FileInfo(MFileName);
            if (File.Exists(strDownloadFileName.ToString()))
            {
                File.Delete(file.FullName.ToString());
            }
            if (File.Exists(strDownloadFileName.ToString()))
            {
                File.Delete(file.FullName.ToString());
                strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strDownloadFileName + ";Extended Properties='Excel 8.0;HDR=Yes'";
            }
            else
            {
                strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strDownloadFileName + ";Extended Properties='Excel 8.0;HDR=Yes'";
            }
            // Retrieve data from SQL Server table.
            DataTable dtSQL = RetrieveData1();
            // Export data to an Excel spreadsheet.
            ExportToExcel(strExcelConn, dtSQL);

            if (File.Exists(MFileName.ToString()))
            {
                //
                FileStream sourceFile = new FileStream(file.FullName, FileMode.Open);
                float FileSize;
                FileSize = sourceFile.Length;
                byte[] getContent = new byte[(int)FileSize];
                sourceFile.Read(getContent, 0, (int)sourceFile.Length);
                sourceFile.Close();
                //
                Response.ClearContent(); // neded to clear previous (if any) written content
                Response.AddHeader("Content-Disposition", "attachment; filename=" + file.Name);
                Response.AddHeader("Content-Length", file.Length.ToString());
                Response.ContentType = "text/plain";
                Response.BinaryWrite(getContent);
                File.Delete(file.FullName.ToString());
                Response.Flush();
                Response.End();

            }

        }
        catch (Exception ex)
        {
        }
    }
    private void Ingcsv()
    {
        try
        {
            string strDownloadFileName = "";
            string strExcelConn = "";
            DateTime curdate = System.DateTime.Now;
            string dd = curdate.ToString("dd");
            string mm = curdate.ToString("MM");
            string yy = curdate.ToString("yyyy");
            string fname = "SVD" + dd + mm + yy;
            strDownloadFileName = @"C:/BILL VYSHNAVI/" + fname + ".xls";
            string MFileName = @"C:/BILL VYSHNAVI/" + fname + ".xls";
            string path = @"C:/BILL VYSHNAVI/";
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            System.IO.FileInfo file = new System.IO.FileInfo(MFileName);
            if (File.Exists(strDownloadFileName.ToString()))
            {
                //File.Delete(file.FullName.ToString());
            }
            if (File.Exists(strDownloadFileName.ToString()))
            {
                // File.Delete(file.FullName.ToString());
                strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strDownloadFileName + ";Extended Properties='Excel 8.0;HDR=Yes'";
            }
            else
            {
                strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strDownloadFileName + ";Extended Properties='Excel 8.0;HDR=Yes'";
            }
            // Retrieve data from SQL Server table.
            DataTable dtSQL = RetrieveData2();
            // Export data to an Excel spreadsheet.
            ExportToExcel2(strExcelConn, dtSQL);

            if (File.Exists(MFileName.ToString()))
            {
                //
                FileStream sourceFile = new FileStream(file.FullName, FileMode.Open);
                float FileSize;
                FileSize = sourceFile.Length;
                byte[] getContent = new byte[(int)FileSize];
                sourceFile.Read(getContent, 0, (int)sourceFile.Length);
                sourceFile.Close();
                //
                Response.ClearContent(); // neded to clear previous (if any) written content
                Response.AddHeader("Content-Disposition", "attachment; filename=" + file.Name);
                Response.AddHeader("Content-Length", file.Length.ToString());
                Response.ContentType = "text/plain";
                Response.BinaryWrite(getContent);
                File.Delete(file.FullName.ToString());
                Response.Flush();
                Response.End();

            }

        }
        catch (Exception ex)
        {
        }
    }
    private void HdfcExcel()
    {
        try
        {
            string strDownloadFileName = "";
            string strExcelConn = "";
            DateTime curdate = System.DateTime.Now;
            string dd = curdate.ToString("dd");
            string mm = curdate.ToString("MM");
            string yy = curdate.ToString("yyyy");
            string fname = "SVD" + dd + mm + yy;
            // string fname = "Dairy HDFC UPLOAD11 - 20";
            strDownloadFileName = @"C:/BILL VYSHNAVI/" + fname + ".xls";
            string MFileName = @"C:/BILL VYSHNAVI/" + fname + ".xls";
            string path = @"C:/BILL VYSHNAVI/";
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            System.IO.FileInfo file = new System.IO.FileInfo(MFileName);
            if (File.Exists(strDownloadFileName.ToString()))
            {
                //File.Delete(file.FullName.ToString());
            }
            if (File.Exists(strDownloadFileName.ToString()))
            {
                // File.Delete(file.FullName.ToString());
                strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strDownloadFileName + ";Extended Properties='Excel 8.0;HDR=Yes'";
            }
            else
            {
                strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strDownloadFileName + ";Extended Properties='Excel 8.0;HDR=Yes'";
            }
            // Retrieve data from SQL Server table.
            DataTable dtSQL = RetrieveDataHdfc();
            // Export data to an Excel spreadsheet.
            ExportToExcelHdfc(strExcelConn, dtSQL);

            if (File.Exists(MFileName.ToString()))
            {
                //
                FileStream sourceFile = new FileStream(file.FullName, FileMode.Open);
                float FileSize;
                FileSize = sourceFile.Length;
                byte[] getContent = new byte[(int)FileSize];
                sourceFile.Read(getContent, 0, (int)sourceFile.Length);
                sourceFile.Close();
                //
                Response.ClearContent(); // neded to clear previous (if any) written content
                Response.AddHeader("Content-Disposition", "attachment; filename=" + file.Name);
                Response.AddHeader("Content-Length", file.Length.ToString());
                Response.ContentType = "text/plain";
                Response.BinaryWrite(getContent);
                File.Delete(file.FullName.ToString());
                Response.Flush();
                Response.End();

            }

        }
        catch (Exception ex)
        {
        }
    }
    private void OthersToHdfcExportGridTomacroformat()
    {
        int cc = 0;
        pcode = ddlbranch.SelectedItem.Value;
        cc = LoadOthersToHDFCmacroformatGrid();
        Response.Clear();
        Response.Buffer = true;

        string dat, mon;
        dat = System.DateTime.Now.ToString("dd");
        mon = System.DateTime.Now.ToString("MM");
        filename = dat + mon;
        string rowcount = string.Empty;

        if (cc < 10)
        {
            rowcount = "00" + cc.ToString();
        }
        else if (cc >= 10 && cc < 100)
        {
            rowcount = "0" + cc.ToString();
        }
        else if (cc >= 100)
        {
            rowcount = cc.ToString();
        }

        // Response.AddHeader("content-disposition", "attachment;filename=bms.009");
        //  Response.AddHeader("content-disposition", "attachment;filename=SVD2" + filename + "." + rowcount);
        Response.AddHeader("content-disposition", "attachment;filename=" + planttype + filename + "." + rowcount);
        Response.Charset = "";
        Response.ContentType = "application/text";
        GridView6.AllowPaging = false;
        GridView6.DataBind();
        StringBuilder Rowbind = new StringBuilder();

        //Add Header in UploadFile
        //int L = GridView6.Columns.Count;
        //int M = 1;
        //for (int k = 0; k < GridView6.Columns.Count; k++)
        //{
        //    if (M == L)
        //    {
        //        Rowbind.Append(GridView6.Columns[k].HeaderText);
        //    }
        //    else
        //    {
        //        Rowbind.Append(GridView6.Columns[k].HeaderText + ',');
        //    }
        //    M++;

        //}
        //Rowbind.Append("\r\n");

        //Add Rows in UploadFile
        for (int i = 0; i < GridView6.Rows.Count; i++)
        {
            int s = GridView6.Columns.Count;
            int j = 1;
            for (int k = 0; k < GridView6.Columns.Count; k++)
            {
                if (j == s)
                {
                    Rowbind.Append(GridView6.Rows[i].Cells[k].Text);
                }
                else if (j == 1)
                {
                    Rowbind.Append(GridView6.Rows[i].Cells[k].Text + ',' + ',');
                }
                else if (j == 4)
                {
                    Rowbind.Append(GridView6.Rows[i].Cells[k].Text + ',' + ',' + ',' + ',' + ',' + ',' + ',' + ',' + ',');
                }
                else if (j == 5)
                {
                    Rowbind.Append(GridView6.Rows[i].Cells[k].Text + ',' + ',' + ',' + ',' + ',' + ',' + ',' + ',' + ',');
                }
                else if (j == 6)
                {
                    Rowbind.Append(GridView6.Rows[i].Cells[k].Text + ',' + ',');
                }
                else if (j == 8)
                {
                    Rowbind.Append(GridView6.Rows[i].Cells[k].Text + ',' + ',');
                }
                else
                {
                    Rowbind.Append(GridView6.Rows[i].Cells[k].Text + ',');
                }
                j++;

            }

            Rowbind.Append("\r\n");
        }
        Response.Output.Write(Rowbind.ToString());
        Response.Flush();
        Response.End();

    }
    public int LoadOthersToHDFCmacroformatGrid()
    {

        DataTable dt = new DataTable();
        int c = 0;
        try
        {
            //TranType,ACCOUNT,AMOUNT,AgentName,Agent_Id,PayDate,Ifsccode,BankName,Pmail
            DataTable Report = new DataTable();
            Report.Columns.Add("TranType");
            Report.Columns.Add("ACCOUNT");
            Report.Columns.Add("AMOUNT");
            Report.Columns.Add("EMPName");
            Report.Columns.Add("EMP_Id");
            Report.Columns.Add("PayDate");
            Report.Columns.Add("IfscCode");
            Report.Columns.Add("BankName");
            Report.Columns.Add("Pmail");
            DBManager vdm = new DBManager();
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            string branch = ddlbranch.SelectedItem.Value;
            string month = ddlmonth.SelectedItem.Value;
            string year = ddlyear.SelectedItem.Value;
            string get;
            string fileid = "";
            string d3 = ddl_filename.SelectedItem.Value.ToString();
            SqlCommand cmd = new SqlCommand("SELECT subbankformatmaster.empid, subbankformatmaster.empname,  subbankformatmaster.Companyid, subbankformatmaster.bankaccountno, subbankformatmaster.ifsccode, CONVERT(int, subbankformatmaster.netpay) AS AMOUNT,  bankmaster.bankname FROM  subbankformatmaster INNER JOIN bankmaster ON  subbankformatmaster.bankid = bankmaster.sno WHERE subbankformatmaster.branchid=@branchid AND month=@month AND year=@year AND refno=@refno");
            cmd.Parameters.Add("@branchid", branch);
            cmd.Parameters.Add("@month", month);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@refno", d3);
            dt = vdm.SelectQuery(cmd).Tables[0];
            c = dt.Rows.Count;
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    string empname = dr["empname"].ToString();
                    string empid = dr["empid"].ToString();
                    string bankaccno = dr["bankaccountno"].ToString();
                    string ifsccode = dr["ifsccode"].ToString();
                    string AMOUNT = dr["AMOUNT"].ToString();
                    string bankname = dr["bankname"].ToString();
                    DataRow newrow = Report.NewRow();
                    newrow["TranType"] = "N";
                    newrow["ACCOUNT"] = bankaccno;
                    newrow["AMOUNT"] = AMOUNT;
                    newrow["EMPName"] = empname;
                    newrow["EMP_Id"] = empid;
                    newrow["PayDate"] = ServerDateCurrentdate.ToString("dd/MM/yyyy");
                    newrow["IfscCode"] = ifsccode;
                    newrow["BankName"] = bankname;
                    newrow["Pmail"] = "hr@vyshnavi.in";
                    Report.Rows.Add(newrow);
                }
                if (Report.Rows.Count > 0)
                {
                    GridView6.DataSource = Report;
                    GridView6.DataBind();
                }
                else
                {
                    GridView6.DataSource = null;
                    GridView6.DataBind();
                }
            }
            return c;
        }
        catch
        {
            return c;
        }
    }


    public void getaddeddetails()
    {

        DateTime dt1 = new DateTime();
        DateTime dt2 = new DateTime();
        //  DateTime dt3 = new DateTime();
        dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
        dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);
        //dt3 = DateTime.ParseExact(ddl_filename.SelectedItem.Value, "dd/MM/yyyy", null);

        string d1 = dt1.ToString("MM/dd/yyyy");
        string d2 = dt2.ToString("MM/dd/yyyy");
       // con = dbaccess.GetConnection();
        string stt = "select  CONVERT(decimal(18,2), isnull(FLOOR(SUM(TotAmount)),0)) as  TotAmount  from  AgentExcesAmount   where plant_code='" + pcode + "' and  Frm_date='" + d1 + "'  and To_date='" + d2 + "'  and Agent_id='" + Agent_Id + "'";
        SqlCommand cmd = new SqlCommand(stt, con);
        dtaddamount.Rows.Clear();
        SqlDataAdapter DA = new SqlDataAdapter(cmd);
        DA.Fill(dtaddamount);


    }
    private void HdfcExportGridTomacroformat()
    {
        int cc = 0;
        pcode = ddlbranch.SelectedItem.Value;
        cc = LoadHDFCmacroformatGrid();
        Response.Clear();
        Response.Buffer = true;

        string dat, mon;
        dat = System.DateTime.Now.ToString("dd");
        mon = System.DateTime.Now.ToString("MM");
        filename = dat + mon;
        string rowcount = string.Empty;

        if (cc < 10)
        {
            rowcount = "00" + cc.ToString();
        }
        else if (cc >= 10 && cc < 100)
        {
            rowcount = "0" + cc.ToString();
        }
        else if (cc >= 100)
        {
            rowcount = cc.ToString();
        }

        // Response.AddHeader("content-disposition", "attachment;filename=bms.009");
        //   Response.AddHeader("content-disposition", "attachment;filename=SVD2H" + filename + "." + rowcount );
        Response.AddHeader("content-disposition", "attachment;filename=" + planttypehdfc + filename + "." + rowcount);
        Response.Charset = "";
        Response.ContentType = "application/text";
        GridView5.AllowPaging = false;
        GridView5.DataBind();
        StringBuilder Rowbind = new StringBuilder();


        int L = GridView5.Columns.Count;
        int M = 1;
        for (int k = 0; k < GridView5.Columns.Count; k++)
        {
            if (M == L)
            {
                Rowbind.Append(GridView5.Columns[k].HeaderText);
            }
            else
            {
                Rowbind.Append(GridView5.Columns[k].HeaderText + ',');
            }
            M++;

        }
        Rowbind.Append("\r\n");


        for (int i = 0; i < GridView5.Rows.Count; i++)
        {
            int s = GridView5.Columns.Count;
            int j = 1;
            for (int k = 0; k < GridView5.Columns.Count; k++)
            {
                if (j == s)
                {
                    Rowbind.Append(GridView5.Rows[i].Cells[k].Text);
                }
                else
                {
                    Rowbind.Append(GridView5.Rows[i].Cells[k].Text + ',');
                }
                j++;

            }

            Rowbind.Append("\r\n");
        }
        Response.Output.Write(Rowbind.ToString());
        Response.Flush();
        Response.End();

    }
    public int LoadHDFCmacroformatGrid()
    {
        DataTable dt = new DataTable();
        int c = 0;
        try
        {
            DataTable Report = new DataTable();
            Report.Columns.Add("ACCOUNT");
            Report.Columns.Add("C");
            Report.Columns.Add("AMOUNT");
            Report.Columns.Add("NARRATION");
       
            DBManager vdm = new DBManager();
            string branch = ddlbranch.SelectedItem.Value;
            string month = ddlmonth.SelectedItem.Value;
            string year = ddlyear.SelectedItem.Value;
            string get;
            string fileid = "";
            string d3 = ddl_filename.SelectedItem.Value.ToString();
            SqlCommand CMD1 = new SqlCommand("SELECT sno FROM bankformatmaster WHERE filename=@filename");
            CMD1.Parameters.Add("@filename", d3);
            DataTable dtFILENAME = vdm.SelectQuery(CMD1).Tables[0];
            if (dtFILENAME.Rows.Count > 0)
            {
                fileid = dtFILENAME.Rows[0]["sno"].ToString();
            }
            SqlCommand cmd = new SqlCommand("SELECT  subbankformatmaster.Companyid, subbankformatmaster.bankaccountno, subbankformatmaster.ifsccode, CONVERT(int, subbankformatmaster.netpay) AS AMOUNT,  bankmaster.bankname FROM  subbankformatmaster INNER JOIN bankmaster ON  subbankformatmaster.bankid = bankmaster.sno WHERE subbankformatmaster.branchid=@branchid AND month=@month AND year=@year AND refno=@refno");
            cmd.Parameters.Add("@branchid", branch);
            cmd.Parameters.Add("@month", month);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@refno", d3);
            dt = vdm.SelectQuery(cmd).Tables[0];
            c = dt.Rows.Count;
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    string bankaccno = dr["bankaccountno"].ToString();
                    string amount = dr["AMOUNT"].ToString();
                    string cv = "C";
                    string narration = "Salary";
                    DataRow newrow = Report.NewRow();
                    newrow["ACCOUNT"] = bankaccno;
                    newrow["AMOUNT"] = amount;
                    newrow["NARRATION"] = narration;
                    newrow["C"] = cv;
                    string cmpid = dr["Companyid"].ToString();
                    if (cmpid == "1")
                    {
                        planttype = "SVD1";
                        planttypehdfc = "SVD1H";
                    }
                    if (cmpid == "2" || cmpid == "4")
                    {
                        planttype = "SVD2";
                        planttypehdfc = "SVD2H";
                    }
                    Report.Rows.Add(newrow);
                }
                GridView5.DataSource = Report;
                GridView5.DataBind();
            }
            else
            {
                GridView5.DataSource = null;
                GridView5.DataBind();
            }
            return c;
        }
        catch
        {
            return c;
        }
    }

    protected void btn_Submit_Click(object sender, EventArgs e)
    {

        try
        {
            GETUPDATE();
            if (GETID == 0)
            {
               // getplanttype();
                if (rbtLstReportItems.SelectedItem != null)
                {
                    Lbl_selectedReportItem.Text = rbtLstReportItems.SelectedItem.Value;
                    if (Lbl_selectedReportItem.Text == "ALL")
                    {
                        
                        ExportExcel();
                        getupdatefilelock();
                    }
                    else if (Lbl_selectedReportItem.Text == "WSbi")
                    {

                        ExportGridToText();
                        getupdatefilelock();
                    }
                    else if (Lbl_selectedReportItem.Text == "PSbi")
                    {
                        
                        ExportGridToTextSBIPaymentAllotmentList();
                        getupdatefilelock();

                    }
                    else if (Lbl_selectedReportItem.Text == "Ing")
                    {
                        Ing();
                        getupdatefilelock();
                    }
                    else if (Lbl_selectedReportItem.Text == "Ing1")
                    {
                        
                        Ingcsv();
                        getupdatefilelock();

                    }
                    else if (Lbl_selectedReportItem.Text == "Hdfc")  //working
                    {
                        
                        HdfcExportGridTomacroformat();
                        getupdatefilelock();

                    }
                    else if (Lbl_selectedReportItem.Text == "Hdfcoth") //working
                    {
                        
                        OthersToHdfcExportGridTomacroformat();
                        getupdatefilelock();
                       // HdfcExcel();

                    }
                    else if (Lbl_selectedReportItem.Text == "pendingList")
                    {
                        getupdatefilelock();
                        PendingBankPaymentData();
                    }
                    else
                    {
                       // WebMsgBox.Show("Please Check the Selected Items");
                    }

                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Please Select the Report Type')", true);
                   // WebMsgBox.Show("Please Select the Report Type");
                }

            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('File Already Updated')", true);
               // WebMsgBox.Show("File Already Updated");
            }
        }
        catch
        {

        }
    }


    private void createNode(string pID, string pName, string pPrice, XmlTextWriter writer)
    {

        writer.WriteStartElement("Product");
        writer.WriteStartElement("Product_id");
        writer.WriteString(pID);
        writer.WriteEndElement();
        writer.WriteStartElement("Product_name");
        writer.WriteString(pName);
        writer.WriteEndElement();
        writer.WriteStartElement("Product_price");
        writer.WriteString(pPrice);
        writer.WriteEndElement();
        writer.WriteEndElement();
    }






    public void getplanttype()
    {

        if (RadioButtonList1.Text == "BUFF")
        {
            planttype = "SVD1";
            planttypehdfc = "SVD1H";
        }
        if (RadioButtonList1.Text == "COW")
        {
            planttype = "SVD2";
            planttypehdfc = "SVD2H";
        }
    }

    private void PendingBankPaymentData()
    {
        try
        {
            string strDownloadFileName = "";
            string strExcelConn = "";
            strDownloadFileName = @"C:/BILL VYSHNAVI/" + "PaymentPendingList" + ".xls";
            string MFileName = @"C:/BILL VYSHNAVI/" + "PaymentPendingList" + ".xls";
            string path = @"C:/BILL VYSHNAVI/";
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            System.IO.FileInfo file = new System.IO.FileInfo(MFileName);
            if (File.Exists(strDownloadFileName.ToString()))
            {
                File.Delete(file.FullName.ToString());
            }
            if (File.Exists(strDownloadFileName.ToString()))
            {
                File.Delete(file.FullName.ToString());
                strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strDownloadFileName + ";Extended Properties='Excel 8.0;HDR=Yes'";
            }
            else
            {
                strExcelConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strDownloadFileName + ";Extended Properties='Excel 8.0;HDR=Yes'";
            }
            // Retrieve data from SQL Server table.
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
            dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);


            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");

            DataTable dtSQL = RetrieveData5(ccode, pcode, d1, d2);
            // Export data to an Excel spreadsheet.
            ExportToExcel5(strExcelConn, dtSQL);

            if (File.Exists(MFileName.ToString()))
            {
                //
                FileStream sourceFile = new FileStream(file.FullName, FileMode.Open);
                float FileSize;
                FileSize = sourceFile.Length;
                byte[] getContent = new byte[(int)FileSize];
                sourceFile.Read(getContent, 0, (int)sourceFile.Length);
                sourceFile.Close();
                //
                Response.ClearContent(); // neded to clear previous (if any) written content
                Response.AddHeader("Content-Disposition", "attachment; filename=" + file.Name);
                Response.AddHeader("Content-Length", file.Length.ToString());
                Response.ContentType = "text/plain";
                Response.BinaryWrite(getContent);
                File.Delete(file.FullName.ToString());
                Response.Flush();
                Response.End();

            }

        }
        catch (Exception ex)
        {
        }
    }


    protected DataTable RetrieveData5(string cccode1, string pcode1, string dt1, string dt2)
    {
        DataTable dt = new DataTable();
        try
        {
            SqlDataAdapter da = new SqlDataAdapter();

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AMPSConnectionString"].ToString()))
            {
                da = new SqlDataAdapter("SELECT Route_Name,Agent_Name,Netpay FROM (Select Agent_id from BankPaymentllotment WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "' AND billfrmdate='" + dt1 + "' AND billtodate='" + dt2 + "') AS bp  RIGHT JOIN  (SELECT *FROM (SELECT cart.ARid AS Rid,cart.cartAid AS proAid,(CONVERT(nvarchar(15),(CONVERT(nvarchar(9),cart.cartAid)+'_'+ cart.Agent_Name))) AS Agent_Name,ISNULL(prdelo.Smkg,0) AS Smkg,ISNULL(prdelo.Smltr,0) AS Smltr,ISNULL(prdelo.AvgFat ,0) AS AvgFat,ISNULL(prdelo.AvgSnf,0) AS AvgSnf,ISNULL(prdelo.AvgRate,0) AS AvgRate,ISNULL(prdelo.Avgclr,0) AS Avgclr,ISNULL(prdelo.Scans,0) AS Scans,ISNULL(prdelo.SAmt,0) AS SAmt,ISNULL(prdelo.ScommAmt,0) AS ScommAmt,ISNULL(CAST((ISNULL(prdelo.Smltr,0) * ISNULL(cart.CarAmt,0)) AS DECIMAL(18,2)),0) AS Scatamt,ISNULL(prdelo.Ssplbonamt,0) AS Ssplbonamt, ISNULL(prdelo.AvgcRate,0) AS AvgcRate,ISNULL(prdelo.Sfatkg,0) AS Sfatkg,ISNULL(prdelo.Ssnfkg,0) AS Ssnfkg,ISNULL(prdelo.Billadv,0) AS SBilladv,ISNULL(prdelo.Ai,0) AS SAiamt,ISNULL(prdelo.Feed,0) AS SFeedamt,ISNULL(prdelo.Can,0) AS Scanamt,ISNULL(prdelo.Recovery,0) AS SRecoveryamt,ISNULL(prdelo.others,0) AS Sothers,ISNULL(prdelo.instamt,0) AS Sinstamt,ISNULL(prdelo.balance,0) AS Sbalance,ISNULL(prdelo.LoanAmount,0) AS SLoanAmount,ISNULL(prdelo.VouAmount,0) AS Sclaim,CAST( ((ISNULL(prdelo.SAmt,0) + ISNULL(prdelo.ScommAmt,0) + ISNULL(prdelo.Ssplbonamt,0)+ ISNULL(prdelo.VouAmount,0) + ISNULL(prdelo.Scatamt,0)) - (ISNULL(prdelo.Billadv,0)+ISNULL(prdelo.Ai,0)+ISNULL(prdelo.Feed,0)+ISNULL(prdelo.Can,0)+ISNULL(prdelo.Recovery,0)+ISNULL(prdelo.others,0)+ISNULL(prdelo.instamt,0))) AS DECIMAL(18,2)) AS SRNetAmt,FLOOR(CAST( ((ISNULL(prdelo.SAmt,0) + ISNULL(prdelo.ScommAmt,0) + ISNULL(prdelo.Ssplbonamt,0)+ ISNULL(prdelo.VouAmount,0) + ISNULL(prdelo.Scatamt,0)) - (ISNULL(prdelo.Billadv,0)+ISNULL(prdelo.Ai,0)+ISNULL(prdelo.Feed,0)+ISNULL(prdelo.Can,0)+ISNULL(prdelo.Recovery,0)+ISNULL(prdelo.others,0)+ISNULL(prdelo.instamt,0))) AS DECIMAL(18,2))) AS Netpay,CAST((((ISNULL(prdelo.SAmt,0) + ISNULL(prdelo.ScommAmt,0) + ISNULL(prdelo.Ssplbonamt,0) + ISNULL(prdelo.VouAmount,0) + ISNULL(prdelo.Scatamt,0)) - (ISNULL(prdelo.Billadv,0)+ISNULL(prdelo.Ai,0)+ISNULL(prdelo.Feed,0)+ISNULL(prdelo.Can,0)+ISNULL(prdelo.Recovery,0)+ISNULL(prdelo.others,0)+ISNULL(prdelo.instamt,0)) )- (FLOOR(CAST( ((ISNULL(prdelo.SAmt,0) + ISNULL(prdelo.ScommAmt,0) + ISNULL(prdelo.Ssplbonamt,0)+ ISNULL(prdelo.VouAmount,0) + ISNULL(prdelo.Scatamt,0)) - (ISNULL(prdelo.Billadv,0)+ISNULL(prdelo.Ai,0)+ISNULL(prdelo.Feed,0)+ISNULL(prdelo.Can,0)+ISNULL(prdelo.Recovery,0)+ISNULL(prdelo.others,0)+ISNULL(prdelo.instamt,0))) AS DECIMAL(18,2)))) ) AS DECIMAL(18,2)) AS SRound,cart.Bank_Id,cart.Payment_mode,cart.Agent_AccountNo FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT agent_id AS SproAid,SUM(Milk_kg) AS Smkg,SUM(Milk_ltr) AS Smltr,CAST(AVG(FAT) AS DECIMAL(18,2)) AS AvgFat,CAST(AVG(SNF) AS DECIMAL(18,2)) AS AvgSnf,CAST(AVG(Rate) AS DECIMAL(18,2)) AS AvgRate,CAST(AVG(Clr) AS DECIMAL(18,2)) AS Avgclr,CAST(SUM(NoofCans) AS DECIMAL(18,2)) AS Scans,SUM(Amount)  AS SAmt,SUM(Comrate)  AS ScommAmt,SUM(CartageAmount) AS Scatamt,SUM(SplBonusAmount) AS Ssplbonamt,CAST(AVG(ComRate) AS DECIMAL(18,2)) AS Avgcrate,SUM(fat_kg) AS Sfatkg,SUM(snf_kg) AS SSnfkg FROM Procurement WHERE prdate BETWEEN '" + dt1 + "' AND '" + dt2 + "'  AND Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "'  GROUP BY agent_id ) AS Spro LEFT JOIN (SELECT  Agent_id AS DAid ,(CAST((Billadvance) AS DECIMAL(18,2))) AS Billadv,(CAST((Ai) AS DECIMAL(18,2))) AS Ai,(CAST((Feed) AS DECIMAL(18,2))) AS Feed,(CAST((can) AS DECIMAL(18,2))) AS can,(CAST((Recovery) AS DECIMAL(18,2))) AS Recovery,(CAST((others) AS DECIMAL(18,2))) AS others FROM Deduction_Details WHERE deductiondate BETWEEN '" + dt1 + "' AND '" + dt2 + "' AND Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "') AS dedu ON Spro.SproAid=dedu.DAid) AS proded LEFT JOIN (select Agent_Id AS VouAid,CAST(SUM(Amount) AS DECIMAL(18,2))  AS VouAmount  from Voucher_Clear where Plant_Code='" + pcode + "'  AND Clearing_Date BETWEEN '" + dt1 + "' AND '" + dt2 + "' GROUP BY Agent_Id) AS vou ON proded.SproAid=vou.VouAid) AS pdv LEFT JOIN  (SELECT ISNULL(LoAid,0) AS LoAid,ISNULL(balance,0) AS balance,ISNULL(LoanAmount,0) AS LoanAmount,(ISNULL(loanRecAmount1,0)+ ISNULL(0,0)) AS instamt FROM (SELECT LoAid1 AS LoAid,balance1 AS balance,LoanAmount1 AS LoanAmount,loanRecAmount1 FROM (SELECT Agent_id AS LoAid1,CAST(SUM(balance) AS DECIMAL(18,2)) AS balance1,CAST(SUM(LoanAmount) AS DECIMAL(18,2)) AS LoanAmount1 FROM LoanDetails WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "'  GROUP BY Agent_id) AS Lonn LEFT JOIN (SELECT Agent_id AS LoRecAid,CAST(SUM(Paid_Amount) AS DECIMAL(18,2)) AS loanRecAmount1 FROM Loan_Recovery WHERE Company_Code='" + ccode + "' AND Plant_code ='" + pcode + "' AND Paid_date between '" + dt1 + "' AND '" + dt2 + "' GROUP BY Agent_id) AS LonRec ON Lonn.LoAid1=LonRec.LoRecAid ) AS LoF  LEFT JOIN (SELECT Agent_Id AS LoDuAid,CAST(SUM(LoanDueRecovery_Amount) AS DECIMAL(18,2)) AS loanDueRecAmount1 FROM LoanDue_Recovery WHERE Company_Code='" + ccode + "' AND Plant_code ='" + pcode + "' AND LoanRecovery_Date between '" + dt1 + "' AND '" + dt2 + "' GROUP BY Agent_id ) AS LonDRec ON LoF.LoAid=LonDRec.LoDuAid ) AS Lon ON pdv.SproAid=Lon.LoAid ) AS prdelo  INNER JOIN   (SELECT Agent_Id AS cartAid,(CAST((Cartage_Amt) AS DECIMAL(18,2)))AS CarAmt,Agent_Name,Bank_Id,Payment_mode,Agent_AccountNo,Route_id AS ARid  FROM  Agent_Master WHERE Type=0 AND Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "' ) AS cart ON prdelo.SproAid=cart.cartAid ) AS FF  LEFT JOIN  (SELECT Route_id AS RRid,Route_Name FROM Route_Master WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "')AS Rout ON FF.Rid=Rout.RRid) AS F2 ON bp.Agent_id=F2.proAid WHERE bp.agent_id is NULL ORDER BY F2.Rid,bp.Agent_Id ", conn);
                // Fill the DataTable with data from SQL Server table.
                da.Fill(dt);
            }

            return dt;
        }
        catch (Exception ex)
        {
            return dt;
        }
    }
    protected void ExportToExcel5(string strConn, System.Data.DataTable dtSQL)
    {
        try
        {
            using (OleDbConnection conn = new OleDbConnection(strConn))
            {
                // Create a new sheet in the Excel spreadsheet.
                OleDbCommand cmd = new OleDbCommand("create table pendingList(Route_Name  Varchar(30),Agent_Name Varchar(30),Netpay Double)", conn);

                // Open the connection.
                conn.Open();

                // Execute the OleDbCommand.
                cmd.ExecuteNonQuery();

                cmd.CommandText = "INSERT INTO pendingList (Route_Name,Agent_Name,Netpay) values (?,?,?)";

                // Add the parameters.
                // cmd.Parameters.Add("Tid", OleDbType.Integer);              
                cmd.Parameters.Add("Route_Name", OleDbType.VarChar, 30, "Route_Name");
                cmd.Parameters.Add("Agent_Name", OleDbType.VarChar, 30, "Agent_Name");
                cmd.Parameters.Add("Netpay", OleDbType.Double, 8, "Netpay");

                // Initialize an OleDBDataAdapter object.
                OleDbDataAdapter da = new OleDbDataAdapter("select Route_Name,Agent_Name,Netpay from pendingList", conn);

                // Set the InsertCommand of OleDbDataAdapter, 
                // which is used to insert data.
                da.InsertCommand = cmd;
                // Changes the Rowstate()of each DataRow to Added,
                // so that OleDbDataAdapter will insert the rows.
                foreach (DataRow dr in dtSQL.Rows)
                {
                    dr.SetAdded();
                }
                // Insert the data into the Excel spreadsheet.
                da.Update(dtSQL);

            }

        }
        catch (Exception ex)
        {
        }
    }
    private void Datechange()
    {
        DateTime dt1 = new DateTime();
        DateTime dt2 = new DateTime();
        dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
        dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);
        d1 = dt1.ToString("MM/dd/yyyy");
        d2 = dt2.ToString("MM/dd/yyyy");
    }

    private void LoadUploadedFilesDetails()
    {
        try
        {

            DBManager vdm = new DBManager();
            string branch = ddlbranch.SelectedItem.Value;
            string month = ddlmonth.SelectedItem.Value;
            string year = ddlyear.SelectedItem.Value;
            //branch mapping
            SqlCommand cmd = new SqlCommand("SELECT  COUNT(subbankformatmaster.refno) AS ActualNoofROws, UPPER(bankformatmaster.filename) AS BankFileName, SUM(CONVERT(int, subbankformatmaster.netpay)) AS TotalAmount FROM            subbankformatmaster INNER JOIN  bankformatmaster ON subbankformatmaster.refno = bankformatmaster.sno WHERE        (subbankformatmaster.branchid = @branchid) AND (subbankformatmaster.month = @month) AND (subbankformatmaster.year = @year) GROUP BY subbankformatmaster.refno, bankformatmaster.filename");
            cmd.Parameters.Add("@branchid", branch);
            cmd.Parameters.Add("@month", month);
            cmd.Parameters.Add("@year", year);
            DataTable dtfileStrips = vdm.SelectQuery(cmd).Tables[0];
            if (dtfileStrips.Rows.Count > 0)
            {
                GridView7.DataSource = dtfileStrips;
                GridView7.DataBind();
            }
            else
            {
                GridView7.DataSource = null;
                GridView7.DataBind();
            }
        }
        catch (Exception ex)
        {
            ex.ToString();
        }
    }
    protected void GridView7_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridView8.Visible = true;
        Button2.Visible = true;
        getid = (GridView7.SelectedRow.Cells[2].Text).ToString();
        getgrid();
    }


    public void getgrid()
    {

        DateTime dt1 = new DateTime();
        DateTime dt2 = new DateTime();
        DBManager vdm = new DBManager();
        string branch = ddlbranch.SelectedItem.Value;
        string month = ddlmonth.SelectedItem.Value;
        string year = ddlyear.SelectedItem.Value;
        string get;
        string fileid = "";
        SqlCommand CMD1 = new SqlCommand("SELECT sno FROM bankformatmaster WHERE filename=@filename");
        CMD1.Parameters.Add("@filename", getid);
        DataTable dtFILENAME = vdm.SelectQuery(CMD1).Tables[0];
        if (dtFILENAME.Rows.Count > 0)
        {
            fileid = dtFILENAME.Rows[0]["sno"].ToString();
        }

        SqlCommand cmd = new SqlCommand("SELECT subbankformatmaster.empid, subbankformatmaster.empname, subbankformatmaster.bankaccountno, subbankformatmaster.ifsccode, CONVERT(int, subbankformatmaster.netpay) AS netpay,  bankmaster.bankname FROM  subbankformatmaster INNER JOIN bankmaster ON  subbankformatmaster.bankid = bankmaster.sno WHERE subbankformatmaster.branchid=@branchid AND month=@month AND year=@year AND refno=@refno");
        cmd.Parameters.Add("@branchid", branch);
        cmd.Parameters.Add("@month", month);
        cmd.Parameters.Add("@year", year);
        cmd.Parameters.Add("@refno", fileid);
        DataTable dt = vdm.SelectQuery(cmd).Tables[0];
        if (dt.Rows.Count > 0)
        {
            GridView8.DataSource = dt;
            GridView8.DataBind();
            GridView8.FooterRow.Cells[4].Text = "TOTAL AMOUNT";
            decimal milkkg = dt.AsEnumerable().Sum(row => row.Field<int>("netpay"));
            GridView8.FooterRow.Cells[5].HorizontalAlign = HorizontalAlign.Right;
            GridView8.FooterRow.Cells[5].Text = milkkg.ToString("N2");
        }
        else
        {
            GridView8.DataSource = null;
            GridView8.DataBind();
        }
    }
    protected void Button2_Click(object sender, EventArgs e)
    {

        try
        {
            Response.Clear();
            Response.Buffer = true;
            Response.ClearContent();
            Response.ClearHeaders();
            Response.Charset = "";
            string FileName = txt_FromDate.Text + txt_ToDate.Text + DateTime.Now + ".xls";
            StringWriter strwritter = new StringWriter();
            HtmlTextWriter htmltextwrtter = new HtmlTextWriter(strwritter);
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.ms-excel";
            Response.AddHeader("Content-Disposition", "attachment;filename=" + FileName);
            GridView8.GridLines = GridLines.Both;
            GridView8.HeaderStyle.Font.Bold = true;
            GridView8.RenderControl(htmltextwrtter);
            Response.Write(strwritter.ToString());
            Response.End();
        }

        catch
        {
            string message;
            message = "Please Check Your Data";
            string script = "window.onload = function(){ alert('";
            script += message;
            script += "')};";
            ClientScript.RegisterStartupScript(this.GetType(), "SuccessMessage", script, true);


        }
    }

    public void getupdatefilelock()
    {
        DBManager vdm = new DBManager();
        string branch = ddlbranch.SelectedItem.Value;
        string month = ddlmonth.SelectedItem.Value;
        string year = ddlyear.SelectedItem.Value;
        string refno = ddl_filename.SelectedItem.Value.ToString();
        DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
        SqlCommand cmd = new SqlCommand("update subbankformatmaster set flag=@upuser,UpdatedUser=@upusername,UpdatedTime=@update WHERE branchid=@branchid AND month=@month AND year=@year AND refno=@refno");
        cmd.Parameters.Add("@branchid", branch);
        cmd.Parameters.Add("@month", month);
        cmd.Parameters.Add("@year", year);
        cmd.Parameters.Add("@refno", refno);
        cmd.Parameters.Add("@upuser", "1");
        cmd.Parameters.Add("@upusername", Session["userid"].ToString());
        cmd.Parameters.Add("@update", ServerDateCurrentdate);
        vdm.Update(cmd);
    }
    public void GETUPDATE()
    {
        DBManager vdm = new DBManager();
        string branch = ddlbranch.SelectedItem.Value;
        string month = ddlmonth.SelectedItem.Value;
        string year = ddlyear.SelectedItem.Value;

        SqlCommand cmd = new SqlCommand("SELECT * from subbankformatmaster WHERE branchid=@branchid AND month=@month AND year=@year AND flag <> '1'");
        cmd.Parameters.Add("@branchid", branch);
        cmd.Parameters.Add("@month", month);
        cmd.Parameters.Add("@year", year);
        DataTable dt = vdm.SelectQuery(cmd).Tables[0];
        if (dt.Rows.Count > 0)
        {
            GETID = 0;
        }
        else
        {
            GETID = 1;
        }
    }
    protected void GridView7_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
    protected void GridView8_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[5].HorizontalAlign = HorizontalAlign.Right;
        }
    }
    public void getbankdeatils()
    {
        DateTime dt1 = new DateTime();
        DateTime dt2 = new DateTime();
        
        string d1 = dt1.ToString("MM/dd/yyyy");
        string d2 = dt2.ToString("MM/dd/yyyy");
        DBManager vdm = new DBManager();
        DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
        string branch = ddlbranch.SelectedItem.Value;
        string month = ddlmonth.SelectedItem.Value;
        string year = ddlyear.SelectedItem.Value;
        string get;
        string fileid = "";
        string d3 = ddl_filename.SelectedItem.Value.ToString();
        SqlCommand cmd = new SqlCommand("SELECT subbankformatmaster.empid, subbankformatmaster.empname, subbankformatmaster.designation, subbankformatmaster.bankaccountno, subbankformatmaster.ifsccode, subbankformatmaster.Companyid, subbankformatmaster.branchid, subbankformatmaster.employecode, subbankformatmaster.emptype, subbankformatmaster.bankid, subbankformatmaster.deptid, subbankformatmaster.refno,  subbankformatmaster.mobileno, subbankformatmaster.month, subbankformatmaster.year, CONVERT(int, subbankformatmaster.netpay) AS AMOUNT,  bankmaster.bankname FROM  subbankformatmaster INNER JOIN bankmaster ON  subbankformatmaster.bankid = bankmaster.sno WHERE subbankformatmaster.branchid=@branchid AND month=@month AND year=@year AND refno=@refno");
        cmd.Parameters.Add("@branchid", branch);
        cmd.Parameters.Add("@month", month);
        cmd.Parameters.Add("@year", year);
        cmd.Parameters.Add("@refno", d3);
        DataTable dt = vdm.SelectQuery(cmd).Tables[0];
        showreport.Rows.Clear();
        showreport.Columns.Clear();
        showreport.Columns.Add("Report");
        foreach (DataRow dr in dt.Rows)
        {
            string getagentid = dr["empid"].ToString();
            string Agent_Name = dr["empname"].ToString();
            string Ifsccode = dr["ifsccode"].ToString();
            string Account_no = dr["bankaccountno"].ToString();
            double NetAmount = Convert.ToDouble(dr["AMOUNT"].ToString());
            string date = ServerDateCurrentdate.ToString("dd/MM/yyyy");
            string pmail = "hr@vyshnavi.in";
            string milktype = "Salary";
            string plcode = dr["employecode"].ToString();
            int bankid = Convert.ToInt16(dr["bankid"].ToString());
            string mobile = dr["mobileno"].ToString();
            string accountnu = ddl_kotack.SelectedItem.Value;
            string companyname = "Vyshnavi Dairy";
            string pay = "RPAY";

            if (bankid == 8)
            {
                paymode = "IFT";
            }
            if (bankid != 8)
            {
                if (NetAmount > 200000)
                {
                    paymode = "RTGS";
                }
                else
                {
                    paymode = "NEFT";
                }
            }
            if ((accountnu == "425044000438") || (accountnu == "328044039913") || (accountnu == "334044049195") || (accountnu == "337044040029"))
            {
                ptype = "SVDSPL";
            }
            if (accountnu == "334044032411")
            {
                ptype = "SVDPL";
            }

            DateTime dtt = new DateTime();
            dtt = System.DateTime.Now;
            string condate = dtt.ToString("dd/MM/yyyy");
           // string[] SPP = 
            string LOCALPLANT = ddlbranch.SelectedItem.Text;
            statement = ptype + "~" + pay + "~" + paymode + "~~" + condate + "~" + accountnu + "~" + NetAmount + "~~" + Agent_Name + "~" + Ifsccode + "~" + Account_no + "~" + pmail + "~" + mobile + "~" + LOCALPLANT + getagentid + "~" + companyname + "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
            showreport.Rows.Add(statement);
        }

        if (showreport.Rows.Count > 0)
        {
            GridView9.DataSource = showreport;
            GridView9.DataBind();
        }
        // Agent_Id, Agent_Name, Ifsccode, Account_no, NetAmount, Date, Pmail, Milktype, Plant_Code,  Bank_Id, phone_Number
       // con = dbaccess.GetConnection();
        //   string getquery = "select Agent_Id,Agent_Name,Ifsccode,Account_no,convert(decimal(18,0),floor(NetAmount)) as NetAmount,Date,Pmail,Milktype,Plant_Code,Bank_Id   from (select  Agent_Id,Agent_Name,Ifsccode,Account_no,NetAmount,Plant_Code,convert(varchar,Added_Date,103) as Date,Bank_id    from BankPaymentllotment  where plant_code='" + pcode + "'   and    Billfrmdate='" + d1 + "'  and Billtodate='" + d2 + "' AND  BankFileName='" + ddl_filename.SelectedItem.Text + "'  and NetAmount > 0) as ff  left join (Select pmail,Milktype,Plant_Code as pcode   from Plant_Master   where plant_code='" + pcode + "' ) as pm on ff.Plant_Code= pm.pcode  order by Date asc";
        //  string getquery = "sELECT Agent_Id,Agent_Name,Ifsccode,Account_no,convert(decimal(18,0),floor(NetAmount)) as NetAmount,Date,Pmail,Milktype,Plant_Code,Bank_Id,phone_Number  FROM (select Agent_Id,Agent_Name,Ifsccode,Account_no,convert(decimal(18,0),floor(NetAmount)) as NetAmount,Date,Pmail,Milktype,Plant_Code,Bank_Id   from (select  Agent_Id,Agent_Name,Ifsccode,Account_no,NetAmount,Plant_Code,convert(varchar,Added_Date,103) as Date,Bank_id    from BankPaymentllotment  where plant_code='" + pcode + "'   and    Billfrmdate='" + d1 + "'  and Billtodate='" + d2 + "' AND  BankFileName='" + ddl_filename.SelectedItem.Text + "'  and NetAmount > 0) as ff  left join (Select pmail,Milktype,Plant_Code as pcode   from Plant_Master   where plant_code='" + pcode + "' ) as pm on ff.Plant_Code= pm.pcode   ) AS FF  LEFT JOIN (sELECT Plant_code AS amplantcode,Agent_Id as agent,phone_Number   FROM Agent_Master   WHERE plant_code='" + pcode + "' GROUP BY Plant_code,Agent_Id,phone_Number)  AS AM ON FF.Plant_Code=AM.amplantcode   and FF.Agent_Id=AM.agent";
    }
    protected void btn_kotack_Click(object sender, EventArgs e)
    {
        GridView9.Visible = true;
        getbankdeatils();
       // getgetbankpayandexcessamt();
        lbl_totamt.Visible = true;
        lbl_totamt.Enabled = false;
    }


    public void getgetbankpayandexcessamt()
    {

        DateTime dt1 = new DateTime();
        DateTime dt2 = new DateTime();
        dt1 = DateTime.ParseExact(txt_FromDate.Text, "dd/MM/yyyy", null);
        dt2 = DateTime.ParseExact(txt_ToDate.Text, "dd/MM/yyyy", null);
        string d1 = dt1.ToString("MM/dd/yyyy");
        string d2 = dt2.ToString("MM/dd/yyyy");

        string str = "";
        str = "Select    NetAmount,ExcessAmt    from (Select   convert(varchar,Sum(NetAmount)) as  NetAmount  , convert(varchar,Sum(Exx)) as ExcessAmt  from (Select   Agent_Id,Agent_Name,Ifsccode,Account_no,convert(decimal(18,0),(floor(NetAmount)))  as NetAmount,Date,Pmail,Milktype,Plant_Code,Bank_Id,phone_Number,(ISNULL(ExcessAmt,0)) as Exx  from (sELECT Agent_Id,Agent_Name,Ifsccode,Account_no,convert(decimal(18,0),floor(NetAmount)) as NetAmount,Date,Pmail,Milktype,Plant_Code,Bank_Id,phone_Number  FROM (select Agent_Id,Agent_Name,Ifsccode,Account_no,convert(decimal(18,0),floor(NetAmount)) as NetAmount,Date,Pmail,Milktype,Plant_Code,Bank_Id   from (select  Agent_Id,Agent_Name,Ifsccode,Account_no,NetAmount,Plant_Code,convert(varchar,Added_Date,103) as Date,Bank_id    from BankPaymentllotment  where plant_code='" + pcode + "'   and    Billfrmdate='" + d1 + "'  and Billtodate='" + d2 + "' AND  BankFileName='" + ddl_filename.SelectedItem.Text + "'  and NetAmount > 0) as ff  left join (Select pmail,Milktype,Plant_Code as pcode   from Plant_Master   where plant_code='" + pcode + "' ) as pm on ff.Plant_Code= pm.pcode   ) AS FF  LEFT JOIN (sELECT Plant_code AS amplantcode,Agent_Id as agent,phone_Number   FROM Agent_Master   WHERE plant_code='" + pcode + "' GROUP BY Plant_code,Agent_Id,phone_Number)  AS AM ON FF.Plant_Code=AM.amplantcode   and FF.Agent_Id=AM.agent) as lleft left join (sELECT  Agent_id as exAgentid ,floor(isnull(sUM(TotAmount),0)) AS ExcessAmt   FROM AgentExcesAmount     WHERE Plant_code='" + pcode + "'  AND Frm_date='" + d1 + "'    AND To_date='" + d2 + "'   group by Agent_id) as agentexpay  on lleft.Agent_Id=agentexpay.exAgentid) as spl) as  ff";
        SqlCommand cmd = new SqlCommand(str, con);
        SqlDataAdapter dsp = new SqlDataAdapter(cmd);
        DataTable milkandexcess = new DataTable();
        dsp.Fill(milkandexcess);
        if (milkandexcess.Rows.Count > 0)
        {
            milkpayamt = Convert.ToDouble(milkandexcess.Rows[0][0]);
            excesspayamt = Convert.ToDouble(milkandexcess.Rows[0][1]);
            lbl_totamt.Text = "Milk Amount:" + milkpayamt + " Excess Amount:" + excesspayamt + " Total Amount:" + (milkpayamt + excesspayamt).ToString();
        }

    }

    public void ExportGridToText12()
    {

        string txt = string.Empty;

        foreach (GridViewRow row in GridView9.Rows)
        {
            //Making the space beween cells.
            foreach (TableCell cell in row.Cells)
            {
                txt += cell.Text;
            }

            txt += "\r\n";
        }

        Response.Clear();
        Response.Buffer = true;
        //here you can give the name of file.

        //string FileName = pcode + txt_FromDate.Text + txt_ToDate.Text + DateTime.Now + ".txt";
        //Response.AddHeader("content-disposition", "attachment;filename=Vithal_Wadje.txt");
        //Response.AddHeader("content-disposition", "attachment;" + FileName);

        DateTime dt = new DateTime();
        dt = System.DateTime.Now;
        string DATEE = dt.ToString("ddMMyy");
        string timee = String.Format("{0:d/M/yyyy HH:mm:ss}", dt);
        string NAME = ddl_filename.Text + DATEE + ".txt";
        Response.AddHeader("content-disposition", "attachment;filename= '" + NAME + "'");
        Response.Charset = "";
        Response.ContentType = "application/text";
        Response.Output.Write(txt);
        //FileStream fs = File.Create(txt);
        //File.SetAttributes(txt+".txt",FileAttributes.ReadOnly);
        Response.Flush();
        getupdatefilelock();
        Response.End();


    }
    protected void btn_kotackexport_Click(object sender, EventArgs e)
    {
       
        GETUPDATE();
        if (GETID == 0)
        {
            ExportGridToText12();
            //  getupdatefilelock();

        }
        else
        {
          //  WebMsgBox.Show("File Already Updated");


        }
    }
    protected void rbtLstReportItems_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtLstReportItems.SelectedItem.Value == "8")
        {
            btn_kotack.Visible = true;
            btn_kotackexport.Visible = true;
            GridView9.Visible = true;
            lbl_ktk.Visible = true;
            ddl_kotack.Visible = true;
        }
        else
        {
            btn_kotack.Visible = false;
            btn_kotackexport.Visible = false;
            GridView9.Visible = false;
            ddl_kotack.Visible = false;
            lbl_ktk.Visible = false;
            GridView9.DataSource = null;
            GridView9.DataBind();
        }
    }
    protected void ddl_filename_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridView9.Visible = false;
    }
    protected void ddl_filename_TextChanged(object sender, EventArgs e)
    {

    }
}