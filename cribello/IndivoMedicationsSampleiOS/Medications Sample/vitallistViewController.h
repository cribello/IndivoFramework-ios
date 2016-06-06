//
//  vitallistViewController.h
//  Medications Sample
//
//  Created by Souman Paul on 22/01/15.
//  Copyright (c) 2015 Children's Hospital Boston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VitalListDetails.h"
@class VitalListDetails;

@class IndivoRecord;
@class IndivoVitalSigns;

@interface vitallistViewController : UIViewController


- (IBAction)add:(id)sender;
- (IBAction)connect:(id)sender;


@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tablevView;


@property (nonatomic, strong) IndivoRecord *activeRecord;
@property (nonatomic, strong) NSArray *meds;


//@property (strong, nonatomic) UIWindow *window;

//@property(strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) VitalListDetails *VitalListDetails;
@end
