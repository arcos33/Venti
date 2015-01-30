//
//  LoginViewController.m
//  Venti
//
//  Created by Personal on 11/8/14.
//
//

#import "LoginViewController.h"
#import "HomePageViewController.h"
#import "RegistrationViewController.h"
#import "ForgotPasswordViewController.h"


@interface LoginViewController ()

@property (nonatomic) UITextField *userNameField;
@property (nonatomic) UITextField *passwordField;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UIImageView *passImageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UIView *loginViewCover;
@property (nonatomic, strong) UIButton *profilePictureButton;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set the login background image
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    UIImage *backgroundImage = [UIImage imageNamed:@"login_background_image.png"];
    backgroundImageView.image = backgroundImage;
    [self.view addSubview:backgroundImageView];
    
    // Create the smaller view to hold the logo and other elements
    _loginView = [[UIView alloc] init];
    _loginView.frame = CGRectMake((self.view.bounds.size.width - 450) / 2.0, (self.view.bounds.size.height - 407.0) / 2.0, 450, 450);
    _loginView.backgroundColor = [UIColor whiteColor];
    _loginView.layer.cornerRadius = 5.0;
    [_loginView.layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [_loginView.layer setShadowOpacity:.85];
    [_loginView.layer setShadowRadius:10];
    [self.view addSubview:_loginView];
    

    
    // Set the Logo Image
    UIImageView *loginLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_loginView.frame.size.width - 200) / 2.0, 15.0, 177.0, 165)];
    UIImage *loginLogoImage = [UIImage imageNamed:@"login_logo.png"];
    loginLogoImageView.image = loginLogoImage;
    [_loginView addSubview:loginLogoImageView];
    
    //Setup the login fields
    _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 50.0)];
    [_userNameField setCenter:loginLogoImageView.center];
    [_userNameField setCenter:CGPointMake(loginLogoImageView.center.x, loginLogoImageView.center.y + 120)];
    
    _userNameField.delegate = self;
    _userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    [_loginView addSubview:_userNameField];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 50.0)];
    [_passwordField setCenter:_userNameField.center];
    [_passwordField setCenter:CGPointMake(_userNameField.center.x, _userNameField.center.y + 50)];
    _passwordField.delegate = self;
    _passwordField.secureTextEntry = YES;
    _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    [_loginView addSubview:_passwordField];
    
    // Setup the borders for the fields
    UIView *userTopBorder = [[UIView alloc] initWithFrame:CGRectMake(0.0, 1.0, _userNameField.frame.size.width, 1.0)];
    userTopBorder.backgroundColor = [UIColor colorWithRed:176.0/255.0 green:176.0/255.0 blue:176.0/255.0 alpha:1.0];
    [_userNameField addSubview:userTopBorder];
    
    UIView *userBottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0.0, _userNameField.frame.size.height - 1.0, _userNameField.frame.size.width, 1.0)];
    userBottomBorder.backgroundColor = [UIColor colorWithRed:176.0/255.0 green:176.0/255.0 blue:176.0/255.0 alpha:1.0];
    [_userNameField addSubview:userBottomBorder];
    
    UIView *passBottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0.0, _passwordField.frame.size.height - 1.0, _passwordField.frame.size.width, 1.0)];
    passBottomBorder.backgroundColor = [UIColor colorWithRed:176.0/255.0 green:176.0/255.0 blue:176.0/255.0 alpha:1.0];
    [_passwordField addSubview:passBottomBorder];
    
    // Create the images for the fields
    _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 15.0, 14.0, 16.0)];
    UIImage *userImage = [UIImage imageNamed:@"login_username_icon.png"];
    _userImageView.image = userImage;
    [_userNameField addSubview:_userImageView];
    
    _passImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 15.0, 14.5, 17.5)];
    UIImage *passImage = [UIImage imageNamed:@"login_password_icon.png"];
    _passImageView.image = passImage;
    [_passwordField addSubview:_passImageView];
    
    // Add Placeholder Text
    _userNameField.placeholder = @"       Username";
    _passwordField.placeholder = @"       Password";
    
    // Set the font size
    _userNameField.font = [UIFont fontWithName:@"HelveticaNeue" size:21.0];
    _passwordField.font = [UIFont fontWithName:@"HelveticaNeue" size:21.0];
    
    //Add the login button
    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginButton.frame = CGRectMake(0, 0, 312.0, 50.0);
    [_loginButton setCenter:_userNameField.center];
    [_loginButton setCenter:CGPointMake(_userNameField.center.x, _userNameField.center.y + 112)];
    CAGradientLayer *gradientColor = [CAGradientLayer layer];
    gradientColor.frame = CGRectMake(0.0, 0.0, _loginButton.frame.size.width, _loginButton.frame.size.height);
    gradientColor.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor colorWithRed:0.30 green:0.73 blue:0.97 alpha:1.00] CGColor],
                            (id)[[UIColor colorWithRed:0.29 green:0.79 blue:0.95 alpha:1.00] CGColor],
                            (id)[[UIColor colorWithRed:0.29 green:0.85 blue:0.90 alpha:1.00] CGColor],
                            nil];
    
    [_loginButton.layer addSublayer:gradientColor];
    [_loginButton.layer setCornerRadius:5];
    [_loginButton setClipsToBounds:YES];
    _loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
    [_loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(callCheckCredentials) forControlEvents:UIControlEventTouchUpInside];
    
    [_loginView addSubview:_loginButton];
    
    [self createRegistrationButton];
    [self createForgotPasswordButton];
    
    // Hide the navigation controller nav bar.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _userNameField) {
        [UIView animateWithDuration:0.8 animations:^{
            _userImageView.frame = CGRectMake(_userNameField.frame.size.width - 29.0, 15.0, 14.0, 16.0);
            _userNameField.placeholder = @"Username";
        }];
    }else{
        [UIView animateWithDuration:0.8 animations:^{
            _passImageView.frame = CGRectMake(_passwordField.frame.size.width - 29.5, 15.0, 14.5, 17.5);
            _passwordField.placeholder = @"Password";
        }];
    }
}

