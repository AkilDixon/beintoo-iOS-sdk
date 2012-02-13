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

@implementation BeintooUser

@synthesize delegate,parser;

-(id)init {
	if (self = [super init])
	{
        parser = [[Parser alloc] init];
		parser.delegate = self;
		rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/user/",[Beintoo getRestBaseUrl]]];
	}
    return self;
}

#pragma mark -
#pragma mark API

- (void)getUser{
	
	NSString *userExt = [Beintoo getUserID];
	if (userExt == nil) {
		return;
	}
	NSString *res		 = [NSString stringWithFormat:@"%@%@",rest_resource,userExt];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GUSER_CALLER_ID];
}

- (void)getUserByM:(NSString *)m andP:(NSString *)p{	
	NSString *res		 = [NSString stringWithFormat:@"%@byemail/",rest_resource];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey",m,@"email",p,@"password", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GUSERBYMP_CALLER_ID];
}

- (void)getUserByUDID{
	NSString *res		 = [NSString stringWithFormat:@"%@bydeviceUDID/%@/",rest_resource,[BeintooDevice getUDID]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GUSERBYUDID_CALLER_ID];	
}

- (void)showChallengesbyStatus:(int)status{
	NSString *res		 = [NSString stringWithFormat:@"%@challenge/show/%@/%@/",rest_resource,
							[Beintoo getUserID], [self getStatusCode:status]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_SHOWCHALLENGES_CALLER_ID];
}
- (void)challengeRequestfrom:(NSString *)userIDFrom	to:(NSString *)userIDTo withAction:(NSString *)action forContest:(NSString *)contest withBedollarsToBet:(NSString *)_bedollars andScoreToReach:(NSString *)_scoreToReach forKindOfChallenge:(NSString *)_challengeKind andActor:(NSString *)actor{
	
    NSString *res		 = [NSString stringWithFormat:@"%@challenge/%@/%@/%@",rest_resource,userIDFrom,action,userIDTo];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey",contest,@"codeID", nil];
    
    if(_bedollars != nil){
        res = [res stringByAppendingString:[NSString stringWithFormat:@"?bet=%@",_bedollars]];
    }
    if (_scoreToReach != nil) {
        res = [res stringByAppendingString:[NSString stringWithFormat:@"&score=%@",_scoreToReach]];
    }
    if (actor != nil) {
        res = [res stringByAppendingString:[NSString stringWithFormat:@"&userActor=%@",actor]];
    }
    if (_challengeKind != nil) {
        res = [res stringByAppendingString:[NSString stringWithFormat:@"&kind=%@",_challengeKind]];
    }
    
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_CHALLENGEREQ_CALLER_ID];
}

- (void)getChallangePrereequisitesFromUser:(NSString *)userIDFrom toUser:(NSString *)userIDTo forContest:(NSString *)codeID{
	NSString *res		 = [NSString stringWithFormat:@"%@challenge/%@/PREREQUISITE/%@",rest_resource,userIDFrom,userIDTo];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", codeID, @"codeID", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_CHALLENGEPREREQ_CALLER_ID];  
}
- (void)getFriendsByExtid{
	NSString *res		 = [NSString stringWithFormat:@"%@friend/%@/",rest_resource,[Beintoo getUserID]];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GFRIENDS_CALLER_ID];	
}

- (void)removeUDIDConnectionFromUserID:(NSString *)userID{
	NSString *res		 = [NSString stringWithFormat:@"%@removeUDID/%@/%@/",rest_resource,[BeintooDevice getUDID],userID];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey", nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_REMOVEUDID_CALLER_ID];		
}

- (void)getBalanceFrom:(int)start andRowns:(int)numOfRows{
	NSString *userID	 = [Beintoo getUserID];
	NSString *res		 = [NSString stringWithFormat:@"%@balance/%@/?start=%d&rows=%d",rest_resource,userID,start,numOfRows];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GETBALANCE_CALLER_ID];		
}

- (void)getUsersByQuery:(NSString *)query andSkipFriends:(BOOL)skip{
	NSString *userID	 = [Beintoo getUserID];
	NSString *res;
	if (skip) 
		res		 = [NSString stringWithFormat:@"%@byquery?query=%@&userExt=%@&skipFriends=true",rest_resource,query,userID];
	else
		res		 = [NSString stringWithFormat:@"%@byquery?query=%@&userExt=%@&skipFriends=false",rest_resource,query,userID];
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GETBYQUERY_CALLER_ID];			
}

- (void)sendFriendshipRequestTo:(NSString *)toUserExt{
	NSString *myUserExt	 = [Beintoo getUserID];
	NSString *res = [NSString stringWithFormat:@"%@friendshiprequest/%@/invite/%@",rest_resource,myUserExt,toUserExt];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_SENDFRIENDSHIP_CALLER_ID];			
}

- (void)getFriendRequests{
	NSString *myUserExt	 = [Beintoo getUserID];
	NSString *res = [NSString stringWithFormat:@"%@friendshiprequest/%@",rest_resource,myUserExt];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_GETFRIENDSHIP_CALLER_ID];				
}

- (void)replyToFriendshipRequestWithAnswer:(NSInteger)answer toUser:(NSString *)toUserExt{
	NSString *myUserExt	 = [Beintoo getUserID];
	NSString *res;
	if (answer == USER_ACCEPT_FRIENDSHIP) {
		res	= [NSString stringWithFormat:@"%@friendshiprequest/%@/accept/%@",rest_resource,myUserExt,toUserExt];
	}
	else
		res = [NSString stringWithFormat:@"%@friendshiprequest/%@/ignore/%@",rest_resource,myUserExt,toUserExt];

	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey],@"apikey",nil];
	[parser parsePageAtUrl:res withHeaders:params fromCaller:USER_SENDFRIENDSHIP_CALLER_ID];				
}

