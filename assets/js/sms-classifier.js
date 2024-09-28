// 定义短信意图分类器
class SmsIntentClassifier {
    constructor() {
        this.intents = {
            'appointment': ['schedule', 'appointment', 'meeting', 'book', '预约', '安排', '会议', '预定'],
            'payment': ['pay', 'payment', 'bill', 'invoice', '付款', '支付', '账单', '发票'],
            'support': ['help', 'support', 'issue', 'problem', '帮助', '支持', '问题', '故障'],
            'captcha': ['验证码', '校验码', '登录随机码', 'verification code']
        };
    }

    classify(message) {
        // 将消息转换为小写
        const lowerMessage = message.toLowerCase();

        // 遍历意图并检查消息中是否包含相应的关键词
        for (const [intent, keywords] of Object.entries(this.intents)) {
            for (const keyword of keywords) {
                if (lowerMessage.includes(keyword)) {
                    return intent;
                }
            }
        }

        // 如果没有匹配的意图，返回默认值
        return 'unknown';
    }
}

// 定义电话号码分类器
class PhoneNumberClassifier {
    constructor() {
        // 定义特定号码及其分类
        this.numberCategories = {
            'China Telecom': ['10000', '10001'],
            'China Unicom': ['10010', '10018', '10015'],
            'China Mobile': ['10086', '10085'],
        };

        // 定义电话号码模式及其分类
        this.patterns = {
            'Landline': /^0\d{2,3}-\d{7,8}$/,  // 例如：010-12345678（中国固定电话）
            'International calls': /^\+\d{1,3}-\d{4,14}$/, // 例如：+1-800-1234567（国际电话）
        };
    }

    classify(phoneNumber) {
        // 去除电话号码中的空格和特殊字符
        const cleanedNumber = phoneNumber.replace(/\s+/g, '').replace(/[-()]/g, '');

        // 首先进行精确匹配
        for (const [category, numbers] of Object.entries(this.numberCategories)) {
            if (numbers.includes(cleanedNumber)) {
                return category;
            }
        }

        // 如果没有匹配的特定号码，则进行模式匹配
        for (const [category, pattern] of Object.entries(this.patterns)) {
            if (pattern.test(cleanedNumber)) {
                return category;
            }
        }

        // 如果没有匹配的模式，返回默认值
        return 'unknown';
    }
}


function smsClassifier(number, message) {
    const phoneClassifier = new PhoneNumberClassifier();
    const smsClassifier = new SmsIntentClassifier();

    const smsSender = phoneClassifier.classify(number);
    const smsType = smsClassifier.classify(message);

    return {
        sender: smsSender,
        type: smsType
    };
}