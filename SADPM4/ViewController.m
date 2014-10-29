//
//  ViewController.m
//  SADPM4
//
//  Created by kawakami_mac on 2014/10/24.
//  Copyright (c) 2014年 kawakami_mac. All rights reserved.
//  test comment
// kawakamitest

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)t_resister:(UIButton *)sender {
    NSString *urlString = @"https://twitter.com/?lang=ja";
    NSURL *url = [NSURL URLWithString:urlString];
    
    // ブラウザを起動する
    [[UIApplication sharedApplication] openURL:url];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
