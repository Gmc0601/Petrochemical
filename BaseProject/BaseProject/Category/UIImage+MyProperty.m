//
//  UIImage+MyProperty.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "UIImage+MyProperty.h"

@implementation UIImage (MyProperty)
- (NSString *) base64String{
    if ([self isKindOfClass:[UIImage class]]) {
        NSData *imageData = UIImageJPEGRepresentation(self, 0.6);
        NSString *image64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        return image64;
    }else{
        return nil;
    }
}
@end
