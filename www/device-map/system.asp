<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="formcontrol.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/jquery.js"></script>
<script>

<% wanlink(); %>

var $j = jQuery.noConflict();
var id_update_wanip = 0;
var last_bytes_rx = 0;
var last_bytes_tx = 0;
var last_time = 0;

window.performance = window.performance || {};
performance.now = (function() {
	return performance.now ||
	performance.mozNow ||
	performance.msNow ||
	performance.oNow ||
	performance.webkitNow ||
	function() { return new Date().getTime(); };
})();

function initial(){
	flash_button();

  if(!checkSERIALNO())
        return;	
	fill_info();

	id_update_wanip = setTimeout("update_wanip();", 2500);
}


function fill_status(scode,wtype,simcard,ltesignal,rsrp,rsrq,cellid,signal_5g,rsrp_5g,rsrq_5g,signal_3g,rssi_3g,network_type){
	var stext = "Unknown";
	if (scode == 0)
		stext = "<#InetState0#>";
	else if (scode == 1)
		stext = "<#InetState1#>";
	else if (scode == 2)
		stext = "<#InetState2#>";
	else if (scode == 3)
		stext = "<#InetState3#>";
	else if (scode == 4)
		stext = "<#InetState4#>";
	else if (scode == 5)
		stext = "<#InetState5#>";
	else if (scode == 6)
		stext = "<#InetState6#>";
	else if (scode == 7)
		stext = "<#InetState7#>";
	else if (scode == 8)
		stext = "<#InetState8#>";
	else if (scode == 9)
		stext = "<#InetState9#>";
	//$("wan_status").innerHTML = '<span class="label label-' + (scode != 0 ? 'warning' : 'success') + '">' + stext + '</span>';

	var wtext = wtype;
	if(wtype == 'Automatic IP')
		wtext = 'WAN: <#BOP_ctype_title1#>';
	else if(wtype == 'Static IP')
		wtext = 'WAN: <#BOP_ctype_title5#>';
	//$("WANType").innerHTML = wtext;
	if(simcard == 0)
		$("simcard_status").innerHTML = '<#Simcard_noexist#>';
	else if(simcard == 1)
		$("simcard_status").innerHTML = '<#Simcard_exist#>';
	else
		$("simcard_status").innerHTML = '<#Simcard_unkown#>';

	$("cellid").innerHTML = cellid;
	
	if (simcard == 1) {
		if(network_type == "LTE"){
			$("signal").innerHTML = "<img  src='/bootstrap/img/signal/Signal" + ltesignal +".gif'>";
			if (rsrp != "")
			$("rsrp").innerHTML = rsrp + ' dBm';
			$("rsrq").innerHTML = rsrq;
			$("tr_rssi").style.display="none";
			$("tr_rsrp").style.display="";
			$("tr_rsrq").style.display="";
		}else if(network_type == "NR5G-NSA"){
			$("signal").innerHTML = "<img  src='/bootstrap/img/signal/Signal" + signal_5g +".gif'>";
			if (rsrp != "")
			$("rsrp").innerHTML = rsrp_5g + ' dBm';
			$("rsrq").innerHTML = rsrq_5g;
			$("tr_rssi").style.display="none";
			$("tr_rsrp").style.display="";
			$("tr_rsrq").style.display="";
		}
		else if(network_type == "NR5G-SA"){
			$("signal").innerHTML = "<img  src='/bootstrap/img/signal/Signal" + signal_5g +".gif'>";
			if (rsrp_5g != "")
			$("rsrp").innerHTML = rsrp_5g + ' dBm';
			$("rsrq").innerHTML = rsrq_5g;
			$("tr_rssi").style.display="none";
			$("tr_rsrp").style.display="";
			$("tr_rsrq").style.display="";
		}else if(network_type == "WCDMA"){
			$("signal").innerHTML = "<img  src='/bootstrap/img/signal/Signal" + signal_3g +".gif'>";
			if (rssi_3g != "")
				$("rssi").innerHTML = rssi_3g;
			$("tr_rssi").style.display="";
			$("tr_rsrp").style.display="none";
			$("tr_rsrq").style.display="none";
		}else{
			$("signal").innerHTML = "<img  src='/bootstrap/img/signal/Signal" + 0 +".gif'>";
			$("rsrp").innerHTML = "";
			$("rsrq").innerHTML = "";
			$("tr_rssi").style.display="";
			$("tr_rsrp").style.display="";
			$("tr_rsrq").style.display="";
		}
	}
}




