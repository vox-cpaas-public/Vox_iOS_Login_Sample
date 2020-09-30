//
//  SignupViewController.m
//  LoginSample
//
//  Created by Kiran Vangara on 01/04/15.
//  Copyright © 2015-2018, Connect Arena Private Limited. All rights reserved.
//
#import <sys/utsname.h>

#import "SignupViewController.h"
#import "CountryCodeViewController.h"

@import VoxSDK;

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSDictionary *countryCodes;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) CSClientState clientState;

@property (nonatomic, retain) UIButton *doneButton;

@end

@implementation SignupViewController

@synthesize countryName;
@synthesize countryCode;
@synthesize dialingCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countryCodes = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"+93",@"AF",@"+355",@"AL",@"+213",@"DZ",@"+1684",@"AS",
                                  @"+376",@"AD",@"+244",@"AO",@"+1264",@"AI",@"+1268",@"AG",
                                  @"+54",@"AR",@"+374",@"AM",@"+297",@"AW",@"+61",@"AU",
                                  @"+43",@"AT",@"+994",@"AZ",@"+1242",@"BS",@"+973",@"BH",
                                  @"+880",@"BD",@"+1246",@"BB",@"+375",@"BY",@"+32",@"BE",
                                  @"+501",@"BZ",@"+229",@"BJ",@"+1441",@"BM",@"+975",@"BT",
                                  @"+387",@"BA",@"+267",@"BW",@"+55",@"BR",@"+246",@"IO",
                                  @"+359",@"BG",@"+226",@"BF",@"+257",@"BI",@"+855",@"KH",
                                  @"+237",@"CM",@"+1",@"CA",@"+238",@"CV",@"+1345",@"KY",
                                  @"+236",@"CF",@"+235",@"TD",@"+56",@"CL",@"+86",@"CN",
                                  @"+61",@"CX",@"+57",@"CO",@"+269",@"KM",@"+242",@"CG",
                                  @"+682",@"CK",@"+506",@"CR",@"+385",@"HR",@"+53",@"CU",
                                  @"+357",@"CY",@"+420",@"CZ",@"+45",@"DK",@"+253",@"DJ",
                                  @"+1767",@"DM",@"+1",@"DO",@"+593",@"EC",@"+20",@"EG",
                                  @"+503",@"SV",@"+240",@"GQ",@"+291",@"ER",@"+372",@"EE",
                                  @"+251",@"ET",@"+298",@"FO",@"+679",@"FJ",@"+358",@"FI",
                                  @"+33",@"FR",@"+594",@"GF",@"+689",@"PF",@"+241",@"GA",
                                  @"+220",@"GM",@"+995",@"GE",@"+49",@"DE",@"+233",@"GH",
                                  @"+350",@"GI",@"+30",@"GR",@"+299",@"GL",@"+1473",@"GD",
                                  @"+590",@"GP",@"+1671",@"GU",@"+502",@"GT",@"+224",@"GN",
                                  @"+245",@"GW",@"+592",@"GY",@"+509",@"HT",@"+504",@"HN",
                                  @"+36",@"HU",@"+354",@"IS",@"+91",@"IN",@"+62",@"ID",
                                  @"+964",@"IQ",@"+353",@"IE",@"+972",@"IL",@"+39",@"IT",
                                  @"+1876",@"JM",@"+81",@"JP",@"+962",@"JO",@"+7",@"KZ",
                                  @"+254",@"KE",@"+686",@"KI",@"+965",@"KW",@"+996",@"KG",
                                  @"+371",@"LV",@"+961",@"LB",@"+266",@"LS",@"+231",@"LR",
                                  @"+423",@"LI",@"+370",@"LT",@"+352",@"LU",@"+261",@"MG",
                                  @"+265",@"MW",@"+60",@"MY",@"+960",@"MV",@"+223",@"ML",
                                  @"+356",@"MT",@"+692",@"MH",@"+596",@"MQ",@"+222",@"MR",
                                  @"+230",@"MU",@"+262",@"YT",@"+52",@"MX",@"+377",@"MC",
                                  @"+976",@"MN",@"+382",@"ME",@"+1664",@"MS",@"+212",@"MA",
                                  @"+95",@"MM",@"+264",@"NA",@"+674",@"NR",@"+977",@"NP",
                                  @"+31",@"NL",@"+599",@"AN",@"+687",@"NC",@"+64",@"NZ",
                                  @"+505",@"NI",@"+227",@"NE",@"+234",@"NG",@"+683",@"NU",
                                  @"+672",@"NF",@"+1670",@"MP",@"+47",@"NO",@"+968",@"OM",
                                  @"+92",@"PK",@"+680",@"PW",@"+507",@"PA",@"+675",@"PG",
                                  @"+595",@"PY",@"+51",@"PE",@"+63",@"PH",@"+48",@"PL",
                                  @"+351",@"PT",@"+1",@"PR",@"+974",@"QA",@"+40",@"RO",
                                  @"+250",@"RW",@"+685",@"WS",@"+378",@"SM",@"+966",@"SA",
                                  @"+221",@"SN",@"+381",@"RS",@"+248",@"SC",@"+232",@"SL",
                                  @"+65",@"SG",@"+421",@"SK",@"+386",@"SI",@"+677",@"SB",
                                  @"+27",@"ZA",@"+500",@"GS",@"+34",@"ES",@"+94",@"LK",
                                  @"+249",@"SD",@"+597",@"SR",@"+268",@"SZ",@"+46",@"SE",
                                  @"+41",@"CH",@"+992",@"TJ",@"+66",@"TH",@"+228",@"TG",
                                  @"+690",@"TK",@"+676",@"TO",@"+1868",@"TT",@"+216",@"TN",
                                  @"+90",@"TR",@"+993",@"TM",@"+1649",@"TC",@"+688",@"TV",
                                  @"+256",@"UG",@"+380",@"UA",@"+971",@"AE",@"+44",@"GB",
                                  @"+1",@"US",@"+598",@"UY",@"+998",@"UZ",@"+678",@"VU",
                                  @"+681",@"WF",@"+967",@"YE",@"+260",@"ZM",@"+263",@"ZW",
                                  @"+591",@"BO",@"+673",@"BN",@"+61",@"CC",@"+243",@"CD",
                                  @"+225",@"CI",@"+500",@"FK",@"+44",@"GG",@"+379",@"VA",
                                  @"+852",@"HK",@"+98",@"IR",@"+44",@"IM",@"+44",@"JE",
                                  @"+850",@"KP",@"+82",@"KR",@"+856",@"LA",@"+218",@"LY",
                                  @"+853",@"MO",@"+389",@"MK",@"+691",@"FM",@"+373",@"MD",
                                  @"+258",@"MZ",@"+970",@"PS",@"+872",@"PN",@"+262",@"RE",
                                  @"+7",@"RU",@"+590",@"BL",@"+290",@"SH",@"+1869",@"KN",
                                  @"+1758",@"LC",@"+590",@"MF",@"+508",@"PM",@"+1784",@"VC",
                                  @"+239",@"ST",@"+252",@"SO",@"+47",@"SJ",@"+963",@"SY",
                                  @"+886",@"TW",@"+255",@"TZ",@"+670",@"TL",@"+58",@"VE",
                                  @"+84",@"VN",@"+1284",@"VG",@"+1340",@"VI",@"+672",@"AQ",
                                  @"+358",@"AX",@"+47",@"BV",@"+599",@"BQ",@"+599",@"CW",
                                  @"+689",@"TF",@"+1721",@"SX",@"+211",@"SS",@"+212",@"EH",
                                  @"+972",@"IL",@"+672",@"AQ",@"+358", @"AX",@"+47",@"BV",
                                  @"+599",@"BQ",@"+599",@"CW",@"+689",@"TF",@"+1",@"SX",
                                  @"+211",@"SS",@"+212",@"EH",nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppStateNotification:) name:@"AppStateNotification" object:nil];
    
    //load values from settings
    NSLocale * locale = [NSLocale autoupdatingCurrentLocale];

	//! pick country from phone settings
	countryCode = [locale objectForKey:NSLocaleCountryCode];
    
    NSString *name = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:countryCode];
    
    [self.countryName setTitle:name forState:UIControlStateNormal];
    dialingCode.text = [self.countryCodes objectForKey:countryCode];
	
	if([CSContactStore isValidPhoneNumber:[CSSettings getLoginId] defaultRegion:countryCode])
		[self.nextButton setEnabled:YES];
	else
		[self.nextButton setEnabled:NO];
	
    CSClient *appManager = [CSClient sharedInstance];
    self.clientState = [appManager getClientState];
    
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
    
    if(self.clientState == CSClientStateReady)
        [self enableControls:YES title:@"Signup"];
    else if(self.clientState == CSClientStateConnecting)
        [self enableControls:NO title:@"Connecting..."];
    else
        [self enableControls:NO title:@"Waiting for network"];
    
    [self.phoneNumber becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AppStateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SignupResponseNotification" object:nil];
}

