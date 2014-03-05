//
//  ViewController.m
//  PhoneCallSample
//
//  Created by haowenliang on 14-3-5.
//  Copyright (c) 2014年 dpsoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIWebView* _phoneCallWebView;
}
@end

@implementation ViewController

- (IBAction)makeAPhoneCall:(id)sender {
    [self openPhoneCallViewWithphoneNumber:@"0755-86298989"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)dealloc
{
    if (_phoneCallWebView) {
        [_phoneCallWebView setDelegate:nil];
        [_phoneCallWebView stopLoading];
        _phoneCallWebView = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//打开拨打电话
- (void)openPhoneCallViewWithphoneNumber:(NSString *)phoneNum
{
    if (_phoneCallWebView == nil) {
        _phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    NSString *newPhoneString = [ViewController dealWithPhoneNumber:phoneNum];
    if ([ViewController isMobileNumber:newPhoneString]) {
        
        NSURL* dialUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", newPhoneString]];
        if ([[UIApplication sharedApplication] canOpenURL:dialUrl])
        {
            if (_phoneCallWebView) {
                [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:dialUrl]];
            }
            else{
                [[UIApplication sharedApplication] openURL:dialUrl];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"设备不支持" delegate:nil cancelButtonTitle:@"确定 " otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您选择的号码不合法" delegate:nil cancelButtonTitle:@"确定 " otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

+ (NSString *)dealWithPhoneNumber:(NSString *)phone
{
    NSString *newPhone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return newPhone;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestphs evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return YES; //暂时不做检查
    }
}

@end
