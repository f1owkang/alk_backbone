// sms.html
var timerSmsInfo;
// 记录各类短信总数
var smsSum = { "receive": 0, "send": 0, "unsend": 0 };
// 记录当前激活的选项卡 ID
let previousActiveTabId = document.querySelector('.panel-tabs a.is-active').id;

// sms.html
function getSmsInfo() {
    clearTimeout(timerSmsInfo);

    $j.ajax({
        type: 'get',
        url: 'components/system_sms.asp',
        dataType: 'script',
        cache: true,
        error: function (xhr) {
            timerSmsInfo = setTimeout(getSmsInfo, 2000);
            console.error(xhr);
        },
        success: function (response) {
            timerSmsInfo = setTimeout(getSmsInfo, 2000);
            eval(response);
            displaySmsInfo();
            displaySMS();
        }
    });
}

function displaySmsInfo() {
    showText("Quantity received value", smsSum.receive);
    showText("Number sent value", smsSum.send);
    showText("Number unsent value", smsSum.unsend);
    // 面板显示手机号码
    showText("Phone number", '<% nvram_get_x("",  "PhoneNumber"); %>');
}


function displaySMS() {
    // 判断短信数量是否发生变化或选项卡是否发生变化
    if (
        smsReceive.length === smsSum.receive &&
        smsSend.length === smsSum.send &&
        smsUnSend.length === smsSum.unsend &&
        previousActiveTabId === document.querySelector('.panel-tabs a.is-active').id
    ) {
        // 如果短信数量和选项卡均未变化，则返回
        return;
    } else {
        // 更新短信数量
        smsSum.receive = smsReceive.length;
        smsSum.send = smsSend.length;
        smsSum.unsend = smsUnSend.length;

        // 更新当前激活的选项卡 ID
        previousActiveTabId = document.querySelector('.panel-tabs a.is-active').id;
    }

    // 找到面板卡的激活选项
    const activeTab = document.querySelector('.panel-tabs a.is-active');
    // console.log(activeTab.id);

    // 合并所有消息数据，并标记类型
    function mergeAndTagMessages(receive, send, unsend) {
        return [
            ...receive.map(msg => ({ ...msg, type: 'Receive' })),
            ...send.map(msg => ({ ...msg, type: 'Send' })),
            ...unsend.map(msg => ({ ...msg, type: 'UnSend' }))
        ];
    }
    // 排序函数，根据时间降序排序（最新的排前面）
    function sortMessagesByDate(messages) {
        return messages.sort((a, b) => {
            const dateA = new Date(a[3]);
            const dateB = new Date(b[3]);
            return dateB - dateA; // 降序
        });
    }

    // 根据选项不同加载不同数据
    if (activeTab.id == "all") {
        allMessages = mergeAndTagMessages(smsReceive, smsSend, smsUnSend);
    } else if (activeTab.id == "inbox") {
        allMessages = smsReceive.map(msg => ({ ...msg, type: 'Receive' }));
    } else if (activeTab.id == "outbox") {
        allMessages = smsSend.map(msg => ({ ...msg, type: 'Send' }));
    } else if (activeTab.id == "unsend") {
        allMessages = smsUnSend.map(msg => ({ ...msg, type: 'UnSend' }));
    }

    // 对消息进行排序
    allMessages = sortMessagesByDate(allMessages);

    // 清空动态内容区域并插入消息
    const dynamicContent = document.getElementById('dynamic-content');
    dynamicContent.innerHTML = '';
    allMessages.forEach((message) => {
        const messageElement = createMessageItem(message);
        dynamicContent.appendChild(messageElement);
    });
}


