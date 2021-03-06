//
//  LSDevice.m
//  LSKit
//
//  Created by Apple on 2018/5/31.
//  Copyright © 2018年 Price Lai. All rights reserved.
//

#import "LSDevice.h"
#import <sys/sysctl.h>

@implementation LSDevice

+ (NSString *)uuid {
    static dispatch_once_t onceToken;
    static NSString *trilaName = nil;
    dispatch_once(&onceToken, ^{
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        trilaName = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
    });
    return trilaName;
}

+ (CGFloat)getSystemVersion {
    static dispatch_once_t onceToken;
    static CGFloat version = 0;
    dispatch_once(&onceToken, ^{
        version = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return version;
}

//获取硬件型号
+ (NSString *)getDevicePlatform {
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    
    static dispatch_once_t onceToken;
    static NSString *platform = nil;
    
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    dispatch_once(&onceToken, ^{
        if ([platform isEqualToString:@"iPhone1,1"]) {
            platform = @"iPhone";
        }
        else if ([platform isEqualToString:@"iPhone1,2"]) {
            platform = @"iPhone 3G";
        }
        else if ([platform isEqualToString:@"iPhone2,1"]) {
            platform = @"iPhone 3GS";
        }
        else if ([platform isEqualToString:@"iPhone3,1"] || [platform isEqualToString:@"iPhone3,2"] || [platform isEqualToString:@"iPhone3,3"]) {
            platform = @"iPhone 4";
        }
        else if ([platform isEqualToString:@"iPhone4,1"]) {
            platform = @"iPhone 4S";
        }
        else if ([platform isEqualToString:@"iPhone5,1"] || [platform isEqualToString:@"iPhone5,2"]) {
            platform = @"iPhone 5";
        }
        else if ([platform isEqualToString:@"iPhone5,3"] || [platform isEqualToString:@"iPhone5,4"]) {
            platform = @"iPhone 5C";
        }
        else if ([platform isEqualToString:@"iPhone6,2"] || [platform isEqualToString:@"iPhone6,1"]) {
            platform = @"iPhone 5S";
        }
        else if ([platform isEqualToString:@"iPhone7,1"]) {
            platform = @"iPhone 6PLUS";
        }
        else if ([platform isEqualToString:@"iPhone7,2"]) {
            platform = @"iPhone 6";
        }
        else if ([platform isEqualToString:@"iPhone8,1"]) {
            platform = @"iPhone 6S";
        }
        else if ([platform isEqualToString:@"iPhone8,2"]) {
            platform = @"iPhone 6SPLUS";
        }
        else if ([platform isEqualToString:@"iPod4,1"]) {
            platform = @"iPod touch 4";
        }
        else if ([platform isEqualToString:@"iPod5,1"]) {
            platform = @"iPod touch 5";
        }
        else if ([platform isEqualToString:@"iPod3,1"]) {
            platform = @"iPod touch 3";
        }
        else if ([platform isEqualToString:@"iPod2,1"]) {
            platform = @"iPod touch 2";
        }
        else if ([platform isEqualToString:@"iPod1,1"]) {
            platform = @"iPod touch";
        }
        else if ([platform isEqualToString:@"iPad3,2"] || [platform isEqualToString:@"iPad3,1"]) {
            platform = @"iPad 3";
        }
        else if ([platform isEqualToString:@"iPad2,2"] || [platform isEqualToString:@"iPad2,1"] || [platform isEqualToString:@"iPad2,3"] || [platform isEqualToString:@"iPad2,4"]) {
            platform = @"iPad 2";
        }
        else if ([platform isEqualToString:@"iPad1,1"]) {
            platform = @"iPad 1";
        }
        else if ([platform isEqualToString:@"iPad2,5"] || [platform isEqualToString:@"iPad2,6"] || [platform isEqualToString:@"iPad2,7"]) {
            platform = @"ipad mini";
        }
        else if ([platform isEqualToString:@"iPad3,3"] || [platform isEqualToString:@"iPad3,4"] || [platform isEqualToString:@"iPad3,5"] || [platform isEqualToString:@"iPad3,6"]) {
            platform = @"ipad 3";
        }
        
    });
    return platform;
}

//获得当前时间
+ (NSString *)getCurrentDate {
    NSString *dateStr = nil;
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    });
    dateStr = [formatter stringFromDate:[NSDate date]];
    return dateStr;
}

