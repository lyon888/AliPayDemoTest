# 支付宝支付集成方法
## 1.将项目中的`AliSDK`与`AliPayTool`文件夹拖入自己的项目中

## 2.在`Build Phases`选项卡的`Link Binary With Libraries`中，增加以下依赖：
![image](https://img.alicdn.com/top/i1/LB1PlBHKpXXXXXoXXXXXXXXXXXX)

## 3.到`MXAlipayConfig.h`配置支付宝支付所需要的参数

## 4.导入头文件`MXAlipayConfig.h`

## 5.在`AppDelegate.m`实现以下代码

```
/**
 @create by 刘智援 2016-11-28
 
 @简书地址:    http://www.jianshu.com/users/0714484ea84f/latest_articles
 @Github地址: https://github.com/lyoniOS
 
 */

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        [self paymentResult:url];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        [self paymentResult:url];
    }
    return YES;
}

- (void)paymentResult:(NSURL *)url
{
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
}

@end

```
## 6.在需要调起微信支付的界面编写以下代码

```
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [MXAliPayHandler jumpToAliPay];
}


```