function fill_man_addr4(ip,gw){
	if (ip != ''){
		$("MANIP4").innerHTML = ip;
		$("MANGW4").innerHTML = gw;
		$("row_man_ip4").style.display = "";
		$("row_man_gw4").style.display = "";
	}else{
		$("row_man_ip4").style.display = "none";
		$("row_man_gw4").style.display = "none";
	}
}
function fill_info(){
	var now = performance.now();
	fill_status(wanlink_status(), wanlink_type(), simcard_status(), signal_strength(), rsrp(), rsrq(), cellid(),signal_strength_5g(), rsrp_5g(),rsrq_5g(),signal_strength_3g(), rssi_3g(), network_type());
//	fill_uptime(wanlink_uptime(), wanlink_dltime());
//	fill_phylink(wanlink_etherlink(), wanlink_apclilink());
	fill_man_addr4(wanlink_ip4_man(), wanlink_gw4_man());
	//fill_wan_addr6(wanlink_ip6_wan(), wanlink_ip6_lan());
	//fill_wan_bytes(wanlink_bytes_rx(), wanlink_bytes_tx(), now);
	$("WANIP4").innerHTML = wanlink_ip4_wan();
	$("WANGW4").innerHTML = wanlink_gw4_wan();
	$("WANDNS").innerHTML = wanlink_dns();
	$("WANMAC").innerHTML = wanlink_mac();
	
	//showtext($("model_version"), '<% nvram_get_x("",  "model_version"); %>');
	showtext($("imei"), '<% nvram_get_x("",  "imei"); %>');
	showtext($("modem_isp"), '<% nvram_get_x("",  "operator"); %>');
	showtext($("apn1"), '<% nvram_get_x("",  "modem_apn"); %>');
	//showtext($("SubnetMask"), '<% nvram_get_x("",  "wan0_netmask"); %>');
	//showtext($("SecdDNS"), '<% nvram_get_x("",  "wan_dns2_x"); %>');
	$("SubnetMask").innerHTML = wanlink_netmask();
	$("SecdDNS").innerHTML = wanlink_dns2();
	showtext($("local_netmask"), '<% nvram_get_x("",  "lan_netmask"); %>');	
	showtext($("local_ip"), '<% nvram_get_x("",  "lan_ipaddr"); %>');	
	
	if (simcard_status()==1) {
		showtext($("iccid"), '<% nvram_get_x("",  "iccid"); %>');		
		showtext($("imsi"), '<% nvram_get_x("",  "imsi"); %>');
		showtext($("band"), '<% nvram_get_x("",  "band"); %>');
		showtext($("PhoneNum"), '<% nvram_get_x("",  "PhoneNumber"); %>');
		//showtext($("band_5g"), '<% nvram_get_x("",  "band_5g"); %>');
		//showtext($("band_3g"), '<% nvram_get_x("",  "band_3g"); %>');
		
	}
}

function update_wanip(){
	clearTimeout(id_update_wanip);
	$j.ajax({
		url: '/status_wanlink.asp',
		dataType: 'script',
		cache: true,
		error: function(xhr){
			;
		},
		success: function(response){
			fill_info();
			id_update_wanip = setTimeout("update_wanip();", 2500);
		}
	});
}

