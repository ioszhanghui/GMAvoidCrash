//
//  NSObject+NoCrash.m
//  MethodResolveDemo
//
//  Created by 小飞鸟 on 2019/12/20.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "NSObject+NoCrash.h"
#import <objc/runtime.h>
#import "NSObject+CategoryMethod.h"

@interface GMCrashManager : NSObject

FOUNDATION_STATIC_INLINE void crasHandler(id self,SEL _cmd);
@end

@implementation GMCrashManager

FOUNDATION_STATIC_INLINE void crasHandler(id self,SEL _cmd){
        NSLog(@"我是崩溃 处理");
}
@end

@implementation NSObject (NoCrash)

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        [self swizzleInstanceMethod:@selector(forwardingTargetForSelector:) SwizzleSel:@selector(gm_forwardingTargetForSelector:)];
        
        /*KVC 防崩溃 处理*/
        [self swizzleInstanceMethod:@selector(valueForUndefinedKey:) SwizzleSel:@selector(gm_valueForUndefinedKey:)];
        [self swizzleInstanceMethod:@selector(setValue:forUndefinedKey:) SwizzleSel:@selector(setgm_Value:forUndefinedKey:)];
        
        #pragma clang diagnostic pop
    });
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"value:----%@---key:---%@",value,key);
}

-(id)gm_valueForUndefinedKey:(NSString *)key{
    
    return nil;
}

-(id)gm_forwardingTargetForSelector:(SEL)aSelector{
    
    //当前类的方法实现
    Method  currentClassMethod = class_getInstanceMethod(self.class, @selector(forwardingTargetForSelector:));
    Method nsobjectMethod = class_getInstanceMethod([NSObject class], @selector(forwardingTargetForSelector:));
    
   BOOL isRewrite = (method_getImplementation(currentClassMethod)==method_getImplementation(nsobjectMethod));//是否重写了方法
    if (isRewrite) {
        
        Method signatureMethod  = class_getInstanceMethod([self class], @selector(methodSignatureForSelector:));
        Method objMethod = class_getInstanceMethod([NSObject class], @selector(methodSignatureForSelector:));
        BOOL signatureRewrite = signatureMethod==objMethod; //签名方法 是否重写了 YES 没有重写 NO 重写了
        
        if (signatureRewrite) {
            //为crash类 增加 方法
            class_addMethod([GMCrashManager class], aSelector, (IMP)crasHandler, "v@:");
            return [GMCrashManager new];
        }
    }
    
    return [self gm_forwardingTargetForSelector:aSelector];
}

@end
