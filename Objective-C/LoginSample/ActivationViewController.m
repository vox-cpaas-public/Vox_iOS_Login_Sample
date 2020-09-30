//
//  ActivationViewController.m
//  LoginSample
//
//  Created by Kiran Vangara on 02/04/15.
//  Copyright © 2015-2018, Connect Arena Private Limited. All rights reserved.
//
#import <sys/utsname.h>

#import "ActivationViewController.h"
#import "HomeViewController.h"

@import VoxSDK;

//! TBD filter in numbers from pasted text
//! TBD save remaining time in persistent storage

const int VERIFICATION_CODE_LENGTH = 4;
const int RESEND_COUNTDOWN_FIRST = 30;

@interface ActivationViewController ()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSTimer *countdownTimer;

@property (weak, nonatomic) IBOutlet UILabel *displayText;
@property (weak, nonatomic) IBOutlet UIButton *resendCallButton;
@property (weak, nonatomic) IBOutlet UIButton *resendSMSButton;

@property (nonatomic) NSInteger remainingSeconds;

@end

@implementation ActivationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [CSSettings getLoginId];
    
    [self initCoundownTimer];
	
	[self.resendSMSButton setHidden:TRUE];
	[self.resendCallButton setHidden:TRUE];
    
    [self.nextButton setEnabled:FALSE];
    [self.verificationCodeText setText:@""];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppStateNotification:) name:@"AppStateNotification" object:nil];
//
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResendNotification:) name:@"ResendActivationCodeNotification" object:nil];

	CSClient *appManager = [CSClient sharedInstance];
	CSClientState clientState = [appManager getClientState];
	
	self.nameLabel = [[UILabel alloc] init];
	self.nameLabel.backgroundColor = [UIColor clearColor];
	self.nameLabel.textColor = [UIColor whiteColor];
	self.nameLabel.font = [UIFont systemFontOfSize:16.0];
	self.nameLabel.textAlignment = NSTextAlignmentCenter;
	self.nameLabel.frame = CGRectMake(0, 0, 200, 44);
	
	// custom title view for name and last seen info
	UIView * titleView = [[UIView alloc] init];
	[titleView setBackgroundColor:[UIColor clearColor]];
	titleView.frame = CGRectMake(0, 0, 200, 44);
	
	[titleView addSubview:self.nameLabel];
	
	//! start animation
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
	self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	
	[titleView addSubview:self.activityIndicator];
	
	self.navigationItem.titleView = titleView;
	
	if(clientState == CSClientStateReady)
		[self enableControls:YES title:@"  Activation  "];
	else if(clientState == CSClientStateConnecting)
		[self enableControls:NO title:@"Connecting..."];
	else
		[self enableControls:NO title:@"Waiting for network"];
}

-(void) viewDidAppear:(BOOL)animated {
    [self.verificationCodeText becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) initCoundownTimer {

	self.remainingSeconds = RESEND_COUNTDOWN_FIRST;
	self.countdownTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:self.countdownTimer forMode:NSRunLoopCommonModes];
	self.displayText.text = [NSString stringWithFormat:@"If you didnt receive SMS, you can request again in %zd seconds", (long)self.remainingSeconds];
}

-(void)updateCountdown {
    
    self.remainingSeconds--;
	
	if (self.remainingSeconds == 0) {
		
		[self.resendCallButton setHidden:FALSE];
		[self.resendCallButton setEnabled:YES];
		
		[self.resendSMSButton setHidden:FALSE];
		[self.resendSMSButton setEnabled:YES];
	
		self.displayText.text = @"";
		[self.countdownTimer invalidate];
	}
	else
		self.displayText.text = [NSString stringWithFormat:@"If you didnt receive SMS, you can request again in %zd seconds", (long)self.remainingSeconds];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)continueAction:(id)sender {

    //! activate account
    CSClient *appManager = [CSClient sharedInstance];
    
    [appManager activate:[CSSettings getLoginId]
				 withOTP:self.verificationCodeText.text
	   completionHandler:^(NSDictionary *response, NSError *error) {
		   
		   NSNumber *returnCode = [response objectForKey:kARReturnCode];
		   
		   switch ([returnCode intValue]) {
				   
			   case E_200_OK:
			   case E_202_OK: {
				   
				   // Login
				   [[CSClient sharedInstance] login:[CSSettings getLoginId]
									   withPassword:[CSSettings getPassword]
								  completionHandler:nil];
			   }
				   break;
				   
			   default: {
				   
				   //! failed error msg or alert
				   
				   [self enableControls:YES title:@"  Activation  "];
				   
				   NSString* errMessage =[NSString stringWithFormat:@"Activation failed : Wrong OTP"];
				   
				   UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"LoginSample"
																				  message:errMessage
																		   preferredStyle:UIAlertControllerStyleAlert];
				   
				   UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok"
																	  style:UIAlertActionStyleDefault
																	handler:^(UIAlertAction * action)
											  {
											  }];
				   
				   [alert addAction:okButton];
				   [self presentViewController:alert animated:YES completion:nil];
				   
			   }
				   break;
		   }
	   }];
	
	[self enableControls:NO title:@"Verifying..."];
}

