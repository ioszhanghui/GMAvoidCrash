//
//  GMCrashManager.m
//  MethodResolveDemo
//
//  Created by 小飞鸟 on 2019/12/26.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "GMCrashLoadManager.h"
#import "NSObject+NoCrash.h"
#import "NSObject+GMKVOCrash.h"
#import "NSString+GMAvoidCrash.h"
#import "NSMutableString+GMAvoidCrash.h"
#import "NSArray+GMAvoidCrash.h"
#import "NSMutableArray+GMAvoidCrash.h"
#import "NSDictionary+GMAvoidCrash.h"
#import "NSMutableDictionary+GMAvoidCrash.h"
#import "NSMutableAttributedString+GMAvoidCrash.h"
#import "NSObject+GMKVOCrash.h"

@implementation GMCrashLoadManager


/*生效 防崩溃方法*/
+(void)effectiveAvoidCrashMethod{
    
    [NSObject loadNSObjectAoidCrash];
    [NSArray loadNSObjectAoidCrash];
    [NSMutableArray loadNSObjectAoidCrash];
    [NSDictionary loadNSObjectAoidCrash];
    [NSMutableDictionary loadNSObjectAoidCrash];
    [NSString loadNSObjectAoidCrash];
    [NSMutableAttributedString loadNSObjectAoidCrash];
    [NSMutableString loadNSObjectAoidCrash];
}

@end