-(void) viewWillAppear:(BOOL)animated {
}

- (IBAction)backButtonAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) continueAction:(id)sender {
    
    //! TBD: validate phone number
    if ([self.phoneNumber.text length] > 0) {
        NSString *message = [NSString stringWithFormat:@"\nYou will receive an SMS with verification code to this number\n\n(%@) %@\n", dialingCode.text, self.phoneNumber.text];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:message delegate:self cancelButtonTitle:@"Edit" otherButtonTitles:@"OK", nil];
        
        [alert show];
    }
    else {
        //! error msg or alert
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { // OK
        
        NSString* loginId = [dialingCode.text stringByAppendingString:self.phoneNumber.text];
        
        //! create account
        CSClient *appManager = [CSClient sharedInstance];
		
		NSString* password = [[NSUUID UUID] UUIDString];

		if(self.password.text.length > 0)
			password = self.password.text;
		
        [appManager signUpWithLoginID:loginId
						  andPassword:password
					completionHandler:^(NSDictionary *response, NSError *error) {
						
						NSNumber *returnCode = [response objectForKey:kARReturnCode];
						
						switch ([returnCode intValue]) {
								
							case E_202_OK:
							case E_200_OK:
							case E_204_RESENDACTIVATIONCODE: {
								
								[self enableControls:YES title:@"Setup"];
								
								[self performSegueWithIdentifier:@"showActivationFromSetup" sender:self];
							}
								break;
								
							default: {
								
								//! TODO failed error msg or alert
								
								if (self.clientState == CSClientStateReady)
									[self enableControls:YES title:@"Setup"];
								
								NSString* errMessage = @"Signup failed";
								
								if ([returnCode intValue] == E_403_FORBIDDEN) {
									errMessage = @"Signup failed : Fobidden";
								}
								else if ([returnCode intValue] == E_499_USER_ALREADY_ATTACHED) {
									errMessage = @"Signup failed : Account used on another device";
								}
								else if ([returnCode intValue] == E_803_USER_DEACTIVATED) {
									errMessage = @"Signup failed : Account deactivated";
								}
								else if ([returnCode intValue] == E_800_INVALID_APP_ID) {
									errMessage = @"Signup failed : Invalid or No App ID";
								}
								else {
									errMessage = [NSString stringWithFormat:@"Signup failed : %@", returnCode];
								}
								
								UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"LoginSample" message:errMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
								[alert show];
								
							}
								break;
						}
					}];
        
        //! disable controls
        [self enableControls:NO title:@"Signing up..."];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showCountryCode"]) {
        
        CountryCodeViewController *destViewController = [segue destinationViewController];
        destViewController.selectedCountryCode = countryCode;
    }
}

