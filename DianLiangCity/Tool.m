//
//  Tool.m
//  oschina
//
//  Created by wangjun on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+ (UIAlertView *)getLoadingView:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *progressAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(121, 80, 37, 37);
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

+ (NSString *)getBBSIndex:(int)index
{
    if (index < 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%d楼", index+1];
}

+ (void)toTableViewBottom:(UITableView *)tableView isBottom:(BOOL)isBottom
{
    if (isBottom) {
        NSUInteger sectionCount = [tableView numberOfSections];
        if (sectionCount) {
            NSUInteger rowCount = [tableView numberOfRowsInSection:0];
            if (rowCount) {
                NSUInteger ii[2] = {0, rowCount - 1};
                NSIndexPath * indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:isBottom ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop animated:YES];
            }
        }
    }
    else
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

+ (NSString *)getCommentLoginNoticeByCatalog:(int)catalog
{
    switch (catalog) {
        case 1:
        case 3:
            return @"请先登录后发表评论";
        case 2:
            return @"请先登录后再回帖或评论";
        case 4:
            return @"请先登录后发留言";
    }
    return @"请先登录后发表评论";
}

+ (void)borderView:(UIView *)view
{
    view.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0] CGColor];
    view.layer.borderWidth = 1;
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
}

+ (void)roundTextView:(UIView *)txtView andBorderWidth:(int)width andCornerRadius:(float)radius
{
    txtView.layer.borderColor = [[UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1.0] CGColor];
    txtView.layer.borderWidth = width;
    txtView.layer.cornerRadius = radius;
    txtView.layer.masksToBounds = YES;
    txtView.clipsToBounds = YES;
}

+ (void)roundView:(UIView *)view andCornerRadius:(float)radius
{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
}

+ (void)playAudio:(BOOL)isAlert
{
    NSString * path = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath], isAlert ? @"/alertsound.wav" : @"/soundeffect.wav"];
    SystemSoundID soundID;
    NSURL * filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

+ (UIColor *)getColorForCell:(int)row
{
    return row % 2 ?
    [UIColor colorWithRed:235.0/255.0 green:242.0/255.0 blue:252.0/255.0 alpha:1.0]:
    [UIColor colorWithRed:248.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
}

+ (void)clearWebViewBackground:(UIWebView *)webView
{
    UIWebView *web = webView;
    for (id v in web.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            [v setBounces:NO];
        }
    }
}

+ (void)doSound:(id)sender
{
    NSError *err;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"soundeffect" ofType:@"wav"]] error:&err];
    player.volume = 1;
    player.numberOfLoops = 1;
    [player prepareToPlay];
    [player play];
}

+ (NSString *)getAppClientString:(int)appClient
{
    switch (appClient) {
        case 1:
            return @"";
        case 2:
            return @"来自手机";
        case 3:
            return @"来自手机";
        case 4:
            return @"来自iPhone";
        case 5:
            return @"来自手机";
        default:
            return @"";
    }
}

+ (void)ReleaseWebView:(UIWebView *)webView
{
    [webView stopLoading];
    [webView setDelegate:nil];
    webView = nil;
}

+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    else if (cha/86400>1&&cha/864000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    else
    {
        //        timeString = [NSString stringWithFormat:@"%d-%"]
        NSArray *array = [theDate componentsSeparatedByString:@" "];
        //        return [array objectAtIndex:0];
        timeString = [array objectAtIndex:0];
    }
    return timeString;
}

+ (BOOL)isToday:(NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=now-late;
    
    if (cha/86400<1) {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(int)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt
{
    float fPadding = 16.0;
    CGSize constraint = CGSizeMake(txtView.contentSize.width - 10 - fPadding, CGFLOAT_MAX);
    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    float fHeight = size.height + 16.0;
    return fHeight;
}

+(int)getTextHeight:(int)width andUIFont:(UIFont *)font andText:(NSString *)txt
{
    float fPadding = 16.0;
    CGSize constraint = CGSizeMake(width - 10 - fPadding, CGFLOAT_MAX);
    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    float fHeight = size.height + 16.0;
    return fHeight;
}

+ (int)getDaysCount:(int)year andMonth:(int)month andDay:(int)day
{
    return year*365 + month * 31 + day;
}

+ (UIColor *)getBackgroundColor
{
//    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"fb_bg.jpg"]];
    return [UIColor colorWithRed:189.0/255 green:196.0/255 blue:204.0/255 alpha:1.0];
}
+ (UIColor *)getCellBackgroundColor
{
    return [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:1.0];
}

+ (void)saveCache:(int)type andID:(int)_id andString:(NSString *)str
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    [setting setObject:str forKey:key];
    [setting synchronize];
}
+ (NSString *)getCache:(int)type andID:(int)_id
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    
    NSString *value = [settings objectForKey:key];
    return value;
}

