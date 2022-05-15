//
//  LcaViewController.m
//  Lca
//
//  Created by Ludovic MILHAU on 10/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LcaViewController.h"
#import "View_iPhoneView.h"

#include "System.h"

@implementation LcaViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.wantsFullScreenLayout = YES;
	
    View_iPhoneView *view = [[View_iPhoneView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
	
	[self.view setOpaque:TRUE];
    
	if ( 1 ) {
		[self.view setClearsContextBeforeDrawing:TRUE];
		[self.view setBackgroundColor:[UIColor blackColor]];
	} else {
		[self.view setClearsContextBeforeDrawing:FALSE];
	}
    
	
    [view release];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// Orientation de l'écran acceptée
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    ViewRef view = get_view();
    if ( view ) {
        switch (interfaceOrientation) {
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                return view->shouldAutorotateToInterfaceOrientation(orientationPortrait);
            
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                return view->shouldAutorotateToInterfaceOrientation(orientationLandscape);
        }
    }    
    return false;
}

@end