function submitInternet(v){
//	parent.showLoading();
//	document.internetForm.action = "wan_action.asp";
//	document.internetForm.wan_action.value = v;
//	document.internetForm.modem_prio.value = $("modem_prio").value;
//	document.internetForm.sim_slot.value = $("sim_slot").value;
//	document.internetForm.submit();
}

</script>
</head>

<body class="body_iframe" onload="initial();">
<table width="100%" align="center" cellpadding="4" cellspacing="0" class="table" id="tbl_info">
<!--   <tr>
          <th colspan="2" style="background-color: #E3E3E3;"><#System_info#></th>
   </tr>-->
<!--  <tr>
    <th width="50%" style="border-top: 0 none;"><#InetControl#></th>
    <td style="border-top: 0 none;" colspan="3">
      <input type="button" id="btn_connect_1" class="btn btn-info" value="<#Connect#>" onclick="submitInternet('Connect');">
      <input type="button" id="btn_connect_0" class="btn btn-danger" value="<#Disconnect#>" onclick="submitInternet('Disconnect');">
    </td>
  </tr>-->
<!--  <tr id="row_modem_prio" style="display:none">
    <th><#ModemPrio#></th>
    <td colspan="3">
        <select id="modem_prio" class="input" style="width: 260px;" onchange="submitInternet('ModemPrio');">
            <option value="0" <% nvram_match_x("", "modem_prio", "0", "selected"); %>><#ModemPrioItem0#></option>
            <option value="1" <% nvram_match_x("", "modem_prio", "1", "selected"); %>><#ModemPrioItem1#></option>
            <option value="2" <% nvram_match_x("", "modem_prio", "2", "selected"); %>><#ModemPrioItem2#></option>
        </select>
    </td>
  </tr>-->
 <!-- <tr id="row_link_ether" style="display:none">
    <th><#SwitchState#></th>
    <td colspan="3"><span id="WANEther"></span></td>
  </tr>-->
<!--  <tr id="row_link_apcli" style="display:none">
    <th><#InetStateWISP#></th>
    <td colspan="2"><span id="WANAPCli"></span></td>
    <td width="40px" style="text-align: right; padding: 6px 8px"><button type="button" class="btn btn-mini" style="height: 21px; outline:0;" title="<#Connect#>" onclick="submitInternet('WispReassoc');"><i class="icon icon-refresh"></i></button></td>
  </tr>-->

   
<!--   <tr>
        <th ><#General_x_FirmwareVersion_itemname#></th>
     <td id="firmver" colspan="3"   name="firmver" value="<% nvram_get_x("",  "fw_ver"); %>"></td>
  </tr>
   <tr>
     <th ><#SN_N#></th>
     <td id="snnum" colspan="3"   name="snnum" value="<% nvram_get_x("",  "sn_num"); %>"></td>
  </tr> -->
  <th colspan="2" style="background-color: #E3E3E3;"><#Internet_Configurations#></th>
   <tr>
    <th><#IP4_Addr#> WAN:</th>
    <td colspan="3"><span id="WANIP4"></span></td>
  </tr>
     <tr>
    <th><#IP4_SubnetMask#> WAN:</th>
    <td colspan="3"><span id="SubnetMask"></span></td>
  </tr>
  <tr id="row_man_ip4" style="display:none">
    <th><#IP4_Addr#> MAN:</th>
    <td colspan="3"><span id="MANIP4"></span></td>
  </tr>
  <tr>
    <th><#Gateway#> WAN:</th>
    <td colspan="3"><span id="WANGW4"></span></td>
  </tr>
  
  <tr id="row_man_gw4" style="display:none">
    <th><#Gateway#> MAN:</th>
    <td colspan="3"><span id="MANGW4"></span></td>
  </tr>
  <tr>
    <th><#FstDNS#></th>
    <td colspan="3"><span id="WANDNS"></span></td>
  </tr>
  <tr>
    <th><#SecdDNS#></th>
    <td colspan="3"><span id="SecdDNS"></span></td>
  </tr>
  <th colspan="2" style="background-color: #E3E3E3;"><#Local_Network#></th>
  <tr>
    <th><#LOCAL_IP#></th>
    <td colspan="3"><span id="local_ip"></span></td>
  </tr> 
  <tr>
    <th><#LOCAL_NETMASK#></th>
    <td colspan="3"><span id="local_netmask"></span></td>
  </tr> 
  <tr style="display:none">
    <th><#MAC_Address#></th>
    <td colspan="3"><span id="WANMAC"></span></td>
  </tr> 
 
