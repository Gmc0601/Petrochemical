//
//  InformationDetailViewController.m
//  BaseProject
//
//  Created by Yitian on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "InformationDetailViewController.h"
#import <AVFoundation/AVFoundation.h>

#import <AVKit/AVKit.h>
#import "Masonry.h"
@interface InformationDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (nonatomic,strong) AVPlayerViewController *player;
@property (strong, nonatomic)AVPlayerItem *item;
@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomerTitle:@"咨询详情"];
    if (0) {
        self.webView = [[UIWebView alloc] init];
        self.webView.delegate = self;
        [self.view addSubview:self.webView];
        WeakSelf(ws);
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.dateLabel.mas_bottom);
            make.left.mas_offset(0);
            make.right.mas_offset(0);
            make.bottom.mas_offset(0);
        }];
    }
    else{
        WeakSelf(ws);
        self.videoView = [[UIView alloc] init];
        self.videoView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:self.videoView];
        [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.dateLabel.mas_bottom);
            make.left.mas_offset(0);
            make.right.mas_offset(0);
            make.height.mas_equalTo(kScreenW/2);
        }];
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton addTarget:self action:@selector(clickPlayer:) forControlEvents:UIControlEventTouchUpInside];
        [playButton setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
        [self.videoView addSubview:playButton];
        
        [playButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws.videoView);
        }];
      
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        if ([keyPath isEqualToString:@"status"]) {
            
            AVPlayerItem *item = object;
            NSInteger stauts = item.status;
            NSLog(@"播放失败%ld",stauts);
        }
    }
}

-(void)clickPlayer:(UIButton *)sender{
    sender.hidden = YES;
    NSURL *playUrl = [NSURL URLWithString:@"http://record.ytlive.cn/record/ytlive/live_15293/2018-03-18-15:24:37_2018-03-18-15:50:41.mp4"];
   _item = [AVPlayerItem playerItemWithURL:playUrl];
    //如果要切换视频需要调AVPlayer的replaceCurrentItemWithPlayerItem:方法
   _player = [[AVPlayerViewController alloc]init];
    _player.player = [AVPlayer playerWithPlayerItem:_item];
    
    _player.showsPlaybackControls = YES;
    _player.view.frame = CGRectMake(0, 0, kScreenW, kScreenW/2);
  
    [self addChildViewController:_player];
    //添加子视图
    [self.videoView addSubview:_player.view];
    [_item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_player.player play];
}

-(void)dealloc{
     [self.item removeObserver:self forKeyPath:@"status"];
    //self.player.player
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
