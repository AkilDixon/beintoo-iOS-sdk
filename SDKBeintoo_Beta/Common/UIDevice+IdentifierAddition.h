//
//  UIDevice(Identifier).h
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIDevice (IdentifierAddition)

/* 
** MAC Address has been deprecated on iOS 7.0, this function wil return empty string starting from iOS 7.0.
*/

- (NSString *)_getMacAddress;

@end
