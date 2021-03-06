//
//  SetTime.m
//  SADPM3
//
//  Created by ono on 2014/10/24.
//  Copyright (c) 2014年 ono. All rights reserved.
//

#import "SetTime.h"
#import <Parse/Parse.h>

@interface SetTime ()

@end

@implementation SetTime

@synthesize dp, tf;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//データのストア
- (IBAction)storeTimer:(id)sender {
    PFObject *objectData = [[PFObject alloc] initWithClassName:@"Test"];
    //ユーザ名の取得
    NSString *user = self.tf.text;
    [objectData setObject:user forKey:@"name"];
    
    //時間の取得
    //ラベルに指定したフォーマットで表示
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    NSString *inputDateStr = @"yyyy/MM/dd HH:mm:ss Z";
    [inputDateFormatter setDateFormat:inputDateStr];
    //NSString *intputDateStr = @"2000/01/02 03:04:05 +0000";
    NSString *intputDateStr = [inputDateFormatter stringFromDate:dp.date];
    NSDate *dates = [inputDateFormatter dateFromString:intputDateStr];
    [objectData setObject:dates forKey:@"Time"];
    
    //保存する
    [objectData save];
    NSString *msg = @"登録に成功しました。";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

@end
