//
//  NSDictionary+GMAvoidCrash.m
//  MethodResolveDemo
//
//  Created by 小飞鸟 on 2019/12/23.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "NSDictionary+GMAvoidCrash.h"
#import "NSObject+CategoryMethod.h"
#import <objc/runtime.h>

@implementation NSDictionary (GMAvoidCrash)

+(void)loadNSObjectAoidCrash{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        /*  __NSDictionaryI
            __NSSingleEntryDictionaryI
            __NSDictionary0
            __NSPlaceholderDictionary
         */
             
        Class NSDictionary = NSClassFromString(@"NSDictionary");
                
        //NSDictionary构造方法
        [NSDictionary swizzleClassMethod:@selector(dictionaryWithObjectsAndKeys:) SwizzleSel:@selector(gm_dictionaryWithObjectsAndKeys:)];
        //@{} 崩溃的处理        
        [NSDictionary swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) SwizzleSel:@selector(avoidCrashDictionaryWithObjects:forKeys:count:)];
    });
}

FOUNDATION_STATIC_INLINE BOOL isNilObject(id objject){
    if (!objject) {
        return YES;
    }
    return NO;
}

+(instancetype)gm_dictionaryWithObjectsAndKeys:(id)firstObject, ...NS_REQUIRES_NIL_TERMINATION{

    NSMutableArray *  newObjects= [NSMutableArray arrayWithObjects:firstObject, nil]; ;//存放 object
    NSMutableArray * newkeys= [NSMutableArray array]; ;//存放 object

    va_list args;
    id object;
    va_start(args, firstObject);
    unsigned index =0;
    while ((object=va_arg(args, id))) {
        if (index%2!=0) {
            //不能被2整除 就是 为key的时候
            if (!isNilObject(object)) {
                newkeys[index]= object;
                index++;
            }else{
                newObjects[index] = nil;
            }
        }else{
            if (!isNilObject(object)) {
                index==0? (newkeys[index]= object):(newObjects[index]= object);
            }
        }
    }
    va_end(args);
    
    return [NSDictionary dictionaryWithObjects:newObjects forKeys:newkeys];
}

+ (instancetype)avoidCrashDictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt{
    
    id newObjects[cnt]; //新处理的数组
    id newKeys[cnt]; //新处理的key
    unsigned index = 0; //新的个数
    for (unsigned i=0; i<cnt; i++) {
        id obj =objects[i];
        id key = keys[i];
        if (obj&&key) {
            newKeys[index]=key;
            newObjects[index] =obj;
            index++;
        }
    }
    return [self avoidCrashDictionaryWithObjects:newObjects forKeys:newKeys count:index];
}

@end