- (void)registerUserToGuid:(NSString *)_guid withEmail:(NSString *)_email nickname:(NSString *)_nick password:(NSString *)_pass name:(NSString *)_name
					  country:(NSString *)_country address:(NSString *)_address gender:(NSString *)_gender sendGreetingsEmail:(BOOL)_sendGreet{
		
	if (_guid == nil) {
		NSLog(@"* Beintoo * RegisterUser error: no guid provided.");
		return;
	}
	if (_email == nil) {
		NSLog(@"* Beintoo * RegisterUser error: email not provided.");
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
	
	NSString *res			 = [NSString stringWithFormat:@"%@set",rest_resource];
	NSDictionary *params	 = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey",_guid,@"guid", nil];	
	[parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_REGISTER_CALLER_ID];
}

- (void)updateUser:(NSString *)_userExt withNickname:(NSString *)_nick{
	if(_userExt == nil){
		return;
	}	
	NSString *httpBody = @"";
	if (_nick != nil){
		httpBody = [NSString stringWithFormat:@"nickname=%@",_nick];
	}
	
	NSString *res			 = [NSString stringWithFormat:@"%@update",rest_resource];
	NSDictionary *params	 = [NSDictionary dictionaryWithObjectsAndKeys:[Beintoo getApiKey], @"apikey",_userExt,@"userExt", nil];	
	[parser parsePageAtUrlWithPOST:res withHeaders:params withHTTPBody:httpBody fromCaller:USER_NICKUPDATE_CALLER_ID];
}


#pragma mark -
#pragma mark parser delegate response

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID{	
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
			//NSLog(@"getUserByUDID result: %@",result);
		}
			break;
		
		case USER_GUSERBYUDID_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didGetUserByUDID:)]) {
				[[self delegate] didGetUserByUDID:(NSMutableArray *)result];
			}
			//NSLog(@"getUserByUDID result: %@",result);
		}
			break;
			
		case USER_SHOWCHALLENGES_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didShowChallengesByStatus:)]) {
				[[self delegate] didShowChallengesByStatus:(NSMutableArray *)result];
			}
			//NSLog(@"showChallenges result: %@",result);
		}
			break;
		
        case USER_CHALLENGEPREREQ_CALLER_ID:{
            if ([[self delegate] respondsToSelector:@selector(didGetChallangePrerequisites:)]) {
				[[self delegate] didGetChallangePrerequisites:(NSDictionary *)result];
			}
        }
			break;

		case USER_CHALLENGEREQ_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(challengeRequestFinishedWithResult:)]) {
				[[self delegate] challengeRequestFinishedWithResult:result];
			}
			NSLog(@"challenge req result: %@",result);
		}
			break;
			
		case USER_GFRIENDS_CALLER_ID:{
			if ([[self delegate] respondsToSelector:@selector(didGetFriendsByExtid:)]) {
				[[self delegate] didGetFriendsByExtid:(NSMutableArray *)result];
			}
			//NSLog(@"getfriends req result: %@",result);
		}
			break;
			
		case USER_REMOVEUDID_CALLER_ID:{
			//NSLog(@"remove UDID result: %@",result);
		}
			break;

		case USER_GETBALANCE_CALLER_ID:{
			//NSLog(@"getBalance result: %@",result);
			if ([[self delegate]respondsToSelector:@selector(didGetBalance:)]) {
				[[self delegate]didGetBalance:(NSMutableArray *)result];
			}
		}
			break;

		case USER_GETBYQUERY_CALLER_ID:{
			//NSLog(@"getBalance result: %@",result);
			if ([[self delegate]respondsToSelector:@selector(didGetUserByQuery:)]) {
				[[self delegate]didGetUserByQuery:(NSMutableArray *)result];
			}
		}
			break;
			
		case USER_SENDFRIENDSHIP_CALLER_ID:{
			//NSLog(@"send friend request result: %@",result);
			if ([[self delegate]respondsToSelector:@selector(didGetFriendRequestResponse:)]) {
				[[self delegate]didGetFriendRequestResponse:result];
			}
		}
			break;
			
		case USER_GETFRIENDSHIP_CALLER_ID:{
			//NSLog(@"get friend request result: %@",result);
			if ([[self delegate]respondsToSelector:@selector(didGetFriendRequests:)]) {
				[[self delegate]didGetFriendRequests:(NSMutableArray *)result];
			}
		}
			break;
			
		case USER_REGISTER_CALLER_ID:{
			if ([result objectForKey:@"message"] != nil) {
				NSLog(@"Beintoo: error in user registration: %@",[result objectForKey:@"message"]);
            }
            if ([[self delegate]respondsToSelector:@selector(didCompleteRegistration:)]) 
                [[self delegate]didCompleteRegistration:result];
		}
			break;
			
		case USER_NICKUPDATE_CALLER_ID:{
			if ([result objectForKey:@"message"] != nil) {
				NSLog(@"Beintoo: error in user registration: %@",[result objectForKey:@"message"]);
            }
            if ([[self delegate]respondsToSelector:@selector(didCompleteUserNickUpdate:)]) 
                [[self delegate]didCompleteUserNickUpdate:result];
		}
			break;
			
		default:{
			//statements
		}
			break;
	}	
}

- (NSString *)getStatusCode:(int)code{
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
	[parser release];
	[rest_resource release];
    [super dealloc];
}


@end
