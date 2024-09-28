<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_6_2#></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/itoggle.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script>
var $j = jQuery.noConflict();

$j(document).ready(function() {
	init_itoggle('help_enable');
	init_itoggle('enable_auto_sleep');
});

</script>
<script>

<% login_state_hook(); %>

function initial(){
	show_banner(1);
	show_menu(5,7,1);
	show_footer();

	document.form.http_passwd2.value = "";

	if (login_safe()){
		showhide_div('row_user', 1);
		showhide_div('row_pass1', 1);
		showhide_div('row_pass2', 1);
	}

	load_body();
}

function applyRule(){
	if(validForm()){
		showLoading();
		if(document.form.http_passwd2.value.length > 0)
			document.form.http_passwd.value = document.form.http_passwd2.value;
		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "Advanced_System_Content.asp";
		document.form.next_page.value = "";
		
		document.form.submit();
	}
}
function applyRule2(){
		showLoading();
	document.form.action_mode.value = " ApplyApn ";
		document.form.current_page.value = "Advanced_System_Content.asp";
		document.form.next_page.value = "";
		document.form.submit();
}
/*
function applyRuleLang(){
	showLoading();
	document.form.action_mode.value = " ApplyLang ";
	document.form.current_page.value = "Advanced_System_Content.asp";
	document.form.next_page.value = "";
	document.form.submit();
}
*/

