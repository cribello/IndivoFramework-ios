//
//  ImmunizationviewController.h
//  Medications Sample
//
//  Created by Souman Paul on 22/01/15.
//  Copyright (c) 2015 Children's Hospital Boston. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndivoRecord;
@interface ImmunizationviewController : UIViewController


@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)connect:(id)sender;

- (IBAction)add:(id)sender;

@property (nonatomic, strong) IndivoRecord *activeRecord;
@property (nonatomic, strong) NSArray *meds;
@end