+ (void)deleteAllCache
{
}

+ (NSString *)getHTMLString:(NSString *)html
{
    return html;
}
+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
{
    [view addSubview:hud];
    hud.labelText = text;
    //    hud.dimBackground = YES;
    hud.square = YES;
    [hud show:YES];
}

+ (void)showCustomHUD:(NSString *)text andView:(UIView *)view andImage:(NSString *)image andAfterDelay:(int)second
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]] ;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = text;
    [HUD show:YES];
    [HUD hide:YES afterDelay:second];
}

+ (UIImage *)scale:(UIImage *)sourceImg toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [sourceImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+ (CGSize)scaleSize:(CGSize)sourceSize
{
    float width = sourceSize.width;
    float height = sourceSize.height;
    if (width >= height) {
        return CGSizeMake(800, 800 * height / width);
    }
    else
    {
        return CGSizeMake(800 * width / height, 800);
    }
}

+ (NSString *)getOSVersion
{
    return [NSString stringWithFormat:@"GreenOrange.com/%@/%@/%@/%@",AppVersion,[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion, [UIDevice currentDevice].model];
}

//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom
{
    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:isLoading inPresentationMode:isBottom?GCDiscreetNotificationViewPresentationModeBottom:GCDiscreetNotificationViewPresentationModeTop inView:view];
    [notificationView show:YES];
    [notificationView hideAnimatedAfter:2.6];
}
+ (void)CancelRequest:(ASIHTTPRequest *)request
{
    if (request != nil) {
        [request cancel];
        [request clearDelegatesAndCancel];
    }
}
+ (NSDate *)NSStringDateToNSDate:(NSString *)string
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * d = [f dateFromString:string];
    return d;
}

+ (NSString *)TimestampToDateStr:(NSString *)timestamp andFormatterStr:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]];
    return [dateFormatter stringFromDate:confromTimesp];
}

//生成随机数
+(int)getRandomNumber:(int)start to:(int)end
{
    return (int)(start + (arc4random() % (end - start + 1)));
}

#pragma mark - json转对象方法

+ (NSMutableArray *)readJsonStrToADV:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *advJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( advJsonArray == nil || [advJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *advs = [RMMapper mutableArrayOfClass:[Advertisement class] fromArrayOfDictionary:advJsonArray];
    return advs;
}

+ (NSMutableArray *)readJsonStrToSystemInfo:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *sysJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( sysJsonArray == nil || [sysJsonArray count] <= 0)
    {
        return nil;
    }
    NSMutableArray *systemInfos = [RMMapper mutableArrayOfClass:[SystemInform class] fromArrayOfDictionary:sysJsonArray];
    return systemInfos;
}

+ (NSMutableArray *)readJsonStrToMyComm:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *commJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (commJsonArray == nil || [commJsonArray count] <= 0)
    {
        return nil;
    }
    NSMutableArray *comms = [RMMapper mutableArrayOfClass:[Community class] fromArrayOfDictionary:commJsonArray];
    return comms;
}

+ (SystemDetails *)readJsonStrToSystemDetails:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *sysJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( sysJsondDic == nil ) {
        return nil;
    }
    SystemDetails *sysInfo = [RMMapper objectWithClass:[SystemDetails class] fromDictionary:sysJsondDic];
    return sysInfo;
}


+ (NSMutableArray *)readJsonStrToRegionArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *areaArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( [areaArray count] <= 0) {
        return nil;
    }
    NSMutableArray *provinceArray;
    if ([areaArray count] >= 1)
    {
        NSDictionary *areaDic = [areaArray objectAtIndex:0];
        id areaJSON = [areaDic objectForKey:@"_child"];
        provinceArray = [RMMapper mutableArrayOfClass:[ProvinceModel class]
                                fromArrayOfDictionary:areaJSON];
        for (ProvinceModel *p in provinceArray)
        {
            NSMutableArray *cityArray = [RMMapper mutableArrayOfClass:[CityModel class]
                                                fromArrayOfDictionary:p._child];
            for (CityModel *c in cityArray)
            {
                NSMutableArray *regionArray = [RMMapper mutableArrayOfClass:[RegionModel class]
                                                      fromArrayOfDictionary:c._child];
                c.regionArray = regionArray;
            }
            p.cityArray = cityArray;
        }
    }
    return provinceArray;
}

