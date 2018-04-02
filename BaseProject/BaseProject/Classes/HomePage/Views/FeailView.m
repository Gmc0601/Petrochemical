//
//  FeailView.m
//  BaseProject
//
//  Created by cc on 2018/1/12.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "FeailView.h"
#import <YYKit.h>

@implementation FeailView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self ==[super initWithFrame:frame]) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.whitView];
        [self.whitView addSubview:self.titleLab];
        [self.whitView addSubview:self.content];
        [self.whitView addSubview:self.cancleBtn];
        [self.whitView addSubview:self.clickBtn];
        
    }
    return self;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH)];
        _backView.backgroundColor = RGBColorAlpha(0, 0, 0, 0.7);
    }
    return _backView;
}

- (UITextView *)content {
    if (!_content) {
        _content = [[UITextView alloc] initWithFrame:FRAME(5, 10, self.whitView.width - 10, SizeHeight(280))];
        _content.textColor = [UIColor blackColor];
        _content.textAlignment = NSTextAlignmentCenter;
        _content.text = @"您好，为了合作共赢互赢互利的原则，我公司规定：\n"
        "\n"
        "一；司机运输途中必须确保货物安全，保证货物无泄漏，无污染。 \n"
        "二；未按规定时间运送货物到达’逾期造成严重损失’由车上负责，不可抗拒因素除外。\n"
        "三；在运输途中出现交通事故，车上承担赔偿责任。  \n"
        "四：运输过程中货物灭失、短少、变质、被盗、交货不清等因素、车上应承担全部责任。\n"
        "\n"
        "您必须同意以上合作规定，才能在本平台进行做单，谢谢支持！\n";
        _content.font = [UIFont systemFontOfSize:14];
        _content.userInteractionEnabled = YES;
        _content.editable= NO;
    }
    return _content;
}


- (UIButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [[UIButton alloc] initWithFrame:FRAME(self.whitView.width/2 ,SizeHeight(300), self.whitView.width/2, SizeHeight(30))];
        [_clickBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_clickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_clickBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _clickBtn;
}
- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [[UIButton alloc] initWithFrame:FRAME(0, SizeHeight(300), self.whitView.width/2, SizeHeight(30))];
        [_cancleBtn setTitle:@"不同意" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (void)click {
    [self dismiss];
    if (self.clickBlick) {
        self.clickBlick();
    }
}

- (UIView *)whitView{
    if (!_whitView) {
        _whitView = [[UIView alloc] initWithFrame:CGRectMake(SizeWidth(20), kScreenH /2 - SizeHeight(175), kScreenW - SizeWidth(40), SizeHeight(350))];
        _whitView.backgroundColor = [UIColor whiteColor];
        [_whitView.layer setMasksToBounds: YES];
        [_whitView.layer setCornerRadius:SizeHeight(15)];
    }
    return _whitView;
}

- (void)pop {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    self.whitView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    self.backView.alpha = 1;
    [UIView animateWithDuration:.35 animations:^{
        self.whitView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backView.alpha = 1;
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:.35 animations:^{
        self.whitView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
