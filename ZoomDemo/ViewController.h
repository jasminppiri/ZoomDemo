//
//  ViewController.h
//  ZoomDemo
//
//  Created by Jasmin Patel on 15/06/21.
//

#import <UIKit/UIKit.h>
#import <MobileRTC/MobileRTC.h>

@interface ViewController : UIViewController<MobileRTCMeetingServiceDelegate>

- (IBAction)joinAMeetingButtonPressed:(UIButton *_Nonnull)sender;
- (IBAction)startAnInstantMeetingButtonPressed:(UIButton *_Nonnull)sender;

- (void)joinMeeting:(nonnull NSString *)meetingNumber meetingPassword:(nonnull NSString*)meetingPassword name:(nonnull NSString*)name;
- (void)logIn:(nonnull NSString*)email password:(nonnull NSString*)password;
- (void)startMeeting;
- (void)presentJoinMeetingAlert;
- (void)presentLogInAlert;
- (void)userLoggedIn;

@end

