//
//  allergylistViewController.m
//  Medications Sample
//
//  Created by Souman Paul on 22/01/15.
//  Copyright (c) 2015 Children's Hospital Boston. All rights reserved.
//

#import "allergylistViewController.h"
#import "AppDelegate.h"
#import "IndivoRecord.h"
#import "IndivoDocuments.h"
#import "MedViewController.h"
//#import "IndivoAllergy+Report.h"


@interface allergylistViewController ()
- (void)selectRecord:(id)sender;
- (void)cancelSelection:(id)sender;
- (void)setRecordButtonTitle:(NSString *)aTitle;
- (void)showMedication:(IndivoMedication *)aMedication animated:(BOOL)animated;


@end

@implementation allergylistViewController

@synthesize activeRecord, meds;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Allergy";
	
	// Select Records button
	[self setRecordButtonTitle:nil];
	
    // Allow to add medications
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMedication:)];
	addButton.enabled = (nil != self.activeRecord);
	self.navigationItem.rightBarButtonItem = addButton;
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
	[self setRecordButtonTitle:nil];
}

/**
 *	Connecting to the server retrieves the records of your users account
 */
- (void)selectRecord:(id)sender
{
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
			[self setRecordButtonTitle:[activeRecord label]];
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
			[self setRecordButtonTitle:[activeRecord label]];
			self.navigationItem.rightBarButtonItem.enabled = (nil != self.activeRecord);
			
			// fetch this record's medications
			[activeRecord fetchReportsOfClass:[IndivoAllergy class]
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
			[self setRecordButtonTitle:[activeRecord label]];
		}
	}];
}

/**
 *	Cancels current connection attempt
 */
- (void)cancelSelection:(id)sender
{
	/// @todo cancel if still in progress
	[self setRecordButtonTitle:nil];
}

/**
 *	Reverts the navigation bar "connect" button
 */
- (void)setRecordButtonTitle:(NSString *)aTitle
{
	NSString *title = ([aTitle length] > 0) ? aTitle : @"Connect";
	UIBarButtonItem *connectButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(selectRecord:)];
	self.navigationItem.leftBarButtonItem = connectButton;
}



#pragma mark - Medication Handling
/**
 *	Called when the user taps a medication row, shows the details for the selected medication
 */
- (void)showMedication:(IndivoMedication *)aMedication animated:(BOOL)animated
{
	if (aMedication) {
		MedViewController *viewController = [MedViewController new];
		viewController.medication = aMedication;
		[self.navigationController pushViewController:viewController animated:animated];
	}
}

/**
 *	Adds a medication to the active record
 */
- (void)addMedication:(id)sender
{
	NSError *error = nil;
	IndivoAllergy *newMed = (IndivoAllergy *)[activeRecord addDocumentOfClass:[IndivoAllergy class] error:&error];
	if (!newMed) {
		DLog(@"Error: %@", [error localizedDescription]);
		// handle error
		return;
	}
	
	/*******************************************************
	 *  This is the place to setup your medication object  *
	 *******************************************************/
    
    newMed.category=[INCodedValue new];
	newMed.category.title = @"title";
    newMed.category.system = @"http://purl.bioontology.org/ontology/SNOMEDCT/";
    newMed.category.identifier = @"416098002";
    
	newMed.allergic_reaction=[INCodedValue new];
     newMed.allergic_reaction.title =@"allery_test";
     newMed.allergic_reaction.system =@"http://purl.bioontology.org/ontology/SNOMEDCT/";
    newMed.allergic_reaction.identifier =@"271807003";
    
    newMed.drug_class_allergen=[INCodedValue new];
    newMed.drug_class_allergen.title =@"drug_class_allergentitle";
    newMed.drug_class_allergen.system =@"http://purl.bioontology.org/ontology/NDFRT/";
    newMed.drug_class_allergen.identifier =@"N0000175503";
    
    newMed.food_allergen=[INCodedValue new];
    newMed.food_allergen.title =@"food_allergen_allergentitle";
    newMed.food_allergen.system =@"http://fda.gov/UNII/";
    newMed.food_allergen.identifier =@"255604002";
    
    newMed.drug_allergen=[INCodedValue new];
    newMed.drug_allergen.title =@"fdrug_allergen_allergentitle";
    newMed.drug_allergen.system =@"http://purl.bioontology.org/ontology/RXNORM/";
    newMed.drug_allergen.identifier =@"255604002";

    newMed.severity=[INCodedValue new];
    newMed.severity.title =@"severityallergentitle";
    newMed.severity.system =@"http://purl.bioontology.org/ontology/SNOMEDCT/";
    newMed.severity.identifier =@"255604002";

    
	
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
    [self showMedication:selected animated:YES];
}


@end
