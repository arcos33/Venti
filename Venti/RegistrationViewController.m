//
//  RegistrationViewController.m
//  Venti
//
//  Created by Personal on 11/29/14.
//
//

#import "RegistrationViewController.h"
#import "HomePageViewController.h"

@interface RegistrationViewController ()
@property (nonatomic, assign) BOOL firstNameIsEmpty;
@property (nonatomic, assign) BOOL lastNameIsEmpty;
@property (nonatomic, assign) BOOL usernameIsEmpty;
@property (nonatomic, assign) BOOL emailIsEmpty;
@property (nonatomic, assign) BOOL passwordIsEmpty;
@property (nonatomic, assign) BOOL confirmedPasswordIsEmpty;
@property (nonatomic, assign) BOOL mobilePhoneIsEmpty;
@property (nonatomic, assign) BOOL wirelessProviderIsEmpty;

@end

@implementation RegistrationViewController
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [firstNameTextField setDelegate:self];
    [firstNameTextField setTintColor:[UIColor blackColor]];
    [lastNameTextField setDelegate:self];
    [lastNameTextField setTintColor:[UIColor blackColor]];
    [usernameTextField setDelegate:self];
    [usernameTextField setTintColor:[UIColor blackColor]];
    [email setDelegate:self];
    [email setTintColor:[UIColor blackColor]];
    [passwordTextField setDelegate:self];
    [passwordTextField setTintColor:[UIColor blackColor]];
    [passwordConfirmedTextField setDelegate:self];
    [passwordConfirmedTextField setTintColor:[UIColor blackColor]];
    [mobileNumberTextField setDelegate:self];
    [mobileNumberTextField setTintColor:[UIColor blackColor]];
    [wirelessProviderTextField setDelegate:self];
    [wirelessProviderTextField setTintColor:[UIColor blackColor]];
    
    _firstNameIsEmpty = YES;
    _lastNameIsEmpty = YES;
    _usernameIsEmpty = YES;
    _emailIsEmpty = YES;
    _passwordIsEmpty = YES;
    _confirmedPasswordIsEmpty = YES;
    _mobilePhoneIsEmpty = YES;
    _wirelessProviderIsEmpty = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendToServer
{
    NSString *requestString = [NSString stringWithFormat:@"first_name=%@&last_name=%@&username=%@&email=%@&password=%@&confirmed_password=%@&mobile_number=%@&wireless_provider=%@",firstNameTextField.text, lastNameTextField.text, usernameTextField.text, email.text, passwordTextField.text, passwordConfirmedTextField.text, mobileNumberTextField.text, wirelessProviderTextField.text];
    
    NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile_Register_User.php", kBaseURL]]];
    
    // set Request Type
    [URLRequest setHTTPMethod:@"POST"];
    
    // set Content Type
    [URLRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    // set Request Body
    [URLRequest setHTTPBody:requestData];
    
    // send a Request and get Response
    NSData *returnData = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:nil error:nil];
    
    // log response
    NSString *resultsString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"\n\nrequestString: %@\nURLRequest = %@\nresultString: %@", requestString, URLRequest, resultsString);
    NSLog(@"done");
    
    if ([resultsString isEqualToString:@"successfully created user"])
    {
        [self successAlert];
    }

}

