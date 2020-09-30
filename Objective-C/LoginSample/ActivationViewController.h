//
//  ActivationViewController.h
//  LoginSample
//
//  Created by Kiran Vangara on 02/04/15.
//  Copyright © 2015-2018, Connect Arena Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivationViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@end