- (IBAction)unwindFromCountryCodeViewController: (UIStoryboardSegue *)segue {

    if ([segue.sourceViewController isKindOfClass:[CountryCodeViewController class]]) {
        CountryCodeViewController *sourceViewConroller = segue.sourceViewController;
        
        countryCode = sourceViewConroller.selectedCountryCode;
       
        NSString *name = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:countryCode];
        
        [self.countryName setTitle:name forState:UIControlStateNormal];
        NSString *code = [self.countryCodes objectForKey:countryCode];
        dialingCode.text = code;
		
		if([CSContactStore isValidPhoneNumber:[dialingCode.text stringByAppendingString:self.phoneNumber.text] defaultRegion:countryCode])
			[self.nextButton setEnabled:YES];
		else
			[self.nextButton setEnabled:NO];
    }
}

#pragma mark - Keyboard handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if(textField != self.phoneNumber)
		return YES;
	
	if([CSContactStore isValidPhoneNumber:[dialingCode.text stringByAppendingString:[textField.text stringByReplacingCharactersInRange:range withString:string]] defaultRegion:countryCode] && self.clientState == CSClientStateReady)
		[self.nextButton setEnabled:YES];
	else
		[self.nextButton setEnabled:NO];
	
    return YES;
}

#pragma mark - notification handlers

-(void) handleAppStateNotification:(NSNotification*)notification {
    
    if ([notification.name isEqualToString:@"AppStateNotification"]) {
        
        NSDictionary* ASNotification = notification.userInfo;
        
        NSNumber *state = [ASNotification objectForKey:kANAppState];
        self.clientState = [state intValue];
        
        if(self.clientState == CSClientStateReady)
            [self enableControls:YES title:@"Setup"];
        else
            [self enableControls:NO title:@"Waiting for network"];
    }
}

-(void) enableControls:(BOOL)flag title:(NSString*)title {
    
    self.nameLabel.text = title;

    if (flag == TRUE) {
        
		if([CSContactStore isValidPhoneNumber:[dialingCode.text stringByAppendingString:self.phoneNumber.text] defaultRegion:countryCode])
			[self.nextButton setEnabled:YES];
		else
			[self.nextButton setEnabled:NO];

		[self.activityIndicator stopAnimating];
    }
    else {
        [self.nextButton setEnabled:NO];
        [self.activityIndicator startAnimating];
    }
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
