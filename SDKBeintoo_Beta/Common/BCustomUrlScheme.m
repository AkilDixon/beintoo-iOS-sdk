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

#import "BCustomUrlScheme.h"
#import "Beintoo.h"
#import "SBJSON.h"

NSString  *BCUrlScheme             = @"BeintooIOS://";
NSString  *BCUrlSchemeBase         = @"sdk-html5/";

NSString  *BUSGetSdkData           = @"function/getSdkData";
NSString  *BUSGetPlayer            = @"function/getPlayer";
NSString  *BUSGetApiKey            = @"function/getApiKey";
NSString  *BUSGetSdkVersion        = @"function/getSdkVersion";
NSString  *BUSGetPlatform          = @"function/getPlatform";
NSString  *BUSGetDeviceInfo        = @"function/getDeviceInfo";
NSString  *BUSGetDeviceID          = @"function/getDeviceId";
NSString  *BUSGetUserExt           = @"function/getUserExt";
NSString  *BUSGetGuid              = @"function/getGuid";
NSString  *BUSGetMacAdress         = @"function/getMacAddress";
NSString  *BUSGetDeviceGeoLocation = @"function/getDeviceGeoLocation";
NSString  *BUSGetDeviceLanguage    = @"function/getDeviceLanguage";
NSString  *BUSGetDeviceTimezone    = @"function/getDeviceTimezone";
NSString  *BUSGetDeviceScreenSize  = @"function/getDeviceScreenSize";
NSString  *BUSGetDeviceOSVersion   = @"function/getDeviceOSVersion";
NSString  *BUSGetDeviceModel       = @"function/getDeviceModel";
NSString  *BUSGetDeviceUserAgent   = @"function/getDeviceUserAgent";
NSString  *BUSGetCarrier           = @"function/getCarrier";
NSString  *BUSLoginUser            = @"function/loginUser";
NSString  *BUSLogoutUser           = @"function/logoutUser";
NSString  *BUSCloseDashboard       = @"function/closeDashboard";
NSString  *BUSGetIFA               = @"function/getIFA";
NSString  *BUSCloseLoader          = @"function/closeLoader";

NSString  *BUSGoToUrl                   = @"function/goToUrl";
NSString  *BUSOpenSection               = @"function/openSection";
// open url with custom management by APIs
NSString  *BUSOpenUrlInsideDashboard    = @"function/openUrlInsideDashboard";
NSString  *BUSOpenUrlInExternalBrowser  = @"function/openUrlInExternalBrowser";
NSString  *BUSOpenUrlInBeintooBrowser   = @"function/openUrlInBeintooBrowser";

NSString  *BCUrlSectionDashboard    = @"dashboard";
NSString  *BCUrlSectionBestore      = @"redeem";
NSString  *BCUrlSectionSignup       = @"signup-email";
NSString  *BCUrlSectionMissions     = @"";

@implementation BCustomUrlScheme

+ (NSString *)urlSchemeWithSubpath:(NSString *)subscheme
{
    return [[NSString stringWithFormat:@"%@%@%@", BCUrlScheme, BCUrlSchemeBase, subscheme] lowercaseString];
}

+ (BOOL)matcherBetweenUrl:(NSString *)url andSchemeSubPath:(NSString *)scheme
{
    if ([[url lowercaseString] isEqualToString:[BCustomUrlScheme urlSchemeWithSubpath:scheme]])
    {
        return YES;
    }
    return NO;
}

+ (NSDictionary *)getGeoLocationInfo
{
    NSDictionary *dictionary;
    if ([Beintoo getUserLocation])
    {
        CLLocation *location = [Beintoo getUserLocation];
        
        NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        NSString *altitude = [NSString stringWithFormat:@"%f", location.altitude];
        NSString *timestamp = [NSString stringWithFormat:@"%@", location.timestamp];
        
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              latitude, @"lat",
                              longitude, @"lng",
                              altitude, @"alt",
                              timestamp, @"time",
                              nil];
    }
    else {
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNull null], @"lat",
                              [NSNull null], @"lng",
                              [NSNull null], @"alt",
                              [NSNull null], @"time",
                              nil];
    }
    
    return dictionary;
}

