//
//  HomePageViewController.m
//  Venti
//
//  Created by Personal on 11/5/14.
//
//

#import "HomePageViewController.h"
#import <math.h>
#import "Knock_Event.h"
#import "CoreDataManager.h"

@interface HomePageViewController ()

@property (nonatomic) MapViewController *mapVC;
@property (nonatomic) NSString *selectedView;
@property (nonatomic) UIButton *profilePictureButton;
@property (nonatomic) BOOL button1_IS_pressed;
@property (nonatomic) CustomerSnapshotViewController *customerSnapshotVC;
@end

@implementation HomePageViewController
//PINK- LOW [UIColor colorWithRed:0.965 green:0.690 blue:0.722 alpha:1.0];
//PINK- MEDIUM [UIColor colorWithRed:0.922 green:0.471 blue:0.643 alpha:1.0];
//PINK- HIGHT [UIColor colorWithRed:0.875 green:0.251 blue:0.498 alpha:1.0];
//REDDISH/PINK- [UIColor colorWithRed:0.808 green:0.188 blue:0.290 alpha:1.0];
//GREENISH/BLUE- [UIColor colorWithRed:0.565 green:0.780 blue:0.655 alpha:1.0];

//BLUE [UIColor colorWithRed:0.196 green:0.729 blue:0.812 alpha:1.0];
//NEW PINK [UIColor colorWithRed:0.929 green:0.255 blue:0.424 alpha:1.0];
//DARK GRAY [UIColor colorWithRed:0.290 green:0.278 blue:0.286 alpha:1.0];


- (void)viewDidLoad {
    _button1_IS_pressed = NO;
    
    //    for (DLRadioButton *radioButton in otherButtonsArray)
    //    {
    //        NSLog(@"radio button = %@", radioButton);
    //    }
    
    //setup add Map VIEW
    //-----------------------------------------------------
    _mapVC = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    [_mapVC.view setFrame:CGRectMake(0, 0, _mapVC.view.frame.size.width, _mapVC.view.frame.size.height)];
    [mapView addSubview:_mapVC.view];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.875 green:0.251 blue:0.498 alpha:1.0]];
    
    //setup Shortcuts VIEW
    //-----------------------------------------------------
    [mapView addSubview:shortcutsView];
    [shortcutsView setFrame:CGRectMake(560, 200, shortcutsView.frame.size.width, shortcutsView.frame.size.height)];
    [shortcutsView setBackgroundColor:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:.5]];
    [shortcutsView.layer setCornerRadius:10];
    
    //setup Radio Buttons
    //-----------------------------------------------------
    //[radioButton_knockEvents setCircleColor:[UIColor colorWithRed:0.290 green:0.278 blue:0.286 alpha:1.0]];
    //[radioButton setCircleRadius:12];
    //[radioButton setCircleStrokeWidth:5];
    //[radioButton_knockEvents setIndicatorColor:[UIColor greenColor]];
    
    //[radioButton_knockEvents setIndicatorColor:[UIColor colorWithRed:0.290 green:0.278 blue:0.286 alpha:1.0]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSArray *buttonArray = [[NSArray alloc] initWithArray:[_radioButton groupButtons]];
    
    
    for (RadioButton *radioButton in buttonArray)
    {
        [radioButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [radioButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        [radioButton addTarget:self action:@selector(radioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.view addSubview:radioButton];
    }
}

- (void)radioButtonValueChanged:(RadioButton *)sender
{
    if (sender.tag == 1 && sender.selected)
    {
        NSLog(@"button 1 selected");
    }
    
    else if (sender.tag == 2 && sender.selected)
    {
        NSLog(@"button 2 selected");
    }
    
    else if (sender.tag == 3 && sender.selected)
    {
        NSLog(@"button 3 selected");
    }
    
    

}

- (void)logOut
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)toKnockingMode
{
    [[self view] setBackgroundColor:[UIColor colorWithRed:0.290 green:0.278 blue:0.286 alpha:1.0]];
}

- (void)toProducstMode
{
    [[self view] setBackgroundColor:[UIColor colorWithRed:0.196 green:0.729 blue:0.812 alpha:1.0]];
}

- (void)toVideosMode
{
    [[self view] setBackgroundColor:[UIColor colorWithRed:0.929 green:0.255 blue:0.424 alpha:1.0]];
}

-(IBAction)takePhoto :(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    // image picker needs a delegate,
    [imagePickerController setDelegate:self];
    
    // Place image picker on the screen
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(IBAction)chooseFromLibrary:(id)sender
{
    
    UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    // image picker needs a delegate so we can respond to its messages
    [imagePickerController setDelegate:self];
    
    // Place image picker on the screen
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

//delegate methode will be called after picking photo either from camera or library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [_profilePictureButton setImage:image forState:UIControlStateNormal];
}


- (IBAction)newKnock:(id)sender {
}

- (IBAction)noThanks:(id)sender {
}

- (IBAction)newAppointment:(id)sender
{
    _customerSnapshotVC = [[CustomerSnapshotViewController alloc] initWithNibName:@"CustomerSnapshotViewController" bundle:nil];
    [mapView addSubview:_customerSnapshotVC.view];
}
@end
