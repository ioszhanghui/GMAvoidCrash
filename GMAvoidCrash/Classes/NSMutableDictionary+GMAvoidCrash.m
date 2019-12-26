//
//  NSMutableDictionary+GMAvoidCrash.m
//  MethodResolveDemo
//
//  Created by 小飞鸟 on 2019/12/23.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "NSMutableDictionary+GMAvoidCrash.h"
#import "NSObject+CategoryMethod.h"

@implementation NSMutableDictionary (GMAvoidCrash)
+(void)loadNSObjectAoidCrash{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//__NSDictionaryM  __NSSingleEntryDictionaryI
        
        Class __NSSingleEntryDictionaryI = NSClassFromString(@"__NSDictionaryM");
        [__NSSingleEntryDictionaryI swizzleInstanceMethod:@selector(setObject:forKey:) SwizzleSel:@selector(gm_setObject:forKey:)];
        [__NSSingleEntryDictionaryI swizzleInstanceMethod:@selector(removeObjectForKey:) SwizzleSel:@selector(gm_removeObjectForKey:)];
        
    });
}

FOUNDATION_STATIC_INLINE BOOL insertAvailable(NSMutableDictionary * dict,id value,NSString *key){
    
    if (![dict isKindOfClass:[NSMutableDictionary class]]||!value||!key) {
        return NO;
    }
    return YES;
}

/*setValue:forKey:*/
-(void)gm_setObject:(id)value forKey:(NSString *)key{
    if (!insertAvailable(self, value, key)) return;

    [self gm_setObject:value forKey:key];
}

-(void)gm_removeObjectForKey:(id)aKey{
    if (!insertAvailable(self,self, aKey)) return;
    [self gm_removeObjectForKey:aKey];
}

@end