+ (NSArray *)readJsonStrToComms:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *commArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableArray *comms = [RMMapper mutableArrayOfClass:[Community class] fromArrayOfDictionary:commArray];
    if ( [comms count] <= 0) {
        return nil;
    }
    NSMutableArray *careaArray;
    for(int i = 0;i < comms.count; ++i)
    {
        NSDictionary *commDic = [commArray objectAtIndex:i];
        id areaJSON = [commDic objectForKey:@"areaList"];
        careaArray = [RMMapper mutableArrayOfClass:[CArea class]
                             fromArrayOfDictionary:areaJSON];
        for (CArea *p in careaArray)
        {
            NSMutableArray *buildArray = [RMMapper mutableArrayOfClass:[CBuild class]
                                                 fromArrayOfDictionary:p.buildList];
            for (CBuild *c in buildArray)
            {
                NSMutableArray *unitArray = [RMMapper mutableArrayOfClass:[CUnit class]
                                                    fromArrayOfDictionary:c.uintList];
                for(CUnit *u in unitArray)
                {
                    NSMutableArray *houseArray = [RMMapper mutableArrayOfClass:[HouseNumber class]
                                                         fromArrayOfDictionary:u.houseList];
                    u.houseList = houseArray;
                }
                c.uintList = unitArray;
            }
            p.buildList = buildArray;
         }
        Community *comm = [comms objectAtIndex:i];
        comm.areaList = careaArray;
    }
    return comms;
}

+ (UserInfo *)readJsonStrToUserInfo:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *userJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( userJsondDic == nil )
    {
        return nil;
    }
    UserInfo *userInfo = [RMMapper objectWithClass:[UserInfo class] fromDictionary:userJsondDic];
    return userInfo;
}

+ (CommunityInfo *)readJsonStrToCommInfo:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *commJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( commJsondDic == nil )
    {
        return nil;
    }
    CommunityInfo *commInfo = [RMMapper objectWithClass:[CommunityInfo class] fromDictionary:commJsondDic];
    return commInfo;
}

+ (NSMutableArray *)readJsonStrToCommNews:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *commArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableArray *comms = [RMMapper mutableArrayOfClass:[CommNew class] fromArrayOfDictionary:commArray];
    if ( [comms count] <= 0)
    {
        return nil;
    }
    NSMutableArray *piclistArray;
    //得到图片集合
    for(int i = 0;i < comms.count; ++i)
    {
        NSDictionary *commDic = [commArray objectAtIndex:i];
        id areaJSON = [commDic objectForKey:@"piclist"];
        piclistArray = [RMMapper mutableArrayOfClass:[NSString class]
                             fromArrayOfDictionary:areaJSON];
        CommNew *commNew = [comms objectAtIndex:i];
        commNew.piclist = piclistArray;
    }
    return comms;
}

+ (CommNew *)readJsonStrToCommNew:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *commJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( commJsondDic == nil )
    {
        return nil;
    }
    CommNew *commNew = [RMMapper objectWithClass:[CommNew class] fromDictionary:commJsondDic];
    return commNew;
}

+ (NSMutableArray *)readJsonStrToHotline:(NSString *)str
{
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *hotlineJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (hotlineJsonArray == nil || [hotlineJsonArray count] <= 0)
    {
        return nil;
    }
    NSMutableArray *hotlines = [RMMapper mutableArrayOfClass:[Hotline class] fromArrayOfDictionary:hotlineJsonArray];
    return hotlines;
}

+ (NSMutableArray *)readJsonStrToCommNotics:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *commArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableArray *comms = [RMMapper mutableArrayOfClass:[CommNotic class] fromArrayOfDictionary:commArray];
    if ( [comms count] <= 0)
    {
        return nil;
    }
    NSMutableArray *piclistArray;
    //得到图片集合
    for(int i = 0;i < comms.count; ++i)
    {
        NSDictionary *commDic = [commArray objectAtIndex:i];
        id areaJSON = [commDic objectForKey:@"piclist"];
        piclistArray = [RMMapper mutableArrayOfClass:[NSString class]
                               fromArrayOfDictionary:areaJSON];
        CommNotic *commNew = [comms objectAtIndex:i];
        commNew.piclist = piclistArray;
    }
    return comms;
}

