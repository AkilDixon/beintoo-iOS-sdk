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

#import "BeintooUser.h"
#import "Beintoo.h"

NSString *GIVE_1_BEDOLLAR = @"GIVE_BEDOLLARS_1";
NSString *GIVE_2_BEDOLLAR = @"GIVE_BEDOLLARS_2";
NSString *GIVE_5_BEDOLLAR = @"GIVE_BEDOLLARS_5";

@implementation BeintooUser

@synthesize delegate, parser, callingDelegate, userParams, showGiveBedollarsNotification, notificationPosition;

- (id)init
{
	if (self = [super init])
	{
        parser          = [[Parser alloc] init];
		parser.delegate = self;
		rest_resource   = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/user/",[Beintoo getRestBaseUrl]]];
        app_rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/app/",[Beintoo getRestBaseUrl]]];
    }
    return self;
}

- (NSString *)restResource
{
	return rest_resource;
}

- (NSString *)appRestResource
{
	return app_rest_resource;
}

+ (void)setUserDelegate:(id)_caller
{
	BeintooUser *userService = [Beintoo beintooUserService];
	userService.delegate = _caller;
}

+ (void)setDelegate:(id)_delegate
{
	BeintooUser *userService = [Beintoo beintooUserService];
	userService.delegate = _delegate;
}

#pragma mark -
#pragma mark API

- (void)getUser
{	
	NSString *userExt = [Beintoo getUserID];
	if (userExt == nil) {
		return;
	}
	NSString *res		 = [NSString stringWithFormat:@"%@%@",rest_resource,userExt];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GUSER_CALLER_ID];
}

- (void)getUserByM:(NSString *)m andP:(NSString *)p
{
	NSString *res		 = [NSString stringWithFormat:@"%@byemail/",rest_resource];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            m, @"email",
                            p, @"password", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GUSERBYMP_CALLER_ID];
}

- (void)getUserByUDID
{
	NSString *res		 = [NSString stringWithFormat:@"%@bydeviceUDID/%@/",rest_resource,[BeintooDevice getUDID]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey],
                            @"apikey", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GUSERBYUDID_CALLER_ID];	
}

- (void)removeUDIDConnectionFromUserID:(NSString *)userID
{
	NSString *res		 = [NSString stringWithFormat:@"%@removeUDID/%@/%@/", rest_resource, [BeintooDevice getUDID], userID];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey], @"apikey",
                            nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_REMOVEUDID_CALLER_ID];		
}

- (void)getBalanceFrom:(int)start andRowns:(int)numOfRows
{
	NSString *userID	 = [Beintoo getUserID];
	NSString *res		 = [NSString stringWithFormat:@"%@balance/%@/?start=%d&rows=%d",rest_resource,userID,start,numOfRows];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GETBALANCE_CALLER_ID];		
}

- (void)getUsersByQuery:(NSString *)query andSkipFriends:(BOOL)skip
{
	NSString *userID	 = [Beintoo getUserID];
	NSString *res;
	if (skip) 
		res		 = [NSString stringWithFormat:@"%@byquery?query=%@&userExt=%@&skipFriends=true",rest_resource,query,userID];
	else
		res		 = [NSString stringWithFormat:@"%@byquery?query=%@&userExt=%@&skipFriends=false",rest_resource,query,userID];
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GETBYQUERY_CALLER_ID];			
}

