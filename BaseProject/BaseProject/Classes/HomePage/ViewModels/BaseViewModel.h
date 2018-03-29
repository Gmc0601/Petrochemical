//
//  BaseViewModel.h
//  BaseProject
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>


@interface BaseViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) int  page;

@property (nonatomic, assign) int size;

@property (nonatomic) BOOL haveMore;

@end
