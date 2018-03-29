//
//  CCUrl.h
//  CarSticker
//
//  Created by cc on 2017/3/21.
//  Copyright © 2017年 cc. All rights reserved.
//

#ifndef CCUrl_h
#define CCUrl_h
/*
 接口文档
 */
#define TokenKey @"02c8f878c1d5463b5bea89e893cde184"

#define UDID     0

/*****************************测试开关*******************************/

#define HHTest   1      // 1 测试  0 上传

/*****************************测试开关*******************************/

#if HHTest

//#define    BaseApi       @"http://139.224.70.219:8989/index.php"
#define    BaseApi       @"http://lm.feiyouce.com/index.php"
#else

#define    BaseApi      @"正式地址"

#endif

#pragma mark - 接口地址 -



/*
 *   User Info
 */
//  判断是否登录 
#define IsLogin @"islogin"

#define UserToken @"userTOken"


#endif /* CCUrl_h */
