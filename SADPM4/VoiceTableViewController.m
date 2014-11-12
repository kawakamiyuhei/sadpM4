//
//  VoiceTableViewController.m
//  SADPM4
//
//  Created by ono on 2014/11/02.
//  Copyright (c) 2014年 kawakami_mac. All rights reserved.
//

#import "VoiceTableViewController.h"

@interface VoiceTableViewController ()

@end

@implementation VoiceTableViewController

@synthesize list;
@synthesize userID;
@synthesize dir;
@synthesize tempPath;
@synthesize avPlayer;
@synthesize audioSession;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //========
    userID = @"test";
    //=========
    
    dir = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:userID];
    //dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    tempPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"temp.caf"];
    
    //ディレクトリの作成
    if (![fileManager fileExistsAtPath:dir]){
        BOOL created = [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
        if (!created) {
            NSLog(@"failed to create directory. reason is %@ - %@", error, error.userInfo);
        }
        NSLog(@"directory %@ is created.", dir);
    }

    list = [[fileManager contentsOfDirectoryAtPath:dir error:&error] mutableCopy];
    
    [list addObject:@"新規音声録音...."];
    // test
    //list = [[NSArray alloc]initWithObjects: @"Snoopy", @"Spike", @"Olaf",@"Marbles", @"Belle", @"Andy", nil];
    for (NSString *path in list) {
        NSLog(@"%@", path);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//--------------------------------------------
//セクション数
//--------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//--------------------------------------------
//何列表示するか
//--------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"numberOfRowsInSection");
    if (self.tableView.isEditing){
        return [list count];
    }else{
        return [list count]-1;
    }
}

//--------------------------------------------
//cell
//--------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //cell.textLabel.text = [list objectAtIndex:indexPath.row];
    cell.textLabel.text = [[list objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(0, [NSString stringWithFormat:@"%@", [list objectAtIndex:indexPath.row]].length-4)];
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
//--------------------------------------------
//編集時の各操作
//--------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    //削除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //ファイル削除
        NSString *file = [dir stringByAppendingPathComponent:[list objectAtIndex:indexPath.row]];
        [fileManager removeItemAtPath:file error:&error];
        //リストから削除
        [list removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    //挿入
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        if ([fileManager fileExistsAtPath:tempPath]){
            [fileManager removeItemAtPath:tempPath error:&error];
        }
        //Recordingに移動
        UIViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"RecordingNavi"];
        [self presentViewController:controller animated:YES completion:nil];//YESならModal,Noなら何もなし
    }   
}

//--------------------------------------------
//編集時の各セルの操作割り当て
//--------------------------------------------
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //最後のセルだけ挿入操作，他は削除
    if(list.count == indexPath.row+1) return UITableViewCellEditingStyleInsert;
    return UITableViewCellEditingStyleDelete;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//--------------------------------------------
//セル選択時(再生)
//--------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
    NSError *error = nil;
    
    // 録音ファイルパス
    NSString *url = [dir stringByAppendingPathComponent:[list objectAtIndex:indexPath.row]];
    NSURL *recordingURL = [NSURL fileURLWithPath:url];
    NSLog(@"file %@",[list objectAtIndex:indexPath.row]);
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
//戻るボタン
//--------------------------------------------
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//--------------------------------------------
//編集ボタン
//--------------------------------------------
- (IBAction)edit:(id)sender {
    //編集中か否か
    if (self.tableView.isEditing){
        [self setEditing:false animated:YES];
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2f];
        //[self.tableView reloadData];
        //[self viewWillAppear:YES];
        [edit setTitle:@"編集"];
    }else{
        [self setEditing:true animated:YES];
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2f];
        [edit setTitle:@"完了"];
    }
}

//--------------------------------------------
//Recordingから戻ってきたとき
//--------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear1");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (self.tableView.isEditing){
        list = [[fileManager contentsOfDirectoryAtPath:dir error:&error] mutableCopy];
        [list addObject:@"新規音声録音...."];
        [self setEditing:false animated:YES];
        [self.tableView reloadData];
        [edit setTitle:@"編集"];
    }
    [super viewWillDisappear:animated];
    NSLog(@"viewWillAppear2");
    NSLog(@"list length = %lu", (unsigned long)[list count]);
}
@end

// カスタムセル
@implementation CustomOneCell

@end