+ (CommNotic *)readJsonStrToCommNoticDetail:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *commJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( commJsondDic == nil )
    {
        return nil;
    }
    CommNotic *commNotic = [RMMapper objectWithClass:[CommNotic class] fromDictionary:commJsondDic];
    
    NSMutableArray *piclistArray;
    
    //得到图片集合
    id areaJSON = [commJsondDic objectForKey:@"piclist"];
    piclistArray = [RMMapper mutableArrayOfClass:[NSString class]
                           fromArrayOfDictionary:areaJSON];
    commNotic.piclist = piclistArray;
    return commNotic;
}

+ (MyBill *)readJsonStrToMyBill:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *myBillJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( myBillJsondDic == nil )
    {
        return nil;
    }
    MyBill *myBill = [RMMapper objectWithClass:[MyBill class] fromDictionary:myBillJsondDic];
    
    //得到未支付账单集合
    NSMutableArray *nopay;
    id noJSON = [myBillJsondDic objectForKey:@"nopay"];
    nopay = [RMMapper mutableArrayOfClass:[Bill class]
                           fromArrayOfDictionary:noJSON];
    myBill.nopay = nopay;
    
    //得到支付账单集合
    NSMutableArray *pay;
    id payJSON = [myBillJsondDic objectForKey:@"pay"];
    pay = [RMMapper mutableArrayOfClass:[Bill class]
                    fromArrayOfDictionary:payJSON];
    myBill.pay = pay;
    
    //得到已忽略账单集合
    NSMutableArray *other;
    id otherJSON = [myBillJsondDic objectForKey:@"other"];
    other = [RMMapper mutableArrayOfClass:[Bill class]
                    fromArrayOfDictionary:otherJSON];
    myBill.other = other;
    return myBill;
}

+ (NSMutableArray *)readJsonStrToBillType:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableArray *billtypeJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (billtypeJsonArray == nil || [billtypeJsonArray count] <= 0)
    {
        return nil;
    }
    return billtypeJsonArray;
}

+ (BillDetail *)readJsonStrToBillDetail:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *myBillJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( myBillJsondDic == nil )
    {
        return nil;
    }
    BillDetail *myBill = [RMMapper objectWithClass:[BillDetail class] fromDictionary:myBillJsondDic];
    return myBill;
}

+ (UIColor *)getColorForRed
{
    return [UIColor colorWithRed:247.0/255 green:119.0/255 blue:0/255 alpha:1.0];
}

+ (NSMutableArray *)readJsonStrToBBSArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *bbsJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( bbsJsonArray == nil || [bbsJsonArray count] <= 0) {
        return nil;
    }
    NSMutableArray *bbsArray = [RMMapper mutableArrayOfClass:[BBSModel class] fromArrayOfDictionary:bbsJsonArray];
    for (BBSModel *o in bbsArray)
    {
        NSMutableArray *reply_Array = [RMMapper mutableArrayOfClass:[BBSReplyModel class]
                                              fromArrayOfDictionary:o.reply_list];
        NSMutableAttributedString *reply_str = [[NSMutableAttributedString alloc] init];
        for (BBSReplyModel *r in reply_Array)
        {
            NSString *rname = @"匿名用户:";
            if ([r.nickname isEqualToString:@""] == NO)
            {
                rname = [NSString stringWithFormat:@"%@:", r.nickname];
            }
            else if ([r.name isEqualToString:@""] == NO)
            {
                rname = [NSString stringWithFormat:@"%@:", r.name];
            }
            NSString *rcontent = [NSString stringWithFormat:@"%@%@\n", rname, r.reply_content];
            NSMutableAttributedString *lien_str = [[NSMutableAttributedString alloc] initWithString:rcontent];
            
            [lien_str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.49 blue:0.89 alpha:1] range:NSMakeRange(0,[rcontent rangeOfString:@":"].location)];
            [reply_str appendAttributedString:lien_str];
        }
        o.timeStr = [Tool intervalSinceNow:[Tool TimestampToDateStr:o.addtime andFormatterStr:@"yyyy-MM-dd HH:mm:ss"]];
        o.replyArray = reply_Array;
        o.contentHeight = [self getTextHeight:253 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12] andText:o.content];
        o.reply_str = reply_str;
        o.replyHeight = [self getTextHeight:253 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12] andText:reply_str.string];
        NSMutableArray *point_Array = [RMMapper mutableArrayOfClass:[BBSPoint class] fromArrayOfDictionary:o.points_list];
        if(o.points_list.count > 0)
        {
            NSMutableString *point_str = [[NSMutableString alloc] init];
            for(int i = 0;i < point_Array.count;++i)
            {
                BBSPoint *point = [point_Array objectAtIndex:i];
                NSString *str;
                if( i== 0)
                {
                    if(point_Array.count > 1)
                    {
                        str = [NSString stringWithFormat:@" %@、",point.nickname];
                    }
                    else
                    {
                        str = [NSString stringWithFormat:@" %@",point.nickname];
                    }
                }
                else if(i == point_Array.count - 1)
                {
                    str = [NSString stringWithFormat:@"%@,觉得很赞",point.nickname];
                }
                else
                {
                    str = [NSString stringWithFormat:@"%@、",point.nickname];
                }
                [point_str appendString:str];
            }
            o.point_str = point_str;
        }
        o.points_list = point_Array;
    }
    return bbsArray;
}


