//
//  ViewController.m
//  MyMy
//
//  Created by yushichao on 16/7/24.
//  Copyright © 2016年 MMS. All rights reserved.
//

#import "ViewController.h"
#import "YSCTools.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *test1;
@property (nonatomic, assign) NSInteger testNum;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _test1= @"yy";
    NSString *st = [self nameWithInstance:_test1];
    NSLog(@"%@", st);
    [self getProperty];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
