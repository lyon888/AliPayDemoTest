/**
 配置文件
 @create by 刘智援 2016-11-28
 
 @简书地址:    http://www.jianshu.com/users/0714484ea84f/latest_articles
 @Github地址: https://github.com/lyoniOS
 */

#ifndef MXAlipayConfig_h
#define MXAlipayConfig_h

#import <AlipaySDK/AlipaySDK.h> //支付宝SDK
#import "MXAliPayHandler.h"     //支付宝调起支付类
#import "DataSigner.h"          //支付宝签名类
#import "Order.h"               //订单模型

/**
 -----------------------------------
 支付宝支付需要配置的参数
 -----------------------------------
 */

//开放平台登录https://openhome.alipay.com/platform/appManage.htm
//管理中心获取APPID
#define MXAlipayAPPID       @"请配置你的AppID"
//支付宝私钥（用户自主生成，使用pkcs8格式的私钥）
#define MXAlipayPrivateKey  @"请配置你的支付宝pkcs8私钥"
//应用注册scheme,在AliSDKDemo-Info.plist定义URL types
#define MXURLScheme         @"请前往Info.plist定义URL types"

/**
 -----------------------------------
 支付宝支付接口
 -----------------------------------
 */

#define MXUrlAlipay       @"alipay.trade.app.pay"


#endif /* MXAlipayConfig_h */
