<%@ WebHandler Language="C#" Class="ValidationName" %>

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


public class ValidationName : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    string strData = "";
    string strName = "";
    HttpContext objContext = HttpContext.Current;
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1d);
        context.Response.Expires = -1500;
        context.Response.CacheControl = "no-cache";
        context.Response.ContentType = "text/plain";        

        if (HttpUtility.UrlDecode(context.Request["name"]) != null)
        {
            strName = HttpUtility.UrlDecode(context.Request["name"]).Trim();
        }
        else
        {
            strName = "";
        }

        if (isValidName())
        {
            context.Response.Write("success");
        }
        else
        {
            context.Response.Write(strData);
        }
        
    }


    private bool isValidName()
    {

        if (strName == "" || strName == "Name")
        {
            strData += "Please enter your name.*****txtname";
            return false;
        }

        if (strName != "")
        {

            Regex rgobj = new Regex(@"^[a-zA-Z][a-zA-Z ]*$");
            if (!rgobj.IsMatch(strName))
            {
                strData += "Name can have only letters.*****txtname";
                return false;
            }

            if (strName.Length < 3)
            {
                strData += "Please enter your valid name.*****txtname";
                return false;
            }
        }

        
            return true;
   }

    
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}