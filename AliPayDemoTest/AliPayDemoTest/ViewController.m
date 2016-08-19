//
//  ViewController.m
//  AliPayDemoTest
//
//  Created by 众网合一 on 16/6/14.
//  Copyright © 2016年 GdZwhy. All rights reserved.
//

#import "ViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import <AFNetworking.h>
@interface ViewController ()

@end

@implementation ViewController

#pragma mark   ==============产生随机订单号==============

- (NSString *)generateTradeNO
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


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
#pragma mark - 客户端调用支付宝支付
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    
    
        NSString *partner = @"";
        NSString *seller = @"";
        NSString *privateKey = @"";
    
    
        /*============================================================================*/
        /*============================================================================*/
    
    
        //partner和seller获取失败,提示
        if ([partner length] == 0 ||
            [seller length] == 0 ||
            [privateKey length] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"缺少partner或者seller或者私钥。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
    
            return;
        }
    
    
    
        /*
         *生成订单信息及签名
         */
        //将商品信息赋予AlixPayOrder的成员变量
        Order *order = [[Order alloc] init];
        order.partner = partner;    //  支付宝分配给商户的ID
        order.sellerID = seller;    //  收款支付宝账号（用于收💰）
        order.outTradeNO = @"0000000001";//[self generateTradeNO]; //订单ID（由商家自行制定）
        order.subject = @"充值"; //商品标题
        order.body = @"充值"; //商品描述
        order.totalFee = [NSString stringWithFormat:@"%d",1]; //商品价格
    
        // 回调 URL ：貌似后台用来获取每笔交易记录的
        order.notifyURL = @"";// @"http://www.xxx.com"; //回调URL（通知服务器端交易结果）(重要)
    
        //???: 接口名称要如何修改?
        order.service = @"mobile.securitypay.pay"; //接口名称, 固定值, 不可空
        order.paymentType = @"1"; //支付类型 默认值为1(商品购买), 不可空
        order.inputCharset = @"utf-8"; //参数编码字符集: 商户网站使用的编码格式, 固定为utf-8, 不可空
        order.itBPay = @"30m";//未付款交易的超时时间 取值范围:1m-15d, 可空
        order.showURL = @"m.alipay.com";
    
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"";
    
        //将商品信息拼接成字符串
        NSString *orderSpec = [order description];
 
    
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(privateKey);
    
        NSString *signedString = [signer signString:orderSpec];
    
        NSLog(@"signedString = %@",signedString);

        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            
            NSLog(@"%@",orderString);
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        }
    
    
    
#pragma mark - 服务端调用支付宝支付
   /*
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"total_fee"] = @"1";
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [mgr POST:@"" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
 
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
                NSString *orderString = nil;
                if (string != nil) {
                    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                   orderSpec, string, @"RSA"];
        
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"hjkjAlipay";
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    */
}


@end