function validate_password(){
	var password = document.form.http_passwd2.value;
	var number=false;
	var alphabet=false;
	var specialchar=false;

	for(var i = 0; i < password.length; ++i){
		if(password.charAt(i) < '!' || password.charAt(i) > '~') {
			alert(<#Alert_String0#>);
			return false;
		}
	
		if('!' <=  password.charAt(i) && password.charAt(i) <= '/')
			specialchar = true;
		if(':' <=  password.charAt(i) && password.charAt(i) <= '@')
			specialchar = true;
		if('[' <=  password.charAt(i) && password.charAt(i) <= '`')
			specialchar = true;
		if('{' <=  password.charAt(i) && password.charAt(i) <= '~')
			specialchar = true;

		if('0' <=  password.charAt(i) && password.charAt(i) <= '9')
			number = true;

		if('A' <=  password.charAt(i) && password.charAt(i) <= 'Z')
			alphabet = true;
		if('a' <=  password.charAt(i) && password.charAt(i) <= 'z')
			alphabet = true;
	}

	if(number==false) {
		alert(<#Alert_String1#>);
		return false;
	}
	if(specialchar==false) {
		alert(<#Alert_String2#>);
		return false;
	}
	if(alphabet==false) {
		alert(<#Alert_String3#>);
		return false;
	}
	
	var odpasswd = '<% nvram_get_x("",  "http_passwd"); %>';
	if(password == odpasswd){
		alert(<#Alert_String4#>);
		return false;
	}
	var odpasswd = '<% nvram_get_x("",  "http_passwd"); %>';
	if(password == odpasswd){
		alert(<#Alert_String4#>);
		return false;
	}
	var SERIALNO = "#ab@" +'<% nvram_get_x("",  "serialno"); %>';
	if(password == SERIALNO){
		alert(<#Alert_String5#>);
		return false;
	}
	return true;
}


function validForm(){

	if(document.form.http_username.value.length < 6) {
		alert(<#Alert_String6#>);
		return false;
	}

	if(!validate_string(document.form.http_username))
		return false;

	if(!validate_string(document.form.http_passwd2) || !validate_string(document.form.v_password2))
		return false;

	if(document.form.http_passwd2.value != document.form.v_password2.value){
		showtext($("alert_msg"),"*<#File_Pop_content_alert_desc7#>");
		document.form.http_passwd2.focus();
		document.form.http_passwd2.select();
		return false;
	}

	if(document.form.http_passwd2.value.length<8) {
		alert(<#Alert_String7#>);
		return false;
	}

	if(!validate_password())
		return false;

	if(document.form.http_passwd2.value.length > 0)
		alert("<#File_Pop_content_alert_desc10#>");

	return true;
}

function done_validating(action){
	refreshpage();
}

function blanktest(obj, flag){
	var value2 = eval("document.form."+flag+"2.value");

	if(obj.value == ""){
		if(value2 != "")
			obj.value = decodeURIComponent(value2);
		else
			obj.value = "";
		
		alert("<#JS_Shareblanktest#>");
		
		return false;
	}

	return true;
}

function openLink(s) {
	var link_params = "toolbar=yes,location=yes,directories=no,status=yes,menubar=yes,scrollbars=yes,resizable=yes,copyhistory=no,width=640,height=480";
	var tourl = "http://support.ntp.org/bin/view/Servers/WebHome";
	link = window.open(tourl, "NTPLink", link_params);
	if (!link.opener) link.opener = self;
}

</script>
<style>
    .table th, .table td{vertical-align: middle;}
    .table input, .table select {margin-bottom: 0px;}
</style>
</head>

<body onload="initial();" onunLoad="return unload_body();">

<div class="wrapper">
    <div class="container-fluid" style="padding-right: 0px">
        <div class="row-fluid">
            <div class="span3">
                <center>
                    <div id="logo"></div>
                    <div id="company_name"><#Company_Name#></div>
                    <div id="product_name"><#Product_Name#></div>
                    <div id="model_name"><#Model_Name#></div>
                    <div id="model_name1"><#Model_Name1#></div>
                </center>
            </div>
            <div class="span9" >
                <div id="TopBanner"></div>
            </div>
        </div>
    </div>

    <div id="Loading" class="popup_bg"></div>

    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
    <form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
    <input type="hidden" name="current_page" value="Advanced_System_Content.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="LANHostConfig;General;Storage;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="">

    <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get_x("", "preferred_lang"); %>">
    <input type="hidden" name="http_passwd" value="">

    <div class="container-fluid">
        <div class="row-fluid">
            <div class="span3">
                <!--Sidebar content-->
                <!--=====Beginning of Main Menu=====-->
                <div class="well sidebar-nav side_nav" style="padding: 0px;">
                    <ul id="mainMenu" class="clearfix"></ul>
                    <ul class="clearfix">
                        <li>
                            <div id="subMenu" class="accordion"></div>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="span9">
                <!--Body content-->
                <div class="row-fluid">
                    <div class="span12">
                        <div class="box well grad_colour_dark_blue">
                            <h2 class="box_head round_top"><#menu5_6#> - <#menu5_6_2#></h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
                                    <div class="alert alert-info" style="margin: 10px;"><#Adm_System_desc#></div>

                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;"><#Adm_System_ident#></th>
                                        </tr>
                                        <tr id="row_user" style="display:none">
                                            <th  width="50%"><#Adm_System_admin#></th>
                                            <td>
                                                <input type="text" name="http_username" class="input" autocomplete="off" maxlength="32" size="25" onKeyPress="return is_string(this,event);" />
                                            </td>
                                        </tr>
                                        <tr id="row_pass1" style="display:none">
                                            <th  width="50%"><a class="help_tooltip"  href="javascript:void(0);" onmouseover="openTooltip(this,11,4)"><#PASS_new#></a></th>
                                            <td>
                                                <input type="password" name="http_passwd2" class="input" autocomplete="off" maxlength="32" size="25" onKeyPress="return is_string(this,event);"/>
                                            </td>
                                        </tr>
                                        <tr id="row_pass2" style="display:none">
                                            <th  width="50%"><a class="help_tooltip"  href="javascript:void(0);" onmouseover="openTooltip(this,11,4)"><#PASS_retype#></a></th>
                                            <td>
                                                <input type="password" name="v_password2" class="input" autocomplete="off" maxlength="32" size="25" onKeyPress="return is_string(this,event);"/><br/><span id="alert_msg"></span>
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;">
                                                <center><input class="btn btn-primary" style="width: 219px" onclick="applyRule();" type="button" value="<#CTL_apply#>" /></center>
                                            </td>
                                        </tr>
                                    </table>

                                    
<!--                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;">APN</th>
                                        </tr>
                                        <tr>
                                            <th>APN: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
                                            
                                            <td>
                                                <input id="modem_apn" name="modem_apn" maxlength="64" class="input" type="text" value="<% nvram_get_x("","modem_apn"); %>"/>
                                            </td>
                                        </tr>

                                    </table>
                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;">
                                                <center><input class="btn btn-primary" style="width: 219px" onclick="applyRule2();" type="button" value="<#CTL_apply#>" /></center>
                                            </td>
                                        </tr>
                                    </table>-->
 
                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;"><#Language#></th>
                                        </tr>

                                        <tr>
                                            <th width="50%"><#PASS_LANG#></th>
                                            <td>
                                                <select " name="select_lang" id="select_lang" onchange="submit_language();">
                                                    <% shown_language_option(); %>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;">
                                                <center><input class="btn btn-primary" style="width: 219px" onclick="applyRuleLang();" type="button" value="<#CTL_apply#>" /></center>
                                            </td>
                                        </tr>
                                    </table>
								
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    </form>

    <div id="footer"></div>
</div>
</body>
</html>
