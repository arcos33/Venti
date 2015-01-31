//
//  HomePageViewController.h
//  Venti
//
//  Created by Personal on 11/5/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"
#import "RadioButton.h"
#import "CustomerSnapshotViewController.h"

@interface HomePageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    IBOutlet UIView *shortcutsView;
    IBOutlet UIView *mapView;
    
}
@property (nonatomic) IBOutlet RadioButton *radioButton;
- (IBAction)newKnock:(id)sender;
- (IBAction)noThanks:(id)sender;
- (IBAction)newAppointment:(id)sender;


@end