+ (NSDictionary *)createSdkData
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    // Apikey
    [dictionary setObject:[Beintoo getApiKey] forKey:@"apikey"];
    
    // Version
    [dictionary setObject:[Beintoo currentVersion] forKey:@"v"];
    
    // Platform
    [dictionary setObject:[Beintoo platform] forKey:@"platform"];
    
    // apiSandbox
    [dictionary setObject:[NSString stringWithFormat:@"%i", [Beintoo isOnPrivateSandbox]] forKey:@"apisandbox"];
    
    // devSandbox
    [dictionary setObject:[NSString stringWithFormat:@"%i", [Beintoo isOnSandbox]] forKey:@"devsandbox"];
    
    // deviceId
    [dictionary setObject:[BeintooDevice getUDID] forKey:@"udid"];
    
    // userExt
    if ([Beintoo getUserID])
        [dictionary setObject:[Beintoo getUserID] forKey:@"userext"];
    else
        [dictionary setObject:[NSNull null] forKey:@"userext"];
    
    // guid
    if ([Beintoo getPlayerID] != nil)
        [dictionary setObject:[Beintoo getPlayerID] forKey:@"guid"];
    else
        [dictionary setObject:[NSNull null] forKey:@"guid"];
    
    // Mac Address
    if ([BeintooDevice getMacAddress] != nil)
        [dictionary setObject:[BeintooDevice getMacAddress] forKey:@"mac"];
    else
        [dictionary setObject:[NSNull null] forKey:@"mac"];
    
    // Geo Location
    [dictionary setObject:[BCustomUrlScheme getGeoLocationInfo] forKey:@"geo"];
    
    // Screen Size
    [dictionary setObject:[BeintooDevice screenSize] forKey:@"sres"];
    
    // Language
    [dictionary setObject:[BeintooDevice getISOLanguage] forKey:@"lan"];
    
    // Timezone
    [dictionary setObject:[BCustomUrlScheme getTimezoneInfo] forKey:@"timezone"];
    
    // UserAgent
    [dictionary setObject:[BeintooNetwork getUserAgent] forKey:@"useragent"];
    
    // DeviceModel
    [dictionary setObject:[BeintooDevice getDeviceType] forKey:@"devicemodel"];
    
    // Carrier
    if ([BeintooNetwork getCarrierBuiltString] != nil)
        [dictionary setObject:[BeintooNetwork getCarrierBuiltString] forKey:@"carrier"];
    else
        [dictionary setObject:[NSNull null] forKey:@"carrier"];
    
    // IFA
    [dictionary setObject:[BCustomUrlScheme getIFAinfo] forKey:@"ifa"];
    
#ifdef BEINTOO_ARC_AVAILABLE
    return dictionary;
#else
    return [dictionary autorelease];
#endif
    
}

+ (NSDictionary *)getIFAinfo
{
    NSString *ifa = nil;
    NSNumber *ifaEnabled = [NSNumber numberWithBool:FALSE];
    
    NSDictionary *locationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNull null], @"ifaValue",
                                        ifaEnabled, @"ifaAllowed",
                                        nil];
    
    if ([BeintooDevice isASIdentifierSupported])
    {
        ifa = [BeintooDevice getASIdentifier];
        ifaEnabled = [NSNumber numberWithBool:[[BeintooDevice isASIdentifierEnabledByUser] boolValue]];
        
        if (ifa != nil)
            locationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  ifa, @"ifav",
                                  ifaEnabled, @"ifae",
                                  nil];
    }
    
#ifdef BEINTOO_ARC_AVAILABLE
    return locationDictionary;
#else
    return [locationDictionary autorelease];
#endif
    
}

+ (NSDictionary *)getTimezoneInfo
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:[NSTimeZone systemTimeZone].secondsFromGMT], @"offset",
                                        [NSNumber numberWithBool:[NSTimeZone systemTimeZone].isDaylightSavingTime], @"daylightsavingtime",
                                        [NSTimeZone systemTimeZone].name, @"name",
                                        [NSTimeZone systemTimeZone].abbreviation, @"abbreviation",
                                        nil];
}

