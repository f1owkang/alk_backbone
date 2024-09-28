<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_5_1#></title>
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

init_itoggle('ipfilter_enable', change_ipfilter_enabled);
});

function change_ipfilter_enabled() {
    var v = document.form.ipfilter_enable[0].checked;
    showhide_div('ipfilterip', v);
}

</script>
<script>
var IFList = [<% get_nvram_list("FirewallConfig", "IFList"); %>];
//var http_proto = '<% nvram_get_x("", "http_proto"); %>';

function initial(){
	show_banner(1);
	show_menu(5,5,5);
	show_footer();

    if(!checkSERIALNO())
        return;
	load_body();
	change_ipfilter_enabled();
	showIFList();

	
}
function valid_LAN_IP(ip_obj) {
    // A : 1.0.0.0~126.255.255.255
    // B : 127.0.0.0~127.255.255.255 (forbidden)
    // C : 128.0.0.0~255.255.255.254
    var A_class_min = inet_network("1.0.0.0");
    var A_class_max = inet_network("126.255.255.255");
    var B_class_min = inet_network("127.0.0.0");
    var B_class_max = inet_network("127.255.255.255");
    var C_class_min = inet_network("128.0.0.0");
    var C_class_max = inet_network("255.255.255.255");

    var ip_num = inet_network(ip_obj.value);

    if (ip_num > A_class_min && ip_num < A_class_max)
        return true;
    else if (ip_num > B_class_min && ip_num < B_class_max)
        return false;
    else if (ip_num > C_class_min && ip_num < C_class_max)
        return true;
    return false;
}
//function change_ipf_enabled() {
//    var v = document.form.ipf_enable[0].checked;
//    showhide_div("VSList_Block", v);
//   showhide_div("ip_filter_line", v);
//    //	showhide_div("row_famous_game", v);
//}
function applyRule(){
	//if(validForm())
	{
		showLoading();
		
		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "Advanced_IPFiltering.asp";
		document.form.next_page.value = "";
		document.form.group_id.value = "IFList";
		document.form.submit();
	}
}
function markGroupIP(o, c, b) {
    document.form.group_id.value = "IFList";
    if (b == " Add ") {
        if (validForm() == false)
            return false;
        if (validNewRow(c) == false)
            return false;

        //updateDT();
    }
    pageChanged = 0;
    document.form.action_mode.value = b;
    return true;
}
function validNewRow(max_rows) {
    if (document.form.ipfilter_num_x_0.value >= max_rows) {
        alert("<#JS_itemlimit1#> " + max_rows + " <#JS_itemlimit2#>");
        return false;
    }

    if (document.form.ipfilter_list_x_0.value == "") {
        alert("<#JS_fieldblank#>");
        document.form.ipfilter_list_x_0.focus();
        document.form.ipfilter_list_x_0.select();
        return false;
    }

//    if (!validate_hwaddr(document.form.ipfilter_list_x_0)) {
//        return false;
//    }



    return true;
}
function showIFList(){
	var code = '';
	if(IFList.length == 0) {
		code +='<tr><td colspan="4" style="text-align: center;"><div class="alert alert-info"><#IPConnection_VSList_Norule#></div></td></tr>';
		

	}
	else{
	    for(var i = 0; i < IFList.length; i++){
		code +='<tr id="row' + i + '">';
		code += '<td width="45%">&nbsp;</td>';
		code +='<td width="50%">&nbsp;' + IFList[i][0] + '</td>';
		
		code +='<td width="5%" style="text-align: right;"><input type="checkbox" name="IFList_s" value="' + i + '" onClick="changeBgColor(this,' + i + ');" id="check' + i + '"></td>';
		code +='</tr>';
	    }
		code += '<tr>';
		code += '<td width="50%">&nbsp;</td>'
		code += '<td width="45%">&nbsp;</td>'
		code += '<td width="5%" style="text-align: right;"><button class="btn btn-danger" type="submit" onclick="return markGroupIP(this, 64, \' Del \');" name="IFList"><i class="icon icon-minus icon-white"></i></button></td>';
		code += '</tr>'
		
		var last_row = IFList.length - 1;

	}


	$j('#IFList_Block').append(code);
}
function validForm() {
    var addr_obj = document.form.ipfilter_list_x_0;
 
    if (!valid_LAN_IP(addr_obj)) {
        alert(addr_obj.value + " <#JS_validip#>");
        addr_obj.focus();
        addr_obj.select();
        return false;
    }

//	if (sw_mode == '4')
//		return true;

//	if (support_http_ssl()){
//		if (http_proto == "0" || http_proto == "2"){
//			if(!validate_range(document.form.misc_httpport_x, 80, 65535))
//				return false;
//		}
//		if (http_proto == "1" || http_proto == "2"){
//			if(!validate_range(document.form.https_wport, 81, 65535))
//				return false;
//		}
//		if (http_proto == "2"){
//			if (document.form.misc_httpport_x.value == document.form.https_wport.value){
//				alert("HTTP and HTTPS ports is equal!");
//				document.form.https_wport.focus();
//				document.form.https_wport.select();
//				return false;
//			}
//		}
//	}else{
//		if(!validate_range(document.form.misc_httpport_x, 80, 65535))
//			return false;
//	}

//	if(!validate_range(document.form.udpxy_wport, 1024, 65535))
//		return false;

//	if(found_app_sshd()){
//		if(!validate_range(document.form.sshd_wport, 22, 65535))
//			return false;
//	}

//	if(found_app_ftpd()){
//		if(!validate_range(document.form.ftpd_wport, 21, 65535))
//			return false;
//	}

	return true;
}



