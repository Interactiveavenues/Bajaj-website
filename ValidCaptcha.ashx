<%@ WebHandler Language="C#" Class="ValidCaptcha" %>

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


public class ValidCaptcha : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    string strData = "";
    string Captcha = "";
    string CompareValue = "";

    HttpContext objContext = HttpContext.Current;
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1d);
        context.Response.Expires = -1500;
        context.Response.CacheControl = "no-cache";
        context.Response.ContentType = "text/plain";

        if (HttpUtility.UrlDecode(context.Request["captcha"]) != null)
        {
            Captcha = HttpUtility.UrlDecode(context.Request["captcha"]).Trim();
        }
        else
        {
            Captcha = "";
        }        
        
        CompareValue = Convert.ToString(context.Session["captcha"]);





        if (isValidCaptcha())
        {
            context.Response.Write("success");
        }
        else
        {
            context.Response.Write(strData);
        }
        
    }


    private bool isValidCaptcha()
    {  
        if (Captcha == "" || Captcha == "Enter Captcha*")
        {
            strData = "Please enter the captcha.*****txtCaptcha@@";
            return false;
        }

        if (Captcha != "" && Captcha != "Enter Captcha*" && Captcha.ToLower() != CompareValue.ToLower())
        {
            strData = "Please enter valid captcha.*****txtCaptcha@@";
            return false;
        }
            return true;
   }

    
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}