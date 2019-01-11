<%@ WebHandler Language="C#" Class="validateFunction" %>

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


public class validateFunction : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{


    string strConnectionString = ConfigurationManager.ConnectionStrings["connectionStringWebsite"].ConnectionString;
    Regex charc = new Regex(@"^[a-zA-Z][a-zA-Z ]*$");
    Regex numbers = new Regex("^[0-9]*$");
    Regex DateFormat = new Regex("^(((0[1-9]|[12]\\d|3[01])\\/(0[13578]|1[02])\\/((19|[2-9]\\d)\\d{2}))|((0[1-9]|[12]\\d|30)\\/(0[13456789]|1[012])\\/((19|[2-9]\\d)\\d{2}))|((0[1-9]|1\\d|2[0-8])\\/02\\/((19|[2-9]\\d)\\d{2}))|(29\\/02\\/((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$");
    string strData = "";
    string CompareValue = "";
    string strControlId = "";
    string strControlName = "";
    bool flag = true;

    HttpContext objContext = HttpContext.Current;

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1d);
        context.Response.Expires = -1500;
        context.Response.CacheControl = "no-cache";
        context.Response.ContentType = "text/plain";

        foreach (string s in context.Request.Form.Keys)
        {
            if (HttpUtility.UrlDecode(context.Request[s.ToString()]) != null)
            {
                strControlId = HttpUtility.UrlDecode(context.Request[s.ToString()]).Trim();

                strControlName = s.ToString();

            }
            else
            {
                strControlId = "";
            }
        }

        isValidForm();
        
        
        if (flag == true)
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

        if (strControlId == "" || strControlId == "Name")
        {
            strData += "Please enter your name.*****txtname";
            return false;
        }

        if (strControlId != "")
        {

            Regex rgobj = new Regex(@"^[a-zA-Z][a-zA-Z ]*$");
            if (!rgobj.IsMatch(strControlId))
            {
                strData += "Name can have only letters.*****txtname";
                return false;
            }

            if (strControlId.Length < 3)
            {
                strData += "Please enter your valid name.*****txtname";
                return false;
            }
        }


        return true;
    }

    private bool isValidmobileNo()
    {
        if (strControlId == "" || strControlId == "Phone")
        {
            strData = "Please enter your mobile number.*****txtmobileNo";
            return false;
        }

        if (strControlId != "")
        {
            if (strControlId.Length < 10)
            {
                strData = "Mobile number should be 10 digits.*****txtmobileNo";
                return false;
            }

            else if (fnValidateMobileNumberR(strControlId))
            {
                strData = "Mobile number should start with 6,7,8 and 9.*****txtmobileNo";
                return false;
            }
        }
        return true;
    }

    private bool isValidDateofBirth()
    {

        if (strControlId == "")
        {
            strData = "Please enter your date of birth.*****txtDOB";
            return false;
        }
        if (strControlId != "")
        {
            if (!DateFormat.IsMatch(strControlId))
            {
                strData = "Please enter your valid date of birth.*****txtDOB";
                return false;
            }
            else
            {
                if (validateAge(strControlId))
                {
                    strData = "Enter Age should be greater than 18 and less than 60*****txtDOB";
                    return false;
                }
            }
        }
        return true;
    }

    private bool isValidEmail()
    {
        if (strControlId == "" || strControlId == "Email")
        {
            strData = "Please enter your e-mailId*****txtemail";
            return false;
        }
        if (strControlId != "" && !ValidEmails(strControlId))
        {
            strData = "Please enter valid e-mailId*****txtemail";
            return false;
        }
        return true;
    }


    private bool isValidState()
    {
        if (strControlId == "" || strControlId == "Select State")
        {
            strData = "Please select state*****ddlstate";
            return false;
        }

        return true;
    }

    private bool isValidCity()
    {
        if (strControlId == "" || strControlId == "Select City")
        {
            strData = "Please select city*****ddlcity";
            return false;
        }

        return true;
    }

    private bool isValidCaptcha()
    {
        if (strControlId == "" || strControlId == "Enter Captcha*")
        {
            strData = "Please enter the captcha.*****txtCaptcha";
            return false;
        }

        if (strControlId != "" && strControlId != "Enter Captcha*" && strControlId.ToLower() != CompareValue.ToLower())
        {
            strData = "Please enter valid captcha.*****txtCaptcha";
            return false;
        }
        return true;
    }


    private bool isValidTerms()
    {
        if (strControlId == "0")
        {
            strData = "Please agree to the terms to proceed.*****chk_terms";
            return false;
        }

        return true;
    }


    public void isValidForm()
    {
        
        switch (strControlName)
        {
            case "txtname":
                flag = isValidName() ? true : false; 
                break;

            case "txtmobileNo":
                flag = isValidmobileNo() ? true : false;                
                break;

            case "txtDOB":
                flag = isValidDateofBirth() ? true : false;                 
                break;

            case "txtemail":
                flag = isValidEmail() ? true : false; 
                break;

            case "ddlstate":
                flag = isValidState() ? true : false;                
                break;

            case "ddlcity":
                flag = isValidCity() ? true : false;
                break;

            case "txtCaptcha":
                flag = isValidCaptcha() ? true : false;                                
                break;

            case "chk_terms":
                flag = isValidTerms() ? true : false;
                break;
        }
        

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

}