+ (NSMutableArray *)readJsonStrToCommercialReply:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( json == nil ) {
        return nil;
    }
    NSArray *jsonArray = [json objectForKey:@"reply_list"];
    NSMutableArray *replyArray = [RMMapper mutableArrayOfClass:[CommercialReply class] fromArrayOfDictionary:jsonArray];
    for (CommercialReply *comm in replyArray)
    {
        
        NSString *rname = @"匿名用户";
        if ([comm.nickname isEqualToString:@""] == NO)
        {
            rname = [NSString stringWithFormat:@"%@", comm.nickname];
        }
        else if ([comm.name isEqualToString:@""] == NO)
        {
            rname = [NSString stringWithFormat:@"%@", comm.name];
        }
        comm.nickname = rname;
        comm.timeStr = [Tool intervalSinceNow:[Tool TimestampToDateStr:comm.reply_time andFormatterStr:@"yyyy-MM-dd HH:mm:ss"]];
        comm.contentHeight = [self getTextHeight:300 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12] andText:comm.reply_content];
    }
    return replyArray;
}

+ (BaoXius *)readJsonStrToBaoXius:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *myRepairJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( myRepairJsondDic == nil )
    {
        return nil;
    }
    BaoXius *myBaoXius = [RMMapper objectWithClass:[BaoXius class] fromDictionary:myRepairJsondDic];
    
    //得到未支付账单集合
    NSMutableArray *no;
    id noJSON = [myRepairJsondDic objectForKey:@"no"];
    no = [RMMapper mutableArrayOfClass:[BaoXiuCase class]
                    fromArrayOfDictionary:noJSON];
    myBaoXius.no = no;
    
    //得到支付账单集合
    NSMutableArray *yes;
    id yesJSON = [myRepairJsondDic objectForKey:@"yes"];
    yes = [RMMapper mutableArrayOfClass:[BaoXiuCase class]
                  fromArrayOfDictionary:yesJSON];
    myBaoXius.yes = yes;
    
    return myBaoXius;
}

+ (BaoXiuInfo *)readJsonStrToBaoXiuInfo:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *myRepairJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( myRepairJsondDic == nil )
    {
        return nil;
    }
    BaoXiuInfo *baoXiuInfo = [RMMapper objectWithClass:[BaoXiuInfo class] fromDictionary:myRepairJsondDic];
    
    //得到报修图片集合
    baoXiuInfo.thumb = [myRepairJsondDic objectForKey:@"thumb"];
    
    //得到维修图片集合
    baoXiuInfo.weixiu_pics = [myRepairJsondDic objectForKey:@"weixiu_pics"];
    
    //得到维修过程集合
    NSMutableArray *baoxiu_process;
    id baoxiu_process_picsJSON = [myRepairJsondDic objectForKey:@"baoxiu_process"];
    baoxiu_process = [RMMapper mutableArrayOfClass:[BaoxiuPro class]
                          fromArrayOfDictionary:baoxiu_process_picsJSON];
    baoXiuInfo.baoxiu_process = baoxiu_process;
    
    return baoXiuInfo;
}

+ (NSMutableArray *)readJsonStrToFamilys:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *familyJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (familyJsonArray == nil || [familyJsonArray count] <= 0)
    {
        return nil;
    }
    NSMutableArray *familys = [RMMapper mutableArrayOfClass:[Family class] fromArrayOfDictionary:familyJsonArray];
    return familys;
}

