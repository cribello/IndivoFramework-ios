/*
 AppDelegate.m
 Medications Sample
 
 Created by Pascal Pfiffner on 9/7/11.
 Copyright (c) 2011 Children's Hospital Boston
 
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

#import "AppDelegate.h"
#import "MedListViewController.h"
#import "IndivoServer.h"
#import "IndivoAppDocument.h"
#import "allergylistViewController.h"
#import "allergyViewController.h"
#import "ImmunizationviewController.h"
#import "vitallistViewController.h"
#import "DemographicsListViewController.h"
@class DemographicsListViewController;
@class ImmunizationviewController;


@interface AppDelegate ()

@property (nonatomic, readwrite, strong) IndivoServer *indivo;
@property (nonatomic, strong) MedListViewController *listController;
@property(nonatomic, strong) allergylistViewController*allergylistViewController;

@property(nonatomic,strong) allergyViewController*allergyViewController;
@property(nonatomic,strong) ImmunizationviewController*ImmunizationviewController;
@property (strong, nonatomic) vitallistViewController*vitallistViewController;
@property (strong, nonatomic) DemographicsListViewController *DemographicsListViewController;



@end


/**
 *	The sample's application App Delegate.
 *	Here, we setup the indivo server after the App has launched.
 */
@implementation AppDelegate

@synthesize window;
@synthesize indivo, listController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Setup the UI
	// Setup the UI
    
	self.listController = [[MedListViewController alloc] initWithStyle:UITableViewStylePlain];
	window.rootViewController = [[UINavigationController alloc] initWithRootViewController:listController];
	[self.window makeKeyAndVisible];
     
    
    
    /*
     self.allergylistViewController = [[allergylistViewController alloc] initWithStyle:UITableViewStylePlain];
     window.rootViewController = [[UINavigationController alloc] initWithRootViewController:allergylistViewController];
     [window makeKeyAndVisible];
     */
    
    //  allergyViewController
    /*
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.allergyViewController = [[allergyViewController alloc] initWithNibName:@"allergyViewController" bundle:nil];
     self.window.rootViewController = self.allergyViewController;
     [self.window makeKeyAndVisible];
     */
    /*
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.allergyViewController = [[allergyViewController alloc] initWithNibName:@"allergyViewController" bundle:nil];
     self.window.rootViewController = self.allergyViewController;
     [self.window makeKeyAndVisible];
     */
    /*
     // ImmunizationviewController
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.ImmunizationviewController = [[ImmunizationviewController alloc] initWithNibName:@"ImmunizationviewController" bundle:nil];
     self.window.rootViewController = self.ImmunizationviewController;
     [self.window makeKeyAndVisible];
     
     
    
     // vitallistViewController
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.vitallistViewController = [[vitallistViewController alloc] initWithNibName:@"vitallistViewController" bundle:nil];
     self.window.rootViewController = self.vitallistViewController;
     [self.window makeKeyAndVisible];
     */
    
    //Demographics
    /*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.DemographicsListViewController = [[DemographicsListViewController alloc] initWithNibName:@"DemographicsListViewController" bundle:nil];
    self.window.rootViewController = self.DemographicsListViewController;
    [self.window makeKeyAndVisible];
    */
    

	
    // Setup the server
	self.indivo = [IndivoServer serverWithDelegate:self];
	
	/*/ ** Demo: Fetch application specific documents
	[indivo fetchAppSpecificDocumentsWithCallback:^(BOOL success, NSDictionary *__autoreleasing userInfo) {
		
		// success, pull the individual app documents
		if (success) {
			NSArray *appDocuments = [userInfo objectForKey:INResponseArrayKey];
			if ([appDocuments count] > 0) {
				for (IndivoAppDocument *appDoc in appDocuments) {
					[appDoc pull:^(BOOL userDidCancel, NSString *__autoreleasing errorMessage) {
						if (errorMessage) {
							DLog(@"Error pulling app document: %@", errorMessage);
						}
					}];
				}
			}
			
			// there is none, create one
			else {
				IndivoAppDocument *newAppDoc = [IndivoAppDocument newOnServer:indivo];
				
				NSDictionary *childDict = [NSDictionary dictionaryWithObject:@"a node attribute" forKey:@"foo"];
				INXMLNode *aChild = [INXMLNode nodeWithName:@"child" attributes:childDict];
				[newAppDoc.tree addChild:aChild];
				
				// push
				[newAppDoc push:^(BOOL userDidCancel, NSString *__autoreleasing errorMessage) {
					if (errorMessage) {
						DLog(@"Error pushing new app document: %@", errorMessage);
					}
				}];
			}
		}
		
		// log failure
		else {
			DLog(@"Failed to get app specific documents: %@", [[userInfo objectForKey:INErrorKey] localizedDescription]);
		}
	}];	//	*/
	
    return YES;
}



#pragma mark - Indivo Framework Delegate
- (UIViewController *)viewControllerToPresentLoginViewController:(IndivoLoginViewController *)loginVC
{
	return window.rootViewController;
}

- (void)userDidLogout:(IndivoServer *)fromServer
{
	[listController unloadData];
}


@end
