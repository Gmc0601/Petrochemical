# Petrochemical


 NSDictionary *dic = @{
                          @"username":@"17682318061",
                          @"loginPass":@"123456",
                          @"device_number" : udidStr,
                          };

    [HttpRequest postPath:LoginURL params:dic resultBlock:^(id responseObject, NSError *error) {
        NSLog(@"Login>>>>>%@", responseObject);
        NSDictionary *dic = responseObject;
        NSLog(@"%@", dic);
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSDictionary *info = dic[@"info"];
            NSString *userToken = info[@"userToken"];
            [ConfigModel mbProgressHUD:@"登录成功" andView:nil];
        }else {
            NSString *errorStr = dic[@"info"];
            NSLog(@"%@", errorStr);
            [ConfigModel mbProgressHUD:errorStr andView:nil];
            
        }
    }];
