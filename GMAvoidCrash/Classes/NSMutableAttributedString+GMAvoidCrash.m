//
//  NSMutableAttributedString+GMAvoidCrash.m
//  MethodResolveDemo
//
//  Created by 小飞鸟 on 2019/12/24.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "NSMutableAttributedString+GMAvoidCrash.h"
#import "NSObject+CategoryMethod.h"
@implementation NSMutableAttributedString (GMAvoidCrash)

+(void)loadNSObjectAoidCrash{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class NSConcreteMutableAttributedString = NSClassFromString(@"NSConcreteMutableAttributedString");
        Class NSMutableAttributedString = NSClassFromString(@"NSMutableAttributedString");
        
        [NSConcreteMutableAttributedString swizzleInstanceMethod:@selector(initWithString:) SwizzleSel:@selector(init_GM_WithString:)];
        [NSMutableAttributedString swizzleInstanceMethod:@selector(addAttributes:range:) SwizzleSel:@selector(gm_addAttributes:range:)];
        [NSConcreteMutableAttributedString swizzleInstanceMethod:@selector(addAttribute:value:range:) SwizzleSel:@selector(gm_addAttribute:value:range:)];
    });
}

/*x添加 修饰*/
-(void)gm_addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range{
    
    if ((range.location+range.length>self.length)||!value) {
        return;
    }
    [self gm_addAttribute:name value:value range:range];
}

-(void)gm_addAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range{
    if ((range.location+range.length>self.length)||!attrs) {
        return;
    }
    [self gm_addAttributes:attrs range:range];
}
/*遗留问题 不能直接调用 self =[super initwithstring:]*/
-(instancetype)init_GM_WithString:(NSString *)str{
    
    if (!str) {
        return nil;
    }
    return [self init_GM_WithString:str];
}

@end