</script>
<style>
    .nav-tabs > li > a {
          padding-right: 6px;
          padding-left: 6px;
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

    <input type="hidden" name="current_page" value="Advanced_IPFiltering.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="FirewallConfig;">
    <input type="hidden" name="group_id" value="IFList">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="">
    <input type="hidden" name="ipfilter_num_x_0" value="<% nvram_get_x("", "ipfilter_num_x"); %>" readonly="1" />

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
                            <h2 class="box_head round_top"><#menu5_5#> - <#menu5_5_8#></h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
                                   <!-- <div class="alert alert-info" style="margin: 10px;"><#FirewallConfig_display2_sectiondesc#></div>-->

                                    <table width="100%" cellpadding="4" cellspacing="0" class="table" id="IFList_Block">
                                                                            

                                        <tr>
                                            <th width="50%"><a class="help_tooltip"><#menu5_5_8#></a></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="ipfilter_enable_on_of">
                                                        <input type="checkbox" id="ipfilter_enable_fake" <% nvram_match_x("", "ipfilter_enable", "1", "value=1 checked"); %><% nvram_match_x("", "ipfilter_enable", "0", "value=0"); %> />
                                                    </div>
                                                </div>

                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" value="1" name="ipfilter_enable" id="ipfilter_enable_1" <% nvram_match_x("", "ipfilter_enable", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" value="0" name="ipfilter_enable" id="ipfilter_enable_0" <% nvram_match_x("", "ipfilter_enable", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        
                                         <tr id="ipfilterip" >  
                                            <th width="45%" style="border-top: 0 none;"><#IP_ADD#></a></th>
                                            <td width="45%"style="border-top: 0 none;">
                                                <input type="text" maxlength="15" class="input" size="15" id="ipfilter_list_x_0" name="ipfilter_list_x_0" value="<% nvram_get_x("","ipfilter_list_x_0"); %>" onKeyPress="return is_ipaddr(this,event);" />
                                               
                                            </td>
                                            <td width="10%" style="text-align: right;border-top: 0 none;">
                                                <button class="btn" style="max-width: 219px" type="submit" onclick="return markGroupIP(this, 64, ' Add ');" name="IFList2" value="<#CTL_add#>" size="12"><i class="icon icon-plus"></i></button>
                                            </td>  
                                          </tr>                                            
<!--                                        </tr>
                                              <td>
                                                <div id="ClientList_Block" class="alert alert-info ddown-list"></div>
                                                <div class="input-append">
                                                    <input type="text" size="12" maxlength="15" name="ipfilter_ipaddr" value="<% nvram_get_x("", "ipfilter_ipaddr"); %>" onkeypress="return is_ipaddr(this,event);" style="float:left; width: 94px"/>
                                                    <button class="btn btn-chevron" id="chevron" type="button" onclick="pullLANIPList(this);" title="Select the IP of LAN clients."><i class="icon icon-chevron-down"></i></button>
                                                </div>
                                            </td>                                     
                                        
                                        </tr>-->

                                        
                                        
                                      
                                        
                                    </table>


                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;"><center><input  name="IFList" type="button submit"  class="btn btn-primary" style="width: 219px" onclick="applyRule();" value="<#CTL_apply#>"/></center></td>
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
