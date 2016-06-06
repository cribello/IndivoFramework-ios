//
//  VitalListDetails.m
//  Medications Sample
//
//  Created by Souman Paul on 23/01/15.
//  Copyright (c) 2015 Children's Hospital Boston. All rights reserved.
//

#import "VitalListDetails.h"
#import "IndivoDocuments.h"
#import "AppDelegate.h"
#import "IndivoRecord.h"
#import "IndivoDocuments.h"

@interface VitalListDetails ()
- (void)configureView1;

@end

@implementation VitalListDetails
@synthesize vitals;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

- (id)init
{
	return [self initWithNibName:@"VitalListDetails" bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureView1];
}
- (void)configureView1
{
	   
        
		self.Title.text = vitals.bmi.name.title ;
	    self.identifier.text = [NSString stringWithFormat:@"Vitals: %@", ([vitals.bmi.name.identifier length] > 0) ? vitals.bmi.name.identifier : @"unknown"];
//
}
#pragma mark - Managing the detail item
- (void)setVitals:(IndivoVitalSigns *)newVitals
{
    if (newVitals != vitals) {
        vitals = newVitals;
        
        // Update the view.
        [self configureView1];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
