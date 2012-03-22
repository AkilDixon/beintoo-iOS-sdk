/*******************************************************************************
 * Copyright 2011 Beintoo - author fmessina@beintoo.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/

#import "BeintooiPadController.h"
#import "Beintoo.h"

@implementation BeintooiPadController

#ifdef UI_USER_INTERFACE_IDIOM
    @synthesize popoverController,loginPopoverController,vgoodPopoverController;
#endif
@synthesize isLoginOngoing;

-(id)init {
	if (self = [super init]){
		loginVC = [[BeintooLoginVC alloc] initWithNibName:@"BeintooLoginVC" bundle:[NSBundle mainBundle]];
		loginNavController = [[UINavigationController alloc] initWithRootViewController:loginVC];
	}
    return self;
}

- (void)viewDidLoad{
}

- (void)viewWillAppear:(BOOL)animated{	
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark MainPopover-Show-Hide-FromCaller


#ifdef UI_USER_INTERFACE_IDIOM
- (void)showBeintooPopover{
	self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    self.view.frame = [Beintoo getAppWindow].bounds;
	
	BeintooNavigationController *beintooMainNavController = [Beintoo getMainNavigationController];
	if (popoverController != nil) {
		[popoverController release];
		popoverController = nil;
	}
	popoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:beintooMainNavController];
	[popoverController setPopoverContentSize:CGSizeMake(320, 455)];
	popoverController.delegate = self;
    	
	self.view.alpha = 1;

	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadMainPopover" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[popoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
	isMainPopoverVisible = YES;
}

- (void)hideBeintooPopover{

	self.view.alpha = 0;
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.01f];
	[applicationUnloadViewIn setValue:@"unloadMainPopover" forKey:@"name"];
	applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionEnterSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	
	isMainPopoverVisible = NO;
}
#endif


#pragma mark -
#pragma mark LoginPopover - show-hide-FromCaller

#ifdef UI_USER_INTERFACE_IDIOM
- (void)showLoginPopover{
	
	if (loginPopoverController != nil) {
		[loginPopoverController release];
		loginPopoverController = nil;
	}
	[loginNavController popToRootViewControllerAnimated:NO];
	loginPopoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:loginNavController];
	[loginPopoverController setPopoverContentSize:CGSizeMake(320, 455)];
	loginPopoverController.delegate = self;
			
	[popoverController dismissPopoverAnimated:NO];
	[loginPopoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:NO];
	isLoginOngoing = YES;
}

- (void)hideLoginPopover{
	[loginPopoverController dismissPopoverAnimated:NO];
	[popoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:NO];
	isLoginOngoing = NO;
}
#endif

#pragma mark -
#pragma mark Vgood-Show-Hide-FromCaller

#ifdef UI_USER_INTERFACE_IDIOM
- (void)showVgoodPopoverWithVGoodController:(UINavigationController *)_vgoodNavController{
	self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
		
	if (vgoodPopoverController != nil) {
		[vgoodPopoverController release];
		vgoodPopoverController = nil;
	}
	vgoodPopoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:_vgoodNavController];
	[vgoodPopoverController setPopoverContentSize:CGSizeMake(320, 455)];
	vgoodPopoverController.delegate = self;
	
	self.view.alpha = 1;
	
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadVgoodPopover" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[vgoodPopoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
	
	isVgoodPopoverVisible = YES;
}

- (void)hideVgoodPopover{
	self.view.alpha = 0;
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.01f];
	[applicationUnloadViewIn setValue:@"unloadVgoodPopover" forKey:@"name"];
	applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionEnterSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	
	isVgoodPopoverVisible= NO;
}


- (void)showMissionVgoodPopoverWithVGoodController:(UINavigationController *)_vgoodNavController{
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    
	if (vgoodPopoverController != nil) {
		[vgoodPopoverController release];
		vgoodPopoverController = nil;
	}
	vgoodPopoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:_vgoodNavController];
	[vgoodPopoverController setPopoverContentSize:CGSizeMake(320, 455)];
	vgoodPopoverController.delegate = self;
	
	self.view.alpha = 1;
	
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:0.1f];
	[applicationLoadViewIn setValue:@"loadMissionVgoodPopover" forKey:@"name"];
	applicationLoadViewIn.removedOnCompletion = YES;
	[applicationLoadViewIn setType:kCATransitionReveal];
	applicationLoadViewIn.subtype = transitionEnterSubtype;
	applicationLoadViewIn.delegate = self;
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationLoadViewIn forKey:@"Show"];
	
	[vgoodPopoverController presentPopoverFromRect:startingRect inView:self.view permittedArrowDirections:0 animated:YES];
	
	isVgoodPopoverVisible = YES;

}
- (void)hideMissionVgoodPopover{
    self.view.alpha = 0;
	CATransition *applicationUnloadViewIn = [CATransition animation];
	[applicationUnloadViewIn setDuration:0.01f];
	[applicationUnloadViewIn setValue:@"unloadMissionVgoodPopover" forKey:@"name"];
	applicationUnloadViewIn.removedOnCompletion = YES;
	[applicationUnloadViewIn setType:kCATransitionReveal];
	applicationUnloadViewIn.subtype = transitionEnterSubtype;
	applicationUnloadViewIn.delegate = self;
	[applicationUnloadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:applicationUnloadViewIn forKey:@"Show"];
	
	isVgoodPopoverVisible= NO;
}

#endif


#pragma mark -
#pragma mark animationFinish

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag{
	// --------------- Main Controller -----------------------
	if ([[animation valueForKey:@"name"] isEqualToString:@"unloadMainPopover"]) {
		[self.view removeFromSuperview];
		[Beintoo beintooDidDisappear];
	}
	if ([[animation valueForKey:@"name"] isEqualToString:@"loadMainPopover"]) {
		[Beintoo beintooDidAppear];
	}
	// --------------- Vgood Controller -----------------------
	if ([[animation valueForKey:@"name"] isEqualToString:@"unloadVgoodPopover"]) {
		[self.view removeFromSuperview];
		[Beintoo prizeDidDisappear];
	}
	if ([[animation valueForKey:@"name"] isEqualToString:@"loadVgoodPopover"]) {
		[Beintoo prizeDidAppear];
	}
    // --------------- Mission Controller -----------------------
	if ([[animation valueForKey:@"name"] isEqualToString:@"unloadMissionVgoodPopover"]) {
		[self.view removeFromSuperview];
		[Beintoo beintooDidDisappear];
	}
	if ([[animation valueForKey:@"name"] isEqualToString:@"loadMissionVgoodPopover"]) {
	}
}

- (void)preparePopoverOrientation{
	
	if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeLeft) {
		startingRect = CGRectMake(370, 510, 1, 1);
		transitionEnterSubtype = kCATransitionFromTop;
		transitionExitSubtype  = kCATransitionFromBottom;
	}
	if ([Beintoo appOrientation] == UIInterfaceOrientationLandscapeRight) {
		startingRect = CGRectMake(370, 510, 1, 1);
		transitionEnterSubtype = kCATransitionFromTop;
		transitionExitSubtype  = kCATransitionFromBottom;
	}
	if ([Beintoo appOrientation] == UIInterfaceOrientationPortrait) {
		startingRect = CGRectMake(380, 450, 1, 1);
		transitionEnterSubtype = kCATransitionFromTop;
		transitionExitSubtype  = kCATransitionFromBottom;
	}
    
    if ([Beintoo appOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
		startingRect = CGRectMake(380, 450, 1, 1);
		transitionEnterSubtype = kCATransitionFromTop;
		transitionExitSubtype  = kCATransitionFromBottom;
	}
}

#pragma mark -
#pragma mark PopoverDelegate

#ifdef UI_USER_INTERFACE_IDIOM

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
	// Here we need to call the Beintoo dismiss, with respect to the actual popover. 
	// This will call the main or vgood "hide" method here to remove the iPadController from the window.
	
	if (isMainPopoverVisible) {  
		[Beintoo dismissBeintoo];
	}
	if (isVgoodPopoverVisible) {  
		[Beintoo dismissPrize];
	}
	return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
}

#endif

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return [Beintoo appOrientation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)dealloc {
	[loginVC release];
	[loginNavController release];
    [super dealloc];
}

@end
