// 获取用户语言偏好
const defaultLanguage = 'en';

// 设置 <html> 元素的 lang 属性
const userLang = getUserLanguage();
document.documentElement.lang = userLang;

// 动态加载语言文件
setLanguage(userLang);


function translate(key) {
    // 定义版本号
    if (key == 'version' && userLang == 'zh') {
        return '烛九阴';
    } else if (key == 'version' && userLang == 'en') {
        return 'Zhu jiuyin';
    }
    // 直接从全局 translations 获取翻译，如果没有定义则返回 key
    return window.translations?.[key] || key;
}

function getUserLanguage() {
    const urlParams = new URLSearchParams(window.location.search);
    const langFromURL = urlParams.get('lang');
    if (langFromURL) return langFromURL;

    const browserLanguages = navigator.languages || [navigator.language];
    return browserLanguages.map(lang => lang.split('-')[0])[0] || defaultLanguage;
}


function setLanguage(lang) {
    const languageFile = `assets/lang/i18n_${lang}.js`;
    const script = document.createElement('script');
    script.src = languageFile;
    script.onload = () => {
        updatePageContent(window.translations); // 使用加载的翻译数据更新页面
    };
    script.onerror = () => {
        console.error('加载语言文件失败:', languageFile);
        if (lang !== defaultLanguage) {
            console.log('加载默认语言文件:', defaultLanguage);
            setLanguage(defaultLanguage);
        }
    };
    document.head.appendChild(script);
}

function updatePageContent(translations) {
    for (const [key, value] of Object.entries(translations)) {
        const element = document.getElementById(key);
        if (element) {
            element.textContent = value;
        }
    }
}