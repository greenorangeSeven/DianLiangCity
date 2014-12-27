#ifndef DeLightCity_Micro_h
#define DeLightCity_Micro_h

#define ALog(format, ...) NSLog((@"%s [L%d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#ifdef DEBUG
#define TTLog(format, ...) ALog(format, ##__VA_ARGS__)
#else
#define TTLog(...)
#endif

#define SharedAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define UIColorRGB(r, g, b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)/255.0]
#define UIColorHSL(h, s, l)     [UIColor colorWithHue:(h)/255.0f saturation:(s)/255.0f brightness:(l)/255.0f alpha:1.0f]
#define UIColorHSLA(h, s, l, a) [UIColor colorWithHue:(h)/255.0f saturation:(s)/255.0f brightness:(l)/255.0f alpha:(a)/255.0f]


#endif