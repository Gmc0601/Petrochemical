//
//  InformationDetailViewController.m
//  BaseProject
//
//  Created by Yitian on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "InformationDetailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
@interface InformationDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) AVPlayer *player;

@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"咨询详情"];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    [self.view addSubview:webView];
    WeakSelf(ws);
    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.dateLabel.mas_bottom);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)playVideo{
   
    NSURL *playUrl = [NSURL URLWithString:@"http://baobab.wdjcdn.com/14573563182394.mp4"];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:playUrl];
    //如果要切换视频需要调AVPlayer的replaceCurrentItemWithPlayerItem:方法
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.view.bounds;
    //放置播放器的视图
    [self.view.layer addSublayer:playerLayer];
    [_player play];
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