+ (Family *)readJsonStrToFamilyDetail:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *familyJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( familyJsondDic == nil )
    {
        return nil;
    }
    Family *family = [RMMapper objectWithClass:[Family class] fromDictionary:familyJsondDic];
    return family;
}

+ (NSMutableArray *)readJsonStrToHelps:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *helpJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (helpJsonArray == nil || [helpJsonArray count] <= 0)
    {
        return nil;
    }
    NSMutableArray *helps = [RMMapper mutableArrayOfClass:[Helps class] fromArrayOfDictionary:helpJsonArray];
    return helps;
}

+ (Helps *)readJsonStrToHelpDetail:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *helpJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( helpJsondDic == nil )
    {
        return nil;
    }
    Helps *helps = [RMMapper objectWithClass:[Helps class] fromDictionary:helpJsondDic];
    return helps;
}

+ (NSMutableArray *)readJsonStrToChannels:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *channelJsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (channelJsonArray == nil || [channelJsonArray count] <= 0)
    {
        return nil;
    }
    NSMutableArray *channels = [RMMapper mutableArrayOfClass:[Channel class] fromArrayOfDictionary:channelJsonArray];
    return channels;
}

+ (OwnerScope *)readJsonStrToOwnerScopes:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *scopyJsondDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( scopyJsondDic == nil )
    {
        return nil;
    }
    OwnerScope *ownerScope = [RMMapper objectWithClass:[OwnerScope class] fromDictionary:scopyJsondDic];
    
    //得到帖子集合
    NSMutableArray *list;
    id listJSON = [scopyJsondDic objectForKey:@"list"];
    if (listJSON == [NSNull null]) {
        return nil;
    }
    list = [RMMapper mutableArrayOfClass:[BBSModel class]
                             fromArrayOfDictionary:listJSON];
    ownerScope.list = list;
    for (BBSModel *o in ownerScope.list)
    {
        NSMutableArray *reply_Array = [RMMapper mutableArrayOfClass:[BBSReplyModel class]
                                              fromArrayOfDictionary:o.reply_list];
        NSMutableAttributedString *reply_str = [[NSMutableAttributedString alloc] init];
        for (BBSReplyModel *r in reply_Array)
        {
            NSString *rname = @"匿名用户:";
            if ([r.nickname isEqualToString:@""] == NO)
            {
                rname = [NSString stringWithFormat:@"%@:", r.nickname];
            }
            else if ([r.name isEqualToString:@""] == NO)
            {
                rname = [NSString stringWithFormat:@"%@:", r.name];
            }
            NSString *rcontent = [NSString stringWithFormat:@"%@%@\n", rname, r.reply_content];
            NSMutableAttributedString *lien_str = [[NSMutableAttributedString alloc] initWithString:rcontent];
            
            [lien_str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.49 blue:0.89 alpha:1] range:NSMakeRange(0,[rcontent rangeOfString:@":"].location)];
            [reply_str appendAttributedString:lien_str];
        }
        o.timeStr = [Tool intervalSinceNow:[Tool TimestampToDateStr:o.addtime andFormatterStr:@"yyyy-MM-dd HH:mm:ss"]];
        o.replyArray = reply_Array;
        o.contentHeight = [self getTextHeight:253 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12] andText:o.content];
        o.reply_str = reply_str;
        o.replyHeight = [self getTextHeight:253 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12] andText:reply_str.string];
        NSMutableArray *point_Array = [RMMapper mutableArrayOfClass:[BBSPoint class] fromArrayOfDictionary:o.points_list];
        if(o.points_list.count > 0)
        {
            NSMutableString *point_str = [[NSMutableString alloc] init];
            for(int i = 0;i < point_Array.count;++i)
            {
                BBSPoint *point = [point_Array objectAtIndex:i];
                NSString *str;
                if( i== 0)
                {
                    if(point_Array.count > 1)
                    {
                        str = [NSString stringWithFormat:@" %@、",point.nickname];
                    }
                    else
                    {
                        str = [NSString stringWithFormat:@" %@",point.nickname];
                    }
                }
                else if(i == point_Array.count - 1)
                {
                    str = [NSString stringWithFormat:@"%@,觉得很赞",point.nickname];
                }
                else
                {
                    str = [NSString stringWithFormat:@"%@、",point.nickname];
                }
                [point_str appendString:str];
            }
            o.point_str = point_str;
        }
        o.points_list = point_Array;
    }
    return ownerScope;
}
@end

