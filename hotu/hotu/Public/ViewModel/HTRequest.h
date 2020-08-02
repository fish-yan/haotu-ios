//
//  HTRequest.h
//  hotu
//
//  Created by 薛焱 on 2019/12/2.
//  Copyright © 2019 薛焱. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HTRequest : NSObject

+ (void)uploadImage:(UIImage *)image isZoom:(BOOL)isZoom isLogo:(BOOL)isLogo isLive:(BOOL)isLive complete:(void(^)(NSString *_Nullable))complete;
@end
