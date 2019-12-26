//
//  NSString+GMAvoidCrash.m
//  MethodResolveDemo
//
//  Created by 小飞鸟 on 2019/12/24.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "NSString+GMAvoidCrash.h"
#import "NSObject+CategoryMethod.h"

@implementation NSString (GMAvoidCrash)

+(void)loadNSObjectAoidCrash{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class __NSCFConstantString = NSClassFromString(@"__NSCFConstantString");
       
        [self swizzleInstanceMethod:@selector(substringToIndex:) SwizzleSel:@selector(gm_substringToIndex:)];
        [self swizzleInstanceMethod:@selector(substringFromIndex:) SwizzleSel:@selector(gm_substringFromIndex:)];
//        [self swizzleInstanceMethod:@selector(substringWithRange:) SwizzleSel:@selector(gm_substringWithRange:)];
        [self swizzleInstanceMethod:@selector(length) SwizzleSel:@selector(gm_length)];
        
        [__NSCFConstantString swizzleInstanceMethod:@selector(substringWithRange:) SwizzleSel:@selector(gm_substringWithRange:)];
    });
}

/*判断 length*/
-(NSUInteger)gm_length{
    if (isAvailable(self,NSMakeRange(0,0))) return 0;
    return [self gm_length];
}

/*判断字符串 是否可以截取*/
NS_INLINE BOOL isAvailable(NSString * str,NSRange range){
    
    if (!str) {
        return NO;
    }
    if (![str isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (range.location>str.length-1) {
        return NO;
    }
    if (str.length<range.location+range.length) {
        return NO;
    }
    return  YES;
}


-(NSString *)gm_substringWithRange:(NSRange)range{
    
    if (!isAvailable(self, range)) return nil;
    
    return [self gm_substringWithRange:range];
}

-(NSString *)gm_substringFromIndex:(NSUInteger)from{
    
    NSRange range = NSMakeRange(from,self.length-from-1);
    if (!isAvailable(self, range)) return nil;
    return [self gm_substringFromIndex:from];;
}
-(NSString *)gm_substringToIndex:(NSUInteger)to{
     NSRange range = NSMakeRange(0,to);
   if (!isAvailable(self, range)) return nil;
   return [self gm_substringFromIndex:to];
}
@end
