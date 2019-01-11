<%@ WebHandler Language="C#" Class="submit_Quiz2" %> 

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

public class submit_Quiz2 : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    string strConnectionString = ConfigurationManager.ConnectionStrings["connectionStringWebsite"].ConnectionString;
    Regex charc = new Regex(@"^[a-zA-Z][a-zA-Z ]*$");
    Regex numbers = new Regex("^[0-9]*$");

    string strData = "";
    string strName = "";
    string strPhone = "";
    string strEmail = "";
    string strdateofBirth = "";
    string strshirtSize = "";
    string chkTerms = "";
    string Captcha = "";
    string CompareValue = "";
    string utm_source = "";
    string utm_campaign = "";
    string strError = "";
    string stepNo = "";

    HttpContext objContext = HttpContext.Current;

    public void ProcessRequest(HttpContext context)
    {
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

        if (HttpUtility.UrlDecode(context.Request["mobile"]) != null)
        {
            strPhone = HttpUtility.UrlDecode(context.Request["mobile"]).Trim();
        }
        else
        {
            strPhone = "";
        }

        if (HttpUtility.UrlDecode(context.Request["emailId"]) != null)
        {
            strEmail = HttpUtility.UrlDecode(context.Request["emailId"]).Trim();
        }
        else
        {
            strEmail = "";
        }


        if (HttpUtility.UrlDecode(context.Request["shirtSize"]) != null)
        {
            strshirtSize = HttpUtility.UrlDecode(context.Request["shirtSize"]).Trim();
        }
        else
        {
            strshirtSize = "";
        }

        if (HttpUtility.UrlDecode(context.Request["chk_terms"]) != null)
        {
            if (HttpUtility.UrlDecode(context.Request["chk_terms"]) == "1")
            {
                chkTerms = HttpUtility.UrlDecode(context.Request["chk_terms"]).Trim();
            }
            else
            {
                chkTerms = "0";
            }
        }
        else
        {
            chkTerms = "0";
        }


        if (HttpUtility.UrlDecode(context.Request["captcha"]) != null)
        {
            Captcha = HttpUtility.UrlDecode(context.Request["captcha"]).Trim();
        }
        else
        {
            Captcha = "";
        }

        CompareValue = Convert.ToString(context.Session["captcha"]);


        if (HttpUtility.UrlDecode(context.Request["stepNo"]) != null)
        {
            stepNo = HttpUtility.UrlDecode(context.Request["stepNo"]).Trim();
        }
        else
        {
            stepNo = "";
        }

        if (isValidForm())
        {

           

                strData = "success***";
                context.Response.Write(strData);

            


        }
        else
        {
            context.Response.Write(strData);
        }



        context.Response.End();
    }




    private bool isValidForm()
    {

        if (strName == "" || strName == "Name")
        {
            strData += "Please enter your name.*****txtname@@";
        }

        if (strName != "")
        {

            Regex rgobj = new Regex(@"^[a-zA-Z][a-zA-Z ]*$");
            if (!rgobj.IsMatch(strName))
            {
                strData += "Name can have only letters.*****txtname@@";
            }

            if (strName.Length < 3)
            {
                strData += "Please enter your valid name.*****txtname@@";
            }
        }

        if (strPhone == "" || strPhone == "Phone")
        {
            strData += "Please enter your mobile number.*****txtmobileNo@@";
        }

        if (strPhone != "")
        {
            if (strPhone.Length < 10)
            {
                strData += "Mobile number should be 10 digits.*****txtmobileNo@@";
            }

            else if (fnValidateMobileNumberR(strPhone))
            {
                strData += "Mobile number should start with 6,7,8 and 9.*****txtmobileNo@@";
            }
        }


        if (strEmail == "" || strEmail == "Email")
        {
            strData += "Please enter your e-mailId*****txtemail@@";
        }
        if (strEmail != "" && !ValidEmail(strEmail))
        {
            strData += "Please enter valid e-mailId*****txtemail@@";
        }

        if (strshirtSize == "" || strshirtSize == "Select State")
        {
            strData += "Select T-shirt size*****ddlshirtSize@@";
        }


        if (Captcha == "" || Captcha == "Enter Captcha*")
        {
            strData += "Please enter the captcha.*****txtCaptcha@@";
        }

        if (Captcha != "" && Captcha != "Enter Captcha*" && Captcha.ToLower() != CompareValue.ToLower())
        {
            strData += "Please enter valid captcha.*****txtCaptcha@@";
        }

        if (chkTerms == "0")
        {
            strData += "Please agree to the terms to proceed.*****chk_terms@@";
        }

        if (strData != "")
        {
            return false;
        }
        else
        {
            return true;
        }
    }






    private bool ValidEmail(string validatingstring)
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


    private Boolean fnValidateMobileNumberR(string strPhoneNumber)
    {
        if (!numbers.IsMatch(strPhoneNumber))
        {
            return true;
        }
        if (strPhoneNumber.Length != 10)
        {
            return true;
        }
        if (!strPhoneNumber.StartsWith("9") && !strPhoneNumber.StartsWith("8") && !strPhoneNumber.StartsWith("7") && !strPhoneNumber.StartsWith("6"))
        {
            return true;
        }
        if (strPhoneNumber == "9000000000" || strPhoneNumber == "9111111111" || strPhoneNumber == "9222222222" || strPhoneNumber == "9333333333" || strPhoneNumber == "944444444" || strPhoneNumber == "955555555" || strPhoneNumber == "966666666" || strPhoneNumber == "9777777777" || strPhoneNumber == "9888888888" || strPhoneNumber == "9999999999")
        {
            return true;
        }
        if (strPhoneNumber == "8000000000" || strPhoneNumber == "8111111111" || strPhoneNumber == "8222222222" || strPhoneNumber == "8333333333" || strPhoneNumber == "844444444" || strPhoneNumber == "855555555" || strPhoneNumber == "866666666" || strPhoneNumber == "8777777777" || strPhoneNumber == "8888888888" || strPhoneNumber == "8999999999")
        {
            return true;
        }
        if (strPhoneNumber == "7000000000" || strPhoneNumber == "7111111111" || strPhoneNumber == "7222222222" || strPhoneNumber == "7333333333" || strPhoneNumber == "744444444" || strPhoneNumber == "755555555" || strPhoneNumber == "766666666" || strPhoneNumber == "7777777777" || strPhoneNumber == "7888888888" || strPhoneNumber == "7999999999")
        {

            return true;
        }

        if (strPhoneNumber == "6000000000" || strPhoneNumber == "6111111111" || strPhoneNumber == "6222222222" || strPhoneNumber == "6333333333" || strPhoneNumber == "644444444" || strPhoneNumber == "655555555" || strPhoneNumber == "666666666" || strPhoneNumber == "6777777777" || strPhoneNumber == "6888888888" || strPhoneNumber == "6999999999")
        {

            return true;
        }

        return false;
    }


    public bool IsReusable
    {
        get
        {
            return false;
        }
    }





    public class APIDetails
    {
        public string lead_id;
        public string status;
        public string error_message;
    }



}