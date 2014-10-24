//
//  Recording.m
//  SADPM3
//
//  Created by ono on 2014/10/24.
//  Copyright (c) 2014年 ono. All rights reserved.
//

#import "Recording.h"

@interface Recording ()

@end

@implementation Recording

@synthesize audioSession;
@synthesize avRecorder;
@synthesize avPlayer;

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
    NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [dir stringByAppendingPathComponent:@"test.caf"];
    NSURL *recordingURL = [NSURL fileURLWithPath:filePath];
    
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
    self.avRecorder = nil;
}

//--------------------------------------------
//戻る
//--------------------------------------------
- (IBAction)back:(id)sender {
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
    
    // 録音ファイルパス
    NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [dir stringByAppendingPathComponent:@"test.caf"];
    NSURL *recordingURL = [NSURL fileURLWithPath:filePath];
    
    //再生
    avPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:recordingURL error:nil];
    [avPlayer prepareToPlay];
    //avPlayer.delegate = self;
    avPlayer.volume=5.0;
    [avPlayer play];
}
@end
