//
//  JYangLib.h
//  JYangToolKit
//
//  Created by 一路财富 on 16/10/11.
//  Copyright © 2016年 JYang. All rights reserved.
//

//  注：该framework为金融魔方SDK工具类，若集成多个金融魔方SDK，导入一个即可
//  （勿动.h文件中内容）
//  2016-12-06 V 1.2 Https版本

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  宏定义请求成功的block
 *
 *  @param responseObj 请求成功返回的数据
 */
typedef void (^JYResponseSuccess)(NSURLSessionDataTask *task, NSDictionary *responseObj);

/**
 *  宏定义请求失败的block
 *
 *  @param error 报错信息
 */
typedef void (^JYResponseFail)(NSURLSessionDataTask *task, NSError *error);

@interface JYangLib : NSObject

+ (NSString *)SDK_Version;

/**
 获取网络图片

 @param imageView       视图View
 @param url             图片地址
 @param placeholder     默认图片
 */
+ (void)JYangLibsetImageWithImageView:(UIImageView *)imageView URL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

+ (void)JYangLibDownloadImageWithUrl:(NSURL *)url block:(void (^)(UIImage *image))block;

#pragma mark - 等待框
/**
 显示等待框

 @param viewController 当前视图
 @param hint 提示文字
 */
+ (void)JYangLibShowWaitInViewController:(UIViewController *)viewController hint:(NSString *)hint;

/**
 隐藏等待框

 @param viewController 当前视图
 */
+ (void)JYangLibHideWaitWithViewController:(UIViewController *)viewController;

/**
 提示框

 @param hint 提示文字
 @param viewController 显示视图
 */
+ (void)JYangLibShowWait:(NSString *)hint InViewController:(UIViewController *)viewController;

/**
 提示框

 @param hint 提示文字
 @param viewController 显示视图
 @param completion 提示消失之后的回调
 */
+ (void)JYangLibShowWait:(NSString *)hint
        InViewController:(UIViewController *)viewController
              completion:(void (^)(BOOL dismissed))completion;

+ (void)mf_showProgressHUDWith:(NSString *)title inView:(UIView *)view;
+ (void)mf_hideHUDInView:(UIView *)view;

#pragma mark - 网络请求
/**
 普通post方法请求网络数据

 @param reqUrl  请求网址路径
 @param param   请求参数
 @param success 成功回调
 @param fail    失败回调
 */
+ (NSURLSessionDataTask *)postGetRequestWithLink:(NSString *)reqUrl
                                       parameter:(NSString *)param
                                         success:(JYResponseSuccess)success
                                            fail:(JYResponseFail)fail;

#pragma mark - Msg
+ (void)mf_collectErrorMsg:(NSString *)partnerId userId:(NSString *)userId;

+ (NSString *)GetJYangToolLibMsg;

+ (void)mf_setUserIcon:(NSString *)uId
             className:(NSString *)name
                  with:(UIImageView *)uIcon
              webImage:(NSString *)iconStr
          defaultImage:(UIImage *)defaultImage;

+ (void)mf_setUserIcon:(NSString *)uId
             className:(NSString *)name
                  with:(UIImageView *)uIcon
              webImage:(NSString *)iconStr
          defaultImage:(UIImage *)defaultImage
                 block:(void (^)(NSString *imageStr, UIImage *uImage, NSString *user_nickname))block;

+ (NSURLSessionDataTask *)mf_post:(NSString *)urlStr
                            param:(NSDictionary *)mdic
                            block:(void (^)(id obj, NSError *err))block;

+ (void)setCustomerFontName:(NSString *)fontName;

+ (UIFont *)MFYUEFontWithSize:(CGFloat)size;

@end