+ (BOOL)webview:(UIWebView *)webView action:(NSString *)stringURL  timer:(NSTimer *)timer controller:(id)controller
{
    if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSCloseDashboard])
    {
        [Beintoo dismissView:controller];
        
        // BeintooLOG(@"closing the Dashboard");
        
        return NO;
    }
    if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSCloseLoader])
    {
        [BLoadingView stopActivity];
        
        if (timer != nil && [timer isValid])
        {
            [timer invalidate];
            timer = nil;
        }
        
        // BeintooLOG(@"removing the loader");
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetPlayer])
    {
        NSString *result;
        
        if ([Beintoo getPlayerID] != nil)
        {
            NSDictionary *dictionary = [[Beintoo getPlayer] dictionaryFromSelf];
            result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getPlayer('%@')", dictionary]];
            BeintooLOG(@"Sent object to webview: %@",[NSString stringWithFormat:@"BeintooIOS.getPlayer('%@')", dictionary]);
        }
        else {
            result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getPlayer(null)"]];
            BeintooLOG(@"Sent object to webview: %@",[NSString stringWithFormat:@"BeintooIOS.getPlayer(null)"]);
        }
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetGuid])
    {
        NSString *result;
        
        if ([Beintoo getPlayerID] != nil){
            result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getGuid('%@')", [Beintoo getPlayerID]]];
            BeintooLOG(@"Sent object to webview: %@",[NSString stringWithFormat:@"BeintooIOS.getGuid('%@')", [Beintoo getPlayerID]]);
        }
        else {
            result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getGuid(null)"]];
            BeintooLOG(@"Sent object to webview: %@",[NSString stringWithFormat:@"BeintooIOS.getGuid(null)"]);
        }
    
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetApiKey])
    {
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getApiKey('%@')", [Beintoo getApiKey]]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.getApiKey('%@')", [Beintoo getApiKey]]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetSdkVersion])
    {
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getSdkVersion('%@')", [Beintoo currentVersion]]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.getSdkVersion('%@')", [Beintoo currentVersion]]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetPlatform])
    {
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getPlatoform('%@')", [Beintoo platform]]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.getPlatoform('%@')", [Beintoo platform]]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetDeviceID])
    {
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getDeviceId('%@')", [BeintooDevice getUDID]]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.getDeviceId('%@')", [BeintooDevice getUDID]]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetMacAdress])
    {
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getMacAddress('%@')", [BeintooDevice getMacAddress]]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.getMacAddress('%@')", [BeintooDevice getMacAddress]]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetUserExt])
    {
        NSString *result;
        if ([Beintoo getUserID])
        {
            result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getUserExt('%@')", [Beintoo getUserID]]];
            BeintooLOG(@"Sent object to webview: %@",[NSString stringWithFormat:@"BeintooIOS.getUserExt('%@')", [Beintoo getUserID]]);
        }
        else
        {
            result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getUserExt(null)"]];
            BeintooLOG(@"Sent object to webview: %@",[NSString stringWithFormat:@"BeintooIOS.getUserExt(null)"]);
        }
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetDeviceGeoLocation])
    {
        NSString *result;
        NSDictionary *locationDictionary = [BCustomUrlScheme getGeoLocationInfo];
        
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *jsonString = [jsonWriter stringWithObject:locationDictionary];
        
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getDeviceGeoLocation('%@')", jsonString]];
        
        BeintooLOG(@"Sent object to webview: %@",[NSString stringWithFormat:@"BeintooIOS.getDeviceGeoLocation('%@')", jsonString]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetDeviceTimezone])
    {
        NSString *result;
        NSDictionary *locationDictionary = [BCustomUrlScheme getTimezoneInfo];
        
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *jsonString = [jsonWriter stringWithObject:locationDictionary];
        
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getDeviceTimezone('%@')", jsonString]];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [jsonWriter release];
#endif
        
        BeintooLOG(@"Sent object to webview: %@",[NSString stringWithFormat:@"BeintooIOS.getDeviceTimezone('%@')", jsonString]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetDeviceLanguage])
    {
        NSString *result;
        
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getDeviceLanguage('%@')", [BeintooDevice getISOLanguage]]];
        
        BeintooLOG(@"Sent object to webview: %@",[NSString stringWithFormat:@"BeintooIOS.getDeviceLanguage('%@')", [BeintooDevice getISOLanguage]]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetDeviceScreenSize])
    {
        NSString *result;
        
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getDeviceScreenSize('%@')", [BeintooDevice screenSize]]];
        
        BeintooLOG(@"Sent object to webview: %@",[NSString stringWithFormat:@"BeintooIOS.getDeviceScreenSize('%@')", [BeintooDevice screenSize]]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSLoginUser])
    {
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.loginUser()"]];
        
        if (result != nil)
        {
            SBJSON *parser	= [[SBJSON alloc] init];
            NSError *parseError		= nil;
            NSDictionary *dictionary;
            @try
            {
                dictionary = [parser objectWithString:result error:&parseError];
            }
            @catch (NSException *exception)
            {
                BeintooLOG(@"Exception while parsing the object: %@", exception);
            }
            
            if (dictionary != nil && [dictionary isKindOfClass:[NSDictionary class]]){
                BPlayerWrapper *player = [[BPlayerWrapper alloc] initWithContentOfDictionary:dictionary];
                [Beintoo setBeintooPlayer:player];

#ifdef BEINTOO_ARC_AVAILABLE
#else
                [player release];
#endif

            }
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [parser release];
#endif
            
        }
        
        BeintooLOG(@"Sent object to webview: %@",[NSString stringWithFormat:@"BeintooIOS.loginUser()"]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSLogoutUser])
    {
        [Beintoo playerLogout];
        
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.logoutUser()"]];
        
        if (result != nil)
        {
            SBJSON *parser	= [[SBJSON alloc] init];
            NSError *parseError		= nil;
            NSDictionary *dictionary;
            @try {
                
                dictionary = [parser objectWithString:result error:&parseError];
            }
            @catch (NSException *exception) {
                BeintooLOG(@"Exception while parsing the object: %@", exception);
            }
            
            if (dictionary != nil && [dictionary isKindOfClass:[NSDictionary class]]){
                BPlayerWrapper *player = [[BPlayerWrapper alloc] initWithContentOfDictionary:dictionary];
                [Beintoo setBeintooPlayer:player];
                
#ifdef BEINTOO_ARC_AVAILABLE
#else
                [player release];
#endif
                
            }
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [parser release];
#endif
            
        }
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.logoutUser()"]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetIFA])
    {
        NSDictionary *dictionary = [BCustomUrlScheme getIFAinfo];
        
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *jsonString = [jsonWriter stringWithObject:dictionary];
        
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getIFA('%@')", jsonString]];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [jsonWriter release];
#endif
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.getIFA('%@')", jsonString]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetSdkData])
    {
        NSDictionary *dictionary = [BCustomUrlScheme createSdkData];
        
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *jsonString = [jsonWriter stringWithObject:dictionary];
        
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getSdkData('%@')", jsonString]];
        
#ifdef BEINTOO_ARC_AVAILABLE
#else
        [jsonWriter release];
#endif

        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.getSdkData('%@')", jsonString]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetDeviceOSVersion])
    {
        NSNumber *version = [NSNumber numberWithFloat:[[BeintooDevice getSystemVersion] floatValue]];
        
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getDeviceOSVersion('%@')", version]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.getDeviceOSVersion('%@')", version]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetDeviceModel])
    {
        NSString *model = [BeintooDevice getDeviceType];
        
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getDeviceModel('%@')", model]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.getDeviceModel('%@')", model]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetDeviceUserAgent])
    {
        NSString *ua = [BeintooNetwork getUserAgent];
        
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getDeviceUserAgent('%@')", ua]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.getDeviceModel('%@')", ua]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGetCarrier])
    {
        NSString *carrier = [BeintooNetwork getCarrierBuiltString];
        
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.getCarrier('%@')", carrier]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.getCarrier('%@')", carrier]);
        
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSOpenUrlInExternalBrowser])
    {
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.openUrlInExternalBrowser()"]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.openUrlInExternalBrowser()"]);
        
        BeintooLOG(@"URL to opem: %@", result);
        
        if (result != nil)
        {
            SBJSON *parser	= [[SBJSON alloc] init];
            NSError *parseError		= nil;
            NSDictionary *dictionary;
            @try {
                
                dictionary = [parser objectWithString:result error:&parseError];
            }
            @catch (NSException *exception) {
                BeintooLOG(@"Exception while parsing the object: %@", exception);
            }
            
            if (dictionary != nil && [dictionary isKindOfClass:[NSDictionary class]]){
                if ([dictionary objectForKey:@"url"])
                {
                    NSURL *URL = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
                    
                    if ([[UIApplication sharedApplication] canOpenURL:URL])
                        [[UIApplication sharedApplication] openURL:URL];
                }
            }
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [parser release];
#endif
            
        }
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSOpenUrlInBeintooBrowser])
    {
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.openUrlInBeintooBrowser()"]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.openUrlInBeintooBrowser()"]);
        
        if (result != nil)
        {
            SBJSON *parser	= [[SBJSON alloc] init];
            NSError *parseError		= nil;
            NSDictionary *dictionary;
            @try {
                
                dictionary = [parser objectWithString:result error:&parseError];
            }
            @catch (NSException *exception) {
                BeintooLOG(@"Exception while parsing the object: %@", exception);
            }
            
            if (dictionary != nil && [dictionary isKindOfClass:[NSDictionary class]]){
                if ([dictionary objectForKey:@"url"])
                {
                    [Beintoo launchControllerWithURL:[dictionary objectForKey:@"url"]];
                }
            }
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [parser release];
#endif
            
        }
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSOpenSection])
    {
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.openSection()"]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.openSection()"]);
        
        if (result != nil)
        {
            SBJSON *parser	= [[SBJSON alloc] init];
            NSError *parseError		= nil;
            NSDictionary *dictionary;
            @try {
                
                dictionary = [parser objectWithString:result error:&parseError];
            }
            @catch (NSException *exception) {
                BeintooLOG(@"Exception while parsing the object: %@", exception);
            }
            
            if (dictionary != nil && [dictionary isKindOfClass:[NSDictionary class]]){
                if ([dictionary objectForKey:@"section"])
                {
                    [Beintoo openView:[dictionary objectForKey:@"section"] orURL:nil];
                }
            }
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [parser release];
#endif
            
        }
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSGoToUrl])
    {
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.goToUrl()"]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.goToUrl()"]);
        
        if (result != nil)
        {
            SBJSON *parser	= [[SBJSON alloc] init];
            NSError *parseError		= nil;
            NSDictionary *dictionary;
            @try {
                
                dictionary = [parser objectWithString:result error:&parseError];
            }
            @catch (NSException *exception) {
                BeintooLOG(@"Exception while parsing the object: %@", exception);
            }
            
            if (dictionary != nil && [dictionary isKindOfClass:[NSDictionary class]]){
                if ([dictionary objectForKey:@"url"])
                {
                    [Beintoo openView:nil orURL:[dictionary objectForKey:@"url"]];
                }
            }
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [parser release];
#endif
            
        }
        return NO;
    }
    else if ([BCustomUrlScheme matcherBetweenUrl:stringURL andSchemeSubPath:BUSOpenUrlInsideDashboard])
    {
        NSString *result;
        result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"BeintooIOS.openUrlInsideDashboard()"]];
        
        BeintooLOG(@"Sent object to webview: %@", [NSString stringWithFormat:@"BeintooIOS.openUrlInsideDashboard()"]);
        
        if (result != nil)
        {
            BeintooLOG(@"result %@", result);
            
            SBJSON *parser	= [[SBJSON alloc] init];
            NSError *parseError		= nil;
            NSDictionary *dictionary;
            @try {
                
                dictionary = [parser objectWithString:result error:&parseError];
            }
            @catch (NSException *exception) {
                BeintooLOG(@"Exception while parsing the object: %@", exception);
            }
            
            if (dictionary != nil && [dictionary isKindOfClass:[NSDictionary class]]){
                if ([dictionary objectForKey:@"url"])
                {
                    [Beintoo openView:nil orURL:[dictionary objectForKey:@"url"]];
                }
            }
            
#ifdef BEINTOO_ARC_AVAILABLE
#else
            [parser release];
#endif
            
        }
        return NO;
    }

    return YES;
}

@end
