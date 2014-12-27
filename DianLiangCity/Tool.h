//
//  Tool.h
//  oschina
//
//  Created by wangjun on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CommonCrypto/CommonCryptor.h>
#import <ShareSDK/ShareSDK.h>
#import "RMMapper.h"
#import "MBProgressHUD.h"
#import "Advertisement.h"
#import "SystemInform.h"
#import "Community.h"
#import "SystemDetails.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "RegionModel.h"
#import "CArea.h"
#import "CBuild.h"
#import "CUnit.h"
#import "HouseNumber.h"
#import "UserInfo.h"
#import "CommunityInfo.h"
#import "CommNew.h"
#import "Hotline.h"
#import "CommNotic.h"
#import "MyBill.h"
#import "Bill.h"
#import "BillDetail.h"
#import "BBSModel.h"
#import "BBSReplyModel.h"
#import "CommercialReply.h"
#import "BaoXiuCase.h"
#import "BaoXius.h"
#import "BaoXiuInfo.h"
#import "BaoxiuPro.h"
#import "Family.h"
#import "Helps.h"
#import "Channel.h"
#import "OwnerScope.h"
#import "BBSPoint.h"

@interface Tool : NSObject

+ (UIAlertView *)getLoadingView:(NSString *)title andMessage:(NSString *)message;

+ (NSMutableArray *)getRelativeNews:(NSString *)request;
+ (NSString *)generateRelativeNewsString:(NSArray *)array;

+ (UIColor *)getColorForCell:(int)row;

+ (void)clearWebViewBackground:(UIWebView *)webView;

+ (void)doSound:(id)sender;

+ (NSString *)getBBSIndex:(int)index;

+ (void)toTableViewBottom:(UITableView *)tableView isBottom:(BOOL)isBottom;

+ (void)borderView:(UIView *)view;
+ (void)roundTextView:(UIView *)txtView andBorderWidth:(int)width andCornerRadius:(float)radius;
+ (void)roundView:(UIView *)view andCornerRadius:(float)radius;

+ (void)noticeLogin:(UIView *)view andDelegate:(id)delegate andTitle:(NSString *)title;

+ (void)processLoginNotice:(UIActionSheet *)actionSheet andButtonIndex:(NSInteger)buttonIndex andNav:(UINavigationController *)nav andParent:(UIViewController *)parent;

+ (NSString *)getCommentLoginNoticeByCatalog:(int)catalog;

+ (void)playAudio:(BOOL)isAlert;

+ (NSString *)intervalSinceNow: (NSString *) theDate;

+ (BOOL)isToday:(NSString *) theDate;

+ (int)getDaysCount:(int)year andMonth:(int)month andDay:(int)day;

+ (NSString *)getAppClientString:(int)appClient;

+ (void)ReleaseWebView:(UIWebView *)webView;

+ (int)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt;

+ (UIColor *)getBackgroundColor;
+ (UIColor *)getCellBackgroundColor;

+ (BOOL)isValidateEmail:(NSString *)email;

+ (void)saveCache:(int)type andID:(int)_id andString:(NSString *)str;
+ (NSString *)getCache:(int)type andID:(int)_id;

+ (void)deleteAllCache;

+ (NSString *)getHTMLString:(NSString *)html;

+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud;
+ (void)showCustomHUD:(NSString *)text andView:(UIView *)view andImage:(NSString *)image andAfterDelay:(int)second;

+ (UIImage *) scale:(UIImage *)sourceImg toSize:(CGSize)size;

+ (CGSize)scaleSize:(CGSize)sourceSize;

+ (NSString *)getOSVersion;

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom;

+ (void)CancelRequest:(ASIFormDataRequest *)request;

+ (NSDate *)NSStringDateToNSDate:(NSString *)string;
//时间戳转指定格式时间字符串
+ (NSString *)TimestampToDateStr:(NSString *)timestamp andFormatterStr:(NSString *)formatter;

+ (NSString *)GenerateTags:(NSMutableArray *)tags;

