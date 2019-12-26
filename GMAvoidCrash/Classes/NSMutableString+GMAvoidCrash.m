//
//  NSMutableString+GMAvoidCrash.m
//  MethodResolveDemo
//
//  Created by 小飞鸟 on 2019/12/24.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "NSMutableString+GMAvoidCrash.h"
#import "NSObject+CategoryMethod.h"

@implementation NSMutableString (GMAvoidCrash)

+(void)loadNSObjectAoidCrash{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class __NSCFString = NSClassFromString(@"__NSCFString");
        Class NSPlaceholderMutableString = NSClassFromString(@"NSPlaceholderMutableString");
        
        [__NSCFString swizzleInstanceMethod:@selector(substringWithRange:) SwizzleSel:@selector(gm_substringWithRange:)];
        [__NSCFString swizzleInstanceMethod:@selector(appendString:) SwizzleSel:@selector(gm_appendString:)];
        [NSPlaceholderMutableString swizzleInstanceMethod:@selector(initWithString:) SwizzleSel:@selector(init_GM_WithString:)];
        [__NSCFString swizzleInstanceMethod:@selector(replaceCharactersInRange:withString:) SwizzleSel:@selector(gm_replaceCharactersInRange:withString:)] ;
    });
}


-(void)gm_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString{
    
    if ((range.location+range.length>self.length)||!aString) {
        return;
    }
    [self gm_replaceCharactersInRange:range withString:aString];
}

-(instancetype)init_GM_WithString:(NSString *)aString{
    if (!aString) {
        return nil;
    }
    return [self init_GM_WithString:aString];
}

-(void)gm_appendString:(NSString *)aString{
    if (!aString) {
        return;
    }
    [self gm_appendString:aString];
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

@end
