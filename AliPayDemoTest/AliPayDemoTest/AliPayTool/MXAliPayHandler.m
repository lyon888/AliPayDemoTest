/**
 支付宝调起支付类
 @create by 刘智援 2016-11-28
 
 @简书地址:    http://www.jianshu.com/users/0714484ea84f/latest_articles
 @Github地址: https://github.com/lyoniOS
 */

#import "MXAliPayHandler.h"
/**
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif
*/
@implementation MXAliPayHandler

+ (void)jumpToAliPay;
{
    /*=========================================================*/
    /*====客户端调用支付宝支付（实际操作请放到服务端）=================*/
    /*=========================================================*/
    
    //AppId和PrivateKey没有配置下的提示
    if (  [MXAlipayAPPID length] == 0
        ||[MXAlipayPrivateKey length] == 0
        ||[MXAlipayAPPID isEqualToString:@"请配置你的AppID"]
        ||[MXAlipayPrivateKey isEqualToString:@"请配置你的支付宝pkcs8私钥"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //商品价格
    NSString *price = [NSString stringWithFormat:@"%.2f", 0.01];
    
    
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order    = [Order new];
    order.app_id    = MXAlipayAPPID;// NOTE: app_id设置
    order.method    = MXUrlAlipay;  // NOTE: 支付接口名称
    order.charset = @"utf-8";       // NOTE: 参数编码格式
    
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];    // NOTE: 当前时间点
    
    order.version   = @"1.0";       // NOTE: 支付版本
    order.sign_type = @"RSA";       // NOTE: sign_type设置
    
    // NOTE: 商品数据
    order.biz_content                   = [BizContent new];
    order.biz_content.body              = @"我是测试数据";
    order.biz_content.subject           = @"1";
    order.biz_content.out_trade_no      = [self generateTradeNO];   //订单ID（由商家自行制定）
    order.biz_content.timeout_express   = @"30m";                   //超时时间设置
    order.biz_content.total_amount      = price;                    //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo         = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded  = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(MXAlipayPrivateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = MXURLScheme;
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

#pragma mark - Private Method

//==============产生随机订单号==============

+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
