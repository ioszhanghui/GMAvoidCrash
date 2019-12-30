//
//  GMViewController.m
//  GMAvoidCrash
//
//  Created by ioszhanghui@163.com on 12/26/2019.
//  Copyright (c) 2019 ioszhanghui@163.com. All rights reserved.
//

#import "GMViewController.h"
#import "GMCrashLoadManager.h"

@interface GMViewController ()

@end

@implementation GMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GMCrashLoadManager effectiveAvoidCrashMethod];
    
    NSObject * obj = [NSObject new];
    NSLog(@"%@",[obj valueForKey:@"name"]);
    [obj setValue:@"2" forKey:@"name"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