#pragma mark - Keyboard handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (newLength == VERIFICATION_CODE_LENGTH)
            [self.nextButton setEnabled:true];
        else
            [self.nextButton setEnabled:false];
        
        return YES;
}

#pragma mark - Notification handlers

-(void) handleAppStateNotification:(NSNotification*)notification
{
	if ([notification.name isEqualToString:@"AppStateNotification"]) {
		
		NSDictionary* ASNotification = notification.userInfo;
		
		int clientState = [[ASNotification objectForKey:kANAppState] intValue];
		//NSInteger reasonCode = [[ASNotification objectForKey:kANReasonCode] integerValue];
		
		switch (clientState) {
				
			case CSClientStateActive: { // Login success
                [self showMainViewandLoginStatus:false];
			}
				break;
			
			case CSClientStateReady: {
				[self enableControls:YES title:@"  Activation  "];
			}
			break;
			
			case CSClientStateInactive: {
				[self enableControls:NO title:@"Waiting for network"];
			}
			break;
			
			default: {
				//! TODO handle other states
			}
				break;
		}
	}
}

- (IBAction)resendByCallAction:(id)sender {
	
	[self.resendSMSButton setEnabled:NO];
	[self.resendCallButton setEnabled:NO];

	self.displayText.text = @"You will receive a call shortly";

	[[CSClient sharedInstance] resendActivationCodeForLoginID:[CSSettings getLoginId] byVoiceCall:TRUE completionHandler:^(NSDictionary *response, NSError *error) {
		
		NSNumber *returnCode = [response objectForKey:kARReturnCode];
		
		switch ([returnCode intValue]) {
				
			case E_200_OK:
			case E_202_OK: {
				// TODO
			}
				break;
				
			default:
				break;
		}
	}];
	
	[self initCoundownTimer];
}

- (IBAction)resendBySMSAction:(id)sender {
	
	[self.resendSMSButton setEnabled:NO];
	[self.resendSMSButton setHidden:YES];
	[self.resendCallButton setEnabled:NO];
	
	self.displayText.text = @"Resending SMS...";

	[[CSClient sharedInstance] resendActivationCodeForLoginID:[CSSettings getLoginId] byVoiceCall:FALSE completionHandler:^(NSDictionary *response, NSError *error) {
		
		NSNumber *returnCode = [response objectForKey:kARReturnCode];
		
		switch ([returnCode intValue]) {
				
			case E_200_OK:
			case E_202_OK: {
				// TODO
			}
				break;
				
			default:
				break;
		}
	}];

	[self initCoundownTimer];
}

-(void) enableControls:(BOOL)flag title:(NSString*)title {
	
	self.nameLabel.text = title;
	
	if (flag == TRUE) {
		
		if(self.verificationCodeText.text.length == VERIFICATION_CODE_LENGTH)
			[self.nextButton setEnabled:YES];
		else
			[self.nextButton setEnabled:NO];
		
		[self.verificationCodeText setEnabled:YES];
		[self.resendSMSButton setEnabled:YES];
		[self.resendCallButton setEnabled:YES];
		[self.activityIndicator stopAnimating];
	}
	else {
		[self.nextButton setEnabled:NO];
		[self.verificationCodeText setEnabled:NO];
		[self.resendSMSButton setEnabled:NO];
		[self.resendCallButton setEnabled:NO];
		[self.activityIndicator startAnimating];
	}
}

-(void) showMainViewandLoginStatus:(BOOL)status {
    HomeViewController *rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    rootViewController.message = @"Singup successful";
    NSDictionary *barButtonTitleAttributes = @{
                                               NSForegroundColorAttributeName : [UIColor whiteColor]
                                               
                                               };
    UINavigationController *navVc = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    [navVc.navigationBar setTitleTextAttributes:barButtonTitleAttributes];
    navVc.navigationBar.barTintColor = [UIColor colorWithRed:15.0/255.0 green:120.0/255.0 blue:104.0/255.0 alpha:1.0];
    
    UIView *overlayView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    [rootViewController.view addSubview:overlayView];
    [[UIApplication sharedApplication].keyWindow setRootViewController:navVc];
    
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        overlayView.alpha = 0;
    } completion:^(BOOL finished) {
        [overlayView removeFromSuperview];
        //[self dismissViewControllerAnimated:NO completion:nil];
    }];
}


	
#pragma mark Rotation

-(BOOL)shouldAutorotate {
	
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
	
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

@end
