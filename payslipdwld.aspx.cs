using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using iTextSharp.text.pdf;
using iTextSharp.text;
using System.IO;
using System.Net.Mail;
using System.Configuration;
using System.Net;
using System.Data;
using System.Data.SqlClient;

public partial class payslipdwld : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
    protected void btn_employee_click(object sender, EventArgs e)
    {
        PaySlipPDFGeneration();
    }
   
    /// <summary>
    /// This Method is used to Generate PaySlip PDF Document
    /// </summary>
    protected void PaySlipPDFGeneration()
    {
        string EmployeeCode = txtempcode.Text;
        string EmpName = txtempname.Text;
        string ForMonth = txtmonth.Text;
        string NoofDays = txtnoofdays.Text;
        string DaysPaid = txtdayspaid.Text;
        string LOP = txtlop.Text;
        string ActBasic = txtactbasic.Text;
        string MonthBasic = txtmonthbasic.Text;
        string ActHRA = txtacthra.Text;
        string MonthHRA = txtmonthhra.Text;
        string ActConveyance = txtactconveyance.Text;
        string MonthConveyance = txtmonthconveyance.Text;
        string ActmedicalConveyance = txtactmedicalallowance.Text;
        string MonthmedicalConveyance = txtmonthmedicalallowance.Text;
        string canteendeduction = txtmonthcanteendeduction.Text;
        string ActwashingConveyance = txtactwashingallowance.Text;
        string MonthwashingConveyance = txtmonthwashingallowance.Text;
        string MonthPF = txtmonthpf.Text;
        string MonthPT = txtmonthpt.Text;
        string MonthESI = txtmonthesi.Text;
        string MonthIT = txtmonthincometax.Text;
        string ActTotalEarnings = txtActTotalEarnings.Text;
        string MonthTotalEarnings = txtMonthTotalEarnings.Text;
        string MonthTotalDeductions = txtMonthTotalDeductions.Text;
        string NetPay = txtNetPayAmount.Text;
        DateTime dt = DateTime.Now;
        string year = dt.Year.ToString();
        //string paymonth = ForMonth "'++'";
        string paymonth = "" + ForMonth + "-" + year + "";
        // string strNetPayinWords = NumberToWords(Convert.ToInt32(lblNetPayAmount.Text));

        string FilePath = "~/" + "Drawings/PaySlip.pdf";
        RandomAccessFileOrArray ramFile = new RandomAccessFileOrArray(Server.MapPath(FilePath));
        PdfReader reader1 = new PdfReader(ramFile, null);

        string PaySlipPath = FilePath.Substring(0, FilePath.Length - 11) + "" + EmployeeCode + "PaySlip.pdf";

        Document doc = new Document(PageSize.A4);
        PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(Server.MapPath(PaySlipPath), FileMode.Create));
        //PdfWriter email = PdfWriter.GetInstance(doc, new FileStream(Server.MapPath(PaySlipPath), FileMode.Create));
        writer.Open();
        // email.Open();
        doc.Open();
        PdfContentByte cb = writer.DirectContent;
        //PdfContentByte eb = email.DirectContent;

        // Pdf Page
        PdfPTable table = new PdfPTable(5);
        table.TotalWidth = 550f;
        table.LockedWidth = true;
        float[] widths = new float[] { 100f, 75f, 75f, 100f, 80f };
        table.SetWidths(widths);
        Font BoldFont = new Font(Font.FontFamily.TIMES_ROMAN, 11, Font.BOLD);
        Font NormalFont = new Font(Font.FontFamily.TIMES_ROMAN, 11, Font.NORMAL);
        Font SmallFont = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        using (MemoryStream memoryStream = new MemoryStream())
        {
            byte[] bytes = memoryStream.ToArray();

            MailMessage mm = new MailMessage("sknaseema11@gmail.com", "receiver@gmail.com");
            mm.Subject = "iTextSharp PDF";
            mm.Body = "iTextSharp PDF Attachment";
            mm.Attachments.Add(new Attachment(new MemoryStream(bytes), "iTextSharpPDF.pdf"));
            mm.IsBodyHtml = true;
            SmtpClient smtp = new SmtpClient();
            smtp.Host = "czismtp.logix.in";
            smtp.EnableSsl = true;
            NetworkCredential NetworkCred = new NetworkCredential();
            NetworkCred.UserName = "ravindra@vyshnavi.in";
            NetworkCred.Password = "<Ravindra@123>";
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = NetworkCred;
            smtp.Port = 587;
            smtp.Send(mm);


            string imagepath = Server.MapPath("~/Images/Vyshnavilogo.png");
            PdfPCell cell = new PdfPCell();
            cell = new PdfPCell(new Phrase(""));
            cell.FixedHeight = 34.0f;
            cell.Colspan = 2;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell.Colspan = 2;
            iTextSharp.text.Image img = iTextSharp.text.Image.GetInstance(imagepath);
            cell.AddElement(img);
            cell.FixedHeight = 54.0f;
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(""));
            cell.FixedHeight = 54.0f;
            cell.Colspan = 2;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Salary for the Month of " + paymonth, BoldFont));
            cell.FixedHeight = 20.0f;
            cell.Colspan = 5;
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Employee Code:", NormalFont));
            cell.FixedHeight = 20.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(EmployeeCode, BoldFont));
            cell.Colspan = 0;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Employee Name:", NormalFont));
            cell.FixedHeight = 20.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(EmpName, BoldFont));
            cell.Colspan = 0;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("For Month:", NormalFont));
            cell.FixedHeight = 20.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(ForMonth, BoldFont));
            cell.Colspan = 0;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("No.of Days:", NormalFont));
            cell.FixedHeight = 20.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(NoofDays, BoldFont));
            cell.Colspan = 0;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Days Paid:", NormalFont));
            cell.FixedHeight = 20.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(DaysPaid, BoldFont));
            cell.Colspan = 0;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("LOP:", NormalFont));
            cell.FixedHeight = 20.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(LOP, BoldFont));
            cell.Colspan = 0;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(""));
            cell.FixedHeight = 20.0f;
            cell.Colspan = 5;
            cell.Border = Rectangle.NO_BORDER;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Earnings", BoldFont));
            cell.Colspan = 3;
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Deductions", BoldFont));
            cell.Colspan = 3;
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Particulars", BoldFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Gross Earnings(Rs.)", BoldFont));
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Earnings for Month(Rs.)", BoldFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Particulars", BoldFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Deductions for Month(Rs.)", BoldFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Basic", NormalFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(ActBasic, NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(MonthBasic, NormalFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Provident Fund", NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(MonthPF, NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("House Rent Allowence", NormalFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(ActHRA, NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(MonthHRA, NormalFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Professional Tax", NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(MonthPT, NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Conveyance", NormalFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(ActConveyance, NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(MonthConveyance, NormalFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("ESI", NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(MonthESI, NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Medical Allowance", NormalFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(ActmedicalConveyance, NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(MonthmedicalConveyance, NormalFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Income Tax", NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(MonthIT, NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);


            cell = new PdfPCell(new Phrase("Washing Allowance", NormalFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(ActwashingConveyance, NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(MonthwashingConveyance, NormalFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Canteen Deduction", NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(canteendeduction, NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);


            cell = new PdfPCell(new Phrase("Total", NormalFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(ActTotalEarnings, BoldFont));
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(MonthTotalEarnings, BoldFont));
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Total", NormalFont));
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase(MonthTotalDeductions, BoldFont));
            cell.HorizontalAlignment = Element.ALIGN_RIGHT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Net Pay : " + NetPay, BoldFont));
            cell.Colspan = 6;
            cell.FixedHeight = 25.0f;
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            //cell = new PdfPCell(new Phrase(""));
            //cell.FixedHeight = 75.0f;
            //cell.Colspan = 6;
            //cell.Border = Rectangle.NO_BORDER;
            //table.AddCell(cell);

            cell = new PdfPCell(new Phrase("NOTE: This is computer generated payslip and needs no signature. If there is any discrepancy in your pay, you need to contact us within 3 days after payslip issue.", NormalFont));
            cell.FixedHeight = 55.0f;
            cell.Colspan = 5;
            cell.HorizontalAlignment = Element.ALIGN_LEFT;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            //cell = new PdfPCell(new Phrase(""));
            //cell.FixedHeight = 150.0f;
            //cell.Colspan = 5;
            //cell.Border = Rectangle.BOTTOM_BORDER;
            //table.AddCell(cell);

            cell = new PdfPCell(new Phrase("# NO.25, Vyshnavi House, Sriram Center, TNHB Colony, 2nd Street, Korattur, Chennai - 80", NormalFont));
            cell.FixedHeight = 20.0f;
            cell.Colspan = 5;
            cell.Border = Rectangle.NO_BORDER;
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Phone: +91 90870 22244, Email; hr@vyshnavi.in, vyshnavifoods.com", NormalFont));
            cell.FixedHeight = 20.0f;
            cell.Colspan = 5;
            cell.Border = Rectangle.NO_BORDER;
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            table.AddCell(cell);

            doc.Add(table);

            BaseFont bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            Font font = new Font(bf, 11, Font.NORMAL);
            // output src document: 
            int i = 1;
            while (i < reader1.NumberOfPages)
            {
                i++;
                // add next page from source PDF:
                doc.NewPage();
                PdfImportedPage page = writer.GetImportedPage(reader1, i);
                //cb.AddTemplate(page, 0, 0);
                writer.DirectContentUnder.AddTemplate(page, 0, 0);
                // use something like this to flush the current page to the browser:
                writer.Flush();
                //Response.Flush();
            }
            doc.Close();
            writer.Close();

            string FileName = "PaySlip.pdf";
            WebClient req = new WebClient();
            HttpResponse response = HttpContext.Current.Response;
            response.Clear();
            response.ClearContent();
            response.ClearHeaders();
            response.Buffer = true;
            response.AddHeader("Content-Disposition", "attachment;filename=\"" + FileName + "\"");
            byte[] data = req.DownloadData(Server.MapPath(PaySlipPath));
            response.BinaryWrite(data);
            //SendMail();
            //System.IO.File.Delete(Server.MapPath(PaySlipPath));
            response.End();
        }
    }
    /// <summary>
    /// This Method is used to Send eMail
    /// </summary>
    protected void SendMail()
    {
        MailMessage m = new MailMessage();
        System.Net.Mail.SmtpClient sc = new System.Net.Mail.SmtpClient();
        try
        {
            string strHost = ConfigurationManager.AppSettings["Host"].ToString();
            string strFromMailId = ConfigurationManager.AppSettings["EMailId"].ToString();
            string strFromPassword = ConfigurationManager.AppSettings["Password"].ToString();
            string strToMailId = "naveen15444@gmail.com";  //"jyothigidugu@gmail.com"; 

            m.From = new MailAddress(strFromMailId);
            m.To.Add(new MailAddress(strToMailId));
            m.Subject = "Payslip " + txtmonth.Text;
            m.IsBodyHtml = true;
            m.Body = "Please find the attachment of Payslip for " + txtmonth.Text;
            // Send With Attachment
            string FilePath = "~/Drawings/" + txtempcode.Text + "PaySlip.pdf";
            FileStream fs = new FileStream(Server.MapPath(FilePath) + "", FileMode.Open, FileAccess.Read);
            Attachment a = new Attachment(fs, "Payslip " + txtmonth.Text + ".pdf");
            m.Attachments.Add(a);

            sc.Host = strHost;
            sc.UseDefaultCredentials = false;
            sc.Credentials = new
            System.Net.NetworkCredential(strFromMailId, strFromPassword);
            sc.EnableSsl = false;
            sc.Send(m);
            sc.Dispose();
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }
}