- (void)successAlert
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil
                                                   message:@"Registration Successful"
                                                  delegate:nil
                                         cancelButtonTitle:@"Login"
                                         otherButtonTitles:nil, nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == firstNameTextField)
    {
        firstNameTextField.text = @"";
    }
    else if (textField == lastNameTextField)
    {
        if ([firstNameTextField.text isEqualToString:@""])
        {
            [firstNameTextField setText:@"First name cannot be empty"];
            [firstNameTextField setTextColor:[UIColor redColor]];
            firstNameTextField.font = [UIFont systemFontOfSize:10];
        }
        lastNameTextField.text = @"";
    }
    else if (textField == usernameTextField)
    {
        if ([lastNameTextField.text isEqualToString:@""])
        {
            [lastNameTextField setText:@"Last name cannot be empty"];
            [lastNameTextField setTextColor:[UIColor redColor]];
            lastNameTextField.font = [UIFont systemFontOfSize:10];
        }
        
    }
    else if (textField == email)
    {
        if ([usernameTextField.text isEqualToString:@""])
        {
            [usernameTextField setText:@"Username cannot be empty"];
            [usernameTextField setTextColor:[UIColor redColor]];
            usernameTextField.font = [UIFont systemFontOfSize:10];
        }
        
    }
    
    else if (textField == passwordTextField)
    {
        if ([email.text isEqualToString:@""])
        {
            [email setText:@"Email cannot be empty"];
            [email setTextColor:[UIColor redColor]];
            email.font = [UIFont systemFontOfSize:10];
        }
        [passwordTextField becomeFirstResponder];
    }else if (textField == passwordConfirmedTextField)
    {
        if ([passwordTextField.text isEqualToString:@""])
        {
            [passwordTextField setText:@"Password field name cannot be empty"];
            [passwordTextField setTextColor:[UIColor redColor]];
            passwordTextField.font = [UIFont systemFontOfSize:10];
        }
        [passwordConfirmedTextField becomeFirstResponder];
    }else if (textField == mobileNumberTextField)
    {
        if ([passwordConfirmedTextField.text isEqualToString:@""])
        {
            [passwordConfirmedTextField setText:@"Password field cannot be empty"];
            [passwordConfirmedTextField setTextColor:[UIColor redColor]];
            passwordConfirmedTextField.font = [UIFont systemFontOfSize:10];
        }else if (passwordTextField.text != passwordTextField.text)
        [mobileNumberTextField becomeFirstResponder];
    }else if (textField == wirelessProviderTextField)
    {
        if ([mobileNumberTextField.text isEqualToString:@""])
        {
            [mobileNumberTextField setText:@"Mobile # field cannot be empty"];
            [mobileNumberTextField setTextColor:[UIColor redColor]];
            mobileNumberTextField.font = [UIFont systemFontOfSize:10];
        }
        [wirelessProviderTextField becomeFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == email)
    {
        if ([email.text isEqualToString:@""])
        {
            [email setText:@"Username cannot be empty"];
            [email setTextColor:[UIColor redColor]];
            usernameTextField.font = [UIFont systemFontOfSize:10];
        }
        else
        {
            BOOL emailIsValid = NO;
            emailIsValid = [self NSStringIsValidEmail:email.text];
            if (emailIsValid)
            {
                //don't do anything
            }
            else
            {
                [email setText:@"Please provide a valid email address"];
            }
        }

    }
    if (textField == passwordTextField)
    {
        if (![passwordTextField.text isEqualToString:@""])
        {
            [self validatePassword:passwordTextField];
        }
    }
    if (textField == passwordConfirmedTextField)
    {
        if (![passwordConfirmedTextField.text isEqualToString:@""])
        {
            if (![passwordTextField.text isEqualToString:passwordConfirmedTextField.text]) {
                UIAlertView *passwordMismatch = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                           message:@"Password mismatch"
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"Ok"
                                                                 otherButtonTitles:nil];
                [passwordMismatch show];
            }
        }
    }
    if (textField == mobileNumberTextField)
    {
        NSString *newString = [[mobileNumberTextField.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSString *phoneNumber = newString;
        NSString *phoneRegex = @"[235689][0-9]{6}([0-9]{3})?";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        BOOL mobileNumberIsValid = [test evaluateWithObject:phoneNumber];

        if (!mobileNumberIsValid) {
            UIAlertView *invalidMobileNumber = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                          message:@"Phone number must be 10 digits" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [invalidMobileNumber show];
        }

    }
}

- (NSString*)formatPhoneNumber:(NSString*)simpleNumber deleteLastChar:(BOOL)deleteLastChar
{
    if(simpleNumber.length==0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    // check if the number is too long
    if(simpleNumber.length>10) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    if(deleteLastChar) {
        // should we delete the last digit?
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    // 123 456 7890
    // format the number.. if it's less then 7 digits.. then use this regex.
    if(simpleNumber.length<7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"($1) $2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    else   // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"($1) $2-$3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    return simpleNumber;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == mobileNumberTextField)
    {
        
        NSCharacterSet *numSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789-() "];
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        int charCount = [newString length];
        if ([newString rangeOfCharacterFromSet:[numSet invertedSet]].location != NSNotFound
            || [string rangeOfString:@")"].location != NSNotFound
            || [string rangeOfString:@"("].location != NSNotFound
            || [string rangeOfString:@"-"].location != NSNotFound
            || charCount > 14) {
            return NO;
        }
        if (![string isEqualToString:@""])
        {
            if (charCount == 1)
            {
                newString = [NSString stringWithFormat:@"(%@", newString];
            }
            else if(charCount == 4)
            {
                newString = [newString stringByAppendingString:@") "];
            }
            else if(charCount == 5)
            {
                newString = [NSString stringWithFormat:@"%@) %@", [newString substringToIndex:4], [newString substringFromIndex:4]];
            }
            else if(charCount == 6)
            {
                newString = [NSString stringWithFormat:@"%@ %@", [newString substringToIndex:5], [newString substringFromIndex:5]];
            }
            
            else if (charCount == 9)
            {
                newString = [newString stringByAppendingString:@"-"];
            }
            else if(charCount == 10)
            {
                newString = [NSString stringWithFormat:@"%@-%@", [newString substringToIndex:9], [newString substringFromIndex:9]];
            }
        }
        textField.text = newString;
        return NO;
    }
    return YES;
}


-(void)validatePassword:(UITextField *)textField
{
    BOOL lowerCaseLetter = 0;
    BOOL upperCaseLetter = 0;
    BOOL digit = 0;
    
    if([textField.text length] >= 8)
    {
        for (int i = 0; i < [textField.text length]; i++)
        {
            unichar c = [textField.text characterAtIndex:i];
            if(!lowerCaseLetter)
            {
                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!upperCaseLetter)
            {
                upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!digit)
            {
                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
        }
        
        if(digit && lowerCaseLetter && upperCaseLetter)
        {
            //do what u want
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please Ensure that you have at least:\n one lower case letter\none upper case letter\none digit"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Password must contain at least 8 characters"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createUser:(id)sender {
    [self sendToServer];
}
@end