- (void)registerUserToGuid:(NSString *)_guid withEmail:(NSString *)_email nickname:(NSString *)_nick password:(NSString *)_pass name:(NSString *)_name
					  country:(NSString *)_country address:(NSString *)_address gender:(NSString *)_gender sendGreetingsEmail:(BOOL)_sendGreet
{		
	if (_guid == nil) {
		BeintooLOG(@"* Beintoo * RegisterUser error: no guid provided.");
		return;
	}
	if (_email == nil) {
		BeintooLOG(@"* Beintoo * RegisterUser error: email not provided.");
		return;
	}
	int userGender;
	
	if([_gender isEqualToString:@"MALE"])
		userGender = 1;
	else if ([_gender isEqualToString:@"FEMALE"]) 
		userGender = 2;
	else
		userGender = 0;
	
	NSString *httpBody;
	if(!userGender)
		httpBody = [NSString stringWithFormat:@"email=%@",_email];
	else
		httpBody = [NSString stringWithFormat:@"email=%@&gender=%d",_email,userGender];
	
	if (_nick != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&nickname=%@",_nick]];
	if (_pass != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&password=%@",_pass]];
	if (_name != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&name=%@",_name]];
	if (_country != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&country=%@",_country]];
	if (_address != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&address=%@",_address]];
	if(_sendGreet)
		httpBody = [httpBody stringByAppendingString:@"&sendGreetingsEmail=true"];
	else
		httpBody = [httpBody stringByAppendingString:@"&sendGreetingsEmail=false"];
    
    httpBody = [httpBody stringByAppendingFormat:@"&skipOnExists=true&allowAttach=true"];
	
	NSString *res			 = [NSString stringWithFormat:@"%@set", rest_resource];
	NSDictionary *params	 = [NSDictionary dictionaryWithObjectsAndKeys:
                                [Beintoo getApiKey], @"apikey",
                                _guid, @"guid",
                                nil];
    
	[parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_REGISTER_CALLER_ID];
}

- (void)backgroundRegisterUserToGuid:(NSString *)_guid withEmail:(NSString *)_email nickname:(NSString *)_nick password:(NSString *)_pass name:(NSString *)_name
                   country:(NSString *)_country address:(NSString *)_address gender:(NSString *)_gender sendGreetingsEmail:(BOOL)_sendGreet
{   
    BeintooUser *userService = [Beintoo beintooUserService];
    
    if (_guid == nil) {
        
        userService.userParams = [[NSMutableDictionary alloc] init];
        if (_guid != nil)
            [userService.userParams setObject:[_guid copy] forKey:@"guid"];
        if (_email != nil)
            [userService.userParams setObject:[_email copy] forKey:@"email"];
        if (_nick != nil)
            [userService.userParams setObject:[_nick copy] forKey:@"nick"];
        if (_pass != nil)
            [userService.userParams setObject:[_pass copy] forKey:@"pass"];
        if (_name != nil)
            [userService.userParams setObject:[_name copy] forKey:@"name"];
        if (_address != nil)
            [userService.userParams setObject:[_address copy] forKey:@"address"];
        if (_gender != nil)
            [userService.userParams setObject:[_gender copy] forKey:@"gender"];
        if (_country != nil)
            [userService.userParams setObject:[_country copy] forKey:@"country"];
        if (_sendGreet)
            [userService.userParams setObject:[NSNumber numberWithBool:_sendGreet] forKey:@"sendGreetings"];
        
        [BeintooPlayer setPlayerDelegate:self];
        [BeintooPlayer login];
        
		return;
	}
    
	if (_email == nil) {
		BeintooLOG(@"* Beintoo * RegisterUser error: email not provided.");
        
        if ([[self delegate] respondsToSelector:@selector(didNotCompleteBackgroundRegistration)]) 
            [[self delegate] didNotCompleteBackgroundRegistration];
        
        return;
	}
	int userGender;
	
	if([_gender isEqualToString:@"MALE"])
		userGender = 1;
	else if ([_gender isEqualToString:@"FEMALE"]) 
		userGender = 2;
	else
		userGender = 0;
	
	NSString *httpBody;
	if(!userGender)
		httpBody = [NSString stringWithFormat:@"email=%@",_email];
	else
		httpBody = [NSString stringWithFormat:@"email=%@&gender=%d",_email,userGender];
	
	if (_nick != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&nickname=%@",_nick]];
	if (_pass != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&password=%@",_pass]];
	if (_name != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&name=%@",_name]];
	if (_country != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&country=%@",_country]];
	if (_address != nil) 
		httpBody = [httpBody stringByAppendingString:[NSString stringWithFormat:@"&address=%@",_address]];
	if(_sendGreet)
		httpBody = [httpBody stringByAppendingString:@"&sendGreetingsEmail=true"];
	else
		httpBody = [httpBody stringByAppendingString:@"&sendGreetingsEmail=false"];
	
	NSString *res			 = [NSString stringWithFormat:@"%@set", userService.restResource];
	NSDictionary *params	 = [NSDictionary dictionaryWithObjectsAndKeys:
                                [Beintoo getApiKey], @"apikey",
                                _guid, @"guid", 
                                nil];
	
	[parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_BACKGROUND_REGISTER_CALLER_ID];
    
}

- (void)updateUser:(NSString *)_userExt withNickname:(NSString *)_nick
{
	if(_userExt == nil){
		return;
	}	
	NSString *httpBody = @"";
	if (_nick != nil){
		httpBody = [NSString stringWithFormat:@"nickname=%@",_nick];
	}
	
	NSString *res			 = [NSString stringWithFormat:@"%@update",rest_resource];
	NSDictionary *params	 = [NSDictionary dictionaryWithObjectsAndKeys:
                                [Beintoo getApiKey], @"apikey",
                                _userExt, @"userExt", 
                                nil];	
    
	[parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_NICKUPDATE_CALLER_ID];
}

- (void)forgotPassword:(NSString *)email
{    
    NSString *res		 = [NSString stringWithFormat:@"%@forgotpassword", rest_resource];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [Beintoo getApiKey], @"apikey",
                                   nil];
    
    NSString *httpBody = [NSString stringWithFormat:@"email=%@", email];
    
    [parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_FORGOT_PASSWORD_CALLER_ID];
}

#pragma mark -
#pragma mark parser delegate response

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID
{
	switch (callerID){
		case USER_GUSER_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didGetUser:)]) {
				[[self delegate] didGetUser:result];
			}
		}
			break;
			
		case USER_GUSERBYMP_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didGetUserByMail:)]) {
				[[self delegate] didGetUserByMail:result];
			}
			//BeintooLOG(@"getUserByUDID result: %@",result);
		}
			break;
		
		case USER_GUSERBYUDID_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didGetUserByUDID:)]) {
				[[self delegate] didGetUserByUDID:(NSMutableArray *)result];
			}
			//BeintooLOG(@"getUserByUDID result: %@",result);
		}
			break;
			
		case USER_REMOVEUDID_CALLER_ID:{
			//BeintooLOG(@"remove UDID result: %@",result);
		}
			break;

		case USER_GETBALANCE_CALLER_ID:{
			//BeintooLOG(@"getBalance result: %@",result);
			if ([[self delegate]respondsToSelector:@selector(didGetBalance:)]) {
				[[self delegate]didGetBalance:(NSMutableArray *)result];
			}
		}
			break;

		case USER_GETBYQUERY_CALLER_ID:{
			//BeintooLOG(@"getBalance result: %@",result);
			if ([[self delegate]respondsToSelector:@selector(didGetUserByQuery:)]) {
				[[self delegate]didGetUserByQuery:(NSMutableArray *)result];
			}
		}
			break;
			
		case USER_REGISTER_CALLER_ID:{
			if ([result objectForKey:@"message"] != nil) {
				BeintooLOG(@"Beintoo: error in user registration: %@", [result objectForKey:@"message"]);
            }
            if ([[self delegate]respondsToSelector:@selector(didCompleteRegistration:)]) 
                [[self delegate]didCompleteRegistration:result];
		}
			break;
            
        case USER_BACKGROUND_REGISTER_CALLER_ID:{
            
            if ([result objectForKey:@"id"]){
            
                BeintooPlayer *_player = [Beintoo beintooPlayerService];
                [_player setDelegate:self];
                
                NSString *newUserID = [result objectForKey:@"id"];
                
                if (newUserID != nil) {
                    [_player backgroundLogin:newUserID];
                }
            }
            else {
                BeintooLOG(@"Beintoo: error in user registration: %@",[result objectForKey:@"message"]);
                if ([[self delegate] respondsToSelector:@selector(didNotCompleteBackgroundRegistration)]) 
                    [[self delegate] didNotCompleteBackgroundRegistration];
            }
        }
            break;
			
		case USER_NICKUPDATE_CALLER_ID:{
			if ([result objectForKey:@"message"] != nil) {
				BeintooLOG(@"Beintoo: error in user registration: %@",[result objectForKey:@"message"]);
            }
            if ([[self delegate]respondsToSelector:@selector(didCompleteUserNickUpdate:)]) 
                [[self delegate]didCompleteUserNickUpdate:result];
		}
			break;
            
        case USER_FORGOT_PASSWORD_CALLER_ID:{
            
            if ([[self delegate]respondsToSelector:@selector(didCompleteForgotPassword:)]) 
                [[self delegate] didCompleteForgotPassword:result];
		}
			break;
			
		default:{
			//statements
		}
			break;
	}	
}

