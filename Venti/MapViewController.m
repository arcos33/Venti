//
//  MapViewController.m
//  Venti
//
//  Created by Personal on 1/24/15.
//
//

#import "MapViewController.h"

@interface MapViewController ()
@property (nonatomic) UIView *eventWindow;
@property (nonatomic) UIView *noteView;
@property (nonatomic) UIView *pinView;
@property (nonatomic) UIButton *mapButton;
@property (nonatomic) NSMutableArray *mapButtonArray;
@property (nonatomic) CLLocationCoordinate2D longPressCoordinate;
@property (nonatomic) CGRect centerCoordinate;
@property (nonatomic) GMSMarker *knockEventMarker;
@property (nonatomic) GMSMarker *mainMarker;
@property (nonatomic) Knock_Event *knock_event;
@property (nonatomic) NSString *knock_address;
@property (nonatomic) NSString *knock_city;
@property (nonatomic) NSString *knock_state;
@property (nonatomic) NSString *knock_zip;
@property (nonatomic) NSDate *knock_time_stamp;
@property (nonatomic) NSNumber *knock_sales_rep_id;


@end
//_knock_event.address = [myGeocoder valueForKey:@"thoroughfare"];
//_knock_event.city = [myGeocoder valueForKey:@"locality"];
//_knock_event.state = [myGeocoder valueForKey:@"administrativeArea"];
//_knock_event.zip = [myGeocoder valueForKey:@"postalCode"];
//_knock_event.time_stamp = [NSDate date];
//_knock_event.sales_rep_id = [NSNumber numberWithInt:1];
@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createMap
{
    // Create a GMSCameraPosition that tells the map to display the
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithLatitude:40.480898
                                                                    longitude:-111.886804
                                                                         zoom:18];
  
    [mainMap setCamera:cameraPosition];
    [mainMap setMyLocationEnabled:YES];
    mainMap.myLocationEnabled = YES;
    [[mainMap settings] setMyLocationButton:YES];
    
    // Create a marker in the center of the map
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Home";
    marker.snippet = @"Yey";
    marker.map = mainMap;
    
}

- (void)createKnockEventMarker
{
    GMSMarker *newMarker = [GMSMarker markerWithPosition:mainMap.myLocation.coordinate];
    newMarker.title = @"Knock Event";
    newMarker.icon = [UIImage imageNamed:@"knock_icon_blue"];
    newMarker.map = mainMap;
}

- (void)createNoThanksEventMarker
{
    GMSMarker *newMarker = [GMSMarker markerWithPosition:mainMap.myLocation.coordinate];
    newMarker.title = @"No Thanks Event";
    newMarker.icon = [UIImage imageNamed:@"no_thanks_small"];
    newMarker.map = mainMap;
}

- (void)insertKnockEvent
{
    _knockEventMarker = [GMSMarker markerWithPosition:_longPressCoordinate];
    [_knockEventMarker setInfoWindowAnchor:CGPointMake(0.5, 0.5)];
    
    _pinView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 60)];
    [_pinView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"knock_icon_blue"]]];
    [_mainMarker setIcon:[self imageWithView:_pinView]];
    [_mainMarker setMap:mainMap];
    
    //[mapViewOverlay removeFromSuperview];
    [_eventWindow removeFromSuperview];
}

