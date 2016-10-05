//
//  FillUpViewController.m
//  Go Save
//
//  Created by KRS on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Go_SaveAppDelegate.h"
#import "FillUpViewController.h"


@implementation FillUpViewController
@synthesize datePicker, labelCaption, labelSince;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [datePicker release];
    [labelCaption release];
    [labelSince release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self addTextField];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refresh];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) addTextField {
    myTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(33, 105, 100, 39)];
    
    myTextField1.tag = 0;
    [myTextField1 setTextAlignment:UITextAlignmentCenter];
    [myTextField1 setDelegate:self];    
    myTextField1.keyboardType = UIKeyboardTypeDecimalPad;
    [myTextField1 setReturnKeyType:UIReturnKeyDone];
    [myTextField1 addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:myTextField1];
    
    myTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(177, 105, 100, 39)];
    
    myTextField2.tag = 1;
    [myTextField2 setTextAlignment:UITextAlignmentCenter];
    [myTextField2 setDelegate:self];    
    myTextField2.keyboardType = UIKeyboardTypeDecimalPad;
    [myTextField2 setReturnKeyType:UIReturnKeyDone];
    [myTextField2 addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:myTextField2];

    myTextField3 = [[UITextField alloc] initWithFrame:CGRectMake(33, 198, 100, 39)];
    
    myTextField3.tag = 2;
    [myTextField3 setTextAlignment:UITextAlignmentCenter];
    [myTextField3 setDelegate:self];    
    myTextField3.keyboardType = UIKeyboardTypeDecimalPad;
    [myTextField3 setReturnKeyType:UIReturnKeyDone];
    [myTextField3 addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:myTextField3];

    myTextField4 = [[UITextField alloc] initWithFrame:CGRectMake(177, 198, 100, 39)];
    
    myTextField4.tag = 3;
    [myTextField4 setTextAlignment:UITextAlignmentCenter];
    [myTextField4 setDelegate:self];    
    myTextField4.keyboardType = UIKeyboardTypeDecimalPad;
    [myTextField4 setReturnKeyType:UIReturnKeyDone];
    [myTextField4 addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:myTextField4];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [myTextField1 resignFirstResponder];
    [myTextField2 resignFirstResponder];
    [myTextField3 resignFirstResponder];
    [myTextField4 resignFirstResponder];
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder]; 
}

- (IBAction)done:(id)sender
{
	Go_SaveAppDelegate *app = [Go_SaveAppDelegate sharedAppDelegate];
    
    int         nDate = [[datePicker date] timeIntervalSince1970];
    double      nOdometer = [myTextField1.text doubleValue];
    double      nDaysWorked = [myTextField2.text intValue];
    double      nPerGallon = [myTextField3.text doubleValue];
    double      nGallons = [myTextField4.text doubleValue];
    
    if(isNewData)
        [app addFillData:[app getSelectedCar] date:nDate odometer:nOdometer daysWorked:nDaysWorked perGallon:nPerGallon gallons:nGallons];
    else
        [app editFillData:nCurKey carNo:[app getSelectedCar] date:nDate odometer:nOdometer daysWorked:nDaysWorked perGallon:nPerGallon gallons:nGallons];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setData:(int)nFillIndx ary:(NSArray*)ary date:(int)nDate odometer:(double)nOdometer daysWorked:(int)nDaysWorked perGallon:(double)nPerGallon gallons:(double)nGallons key:(int)nKey isNew:(BOOL)isNew
{
    myArray = ary;
    nCurIndx = nFillIndx;
    nCurDate = nDate;
    nCurOdometer = nOdometer;
    nCurDaysWorked = nDaysWorked;
    nCurPerGallon = nPerGallon;
    nCurGallons = nGallons;
    nCurKey = nKey;
    isNewData = isNew;
}

- (void)refresh {
    if(nCurDate != -1)
    {
        NSDate* date = [NSDate dateWithTimeIntervalSince1970: nCurDate];
        [datePicker setDate:date];
    }
    else
        [datePicker setDate:[NSDate date]];
    
    if(nCurOdometer == -1)
        [myTextField1 setText:@""];
    else
        [myTextField1 setText:[Go_SaveAppDelegate realTextDecimal:[NSString stringWithFormat:@"%f", nCurOdometer] nPlaces:1]];
        
    if(nCurDaysWorked == -1)
        [myTextField2 setText:@""];
    else
        [myTextField2 setText:[Go_SaveAppDelegate realTextDecimal: [NSString stringWithFormat:@"%i", nCurDaysWorked] nPlaces:0]];

    if(nCurPerGallon == -1)
        [myTextField3 setText:@""];
    else
        [myTextField3 setText:[Go_SaveAppDelegate realTextDecimal: [NSString stringWithFormat:@"%f", nCurPerGallon] nPlaces:3]];

    if(nCurGallons == -1)
        [myTextField4 setText:@""];
    else
        [myTextField4 setText:[Go_SaveAppDelegate realTextDecimal: [NSString stringWithFormat:@"%f", nCurGallons] nPlaces: 3]];
    
    [labelCaption setText:[NSString stringWithFormat:@"Fill-Up #%d", nCurIndx+1]];
    
    if(nCurIndx == 0)
    {
        [myTextField2 setEnabled:NO];
        [myTextField2 setText:@"Next Time"];
//        [myTextField3 setEnabled:NO];
//        [myTextField3 setText:@"Next Time"];
        [myTextField4 setEnabled:NO];
        [myTextField4 setText:@"Next Time"];
    }
    else
    {
        [myTextField2 setEnabled:YES];
//        [myTextField3 setEnabled:YES];
        [myTextField4 setEnabled:YES];
    }
    
    if(nCurIndx > 0)
    {
        NSDictionary*   dict = [myArray objectAtIndex:nCurIndx-1];
        NSNumber*       minDate = [dict objectForKey:@"Date"];
        
        NSDate*         date = [NSDate dateWithTimeIntervalSince1970: [minDate intValue]+24*60*60];
        [datePicker setMinimumDate:date];
        date = [NSDate dateWithTimeIntervalSince1970: [minDate intValue]];

        NSLocale *uslocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]; 
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init]; 
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;     
        NSDateComponents *components = [calendar components:units fromDate:date];
        
        NSArray* weekArray = [dateFormatter shortWeekdaySymbols];
        NSArray* monthArray = [dateFormatter shortMonthSymbols];
        
        int nWeekDay = [components weekday];
        int nMonth = [components month];


        NSString*   strDate = [NSString stringWithFormat:@"Days Drove to Work Since %@ %@ %d", [weekArray objectAtIndex:nWeekDay-1], [monthArray objectAtIndex:nMonth-1], [components day]];
        [labelSince setText:strDate];

        [dateFormatter setLocale:uslocale]; 
        [uslocale release];
    }
    else
    {
        [labelSince setText:@"Days Drove to Work Since Last"];
        [datePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970: 0]];
    }
}

- (void)checkDecimal
{
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range     replacementString:(NSString *)string 
{
    int nDecimalCount = 0;
    
    switch (textField.tag) {
        case 0:
            nDecimalCount = 1;
            break;
        case 1:
            nDecimalCount = 0;
            break;
        case 2:
            nDecimalCount = 3;
            break;
        case 3:
            nDecimalCount = 3;
            break;
            
        default:
            break;
    }
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setNumberStyle:kCFNumberFormatterDecimalStyle]; 
    
    NSString* strText = [Go_SaveAppDelegate realTextDecimal:[textField.text stringByReplacingCharactersInRange:range withString:string] nPlaces:nDecimalCount];
    
    [textField setText:strText];
    
    return NO;
}

@end
