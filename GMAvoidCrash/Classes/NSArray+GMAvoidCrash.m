//
//  NSArray+AvoidCrash.m
//  MethodResolveDemo
//
//  Created by 小飞鸟 on 2019/12/23.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "NSArray+GMAvoidCrash.h"
#import "NSObject+CategoryMethod.h"
#import <objc/runtime.h>

@implementation NSArray (GMAvoidCrash)

+(void)loadNSObjectAoidCrash{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        
        Class __NSArray = NSClassFromString(@"NSArray");
        Class __NSArrayI = NSClassFromString(@"__NSArrayI");//数组e个数 超过1个
        Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI"); //数组个数 一个 通过 alloc创建
        Class __NSArray0 = NSClassFromString(@"__NSArray0"); //空数组
        
        Class __NSPlaceholderArray = NSClassFromString(@"__NSPlaceholderArray");//未出初始化的array
        
        //@[] 数组防崩溃处理
        [__NSPlaceholderArray swizzleInstanceMethod:@selector(initWithObjects:count:) SwizzleSel:@selector(gm_initWithObjects:count:)];
        [__NSPlaceholderArray swizzleInstanceMethod:@selector(objectAtIndex:) SwizzleSel:@selector(gm_PlaceholderArrayobjectAtIndex:)];
        [__NSArray swizzleInstanceMethod:@selector(objectAtIndex:) SwizzleSel:@selector(gm_objectAtIndex:)];
        [__NSArrayI swizzleInstanceMethod:@selector(objectAtIndex:) SwizzleSel:@selector(gm_NSArrayIobjectAtIndex:)];
        [__NSArrayI swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) SwizzleSel:@selector(gm_objectAtIndexedSubscript:)];
        [__NSSingleObjectArrayI swizzleInstanceMethod:@selector(objectAtIndex:) SwizzleSel:@selector(gm_SingleObjectArrayIobjectAtIndex:)];
        [__NSArray0 swizzleInstanceMethod:@selector(objectAtIndex:) SwizzleSel:@selector(gm_NSArray0objectAtIndex:)];
        #pragma clang diagnostic pop
    });
}

-(id)gm_objectAtIndexedSubscript:(NSUInteger)idx{
    if (idx>self.count-1) {
        return  nil;
    }
    return [self gm_objectAtIndexedSubscript:idx];
}

-(instancetype)gm_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt{
    
    id newObjects [cnt]  ;//创建 新的一个
    int index =0;//添加的索引
    for (int i=0; i<cnt; i++) {
        if (objects[i]) {
            newObjects[index]=objects[i];
            index++;
        }
    }
    return [self gm_initWithObjects:newObjects count:index];
}

//PlaceholderArray
-(id)gm_PlaceholderArrayobjectAtIndex:(NSUInteger)index{
    
     if (exceptionArray(self)) return nil;
    
    if (self.count>index) {
        return [self gm_PlaceholderArrayobjectAtIndex:index];
    }
    return nil;
}

//__NSArray0
-(id)gm_NSArray0objectAtIndex:(NSUInteger)index{
    
     if (exceptionArray(self)) return nil;

    if (self.count>index) {
        return [self gm_NSArray0objectAtIndex:index];
    }
    return nil;
}

//___SingleObjectArrayI
-(id)gm_SingleObjectArrayIobjectAtIndex:(NSUInteger)index{
    
     if (exceptionArray(self)) return nil;
    
    if (self.count>index) {
        return [self gm_SingleObjectArrayIobjectAtIndex:index];
    }
    return nil;
}


//__NSArrayI
-(id)gm_NSArrayIobjectAtIndex:(NSUInteger)index{
    
     if (exceptionArray(self)) return nil;
    
    if (self.count>index) {
        return [self gm_NSArrayIobjectAtIndex:index];
    }
    return nil;
}

//获取alloc类的数组
FOUNDATION_STATIC_INLINE Class placeholderArrayClass(){
    
    return NSClassFromString(@"__NSPlaceholderArray");
}

//判断 数组 1.是否是本类 2.是否不存在 3.是否是 未init的数组
FOUNDATION_STATIC_INLINE BOOL exceptionArray(id self){
    if (!self||![self isKindOfClass:[NSArray class]]||[self isKindOfClass:placeholderArrayClass()]) {
        return YES;
    }
    return NO;
}


// __NSArray的数据交换
-(id)gm_objectAtIndex:(NSUInteger)index{
    
    if (exceptionArray(self)) return nil;
    if (self.count>index) {
        return [self gm_objectAtIndex:index];
    }
    return nil;
}

@end