+ (void)saveCache:(NSString *)catalog andType:(int)type andID:(int)_id andString:(NSString *)str;
+ (NSString *)getCache:(NSString *)catalog andType:(int)type andID:(int)_id;
//保留数值几位小数
+ (NSString *)notRounding:(float)price afterPoint:(int)position;
+ (void)shareAction:(UIButton *)sender andShowView:(UIView *)view andContent:(NSDictionary *)shareContent;
+(int)getRandomNumber:(int)start to:(int)end;
+ (NSString *)databasePath;

+ (UIColor *)getColorForRed;

#pragma mark - json转对象方法
/**
 * 将json转换成广告集合
 */
+ (NSMutableArray *)readJsonStrToADV:(NSString *)str;

/**
 * 将json转换成系统通知集合
 */
+ (NSMutableArray *)readJsonStrToSystemInfo:(NSString *)str;

/**
 * 将json转换成我的社区集合
 */
+ (NSMutableArray *)readJsonStrToMyComm:(NSString *)str;

/**
 * 将json转换成系统通知详情
 */
+ (SystemDetails *)readJsonStrToSystemDetails:(NSString *)str;

/**
 * 将json转换成省市区集合
 */
+ (NSMutableArray *)readJsonStrToRegionArray:(NSString *)str;

/**
 * 将json转换成社区集合
 */
+ (NSArray *)readJsonStrToComms:(NSString *)str;

/**
 * 将json转换成用户信息
 */
+ (UserInfo *)readJsonStrToUserInfo:(NSString *)str;

/**
 * 将json转换成社区简介信息
 */
+ (CommunityInfo *)readJsonStrToCommInfo:(NSString *)str;

/**
 * 将json转换成社区风采,动态
 */
+ (NSMutableArray *)readJsonStrToCommNews:(NSString *)str;

/**
 * 将json转换成社区风采,动态详情
 */
+ (CommNew *)readJsonStrToCommNew:(NSString *)str;

/**
 * 将json转换成社区热线电话
 */
+ (NSMutableArray *)readJsonStrToHotline:(NSString *)str;

/**
 * 将json转换成物业通知列表
 */
+ (NSMutableArray *)readJsonStrToCommNotics:(NSString *)str;

/**
 * 将json转换成物业通知详情
 */
+ (CommNotic *)readJsonStrToCommNoticDetail:(NSString *)str;

/**
 * 将json转换成我的账单
 */
+ (MyBill *)readJsonStrToMyBill:(NSString *)str;

/**
 * 将json转换成账单类型
 */
+ (NSMutableArray *)readJsonStrToBillType:(NSString *)str;

/**
 * 将json转换成账单详情
 */
+ (BillDetail *)readJsonStrToBillDetail:(NSString *)str;

/**
 * 将json转换成论坛帖子列表
 */
+ (NSMutableArray *)readJsonStrToBBSArray:(NSString *)str;

/**
 * 将json转换成论坛帖子回复集合
 */
+ (NSMutableArray *)readJsonStrToCommercialReply:(NSString *)str;

/**
 * 将json转换成报修列表
 */
+ (BaoXius *)readJsonStrToBaoXius:(NSString *)str;

/**
 * 将json转换成报修记录详情
 */
+ (BaoXiuInfo *)readJsonStrToBaoXiuInfo:(NSString *)str;

/**
 * 将json转换成家庭成员信息集合
 */
+ (NSMutableArray *)readJsonStrToFamilys:(NSString *)str;

/**
 * 将json转换成家庭成员详情
 */
+ (Family *)readJsonStrToFamilyDetail:(NSString *)str;

/**
 * 将json转换成使用帮助集合
 */
+ (NSMutableArray *)readJsonStrToHelps:(NSString *)str;

/**
 * 将json转换成使用帮助详情
 */
+ (Helps *)readJsonStrToHelpDetail:(NSString *)str;

/**
 * 将json转换成频道列表
 */
+ (NSMutableArray *)readJsonStrToChannels:(NSString *)str;

/**
 * 将json转换成业主园地
 */
+ (OwnerScope *)readJsonStrToOwnerScopes:(NSString *)str;

+(int)getTextHeight:(int)width andUIFont:(UIFont *)font andText:(NSString *)txt;
@end
