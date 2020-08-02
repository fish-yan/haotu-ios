//
//  HTRequest.m
//  hotu
//
//  Created by 薛焱 on 2019/12/2.
//  Copyright © 2019 薛焱. All rights reserved.
//

#import "HTRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "hotu-Swift.h"

@implementation HTRequest


+ (void)uploadImage:(UIImage *)image isZoom:(BOOL)isZoom isLogo:(BOOL)isLogo isLive:(BOOL)isLive complete:(void(^)(NSString *_Nullable))complete {
    
    NSMutableDictionary *productParams=[[NSMutableDictionary alloc]init];
    
    [productParams setValue:[HTUserInfo share].tokenId forKey:@"user_token"];
    [productParams setValue: isLogo ? @"1" : @"0" forKey:@"isLogo"];
    [productParams setValue:@"100" forKey:@"height"];
    [productParams setValue:@"200" forKey:@"width"];
    [productParams setValue:isZoom ? @"1" : @"0" forKey:@"isZoom"];
    NSString *urlStr = [NSString stringWithFormat:@"%@file/uploadSingle", [HTAppVM share].api];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/plain",
                                                         @"text/javascript",
                                                         @"text/json",
                                                         @"text/html",
                                                         @"image/jpeg", nil];
    
    [manager POST:urlStr parameters:productParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData * imageData = UIImageJPEGRepresentation(image,0.5);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *imageFileName = [NSString stringWithFormat:@"%@.jpg", [formatter stringFromDate:[NSDate date]]];
        [formData appendPartWithFileData:imageData name:@"file" fileName:imageFileName mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *strtmp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *requestTmp = [NSString stringWithString: strtmp];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        int code =  [resultDic[@"code"] intValue];
        if (code == 200) {
            if (isZoom) {
                NSString *imgs = @"";
                if (isLive) {
                    imgs = [NSString stringWithFormat:@"%@&%@&%@&%@", resultDic[@"data"][@"originImage"], resultDic[@"data"][@"zoomImage"],resultDic[@"data"][@"zoomBiggerImage"],resultDic[@"data"][@"originImageSize"]];
                } else {
                    imgs = [NSString stringWithFormat:@"%@@%@", resultDic[@"data"][@"originImage"], resultDic[@"data"][@"zoomImage"]];
                }
                complete(imgs);
            } else {
                complete(resultDic[@"data"]);
            }
        }else {
            complete(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(nil);
    }];
    
}


@end
