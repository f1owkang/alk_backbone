<% bandwidth("history", ""); %>
var $j = jQuery.noConflict();


window.onload = function () {
    var href = document.URL; // 获取当前页面的URL
    // console.log(href);
    // 判断URL中是否包含特定的字符串
    if (href.indexOf('index.html') > 0) {
        console.log('index.html');
        getSystemInfo();
        getClientsInfo();
        // index.html底部导航栏: 加载完自动选择
        const firstTab = document.querySelector('.tabs ul li.is-active');
        if (firstTab) {
            firstTab.click(); // 触发点击事件，加载相应的内容
        }

    } else if (href.indexOf('traffic.html') > 0) {
        console.log('traffic.html');
        initChart();
        getNetworkInfo();
        displayHistory(monthly_history);

    } else if (href.indexOf('sms.html') > 0) {
        console.log('sms.html');
        getSmsInfo();

    }
};


function showText(id, str) {
    var obj = document.getElementById(id);

    if (obj) {
        // 检查是否具有 has-skeleton 属性并移除
        if (obj.classList.contains('has-skeleton')) {
            obj.classList.remove('has-skeleton');
        }
        // 检查是否具有 is-skeleton 属性并移除
        if (obj.classList.contains('is-skeleton')) {
            obj.classList.remove('is-skeleton');
        }
        // 设置文本内容
        obj.textContent = str;
    }
}

function showProgress(id, int) {
    var obj = document.getElementById(id);

    if (obj) {
        // 判断 int 是否为空
        if (int !== null && int !== undefined && int !== '') {
            obj.value = int;
        } else {
            obj.removeAttribute('value');
        }
    }
}
