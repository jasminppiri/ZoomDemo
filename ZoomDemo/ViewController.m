//
//  ViewController.m
//  ZoomDemo
//
//  Created by Jasmin Patel on 15/06/21.
//

#import "ViewController.h"
#import <MobileRTC/MobileRTC.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINavigationController *navController = self.navigationController;

    if (navController)
        [[MobileRTC sharedRTC] setMobileRTCRootController:navController];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedIn) name:@"userLoggedIn" object:nil];
}


#pragma mark - IBOutlets


- (IBAction)joinAMeetingButtonPressed:(UIButton *)sender {
    [self presentJoinMeetingAlert];
}


- (IBAction)startAnInstantMeetingButtonPressed:(UIButton *)sender {
    MobileRTCAuthService *authService = [[MobileRTC sharedRTC] getAuthService];

    if (authService) {
        BOOL isLoggedIn = [authService isLoggedIn];
        if (isLoggedIn) {
            [self startMeeting];
        } else {
            [self presentLogInAlert];
        }
    }
}

- (void)joinMeeting:(NSString *)meetingNumber meetingPassword:(NSString *)meetingPassword name:(NSString*)name {
    MobileRTCMeetingService *meetService = [[MobileRTC sharedRTC] getMeetingService];

    if (meetService) {
        meetService.delegate = self;

        MobileRTCMeetingJoinParam *joinParams = [[MobileRTCMeetingJoinParam alloc] init];
        joinParams.meetingNumber = meetingNumber;
        joinParams.password = meetingPassword;
        joinParams.userName = name;
        [meetService joinMeetingWithJoinParam:joinParams];
    }
}


- (void)logIn:(NSString *)email password:(NSString *)password {
    MobileRTCAuthService *authService = [[MobileRTC sharedRTC] getAuthService];

    if (authService)
        [authService loginWithEmail:email password:password rememberMe:false];
}


- (void)startMeeting {
    MobileRTCMeetingService *meetService = [[MobileRTC sharedRTC] getMeetingService];

    if (meetService) {
        meetService.delegate = self;

        MobileRTCMeetingStartParam * startParams = [[MobileRTCMeetingStartParam4LoginlUser alloc] init];

        [meetService startMeetingWithStartParam:startParams];
    }
}

- (void)presentJoinMeetingAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Join meeting" message:@"" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Meeting number";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Meeting password";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.secureTextEntry = YES;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Display name";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    UIAlertAction *joinMeetingAction = [UIAlertAction actionWithTitle:@"Join meeting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *number = [[alertController textFields][0] text];
        NSString *password = [[alertController textFields][1] text];
        NSString *name = [[alertController textFields][2] text];

        if (number && password)
            [self joinMeeting:number meetingPassword:password name:name];

    }];

    [alertController addAction:joinMeetingAction];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NULL;
    }];

    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)presentLogInAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Log in" message:@"" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Email";
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.secureTextEntry = YES;
    }];

    UIAlertAction *logInAction = [UIAlertAction actionWithTitle:@"Log in" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *email = [[alertController textFields][0] text];
        NSString *password = [[alertController textFields][1] text];

        if (email && password)
            [self logIn:email password:password];

    }];

    [alertController addAction:logInAction];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NULL;
    }];

    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)userLoggedIn {
    [self startMeeting];
}

- (void)onMeetingError:(MobileRTCMeetError)error message:(NSString *)message {
    switch (error) {
        case MobileRTCMeetError_Success:
            NSLog(@"Successful meeting operation.");
        case MobileRTCMeetError_PasswordError:
            NSLog(@"Could not join or start meeting because the meeting password was incorrect.");
        default:
            NSLog(@"Could not join or start meeting with MobileRTCMeetError: %lu %@", error, message);
    }
}

- (void)onJoinMeetingConfirmed {
    NSLog(@"Join meeting confirmed.");
}


- (void)onMeetingStateChange:(MobileRTCMeetingState)state {
    NSLog(@"Current meeting state: %lu", state);
}


@end