<!--  <tr>
    <th><#ConnectionStatus#></th>
    <td id="wan_status" colspan="3"></td>
  </tr>-->
 <!-- <tr>
    <th><#Connectiontype#>:</th>
    <td colspan="3"><span id="WANType"></span></td>
  </tr>
  <tr id="row_uptime" style="display:none">
    <th><#WAN_Uptime#></th>
    <td colspan="3"><span id="WANTime"></span></td>
  </tr>
  <tr id="row_dltime" style="display:none">
    <th><#WAN_Lease#></th>
    <td colspan="3"><span id="WANLease"></span></td>
  </tr>
  <tr id="row_bytes" style="display:none">
    <th><#WAN_Bytes#></th>
    <td width="90px"><span id="WANBytesRX"></span></td>
    <td colspan="2"><span id="WANBytesTX"></span></td>
  </tr>
  <tr id="row_brate" style="display:none">
    <th><#WAN_BRate#></th>
    <td width="90px"><span id="WANBRateRX"></span></td>
    <td colspan="2"><span id="WANBRateTX"></span></td>
  </tr>-->

  <tr id="row_wan_ip6" style="display:none">
    <th><#IP6_Addr#> WAN:</th>
    <td colspan="3"><span id="WANIP6"></span></td>
  </tr>
  <tr id="row_lan_ip6" style="display:none">
    <th><#IP6_Addr#> LAN:</th>
    <td colspan="3"><span id="LANIP6"></span></td>
  </tr>
  
 
 <!-- <tr id="row_more_links">
    <td style="padding-bottom: 0px;">&nbsp;</td>
    <td style="padding-bottom: 0px;" colspan="3">
        <select id="domore" class="domore" style="width: 260px;" onchange="domore_link(this);">
          <option selected="selected"><#MoreConfig#>...</option>
          <option value="../Advanced_WAN_Content.asp"><#menu5_3_1#></option>
          <option value="../Advanced_IPv6_Content.asp"><#menu5_3_3#></option>
          <option value="../Advanced_VirtualServer_Content.asp"><#menu5_3_4#></option>
          <option value="../Advanced_Exposed_Content.asp"><#menu5_3_5#></option>
          <option value="../Advanced_DDNS_Content.asp"><#menu5_3_6#></option>
          <option value="../Advanced_Modem_others.asp"><#menu5_4_4#></option>
          <option value="../vpnsrv.asp"><#menu2#></option>
          <option value="../vpncli.asp"><#menu6#></option>
        </select>
    </td>-->
  </tr>
</table>

<table width="100%" align="center" cellpadding="4" cellspacing="0" class="table" id="tbl_info">
<h2 id="tbl2name" style="background-color:#006dcc;color: #ffffff;font-size: 14px;" class="box_head round_top box well grad_colour_dark_blue"><#LTE5G_Information#></h2>
 <!--<th colspan="2" style="background-color: #E3E3E3;"><#Module_Information#></th>
 <tr>
     <th><#module_version#></th>
     <td id="modu_ver" colspan="3"  value="<% nvram_get_x("",  "module_ver"); %>"></td>
  </tr>
   <tr>
    <th width="50%" style="border-top: 0 none;"><#Modelversion#>:</th>
    <td style="border-top: 0 none;"><span id="model_version"></span></td>
  </tr>-->
  <th colspan="2" style="background-color: #E3E3E3;"><#LTE_INFO#></th>
    <tr>
     <th><#Simcardstatus#></th>
     <td id="simcard_status" colspan="2" style="text-align: left;width: 160px;"></td>
