//
//  NSMutableArray+GMAvoidCrash.m
//  MethodResolveDemo
//
//  Created by 小飞鸟 on 2019/12/23.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "NSMutableArray+GMAvoidCrash.h"
#import "NSObject+CategoryMethod.h"

@implementation NSMutableArray (GMAvoidCrash)

+(void)loadNSObjectAoidCrash{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class  __NSArrayM = NSClassFromString(@"__NSArrayM");
        Class  __NSPlaceholderArray = NSClassFromString(@"__NSPlaceholderArray");
       
        //获取方法替换
        [__NSArrayM swizzleInstanceMethod:@selector(objectAtIndex:) SwizzleSel:@selector(gm_objectAtIndex:)];
        [__NSPlaceholderArray swizzleInstanceMethod:@selector(objectAtIndex:) SwizzleSel:@selector(gm_PlaceholderArrayobjectAtIndex:)];
        //数据插入
        [__NSArrayM swizzleInstanceMethod:@selector(insertObject:atIndex:) SwizzleSel:@selector(gm_insertObject:atIndex:)];
        //移除数据
        [__NSArrayM swizzleInstanceMethod:@selector(removeObjectAtIndex:) SwizzleSel:@selector(gm_removeObjectAtIndex:)];
        [__NSArrayM swizzleInstanceMethod:@selector(removeObjectsInRange:) SwizzleSel:@selector(gm_removeObjectsInRange:)];
        //替换
        [__NSArrayM swizzleInstanceMethod:@selector(replaceObjectAtIndex:withObject:) SwizzleSel:@selector(gm_replaceObjectAtIndex:withObject:)];
    });
}



//数据替换
-(void)gm_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    if (insertAvailabletObject(self,anObject,index)) return;
    [self gm_replaceObjectAtIndex:index withObject:anObject];
}

//数据移除
-(void)gm_removeObjectAtIndex:(NSUInteger)index{
    if (insertAvailabletObject(self,self,index)) return;
    [self gm_removeObjectAtIndex:index];
}

-(void)gm_removeObjectsInRange:(NSRange)range{
    if (insertAvailabletObject(self,self,range.location+range.length)) return;
    [self gm_removeObjectsInRange:range];
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

FOUNDATION_STATIC_INLINE BOOL insertAvailabletObject(NSMutableArray* array,id anObject,NSUInteger index){
    if (exceptionArray(array)) return YES;
    if(index>array.count||!anObject) return YES;
    return NO;
}

-(void)gm_insertObject:(id)anObject atIndex:(NSUInteger)index{
    
    if (insertAvailabletObject(self,anObject,index)) return;
    [self gm_insertObject:anObject atIndex:index];
}

//获取一个数据 防崩溃
-(id)gm_objectAtIndex:(NSUInteger)index{
    
    if (exceptionArray(self))  return  nil;
    if (self.count>index&&(index>=0)) {
        return [self gm_objectAtIndex:index];
    }
    return nil;
}

//获取一个数据 防崩溃
-(id)gm_PlaceholderArrayobjectAtIndex:(NSUInteger)index{
    
    if (exceptionArray(self))  return  nil;
    if (self.count>index) {
        return [self gm_PlaceholderArrayobjectAtIndex:index];
    }
    return nil;
}
@end