+ (NSString *)getAPPVersion {
    static dispatch_once_t onceToken;
    static NSDictionary *infoDictionary = nil;
    static NSString *version = nil;
    dispatch_once(&onceToken, ^{
        infoDictionary = [[NSBundle mainBundle] infoDictionary];
        version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//        if ([version componentsSeparatedByString:@"."].count - 1 == 1) {
//            version = [version stringByAppendingString:@".0"];
//        }
    });
    return version;
}

+ (NSString *)getBundleVersion {
    static dispatch_once_t onceToken;
    static NSDictionary *infoDictionary = nil;
    static NSString *bundleVersion = nil;
    dispatch_once(&onceToken, ^{
        infoDictionary = [[NSBundle mainBundle] infoDictionary];
        bundleVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    });
    return bundleVersion;
}

+ (NSString *)getIdfv {
    static dispatch_once_t onceToken;
    static NSString *idfv = nil;
    dispatch_once(&onceToken, ^{
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];;
    });
    return idfv;
}

+ (BOOL)afterIOS7 {
    static dispatch_once_t onceToken;
    static BOOL temp = NO;
    dispatch_once(&onceToken, ^{
        CGFloat ver = [self getSystemVersion];
        if (ver >= 7.0) {
            temp = YES;
        } else {
            temp = NO;
        }
    });
    return temp;
}

+ (BOOL)isIOS7 {
    static dispatch_once_t onceToken;
    static BOOL temp = NO;
    dispatch_once(&onceToken, ^{
        CGFloat ver = [self getSystemVersion];
        if (ver >= 7.0 && ver < 8.0) {
            temp = YES;
        } else {
            temp = NO;
        }
    });
    return temp;
}

+ (BOOL)isIOS8 {
    static dispatch_once_t onceToken;
    static BOOL temp = NO;
    dispatch_once(&onceToken, ^{
        CGFloat ver = [self getSystemVersion];
        if (ver >= 8.0 && ver < 9.0) {
            temp = YES;
        } else {
            temp = NO;
        }
    });
    return temp;
}

+ (BOOL)isIOS9 {
    static dispatch_once_t onceToken;
    static BOOL temp = NO;
    dispatch_once(&onceToken, ^{
        CGFloat ver = [self getSystemVersion];
        if (ver >= 9.0 && ver < 10.0) {
            temp = YES;
        } else {
            temp = NO;
        }
    });
    return temp;
}

+ (BOOL)isIOS11 {
    static dispatch_once_t onceToken;
    static BOOL temp = NO;
    dispatch_once(&onceToken, ^{
        CGFloat ver = [self getSystemVersion];
        if (ver >=11.0) {
            temp = YES;
        } else {
            temp = NO;
        }
    });
    return temp;
}

+ (BOOL)isIPhone4 {
    static dispatch_once_t onceToken;
    static BOOL temp = NO;
    dispatch_once(&onceToken, ^{
        temp = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO;
    });
    return temp;
}

+ (BOOL)isIPhone5 {
    static dispatch_once_t onceToken;
    static BOOL temp = NO;
    dispatch_once(&onceToken, ^{
        temp = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO;
    });
    return temp;
}

+ (BOOL)isIPhone6 {
    static dispatch_once_t onceToken;
    static BOOL temp = NO;
    dispatch_once(&onceToken, ^{
        temp = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO;
    });
    return temp;
}

+ (BOOL)isIPhone6p {
    static dispatch_once_t onceToken;
    static BOOL temp = NO;
    dispatch_once(&onceToken, ^{
        temp = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO;
    });
    return temp;
}

+ (BOOL)isIPhoneX {
    static dispatch_once_t onceToken;
    static BOOL temp = NO;
    dispatch_once(&onceToken, ^{
        temp = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
    });
    return temp;
}

@end
