// traffic.html
var timerNetworkInfo;
// 定义下载和上传历史记录，包含字节数和时间戳
let downloadHistory = [];
let uploadHistory = [];
// 平均历史点数，可调整
const MAX_HISTORY_POINTS = 10;
// 最大表格点数，可调整
const MAX_CHART_POINTS = 10;
// 用于存储图表的历史数据点
let chartDataHistory = [];
// 用于控制图表刷新时间
let chartDataCounter = 0;
// 图标的句柄
let chartMain;

// traffic.html
function getNetworkInfo() {
    clearTimeout(timerNetworkInfo);

    $j.ajax({
        type: 'get',
        url: 'components/lan_network.asp',
        dataType: 'script',
        cache: true,
        error: function (xhr) {
            timerNetworkInfo = setTimeout(getNetworkInfo, 1000);
            console.error(xhr);
        },
        success: function (response) {
            timerNetworkInfo = setTimeout(getNetworkInfo, 1000);
            eval(response);
            updateHistory(netdevs['RMNET_DATA0'].rx, netdevs['RMNET_DATA0'].tx);
            // 在图表上显示
            if (document.getElementById("chart")) {
                updateChart(calcInstDlSpeed(0), calcInstUlSpeed(0), calcAvgDlSpeed(0), calcAvgUlSpeed(0));
            }
            // 在标签上显示
            displayNetworkInfo();

            // console.log(calcInstDlSpeed(), calcInstUlSpeed());
            // console.log(calcAvgDlSpeed(),calcAvgUlSpeed());
        }
    });
}


function displayNetworkInfo() {
    // 获取即时下载和上传速度
    const iDlSpeed = calcInstDlSpeed(1);
    const iUlSpeed = calcInstUlSpeed(1);
    const aDlSpeed = calcAvgDlSpeed(1);
    const aUlSpeed = calcAvgUlSpeed(1);
    showText("Instant download value", `${iDlSpeed.value} ${iDlSpeed.unit}`);
    showText("Instant upload value", `${iUlSpeed.value} ${iUlSpeed.unit}`);
    showText("Avg download value", `${aDlSpeed.value} ${aDlSpeed.unit}`);
    showText("Avg upload value", `${aUlSpeed.value} ${aUlSpeed.unit}`);
}

// 更新下载和上传历史记录
function updateHistory(total_download_bytes, total_upload_bytes) {
    const current_time = Date.now();

    // 更新下载历史
    downloadHistory.unshift({ bytes: total_download_bytes, time: current_time });
    if (downloadHistory.length > MAX_HISTORY_POINTS) {
        downloadHistory.pop();
    }
    // 更新上传历史
    uploadHistory.unshift({ bytes: total_upload_bytes, time: current_time });
    if (uploadHistory.length > MAX_HISTORY_POINTS) {
        uploadHistory.pop();
    }
}

// 自适应速率转换，返回数值和单位
function formatSpeed(speed) {
    const units = ['B/s', 'KB/s', 'MB/s', 'GB/s'];
    let unit_index = 0;

    // 当速度大于 1024 时，除以 1024 并升级单位
    while (speed >= 1024 && unit_index < units.length - 1) {
        speed /= 1024;
        unit_index++;
    }
    // 保留两位小数
    return { value: speed.toFixed(2), unit: units[unit_index] };
}

// 计算平均下载速度
function calcAvgDlSpeed(format) {
    if (downloadHistory.length < 2) {
        return { value: 0, unit: 'B/s' }; // 数据点不足
    }

    const firstPoint = downloadHistory[downloadHistory.length - 1]; // 最旧的数据点
    const lastPoint = downloadHistory[0]; // 最新的数据点

    const bytesDifference = lastPoint.bytes - firstPoint.bytes;
    const timeDifference = lastPoint.time - firstPoint.time;

    if (timeDifference <= 0) {
        return { value: 0, unit: 'B/s' }; // 防止时间差为0或负数
    }

    const speed = bytesDifference / (timeDifference / 1000); // 字节/秒
    if (format) {
        return formatSpeed(speed);
    } else {
        return { value: speed.toFixed(2), unit: 'B/s' };
    }
}

