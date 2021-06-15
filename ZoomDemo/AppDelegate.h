//
//  AppDelegate.h
//  ZoomDemo
//
//  Created by Jasmin Patel on 15/06/21.
//

#import <UIKit/UIKit.h>
#import <MobileRTC/MobileRTC.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, MobileRTCAuthDelegate>

-(void)setupSDK:(NSString *)sdkKey sdkSecret:(NSString *)sdkSecret;

@property (strong, nonatomic) UIWindow *window;

@end

