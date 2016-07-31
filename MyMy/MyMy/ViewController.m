//
//  ViewController.m
//  MyMy
//
//  Created by yushichao on 16/7/24.
//  Copyright © 2016年 MMS. All rights reserved.
//

#import "ViewController.h"
#import "YSCTools.h"
#import "YSCUIKit.h"

//test
#import "PopViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *test1;
@property (nonatomic, assign) NSInteger testNum;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    _test1= @"yy";
//    NSString *st = [self nameWithInstance:_test1];
//    NSLog(@"%@", st);
//    [self getProperty];
//    
//    UIViewController *pop = [[PopViewController alloc] init];
//    [self.navigationController pushViewController:pop animated:YES];
    
//    NSURL *url = [NSURL URLWithString:@"tel://1008611"];
//    [[UIApplication sharedApplication] openURL:url];
    
    YSCHamburgeButton *menuButton = [[YSCHamburgeButton alloc] init];
//    menuButton.frame = CGRectMake(133, 133, 54, 54);
    menuButton.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
    UIEdgeInsets inset = UIEdgeInsetsMake(64, 0, self.view.bounds.size.height - 64 - 54, self.view.bounds.size.width - 54);
    [menuButton showInParentView:self.view withArea:inset withShowType:YSCHamburgeButtonShowTypeHamburge];
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
