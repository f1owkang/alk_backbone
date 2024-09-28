// index.html
var timerSystemInfo;
var lastSysInfo = <% json_system_status(); %>;
var currentSysInfo, currentClients, realCharge = 100;

// index.html
function getSystemInfo() {
    clearTimeout(timerSystemInfo);

    $j.ajax({
        type: 'get',
        url: 'components/system_info.asp',
        dataType: 'script',
        cache: true,
        error: function (xhr) {
            timerSystemInfo = setTimeout(getSystemInfo, 2000);
            console.error(xhr);
        },
        success: function (response) {
            timerSystemInfo = setTimeout(getSystemInfo, 2000);
            eval(response);
            displaySystemInfo();
            displayTabInfo();
            displayDevice();
        }
    });
}

// index.html
function getClientsInfo() {
    // ip_monitor: [[IP, MAC, DeviceName, Type, http, staled], ...]
    $j.ajax({
        type: 'get',
        url: 'components/lan_clients.asp',
        dataType: 'script',
        cache: true,
        error: function (xhr) {
            console.error(xhr);
        },
        success: function (response) {
            eval(response);
            // console.log(response);
        }
    });
}

// index.html
function displaySystemInfo() {

    // console.log(response);
    // 判断 currentSysInfo 是否为对象
    if (typeof (currentSysInfo) !== 'object') return;

    var cpuNow = {};  // 用来存储当前计算后的 CPU 数据
    var cpuTotal = (currentSysInfo.cpu.total - lastSysInfo.cpu.total);  // 计算当前周期的 CPU 总时间

    // 避免除以 0 的情况
    if (!cpuTotal) cpuTotal = 1;

    // 计算 CPU 使用情况并将其转化为百分比
    cpuNow.busy = parseInt((currentSysInfo.cpu.busy - lastSysInfo.cpu.busy) * 100 / cpuTotal);
    cpuNow.user = parseInt((currentSysInfo.cpu.user - lastSysInfo.cpu.user) * 100 / cpuTotal);
    cpuNow.nice = parseInt((currentSysInfo.cpu.nice - lastSysInfo.cpu.nice) * 100 / cpuTotal);
    cpuNow.system = parseInt((currentSysInfo.cpu.system - lastSysInfo.cpu.system) * 100 / cpuTotal);
    cpuNow.idle = parseInt((currentSysInfo.cpu.idle - lastSysInfo.cpu.idle) * 100 / cpuTotal);
    cpuNow.iowait = parseInt((currentSysInfo.cpu.iowait - lastSysInfo.cpu.iowait) * 100 / cpuTotal);
    cpuNow.irq = parseInt((currentSysInfo.cpu.irq - lastSysInfo.cpu.irq) * 100 / cpuTotal);
    cpuNow.sirq = parseInt((currentSysInfo.cpu.sirq - lastSysInfo.cpu.sirq) * 100 / cpuTotal);

    // 更新全局变量 lastSysInfo 为最新的 currentSysInfo 数据
    lastSysInfo = currentSysInfo;

    // 解析并输出日志信息
    // console.log("系统负载 (Load Average):", currentSysInfo.lavg);

    // console.log("内存信息:");
    // console.log("总内存 (Total RAM):", currentSysInfo.ram.total, "kB");
    // console.log("已用内存 (Used RAM):", currentSysInfo.ram.used, "kB");
    // console.log("空闲内存 (Free RAM):", currentSysInfo.ram.free, "kB");
    // console.log("缓冲区 (Buffers):", currentSysInfo.ram.buffers);
    // console.log("缓存 (Cached):", currentSysInfo.ram.cached, "kB");

    // console.log("交换区 (Swap):");
    // console.log("总交换区 (Total Swap):", currentSysInfo.swap.total, "kB");
    // console.log("已用交换区 (Used Swap):", currentSysInfo.swap.used, "kB");
    // console.log("空闲交换区 (Free Swap):", currentSysInfo.swap.free, "kB");

    // console.log("CPU 使用情况:");
    // console.log("繁忙 (Busy):", currentSysInfo.cpu.busy);
    // console.log("用户 (User):", currentSysInfo.cpu.user);
    // console.log("Nice:", currentSysInfo.cpu.nice);
    // console.log("系统 (System):", currentSysInfo.cpu.system);
    // console.log("空闲 (Idle):", currentSysInfo.cpu.idle);
    // console.log("IO 等待 (IOWait):", currentSysInfo.cpu.iowait);
    // console.log("硬中断 (IRQ):", currentSysInfo.cpu.irq);
    // console.log("软中断 (SIRQ):", currentSysInfo.cpu.sirq);
    // console.log("总 CPU 使用量 (Total):", currentSysInfo.cpu.total);

    // console.log("WiFi 状态 (2.4G):", currentSysInfo.wifi2.state === 0 ? "关闭" : "开启", "访客网络:", currentSysInfo.wifi2.guest === 0 ? "无" : "有");
    // console.log("WiFi 状态 (5G):", currentSysInfo.wifi5.state === 0 ? "关闭" : "开启", "访客网络:", currentSysInfo.wifi5.guest === 0 ? "无" : "有");

    // console.log("3G 网络信号强度 (Signal Strength):", currentSysInfo.signal_strength_3g);
    // console.log("3G RSSI:", currentSysInfo.rssi_3g);
    // console.log("5G 网络信号强度 (Signal Strength):", currentSysInfo.signal_strength_5g);
    // console.log("5G RSRP:", currentSysInfo.rsrp_5g, "dBm");
    // console.log("5G RSRQ:", currentSysInfo.rsrq_5g, "dB");
    showText("Backend value", translate('version'));
    showProgress("CPU busy value", cpuNow.busy);
    showProgress("Running memory value", (currentSysInfo.ram.used / currentSysInfo.ram.total) * 100);
    showProgress("Virtual memory value", (currentSysInfo.swap.used / currentSysInfo.swap.total) * 100)

    showText("Network value", currentSysInfo.network_type);
    showText("Network value1", currentSysInfo.network_type);
    if (currentSysInfo.rsrp_5g === 0) {
        showText("Signal value", currentSysInfo.rsrp + " dBm");
    } else {
        showText("Signal value", currentSysInfo.rsrp_5g + " dBm");
    }
    showProgress("Signal progress value", currentSysInfo.signal_strength_5g);
    showText("Boot value", currentSysInfo.uptime.days + "d " + currentSysInfo.uptime.hours + "h " + currentSysInfo.uptime.minutes + "m ");

    if (currentSysInfo.simcard_status === 0) {
        showText("SIM value", translate('notexist'));//不存在
        showText("SIM value1", translate('notexist'));
    } else if (currentSysInfo.simcard_status === 1) {
        showText("SIM value", translate('normal'));//正常
        showText("SIM value1", translate('normal'));
    } else {
        showText("SIM value", translate('unknown'));//未知
        showText("SIM value1", translate('unknown'));
    }

    showText("Charge value", currentSysInfo.bat_charge === 0 ? translate('notcharge') : translate('charging'));

    if (currentSysInfo.bat_charge === 0) {
        showProgress("Battery progress value", (currentSysInfo.bat_value / 6) * 100);
        showText("Battery value", Math.round((currentSysInfo.bat_value / 6) * 100) + " %")
        realCharge = (currentSysInfo.bat_value / 6) * 100;
    } else {
        showProgress("Battery progress value", null);
        if (((currentSysInfo.bat_value / 5) * 100) <= realCharge) {
            realCharge = (currentSysInfo.bat_value / 5) * 100;
        }
        showText("Battery value", realCharge + " %");
    }

    showText("Unread value", currentSysInfo.sms_unread_count + " " + translate('sms_sum'));


}

