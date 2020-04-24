//
//  ViewController.m
//  MSCLunarDateDemo
//
//  Created by MiaoShichang on 2020/4/24.
//  Copyright © 2020 MiaoShichang. All rights reserved.
//

#import "ViewController.h"
#import "MSCLunarDate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 阳历转农历
    NSDate *date = [NSDate date];
    MSCLunarDate *toLunarDate = [MSCLunarDate lunarDateWithDate:date];
    NSLog(@"lunarDate = %@", toLunarDate);
    
    // 农历转阳历
    MSCLunarDate *lunarDate = [MSCLunarDate lunarDate];
    lunarDate.year = 2020;
    lunarDate.month = 4;
    lunarDate.day = 3;
    lunarDate.bLeap = YES;
    NSDate *toDate = [lunarDate toSolarDate];
    NSLog(@"date = %@", toDate);
    
}



@end
