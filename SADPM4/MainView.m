//
//  MainView.m
//  SADPM3
//
//  Created by ono on 2014/10/24.
//  Copyright (c) 2014年 ono. All rights reserved.
//

#import "MainView.h"

@interface MainView ()

@end

@implementation MainView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore
     requestAccessToAccountsWithType:twitterAccountType
     options:nil
     completion:^(BOOL granted, NSError *error)
     {
         if (!granted) {
             NSLog(@"ユーザーがアクセスを拒否しました。");
         }else{
             NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType]; // 追加
             NSLog(@"twitterAccounts = %@", twitterAccounts); // 追加
             if ([twitterAccounts count] > 0) { // 追加
                 ACAccount *account = [twitterAccounts objectAtIndex:0]; // 追加
                 NSLog(@"account = %@", account); // 追加
             }else{
                 NSLog(@"account = null");
             } // 追加
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
