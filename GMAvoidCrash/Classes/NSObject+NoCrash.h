//
//  NSObject+NoCrash.h
//  MethodResolveDemo
//
//  Created by 小飞鸟 on 2019/12/20.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import <Foundation/Foundation.h>

/*1.unrecognized selector crash
 *2.KVO crash
 *3.NSNotification crash
 *4.NSTimer crash
 *5.Container crash（数组越界，插nil等）
 *6.NSString crash （字符串操作的crash）
 *7.UI not on Main Thread Crash (非主线程刷UI(机制待改善))
 */


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NoCrash)

@end

NS_ASSUME_NONNULL_END
