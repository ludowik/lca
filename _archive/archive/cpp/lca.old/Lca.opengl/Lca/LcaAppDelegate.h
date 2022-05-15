//
//  LcaAppDelegate.h
//  Lca
//
//  Created by Ludovic MILHAU on 10/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EAGLView.h"

@class EAGLView;

@class LcaViewController;

@interface LcaAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet LcaViewController *viewController;

@end
