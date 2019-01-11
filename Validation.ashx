<%@ WebHandler Language="C#" Class="Validation" %>

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


public class Validation : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{


    string strConnectionString = ConfigurationManager.ConnectionStrings["connectionStringWebsite"].ConnectionString;
    Regex charc = new Regex(@"^[a-zA-Z][a-zA-Z ]*$");
    Regex numbers = new Regex("^[0-9]*$");

    Regex DateFormat = new Regex("^(((0[1-9]|[12]\\d|3[01])\\/(0[13578]|1[02])\\/((19|[2-9]\\d)\\d{2}))|((0[1-9]|[12]\\d|30)\\/(0[13456789]|1[012])\\/((19|[2-9]\\d)\\d{2}))|((0[1-9]|1\\d|2[0-8])\\/02\\/((19|[2-9]\\d)\\d{2}))|(29\\/02\\/((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$");
    string strData = "";
    string strName = "";
    string strPhone = "";
    string strEmail = "";
    string strdateofBirth = "";
    string strstate = "";
    string strcity = "";
    string chkTerms = "";
    string Captcha = "";
    string CompareValue = "";
    string utm_source = "";
    string utm_campaign = "";
    string strError = "";

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

        if (HttpUtility.UrlDecode(context.Request["dateofBirth"]) != null)
        {
            strdateofBirth = HttpUtility.UrlDecode(context.Request["dateofBirth"]).Trim();
        }
        else
        {
            strdateofBirth = "";
        }

        if (HttpUtility.UrlDecode(context.Request["state"]) != null)
        {
            strstate = HttpUtility.UrlDecode(context.Request["state"]).Trim();
        }
        else
        {
            strstate = "";
        }

        if (HttpUtility.UrlDecode(context.Request["city"]) != null)
        {
            strcity = HttpUtility.UrlDecode(context.Request["city"]).Trim();
        }
        else
        {
            strcity = "";
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

        

        if (HttpUtility.UrlDecode(context.Request["utm_source"]) != null)
        {
            utm_source = HttpUtility.UrlDecode(context.Request["utm_source"]).Trim();
        }
        else
        {
            utm_source = "";
        }


        if (HttpUtility.UrlDecode(context.Request["utm_campaign"]) != null)
        {
            utm_campaign = HttpUtility.UrlDecode(context.Request["utm_campaign"]).Trim();
        }
        else
        {
            utm_campaign = "";
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

        if (strName == "" || strName == "Name")
        {
            strData = "Please enter your name.*****txtname";
            return false;
        }

        if (strName != "")
        {

            Regex rgobj = new Regex(@"^[a-zA-Z][a-zA-Z ]*$");
            if (!rgobj.IsMatch(strName))
            {
                strData = "Name can have only letters.*****txtname";
                return false;
            }

            if (strName.Length < 3)
            {
                strData = "Please enter your valid name.*****txtname";
                return false;
            }
        }

        if (strPhone == "" || strPhone == "Phone")
        {
            strData = "Please enter your mobile number.*****txtmobileNo";
            return false;
        }

        if (strPhone != "")
        {
            if (strPhone.Length < 10)
            {
                strData = "Mobile number should be 10 digits.*****txtmobileNo";
                return false;
            } 
            
            else if (fnValidateMobileNumberR(strPhone))
            {
                strData = "Mobile number should start with 6,7,8 and 9.*****txtmobileNo";
                return false;
            }
        }

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

        if (strEmail == "" || strEmail == "Email")
        {
            strData = "Please enter your e-mailId*****txtemail";
            return false;
        }
        if (strEmail != "" && !ValidEmail(strEmail))
        {
            strData = "Please enter valid e-mailId*****txtemail";
            return false;
        }

        if (strstate == "" || strstate == "Select State")
        {
            strData = "Please select state*****ddlstate";
            return false;
        }


        if (strcity == "" || strcity == "Select City")
        {
            strData = "Please select city*****ddlcity";
            return false;
        }

        if (Captcha == "" || Captcha == "Enter Captcha*")
        {
            strData = "Please enter the captcha.*****txtCaptcha";
            return false;
        }

        if (Captcha != "" && Captcha != "Enter Captcha*" && Captcha.ToLower() != CompareValue.ToLower())
        {
            strData = "Please enter valid captcha.*****txtCaptcha";
            return false;
        }

        if (chkTerms == "0")
        {
            strData = "Please agree to the terms to proceed.*****chk_terms";
            return false;
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
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}