// index.html
function displayTabInfo() {
    showText("Serialno value", '<% nvram_get_x("",  "serialno"); %>');
    // showText("SN value", '<% nvram_get_x("",  "sn_num"); %>');
    showText("WAN value", wanlink_ip4_wan());
    showText("LAN value", '<% nvram_get_x("", "lan_ipaddr"); %>');
    showText("LAN netmask value", '<% nvram_get_x("", "lan_netmask"); %>');
    showText("VPN value", wanlink_vpn_wan());
    showText("Gateway value", wanlink_gw4_wan());
    showText("Subnet value", wanlink_netmask());
    showText("DNS 1 value", wanlink_dns());
    showText("DNS 2 value", wanlink_dns2());
    showText("Cell value", cellid());
    showText("Operators value", '<% nvram_get_x("",  "operator"); %>');
    showText("IMEI value", '<% nvram_get_x("",  "imei"); %>');
    showText("APN value", '<% nvram_get_x("",  "modem_apn"); %>');
    showText("ICCID value", '<% nvram_get_x("",  "iccid"); %>');
    showText("IMSI value", '<% nvram_get_x("",  "imsi"); %>');
    showText("Band value", '<% nvram_get_x("",  "band"); %>');
    showText("Phone value", '<% nvram_get_x("",  "PhoneNumber"); %>');
    showText("Model value", '<% nvram_get_x("",  "model_version"); %>');

    if (rsrq_5g() !== '') {
        showText("RTSP value", rsrp_5g());
    } else {
        showText("RTSP value", rsrp());
    }
    if (rsrq_5g() !== '') {
        showText("RTSQ value", rsrq_5g());
    } else {
        showText("RTSQ value", rsrq());
    }

    var status = wanlink_status();
    var statusText = '';
    if (status === 0) {
        statusText = translate('InetState0'); // 已连接
    } else if (status === 1) {
        statusText = translate('InetState1'); // 未插入网线
    } else if (status === 2) {
        statusText = translate('InetState2'); // 未连接到上级 WISP AP
    } else if (status === 3) {
        statusText = translate('InetState3'); // 未连接到上级蜂窝 BS
    } else if (status === 4) {
        statusText = translate('InetState4'); // 网络接口未就绪
    } else if (status === 5) {
        statusText = translate('InetState5'); // 正在获取 IP 地址...
    } else if (status === 6) {
        statusText = translate('InetState6'); // 等待 PPP 客户端连接...
    } else if (status === 7) {
        statusText = translate('InetState7'); // PPP 连接未激活
    } else if (status === 8) {
        statusText = translate('InetState8'); // 未设置默认网关
    } else if (status === 9) {
        statusText = translate('InetState9'); // WAN 子网和 LAN 子网冲突!
    } else {
        statusText = translate('Unknown'); // 未知状态
    }
    showText("Network status value", statusText);

    var service_state = '<% nvram_get_x("",  "service_state"); %>';
    var statusText = '';
    if (service_state == "registered") {
        statusText = translate('ServiceState0'); // 已注册
    } else if (service_state == "not registered") {
        statusText = translate('ServiceState1'); // 未注册
    } else if (service_state == "searching") {
        statusText = translate('ServiceState2'); // 搜索网络
    } else if (service_state == "denied") {
        statusText = translate('ServiceState3'); // 网络拒绝
    } else {
        statusText = translate('Unknown'); // 未知状态
    }
    showText("Service value", statusText);



}

