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
using System.Xml;
public partial class bankfileformatreport : System.Web.UI.Page
{
    DBManager vdm;
    string userid = "";
    SqlCommand cmd;
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
                    DateTime dtyear = DateTime.Now.AddYears(0);
                    bindbranchs();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    ddlmonth.SelectedValue = str[1];
                    string fryear = dtyear.ToString("dd/MM/yyyy");
                    string[] str1 = fryear.Split('/');
                    year1.SelectedValue = str1[2];
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
    private void bindbranchs()
    {

        DBManager SalesDB = new DBManager();
        //branchwise
        //cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='1'");
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
    protected void RadioButton_CheckedChanged(object sender, EventArgs e)
    {
        string text = rbtLstReportItems.SelectedItem.Text;
        if (text == "Hdfcoth")
        {
            Lbl_selectedReportItem.Text = "HDFC Bank";
        }
        else{
            Lbl_selectedReportItem.Text = rbtLstReportItems.SelectedItem.Value;
        }
        string bankname = Lbl_selectedReportItem.Text;
        DBManager SalesDB = new DBManager();
        string mainbranch = Session["mainbranch"].ToString();
        cmd = new SqlCommand("SELECT sno, accountno, ifsccode, branchname, bankname, bankid FROM accountno_details WHERE (bankname = @bankname)");
        cmd.Parameters.Add("@bankname", bankname);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        Slect_account.DataSource = dttrips;
        Slect_account.DataTextField = "accountno";
        Slect_account.DataValueField = "sno";
        Slect_account.DataBind();
        Slect_account.ClearSelection();
        Slect_account.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Account--", Selected = true });
        Slect_account.SelectedValue = "0";
    }







    DataTable Report = new DataTable();
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT filename, branchid, month, year, doe, status, userid FROM bankformatmaster WHERE (month = @month) AND (year = @year) AND (branchid = @branchid) GROUP BY filename, branchid, month, year, doe, status, userid");
        cmd.Parameters.Add("@branchid", ddlbranch.SelectedValue);
        cmd.Parameters.Add("@month", ddlmonth.SelectedValue);
        cmd.Parameters.Add("@year", year1.SelectedValue);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddl_filenames.DataSource = dttrips;
        ddl_filenames.DataTextField = "filename";
        ddl_filenames.DataBind();
        ddl_filenames.ClearSelection();
        ddl_filenames.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        ddl_filenames.SelectedValue = "0";
       
    }

