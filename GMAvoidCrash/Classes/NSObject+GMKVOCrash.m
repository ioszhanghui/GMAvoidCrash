//
//  NSObject+TestKVOCrash.m
//  MethodResolveDemo
//
//  Created by 小飞鸟 on 2019/12/25.
//  Copyright © 2019 小飞鸟. All rights reserved.
//

#import "NSObject+GMKVOCrash.h"
#import "NSObject+CategoryMethod.h"
#import <objc/runtime.h>

#import <pthread.h>

#define lock(_lock) pthread_mutex_lock(&_lock) //加锁
#define unlock(_lock) pthread_mutex_unlock(&_lock) //解锁


static const char managerKey; //管理者


@interface GMKVOManager : NSObject
/*存储容器*/
@property(nonatomic,strong)NSMapTable * maptable;
/*添加 数据*/
-(void)pushObj:(id)obj Key:(id)key;
/*查询 y是否已经被 管理*/
-(BOOL)queryObjForKey:(id)key;
/*获取 hash之后的key*/
-(id)keyValue:(NSObject*)observer key:(NSString*)key;

@end

@implementation GMKVOManager{
    
    pthread_mutex_t _lock;//互斥锁
}

-(instancetype)init{
    if (self=[super init]) {
        pthread_mutex_init(&_lock, NULL);
        self.maptable = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableWeakMemory];
    }
    return self;
}

-(id)keyValue:(NSObject*)observer key:(NSString*)key{
    
    NSString *  hashKey = [NSString stringWithFormat:@"%@_%@",NSStringFromClass(observer.class),key];
    return hashKey;
}

/*查询 y是否已经被 管理*/
-(BOOL)queryObjForKey:(id)key{
    lock(_lock);
     id obj = [self.maptable objectForKey:key];
    unlock(_lock);
    return !obj? NO:YES;
}

-(void)popObj:(id)obj Key:(id)key{
    lock(_lock);
    [self.maptable removeObjectForKey:key];
    unlock(_lock);
}

-(void)pushObj:(id)obj Key:(id)key{
    lock(_lock);
    [self.maptable setObject:obj forKey:key];
    unlock(_lock);
}
@end


@interface GMKVOReference : NSObject
/*被观察者*/
@property(nonatomic,weak)NSObject * target;
/*观察者*/
@property(nonatomic,weak)NSObject * observer;
/*keypath属性*/
@property(nonatomic,copy)NSString * keypath;
/*相互引用的指针*/
@property(nonatomic,weak)GMKVOReference * reference;

@end

@implementation GMKVOReference


-(void)dealloc{
    
    if (_reference) {
        [_target removeObserver:_observer forKeyPath:_keypath];
    }
}

@end

@implementation NSObject (GMKVOCrash)

+(void)loadNSObjectAoidCrash{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(addObserver:forKeyPath:options:context:) SwizzleSel:@selector(gm_addObserver:forKeyPath:options:context:)];
    });
}



/*添加管理者*/
NS_INLINE GMKVOManager* addManager(id self){
    
  GMKVOManager * manager = objc_getAssociatedObject(self, &managerKey);
    if (manager) {
        return manager;
    }
    manager = [GMKVOManager new];
    objc_setAssociatedObject(self, &managerKey, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return manager;
}

-(void)gm_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    
    //被观察者->manager->maptable->观察者->被观察者
    GMKVOManager * manager = addManager(self); //添加管理者
    id key = [manager keyValue:observer key:keyPath];
    if ([manager queryObjForKey:key]) {
        //如果已经被管理了 那就 不错操作
        return;
    }
    [manager pushObj:observer Key:key];
    
    //被观察者->manager1->manager2
    //观察者->manager2->manager1
    
    GMKVOReference * observerObj = [GMKVOReference new];
    GMKVOReference * addObj = [GMKVOReference new];
    addObj.target = observerObj.target = self;
    addObj.observer = observerObj.observer =observer;
    addObj.keypath = observerObj.keypath = keyPath;
    addObj.reference = observerObj;
    observerObj.reference = addObj;
    
    const char * addKeyPath  = [[keyPath mutableCopy] UTF8String];
    const char * observerKeypath = [[keyPath mutableCopy] UTF8String];
    
    objc_setAssociatedObject(self, addKeyPath, addObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(observer, observerKeypath, observerObj,OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

@end
