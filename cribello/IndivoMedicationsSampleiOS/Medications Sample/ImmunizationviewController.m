//
//  ImmunizationviewController.m
//  Medications Sample
//
//  Created by Souman Paul on 22/01/15.
//  Copyright (c) 2015 Children's Hospital Boston. All rights reserved.
//

#import "ImmunizationviewController.h"
#import "AppDelegate.h"
#import "IndivoRecord.h"
#import "IndivoDocuments.h"
#import "MedViewController.h"


@interface ImmunizationviewController ()

@end

@implementation ImmunizationviewController
@synthesize activeRecord, meds;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIDeviceOrientationIsPortrait(interfaceOrientation);
}



#pragma mark - Record Handling
/**
 *	Called when the user logged out
 */
- (void)unloadData
{
	self.navigationItem.rightBarButtonItem.enabled = NO;
	self.activeRecord = nil;
	self.meds = nil;
	[self.tableView reloadData];
	[self connect:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connect:(id)sender {
    // create an activity indicator to show that something is happening
	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *activityButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];
	[activityButton setTarget:self];
	[activityButton setAction:@selector(cancelSelection:)];
	self.navigationItem.leftBarButtonItem = activityButton;
	[activityView startAnimating];
	
	// select record
	[APP_DELEGATE.indivo selectRecord:^(BOOL userDidCancel, NSString *errorMessage) {
		
		// there was an error selecting the record
		if (errorMessage) {
			[self connect:[activeRecord label]];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to connect"
															message:errorMessage
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
		}
		
		// successfully selected record, fetch medications
		else if (!userDidCancel) {
			self.activeRecord = [APP_DELEGATE.indivo activeRecord];
			//[self connect:[activeRecord label]];
			self.navigationItem.rightBarButtonItem.enabled = (nil != self.activeRecord);
			
			// fetch this record's medications
			[activeRecord fetchReportsOfClass:[IndivoImmunization class]
									 callback:^(BOOL success, NSDictionary *__autoreleasing userInfo) {
                                         
                                         // error fetching medications
                                         if (!success) {
                                             NSString *errorMessage = [[userInfo objectForKey:INErrorKey] localizedDescription];
                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to get medications"
                                                                                             message:errorMessage
                                                                                            delegate:nil
                                                                                   cancelButtonTitle:@"OK"
                                                                                   otherButtonTitles:nil];
                                             [alert show];
                                         }
                                         
                                         // successfully fetched medications, display
                                         else if (!userDidCancel) {
                                             //DLog(@"%@", [userInfo objectForKey:INResponseStringKey]);
                                             self.meds = [userInfo objectForKey:INResponseArrayKey];
                                             [self.tableView reloadData];
                                         }
                                     }];
		}
		
		// cancelled
		else {
			//[self connect:[activeRecord label]];
		}
	}];

}

- (IBAction)add:(id)sender {
    
    NSError *error = nil;
	IndivoImmunization *newMed = (IndivoImmunization *)[activeRecord addDocumentOfClass:[IndivoImmunization class] error:&error];
	if (!newMed) {
		DLog(@"Error: %@", [error localizedDescription]);
		// handle error
		return;
	}
	
	/*******************************************************
	 *  This is the place to setup your medication object  *
	 *******************************************************/
    
    newMed.product_class=[INCodedValue new];
	newMed.product_class.title = @"title";
    newMed.product_class.system = @"http://www2a.cdc.gov/nip/IIS/IISStandards/vaccines.asp?rpt=vg#";
    newMed.product_class.identifier = @"416098002";
    
	newMed.administration_status=[INCodedValue new];
    newMed.administration_status.title =@"allery_test";
    newMed.administration_status.system =@"http://smartplatforms.org/terms/codes/ImmunizationAdministrationStatus#";
    newMed.administration_status.identifier =@"doseGiven";
    
    newMed.refusal_reason=[INCodedValue new];
    newMed.refusal_reason.title =@"refusal_reason";
    newMed.refusal_reason.system =@"http://smartplatforms.org/terms/codes/ImmunizationRefusalReason#";
    newMed.refusal_reason.identifier =@"documentedImmunityOrPreviousDisease";
    
    newMed.product_class_2=[INCodedValue new];
    newMed.product_class_2.title =@"HepB";
    newMed.product_class_2.system =@"http://www2a.cdc.gov/nip/IIS/IISStandards/vaccines.asp?rpt=vg#";
    newMed.product_class_2.identifier =@"HepB";
    
    newMed.product_name=[INCodedValue new];
    newMed.product_name.title =@"fdrug_allergen_allergentitle";
    newMed.product_name.system =@"http://www2a.cdc.gov/nip/IIS/IISStandards/vaccines.asp?rpt=cvx#";
    newMed.product_name.identifier =@"255604002";
    
    /////encounter//////
    
    
    
    
    
    
    ///////////////////////
    newMed.date = [INDateTime now];
	
	/******************************************************/
	
	// push to the server
	[newMed push:^(BOOL didCancel, NSString *errorString) {
		if (errorString) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error pushing to server"
															message:errorString
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
		}
		else if (!didCancel) {
			self.meds = [meds arrayByAddingObject:newMed];
			[self.tableView reloadData];
			
			// show the medication
            //	[self showMedication:newMed animated:YES];
			
			// send a natification
			[activeRecord sendMessage:@"New Allergy"
							 withBody:@"A new medication has just been added"
							   ofType:INMessageTypePlaintext
							 severity:INMessageSeverityLow
						  attachments:[NSArray arrayWithObject:newMed]
							 callback:NULL];
		}
	}];
    

}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (0 == section) {
		return [meds count];
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
	if (0 == indexPath.section && [meds count] > indexPath.row) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		// display the name
		IndivoAllergy *med = [meds objectAtIndex:indexPath.row];
		cell.textLabel.text = [med label];
		return cell;
	}
	return nil;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (0 != indexPath.section || indexPath.row >= [meds count]) {
		return;
	}
	
	IndivoMedication *selected = [meds objectAtIndex:indexPath.row];
    //[self showMedication:selected animated:YES];
}
- (void)showMedication:(IndivoMedication *)aMedication animated:(BOOL)animated
{
	if (aMedication) {
		MedViewController *viewController = [MedViewController new];
		viewController.medication = aMedication;
		[self.navigationController pushViewController:viewController animated:animated];
	}
}

@end