<!--     <td colspan="1">
	     <select id="sim_slot" class="input" style="width: 80px;" onchange="submitInternet('SimSlot');">
		     <option value="1" <% nvram_match_x("", "sim_slot", "1", "selected"); %>><#SIMSLOT1#></option>
		     <option value="2" <% nvram_match_x("", "sim_slot", "2", "selected"); %>><#SIMSLOT2#></option>
	     </select>
     </td>-->
  </tr>
  <tr>
     <th><#HSDPAConfig_ISP_itemname#></th>
     <td id="modem_isp" colspan="2" style="text-align: left;width: 160px;"></td>   
  </tr>
   <tr>
     <th><#HSDPAConfig_private_apn_itemname#></th>
     <td id="apn1" colspan="2" style="text-align: left;width: 160px;"></td>   
  </tr>
<!--
   <th colspan="2" style="background-color: #E3E3E3;"><#LTE_RF_STATUS#></th>
 <tr>
   <tr>
    <th width="50%"><#band#></th>
    <td <span id="band"></span></td>
  </tr>
     <th><#Ltesignal#></th>
     <td id="lte_signal" colspan="3" ></td>
  </tr>
  <tr>
     <th><#rsrp#></th>
     <td id="rsrp" colspan="3" ></td>
  </tr>
  <tr>
     <th><#rsrq#></th>
     <td id="rsrq" colspan="3" ></td>
  </tr>
  <th colspan="2" style="background-color: #E3E3E3;"><#RF_STATUS_3G#></th>
    <tr>
   <tr>
    <th width="50%"><#band#></th>
    <td <span id="band_3g"></span></td>
  </tr>
 <tr>
     <th><#Ltesignal#></th>
     <td id="signal_3g" colspan="3" ></td>
  </tr>
  <tr>
     <th><#rssi#></th>
     <td id="rssi_3g" colspan="3" ></td>
  </tr>
-->

  <th colspan="2" style="background-color: #E3E3E3;"><#MODEM_RF_STATUS#></th>
    <tr>
   <tr>
    <th width="50%"><#band#></th>
    <td <span id="band"></span></td>
  </tr>
 <tr>
     <th><#Ltesignal#></th>
     <td id="signal" colspan="3" ></td>
  </tr>
  <tr id="tr_rsrp">
     <th><#rsrp#></th>
     <td id="rsrp" colspan="3" ></td>
  </tr>
  <tr id="tr_rsrq">
     <th><#rsrq#></th>
     <td id="rsrq" colspan="3" ></td>
  </tr>
  <tr id="tr_rssi">
     <th><#rssi#></th>
     <td id="rssi" colspan="3" ></td>
  </tr>
  
   <th colspan="2" style="background-color: #E3E3E3;"><#IMEI_PhoneNume#></th>

  <tr>
    <th width="50%"><#imei#></th>
    <td <span id="imei"></span></td>
  </tr>
  <tr>
    <th width="50%"><#iccid#></th>
    <td <span id="iccid"></span></td>
  </tr>
  <tr>
    <th width="50%"><#imsi#></th>
    <td <span id="imsi"></span></td>
  </tr>
  <tr style="display:none">
    <th width="50%"><#Phone_Number#></th>
    <td <span id="PhoneNum"></span></td>
  </tr>
  <tr>
     <th><#cellid#></th>
     <td id="cellid" colspan="3" ></td>
  </tr>
</table>
<form method="post" name="internetForm" action="">
<input type="hidden" name="wan_action" value="">
<!--<input type="hidden" name="modem_prio" value="">-->

</form>

</body>
</html>
