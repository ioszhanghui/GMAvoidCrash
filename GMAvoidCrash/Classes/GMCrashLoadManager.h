//
//  GMCrashManager.h
//  MethodResolveDemo
//
//  Created by 小飞鸟 on 2019/12/26.
//  Copyright © 2019 小飞鸟. All rights reserved.
//


#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMCrashLoadManager : NSObject

/*生效 防崩溃方法*/
+(void)effectiveAvoidCrashMethod;

@end

NS_ASSUME_NONNULL_END