// 创建消息项
function createMessageItem(message) {
    const messageElement = document.createElement('a');
    messageElement.className = 'panel-block';
    messageElement.style.display = 'block';
    messageElement.style.width = '100%';
    messageElement.style.wordWrap = 'break-word';

    const nav = document.createElement('nav');
    nav.className = 'level is-mobile';

    const levelLeft = document.createElement('div');
    levelLeft.className = 'level-left';

    const levelItem1 = document.createElement('div');
    levelItem1.className = 'level-item';

    const levelItem2 = document.createElement('div');
    levelItem2.className = 'level-item';

    const levelItem3 = document.createElement('div');
    levelItem3.className = 'level-item';

    const levelItem4 = document.createElement('div');
    levelItem3.className = 'level-item';

    const levelItem5 = document.createElement('div');
    levelItem3.className = 'level-item';

    const icon = document.createElement('span');
    icon.className = 'panel-icon';
    const iIcon = document.createElement('i');

    // 根据类型赋予不同的标签
    if (message.type == 'Receive') {
        iIcon.className = 'fas fa-comments';
    } else if (message.type == 'Send') {
        iIcon.className = 'fas fa-comment';
    } else {
        iIcon.className = 'fas fa-comment-slash';
    }
    iIcon.setAttribute('aria-hidden', 'true');

    const title = document.createElement('h1');
    title.textContent = message[4]; // 显示发件人或接收人

    // 标记类型
    const typeLabel = document.createElement('div');
    typeLabel.className = 'tag is-primary';
    typeLabel.textContent = translate(message.type); // 显示消息类型
    messageElement.appendChild(typeLabel);

    // 时间标记
    const timeLabel = document.createElement('div');
    timeLabel.className = 'tag is-light';
    timeLabel.textContent = message[3];
    messageElement.appendChild(timeLabel);

    // 添加图标和标题到左侧
    icon.appendChild(iIcon);
    levelItem1.appendChild(icon);
    levelItem1.appendChild(title);
    levelItem2.appendChild(typeLabel);
    levelItem3.appendChild(timeLabel);
    levelLeft.appendChild(levelItem1);
    levelLeft.appendChild(levelItem2);
    levelLeft.appendChild(levelItem3);

    // 处理接收到的消息
    if (message.type == 'Receive') {
        // 调用短信分类器
        const smsType = smsClassifier(message[4], message[5]);
        // console.log(smsType);

        // 意图标记
        const intentLabel = document.createElement('div');
        intentLabel.className = 'tag is-info';
        intentLabel.textContent = translate(smsType.type) || 'Unknown';

        // 号码标记
        const senderLabel = document.createElement('div');
        senderLabel.className = 'tag is-info';
        senderLabel.textContent = translate(smsType.sender) || 'Unknown';

        // 创建容器用于放置意图和号码标签
        const levelItem4 = document.createElement('div');
        levelItem4.className = 'level-item';
        const levelItem5 = document.createElement('div');
        levelItem5.className = 'level-item';

        // 根据分类结果添加标签
        if (smsType.type != 'unknown') {
            levelItem4.appendChild(intentLabel);
            levelLeft.appendChild(levelItem4);
        }
        if (smsType.sender != 'unknown') {
            levelItem5.appendChild(senderLabel);
            levelLeft.appendChild(levelItem5);
        }
    }

    const levelRight = document.createElement('div');
    levelRight.className = 'level-right';

    const buttonContainer1 = document.createElement('div');
    buttonContainer1.className = 'level-item';

    const buttonContainer2 = document.createElement('div');
    buttonContainer2.className = 'level-item';

    const button1 = document.createElement('button');
    button1.className = 'button is-info is-rounded';
    button1.textContent = '标记已读'; // 按钮文字
    button1.addEventListener('click', (event) => {
        event.stopPropagation(); // 阻止事件冒泡
        alert(message[5]); // 显示消息内容
    });

    const button2 = document.createElement('button');
    button2.className = 'button is-info is-rounded';
    button2.textContent = '删除信息'; // 按钮文字
    button2.addEventListener('click', (event) => {
        event.stopPropagation(); // 阻止事件冒泡
        // alert(message[5]); // 显示消息内容
        deleteSMS(message[0], message[1]);

    });

    // 是否显示已读按钮
    if (message[2] == '0') {
        // console.log(message[2]);
        buttonContainer1.appendChild(button1);
        levelRight.appendChild(buttonContainer1);
    }
    buttonContainer2.appendChild(button2);
    levelRight.appendChild(buttonContainer2);

    nav.appendChild(levelLeft);
    nav.appendChild(levelRight);
    messageElement.appendChild(nav);

    const contextDiv = document.createElement('div');
    contextDiv.className = 'context has-text-justified px-1';
    contextDiv.textContent = message[5]; // 消息内容
    messageElement.appendChild(contextDiv);

    return messageElement;
}