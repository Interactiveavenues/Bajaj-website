<%@ WebHandler Language="C#" Class="ValidEmail" %>

using System;
using System.Web;
using System.IO;
using System.Drawing;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using System.Text.RegularExpressions;
using System.Net;
using System.IO;
using System.Text;


public class ValidEmail : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    string strData = "";
    string strEmail = "";

    HttpContext objContext = HttpContext.Current;
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1d);
        context.Response.Expires = -1500;
        context.Response.CacheControl = "no-cache";
        context.Response.ContentType = "text/plain";
        
        if (HttpUtility.UrlDecode(context.Request["emailId"]) != null)
        {
            strEmail = HttpUtility.UrlDecode(context.Request["emailId"]).Trim();
        }
        else
        {
            strEmail = "";
        }        

        if (isValidForm())
        {
            context.Response.Write("success");
        }
        else
        {
            context.Response.Write(strData);
        }        
    }
    private bool isValidForm()
    {
        if (strEmail == "" || strEmail == "Email")
        {
            strData = "Please enter your e-mailId*****txtemail";
            return false;
        }
        if (strEmail != "" && !ValidEmails(strEmail))
        {
            strData = "Please enter valid e-mailId*****txtemail";
            return false;
        }        
        return true;
   }

    private bool ValidEmails(string validatingstring)
    {
        if (!Regex.Match(validatingstring, @"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$").Success)
        {
            return false;
        }
        else
        {
            return true;
        }
    }   
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}