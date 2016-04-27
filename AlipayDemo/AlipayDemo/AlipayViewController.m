//
//  AlipayViewController.m
//  AlipayDemo
//
//  Created by Bo on 16/4/27.
//  Copyright © 2016年 Bo. All rights reserved.
//

#import "AlipayViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AlipayViewController ()

@end

@implementation AlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)alipayBtnClick:(id)sender {
    NSDictionary *dic = @{@"testTitle":@"testBody"};
    
    NSString *partner = @"2088121287862492";
    NSString *seller = @"lsh123_wx@sina.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKZfq5WKE/ZGXV9+\
    KExpkFeei7WasoVA4A8zavB974Z4sdhq9BHnLC9qlKPdOBVoSTZlaOZrC17Fm7YZ\
    aB2vKhCXAIG3ofI99L9rmefL8vWcCx4k6GmAp3DNCAzCUmljGK+kXHP1+w2wavqV\
    o6OsNXGPS+dxxw4FIgVuORqY5NLFAgMBAAECgYAXHd/nbUIMzAYZSJws0dYedocO\
    +qmnXjZDpm9LbxQi6Q489c9n1WkMRZDVm905DD5v8nM64NC5oFdcW/ddeIMthZBQ\
    Xp5F/46ZFHAzQqbC4FnP999x2qozZDELjiiTLNibasmndEX3BX5IWjY4CJcFMxjR\
    UUIypj69ST9tS2Q5wQJBANLznq2evQin4e2JkWXdQz8GgvT172j33wn3x5xSkX8V\
    kXXwaESP2YexepDLMetMtY0lFoZYD1ouKFQxaua5/MkCQQDJ5wxW6Zt9QO1gHYDF\
    DQ0U+Obu9zUn0kJ4qdUOCw0Y7XaWL7UpiQYRhcagLwbJpp4mFHl8LLTGA8n8J1Oh\
    QbAdAkA1WukHgN7PEadTLThZS112027MBmhHZGpFWyZho4CpZAsmiWfV74xVhc46\
    USqPGRfSW08XK662YHZS1Sz0rpYBAkEAvaW4Un8V3Z46Gjk8Nlue+R8fFEHCfUgj\
    xeGIzasVv192L3Zajcw2lgj5XIcvsgQ+svgycLAxkXoHpUFvbZ4dBQJAX1YKMXTF\
    tTfYnokXDNY56cQnHhSEso7LW9i/DTVzJmo7Xj7DvvC5cpQubaFC1ZtEpikZ7Vzr\
    hkwF8RQnOUfjag==";
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO];
    order.productName = @"商品名";
    order.productDescription = @"商品描述";
    order.amount = [NSString stringWithFormat:@"%.2f", 0.01];
    order.notifyURL = @"www.baidu.com";
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    NSString *appScheme = @"alipaydemo";
    
    NSString *orderSpec = [order description];
    
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }

}

#pragma mark -
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



@end
