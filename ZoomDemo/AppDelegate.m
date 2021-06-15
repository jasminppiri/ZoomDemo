//
//  AppDelegate.m
//  ZoomDemo
//
//  Created by Jasmin Patel on 15/06/21.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <MobileRTC/MobileRTC.h>

@interface AppDelegate ()

@property (nonatomic, copy) NSString *sdkKey;
@property (nonatomic, copy) NSString *sdkSecret;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.sdkKey = @"EMy8Zo67fkJNsJuOYAjT0iIGUMgIJt50hnun";
    self.sdkSecret = @"6y0n3IVcUv92bc8MNRwmep4H3ocddTfDIGVb";

    [self setupSDK:self.sdkKey sdkSecret:self.sdkSecret];
    
    return YES;

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    MobileRTCAuthService *authService = [[MobileRTC sharedRTC] getAuthService];

    if (authService)
        [authService logoutRTC];

    [[MobileRTC sharedRTC] appWillTerminate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[MobileRTC sharedRTC] appWillResignActive];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[MobileRTC sharedRTC] appDidBecomeActive];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[MobileRTC sharedRTC] appDidEnterBackgroud];
}


- (void)setupSDK:(NSString *)sdkKey sdkSecret:(NSString *)sdkSecret {
    MobileRTCSDKInitContext *context = [[MobileRTCSDKInitContext alloc] init];
    context.domain = @"zoom.us";
    context.enableLog = YES;

    BOOL sdkInitSuc = [[MobileRTC sharedRTC] initialize:context];

    if (sdkInitSuc) {
        MobileRTCAuthService *authService = [[MobileRTC sharedRTC] getAuthService];

        if (authService) {
            authService.clientKey = sdkKey;
            authService.clientSecret = sdkSecret;

            authService.delegate = self;

            [authService sdkAuth];
        }
    }
}


#pragma mark - MobileRTCAuthDelegate

- (void)onMobileRTCAuthReturn:(MobileRTCAuthError)returnValue {
    switch (returnValue) {
        case MobileRTCAuthError_Success:
            NSLog(@"SDK successfully initialized.");
            break;
        case MobileRTCAuthError_KeyOrSecretEmpty:
            NSLog(@"SDK key/secret was not provided. Replace sdkKey and sdkSecret at the top of this file with your SDK key/secret.");
            break;
        case MobileRTCAuthError_KeyOrSecretWrong:
            NSLog(@"SDK key/secret is not valid.");
            break;
        case MobileRTCAuthError_Unknown:
            NSLog(@"SDK key/secret is not valid.");
            break;
        default:
            NSLog(@"SDK Authorization failed with MobileRTCAuthError: %lu", returnValue);
    }
}

- (void)onMobileRTCLoginReturn:(NSInteger)returnValue {
    switch (returnValue) {
        case 0:
            NSLog(@"Successfully logged in");

            [[NSNotificationCenter defaultCenter] postNotificationName:@"userLoggedIn" object:self];
            break;
        case 1002:
            NSLog(@"Password incorrect");
            break;
        default:
            NSLog(@"Could not log in. Error code: %li", (long)returnValue);
            break;
    }
}

- (void)onMobileRTCLogoutReturn:(NSInteger)returnValue {
    switch (returnValue) {
        case 0:
            NSLog(@"Successfully logged out");
            break;
        case 1002:
            NSLog(@"Password incorrect");
            break;
        default:
            NSLog(@"Could not log out. Error code: %li", (long)returnValue);
            break;
    }
}


@end