- (void)callCheckCredentials
{
    _loginViewCover = [[UIView alloc] init];
    _loginViewCover.frame = CGRectMake((self.view.bounds.size.width - 358.0) / 2.0, (self.view.bounds.size.height - 407.0) / 2.0, 358.0, 407.0);
    _loginViewCover.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    _loginViewCover.layer.cornerRadius = 10.0;
    
    
    [self.view addSubview:_loginViewCover];
    
    dispatch_queue_t loginActivity = dispatch_queue_create("com.acti.post", NULL);
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.frame = CGRectMake(_loginViewCover.frame.size.width / 2.0 - 20.0, _loginViewCover.frame.size.height / 2.0 - 20.0, 40.0, 40.0);
    
    [_loginViewCover addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    
    dispatch_async(loginActivity,^{
        [self checkCredentials];
    });
    
    
    
}

- (void)checkCredentials
{
    
    
    // First, make sure both fields are filled out.
    NSString *userNameString = _userNameField.text;
    NSString *userPasswordString = _passwordField.text;
    
    //userNameString = @"arios";
    //userPasswordString = @"hounds56";
    
    if ([userNameString isEqualToString:@""] || userNameString == nil) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activityIndicator stopAnimating];
            [_loginViewCover removeFromSuperview];
            CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
            [shake setDuration:0.1];
            [shake setRepeatCount:2];
            [shake setAutoreverses:YES];
            [shake setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake(_loginView.center.x - 5,_loginView.center.y)]];
            [shake setToValue:[NSValue valueWithCGPoint:
                               CGPointMake(_loginView.center.x + 5, _loginView.center.y)]];
            [_loginView.layer addAnimation:shake forKey:@"position"];
            
        });
        
    }else if ([userPasswordString isEqualToString:@""] || userPasswordString == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activityIndicator stopAnimating];
            [_loginViewCover removeFromSuperview];
            CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
            [shake setDuration:0.1];
            [shake setRepeatCount:2];
            [shake setAutoreverses:YES];
            [shake setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake(_loginView.center.x - 5,_loginView.center.y)]];
            [shake setToValue:[NSValue valueWithCGPoint:
                               CGPointMake(_loginView.center.x + 5, _loginView.center.y)]];
            [_loginView.layer addAnimation:shake forKey:@"position"];
            
        });
    }

    
    NSString *requestString = [NSString stringWithFormat:@"username=%@&password=%@", userNameString, userPasswordString];
    
    NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    
    NSMutableURLRequest *URLrequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile_Validate_Login.php", kBaseURL]]];
    
    // set Request Type
    [URLrequest setHTTPMethod:@"POST"];
    
    // set Content Type
    [URLrequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    // set Request Body
    [URLrequest setHTTPBody:requestData];
    
    // send a Request and geft Response
    NSData *returnData = [NSURLConnection sendSynchronousRequest:URLrequest returningResponse:nil error:nil];
    
    // log response
    NSString *resultsString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    [resultsString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];


    NSLog(@"resultString = %@", resultsString);
    NSLog(@"done");
    

    BOOL success = YES;//[resultsString isEqualToString:@"success"];
    
    
    if (success)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activityIndicator stopAnimating];
            
            HomePageViewController *homePageVC = [[HomePageViewController alloc] init];
            [self.navigationController setNavigationBarHidden:YES animated:NO];
            [self.navigationController pushViewController:homePageVC animated:YES];
            [_loginViewCover removeFromSuperview];
        });
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activityIndicator stopAnimating];
            [_loginViewCover removeFromSuperview];
            CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
            [shake setDuration:0.1];
            [shake setRepeatCount:2];
            [shake setAutoreverses:YES];
            [shake setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake(_loginView.center.x - 5,_loginView.center.y)]];
            [shake setToValue:[NSValue valueWithCGPoint:
                               CGPointMake(_loginView.center.x + 5, _loginView.center.y)]];
            [_loginView.layer addAnimation:shake forKey:@"position"];
            
        });

    }
}

- (void)createRegistrationButton
{
    UIButton *registrationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 24)];
    [registrationButton setCenter:_loginButton.center];
    [registrationButton setCenter:CGPointMake(_loginButton.center.x, _loginButton.center.y + 100)];
    [registrationButton setTitle:@"Create an account" forState:UIControlStateNormal];
    [[registrationButton titleLabel] setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:20]];
    [registrationButton setTitleColor:[UIColor colorWithRed:0.196 green:0.729 blue:0.812 alpha:1.0] forState:UIControlStateNormal];
    [registrationButton addTarget:self action:@selector(goToRegistrationPage) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:registrationButton];
}

- (void)createForgotPasswordButton
{
    UIButton *forgotPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(190, 365, 200, 24)];
    [forgotPasswordButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
    [[forgotPasswordButton titleLabel] setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:20]];
    [forgotPasswordButton setTitleColor: [UIColor colorWithRed:0.196 green:0.729 blue:0.812 alpha:1.0] forState:UIControlStateNormal];
    
    [forgotPasswordButton addTarget:self action:@selector(goToForgotPasswordPage) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:forgotPasswordButton];
}

- (void)goToRegistrationPage
{
    RegistrationViewController *viewController = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil];
    [viewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

- (void)goToForgotPasswordPage
{
    ForgotPasswordViewController *viewController = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [viewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end