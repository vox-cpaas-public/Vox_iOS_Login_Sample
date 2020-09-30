//
//  CountryCodeViewController.m
//  LoginSample
//
//  Created by Kiran Vangara on 07/04/15.
//  Copyright © 2015-2018, Connect Arena Private Limited. All rights reserved.
//

#import "CountryCodeViewController.h"

@interface CountryCodeViewController ()

@property (strong, nonatomic) NSArray *countryNames;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSDictionary *countryCodeMap;
@property (strong, nonatomic) NSMutableDictionary *countryNameMap;
@property (strong, nonatomic) NSMutableArray *isdCountryCodes;

@property (weak, nonatomic) IBOutlet UITableView *namesTableView;

@end

@implementation CountryCodeViewController

@synthesize selectedCountryCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // search controller
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchDisplayController.searchResultsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor lightGrayColor];
    
    // initialize and default to phone locale
    
    NSArray* unSortedCountryCodes = [NSLocale ISOCountryCodes];
    NSMutableArray* unsortedNames = [[NSMutableArray alloc] init];
    self.countryNameMap = [[NSMutableDictionary alloc] init];
	self.isdCountryCodes = [[NSMutableArray alloc] init];

    for (NSString *code in unSortedCountryCodes) {
        NSString *name = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:code];
		
		if([code isEqualToString:@"CP"])
			continue;
		
        [unsortedNames addObject:name];
        [self.countryNameMap addEntriesFromDictionary:[NSDictionary dictionaryWithObject:code forKey:name]];
    }
    
    self.countryNames = [unsortedNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
    self.countryCodeMap = [NSDictionary dictionaryWithObjectsAndKeys:
								  @"+247", @"AC", @"+34", @"IC", @"+34", @"EA", @"+246", @"DG",
						   		  @"+672", @"HM", @"+383", @"XK", @"290", @"TA", @"+1", @"UM",
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
	
	for(NSString* name in self.countryNames) {
		NSString* ISOCode = [self.countryNameMap objectForKey:name];
		NSString* ISDCode = [self.countryCodeMap objectForKey:ISOCode];
		[self.isdCountryCodes addObject:ISDCode];
	}
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *name = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:selectedCountryCode];
    
    NSPredicate *searchPredicate =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@", name];
    NSArray *filterResults = [self.countryNames filteredArrayUsingPredicate:searchPredicate];
    
    if ([filterResults count] > 0) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.countryNames indexOfObject:[filterResults firstObject]] inSection:0];
        [self.namesTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - TableView handling

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return self.searchResults.count;
    else
        return [self.countryNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CountryCodeCell";
    
    UITableViewCell *cell = nil;
    
    cell = [self.namesTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    UILabel *countryNameLabel = (UILabel*)[cell.contentView viewWithTag:101];
    UILabel *countryCodeLabel = (UILabel*)[cell.contentView viewWithTag:102];
    
    NSString *countryName;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
        countryName = [self.searchResults objectAtIndex:indexPath.row];
    else
        countryName = [self.countryNames objectAtIndex:indexPath.row];
    
    countryNameLabel.text = countryName;
    countryCodeLabel.text = [self.countryCodeMap objectForKey:[self.countryNameMap objectForKey:countryName]];
    
    // selected cell bg color
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
    cell.selectedBackgroundView =  bgView;
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
        name = [self.searchResults objectAtIndex:indexPath.row];
    else
        name = [self.countryNames objectAtIndex:indexPath.row];
    
    selectedCountryCode = [self.countryNameMap objectForKey:name];
    
    [self performSegueWithIdentifier:@"unwindToSetup" sender:self];
}

#pragma mark Search handling

//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    // only show the status bar’s cancel button while in edit mode sbar (UISearchBar)
//    searchBar.showsCancelButton = YES;
//    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *searchPredicate =  [NSPredicate predicateWithBlock:^BOOL(id countryName, NSDictionary *bindings) {
        return (([countryName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound));
    }];
    
   self.searchResults = [self.countryNames filteredArrayUsingPredicate:searchPredicate];
	if(self.searchResults.count == 0) {
		
		NSMutableArray* names = [[NSMutableArray alloc] init];
		
		NSArray* results = [self.isdCountryCodes filteredArrayUsingPredicate:searchPredicate];
		NSArray* uniqueResults = [results valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", @"self"]];
		
		for(NSString* isdcode in uniqueResults) {
			NSArray* ISOCodes = [self.countryCodeMap allKeysForObject:isdcode];
			for(NSString* isocode in ISOCodes) {
				[names addObject:[[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:isocode]];
			}
		}
		
		self.searchResults = names;
	}
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark Rotation

-(BOOL)shouldAutorotate {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return UIInterfaceOrientationPortrait;
}

@end
