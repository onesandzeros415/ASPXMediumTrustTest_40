<%@ Page Language="C#" %>

<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        //Code by Matthew Costello, 08/2011 http://www.mrcostello.com 
        string path = Path.Combine(Server.MapPath("~/temp"));

        if (Directory.Exists(path))
        {
            GetFiles();
        }
        else if (!Directory.Exists(path))
        {

        }
    }
    protected void btnmakedir_Click(object sender, EventArgs e)
    {
        string path = Path.Combine(Server.MapPath("~/temp"));

        try
        {
            // Determine whether the directory exists.
            if (Directory.Exists(path))
            {
                lblInfo.Text = "That path exists already.";
            }
            else
            {
                // Try to create the directory.
                DirectoryInfo di = Directory.CreateDirectory(path);

                lblInfo.Text = "The directory was created successfully at : <br />" + path + "<br />" + Directory.GetCreationTime(path);
            }
        }
        catch (Exception ex)
        {
            lblInfo.Text = "The following failed: <br /> <br />" + ex.ToString();
        }
    }
    protected void btndeletedir_Click(object sender, EventArgs e)
    {
        string path = Path.Combine(Server.MapPath("~/temp"));

        try
        {
            if (Directory.Exists(path))
            {
                Directory.Delete(path, true);

                Page.Response.Redirect(HttpContext.Current.Request.Url.ToString(), true);

                lblInfo.Text = "The directory was deleted successfully.";

            }
            else if (!Directory.Exists(path))
            {
                lblInfo.Text = "There was no temp directory to delete.";
            }
        }
        catch (Exception ex)
        {
            lblInfo.Text = "The following failed: <br /> <br />" + ex.ToString();
        }
    }
    protected void btncreatetext_Click(object sender, EventArgs e)
    {
        try
        {
            string path = Path.Combine(Server.MapPath("~/temp"));
            string text = "A class is the most powerful data type in C#. Like structures, " + "a class defines the data and behavior of the data type. ";

            if (Directory.Exists(path))
            {
                if (!File.Exists(path + "\\WriteText.txt"))
                {
                    File.WriteAllText(path + "\\WriteText.txt", text);
                    lblInfo.Text = "Successfully Created WriteText.txt at : <br />" + path + "<br />" + Directory.GetCreationTime(path);

                    GetFiles();
                }
                else if (File.Exists(path + "\\WriteText.txt"))
                {
                    lblInfo.Text = "WriteText.txt already exists";
                }
            }
            else if (!Directory.Exists(path))
            {
                lblInfo.Text = "You Need To Make The Temp Directory First";
            }
        }
        catch (Exception ex)
        {
            lblInfo.Text = "The following failed: <br /> <br />" + ex.ToString();
        }
    }
    protected void btndeletetext_Click(object sender, EventArgs e)
    {
        string path = Path.Combine(Server.MapPath("~/" + "temp\\WriteText.txt"));

        try
        {
            if (File.Exists(path))
            {
                File.Delete(path);
                lblInfo.Text = "The file was deleted successfully.";

                GetFiles();
            }
            else if (!File.Exists(path))
            {
                lblInfo.Text = "Nothing text file to delete.";
            }
        }
        catch (Exception ex)
        {
            lblInfo.Text = "The following failed: <br /> <br />" + ex.ToString();
        }
    }
    protected void btnUpload_Click(object sender, EventArgs e)
    {
        string path = Path.Combine(Server.MapPath("~/temp"));

        try
        {
            //check to make sure a file is selected
            if (FileUpload1.HasFile)
            {
                if (Directory.Exists(path))
                {
                    //create the path to save the file to
                    string fileName = Path.Combine(Server.MapPath("~/temp"), FileUpload1.FileName);
                    //save the file to our local path
                    FileUpload1.SaveAs(fileName);
                    lblInfo.Text = "The file was uploaded successfully.";

                    imagePrint();

                    GetFiles();
                }
                else
                {
                    lblInfo.Text = "In order to upload this image please make a temp directory.";
                }
            }
            else if (!FileUpload1.HasFile)
            {
                if (!Directory.Exists(path))
                {
                    lblInfo.Text = "Please select a file to upload.";
                }
                else if (Directory.Exists(path))
                {
                    lblInfo.Text = "Please select a file to upload";
                }
            }

        }
        catch (Exception ex)
        {
            lblInfo.Text = "The following failed: <br /> <br />" + ex.ToString();
        }
    }
    protected void btnupdatefilelist_Click(object sender, EventArgs e)
    {
        string path = Path.Combine(Server.MapPath("~/temp"));

        try
        {
            if (Directory.Exists(path))
            {
                imagePrint();
                GetFiles();
            }
            else if (!Directory.Exists(path))
            {
                lblInfo.Text = "There is no temp directory.";
            }
        }
        catch (Exception ex)
        {
            lblInfo.Text = "The following failed: <br /> <br />" + ex.ToString();
        }
    }
    protected void btndeletefile_Click(object sender, EventArgs e)
    {
        string path = this.ddl2.Text.ToString();
        try
        {
            if (File.Exists(path))
            {
                File.Delete(path);
                lblInfo.Text = "The file was deleted successfully.";

                imagePrint();
                GetFiles();
            }
            else if (!Directory.Exists(path))
            {
                lblInfo.Text = "There is no temp directory.";
            }
            else
            {
                lblInfo.Text = "Nothing to delete.  Try again.";
            }
        }
        catch (Exception ex)
        {
            lblInfo.Text = "The following failed: <br /> <br />" + ex.ToString();
        }
    }
    protected void btnpwd_Click(object sender, EventArgs e)
    {
        string path = Server.MapPath(".") + "\\temp";

        lblIPHost.Text = path.ToString();
    }
    public void GetFiles()
    {
        //string dir = this.ddl1.Text;
        //string windows = @ConfigurationManager.AppSettings["ServerDirectory"];
        string windows = Path.Combine(Server.MapPath("~/"));

        string path = windows + "\\temp";

        string[] fileinfo = Directory.GetFiles(path, "*.*");

        try
        {
            ddl2.DataSource = fileinfo;
            ddl2.DataBind();
        }
        catch (Exception ex)
        {
            lblInfo.Text = "The following failed: <br /> <br />" + ex.ToString();
        }
    }
    public void imagePrint()
    {
        string[] filesindirectory = Directory.GetFiles(Server.MapPath("~/temp"));
        List<String> images = new List<string>(filesindirectory.Count());

        foreach (string item in filesindirectory)
        {
            images.Add(String.Format("~/temp/{0}", System.IO.Path.GetFileName(item)));
        }

        RepeaterImages.DataSource = images;
        RepeaterImages.DataBind();
    }
    protected void btniphost_Click(object sender, EventArgs e)
    {
        string host = Environment.MachineName;

        try
        {
            // get host IP addresses
            IPAddress[] hostIPs = Dns.GetHostAddresses(host);
            // get local IP addresses
            IPAddress[] localIPs = Dns.GetHostAddresses(Dns.GetHostName());

            // test if any host IP equals to any local IP or to localhost
            foreach (IPAddress hostIP in hostIPs)
            {
                // is localhost
                if (IPAddress.IsLoopback(hostIP))
                {
                    lblIPHost.Text = "Host IP: " + hostIP.ToString() + "<br />" + "HostName:  " + host;
                };
                // is local address
                foreach (IPAddress localIP in localIPs)
                {
                    if (hostIP.Equals(localIP))
                    {
                        lblIPHost.Text = "Local IP: " + localIP.ToString() + "<br />" + "HostName:  " + host;
                    }
                }
            }
        }
        catch
        {
        }
    }
    void btnSubmit_Click(Object sender, EventArgs e)
    {
        try
        {
            string userName = UserNameText.Text.ToString();
            string password = PasswordText.Text.ToString();

            MailMessage objEmail = new MailMessage();

            objEmail.To.Add(txtTo.Text);
            objEmail.From = new MailAddress(txtFrom.Text);
            objEmail.Subject = "Test Email using System.Net.Mail Assembly.";
            objEmail.Body = txtComments.Text.ToString();
            objEmail.Priority = MailPriority.High;

            // Make sure you have appropriate replying permissions from your local system



            if (SmtpAuthCheck.Checked)
            {
                if (SSLCheck.Checked)
                {
                    SmtpClient smtp = new SmtpClient();
                    smtp.EnableSsl = true;
                    smtp.Host = MailServerText.Text.ToString();
                    smtp.Port = 25;
                    smtp.Credentials = new System.Net.NetworkCredential(UserNameText.Text.ToString(), PasswordText.Text.ToString());

                    smtp.Send(objEmail);
                    lblsmtpinfo.Text = "Your Email has been sent sucessfully using SMTP Authentication with SSL - Thank You";
                }
                else if (!SSLCheck.Checked)
                {
                    SmtpClient smtp = new SmtpClient();
                    smtp.Host = MailServerText.Text.ToString();
                    smtp.Port = 25;
                    smtp.Credentials = new System.Net.NetworkCredential(UserNameText.Text.ToString(), PasswordText.Text.ToString());

                    smtp.Send(objEmail);
                    lblsmtpinfo.Text = "Your Email has been sent sucessfully using SMTP Authentication without SSL - Thank You";

                }

            }
            else if (!SmtpAuthCheck.Checked)
            {
                SmtpClient smtp = new SmtpClient();
                smtp.Host = "localhost";
                smtp.Send(objEmail);
                lblsmtpinfo.Text = "Your Email has been sent sucessfully using Openrelays - Thank You";
            }

        }
        catch (Exception exc)
        {
            lblsmtpinfo.Text = "Send failure: " + exc.ToString();
        }
    }
    void btnSubmit_sql_Click(Object sender, EventArgs e)
    {
        try
        {
            string hname = Hostname.Text;
            string dbname = Dbname.Text;
            string username = Username.Text;
            string pword = Password.Text;


            string ConnectionString = "Server=" + hname + ";Database=" + dbname + ";Uid=" + username + ";Pwd=" + pword;

            using (SqlConnection cn = new SqlConnection(ConnectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM sys.Tables", cn);
                cn.Open();
                SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                rdr.Read();

                GridView1.DataSource = rdr;
                GridView1.DataBind(); //read a value

                TotalRec.Text = GridView1.Rows.Count.ToString() + " Records";
            }
        }
        catch (Exception exc)
        {
            lblsqlinfo.Text = "Trouble Connecting to MSSQL: " + exc.ToString();
        }
    }
</script>
<head id="Head1" runat="server">
    <title>ASP.NET 4.0 Test!</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align: center; width: 600px; border: 1px solid black; margin-left: auto; margin-right: auto; font-size: 12px; font-family: Arial;">
            <br />
            This test makes use of System.IO Assembly for creating diretories, file uploads,
        <br />
            and creating text files.
        <br />
            <br />
            To ensure this test works correctly please ensure you have the correct 
        permissions setup within your hosting environment to allow for reading and writing.
        <br />
            <br />
            For Rackspace CloudSites Customers:<br />
            <br />
            Please make sure that <a href="http://www.rackspace.com/knowledge_center/index.php/How_do_I_add_impersonation_to_my_ASP.NET_site" target="_blank">impersonation </a> is enabled via web.config in the system.Web element:
        <br />
                <br />
                &lt;identity impersonate="true" username="ord\USERNAME" password="PASSWORD" /&gt;
        
        <br />
                &lt;identity impersonate="true" username="dfw\USERNAME" password="PASSWORD" /&gt;
        <br />
                <br />
                This TEST will only work on with .NET 4.0<br />
                <br />
                Instructions:
        
        <br />
                Step 1. Make directory
        <br />
                Step 2. Make text file
        <br />
                Step 3. Delete text file
        <br />
                Step 4. Delete Directory
        <br />
                <br />
                If uploading:
        <br />
                Step 1. Make directory
        <br />
                Step 2. Upload file.<br />
                <br />
                <asp:Label runat="server" ID="lblInfo" ForeColor="Red" Text="" />
                <br />
                <br />
                <asp:Button runat="server" ID="btnmakedir" OnClick="btnmakedir_Click" Text="Make Temp Directory" />
                <asp:Button runat="server" ID="btndeletedir" OnClick="btndeletedir_Click" OnClientClick="window.location.reload();"
                    Text="Delete Temp Directory" />
                <asp:Button runat="server" ID="btncreatetext" OnClick="btncreatetext_Click" Text="Create Text File" />
                <asp:Button runat="server" ID="btndeletetext" OnClick="btndeletetext_Click" Text="Delete Text File" />
                <br />
                <br />
                <div>
                    <asp:FileUpload ID="FileUpload1" runat="server" />
                    <asp:Button ID="btnUpload" runat="server" Text="Upload" OnClick="btnUpload_Click" />
                    <br />
                </div>
                <br />
                <br />
                <br />
                Files:
        <asp:DropDownList ID="ddl2" runat="server" />
                <br />
                <br />
                <asp:Button runat="server" ID="btnupdatefilelist" OnClick="btnupdatefilelist_Click"
                    Text="Manually Update File List" />
                <br />
                <asp:Button runat="server" ID="btndeletefile" OnClick="btndeletefile_Click" Text="Delete File" />
                <br />
                <br />
                <asp:Label runat="server" ID="lblIPHost" ForeColor="Red" Text="" />
                <br />
                <br />
                <asp:Button runat="server" ID="pwd" OnClick="btnpwd_Click" Text="PWD" />
                <br />
                <asp:Button runat="server" ID="btniphost" OnClick="btniphost_Click" Text="Get Local IP and Hostname" />
                <br />
        </div>
        <div style="text-align: center;">
            <br />
            <br />
            <asp:Repeater ID="RepeaterImages" runat="server">
                <ItemTemplate>
                    <asp:Image ID="Image" runat="server" ImageUrl='<%# Container.DataItem %>' />
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <br />
        <div style="text-align: center; width: 600px; border: 1px solid black; margin-left: auto; margin-right: auto; font-size: 12px; font-family: Arial;">
            <h1>Test MSSQL Connectivity
            </h1>
            <p>
                Please keep in mind the differences in hostnames:
            <br />
                <br />
                Internal to Rackspace: mssql0814.wc2\inst2
            <br />
                External to Rackspace: 174.143.28.36,4120
            </p>
            <center>
            <table>
                <tr>
                    <td>
                        Enter Hostname:
                    </td>
                    <td>
                        <asp:TextBox runat="server" Height="25px" Width="215px" ID="Hostname" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Enter Database Name:
                    </td>
                    <td>
                        <asp:TextBox runat="server" Height="25px" Width="215px" ID="Dbname" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Enter Username:
                    </td>
                    <td>
                        <asp:TextBox runat="server" Height="25px" Width="215px" ID="Username" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Enter Password:
                    </td>
                    <td>
                        <asp:TextBox runat="server" Height="25px" Width="215px" ID="Password" TextMode="Password" />
                    </td>
                </tr>
            </table>
            <br />
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="Name"
                BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px"
                CellPadding="4" ForeColor="Black" GridLines="Horizontal">
                <Columns>
                    <asp:BoundField DataField="Name" HeaderText="Name" ReadOnly="True" SortExpression="Name" />
                </Columns>
            </asp:GridView>
            <br />
            Total Records:
            <asp:Label ID="TotalRec" runat="server" Text=""></asp:Label>
            <br />
            <br />
            <asp:Label runat="server" ID="lblsqlinfo" ForeColor="Red" Text="" />
            <br />
            <br />
            <asp:Button runat="server" ID="sqlbtn" OnClick="btnSubmit_sql_Click" Text="Retrieve Info">
            </asp:Button>
        </center>
            <br />
        </div>
        <br />
        <br />
        <br />
        <div style="text-align: center; width: 600px; border: 1px solid black; margin-left: auto; margin-right: auto; font-size: 12px; font-family: Arial;">
            <h1>Send Mail using System.Net.Mail assembly.</h1>
            <div style="width: 350px; margin-left: auto; margin-right: auto;">
                This script makes use of the System.Net.Mail assembly.
            <br />
                <br />
                <table border="0" width="350">
                    <tr>
                        <td valign="top">To
                        </td>
                        <td style="height: 24px;" valign="top">
                            <asp:TextBox runat="server" Height="22px" Width="212px" ID="txtTo"></asp:TextBox>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">From
                        </td>
                        <td style="height: 24px;">
                            <asp:TextBox runat="server" Height="22px" Width="213px" ID="txtFrom"></asp:TextBox>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center;" colspan="2">
                            <br />
                            Use SMTP Authenticaion?<br />
                            <asp:CheckBox ID="SmtpAuthCheck" runat="server" />
                            <br />
                            Use SSL?<br />
                            <asp:CheckBox ID="SSLCheck" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">Mail Server
                        </td>
                        <td style="height: 24px;" valign="top">
                            <asp:TextBox runat="server" Height="22px" Width="210px" ID="MailServerText"></asp:TextBox>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">Username
                        </td>
                        <td style="height: 24px;" valign="top">
                            <asp:TextBox runat="server" Height="22px" Width="210px" ID="UserNameText"></asp:TextBox>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">Password
                        </td>
                        <td style="height: 24px;" valign="top">
                            <asp:TextBox runat="server" Height="22px" Width="210px" ID="PasswordText" TextMode="Password"></asp:TextBox>
                            <br />
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <font face="Verdana" size="2">Comments:</font>
                        </td>
                        <td style="height: 112px;">
                            <asp:TextBox runat="server" Height="107px" TextMode="MultiLine" Width="206px" ID="txtComments"></asp:TextBox>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Label runat="server" ID="lblsmtpinfo" ForeColor="Red" Text="" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center; height: 30px;" valign="top">
                            <asp:Button runat="server" ID="btnSubmit" OnClick="btnSubmit_Click" Text="Submit"></asp:Button>
                            &nbsp;<input id="Reset1" type="reset" runat="server" value="Clear" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
