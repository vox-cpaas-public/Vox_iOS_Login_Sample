//
//  HomeViewController.h
//  LoginSample
//
//  Created by Srikanth Reddy on 08/05/19.
//  Copyright © 2019 Connect Arena Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *loggedStatus;
@property (strong, nonatomic) NSString* message;

@end


NS_ASSUME_NONNULL_END
