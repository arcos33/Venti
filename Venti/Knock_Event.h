//
//  Knock_Event.h
//  Venti
//
//  Created by Personal on 11/26/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Knock_Event : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * time_stamp;
@property (nonatomic, retain) NSNumber * sales_rep_id;

@end
