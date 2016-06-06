//
//  MPOAuthCredentialConcreteStore.m
//  MPOAuthConnection
//
//  Created by Karl Adam on 08.12.11.
//  Copyright 2008 matrixPointer. All rights reserved.
//

#import "MPOAuthCredentialConcreteStore.h"
#import "MPURLRequestParameter.h"

#import "MPOAuthCredentialConcreteStore+KeychainAdditions.h"
#import "NSString+URLEscapingAdditions.h"


@interface MPOAuthCredentialConcreteStore ()

@property (nonatomic, readwrite, strong) NSMutableDictionary *store;
@property (nonatomic, readwrite, strong) NSURL *baseURL;
@property (nonatomic, readwrite, strong) NSURL *authenticationURL;

@end


@implementation MPOAuthCredentialConcreteStore

- (id)initWithCredentials:(NSDictionary *)inCredentials forBaseURL:(NSURL *)inBaseURL {
	return [self initWithCredentials:inCredentials forBaseURL:inBaseURL withAuthenticationURL:inBaseURL];
}

- (id)initWithCredentials:(NSDictionary *)inCredentials forBaseURL:(NSURL *)inBaseURL withAuthenticationURL:(NSURL *)inAuthenticationURL {
	if ((self = [super init])) {
		self.store = [[NSMutableDictionary alloc] initWithDictionary:inCredentials];
		self.baseURL = inBaseURL;
		self.authenticationURL = inAuthenticationURL;
		
		self.requestToken = [self requestToken] ? [self requestToken] : [self findValueFromKeychainUsingName:kMPOAuthCredentialRequestToken];
		self.requestTokenSecret = [self findValueFromKeychainUsingName:kMPOAuthCredentialRequestTokenSecret];
		self.accessToken = [self findValueFromKeychainUsingName:kMPOAuthCredentialAccessToken];
		self.accessTokenSecret = [self findValueFromKeychainUsingName:kMPOAuthCredentialAccessTokenSecret];
		self.sessionHandle = [self findValueFromKeychainUsingName:kMPOAuthCredentialSessionHandle];
	}
	return self;
}


@synthesize store = store_;
@synthesize baseURL = baseURL_;
@synthesize authenticationURL = authenticationURL_;

#pragma mark -

- (NSString *)consumerKey {
	return [self.store objectForKey:kMPOAuthCredentialConsumerKey];
}

- (NSString *)consumerSecret {
	return [self.store objectForKey:kMPOAuthCredentialConsumerSecret];
}

- (NSString *)username {
	return [self.store objectForKey:kMPOAuthCredentialUsername];
}

- (NSString *)password {
	return [self.store objectForKey:kMPOAuthCredentialPassword];
}

- (NSString *)requestToken {
	return [self.store objectForKey:kMPOAuthCredentialRequestToken];
}

- (void)setRequestToken:(NSString *)inToken {
	if (inToken) {
		[self.store setObject:inToken forKey:kMPOAuthCredentialRequestToken];
	} else {
		[self.store removeObjectForKey:kMPOAuthCredentialRequestToken];
		[self removeValueFromKeychainUsingName:kMPOAuthCredentialRequestToken];
	}
}

- (NSString *)requestTokenSecret {
	return [self.store objectForKey:kMPOAuthCredentialRequestTokenSecret];
}

- (void)setRequestTokenSecret:(NSString *)inTokenSecret {
	if (inTokenSecret) {
		[self.store setObject:inTokenSecret forKey:kMPOAuthCredentialRequestTokenSecret];
	} else {
		[self.store removeObjectForKey:kMPOAuthCredentialRequestTokenSecret];
		[self removeValueFromKeychainUsingName:kMPOAuthCredentialRequestTokenSecret];
	}	
}

- (NSString *)accessToken {
	return [self.store objectForKey:kMPOAuthCredentialAccessToken];
}

- (void)setAccessToken:(NSString *)inToken {
	if (inToken) {
		[self.store setObject:inToken forKey:kMPOAuthCredentialAccessToken];
	} else {
		[self.store removeObjectForKey:kMPOAuthCredentialAccessToken];
		[self removeValueFromKeychainUsingName:kMPOAuthCredentialAccessToken];
	}	
}

- (NSString *)accessTokenSecret {
	return [self.store objectForKey:kMPOAuthCredentialAccessTokenSecret];
}

- (void)setAccessTokenSecret:(NSString *)inTokenSecret {
	if (inTokenSecret) {
		[self.store setObject:inTokenSecret forKey:kMPOAuthCredentialAccessTokenSecret];
	} else {
		[self.store removeObjectForKey:kMPOAuthCredentialAccessTokenSecret];
		[self removeValueFromKeychainUsingName:kMPOAuthCredentialAccessTokenSecret];
	}	
}

- (NSString *)sessionHandle {
	return [self.store objectForKey:kMPOAuthCredentialSessionHandle];
}

