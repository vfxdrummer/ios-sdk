//
//  DetailViewController.m
//  ObjCDemo
//
//  Created by LoginRadius Development Team on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "DetailViewController.h"
#import "LoginRadius.h"
#import "XLFormViewControllerExtension.h"


static NSArray<NSString *>* _countries = nil;
@interface DetailViewController ()
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSDictionary *userProfile;
@end

@implementation DetailViewController

+ (NSArray<NSString *>*)countries {
    if (!_countries) {
        NSLocale *locale = [NSLocale currentLocale];
        NSArray *countryArray = [NSLocale ISOCountryCodes];

        NSMutableArray<NSString *> *countryArr = [[NSMutableArray<NSString *> alloc] init];

        for (NSString *countryCode in countryArray) {

            NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
            [countryArr addObject:displayNameString];

        }

        [countryArr sortUsingSelector:@selector(localizedCompare:)];
        _countries = [countryArr copy];
    }

    return _countries;
}

    //NSArray<NSString *> *countries = NSLocale

      /* NSLocale.isoCountryCodes.map { (code:String) -> String in
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        return NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
    }*/

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupForm)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [self setupForm];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupForm{
    NSString * userAccessToken =  [[[LoginRadiusSDK sharedInstance] session] accessToken];
    if (userAccessToken == nil)
    {
        [self showAlert:@"ERROR" message:@"Access token is missing or logged out"];
        [self logoutPressed:self];
        return;
    }
    
    self.accessToken = userAccessToken;
    [self validateAccessToken:NO];
    
    NSDictionary * profile =  [[[LoginRadiusSDK sharedInstance] session] userProfile];
    
    if(profile)
    {
        if ([self userProfile] && [profile isEqualToDictionary:[self userProfile]])
        {
            //same userProfile, don't reload ui
            return;
        }
        
        self.userProfile = profile;
    }else{
        profile = [[NSDictionary alloc] init];
    }
    
    [[self navigationItem] setHidesBackButton:YES animated:NO];
    [self navigationItem].title = @"User Profile ObjC";
    
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    XLFormRowDescriptor * switchRow;
    
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Logout" rowType:XLFormRowDescriptorTypeButton title:@"Log out"];
    row.action.formBlock = ^(XLFormRowDescriptor *block)
    {
        [self logoutPressed:self];
    };
    [section addFormRow:row];
    
    //User Profile Section
    NSString *userEmail = [[_userProfile objectForKey:@"Email"][0] objectForKey:@"Value"];
    
    id countryObj = [_userProfile objectForKey:@"Addresses"];
    NSString *userCountry  = ([countryObj isKindOfClass:[NSArray class]]) ? [[_userProfile objectForKey:@"Addresses"][0]  objectForKey:@"Country"] : nil;
    NSString *gender = [_userProfile objectForKey:@"Gender"];

    section = [XLFormSectionDescriptor formSectionWithTitle:@"User Profile Section"];
    [form addFormSection:section];
    
    switchRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"UserProfile" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"User Profile"];
    switchRow.value = @1;
    [section addFormRow:switchRow];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"FirstName" rowType:XLFormRowDescriptorTypeText title:@"First Name"];
    row.required = YES;
    //bug on validator returning nil when theres no validator
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"First Name is required!" regex:@".+"]];
    row.value = [_userProfile objectForKey:@"FirstName"];
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"LastName" rowType:XLFormRowDescriptorTypeText title:@"Last Name"];
    row.required = YES;
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"Last Name is required!" regex:@".+"]];
    row.value = [_userProfile objectForKey:@"LastName"];
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Email" rowType:XLFormRowDescriptorTypeEmail title:@"Email"];
    row.required = YES;
    row.value = userEmail;
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Gender" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"Gender"];
    row.selectorOptions = @[@"M",@"F",@"?"];
    row.value = gender;
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"Gender is required!" regex:@".+"]];
    row.required = YES;
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [section addFormRow:row];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Country" rowType:XLFormRowDescriptorTypeSelectorPush title:@"Country"];
    row.selectorOptions = [DetailViewController countries];
    row.value = userCountry;
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"Country is required!" regex:@".+"]];
    row.required = YES;
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Update Profile" rowType:XLFormRowDescriptorTypeButton title:@"Update Profile"];
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    row.action.formSelector = @selector(validateUserProfileInput);
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Information" rowType:XLFormRowDescriptorTypeButton title:@"Information"];
    row.action.formBlock = ^(XLFormRowDescriptor *block)
    {
        [self showAlert:@"Information" message:@"For more usage examples,\nSee our Swift demo!"];
    };
    [section addFormRow:row];

    self.form = form;
}

