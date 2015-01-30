//
//  RegistrationViewController.h
//  Venti
//
//  Created by Personal on 11/29/14.
//
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
{
    
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *lastNameTextField;
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *email;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *passwordConfirmedTextField;
    IBOutlet UITextField *mobileNumberTextField;
    IBOutlet UITextField *wirelessProviderTextField;
    
    IBOutlet UIPickerView *wirelessProviderPickerView;
}
- (IBAction)cancel:(id)sender;
- (IBAction)createUser:(id)sender;


@end