// 计算平均上传速度
function calcAvgUlSpeed(format) {
    if (uploadHistory.length < 2) {
        return { value: 0, unit: 'B/s' }; // 数据点不足
    }

    const firstPoint = uploadHistory[uploadHistory.length - 1];
    const lastPoint = uploadHistory[0];

    const bytesDifference = lastPoint.bytes - firstPoint.bytes;
    const timeDifference = lastPoint.time - firstPoint.time;

    if (timeDifference <= 0) {
        return { value: 0, unit: 'B/s' };
    }

    const speed = bytesDifference / (timeDifference / 1000); // 字节/秒
    if (format) {
        return formatSpeed(speed);
    } else {
        return { value: speed.toFixed(2), unit: 'B/s' };
    }
}

// 计算瞬时下载速度
function calcInstDlSpeed(format) {
    if (downloadHistory.length < 2) {
        return { value: 0, unit: 'B/s' }; // 数据点不足
    }

    const latestPoint = downloadHistory[0];
    const previousPoint = downloadHistory[1];

    const bytesDifference = latestPoint.bytes - previousPoint.bytes;
    const timeDifference = latestPoint.time - previousPoint.time;

    if (timeDifference <= 0) {
        return { value: 0, unit: 'B/s' };
    }

    const speed = bytesDifference / (timeDifference / 1000); // 字节/秒
    if (format) {
        return formatSpeed(speed);
    } else {
        return { value: speed.toFixed(2), unit: 'B/s' };
    }
}

// 计算瞬时上传速度
function calcInstUlSpeed(format) {
    if (uploadHistory.length < 2) {
        return { value: 0, unit: 'B/s' }; // 数据点不足
    }

    const latestPoint = uploadHistory[0];
    const previousPoint = uploadHistory[1];

    const bytesDifference = latestPoint.bytes - previousPoint.bytes;
    const timeDifference = latestPoint.time - previousPoint.time;

    if (timeDifference <= 0) {
        return { value: 0, unit: 'B/s' };
    }

    const speed = bytesDifference / (timeDifference / 1000); // 字节/秒
    if (format) {
        return formatSpeed(speed);
    } else {
        return { value: speed.toFixed(2), unit: 'B/s' };
    }

}

// 初始化图表对象
function initChart() {
    const chartContainer = document.getElementById('chart');
    if (chartContainer) {
        chartMain = new frappe.Chart(chartContainer, {
            type: 'axis-mixed', // or 'bar', 'line', 'scatter', 'pie', 'percentage'
            height: 250,
            data: {
                labels: [translate("i_download"), translate("i_upload"), translate("a_download"), translate("a_upload")],
                datasets: [
                    {
                        name: translate("i_download"),
                        values: [0],
                        chartType: "line",
                    },
                    {
                        name: translate("i_upload"),
                        values: [0],
                        chartType: "line",
                    },
                    {
                        name: translate("a_download"),
                        values: [0],
                        chartType: "bar",
                    },
                    {
                        name: translate("a_upload"),
                        values: [0],
                        chartType: "bar",
                    },
                ]
            },
            tooltipOptions: {
                formatTooltipX: (d) => d + " s", // 横坐标 tooltip 格式化
                formatTooltipY: (d) => d + " KB/s", // 纵坐标 tooltip 格式化为 KB/s
            },
        });
    }
}