    protected void ddl_filenames_SelectedIndexChanged1(object sender, EventArgs e)
    {
        LoadHdfc1();
        //DataTable dt = new DataTable();
        //int c = 0;
        //try
        //{
        //    SqlDataAdapter da = new SqlDataAdapter();
        //    DateTime dt1 = new DateTime();
        //    DateTime dt2 = new DateTime();
        //    string d1 = dt1.ToString("MM/dd/yyyy");
        //    string d2 = dt2.ToString("MM/dd/yyyy");
        //    SqlCommand sqlCmd = new SqlCommand("SELECT  SBFM.empname as EMPNAME, 'C' as C, SBFM.bankaccountno as ACCOUNT,SBFM.netpay as NETPAY , BM.bankname as NARRATION, SBFM.ifsccode as IFSCCode, SBFM.mobileno as EMPMOBILENO FROM bankformatmaster AS BFM INNER JOIN  subbankformatmaster AS SBFM ON BFM.sno = SBFM.refno INNER JOIN bankmaster AS BM ON SBFM.bankid = BM.sno WHERE (BFM.month = @month) AND (BFM.year = @year) AND (BFM.branchid = @branchid) AND (BFM.filename = @filename)");
        //    sqlCmd.Parameters.Add("@branchid", ddlbranch.SelectedValue);
        //    sqlCmd.Parameters.Add("@month", ddlmonth.SelectedValue);
        //    sqlCmd.Parameters.Add("@year", year1.SelectedValue);
        //    sqlCmd.Parameters.Add("@filename", ddl_filenames.SelectedItem.Text);
        //    DataTable dtcompany = vdm.SelectQuery(sqlCmd).Tables[0];
        //    da = new SqlDataAdapter(sqlCmd);
        //    // Fill the DataTable with data from SQL Server table.
        //    da.Fill(dt);
        //    c = dt.Rows.Count;
        //    if (dt.Rows.Count > 0)
        //    {
        //        grdReports.DataSource = dt;
        //        grdReports.DataBind();
        //    }
        //    else
        //    {
        //        grdReports.DataSource = null;
        //        grdReports.DataBind();
        //    }
        //    //}
        //    //return c;
        //}
        //catch
        //{
        //    //return c;
        //}
    }


    
    protected void btn_Submit_Click(object sender, EventArgs e)
    {
        try
        {
            if (rbtLstReportItems.SelectedItem != null)
            {
                Lbl_selectedReportItem.Text = rbtLstReportItems.SelectedItem.Text;
                if (Lbl_selectedReportItem.Text == "WSbi")
                {
                    ExportGridToText();
                }
                else if (Lbl_selectedReportItem.Text == "Sbi")
                {
                    ExportGridToTextSBIPaymentAllotmentList();
                }
                else if (Lbl_selectedReportItem.Text == "Ing")
                {
                    Ing();
                }

                else if (Lbl_selectedReportItem.Text == "Hdfc")  //working
                {
                    HdfcExportGridTomacroformat();

                }
                else if (Lbl_selectedReportItem.Text == "Hdfcoth") //working
                {
                    OthersToHdfcExportGridTomacroformat();
                    HdfcExcel();
                }
                else if (Lbl_selectedReportItem.Text == "Kotack Mahindra")
                {
                    getbankdeatils();
                    ExportGridToText12();
                }
                else
                {
                    lblmsg.Text = "Please Check the Selected Items";
                }

            }
            else
            {

                lblmsg.Text = "Please Select the Report Type";
            }

        }
        catch
        {

        }
    }
   
   
    //ING Bankformate
    private void Ing()
    {
        try
        {
            string strDownloadFileName = "";
            string strExcelConn = "";
            strDownloadFileName = @"C:/BILL VYSHNAVI/" + "INGBulkFileUpload" + ".xls";
            string MFileName = @"C:/BILL VYSHNAVI/" + "INGBulkFileUpload" + ".xls";
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


    protected DataTable RetrieveData1()
    {
        DataTable dt = new DataTable();
        try
        {
            SqlDataAdapter da = new SqlDataAdapter();
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            SqlCommand sqlCmd = new SqlCommand("SELECT  SBFM.empname as BeneficiaryName, BM.bankname as BeneficiaryBankName,SBFM.bankaccountno as AccountNo,BM.bankname  AS BeneficiaryAccountType,SBFM.ifsccode AS IFSCCode, SBFM.netpay as Amount, BM.bankname AS SendertoReceiverInfo ,SBFM.empid AS OwnReferenceNumber,BM.bankname AS Remarks, SBFM.mobileno AS BeneficiaryMobileno FROM bankformatmaster AS BFM INNER JOIN  subbankformatmaster AS SBFM ON BFM.sno = SBFM.refno INNER JOIN bankmaster AS BM ON SBFM.bankid = BM.sno WHERE (BFM.month = @month) AND (BFM.year = @year) AND (BFM.branchid = @branchid) AND (BFM.filename = @filename)  ");
            sqlCmd.Parameters.Add("@branchid", ddlbranch.SelectedValue);
            sqlCmd.Parameters.Add("@month", ddlmonth.SelectedValue);
            sqlCmd.Parameters.Add("@year", year1.SelectedValue);
            sqlCmd.Parameters.Add("@filename", ddl_filenames.SelectedItem.Text);
            DataTable dtcompany = vdm.SelectQuery(sqlCmd).Tables[0];
            SqlDataAdapter sqlDa = new SqlDataAdapter(sqlCmd);
            string accountnu = Slect_account.SelectedItem.Text;
            sqlDa.Fill(dt);
            if ( accountnu != "--Select Account--")
            {
            dt.Columns.Add("OwnAccountNumber");
            
            foreach (DataRow row in dt.Rows)
            {
                row["OwnAccountNumber"] = accountnu;

            }
          
            }
            return dt;
        }
        catch (Exception ex)
        {
            return dt;
        }
    }

    //public void LoadINGListGrid()
    //{

    //    try
    //    {
    //        DateTime dt1 = new DateTime();
    //        DateTime dt2 = new DateTime();
    //        DateTime dt3 = new DateTime();
    //        string d1 = dt1.ToString("MM/dd/yyyy");
    //        string d2 = dt2.ToString("MM/dd/yyyy");
    //        string d3 = dt3.ToString("MM/dd/yyyy");
    //        //string connStr = ConfigurationManager.ConnectionStrings["AMPSConnectionString"].ConnectionString;
    //        //using (SqlConnection conn = new SqlConnection(connStr))
    //        //{
    //        //    conn.Open();

    //        SqlCommand sqlCmd = new SqlCommand("SELECT  SBFM.empname as BeneficiaryName, BM.bankname as BeneficiaryBankName,SBFM.bankaccountno as AccountNo,BM.bankname  AS BeneficiaryAccountType,SBFM.ifsccode AS IFSCCode, SBFM.netpay as NetAmount, BM.bankname AS SendertoReceiverInfo ,SBFM.empid AS OwnReferenceNumber,BM.bankname AS Remarks FROM bankformatmaster AS BFM INNER JOIN  subbankformatmaster AS SBFM ON BFM.sno = SBFM.refno INNER JOIN bankmaster AS BM ON SBFM.bankid = BM.sno WHERE (BFM.month = @month) AND (BFM.year = @year) AND (BFM.branchid = @branchid) AND (BFM.filename = @filename)  ");
    //        sqlCmd.Parameters.Add("@branchid", ddlbranch.SelectedValue);
    //        sqlCmd.Parameters.Add("@month", ddlmonth.SelectedValue);
    //        sqlCmd.Parameters.Add("@year", year1.SelectedValue);
    //        sqlCmd.Parameters.Add("@filename", ddl_filenames.SelectedItem.Text);
    //        DataTable dtcompany = vdm.SelectQuery(sqlCmd).Tables[0];
    //        //SqlCommand cmd = new SqlCommand(sqlstr, conn);
    //        DataTable dt = new DataTable();
    //        SqlDataAdapter sqlDa = new SqlDataAdapter(sqlCmd);
    //        sqlDa.Fill(dt);
    //        if (dt.Rows.Count > 0)
    //        {
    //            GridView3.DataSource = dt;
    //            GridView3.DataBind();
    //        }
    //        else
    //        {
    //            GridView3.DataSource = null;
    //            GridView3.DataBind();
    //        }
    //        //}
    //    }
    //    catch
    //    {

    //    }
    //}

    protected void ExportToExcel(string strConn, System.Data.DataTable dtSQL)
    {
        try
        {
            using (OleDbConnection conn = new OleDbConnection(strConn))
            {
                // Create a new sheet in the Excel spreadsheet.
                OleDbCommand cmd = new OleDbCommand("create table INGBULK(BeneficiaryName  Varchar(28),BeneficiaryBankName Varchar(80),AccountNo Varchar(25),BeneficiaryAccountType Varchar(10),IFSCCode Varchar(15),Amount Double,SendertoReceiverInfo Varchar(60),BeneficiaryMobileno Varchar(25),OwnReferenceNumber Varchar(20),Remarks Varchar(80),OwnAccountNumber Varchar(20))", conn);

                // Open the connection.
                conn.Open();

                // Execute the OleDbCommand.
                cmd.ExecuteNonQuery();

                cmd.CommandText = "INSERT INTO INGBULK (BeneficiaryName,BeneficiaryBankName,AccountNo,BeneficiaryAccountType,IFSCCode,Amount,SendertoReceiverInfo,BeneficiaryMobileno,OwnReferenceNumber,Remarks) values (?,?,?,?,?,?,?,?,?,?)";
              
                // Add the parameters.
                cmd.Parameters.Add("BeneficiaryName", OleDbType.VarChar, 28, "BeneficiaryName");
                cmd.Parameters.Add("BeneficiaryBankName", OleDbType.VarChar, 80, "BeneficiaryBankName");
                cmd.Parameters.Add("AccountNo", OleDbType.VarChar, 25, "AccountNo");
                cmd.Parameters.Add("BeneficiaryAccountType", OleDbType.VarChar, 10, "BeneficiaryAccountType");
                cmd.Parameters.Add("IFSCCode", OleDbType.VarChar, 15, "IFSCCode");
                cmd.Parameters.Add("Amount", OleDbType.Double, 8, "Amount");
                cmd.Parameters.Add("SendertoReceiverInfo", OleDbType.VarChar, 60, "SendertoReceiverInfo");
                cmd.Parameters.Add("BeneficiaryMobileno", OleDbType.VarChar, 25, "BeneficiaryMobileno");
                cmd.Parameters.Add("OwnReferenceNumber", OleDbType.VarChar, 20, "OwnReferenceNumber");
                cmd.Parameters.Add("Remarks", OleDbType.VarChar, 20, "Remarks");
                cmd.Parameters.Add("OwnAccountNumber", OleDbType.VarChar, 20, "OwnAccountNumber");
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

    //....................ING END..........................//
    //HDFC TO HDFC Bankformate

    private void HdfcExportGridTomacroformat()
    {
        int cc = 0;
        string branch = ddlbranch.SelectedItem.Value;
        cc = LoadHdfc();
            //LoadformatGrid();
        Response.Clear();
        Response.Buffer = true;

        string dat, mon;
        dat = System.DateTime.Now.ToString("dd");
        mon = System.DateTime.Now.ToString("MM");
        string fname = dat + mon;
        string filename = "SVD2H" + fname + "";
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
        Response.AddHeader("content-disposition", "attachment;filename=" + filename + "." + rowcount);
        Response.Charset = "";
        Response.ContentType = "application/text";
        GridView4.AllowPaging = false;
        GridView4.DataBind();
        StringBuilder Rowbind = new StringBuilder();


        int L = GridView4.Columns.Count;
        int M = 1;
        for (int k = 0; k < GridView4.Columns.Count; k++)
        {
            if (M == L)
            {
                Rowbind.Append(GridView4.Columns[k].HeaderText);
            }
            else
            {
                Rowbind.Append(GridView4.Columns[k].HeaderText + ',');
            }
            M++;

        }
        Rowbind.Append("\r\n");


        for (int i = 0; i < GridView4.Rows.Count; i++)
        {
            int s = GridView4.Columns.Count;
            int j = 1;
            for (int k = 0; k < GridView4.Columns.Count; k++)
            {
                if (j == s)
                {
                    Rowbind.Append(GridView4.Rows[i].Cells[k].Text);
                }
                else
                {
                    Rowbind.Append(GridView4.Rows[i].Cells[k].Text + ',');
                }
                j++;

            }

            Rowbind.Append("\r\n");
        }
        Response.Output.Write(Rowbind.ToString());
        Response.Flush();
        Response.End();

    }

    public int LoadHdfc()
    {
        DataTable dt = new DataTable();
        int c = 0;
        try
        {
            SqlDataAdapter da = new SqlDataAdapter();
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            SqlCommand sqlCmd = new SqlCommand("SELECT  SBFM.bankaccountno as ACCOUNT,'C' as C, SBFM.netpay as NETPAY , BM.bankname as NARRATION FROM bankformatmaster AS BFM INNER JOIN  subbankformatmaster AS SBFM ON BFM.sno = SBFM.refno INNER JOIN bankmaster AS BM ON SBFM.bankid = BM.sno WHERE (BFM.month = @month) AND (BFM.year = @year) AND (BFM.branchid = @branchid) AND (BFM.filename = @filename)");
            sqlCmd.Parameters.Add("@branchid", ddlbranch.SelectedValue);
            sqlCmd.Parameters.Add("@month", ddlmonth.SelectedValue);
            sqlCmd.Parameters.Add("@year", year1.SelectedValue);
            sqlCmd.Parameters.Add("@filename", ddl_filenames.SelectedItem.Text);
            DataTable dtcompany = vdm.SelectQuery(sqlCmd).Tables[0];
            da = new SqlDataAdapter(sqlCmd);
            // Fill the DataTable with data from SQL Server table.
            da.Fill(dt);
            c = dt.Rows.Count;
            if (dt.Rows.Count > 0)
            {
                GridView4.DataSource = dt;
                GridView4.DataBind();
            }
            else
            {
                GridView4.DataSource = null;
                GridView4.DataBind();
            }
            //}
            return c;
        }
        catch
        {
            return c;
        }
    }
    public void LoadHdfc1()
    {
        DataTable dt = new DataTable();
        int c = 0;
        try
        {
            SqlDataAdapter da = new SqlDataAdapter();
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            SqlCommand sqlCmd = new SqlCommand("SELECT  SBFM.bankaccountno as ACCOUNT,'C' as C, SBFM.netpay as NETPAY , BM.bankname as NARRATION FROM bankformatmaster AS BFM INNER JOIN  subbankformatmaster AS SBFM ON BFM.sno = SBFM.refno INNER JOIN bankmaster AS BM ON SBFM.bankid = BM.sno WHERE (BFM.month = @month) AND (BFM.year = @year) AND (BFM.branchid = @branchid) AND (BFM.filename = @filename)");
            sqlCmd.Parameters.Add("@branchid", ddlbranch.SelectedValue);
            sqlCmd.Parameters.Add("@month", ddlmonth.SelectedValue);
            sqlCmd.Parameters.Add("@year", year1.SelectedValue);
            sqlCmd.Parameters.Add("@filename", ddl_filenames.SelectedItem.Text);
            DataTable dtcompany = vdm.SelectQuery(sqlCmd).Tables[0];
            da = new SqlDataAdapter(sqlCmd);
            // Fill the DataTable with data from SQL Server table.
            da.Fill(dt);
            c = dt.Rows.Count;
            if (dt.Rows.Count > 0)
            {
                GridView4.DataSource = dt;
                GridView4.DataBind();
            }
            else
            {
                GridView4.DataSource = null;
                GridView4.DataBind();
            }
            //}
           // return c;
        }
        catch
        {
           // return c;
        }
    }

    public int LoadformatGrid()
    {
        DataTable dt = new DataTable();
        int c = 0;
        try
        {

            SqlDataAdapter da = new SqlDataAdapter();
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            string salarypay = "Salarypay";
            //string mymonth = ddl_filenames.SelectedItem.Text;
            //using (SqlConnection conn = new SqlConnection(connStr))
            //{
            SqlCommand sqlCmd = new SqlCommand("SELECT  SBFM.empname as EMPNAME,  SBFM.bankaccountno as ACCOUNT,SBFM.netpay as NETPAY , BM.bankname as NARRATION, SBFM.mobileno as EMPMOBILENO, SBFM.ifsccode as IFSCCode FROM bankformatmaster AS BFM INNER JOIN  subbankformatmaster AS SBFM ON BFM.sno = SBFM.refno INNER JOIN bankmaster AS BM ON SBFM.bankid = BM.sno WHERE (BFM.month = @month) AND (BFM.year = @year) AND (BFM.branchid = @branchid) AND (BFM.filename = @filename)");
            sqlCmd.Parameters.Add("@branchid", ddlbranch.SelectedValue);
            sqlCmd.Parameters.Add("@month", ddlmonth.SelectedValue);
            sqlCmd.Parameters.Add("@year", year1.SelectedValue);
            sqlCmd.Parameters.Add("@filename", ddl_filenames.SelectedItem.Text);
            DataTable dtcompany = vdm.SelectQuery(sqlCmd).Tables[0];
            da = new SqlDataAdapter(sqlCmd);
            string accountnu = Slect_account.SelectedItem.Text;
            dt.Columns.Add("CompanyAccountNumber");
            // Fill the DataTable with data from SQL Server table.
            da.Fill(dt);
            
            DataRow accountno = dt.NewRow();
            foreach (DataRow row in dt.Rows)
            {
                row["CompanyAccountNumber"] = accountnu;

            }
            c = dt.Rows.Count;
            if (dt.Rows.Count > 0)
            {
                GridView4.DataSource = dt;
                GridView4.DataBind();
            }
            else
            {
                GridView4.DataSource = null;
                GridView4.DataBind();
            }

            return c;
        }
        catch
        {
            return c;
        }
    }
    //........................END HDFC....................//
    // SBI another formate 
    private void ExportGridToText()
    {
        string branch = ddlbranch.SelectedItem.Value;
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
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            //string connStr = ConfigurationManager.ConnectionStrings["AMPSConnectionString"].ConnectionString;
            //using (SqlConnection conn = new SqlConnection(connStr))
            //{
            //    conn.Open();

                //string sqlstr = "Select Agent_Name,Account_no,(Company_Code-Company_Code) AS Standard from BankPaymentllotment WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "' AND billfrmdate='" + d1 + "' AND billtodate='" + d2 + "' AND Added_date='" + d3 + "'";
                //string sqlstr = "Select UPPER(REPLACE(AgentName,'.',' ')) AS Agent_Name ,Account_no,(Pm.plant_code-Pm.plant_code) AS Standard,Ifsccode,NetAmount,PStatus,agent_id,Bank_Id,BankName,Pm.Pmail AS Pmail from (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName,Bank_Id,Bd.Bankname AS BankName,plant_code from (SELECT agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName AS AgentName,Bank_Id,plant_code FROM (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,plant_code from BankPaymentllotment WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "' AND billfrmdate='" + d1 + "' AND billtodate='" + d2 + "' AND BankFileName='" + d3 + "' ) AS Bp LEFT JOIN  (SELECT Agent_Id AS Aid,Agent_Name AS AgentName,Bank_Id FROM Agent_Master WHERE  Company_code='" + ccode + "' AND Plant_code='" + pcode + "' ) AS Am ON bp.agent_id=Am.Aid ) AS t1 INNER JOIN  (Select Bank_id AS Bid,Bank_Name AS Bankname from Bank_Details WHERE Company_code='" + ccode + "' AND Bank_id='33') AS Bd ON t1.Bank_Id=Bd.Bid ) AS t2 LEFT JOIN  (Select plant_code,pmail from Plant_Master WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "') AS Pm ON t2.plant_code=Pm.Plant_Code ORDER BY t2.agent_id";
                //string sqlstr1 = "Select Account_no,NetAmount,CONVERT( NVARCHAR(40),Adate,103) AS Adate,NetAmount,agent_id,REPLACE(AgentName,AgentName,'Bms milk pay') AS Standards from (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName,Bank_Id,Bd.Bankname AS BankName,plant_code,Adate from (SELECT agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName AS AgentName,Bank_Id,plant_code,Added_Date AS Adate FROM (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,plant_code,Added_Date from BankPaymentllotment WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "' AND billfrmdate='" + d1 + "' AND billtodate='" + d2 + "' AND Added_date='" + d3 + "' ) AS Bp LEFT JOIN  (SELECT Agent_Id AS Aid,Agent_Name AS AgentName,Bank_Id FROM Agent_Master WHERE  Company_code='" + ccode + "' AND Plant_code='" + pcode + "' ) AS Am ON bp.agent_id=Am.Aid ) AS t1 INNER JOIN  (Select Bank_id AS Bid,Bank_Name AS Bankname from Bank_Details WHERE Company_code='" + ccode + "' AND Bank_id='33') AS Bd ON t1.Bank_Id=Bd.Bid ) AS t2 LEFT JOIN  (Select plant_code,pmail from Plant_Master WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "') AS Pm ON t2.plant_code=Pm.Plant_Code ORDER BY t2.agent_id";

                //SqlCommand cmd = new SqlCommand(sqlstr, conn);
                SqlCommand sqlCmd = new SqlCommand("SELECT  SBFM.empname as Name,SBFM.bankaccountno as Accountno,SBFM.branchid as Standard,SBFM.netpay as NetAmount,SBFM.ifsccode AS IFSCCode ,SBFM.empid AS OwnReferenceNumber,BM.bankname AS Remarks, SBFM.mobileno FROM bankformatmaster AS BFM INNER JOIN  subbankformatmaster AS SBFM ON BFM.sno = SBFM.refno INNER JOIN bankmaster AS BM ON SBFM.bankid = BM.sno WHERE (BFM.month = @month) AND (BFM.year = @year) AND (BFM.branchid = @branchid) AND (BFM.filename = @filename)  ");
                sqlCmd.Parameters.Add("@branchid", ddlbranch.SelectedValue);
                sqlCmd.Parameters.Add("@month", ddlmonth.SelectedValue);
                sqlCmd.Parameters.Add("@year", year1.SelectedValue);
                sqlCmd.Parameters.Add("@filename", ddl_filenames.SelectedItem.Text);
                DataTable dtcompany = vdm.SelectQuery(sqlCmd).Tables[0];
                DataTable dt = new DataTable();
                SqlDataAdapter sqlDa = new SqlDataAdapter(sqlCmd);
                sqlDa.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    GridView1.DataSource = dt;
                    GridView1.DataBind();
                }
                else
                {
                    GridView1.DataSource = null;
                    GridView1.DataBind();
                }
            //}
        }
        catch
        {

        }
    }

    //.................END but not in use..............//
    //SBI Bankformate

    private void ExportGridToTextSBIPaymentAllotmentList()
    {
       string branch = ddlbranch.SelectedItem.Value;
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
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");

            //string connStr = ConfigurationManager.ConnectionStrings["AMPSConnectionString"].ConnectionString;
            //using (SqlConnection conn = new SqlConnection(connStr))
            //{
            //    conn.Open();

                //string sqlstr = "Select Account_no,CAST(NetAmount AS DECIMAL(18,0)) AS NetAmount,CONVERT( NVARCHAR(40),Adate,103) AS Adate,CAST(NetAmount AS DECIMAL(18,0)) AS NetAmount,agent_id,REPLACE(AgentName,AgentName,'Bms milk pay') AS Standards from (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName,Bank_Id,Bd.Bankname AS BankName,plant_code,Adate from (SELECT agent_id,Account_no,Ifsccode,NetAmount,PStatus,AgentName AS AgentName,Bank_Id,plant_code,Added_Date AS Adate FROM (Select agent_id,Account_no,Ifsccode,NetAmount,PStatus,plant_code,Added_Date from BankPaymentllotment WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "' AND billfrmdate='" + d1 + "' AND billtodate='" + d2 + "' AND BankFileName='" + d3 + "' ) AS Bp LEFT JOIN  (SELECT Agent_Id AS Aid,Agent_Name AS AgentName,Bank_Id FROM Agent_Master WHERE  Company_code='" + ccode + "' AND Plant_code='" + pcode + "' ) AS Am ON bp.agent_id=Am.Aid ) AS t1 INNER JOIN  (Select Bank_id AS Bid,Bank_Name AS Bankname from Bank_Details WHERE Company_code='" + ccode + "' AND Bank_id='33') AS Bd ON t1.Bank_Id=Bd.Bid ) AS t2 LEFT JOIN  (Select plant_code,pmail from Plant_Master WHERE Company_Code='" + ccode + "' AND Plant_Code='" + pcode + "') AS Pm ON t2.plant_code=Pm.Plant_Code ORDER BY t2.agent_id";
            SqlCommand sqlCmd = new SqlCommand("SELECT SBFM.bankaccountno as Accountno,SBFM.netpay as NetAmount, SBFM.empid as EMPID,SBFM.empname as Standards,SBFM.ifsccode AS IFSCCode ,SBFM.empid AS OwnReferenceNumber,BM.bankname AS Remarks,SBFM.mobileno AS EMPMOBILENO FROM bankformatmaster AS BFM INNER JOIN  subbankformatmaster AS SBFM ON BFM.sno = SBFM.refno INNER JOIN bankmaster AS BM ON SBFM.bankid = BM.sno WHERE (BFM.month = @month) AND (BFM.year = @year) AND (BFM.branchid = @branchid) AND (BFM.filename = @filename)  ");
                sqlCmd.Parameters.Add("@branchid", ddlbranch.SelectedValue);
                sqlCmd.Parameters.Add("@month", ddlmonth.SelectedValue);
                sqlCmd.Parameters.Add("@year", year1.SelectedValue);
                sqlCmd.Parameters.Add("@filename", ddl_filenames.SelectedItem.Text);
                DataTable dtcompany = vdm.SelectQuery(sqlCmd).Tables[0];
                //SqlCommand cmd = new SqlCommand(sqlstr, conn);
                DataTable dt = new DataTable();
                SqlDataAdapter sqlDa = new SqlDataAdapter(sqlCmd);

                string accountnu = Slect_account.SelectedItem.Text;
                dt.Columns.Add("CompanyAccountNumber");
                sqlDa.Fill(dt);
                foreach (DataRow row in dt.Rows)
                {
                    row["CompanyAccountNumber"] = accountnu;

                }
               
                if (dt.Rows.Count > 0)
                {
                    GridView2.DataSource = dt;
                    GridView2.DataBind();
                }
                else
                {
                    GridView2.DataSource = null;
                    GridView2.DataBind();
                }
            //}
        }
        catch
        {

        }
    }

    //...........................SBI END..................//
    //.....HDFC TO Others Bankfile Formate
    private void OthersToHdfcExportGridTomacroformat()
    {
        int cc = 0;
       string branch = ddlbranch.SelectedItem.Value;
       cc = LoadOthersToHDFCmacroformatGrid();
        Response.Clear();
        Response.Buffer = true;

        string dat, mon;
        string S = "SVD";
        dat = System.DateTime.Now.ToString("dd");
        mon = System.DateTime.Now.ToString("MM");
        string filename = S + dat + mon;
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
        Response.AddHeader("content-disposition", "attachment;filename=" + filename + "." + rowcount);
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
                    Rowbind.Append("N,," + GridView6.Rows[i].Cells[k].Text + ',');
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
                else if (j == 3)
                {
                    Rowbind.Append(GridView6.Rows[i].Cells[k].Text + ',' + ',' + ',' + ',' + ',' + ',' + ',' + ',' + ',');
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

            SqlDataAdapter da = new SqlDataAdapter();
            DataTable dtt = new DataTable();
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            // string d3 = dt3.ToString("MM/dd/yyyy");
            //using (SqlConnection conn = new SqlConnection(connStr))
            //{
            SqlCommand sqlCmd = new SqlCommand("SELECT SBFM.bankaccountno AS ACCOUNT, SBFM.netpay AS AMOUNT,SBFM.empname AS Empname,SBFM.empid AS Empid,SBFM.mobileno as EMPMOBILENO, SBFM.ifsccode AS IFSCCode,BM.bankname AS BankName, SBFM.branchid, company_master.companyname, BFM.doe, SBFM.bankid FROM   bankformatmaster AS BFM INNER JOIN  subbankformatmaster AS SBFM ON BFM.sno = SBFM.refno INNER JOIN   bankmaster AS BM ON SBFM.bankid = BM.sno INNER JOIN company_master ON SBFM.Companyid = company_master.sno WHERE (BFM.month = @month) AND (BFM.year = @year) AND (BFM.branchid = @branchid)  AND (BFM.filename = @filename)  ");
            sqlCmd.Parameters.Add("@branchid", ddlbranch.SelectedValue);
            sqlCmd.Parameters.Add("@month", ddlmonth.SelectedValue);
            sqlCmd.Parameters.Add("@year", year1.SelectedValue);
            sqlCmd.Parameters.Add("@filename", ddl_filenames.SelectedItem.Text);
            DataTable dtcompany = vdm.SelectQuery(sqlCmd).Tables[0];
                da = new SqlDataAdapter(sqlCmd);
                // Fill the DataTable with data from SQL Server table.
                da.Fill(dt);

                c = dt.Rows.Count;
                if (dt.Rows.Count > 0)
                {
                    //dtt.Columns.Add("TranType");
                    dtt.Columns.Add("ACCOUNT");
                    dtt.Columns.Add("AMOUNT");
                    dtt.Columns.Add("Empname");
                    dtt.Columns.Add("Empid");
                    dtt.Columns.Add("EMPMOBILENO");
                    dtt.Columns.Add("IFSCCode");
                    dtt.Columns.Add("BankName");
                    dtt.Columns.Add("ComapnyAccountno");
                    //dtt.Columns.Add("Pmail");
                    foreach (DataRow Drf in dt.Rows)
                    {
                        //string gettrantype = Drf[0].ToString();
                        string ACCOUNT = Drf[0].ToString();
                        //string AMOUNT = Drf[2].ToString();
                        string Empname = Drf[2].ToString();
                        string Empid = Drf[3].ToString();
                        string EMPMOBILENO = Drf[4].ToString();
                        string DOE = Drf[9].ToString();
                        DateTime dtdate = Convert.ToDateTime(DOE);
                        DOE = dtdate.ToString("dd/MM/yyyy");
                        string IfscCode = Drf[5].ToString();
                        string BankName = Drf[6].ToString();
                        string ComapnyAccountno = Slect_account.SelectedItem.Text;
                        //getaddeddetails();
                        //double getamt;
                        double getamount;
                        //try
                        //{
                        //    getamt = Convert.ToDouble(dtaddamount.Rows[0][0]);
                        //}
                        //catch
                        //{
                        //    getamt = 0;

                        //}
                        try
                        {
                            getamount = Convert.ToDouble(Drf[1].ToString());
                        }
                        catch
                        {
                            getamount = 0;
                        }

                        //getamount = getamount + getamt;

                        dtt.Rows.Add(ACCOUNT, getamount, Empname, Empid, EMPMOBILENO, IfscCode, BankName, ComapnyAccountno);
                    }
                    GridView6.DataSource = dtt;
                    GridView6.DataBind();
                }
                else
                {
                    GridView6.DataSource = null;
                    GridView6.DataBind();
                }
            //}
            return c;
        }
        catch
        {
            return c;
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
    protected DataTable RetrieveDataHdfc()
    {
        DataTable dt = new DataTable();
        try
        {
            SqlDataAdapter da = new SqlDataAdapter();
            DateTime dt1 = new DateTime();
            DateTime dt2 = new DateTime();
            //DateTime dt3 = new DateTime();

            // dt3 = DateTime.ParseExact(ddl_Addeddate.SelectedItem.Value, "dd/MM/yyyy", null);

            string d1 = dt1.ToString("MM/dd/yyyy");
            string d2 = dt2.ToString("MM/dd/yyyy");
            //string d3 = dt3.ToString("MM/dd/yyyy");
            //string d3 = ddl_Addeddate.SelectedItem.Value.ToString();
            SqlCommand sqlCmd = new SqlCommand("SELECT  SBFM.empname as EMPNAME,  SBFM.bankaccountno as ACCOUNT,SBFM.netpay as NETPAY , BM.bankname as NARRATION FROM bankformatmaster AS BFM INNER JOIN  subbankformatmaster AS SBFM ON BFM.sno = SBFM.refno INNER JOIN bankmaster AS BM ON SBFM.bankid = BM.sno WHERE (BFM.month = @month) AND (BFM.year = @year) AND (BFM.branchid = @branchid) AND (BFM.filename = @filename)");
            sqlCmd.Parameters.Add("@branchid", ddlbranch.SelectedValue);
            sqlCmd.Parameters.Add("@month", ddlmonth.SelectedValue);
            sqlCmd.Parameters.Add("@year", year1.SelectedValue);
            sqlCmd.Parameters.Add("@filename", ddl_filenames.SelectedItem.Text);
            DataTable dtcompany = vdm.SelectQuery(sqlCmd).Tables[0];
            da = new SqlDataAdapter(sqlCmd);
            // Fill the DataTable with data from SQL Server table.
            da.Fill(dt);
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
                OleDbCommand cmd = new OleDbCommand("create table SALARY(ACCOUNT Varchar(25),EMPNAME  Varchar(28),AMOUNT Double,NARRATION Varchar(100))", conn);

                // Open the connection.
                conn.Open();

                // Execute the OleDbCommand.
                cmd.ExecuteNonQuery();

                cmd.CommandText = "INSERT INTO SALARY(ACCOUNT,EMPNAME,AMOUNT,NARRATION) values (?,?,?,?)";

                //// Add the parameters.
                //// cmd.Parameters.Add("Tid", OleDbType.Integer);  
                cmd.Parameters.Add("ACCOUNT", OleDbType.VarChar, 25, "ACCOUNT");
                cmd.Parameters.Add("EMPNAME", OleDbType.VarChar, 28, "EMPNAME");
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
    //.................END HDFC TO Others Bank File Formate..............//
    //Kotack bankformate 
    public void getbankdeatils()
    {
        DataTable showreport = new DataTable();
        DateTime dt1 = new DateTime();
        DateTime dt2 = new DateTime();
        string paymode;
        string statement;
        string d1 = dt1.ToString("MM/dd/yyyy");
        string d2 = dt2.ToString("MM/dd/yyyy");
        SqlCommand sqlCmd = new SqlCommand("SELECT SBFM.empid AS Empid, SBFM.empname AS Empname, SBFM.ifsccode AS IFSCCode, SBFM.bankaccountno AS AccountNo, SBFM.netpay AS NetAmount, SBFM.branchid, company_master.companyname, BFM.doe, SBFM.bankid, SBFM.mobileno FROM   bankformatmaster AS BFM INNER JOIN  subbankformatmaster AS SBFM ON BFM.sno = SBFM.refno INNER JOIN   bankmaster AS BM ON SBFM.bankid = BM.sno INNER JOIN company_master ON SBFM.Companyid = company_master.sno WHERE (BFM.month = @month) AND (BFM.year = @year) AND (BFM.branchid = @branchid)  AND (BFM.filename = @filename)  ");
        sqlCmd.Parameters.Add("@branchid", ddlbranch.SelectedValue);
        sqlCmd.Parameters.Add("@month", ddlmonth.SelectedValue);
        sqlCmd.Parameters.Add("@year", year1.SelectedValue);
        sqlCmd.Parameters.Add("@filename", ddl_filenames.SelectedItem.Text);
        DataTable dtcompany = vdm.SelectQuery(sqlCmd).Tables[0];
        SqlDataAdapter sqlDa = new SqlDataAdapter(sqlCmd);
        DataTable dt = new DataTable();
        dt.Rows.Clear();
        sqlDa.Fill(dt);
        showreport.Rows.Clear();
        showreport.Columns.Clear();
        showreport.Columns.Add("Report");
        foreach (DataRow drg in dt.Rows)
        {
            string getemptid = drg[0].ToString();
            string Empname = drg[1].ToString();
            string Ifsccode = drg[2].ToString();
            string Account_no = drg[3].ToString();
            double NetAmount = Convert.ToDouble(drg[4].ToString());
            string branchid = drg[5].ToString();
            string companyname = "Salary Payble";
            string date = drg[7].ToString();
            int bankid = Convert.ToInt16(drg[8]);
            string mobileno = drg[9].ToString();
            string accountnu = Slect_account.SelectedItem.Text;
            string A = "SVDSPL~RPAY";
            string empbankid = drg[8].ToString();
            string cmpbankid = Slect_account.SelectedItem.Value;
            string bank = "";
            cmd = new SqlCommand("select bankid from accountno_details where sno=@sno");
            cmd.Parameters.Add("@sno", cmpbankid);
            DataTable dtbank = vdm.SelectQuery(cmd).Tables[0];
            if (dtbank.Rows.Count > 0)
            {
                bank = dtbank.Rows[0]["bankid"].ToString();
            }
            if (empbankid == bank)
            {
                paymode = "IFT";
            }
            else
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
            //}
            DateTime dtable = new DateTime();
            dtable = System.DateTime.Now;
            string condate = dtable.ToString("dd/MM/yyyy");
            //statement = paymode + "~~" + condate + "~" + NetAmount + "~~" + Empname + "~" + Ifsccode + "~" + Account_no  + "~~" + getemptid + "~" + companyname + "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
            statement = A + "~" + paymode + "~~" + condate + "~" + accountnu + "~" + +NetAmount + "~~" + Empname + "~" + Ifsccode + "~" + Account_no + "~" + mobileno + "~~" + getemptid + "~" + companyname + "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
            showreport.Rows.Add(statement);
        }
        if (showreport.Rows.Count > 0)
        {
            GridView9.DataSource = showreport;
            GridView9.DataBind();

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
                //  txt += cell.Text + "\t\t";
                txt += cell.Text;
            }

            txt += "\r\n";
        }

        Response.Clear();
        Response.Buffer = true;
        //here you can give the name of file.
        string dat, mon;
        dat = System.DateTime.Now.ToString("dd");
        mon = System.DateTime.Now.ToString("MM");

        string dt = dat + "-" + mon;
        string timee = String.Format("{0:d/M/yyyy HH:mm:ss}", dt);
        string NAME = dt + "-" + GridView9.Rows.Count + "-" + timee + ".txt";
        Response.AddHeader("content-disposition", "attachment;filename= '" + NAME + "'");
        Response.Charset = "";
        Response.ContentType = "application/text";
        Response.Output.Write(txt);
        Response.Flush();
        Response.End();


    }
    //...............Kotack Farmate End...............//
}