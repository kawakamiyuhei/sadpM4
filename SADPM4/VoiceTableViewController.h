//
//  VoiceTableViewController.h
//  SADPM4
//
//  Created by ono on 2014/11/02.
//  Copyright (c) 2014年 kawakami_mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface VoiceTableViewController : UITableViewController{
    IBOutlet UIBarButtonItem *edit;
}

@property (retain,nonatomic)AVAudioPlayer *avPlayer;
@property (retain,nonatomic)AVAudioSession *audioSession;
@property (retain,nonatomic)NSMutableArray *list;
@property (retain,nonatomic)NSString *userID;
@property (retain,nonatomic)NSString *dir;
@property (retain,nonatomic)NSString *tempPath;


@end

// カスタムセル
@interface CustomOneCell : UITableViewCell

@end