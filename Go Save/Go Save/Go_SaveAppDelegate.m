//
//  Go_SaveAppDelegate.m
//  Go Save
//
//  Created by KRS on 8/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Go_SaveAppDelegate.h"

@implementation Go_SaveAppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;

+ (Go_SaveAppDelegate *)sharedAppDelegate
{
    return (Go_SaveAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    [self loadData];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (void) openDB 
{
    if (database == NULL) {
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"GoSave.sqlite"];
		
        if ([fileManager fileExistsAtPath:writableDBPath] == NO) {
            NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:@"GoSave" ofType:@"sqlite"];
            success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
            if (!success) {
                NSCAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            }
        }
        
        if (sqlite3_open([writableDBPath UTF8String], &database) != SQLITE_OK) {
            sqlite3_close(database);
            database = NULL;
            NSCAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        }
	}
}

- (void) closeDB
{
    if (database == NULL) 
		return;
    
    if (sqlite3_close(database) != SQLITE_OK) 
	{
        NSCAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
    database = NULL;
}

- (void) loadData
{
    [self openDB];
}

- (void)        editFillData:(int)nKey carNo:(int)carNo date:(int)nDate odometer:(double)nOdometer daysWorked:(int)nDaysWorked perGallon:(double)nPerGallon gallons:(double)nGallons
{
	if(database == nil)
		return;
	
	NSString *sql;
	sqlite3_stmt *statement;

	sql = [NSString stringWithFormat:@"update FillUp SET CarNo='%d', no='%d', Date='%d', Odometer='%f', DaysWorked='%d', PerGallon='%f', Gallons='%f' WHERE no='%d'", nSelectedCar, nKey, nDate, nOdometer, nDaysWorked, nPerGallon, nGallons, nKey];    	
    
	NSLog(@"%@", sql);
	if(sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)    
	{ 
	} 
	if(sqlite3_step(statement) != SQLITE_DONE ) 
	{ 
		NSLog( @"Error: %s", sqlite3_errmsg(database) ); 
	}
	else 
	{ 
		NSLog( @"Update into row id = %lld", sqlite3_last_insert_rowid(database)); 
	} 
	sqlite3_finalize(statement); 
}

- (void)        addFillData:(int)carNo date:(int)nDate odometer:(double)nOdometer daysWorked:(int)nDaysWorked perGallon:(double)nPerGallon gallons:(double)nGallons
{
	if(database == nil)
		return;
	
	int nKey = 0;
	NSString *sql = [NSString stringWithFormat:@"SELECT MAX(no) FROM FillUp"];

	sqlite3_stmt *statement;
	if (sqlite3_prepare(database,[sql UTF8String],-1,&statement,NULL) == SQLITE_OK)
	{
		if (sqlite3_step(statement) == SQLITE_ROW) 
		{		
			nKey = sqlite3_column_int(statement,0);
		}
	}
	sqlite3_finalize(statement);
	nKey++;
    
	sql = [NSString stringWithFormat:@"insert into FillUp (CarNo,no, Date, Odometer, DaysWorked, PerGallon, Gallons) VALUES(%d,%d,%d,%f,%d,%f,%f)", nSelectedCar, nKey, nDate, nOdometer, nDaysWorked, nPerGallon, nGallons];    	
    
	NSLog(@"%@", sql);
	if(sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)    
	{ 
	} 
	if(sqlite3_step(statement) != SQLITE_DONE ) 
	{ 
		NSLog( @"Error: %s", sqlite3_errmsg(database) ); 
	}
	else 
	{ 
		NSLog( @"Insert into row id = %lld", sqlite3_last_insert_rowid(database)); 
	} 
	sqlite3_finalize(statement); 
}

- (void)        removeFillData:(int)nKey
{
	if(database == nil)
		return;
	
	NSString *sql = [NSString stringWithFormat:@"SELECT MAX(no) FROM FillUp"];
	sqlite3_stmt *statement;
    
	sql = [NSString stringWithFormat:@"delete from FillUp where no = %d", nKey];    	
    
	NSLog(@"%@", sql);
	if(sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)    
	{ 
	} 
	if(sqlite3_step(statement) != SQLITE_DONE ) 
	{ 
		NSLog( @"Error: %s", sqlite3_errmsg(database) ); 
	}
	else 
	{ 
	} 
	sqlite3_finalize(statement); 
}

- (NSArray *)readFillData:(int)nCarNo {
	NSString *sql = [NSString stringWithFormat:@"select * from FillUp WHERE CarNo='%d'", nCarNo];

	sqlite3_stmt *statement;
	id result;
    
	NSMutableArray* dataArray = [[NSMutableArray arrayWithCapacity:0] retain];
	if (sqlite3_prepare(database,[sql UTF8String],-1,&statement,NULL) == SQLITE_OK)
	{
		while (sqlite3_step(statement) == SQLITE_ROW) {	
			NSMutableDictionary *thisDict = [NSMutableDictionary dictionaryWithCapacity:4];
			for (int i = 0 ; i < sqlite3_column_count(statement) ; i++) {
				if (sqlite3_column_decltype(statement,i) != NULL &&
					strcasecmp(sqlite3_column_decltype(statement,i),"Boolean") == 0) {
					result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement, i) == SQLITE_TEXT) {
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
					result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
					result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];					
				} else {
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
				}
				if (result) {
					[thisDict setObject:result
								 forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
				}
			}
			[dataArray addObject:[NSDictionary dictionaryWithDictionary:thisDict]];
		}
        
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
    
	return dataArray;
}

- (void)        deleteCar:(int)nCarNo
{
	if(database == nil)
		return;
	
	NSString *sql;
    
	sqlite3_stmt *statement;
    
	sql = [NSString stringWithFormat:@"delete from FillUp where CarNo = %d", nCarNo];    	
    
	NSLog(@"%@", sql);
	if(sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)    
	{ 
	} 
	if(sqlite3_step(statement) != SQLITE_DONE ) 
	{ 
		NSLog( @"Error: %s", sqlite3_errmsg(database) ); 
	}
	else 
	{ 
		NSLog( @"Insert into row id = %lld", sqlite3_last_insert_rowid(database)); 
	} 
	sqlite3_finalize(statement); 
}

- (void)        setSelectedCar:(int)nCarNo
{
    nSelectedCar = nCarNo;
}

- (int)         getSelectedCar
{
    return nSelectedCar;
}

+ (NSString*)realText:(NSString*)strOrg
{
    NSString*   strDest = strOrg;
    
    while (1) {
        NSRange    range = [strDest rangeOfString:@"."];
        if(range.length == 0)
            break;
        
        if([[strDest substringFromIndex:[strDest length]-1] isEqualToString:@"."])
        {
            strDest = [strDest substringToIndex:[strDest length]-1];
            break;
        }
        else if([[strDest substringFromIndex:[strDest length]-1] isEqualToString:@"0"])
        {
            strDest = [strDest substringToIndex:[strDest length]-1];
        }
        else
            break;
    }
    
    return strDest;
}

+ (NSString*)realTextDecimal:(NSString*)strOrg nPlaces:(int)nDecimalPlaces
{
    if([strOrg isEqualToString:@""])
        return strOrg;
    
    if(nDecimalPlaces == 0)
    {
        double d = [strOrg doubleValue];
        int n = round(d);
        return [NSString stringWithFormat:@"%i", n];
    }
    NSString*   strDest = strOrg;
    
    while (1) {
        NSRange    range = [strDest rangeOfString:@"."];
        if(range.length == 0)
            break;
        
        if([[strDest substringFromIndex:[strDest length]-1] isEqualToString:@"."])
        {
            if(nDecimalPlaces == 0)
                strDest = [strDest substringToIndex:[strDest length]-1];
            break;
        }
        else if([[strDest substringFromIndex:[strDest length]-1] isEqualToString:@"0"])
        {
            if(nDecimalPlaces == 0)
                strDest = [strDest substringToIndex:[strDest length]-1];
            else
                break;
        }
        else
            break;
    }

    NSRange    range = [strDest rangeOfString:@"."];
    if(range.length != 0)
    {
        int nDecimal = [strDest length] - range.location - 1;
        int nDelCount = nDecimal - nDecimalPlaces;
        
        if(nDelCount > 0)
            strDest = [strDest substringToIndex:[strDest length]-nDelCount];
    }

    if([[strDest substringFromIndex:[strDest length]-1] isEqualToString:@"."])
    {
        if(nDecimalPlaces == 0)
            strDest = [strDest substringToIndex:[strDest length]-1];
    }

    return strDest;
}

@end
