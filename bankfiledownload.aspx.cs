using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.IO;
public partial class bankfiledownload : System.Web.UI.Page
{
    DataTable showreport = new DataTable();
    string statement;
    string planttype;
    string planttypehdfc;
    String paymode;
    string ptype;
    public string filename;
    string files;
    public string getid;
    int GETID;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["userid"] == null)
            {
                Response.Redirect("Login.aspx");
                ViewState["GETFILE"] = string.Empty;
            }

            else
            {
                Panel4.Visible = false;
                string userid = Session["userid"].ToString();
                DBManager vdm = new DBManager();
                PopulateYear();
                bindbranchs();
                ddl_filename.Visible = true;
                ddlmonth.Visible = true;
                ddlyear.Visible = true;
                Label2.Visible = false;
                Button2.Visible = false;
                ddl_kotacklist.Visible = false;

            }
        }
    }

    //private void PopulateYear()
    //{
    //    ddlyear.Items.Clear();
    //    ListItem lt = new ListItem();
    //    lt.Text = "YYYY";
    //    lt.Value = "0";
    //    ddlyear.Items.Add(lt);
    //    for (int i = DateTime.Now.Year; i >= 1970; i--)
    //    {
    //        lt = new ListItem();
    //        lt.Text = i.ToString();
    //        lt.Value = i.ToString();
    //        ddlyear.Items.Add(lt);
    //    }
    //    ddlyear.Items.FindByValue(DateTime.Now.Year.ToString()).Selected = true;
    //}
    protected void Btn_Load_Click(object sender, EventArgs e)
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
        if (dtfiletrips.Rows.Count > 0)
        {
            ddl_filename.DataSource = dtfiletrips;
            ddl_filename.DataTextField = "filename";
            ddl_filename.DataValueField = "sno";
            ddl_filename.DataBind();
            ddl_filename.ClearSelection();
            ddl_filename.Items.Insert(0, new ListItem { Value = "0", Text = "--Select File--", Selected = true });
            ddl_filename.SelectedValue = "0";
            LoadUploadedFilesDetails();
            
        }
        else
        {
            GridView7.Visible = false;
            GridView8.Visible = false;
           
        }
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
                GridView7.Visible = true;
                Panel3.Visible = true;
            }
            else
            {
                GridView7.DataSource = null;
                GridView7.DataBind();
                GridView7.Visible = false;
                GridView8.Visible = false;
                Button2.Visible = false;
                Panel3.Visible = false;
            }
        }
        catch (Exception ex)
        {
            ex.ToString();
        }
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
            GridView8.Visible = false;
            Button2.Visible = false;
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
      //  LoadUploadedFilesDetails();
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
            Account_no = Account_no.Replace("'", String.Empty).TrimStart();
            // string Account_no 
            double NetAmount = Convert.ToDouble(dr["AMOUNT"].ToString());
            string date = ServerDateCurrentdate.ToString("dd/MM/yyyy");
            string pmail = "hr@vyshnavi.in";
            string milktype = "Salary";
            string plcode = dr["employecode"].ToString();
            int bankid = Convert.ToInt16(dr["bankid"].ToString());
            string mobile = dr["mobileno"].ToString();
            string accountnu = ddl_kotacklist.SelectedItem.Value;
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
            Visible = false;
        }
        // Agent_Id, Agent_Name, Ifsccode, Account_no, NetAmount, Date, Pmail, Milktype, Plant_Code,  Bank_Id, phone_Number
        // con = dbaccess.GetConnection();
        //   string getquery = "select Agent_Id,Agent_Name,Ifsccode,Account_no,convert(decimal(18,0),floor(NetAmount)) as NetAmount,Date,Pmail,Milktype,Plant_Code,Bank_Id   from (select  Agent_Id,Agent_Name,Ifsccode,Account_no,NetAmount,Plant_Code,convert(varchar,Added_Date,103) as Date,Bank_id    from BankPaymentllotment  where plant_code='" + pcode + "'   and    Billfrmdate='" + d1 + "'  and Billtodate='" + d2 + "' AND  BankFileName='" + ddl_filename.SelectedItem.Text + "'  and NetAmount > 0) as ff  left join (Select pmail,Milktype,Plant_Code as pcode   from Plant_Master   where plant_code='" + pcode + "' ) as pm on ff.Plant_Code= pm.pcode  order by Date asc";
        //  string getquery = "sELECT Agent_Id,Agent_Name,Ifsccode,Account_no,convert(decimal(18,0),floor(NetAmount)) as NetAmount,Date,Pmail,Milktype,Plant_Code,Bank_Id,phone_Number  FROM (select Agent_Id,Agent_Name,Ifsccode,Account_no,convert(decimal(18,0),floor(NetAmount)) as NetAmount,Date,Pmail,Milktype,Plant_Code,Bank_Id   from (select  Agent_Id,Agent_Name,Ifsccode,Account_no,NetAmount,Plant_Code,convert(varchar,Added_Date,103) as Date,Bank_id    from BankPaymentllotment  where plant_code='" + pcode + "'   and    Billfrmdate='" + d1 + "'  and Billtodate='" + d2 + "' AND  BankFileName='" + ddl_filename.SelectedItem.Text + "'  and NetAmount > 0) as ff  left join (Select pmail,Milktype,Plant_Code as pcode   from Plant_Master   where plant_code='" + pcode + "' ) as pm on ff.Plant_Code= pm.pcode   ) AS FF  LEFT JOIN (sELECT Plant_code AS amplantcode,Agent_Id as agent,phone_Number   FROM Agent_Master   WHERE plant_code='" + pcode + "' GROUP BY Plant_code,Agent_Id,phone_Number)  AS AM ON FF.Plant_Code=AM.amplantcode   and FF.Agent_Id=AM.agent";
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
        //string FileName = pcode + txt_FromDate.Text + txt_ToDate.Text + DateTime.Now + ".txt";
        //Response.AddHeader("content-disposition", "attachment;filename=Vithal_Wadje.txt");
        //Response.AddHeader("content-disposition", "attachment;" + FileName);
        DateTime dt = new DateTime();
        dt = System.DateTime.Now;
        string DATEE = dt.ToString("ddMMyy");
        string timee = String.Format("{0:d/M/yyyy HH:mm:ss}", dt);
        files = ddl_filename.SelectedItem.Text + DATEE + ".txt";

        Response.AddHeader("content-disposition", "attachment;filename= " + files + "");
        Response.Charset = "";
        Response.ContentType = "application/text";
        Response.Output.Write(txt);
        //FileStream fs = File.Create(txt);
        //File.SetAttributes(txt+".txt",FileAttributes.ReadOnly);
        Response.Flush();
        //    getupdatefilelock();
        Response.End();
    }

    protected void Btn_Download_Click(object sender, EventArgs e)
    {
        //if (ddl_bankname.Text == "KOTACK")
        //{
        //    GridView9.Visible = true;
        //    getbankdeatils();
        //    lbl_totamt.Visible = true;
        //    lbl_totamt.Enabled = false;
        //    ExportGridToText12();
        //}
        //if (ddl_bankname.Text == "HDFC TO OTHERS")
        //{


        //}
        if (ddl_bankname.Text == "HDFC TO OTHERS")
        {
               //getplanttype();
                //  OthersToHdfcExportGridTomacroformat();
                //gridhtoother();
              GETUPDATE();
              if (GETID == 0)
              {
                  getupdatefilelock();
                  LoadOthersToHDFCmacroformatGrid();
                  OthersToHdfcExportGridTomacroformat();
               
              }
              else
              {
                  string message;
                  message = "File Already Updated";
                  string script = "window.onload = function(){ alert('";
                  script += message;
                  script += "')};";
                  ClientScript.RegisterStartupScript(this.GetType(), "SuccessMessage", script, true);
              }

        }
        if (ddl_bankname.Text == "KOTACK")
        {
            GridView9.Visible = true;
            getbankdeatils();
         //   getgetbankpayandexcessamt();
            lbl_totamt.Visible = true;
            lbl_totamt.Enabled = false;
             GETUPDATE();
             if (GETID == 0)
             {
                 lblmsga.Text = "";
                 getupdatefilelock();
                 ExportGridToText12();
             }
             else
             {
                 lblmsga.Text = "File Already Downloded";

               //  ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('')", true);
             }
        }

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
                    GridView6.Visible = false;
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

    private void OthersToHdfcExportGridTomacroformat()
    {
        int cc = 0;
       
        cc = LoadOthersToHDFCmacroformatGrid();
        Response.Clear();
        Response.Buffer = true;

        string dat, mon;
        dat = System.DateTime.Now.ToString("dd");
        mon = System.DateTime.Now.ToString("MM");
      //  filename = dat + mon;
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


        files = ddl_filename.SelectedItem.Text;
        // Response.AddHeader("content-disposition", "attachment;filename=bms.009");
        //  Response.AddHeader("content-disposition", "attachment;filename=SVD2" + filename + "." + rowcount);
        Response.AddHeader("content-disposition", "attachment;filename=" + files + "." + rowcount);
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
    protected void ddl_bankname_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddl_bankname.SelectedItem.Text == "KOTACK")
        {
            ddl_kotacklist.Visible = true;
            Label2.Visible = true;
            //Label3.Visible = false;
            //RadioButtonList1.Visible = false;
        }
        else
        {
            ddl_bankname.Visible = true;
            Label1.Visible = true;
            //Label3.Visible = false;
            //RadioButtonList1.Visible = false;
            ddl_kotacklist.Visible = false;
            Label2.Visible = false;
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {

    }
    protected void btn_Delete_Click(object sender, EventArgs e)
    {

    }
    protected void chk_dele_CheckedChanged(object sender, EventArgs e)
    {

    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        if (CheckBox1.Checked == true)
        {
            Panel4.Visible = true;
        }
        else
        {
            Panel4.Visible = false;
        }
    }
    protected void GridView2_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void ddl_BillDate_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
   
    protected void GridView7_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
    protected void GridView7_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridView8.Visible = true;
        Button2.Visible = true;
        getid = (GridView7.SelectedRow.Cells[2].Text).ToString();
        ViewState["GETFILE"] = (GridView7.SelectedRow.Cells[2].Text).ToString();
        getgrid();
    }
    protected void GridView11_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
    protected void GridView11_SelectedIndexChanged(object sender, EventArgs e)
    {

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
            files = ddl_filename.SelectedItem.Text;
            string FileName = ViewState["GETFILE"].ToString() + DateTime.Now + ".xls";
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
    protected void GridView8_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
    protected void ddl_filename_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadUploadedFilesDetails();
    }
}