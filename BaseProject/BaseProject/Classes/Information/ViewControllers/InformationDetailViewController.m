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
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "NSString+commom.h"
@interface InformationDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic)  UIWebView *webView;
@property (strong, nonatomic)  UIView *videoView;
@property (strong, nonatomic)  UIImageView *coverImageView;
@property (nonatomic,strong) AVPlayerViewController *player;
@property (strong, nonatomic)AVPlayerItem *item;
@property (weak, nonatomic) IBOutlet UIView *shareView;

@property (strong, nonatomic)NSDictionary *infoDic;
@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type==0) {
        [self setCustomerTitle:@"资讯详情"];
        
//        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        shareButton.frame = CGRectMake(0, 0, 44, 44);
//        [shareButton setImage:[UIImage imageNamed:@"2.8.0share"] forState:UIControlStateNormal];
//
//        [shareButton addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
//        shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth / 375.0)];
//
//        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    else{
      [self setCustomerTitle:@"通知详情"];
    }
    [self requestDetail];
    // Do any additional setup after loading the view from its nib.
}

-(void)rightBarClick{
    self.shareView.hidden = NO;
   [self.view bringSubviewToFront:self.shareView ];
}

-(void)initView{
    NSString * video = validString(self.infoDic[@"video"]);
    self.nameLabel.text = self.infoDic[@"title"];
    self.dateLabel.text = self.infoDic[@"create_time"];
    if (video.length) {
        
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
        
        self.coverImageView = [[UIImageView alloc] init];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:@"img"]?:@""] placeholderImage:DefaultImage];
        [self.videoView addSubview:self.coverImageView];
        [self.coverImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws.videoView);
        }];
        
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton addTarget:self action:@selector(clickPlayer:) forControlEvents:UIControlEventTouchUpInside];
        [playButton setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
        [self.videoView addSubview:playButton];
        
        [playButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws.videoView);
        }];
    }
    else{
        self.webView = [[UIWebView alloc] init];
        self.webView.delegate = self;
        [self.view addSubview:self.webView];
        NSString *content = self.infoDic[@"content"];
        [self.webView loadHTMLString:validString(content) baseURL:nil];
        
        WeakSelf(ws);
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.dateLabel.mas_bottom);
            make.left.mas_offset(0);
            make.right.mas_offset(0);
            make.bottom.mas_offset(0);
        }];
    }
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

-(void)requestDetail{
    NSString *usertoken = [ConfigModel getStringforKey:UserToken];
    NSDictionary *dic = @{
                          @"id":self.idString,
                          @"userToken":usertoken,
                          };
    NSString *urlString ;
    if (self.type==0) {
        urlString = @"_information_details_001";
    }
    else{
        urlString = @"_message_particulars_001";
    }
    
    [HttpRequest postPath:urlString params:dic resultBlock:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = responseObject;
        
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            _infoDic = dic[@"info"];
            [self initView];
        }else {
            NSString *errorStr = dic[@"info"];
            NSLog(@"%@", errorStr);
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
}

-(void)clickPlayer:(UIButton *)sender{
    sender.hidden = YES;
    self.coverImageView.hidden = YES;
    NSString * video = validString(self.infoDic[@"video"]);
    NSURL *playUrl = [NSURL URLWithString:video];
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

- (IBAction)clickCloseShare:(id)sender {
    self.shareView.hidden = YES;
}
#pragma mark -- methond
- (IBAction)shareWXAction:(id)sender {
    self.shareView.hidden = YES;
    [self weixinShare:0];
}
- (IBAction)sharePYQAction:(id)sender {
    self.shareView.hidden = YES;
    [self weixinShare:1];
}

- (IBAction)shareQQAction:(id)sender {
    self.shareView.hidden = YES;
    [self shareQQMethod:0];
}
- (IBAction)shareKJAction:(id)sender {
    self.shareView.hidden = YES;
  //  [self shareQQMethod:1];
}

- (void) weixinShare:(int ) scene{
    
    NSString *kLinkTitle = self.infoDic[@"title"];
    NSString *kLinkDescription = self.infoDic[@"title"];
    SendMessageToWXReq *req1 = [[SendMessageToWXReq alloc]init];
    
    // 是否是文档
    req1.bText =  NO;
    
    //    WXSceneSession  = 0,        /**< 聊天界面    */
    //    WXSceneTimeline = 1,        /**< 朋友圈      */
    //    WXSceneFavorite = 2,
    
    if (scene == 0) {
        req1.scene = WXSceneSession;
    }else{
        req1.scene = WXSceneTimeline;
    }
    
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = kLinkTitle;//分享标题
    urlMessage.description = kLinkDescription;//分享描述
    
    WXImageObject *webObj = [WXImageObject object];
    
    NSString *imgPath = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:self.infoDic[@"img"]]];
    UIImage *image00 = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgPath];
    

     NSData *imageData = UIImagePNGRepresentation(image00);
    webObj.imageData = imageData;//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;

    req1.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:req1];
}


- (void) shareQQMethod:(int) type{

    NSString *title = self.infoDic[@"title"];
   
    QQApiTextObject *newsObj = [[QQApiTextObject alloc] init];
    newsObj.title = title;
    newsObj.description = title;
    newsObj.text = title;
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    if (type == 0) {
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        NSLog(@"______%d",sent);
    }else{
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        NSLog(@"______%d",sent);
    }
    
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
