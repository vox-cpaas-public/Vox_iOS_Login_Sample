//
//  InitialViewController.m
//  Konverz
//
//  Created by Kiran Vangara on 31/03/15.
//  Copyright © 2015-2018, Connect Arena Private Limited. All rights reserved.
//

#import "InitialViewController.h"

@import VoxSDK;

@interface InitialViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // register for Application state notificiation
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppStateNotification:) name:@"AppStateNotification" object:nil];
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) handleAppStateNotification:(NSNotification*)notification {
    
    if ([notification.name isEqualToString:@"AppStateNotification"]) {
        
        NSDictionary* ASNotification = notification.userInfo;
		
        NSNumber *state = [ASNotification objectForKey:kANAppState];
		
		if([state intValue] == CSClientStateReady) {
			[self.activityIndicator stopAnimating];
		}
		else if([state intValue] == CSClientStateInactive) {
			
			// TODO: Check if wifi & mobile data is turned off
			// and prompt for settings
			
			[self.statusLabel setHidden:FALSE];

			static dispatch_once_t onceToken;
			dispatch_once(&onceToken, ^{
				UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																			   message:@"Please connect to internet and try again"
																		preferredStyle:UIAlertControllerStyleAlert];
				
				UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok"
																   style:UIAlertActionStyleDefault
																 handler:^(UIAlertAction * action)
										   {
										   }];
				
				[alert addAction:okButton];
				[self presentViewController:alert animated:YES completion:nil];
			});
		}
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
