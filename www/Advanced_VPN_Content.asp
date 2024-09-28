<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_2_3#></title>
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
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script>
var $j = jQuery.noConflict();


$j(document).ready(function() {
	//init_itoggle('dhcp_enable_x');
});

</script>
<script>

function initial(){
	show_banner(1);
	show_menu(5,3,3);
	show_footer();

	if (!checkSERIALNO())
	    return;

	document.form.sslvpnEnbl.value= '<% nvram_get_x("", "sslvpnEnbl"); %>'
	//document.form.sslvpnmode.value= '<% nvram_get_x("", "sslvpnmode"); %>'

	sslvpnUpdateState();

	load_body();
}

function applyRule(){
	if(validForm()){
		showLoading();
		
		document.form.action_mode.value = " Restart ";
		document.form.current_page.value = "Advanced_VPN_Content.asp";
		document.form.next_page.value = "";
		
		document.form.submit();
	}
}

function validForm(){
	return true;
}

function changeBgColor(obj, num){
	$("row" + num).style.background=(obj.checked)?'#D9EDF7':'whiteSmoke';
}

function sslvpnUpdateState_onbutton()
{
	sslvpnUpdateState();
	
	//if(document.lanCfg.sslvpnEnbl.options.selectedIndex == 1 || document.lanCfg.sslvpnEnbl.options.selectedIndex == 2) {
		//alert("");
	//}
}

function sslvpnUpdateState()
{
	if (document.form.sslvpnEnbl.value == "disable"){
		showhide_div('secuwiz_section', '0');	
		showhide_div('axgate_section1', '0');
		showhide_div('axgate_section2', '0');
	}
	else if (document.form.sslvpnEnbl.value == "secuwiz"){
		showhide_div('secuwiz_section', '1');	
		showhide_div('axgate_section1', '0');
		showhide_div('axgate_section2', '0');
	}
	else if (document.form.sslvpnEnbl.value == "axgate"){
		showhide_div('secuwiz_section', '0');	
		showhide_div('axgate_section1', '1');
		showhide_div('axgate_section2', '0');
	}
	else if (document.form.sslvpnEnbl.value == "dual_axgate"){
		showhide_div('secuwiz_section', '0');	
		showhide_div('axgate_section1', '1');
		showhide_div('axgate_section2', '1');
	}
	else {
		showhide_div('secuwiz_section', '0');	
		showhide_div('axgate_section1', '0');
		showhide_div('axgate_section2', '0');
	}
}


