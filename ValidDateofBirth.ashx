<%@ WebHandler Language="C#" Class="ValidDateofBirth" %>

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


public class ValidDateofBirth : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{



    Regex DateFormat = new Regex("^(((0[1-9]|[12]\\d|3[01])\\/(0[13578]|1[02])\\/((19|[2-9]\\d)\\d{2}))|((0[1-9]|[12]\\d|30)\\/(0[13456789]|1[012])\\/((19|[2-9]\\d)\\d{2}))|((0[1-9]|1\\d|2[0-8])\\/02\\/((19|[2-9]\\d)\\d{2}))|(29\\/02\\/((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$");
    string strData = "";
    string strdateofBirth = "";
    HttpContext objContext = HttpContext.Current;    
    public void ProcessRequest (HttpContext context) {
        context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1d);
        context.Response.Expires = -1500;
        context.Response.CacheControl = "no-cache";
        context.Response.ContentType = "text/plain";
        
        if (HttpUtility.UrlDecode(context.Request["dateofBirth"]) != null)
        {
            strdateofBirth = HttpUtility.UrlDecode(context.Request["dateofBirth"]).Trim();
        }
        else
        {
            strdateofBirth = "";
        }

        if (isValidDateofBirth())
        {
            context.Response.Write("success");
        }
        else
        {
            context.Response.Write(strData);
        }
        
    }


    private bool isValidDateofBirth()
    { 

        if (strdateofBirth == "")
        {
            strData = "Please enter your date of birth.*****txtDOB";
            return false;
        }
        if (strdateofBirth != "")
        {
            if (!DateFormat.IsMatch(strdateofBirth))
            {
                strData = "Please enter your valid date of birth.*****txtDOB";
                return false;
            }
            else
            {
                if (validateAge(strdateofBirth))
                {
                    strData = "Enter Age should be greater than 18 and less than 60*****txtDOB";
                    return false;
                }
            }
        }        
            return true;
   }

    public bool validateAge(string inputDate)
    {
        bool flag = false;
        string date1 = inputDate.Split('/')[0];
        string month = inputDate.Split('/')[1];
        string year1 = inputDate.Split('/')[2];
        int age = 0;
        DateTime dateCurrent = DateTime.Today;
        DateTime dob = Convert.ToDateTime(year1 + "-" + month + "-" + date1);
        if (dateCurrent > dob)
        {
            age = new DateTime(DateTime.Now.Subtract(dob).Ticks).Year - 1;
        }

        if (age < 18 || age > 60)
        {
            flag = true;
        }
        return flag;
    }   
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}