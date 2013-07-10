/*******************************************************************************
 * Copyright 2013 Beintoo - author gpiazzese@beintoo.com
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

#import <Foundation/Foundation.h>

extern NSString  *BCUrlScheme;
extern NSString  *BCUrlSchemeBase;

// BUS = Beintoo Url Scheme

extern NSString  *BUSGetSdkData;
extern NSString  *BUSGetPlayer;
extern NSString  *BUSGetApiKey;
extern NSString  *BUSGetSdkVersion;
extern NSString  *BUSGetDeviceID;
extern NSString  *BUSGetUserExt;
extern NSString  *BUSGetGuid;
extern NSString  *BUSGetMacAdress;
extern NSString  *BUSGetDeviceGeoLocation;
extern NSString  *BUSGetDeviceLanguage;
extern NSString  *BUSGetDeviceTimezone;
extern NSString  *BUSGetDeviceScreenSize;
extern NSString  *BUSLoginUser;
extern NSString  *BUSLogoutUser;
extern NSString  *BUSCloseDashboard;
extern NSString  *BUSGetIFA;
extern NSString  *BUSCloseLoader;

extern NSString  *BCUrlSectionDashboard;
extern NSString  *BCUrlSectionBestore;
extern NSString  *BCUrlSectionSignup;
extern NSString  *BCUrlSectionMissions;

@interface BCustomUrlScheme : NSObject
{}

+ (BOOL)webview:(UIWebView *)webView action:(NSString *)stringURL timer:(NSTimer *)timer controller:(id)controller;

+ (NSString *)urlSchemeWithSubpath:(NSString *)subscheme;
+ (BOOL)matcherBetweenUrl:(NSString *)url andSchemeSubPath:(NSString *)scheme;

+ (NSDictionary *)getGeoLocationInfo;
+ (NSDictionary *)createSdkData;
+ (NSDictionary *)getIFAinfo;
+ (NSDictionary *)getTimezoneInfo;

@end