- (void)playerDidLoginWithResult:(NSDictionary *)result
{	
    BeintooUser *userService = [Beintoo beintooUserService];
    [BeintooUser setUserDelegate:userService.callingDelegate];
    
    NSString *_email = nil;
    NSString *_nick = nil;
    NSString *_pass = nil;
    NSString *_address = nil;
    NSString *_name = nil;
    NSString *_gender = nil;
    NSString *_country = nil;
    BOOL _sendGreeting;    
    
    if ([userService.userParams objectForKey:@"email"])
        _email = [userService.userParams objectForKey:@"email"];
    if ([userService.userParams objectForKey:@"name"])
        _name = [userService.userParams objectForKey:@"name"];
    if ([userService.userParams objectForKey:@"pass"])
        _pass = [userService.userParams objectForKey:@"pass"];
    if ([userService.userParams objectForKey:@"nick"])
        _nick = [userService.userParams objectForKey:@"nick"];
    if ([userService.userParams objectForKey:@"address"])
        _address = [userService.userParams objectForKey:@"address"];
    if ([userService.userParams objectForKey:@"gender"])
        _gender = [userService.userParams objectForKey:@"gender"];
    if ([userService.userParams objectForKey:@"country"])
        _country = [userService.userParams objectForKey:@"country"];
    if ([userService.userParams objectForKey:@"sendGreetings"])
        _sendGreeting = (BOOL) [userService.userParams objectForKey:@"sendGreetings"];
    
    [self backgroundRegisterUserToGuid:[Beintoo getPlayerID] withEmail:_email nickname:_nick password:_pass name:_name country:_country address:_address gender:_address sendGreetingsEmail:_sendGreeting];
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [userService.userParams release];
#endif    
    
}

- (void)playerDidCompleteBackgroundLogin:(NSDictionary *)result
{    
    if ([[self delegate] respondsToSelector:@selector(didCompleteBackgroundRegistration:)]) 
        [[self delegate] didCompleteBackgroundRegistration:result];
     
}

- (void)playerDidNotCompleteBackgroundLogin
{    
    if ([[self delegate] respondsToSelector:@selector(didNotCompleteBackgroundRegistration)]) 
        [[self delegate] didNotCompleteBackgroundRegistration];
   
}

- (void)playerDidFailLoginWithResult:(NSString *)error
{
	BeintooLOG(@"playerLogin error: %@", error);
}

- (NSString *)getStatusCode:(int)code
{
	if (code == CHALLENGES_TO_BE_ACCEPTED) {
		return @"TO_BE_ACCEPTED";
	}else if (code == CHALLENGES_STARTED) {
		return @"STARTED";
	}else if (code == CHALLENGES_ENDED) {
		return @"ENDED";
	}else {
		return @"TO_BE_ACCEPTED";
	}	
}

- (void)dealloc {
    parser.delegate = nil;
  
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[parser release];
	[rest_resource release];
    [app_rest_resource release];
    [super dealloc];
#endif
    
}

@end
