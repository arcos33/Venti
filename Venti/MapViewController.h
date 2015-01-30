//
//  MapViewController.h
//  Venti
//
//  Created by Personal on 1/24/15.
//
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Knock_Event.h"
#import "CoreDataManager.h"

#define kBaseURL @"http://clean.whitecoatlabs.co"

typedef NS_ENUM(NSInteger, ButtonTags)
{
    knockEvent = 0,
    noThanksEvent = 1,
    returnEvent = 2,
    note = 3,
    newProspect = 4,
    cancel = 5,
    done = 6
};

@interface MapViewController : UIViewController <GMSMapViewDelegate>
{
    
    IBOutlet GMSMapView *mainMap;
}

@end