- (void)validateUserProfileInput {
    XLFormRowDescriptor *fNameRow = [[self form] formRowWithTag:@"FirstName"];
    XLFormRowDescriptor *lNameRow = [[self form] formRowWithTag:@"LastName"];
    XLFormRowDescriptor *genderRow = [[self form] formRowWithTag:@"Gender"];
    XLFormRowDescriptor *countryRow = [[self form] formRowWithTag:@"Country"];
    
    NSMutableArray<XLFormValidationStatus *> *errors = [[NSMutableArray<XLFormValidationStatus *> alloc] init];
    
    [errors addObject:[fNameRow doValidation]];
    [errors addObject:[lNameRow doValidation]];
    [errors addObject:[genderRow doValidation]];
    [errors addObject:[countryRow doValidation]];

    for (int i = 0; i < [errors count]; i++)
    {
        if (!errors[i].isValid)
        {
            [self showAlert:@"ERROR" message:[errors[i] msg]];
            return;
        }
    }
    
    [self updateProfile:@[fNameRow,lNameRow,genderRow,countryRow]];
}

- (void)updateProfile: (NSArray<XLFormRowDescriptor *> *) rows
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    for(int i = 0; i < [rows count]; i++)
    {
        XLFormRowDescriptor *row = rows[i];
        [parameters setObject:[row value] forKey:[row tag]];
        
        if ([[LoginRadiusField addressFields] containsObject:[[row tag] lowercaseString]])
        {
            if ( ![parameters objectForKey:@"addresses"])
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:[row value] forKey:[row tag]];
                [parameters setObject:@[dict] forKey:@"addresses"];
            }else
            {
                NSArray<NSMutableDictionary *> *arr = [parameters objectForKey:@"addresses"];
                [arr[0] setObject:[row value] forKey:[row tag]];
                [parameters setObject:arr forKey:@"addresses"];
            }
            
            [parameters removeObjectForKey:[row tag]];
        }
    }
    
    //if contains address, add type at the end.
    if ( [parameters objectForKey:@"addresses"])
    {
        NSArray<NSMutableDictionary *> *arr = [parameters objectForKey:@"addresses"];
        [arr[0] setObject:@"Personal" forKey:@"Type"];
    }
    
    [[LoginRadiusRegistrationManager sharedInstance] authUpdateProfilebyToken:[self accessToken] verificationUrl:@"" emailTemplate:@"" userData: [parameters copy] completionHandler: ^(NSDictionary *data, NSError *error)
    {
        if (error)
        {
            [self showAlert:@"ERROR" message:[error localizedDescription]];
        }
        else
        {
            [[LoginRadiusRegistrationManager sharedInstance] authProfilesByToken:[self accessToken] completionHandler:^(NSDictionary *data, NSError *error)
            {
                if (error)
                {
                    NSLog(@"%@", [error localizedDescription]);
                    [self showAlert:@"ERROR" message:[error localizedDescription]];
                }
                else
                {
                    [self showAlert:@"SUCCESS" message:@"User updated!"];
                    NSLog(@"Here is the raw NSDictionary user profile:");
                    NSLog(@"%@", [self userProfile]);
                    NSLog(@"end of raw NSDictionary user profile");
                    [self viewDidLoad];
                }
            }];
        }
    }];
}

- (void) validateAccessToken:(BOOL)showSuccess
{
    [[LoginRadiusRegistrationManager sharedInstance] authValidateAccessToken:[self accessToken] completionHandler:^(NSDictionary *data, NSError *error)
    {
        if (error)
        {
            [self showAlert:@"ERROR" message:[error localizedDescription]];
        }else if (showSuccess)
        {
            NSString *msg = [NSString stringWithFormat:@"Access Token: %@ is VALID\n expires in: %@",[data objectForKey:@"access_token"], [data objectForKey:@"expires_in"]];
            [self showAlert:@"SUCCESS" message: msg];
        }
    }];
}

- (void)logoutPressed:(id)sender {
    [LoginRadiusSDK logout];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