// 更新图表函数
function updateChart(instant_download, instant_upload, avg_download, avg_upload) {
    // 获取当前时间作为标签
    const date = new Date();
    // 格式化当前时间为标签
    const currentTimeLabel = `${date.getSeconds().toString().padStart(2, '0')}`;

    // 将新的数据点添加到历史数组中
    chartDataHistory.push({
        time: currentTimeLabel,
        instant_download: (instant_download.value / 1024).toFixed(2),
        instant_upload: (instant_upload.value / 1024).toFixed(2),
        avg_download: (avg_download.value / 1024).toFixed(2),
        avg_upload: (avg_upload.value / 1024).toFixed(2),
    });

    // 确保最多保留10个数据点
    if (chartDataHistory.length > MAX_CHART_POINTS) {
        chartDataHistory.shift(); // 移除最旧的数据点
    }

    // 在这里更新图表
    // console.log("Updated chart data:", data);
    if (chartDataCounter > 3) {

        chartDataCounter = 0;
        // 从历史数据中提取标签和数据集
        const labels = chartDataHistory.map(entry => entry.time);
        const instDlVals = chartDataHistory.map(entry => entry.instant_download);
        const instUlVals = chartDataHistory.map(entry => entry.instant_upload);
        const avgDlVals = chartDataHistory.map(entry => entry.avg_download);
        const avgUlVals = chartDataHistory.map(entry => entry.avg_upload);

        // 构建图表的数据结构
        const data = {
            labels: labels,
            datasets: [
                {
                    name: translate("i_download"),
                    chartType: "line",
                    values: instDlVals,
                },
                {
                    name: translate("i_upload"),
                    chartType: "line",
                    values: instUlVals,
                },
                {
                    name: translate("a_download"),
                    chartType: "bar",
                    values: avgDlVals,
                },
                {
                    name: translate("a_upload"),
                    chartType: "bar",
                    values: avgUlVals,
                }
            ]
        };

        const container = document.getElementById('chart');
        // 检查是否具有 is-skeleton 属性并移除
        if (container.classList.contains('is-skeleton')) {
            container.classList.remove('is-skeleton');
        }
        chartMain.update(data);
    } else {
        chartDataCounter++;
    }
}


// 解析、缩放、排序并格式化 monthly_history 数据，并将结果显示在表格中
function displayHistory(history, isAscending = false) {
    // 单位名称数组和数字千分位格式化函数，从 KB 开始
    const snames = ['KB', 'MB', 'GB', 'TB'];
    const comma = (num) => num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');

    // 日期解析函数，将日期数值转换为 年-月-日
    const getYMD = (n) => [(n >> 16) & 0xFFFF, (n >> 8) & 0xFF, n & 0xFF];

    // 自动缩放单位函数，从 KB 开始
    const autoRescale = (n) => {
        let scale = 0; // 初始单位为 KB
        while (n >= 1024 && scale < snames.length - 1) {
            n /= 1024; // 将数值缩小一个单位
            scale++;   // 增加单位级别
        }
        return `${comma(n.toFixed(2))} ${snames[scale]}`; // 返回格式化的字符串
    };

    // 解析、格式化并排序数据
    const sortedData = history
        .map(([date, download, upload]) => {
            const [year, month, day] = getYMD(date); // 解析日期
            return {
                // date: `${year}-${month}-${day}`,
                date: `${year}-${month}`,
                timestamp: new Date(year, month - 1, day).getTime(),
                download: autoRescale(download), // 直接传递原始单位的数值 (KB)
                upload: autoRescale(upload), // 直接传递原始单位的数值 (KB)
                total: autoRescale(download + upload) // 计算总流量并自动缩放
            };
        })
        .sort((a, b) => isAscending ? a.timestamp - b.timestamp : b.timestamp - a.timestamp); // 根据 isAscending 参数控制排序顺序

    // 获取表格主体
    const tableBody = document.getElementById('Historical flow table');
    if (tableBody) {
        // 清空表格内容（保留表头）
        const rows = tableBody.getElementsByTagName('tr');
        for (var i = rows.length - 1; i > 0; i--) {
            if (rows[i].parentNode === tableBody) {
                tableBody.removeChild(rows[i]);
            }
        }
        if (sortedData.length === 0) {
            // 如果数据为空，插入提示语
            const emptyRow = document.createElement('tr');
            emptyRow.innerHTML = `
                <td class="has-text-centered" colspan="4">${translate("nodata")}</td>
            `;
            tableBody.appendChild(emptyRow);
        } else {
            // 将数据插入表格
            sortedData.forEach(({ date, download, upload, total }) => {
                const row = document.createElement('tr');
                row.innerHTML = `
            <td class="has-text-centered">${date}</td>
            <td class="has-text-centered">${download}</td>
            <td class="has-text-centered">${upload}</td>
            <td class="has-text-centered">${total}</td>
        `;
                tableBody.appendChild(row);
            });
        }
    }
}