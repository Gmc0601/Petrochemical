//
//  LeasCustomAlbum.h
//  BaseProject
//
//  Created by 桃子leas on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReturnImage)(UIImage *images);
@interface LeasCustomAlbum : NSObject
+ (void) getImageWith:(UIViewController *) controller Value:(ReturnImage) images;

@end