function displayDevice() {
    // 第三选项卡列表
    const list = document.getElementById("Device list");
    // 如果列表对象不存在
    if (!list) {
        return;
    } else {
        // 获取数据
        getClientsInfo();
        // 清空表格内容（保留表头）
        const rows = list.getElementsByTagName('tr');
        for (var i = rows.length - 1; i > 0; i--) {
            if (rows[i].parentNode === list) {
                list.removeChild(rows[i]);
            }
        }
    }
    // 如果current_clients为空，删除父列表，替换为提示语
    if (!currentClients || currentClients.length === 0) {
        // 替换为提示语
        const emptyRow = document.createElement('tr');
        emptyRow.innerHTML = `
                <td class="has-text-centered" colspan="4">${translate("nodata")}</td>
            `;
        tableBody.appendChild(emptyRow);
    } else {
        // 插入数据
        for (var i = 0; i < currentClients.length; i++) {
            var row = document.createElement("tr");

            // Host name
            var hostNameCell = document.createElement("td");
            hostNameCell.textContent = currentClients[i][2];
            row.appendChild(hostNameCell);

            // IP address
            var ipAddressCell = document.createElement("td");
            ipAddressCell.textContent = currentClients[i][0];
            row.appendChild(ipAddressCell);

            // MAC address
            var macAddressCell = document.createElement("td");
            macAddressCell.classList.add("is-uppercase");
            macAddressCell.textContent = currentClients[i][1];
            row.appendChild(macAddressCell);

            // SSID name
            var ssidNameCell = document.createElement("td");
            if (currentClients[i][6] === "-") {
                ssidNameCell.textContent = translate('wired');
            } else {
                ssidNameCell.textContent = currentClients[i][6];
            }
            row.appendChild(ssidNameCell);

            list.appendChild(row);
        }
    }

}
