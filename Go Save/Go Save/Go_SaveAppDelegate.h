//
//  Go_SaveAppDelegate.h
//  Go Save
//
//  Created by KRS on 8/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Go_SaveAppDelegate : NSObject <UIApplicationDelegate> {
    int     nSelectedCar;
	sqlite3* database;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

+ (Go_SaveAppDelegate *)sharedAppDelegate;
+ (NSString*)realText:(NSString*)strOrg;
+ (NSString*)realTextDecimal:(NSString*)strOrg nPlaces:(int)nDecimalPlaces;

- (void)        deleteCar:(int)nCarNo;
- (void)        setSelectedCar:(int)nCarNo;
- (int)         getSelectedCar;

- (void)		openDB;
- (void)		closeDB;

- (void)        loadData;
- (void)        addFillData:(int)carNo date:(int)nDate odometer:(double)nOdometer daysWorked:(int)nDaysWorked perGallon:(double)nPerGallon gallons:(double)nGallons;
- (void)        editFillData:(int)nKey carNo:(int)carNo date:(int)nDate odometer:(double)nOdometer daysWorked:(int)nDaysWorked perGallon:(double)nPerGallon gallons:(double)nGallons;
- (void)        removeFillData:(int)nKey ;
- (NSArray *)   readFillData:(int)nCarNo;

@end