</script>
<style>
.table-list td {
    padding: 6px 8px;
}
.table-list input,
.table-list select {
    margin-top: 0px;
    margin-bottom: 0px;
}
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

    <input type="hidden" name="current_page" value="Advanced_VPN_Content.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="vpn_agent">

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
                            <h2 class="box_head round_top"><#menu5_2#> - <#menu5_2_3#></h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
                                    <div class="alert alert-info" style="margin: 10px;"><#LANHostConfig_VPNAgent_sectiondesc#></div>
                                    <div id="router_in_pool" class="alert alert-danger" style="display:none; margin: 10px;"><b><#LANHostConfig_VPNAgent_sectiondesc2#> <span id="LANIP"></span></b></div>

                                    <table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;">VPN Agent Control</th>
                                        </tr>

						<tr id="sslvpn">
                                            <th>VPN Enable?</th>						  
						  <td>
						    <select onChange="sslvpnUpdateState_onbutton()" name="sslvpnEnbl">
						        <option value="disable">Disable</option>
						        <option value="secuwiz">Enable Secuwiz VPN</option>
						        <option value="axgate">Enable Axgate VPN</option>
						        <!-- <option value="dual_axgate">Enable Dual Axgate VPN</option> --> 
						    </select>
						  </td>
						</tr>
						<!--
						<tr id="div_vpnMode">
                                            <th>VPN Mode</th>						  
						  <td>
						    <select onChange="sslvpnUpdateState()" name="sslvpnmode" >  
						        <option value="staticipmode">Static IP Mode</option>
						        <option value="natmode">NAT Mode</option>
						    </select>
						  </td>
						</tr>
						-->
                                    <table width="100%" cellpadding="4" cellspacing="0" class="table" id="secuwiz_section">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;">Secuwiz VPN</th>
                                        </tr>
						<tr>
                                            <th>VPN User ID</th>						  
						  <td><input type="text" name="scw_userid" class="input" value="<% nvram_get_x("", "scw_userid"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN User Password</th>						  
						  <td><input type="text" name="scw_userpw" class="input" value="<% nvram_get_x("", "scw_userpw"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Server IP</th>						  
						  <td><input type="text" name="scw_svrip" class="input" value="<% nvram_get_x("", "scw_svrip"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Server Port</th>						  
						  <td><input type="text" name="scw_svrport" class="input" value="<% nvram_get_x("", "scw_svrport"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN crypto</th>						  
						  <td><input type="text" name="scw_crypto" class="input" value="<% nvram_get_x("", "scw_crypto"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN log Size</th>						  
						  <td><input type="text" name="scw_logsize" class="input" value="<% nvram_get_x("", "scw_logsize"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN version3</th>						  
						  <td><input type="text" name="scw_version3" class="input" value="<% nvram_get_x("", "scw_version3"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN site-to-site</th>						  
						  <td><input type="text" name="scw_sitetosite" class="input" value="<% nvram_get_x("", "scw_sitetosite"); %>"> </td>
						</tr>
                                    </table>
					
                                    <table width="100%" cellpadding="4" cellspacing="0" class="table" id="axgate_section1">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;">Axgate VPN</th>
                                        </tr>
						<tr>
                                            <th>VPN User ID</th>						  
						  <td><input type="text" name="axg_userid1" class="input" value="<% nvram_get_x("", "axg_userid1"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Key</th>						  
						  <td><input type="text" name="axg_key1" class="input" value="<% nvram_get_x("", "axg_key1"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Mode: (TCP, UDP)</th>						  
						  <td><input type="text" name="axg_opmode1" class="input" value="<% nvram_get_x("", "axg_opmode1"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Server IP</th>						  
						  <td><input type="text" name="axg_svrip1" class="input" value="<% nvram_get_x("", "axg_svrip1"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Server Port</th>						  
						  <td><input type="text" name="axg_svrport1" class="input" value="<% nvram_get_x("", "axg_svrport1"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Queue Size</th>						  
						  <td><input type="text" name="axg_queue1" class="input" value="<% nvram_get_x("", "axg_queue1"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Encyption (Ex: aes128 sha1)</th>						  
						  <td><input type="text" name="axg_enc1" class="input" value="<% nvram_get_x("", "axg_enc1"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN KeepAlive Interval</th>						  
						  <td><input type="text" name="axg_interval1" class="input" value="<% nvram_get_x("", "axg_interval1"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN KeepAlive Threshold</th>						  
						  <td><input type="text" name="axg_threshold1" class="input" value="<% nvram_get_x("", "axg_threshold1"); %>"> </td>
						</tr>
                                    </table>
					
                                    <table width="100%" cellpadding="4" cellspacing="0" class="table" id="axgate_section2">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;">Axgate VPN 2</th>
                                        </tr>
						<tr>
                                            <th>VPN User ID</th>						  
						  <td><input type="text" name="axg_userid2" class="input" value="<% nvram_get_x("", "axg_userid2"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Key</th>						  
						  <td><input type="text" name="axg_key2" class="input" value="<% nvram_get_x("", "axg_key2"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Mode: (TCP, UDP)</th>						  
						  <td><input type="text" name="axg_opmode2" class="input" value="<% nvram_get_x("", "axg_opmode2"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Server IP</th>						  
						  <td><input type="text" name="axg_svrip2" class="input" value="<% nvram_get_x("", "axg_svrip2"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Server Port</th>						  
						  <td><input type="text" name="axg_svrport2" class="input" value="<% nvram_get_x("", "axg_svrport2"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Queue Size</th>						  
						  <td><input type="text" name="axg_queue2" class="input" value="<% nvram_get_x("", "axg_queue2"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN Encyption (Ex: aes128 sha1)</th>
						  <td><input type="text" name="axg_enc2" class="input" value="<% nvram_get_x("", "axg_enc2"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN KeepAlive Interval</th>						  
						  <td><input type="text" name="axg_interval2" class="input" value="<% nvram_get_x("", "axg_interval2"); %>"> </td>
						</tr>
						<tr>
                                            <th>VPN KeepAlive Threshold</th>						  
						  <td><input type="text" name="axg_threshold2" class="input" value="<% nvram_get_x("", "axg_threshold2"); %>"> </td>
						</tr>
                                    </table>

                                    </table>

                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;"><center><input name="button" type="button" class="btn btn-primary" style="width: 219px" onclick="applyRule();" value="<#CTL_apply#>"/></center></td>
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
