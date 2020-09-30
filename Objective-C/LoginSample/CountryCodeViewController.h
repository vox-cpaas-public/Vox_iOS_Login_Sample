//
//  CountryCodeViewController.h
//  LoginSample
//
//  Created by Kiran Vangara on 07/04/15.
//  Copyright © 2015-2018, Connect Arena Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryCodeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *selectedCountryCode;

@end
