//
//  Recording.h
//  SADPM3
//
//  Created by ono on 2014/10/24.
//  Copyright (c) 2014年 ono. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface Recording : UIViewController{
    IBOutlet UIButton *reco;
    IBOutlet UIButton *addButton;
    IBOutlet UIButton *playButton;
}
@property (retain,nonatomic)AVAudioRecorder *avRecorder;
@property (retain,nonatomic)AVAudioSession *audioSession;
@property (retain,nonatomic)AVAudioPlayer *avPlayer;
@property (retain,nonatomic)NSString *userID;
@property (retain,nonatomic)NSString *tempPath;
@property (retain,nonatomic)NSString *addPath;


@end

