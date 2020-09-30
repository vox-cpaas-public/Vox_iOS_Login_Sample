//
//  SignupViewController.h
//  LoginSample
//
//  Created by Kiran Vangara on 01/04/15.
//  Copyright © 2015-2018, Connect Arena Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *countryName;
@property (weak, nonatomic) IBOutlet UILabel *dialingCode;


- (IBAction)unwindFromCountryCodeViewController: (UIStoryboardSegue *)segue;


@end