- (void)setSessionHandle:(NSString *)inSessionHandle {
	if (inSessionHandle) {
		[self.store setObject:inSessionHandle forKey:kMPOAuthCredentialSessionHandle];
	} else {
		[self.store removeObjectForKey:kMPOAuthCredentialSessionHandle];
		[self removeValueFromKeychainUsingName:kMPOAuthCredentialSessionHandle];
	}
}

#pragma mark -

- (NSString *)credentialNamed:(NSString *)inCredentialName {
	return [store_ objectForKey:inCredentialName];
}

- (void)setCredential:(id)inCredential withName:(NSString *)inName {
	[self.store setObject:inCredential forKey:inName];
	[self addToKeychainUsingName:inName andValue:inCredential];
}

- (void)removeCredentialNamed:(NSString *)inName {
	[self.store removeObjectForKey:inName];
	[self removeValueFromKeychainUsingName:inName];
}

- (void)discardOAuthCredentials {
	self.requestToken = nil;
	self.requestTokenSecret = nil;
	self.accessToken = nil;
	self.accessTokenSecret = nil;
	self.sessionHandle = nil;
}

#pragma mark -

- (NSString *)tokenSecret {
	NSString *tokenSecret = @"";
	
	if (self.accessToken) {
		tokenSecret = [self accessTokenSecret];
	} else if (self.requestToken) {
		tokenSecret = [self requestTokenSecret];
	}
	
	return tokenSecret;
}

- (NSString *)signingKey {
	NSString *consumerSecret = [[self consumerSecret] stringByAddingURIPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *tokenSecret = [[self tokenSecret] stringByAddingURIPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	return [NSString stringWithFormat:@"%@&%@", consumerSecret, tokenSecret];
}

#pragma mark -

- (NSString *)timestamp {
	return [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
}

- (NSString *)signatureMethod {
	return [self.store objectForKey:kMPOAuthSignatureMethod];
}

- (NSArray *)oauthParameters {
	NSMutableArray *oauthParameters = [[NSMutableArray alloc] initWithCapacity:5];	
	MPURLRequestParameter *tokenParameter = [self oauthTokenParameter];
	
	[oauthParameters addObject:[self oauthConsumerKeyParameter]];
	if (tokenParameter) [oauthParameters addObject:tokenParameter];
	[oauthParameters addObject:[self oauthSignatureMethodParameter]];
	[oauthParameters addObject:[self oauthTimestampParameter]];
	[oauthParameters addObject:[self oauthNonceParameter]];
	[oauthParameters addObject:[self oauthVersionParameter]];
	
	return oauthParameters;
}

- (void)setSignatureMethod:(NSString *)inSignatureMethod {
	[self.store setObject:inSignatureMethod forKey:kMPOAuthSignatureMethod];
}

- (MPURLRequestParameter *)oauthConsumerKeyParameter {
	MPURLRequestParameter *aRequestParameter = [[MPURLRequestParameter alloc] init];
	aRequestParameter.name = @"oauth_consumer_key";
	aRequestParameter.value = self.consumerKey;
	
	return aRequestParameter;
}

- (MPURLRequestParameter *)oauthTokenParameter {
	MPURLRequestParameter *aRequestParameter = nil;
	
	if (self.accessToken || self.requestToken) {
		aRequestParameter = [[MPURLRequestParameter alloc] init];
		aRequestParameter.name = @"oauth_token";
		
		if (self.accessToken) {
			aRequestParameter.value = self.accessToken;
		} else if (self.requestToken) {
			aRequestParameter.value = self.requestToken;
		}
	}
	
	return aRequestParameter;
}

- (MPURLRequestParameter *)oauthSignatureMethodParameter {
	MPURLRequestParameter *aRequestParameter = [[MPURLRequestParameter alloc] init];
	aRequestParameter.name = @"oauth_signature_method";
	aRequestParameter.value = self.signatureMethod;
	
	return aRequestParameter;
}

- (MPURLRequestParameter *)oauthTimestampParameter {
	MPURLRequestParameter *aRequestParameter = [[MPURLRequestParameter alloc] init];
	aRequestParameter.name = @"oauth_timestamp";
	aRequestParameter.value = self.timestamp;
	
	return aRequestParameter;
}

- (MPURLRequestParameter *)oauthNonceParameter {
	MPURLRequestParameter *aRequestParameter = [[MPURLRequestParameter alloc] init];
	aRequestParameter.name = @"oauth_nonce";
	
	NSString *generatedNonce = nil;
	CFUUIDRef generatedUUID = CFUUIDCreate(kCFAllocatorDefault);
	
	generatedNonce = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, generatedUUID);
	CFRelease(generatedUUID);
	
	aRequestParameter.value = generatedNonce;
	
	return aRequestParameter;
}

- (MPURLRequestParameter *)oauthVersionParameter {
	MPURLRequestParameter *versionParameter = [self.store objectForKey:@"versionParameter"];
	
	if (!versionParameter) {
		versionParameter = [[MPURLRequestParameter alloc] init];
		versionParameter.name = @"oauth_version";
		versionParameter.value = @"1.0";
	}
	
	return versionParameter;
}

@end