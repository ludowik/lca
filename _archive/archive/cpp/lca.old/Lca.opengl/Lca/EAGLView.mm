//
//  EAGLView.m
//  OpenGL.iPhone
//
//  Created by Ludovic MILHAU on 03/02/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "EAGLView.h"

#include "system.h"
#include "launcher.h"

void loop_observer(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void* info) {
	manageEvents();
}

void time_observer(CFRunLoopTimerRef timer, void *info) {
	addEventTimer();
}

void idle_observer(CFRunLoopTimerRef timer, void *info) {
	addEventIdle();
}

void draw_observer(CFRunLoopTimerRef timer, void *info) {
	ViewRef view = get_view();
	if ( view && view->m_needsRedrawAutomatic ) {
		System::Media::setNeedsRedraw();
	}
}

void install_observer() {
	CFRunLoopRef runloop = CFRunLoopGetCurrent();
	
	CFRunLoopObserverRef runloop_observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, true, 0, loop_observer, NULL);
	CFRunLoopAddObserver(runloop, runloop_observer, kCFRunLoopCommonModes);
	
	runloop_observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, true, 1, loop_observer, NULL);
	CFRunLoopAddObserver(runloop, runloop_observer, kCFRunLoopCommonModes);
	
	CFRunLoopTimerRef runlooptimer_ref = CFRunLoopTimerCreate(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent(), 1, 0, 0, time_observer, NULL);
	CFRunLoopAddTimer(runloop, runlooptimer_ref, kCFRunLoopCommonModes);
	
	runlooptimer_ref = CFRunLoopTimerCreate(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent(), 0.1, 0, 0, idle_observer, NULL);
	CFRunLoopAddTimer(runloop, runlooptimer_ref, kCFRunLoopCommonModes);
	
	runlooptimer_ref = CFRunLoopTimerCreate(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent(), 0.02, 0, 0, draw_observer, NULL);
	CFRunLoopAddTimer(runloop, runlooptimer_ref, kCFRunLoopCommonModes);
}

@implementation EAGLView

// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

#define kAccelerometerFrequency 10 // Constant for the number of times per second (Hertz) to sample acceleration

//The EAGL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
	if ((self = [super initWithCoder:coder])) {
		// Get the layer
        CAEAGLLayer* eaglLayer = (CAEAGLLayer*)self.layer;
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE],
                                        kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8,
                                        kEAGLDrawablePropertyColorFormat, nil];
		
		// Gestion de l'animation d'attente
		System::Event::startWaitAnimation((int)[self initActivityIndicatorView]);
		
		// Gestion des notifications de l'accéléromètre
		[self initAccelerometer];
		
		// Pas de barre de statut standard
		[[UIApplication sharedApplication] setStatusBarHidden:YES];
		
		// Gestion des notifications d'orientation de l'iPhone
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
		
		// Orientation courante
		System::Media::setOrientation();
		
		// Gestion spécifique de l'interface
		System::Media::initInterface();
		
		// Référencement de l'interface graphique
		System::Media::setActiveWindow(self);
		System::Media::setActiveDC(self.layer);
		
		// Initialisation du mode graphique
		System::Media::setGdiMode(gdiModeOpenGL);
		
		// Initialisation de la taille de la zone graphique
		System::Media::setWindowsSize();
		
		// Initialisation de la fonction randomize
		System::Math::seed();
		
#if	TARGET_IPHONE_SIMULATOR
		// Execution des tests unitaires de non régression
		Test::getInstance().test();
		Test::releaseInstance();
#endif
		
		// Gestion des événements
		install_observer();
        
		LauncherView* launcherView = (LauncherView*)create_view("Launcher");
		push_view(launcherView, false);
		
		if ( strcmp(((LauncherModel*)launcherView->m_model)->m_cl, "Launcher") ) {
			ViewRef view = create_view(((LauncherModel*)launcherView->m_model)->m_cl);
			if ( view ) {
				push_view(view);
			}
		}
	}
	
    return self;
}

- (id)initActivityIndicatorView {
	// Initialisation de l'animation d'attente
	id progressId = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[self addSubview:progressId];
	
	return progressId;
}

// Gestion des notifications de l'accéléromètre
- (void)initAccelerometer {
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];	
}

// Gestion de l'orientation de l'écran
- (void)didRotate:(NSNotification *)notification {
	if ( System::Media::setOrientation() ) {
		System::Media::setWindowsSize();
		
		ViewRef view = get_view();
		view->releaseGdi();
	}
}

// Gestion des mouvements utilisateurs
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	static CGPoint point;
	
	static int x = 0;
	static int y = 0;
	
	CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
	
	NSUInteger numTaps = [[touches anyObject] tapCount];
	for ( UITouch *touch in touches ) {
		point = [touch locationInView:self];
		
		/*if ( UIDeviceOrientationIsLandscape(m_orientation) ) {
		 x = point.y-applicationFrame.origin.y;
		 y = applicationFrame.size.width-point.x;
		 }
		 else*/ {
			 x = point.x-applicationFrame.origin.x;
			 y = point.y-applicationFrame.origin.y;
		 }
		
		switch ( numTaps ) {
			case 1: {
				addEvent(new Event(eTouchBegin, x, y));
				break;
			}
			case 2: {
				addEvent(new Event(eTouchDoubleTap, x, y));
				break;
			}
			case 3: {
				addEvent(new Event(eTouchTripleTap, x, y));
				break;
			}
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	static CGPoint point;
	static UITouchPhase phase;
	
	for ( UITouch *touch in touches ) {
		point = [touch locationInView:self];
		phase = [touch phase];
		
		if ( phase == UITouchPhaseMoved ) {
			addEvent(new Event(eTouchMove, point.x, point.y));
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	static CGPoint point;
	
	for ( UITouch *touch in touches ) {
		point = [touch locationInView:self];
		addEvent(new Event(eTouchEnd, point.x, point.y));		
		break;
	}
}

// Gestion de l'accéléromètre
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	ViewRef view = get_view();
	if ( view ) {
		view->acceleration(acceleration.x, acceleration.y, acceleration.z);
	}
}

- (void)dealloc {
    [super dealloc];
	free_views();
}

@end
