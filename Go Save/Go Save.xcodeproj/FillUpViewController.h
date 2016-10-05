//
//  FillUpViewController.h
//  Go Save
//
//  Created by KRS on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FillUpViewController : UIViewController<UITextFieldDelegate> {
    UITextField*    myTextField1;
    UITextField*    myTextField2;
    UITextField*    myTextField3;
    UITextField*    myTextField4;

    NSArray*            myArray;
    int                 nCurIndx;
    int                 nCurDate;
    double              nCurOdometer;
    int                 nCurDaysWorked;
    double              nCurPerGallon;
    double              nCurGallons;
    int                 nCurKey;
    
    BOOL            isNewData;
}

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UILabel *labelCaption;
@property (nonatomic, retain) IBOutlet UILabel *labelSince;

- (void)addTextField;
- (IBAction)textFieldFinished:(id)sender;
- (IBAction)done:(id)sender;

- (void)refresh;
- (void)setData:(int)nFillIndx ary:(NSArray*)ary date:(int)nDate odometer:(double)nOdometer daysWorked:(int)nDaysWorked perGallon:(double)nPerGallon gallons:(double)nGallons key:(int)nKey isNew:(BOOL)isNew;
- (void)checkDecimal;

@end
