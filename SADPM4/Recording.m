//
//  Recording.m
//  SADPM3
//
//  Created by ono on 2014/10/24.
//  Copyright (c) 2014年 ono. All rights reserved.
//

//todo
//同じ名前の時

#import "Recording.h"

@interface Recording ()

@end

@implementation Recording

@synthesize audioSession;
@synthesize avRecorder;
@synthesize avPlayer;
@synthesize userID;
@synthesize tempPath;
@synthesize addPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //======
    userID = @"test";
    //======
    tempPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"temp.caf"];
    addPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:userID];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:tempPath]){
        addButton.hidden = YES;
    }
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



//--------------------------------------------
//録音のための準備
//--------------------------------------------
- (void)recordFile{
    audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    // 使用している機種が録音に対応しているか
    if ([audioSession isInputAvailable]) {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    }
    if(error){
        NSLog(@"Error when preparing audio session :%@", [error localizedDescription]);
        return;
    }
    // 録音機能をアクティブにする
    [audioSession setActive:YES error:&error];
    if(error){
        NSLog(@"Error when enabling audio session :%@", [error localizedDescription]);
        return;
    }
    
    // 録音ファイルパス
    NSURL *recordingURL = [NSURL fileURLWithPath:tempPath];
    
    // 録音中に音量をとる場合はYES
    //    AvRecorder.meteringEnabled = YES;
    
    avRecorder = [[AVAudioRecorder alloc] initWithURL:recordingURL settings:nil error:&error];
    
    if(error){
        NSLog(@"error = %@",error);
        return;
    }
    //avRecorder.delegate=self;
    //５秒録音して終了する場合
    [avRecorder recordForDuration: 5.0];
    [avRecorder record];
}

//--------------------------------------------
//録音停止
//--------------------------------------------
- (void)stopRecording{
    [avRecorder stop];
    addButton.hidden = NO;
    self.avRecorder = nil;
}

//--------------------------------------------
//戻る
//--------------------------------------------
- (IBAction)back:(id)sender {
    //一時ファイル削除
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:tempPath]){
        [fileManager removeItemAtPath:tempPath error:&error];
        NSLog(@"del");
    }
    //戻る
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//--------------------------------------------
//クリックされたら録音or停止
//--------------------------------------------
- (IBAction)recording:(id)sender {
    //if ( self.avRecorder != nil && self.avRecorder.isRecording ){
    if ( self.avRecorder != nil){
        [self stopRecording];
        [reco setTitle:@"録音" forState:UIControlStateNormal];
    }else{
        [reco setTitle:@"停止" forState:UIControlStateNormal];
        [self recordFile];
    }
}

//--------------------------------------------
//クリックされたら再生
//--------------------------------------------
- (IBAction)play:(id)sender {
    audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
    NSError *error = nil;
    
    // 録音ファイルパス
    NSURL *recordingURL = [NSURL fileURLWithPath:tempPath];
    
    //再生
    avPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:recordingURL error:&error];
    if(error){
        NSLog(@"error = %@",error);
        return;
    }
    [avPlayer prepareToPlay];
    //avPlayer.delegate = self;
    avPlayer.volume=5.0;
    [avPlayer play];
}

//--------------------------------------------
//クリックされたら追加
//--------------------------------------------
- (IBAction)add:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"名前" message:@"入れてね" delegate:self
                             cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

//--------------------------------------------
//追加時のアラート
//--------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    switch (buttonIndex) {
        case 1:{
            [fileManager moveItemAtPath:tempPath
                                 toPath:[addPath stringByAppendingPathComponent:[[alertView textFieldAtIndex:0].text stringByAppendingString:@".caf"]]
                                  error:&error];
            NSLog(@"1");
            //UIViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"VoiceNavi"];
            //[self presentViewController:controller animated:YES completion:nil];//YESならModal,Noなら何もなし
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        }
        default:
            NSLog(@"2");
            break;
    }
}

@end

