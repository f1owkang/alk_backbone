let contentCache = {};
var $j = jQuery.noConflict();

// 用于控制页面滚动
function preventScroll(e) {
    e.preventDefault()
}

// index.html卡片按钮: 控制网络连接
function submitInternet(command) {
    // 通过jQuery AJAX发送POST请求
    $j.ajax({
        url: 'components/wan_action.asp',
        type: 'POST',
        data: {
            'wan_action': command
        },
        success: function (data) {
            console.log("Response received:", data);
            // 从返回的data中提取restart_needed_time的值
            const waitTimeMatch = data.match(/restart_needed_time\((\d+)\);/);
            let waitTime = 3;  // 默认值

            if (waitTimeMatch) {
                waitTime = parseInt(waitTimeMatch[1], 10);  // 提取等待时间
            }
            // console.log("Wait time:", waitTime, "seconds");
            // 初始化进度条
            let progressBar = document.getElementById('action modal progress');
            progressBar.setAttribute('max', waitTime);
            progressBar.setAttribute('value', 0);
            let elapsed = 0;

            // 更新进度条的定时器
            const interval = setInterval(() => {
                elapsed += 0.1; // 每0.1秒更新一次
                const progress = Math.min((elapsed / waitTime) * 100, 100); // 计算进度
                progressBar.value = elapsed
                progressBar.textContent = `${Math.round(progress)}%`; // 显示百分比
            }, 100);

            // 显示模态框并设置等待时间
            document.getElementById('action modal').classList.add('is-active');
            document.body.addEventListener('mousewheel', preventScroll, { passive: false })
            document.body.addEventListener('touchmove', preventScroll, { passive: false })

            // 在等待时间后刷新页面
            setTimeout(() => {
                clearInterval(interval); // 停止进度条更新
                progressBar.value = waitTime; // 确保进度条满
                progressBar.textContent = '100%'; // 显示100%

                // 关闭模态框
                document.getElementById('action modal').classList.remove('is-active');
                document.body.removeEventListener('mousewheel', preventScroll)
                document.body.removeEventListener('touchmove', preventScroll)
                document.body.classList.remove('no-scroll');

                // 刷新页面
                window.location.reload();
            }, waitTime * 1000);
        },
        error: function (xhr, status, error) {
            console.error("Error:", error);
        }
    });
}


// 导航栏的展开和收起
function initNavbar() {
    const burger = document.querySelector('.navbar-burger');
    const navMenu = document.getElementById('navMenu');

    if (burger && navMenu) {
        burger.addEventListener('click', function () {
            burger.classList.toggle('is-active');
            navMenu.classList.toggle('is-active');
        });
    } else {
        console.error('未找到 burger 或 navMenu 元素，请检查 HTML 结构和 ID/类名是否正确');
    }
}

// 通知横幅的删除按钮
function initDeleteBt() {
    // 查询所有具有 'notification' 和 'delete' 类的元素
    (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
        // 获取 'delete' 按钮的父元素，即 '.notification'
        const $notification = $delete.parentNode;
        // 为 'delete' 按钮绑定点击事件
        $delete.addEventListener('click', () => {
            // 移除 '.notification' 元素
            $notification.parentNode.removeChild($notification);
        });
    });
}


// 短信删除按钮
function deleteSMS(boxID, msgIDs) {
    console.log("Deleting SMS with IDs:", msgIDs, "from box", boxID);
    // 判断msgIDs是否为数组，不是的话按照单个id处理
    if (Array.isArray(msgIDs)) {
        // 将短信ID循环用'|'拼接
        let idsString;
        for (let i = 0; i < msgIDs.length; i++) {
            idsString += msgIDs[i] + '|';
        }
    } else {
        idsString = msgIDs;
    }
    console.log("Deleting SMS with IDs:", idsString, "from box", boxID);
    // 使用FormData对象收集表单数据
    var formData = new FormData();
    formData.append("sms_id", idsString);
    formData.append("action_mode", "Apply");
    formData.append("box_type", String(boxID)); // 删除类型：发送或者收件箱
    formData.append("handle_sms_mode", "DELETE");

    // 使用jQuery的ajax方法发送表单数据
    $j.ajax({
        url: "components/sms_action.asp", // 提交表单的服务器URL
        type: "POST", // 提交方法
        data: formData, // 发送的数据
        processData: false, // 不处理数据
        contentType: false, // 不设置内容类型
        success: function (response) {
            // 处理服务器返回的数据
            console.log("Response:", response);
        },
        error: function (xhr, status, error) {
            console.error("Error:", error);
        }
    });
}

// index选项卡
document.querySelectorAll('.tabs ul li').forEach(function (tab) {
    tab.addEventListener('click', function () {
        // console.log('Clicked tab:', tab);
        document.getElementById('tab_load').classList.add('skeleton-block');
        // 移除所有 <li> 元素的 is-active 类
        document.querySelectorAll('.tabs ul li').forEach(function (tab) {
            tab.classList.remove('is-active');
        });
        // 为当前被点击的 <li> 元素添加 is-active 类
        tab.classList.add('is-active');
        // 获取被点击的标签的 data-content-id
        const contentId = tab.getAttribute('data-content-id');
        // console.log('Content ID:', contentId);
        if (contentId) {
            // 检查缓存中是否已经有该内容
            if (contentCache[contentId]) {
                // console.log('Loading content from cache:', contentId);
                document.getElementById('tab_load').innerHTML = contentCache[contentId];
                // 移除 skeleton-block 类
                document.getElementById('tab_load').classList.remove('skeleton-block');
                // 重新加载语言文件
                setLanguage(userLang);
            } else {
                fetch(`${contentId}.html`)
                    .then(response => {
                        return response.text();
                    })
                    .then(data => {
                        // console.log('Content loaded for:', contentId);
                        // 将内容缓存起来
                        contentCache[contentId] = data;
                        document.getElementById('tab_load').innerHTML = data;
                        // 移除 skeleton-block 类
                        document.getElementById('tab_load').classList.remove('skeleton-block');
                        // 重新加载语言文件
                        setLanguage(userLang);
                    })
                    .catch(error => {
                        console.error('Error loading content for:', contentId, error);
                    });
            }
        } else {
            console.error('No content ID found for this tab.');
        }
    });
});

// sms.html的选项卡
document.querySelectorAll('.panel-tabs a').forEach(tab => {
    tab.addEventListener('click', (event) => {
        event.preventDefault();
        // 移除所有选项卡的激活状态
        document.querySelectorAll('.panel-tabs a').forEach(t => t.classList.remove('is-active'));
        // 设置当前点击的选项卡为激活状态
        tab.classList.add('is-active');
        // displaySMS()
        displaySMS();
    });
});