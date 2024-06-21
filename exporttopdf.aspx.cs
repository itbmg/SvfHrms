using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using System.Text;

public partial class exporttopdf : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["xportdata"] != null)
        {
            DataTable dtt = (DataTable)Session["xportdata"];
            //ExportToExcel(dtt);
            ExportToPDF(dtt);
        }
    }

    public void ExportToExcel(DataTable dt)
    {
        try
        {
            if (dt.Rows.Count > 0)
            {
                string filena = Session["filename"].ToString();
                string address = Session["Address"].ToString();
                string TitleName = Session["TitleName"].ToString();
                string title = Session["title"].ToString();
                string filename = "";
                if (filena != "" && filena != null)
                {
                    filename = filena;
                }
                else
                {
                    filename = "Report";
                }

                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.ClearContent();
                HttpContext.Current.Response.ClearHeaders();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.ContentType = "application/ms-excel";
                HttpContext.Current.Response.Write(@"<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">");
                HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + filename + ".xls");

                HttpContext.Current.Response.Charset = "utf-8";
                HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.GetEncoding("windows-1250");
                //sets font
                HttpContext.Current.Response.Write("<font style='font-size:10.0pt;'>");
                HttpContext.Current.Response.Write("<BR><BR><BR>");
                //sets the table border, cell spacing, border color, font of the text, background, foreground, font height
                HttpContext.Current.Response.Write("<Table border='1' bgColor='#ffffff' " +
                  "borderColor='#000000' cellSpacing='0' cellPadding='0' " +
                  "style='font-size:10.0pt; background:white;'> <TR>");
                int columnscount = dt.Columns.Count;
                //For Header
                if (filename == "Total Deduction" || filename == "Employeedetails" || filename == "Employeebankdetails" || filename == "Organisetionflowdetails")
                {
                }
                else
                {
                    if (columnscount < 9)
                    {
                        if (columnscount < 5)
                        {
                            HttpContext.Current.Response.Write("<Td colspan='" + 6 + "' align='center' style='font-size:15.0pt;'>" + TitleName + "</Td><TR>");
                            HttpContext.Current.Response.Write("<Td colspan='" + 6 + "' align='center' style='font-size:10.0pt;'>" + address + "</Td><TR>");
                            HttpContext.Current.Response.Write("<Td colspan='" + 6 + "' align='center' style='font-size:12.0pt;'>" + title + "</Td><TR>");
                        }
                        else
                        {
                            HttpContext.Current.Response.Write("<Td colspan='" + 10 + "' align='center' style='font-size:20.0pt;'>" + TitleName + "</Td><TR>");
                            HttpContext.Current.Response.Write("<Td colspan='" + 10 + "' align='center' style='font-size:10.0pt;'>" + address + "</Td><TR>");
                            HttpContext.Current.Response.Write("<Td colspan='" + 10 + "' align='center' style='font-size:15.0pt;'>" + title + "</Td><TR>");
                        }
                    }
                    else
                    {
                        HttpContext.Current.Response.Write("<Td colspan='" + columnscount + "' align='center' style='font-size:30.0pt;'>" + TitleName + "</Td><TR>");
                        HttpContext.Current.Response.Write("<Td colspan='" + columnscount + "' align='center' style='font-size:14.0pt;'>" + address + "</Td><TR>");
                        HttpContext.Current.Response.Write("<Td colspan='" + columnscount + "' align='center' style='font-size:20.0pt;'>" + title + "</Td><TR>");
                    }
                }
                //am getting my grid's column headers


                for (int j = 0; j < columnscount; j++)
                {      //write in new column
                    int name = dt.Columns[j].ColumnName.Length;
                    if (name <= 3)
                    {
                        HttpContext.Current.Response.Write("<Td style='font-size:11.0pt;height:40.pt;width:40px'>");
                    }
                    if (name > 3)
                    {
                        HttpContext.Current.Response.Write("<Td style='font-size:11.0pt;height:40.pt;width:85px'>");
                    }
                    //if (dt.Columns[j].ColumnName == "Bank Acc NO")
                    //{
                    //    HttpContext.Current.Response.Write("<Td style='font-size:11.0pt;height:40.pt;width:110px'>");
                    //}
                    //Get column headers  and make it as bold in excel columns
                    HttpContext.Current.Response.Write("<B>");
                    if (dt.Columns[j].ColumnName.ToString() == "Bank Acc NO")
                    {
                        HttpContext.Current.Response.Write(dt.Columns[j].ColumnName.ToString());
                    }
                    else
                    {
                        HttpContext.Current.Response.Write(dt.Columns[j].ColumnName.ToString());
                    }
                    HttpContext.Current.Response.Write("</B>");
                    HttpContext.Current.Response.Write("</Td>");
                }
                HttpContext.Current.Response.Write("</TR>");
                foreach (DataRow row in dt.Rows)
                {//write in new row
                    HttpContext.Current.Response.Write("<TR>");
                    if (columnscount < 9)
                    {
                        for (int i = 0; i < dt.Columns.Count; i++)
                        {

                            HttpContext.Current.Response.Write("<Td style='font-size:10.0pt;height:40px;width:120px'>");
                            HttpContext.Current.Response.Write(row[i].ToString());
                            HttpContext.Current.Response.Write("</Td>");
                        }
                    }
                    else
                    {
                        for (int i = 0; i < dt.Columns.Count; i++)
                        {
                            HttpContext.Current.Response.Write("<Td style='font-size:10.0pt;height:40px'>");
                            HttpContext.Current.Response.Write(row[i].ToString());
                            HttpContext.Current.Response.Write("</Td>");
                        }
                    }
                    HttpContext.Current.Response.Write("</TR>");
                }
                HttpContext.Current.Response.Write("</Table>");
                HttpContext.Current.Response.Write("</font>");
                HttpContext.Current.Response.Flush();
                HttpContext.Current.Response.End();
            }
        }
        catch (Exception ex)
        {
        }
    }

    public void ExportToPDF(DataTable dt)
    {
        string filena = Session["filename"].ToString();
        string address = Session["Address"].ToString();
        string TitleName = Session["TitleName"].ToString();
        string title = Session["title"].ToString();
        string filename = "";
        if (filena != "" && filena != null)
        {
            filename = filena;
        }
        else
        {
            filename = "Report";
        }
        if (filename == "Total Deduction" || filename == "Employeedetails" || filename == "Employeebankdetails" || filename == "Organisetionflowdetails")
        {
        }
        else
        {
            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter hw = new HtmlTextWriter(sw))
                {
                    StringBuilder sb = new StringBuilder();

                    sb.Append("<table width='100%' cellspacing='0' cellpadding='2'>");
                    sb.Append("<tr><td align='center' style='background-color: #18B5F0' colspan = '2'><b>Order Sheet</b></td></tr>");
                    sb.Append("<tr><td colspan = '2'></td></tr>");
                    sb.Append("<tr><td><b>Order No: </b>");
                   // sb.Append(orderNo);
                    sb.Append("</td><td align = 'right'><b>Date: </b>");
                    sb.Append(DateTime.Now);
                    sb.Append(" </td></tr>");
                    sb.Append("<tr><td colspan = '2'><b>Company Name: </b>");
                   // sb.Append(companyName);
                    sb.Append("</td></tr>");
                    sb.Append("</table>");
                    sb.Append("<br />");


                    //Generate Invoice (Bill) Items Grid.
                    sb.Append("<table border = '1'>");
                    sb.Append("<tr>");
                    foreach (DataColumn column in dt.Columns)
                    {
                        sb.Append("<th style = 'background-color: #D20B0C;color:#777;width:150px;'>");
                        sb.Append(column.ColumnName);
                        sb.Append("</th>");
                    }
                    sb.Append("</tr>");
                    foreach (DataRow row in dt.Rows)
                    {
                        sb.Append("<tr>");
                        foreach (DataColumn column in dt.Columns)
                        {
                            sb.Append("<td>");
                            sb.Append(row[column]);
                            sb.Append("</td>");
                        }
                        sb.Append("</tr>");
                    }
                    //sb.Append("<tr><td align = 'right' colspan = '");
                    //sb.Append(dt.Columns.Count - 1);
                    //sb.Append("'>Total</td>");
                    //sb.Append("<td>");
                    //sb.Append(dt.Compute("sum(Total)", ""));
                    //sb.Append("</td>");
                    sb.Append("</table>");

                    //Export HTML String as PDF.
                    StringReader sr = new StringReader(sb.ToString());
                    Document pdfDoc = new Document(PageSize.A3, 0f, 0f, 0f, 0f);
                    Document doc = new Document(new RectangleReadOnly(842, 595), 88f, 88f, 10f, 10f);
                    HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
                    PdfWriter writer = PdfWriter.GetInstance(pdfDoc, Response.OutputStream);
                    pdfDoc.Open();
                    htmlparser.Parse(sr);
                    pdfDoc.Close();
                    Response.ContentType = "application/pdf";
                    Response.AddHeader("content-disposition", "attachment;filename=" + filename + ".pdf");
                    Response.Cache.SetCacheability(HttpCacheability.NoCache);
                    Response.Write(pdfDoc);
                    Response.End();
                }
            }
        }
    }
}