- (void)performCancel
{
    [_eventWindow removeFromSuperview];
    //[mapViewOverlay removeFromSuperview];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    CGPoint pinCoordinates = [mapView.projection pointForCoordinate:coordinate];
    int xOffset = 160;
    int yOffset = 180;
    int round_button_width_height = 60;
    
    _eventWindow = [[UIView alloc] initWithFrame:CGRectMake(pinCoordinates.x - xOffset, pinCoordinates.y - yOffset, 300, 300)];
    //[_eventWindow setBackgroundColor:[UIColor colorWithRed:.1f green:.1f blue:.1f alpha:0.25f]];
    
    UIView *circularView = [[UIView alloc] initWithFrame:CGRectMake(_eventWindow.bounds.size.width / 2 - 150, _eventWindow.bounds.size.height /2 - 150, 300, 300)];
    //[circularView setBackgroundColor:[UIColor colorWithRed:.01f green:.01f blue:.01f alpha:0.50f]];
    [circularView.layer setCornerRadius:75];
    [circularView setClipsToBounds:YES];
    
    UIButton *referenceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [referenceButton setImage:[UIImage imageNamed:@"no_knock_event_with_background"] forState:UIControlStateNormal];
    //[button addTarget:self action:@selector(roundButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    referenceButton.frame = CGRectMake(20, _eventWindow.frame.size.height / 2 - 25, round_button_width_height, round_button_width_height);
    referenceButton.clipsToBounds = YES;
    referenceButton.layer.cornerRadius = round_button_width_height/2.0f;
    
    [mapView addSubview:_eventWindow];
    [_eventWindow addSubview:circularView];
    
    _mapButtonArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *buttonImages = [[NSMutableArray alloc] init];
    [buttonImages addObject:@"knock_event_with_background"];
    [buttonImages addObject:@"no_knock_event_with_background"];
    [buttonImages addObject:@"return_with_background"];
    [buttonImages addObject:@"note_with_background"];
    [buttonImages addObject:@"prospect_small"];
    [buttonImages addObject:@"cancel_image"];
    [buttonImages addObject:@""];
    [buttonImages addObject:@""];
    [buttonImages addObject:@""];
    [buttonImages addObject:@""];
    [buttonImages addObject:@"done_image"];
    
    
    float containerRadius = circularView.bounds.size.width / 2 - referenceButton.bounds.size.width/2;
    float startingPositon = 3.40339204; //15 degrees in Radians
    float radians = 0.523598776; //30 degrees in Radians- space between items
    float originalRadians = radians;
    for (int i = 0; i < 11; i++)
    {
        int x = ((circularView.bounds.size.width/2) + (containerRadius * cos(startingPositon))) - (referenceButton.bounds.size.width/2);
        int y = ((circularView.bounds.size.height/2) + (containerRadius * sin(startingPositon))) - (referenceButton.bounds.size.height/2);
        startingPositon += originalRadians;
        
        UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [mapButton setTag:i];
        mapButton.frame = CGRectMake(x, y, round_button_width_height, round_button_width_height);
        mapButton.clipsToBounds = YES;
        mapButton.layer.cornerRadius = round_button_width_height/2.0f;
        [_mapButtonArray addObject:mapButton];
        //[circularView addSubview:_mapButton];
    }
    [mapView addSubview:_eventWindow];
    _mapButton = [[UIButton alloc] init];
    for (_mapButton in _mapButtonArray)
    {
        if (_mapButton.tag == knockEvent)
        {
            [_mapButton setImage:[UIImage imageNamed:@"knock_event_with_background"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(performKnockEvent) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
            
        }else if (_mapButton.tag == noThanksEvent)
        {
            [_mapButton setImage:[UIImage imageNamed:@"no_knock_event_with_background"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(performDontKnockEvent) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
            
        }else if (_mapButton.tag == returnEvent)
        {
            [_mapButton setImage:[UIImage imageNamed:@"return_with_background"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(performReturnEvent) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
            
        }else if (_mapButton.tag == note)
        {
            [_mapButton setImage:[UIImage imageNamed:@"note_with_background"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(performNote) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
        }
        else if (_mapButton.tag == newProspect)
        {
            [_mapButton setImage:[UIImage imageNamed:@"prospect_small"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(performNP) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
        }else if (_mapButton.tag == cancel)
        {
            [_mapButton setImage:[UIImage imageNamed:@"cancel_image"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(performCancel) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
        }
        else if (_mapButton.tag == done)
        {
            [_mapButton setImage:[UIImage imageNamed:@"done_image"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(saveNote) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
            [_mapButton setHidden:YES];
        }
    }
}

- (void)addmapOverlay
{
    //[mainMap addSubview:mapViewOverlay];
    
}


- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self addmapOverlay];
    //CGPoint myPoint = [mapView coor];
    
    CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
    NSManagedObjectContext *context = [coreDataManager managedObjectContext];
    
    _knock_event = [NSEntityDescription insertNewObjectForEntityForName:@"Knock_Event" inManagedObjectContext:context];
    
    
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error){
        
        NSArray *otherArray = [response results];
        GMSGeocoder *myGeocoder = otherArray[0];
        _knock_address = [myGeocoder valueForKey:@"thoroughfare"];
        _knock_city = [myGeocoder valueForKey:@"locality"];
        _knock_state = [myGeocoder valueForKey:@"administrativeArea"];
        _knock_zip = [myGeocoder valueForKey:@"postalCode"];
        _knock_time_stamp = [NSDate date];
        _knock_sales_rep_id = [NSNumber numberWithInt:1];
    }];
    
    NSString *requestString = [NSString stringWithFormat:@"address=%@&city=%@&state=%@&zip=%@&time_stamp=%@&sales_rep_id=%@", _knock_address, _knock_city, _knock_state, _knock_zip, _knock_time_stamp, _knock_sales_rep_id];
    
    NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile_Insert_Knocked_Event.php", kBaseURL]]];
    
    // set Request Type
    [request setHTTPMethod:@"POST"];
    
    // set Content Type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    // set Request Body
    [request setHTTPBody:requestData];
    
    // send a Request and get Response
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // log response
    NSString *resultsString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"resultString = %@", resultsString);
    
    _mainMarker = [GMSMarker markerWithPosition:coordinate];
    _mainMarker.infoWindowAnchor = CGPointMake(0.5, 0.5);
    
    _pinView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
    [_pinView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"chat"]]];
    _mainMarker.icon = [self imageWithView:_pinView];
    _mainMarker.map = mainMap;
    
    int round_button_width_height = 60;
    
    _eventWindow = [[UIView alloc] initWithFrame:CGRectMake(180, 300, 300, 300)];
    NSLog(@"%@", NSStringFromCGPoint(mapView.center));
    
    
    UIView *circularView = [[UIView alloc] initWithFrame:CGRectMake(_eventWindow.bounds.size.width / 2 - 150, _eventWindow.bounds.size.height /2 - 150, 300, 300)];
    
    [circularView.layer setCornerRadius:75];
    [circularView setClipsToBounds:YES];
    
    UIButton *referenceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [referenceButton setImage:[UIImage imageNamed:@"no_knock_event_with_background"] forState:UIControlStateNormal];
    //[button addTarget:self action:@selector(roundButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    referenceButton.frame = CGRectMake(20, _eventWindow.frame.size.height / 2 - 25, round_button_width_height, round_button_width_height);
    referenceButton.clipsToBounds = YES;
    referenceButton.layer.cornerRadius = round_button_width_height/2.0f;
    
    [mapView addSubview:_eventWindow];
    [_eventWindow addSubview:circularView];
    
    _mapButtonArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *buttonImages = [[NSMutableArray alloc] init];
    [buttonImages addObject:@"knock_event_with_background"];
    [buttonImages addObject:@"no_knock_event_with_background"];
    [buttonImages addObject:@"return_with_background"];
    [buttonImages addObject:@"note_with_background"];
    [buttonImages addObject:@"stl_with_background"];
    [buttonImages addObject:@"new_prospect_with_background"];
    [buttonImages addObject:@"cancel_image"];
    [buttonImages addObject:@""];
    [buttonImages addObject:@""];
    [buttonImages addObject:@""];
    [buttonImages addObject:@""];
    [buttonImages addObject:@"done_image"];
    
    
    float containerRadius = circularView.bounds.size.width / 2 - referenceButton.bounds.size.width/2;
    float startingPositon = 3.40339204; //15 degrees in Radians
    float radians = 0.523598776; //30 degrees in Radians- space between items
    float originalRadians = radians;
    for (int i = 0; i < 12; i++)
    {
        int x = ((circularView.bounds.size.width/2) + (containerRadius * cos(startingPositon))) - (referenceButton.bounds.size.width/2);
        int y = ((circularView.bounds.size.height/2) + (containerRadius * sin(startingPositon))) - (referenceButton.bounds.size.height/2);
        startingPositon += originalRadians;
        
        UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [mapButton setTag:i];
        mapButton.frame = CGRectMake(x, y, round_button_width_height, round_button_width_height);
        mapButton.clipsToBounds = YES;
        mapButton.layer.cornerRadius = round_button_width_height/2.0f;
        [_mapButtonArray addObject:mapButton];
        //[circularView addSubview:_mapButton];
    }
    [mapView addSubview:_eventWindow];
    _mapButton = [[UIButton alloc] init];
    for (_mapButton in _mapButtonArray)
    {
        if (_mapButton.tag == knockEvent)
        {
            [_mapButton setImage:[UIImage imageNamed:@"knock_icon_blue"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(insertKnockEvent) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
            
        }else if (_mapButton.tag == noThanksEvent)
        {
            [_mapButton setImage:[UIImage imageNamed:@"no_thanks_small"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(insertDontKnockEvent) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
            
        }else if (_mapButton.tag == returnEvent)
        {
            [_mapButton setImage:[UIImage imageNamed:@"follow_up_icon"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(insertComeBackEvent) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
            
        }else if (_mapButton.tag == note)
        {
            [_mapButton setImage:[UIImage imageNamed:@"services_icon"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(performNote) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
        }
        else if (_mapButton.tag == newProspect)
        {
            [_mapButton setImage:[UIImage imageNamed:@"prospect_small"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(insertNewProspect) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
        }else if (_mapButton.tag == cancel)
        {
            [_mapButton setImage:[UIImage imageNamed:@"cancel_image"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(performCancel) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
        }
        else if (_mapButton.tag == done)
        {
            [_mapButton setImage:[UIImage imageNamed:@"done_image"] forState:UIControlStateNormal];
            [_mapButton addTarget:self action:@selector(saveNote) forControlEvents:UIControlEventTouchUpInside];
            [circularView addSubview:_mapButton];
            [_mapButton setHidden:YES];
        }
        
        
    }
    
    [_eventWindow addSubview:circularView];

    
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
