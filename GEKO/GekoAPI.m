//
//  GekoAPI.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 6/9/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

#import <QuartzCore/QuartzCore.h>
#import <AFNetworking/AFNetworking.h>

#import "GekoAPI.h"

@implementation GekoAPI {
    NSString *pinKey;
    NSString *commonKey;
}

@synthesize dicResponse = _dicResponse;
@synthesize arrayResponse = _arrayResponse;

#pragma mark - API

- (id)initWithKeys{
    if (self = [super init]) {
        commonKey = @"!gekowsstringscrpretpourenvoi2sRetourALaLigne?";
        pinKey = @"1REfdGRTOPc984^mmlf FPE40+877432FDFN VPEd3d1)";
    }
    return self;
}

/** connection **/
- (void)connectWithUserId:(NSString *)userid Password:(NSString *)password AndCompletion:(void (^)(NSString *result))completion
{
    NSString *encodedPassword = [self encodeWithHmacsha1:pinKey :password];
    encodedPassword = [encodedPassword lowercaseString];
    
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    
    NSString *signature = [NSString stringWithFormat:@"%@%@%@%ld", userid, encodedPassword, commonKey, unixTime];
    NSString *encodedSignature = [self encodeWithHmacsha1:commonKey :signature];
    
    NSString *completeRequestUrl = [NSString stringWithFormat:@"http://5.135.166.171:8080/geko-manager/rest/membres/connection/%@/%@/%ld/%@", userid, encodedPassword, unixTime, encodedSignature];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager GET:completeRequestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dicResponse = [[NSDictionary alloc] init];
        self.dicResponse = (NSDictionary *)responseObject;
        NSString *results;
        if ([[self.dicResponse objectForKey:@"id"] intValue] > 1) {
            results = @"OK";
        } else {
            results = @"Array empty";
        }
        if (completion)
            completion(results);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *results = [NSString stringWithFormat:@"%@", error];
        if (completion)
            completion(results);
    }];
}

/** profil utilisateur **/
- (NSString *)getProfileWithUserId:(NSString *)userid {
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    
    NSString *signature = [NSString stringWithFormat:@"%@%@%ld", @"51", commonKey, unixTime];
    NSString *encodedSignature = [self encodeWithHmacsha1:commonKey :signature];
    encodedSignature = [encodedSignature lowercaseString];
    
    NSString *finalURL = [NSString stringWithFormat:@"http://5.135.166.171:8080/geko-manager/rest/membres/profile/51/%ld/%@", unixTime, encodedSignature];
    
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *rep = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return rep;
}
- (void)getProfileWithUserId:(NSString *)userid AndCompletion:(void (^)(NSString *result))completion
{
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    
    NSString *signature = [NSString stringWithFormat:@"%@%@%ld", @"51", commonKey, unixTime];
    NSString *encodedSignature = [self encodeWithHmacsha1:commonKey :signature];
    encodedSignature = [encodedSignature lowercaseString];
    
    NSString *completeRequestUrl = [NSString stringWithFormat:@"http://5.135.166.171:8080/geko-manager/rest/membres/profile/51/%ld/%@", unixTime, encodedSignature];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager GET:completeRequestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dicResponse = [[NSDictionary alloc] init];
        self.dicResponse = (NSDictionary *)responseObject;
        NSString *results;
        results = [self.dicResponse objectForKey:@"message"];
        if (completion)
            completion(results);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *results = [NSString stringWithFormat:@"%@", error];
        if (completion)
            completion(results);
    }];
}

/** information map **/
- (void)getMapInfoWithCompletion:(void (^)(NSString *result))completion
{
    NSString *completeRequestUrl = @"https://5.135.166.171:8443/geko-manager/rest/pointdeventes/sign";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager GET:completeRequestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.arrayResponse = [[NSArray alloc] init];
        self.arrayResponse = (NSArray *)responseObject;
        NSString *results;
        if ([self.arrayResponse count] > 1) {
            results = @"OK";
        } else {
            results = @"Array empty";
        }
        if (completion)
            completion(results);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *results = [NSString stringWithFormat:@"%@", error];
        if (completion)
            completion(results);
    }];
}

/** Profil validé **/
- (void)getProfileWithCompletion:(void (^)(NSString *result))completion
{
    NSString *key = @"!gekowsstringscrpretpourenvoi2sRetourALaLigne?";
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    
    NSString *signature = [NSString stringWithFormat:@"%@%@%ld", @"51", key, unixTime];
    NSString *encodedSignature = [self encodeWithHmacsha1:key :signature];
    encodedSignature = [encodedSignature lowercaseString];
    
    NSString *completeRequestUrl = [NSString stringWithFormat:@"http://5.135.166.171:8080/geko-manager/rest/membres/profile/51/%ld/%@", unixTime, encodedSignature];
        
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:completeRequestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dicResponse = [[NSDictionary alloc] init];
        self.dicResponse = (NSDictionary *)responseObject;
        NSString *results = [self.dicResponse objectForKey:@"message"];
        if (completion)
            completion(results);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *results = [NSString stringWithFormat:@"%@", error];
        if (completion)
            completion(results);
    }];
}

/** liste points de vente **/
- (void)getAllShopWithCompletion:(void (^)(NSString *result))completion
{
    NSString *completeRequestUrl = @"https://5.135.166.171:8443/geko-manager/rest/pointdeventes/sign";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager GET:completeRequestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.arrayResponse = [[NSArray alloc] init];
        self.arrayResponse = (NSArray *)responseObject;
        NSString *results;
        if ([self.arrayResponse count] > 1) {
            results = @"OK";
        } else {
            results = @"Array empty";
        }
        if (completion)
            completion(results);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *results = [NSString stringWithFormat:@"%@", error];
        if (completion)
            completion(results);
    }];
}

/** étapes transactions **/
- (void)initTransactionWithCompletion:(void (^)(NSString *result))completion
{
    NSString *completeRequestUrl = [NSString stringWithFormat:@"http://5.135.166.171:8080/geko-manager/rest/autorisations/demande/token/6/51"];
    
    //NSLog([NSString stringWithFormat:@"STEP 1: %@", completeRequestUrl]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:completeRequestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dicResponse = [[NSDictionary alloc] init];
        self.dicResponse = (NSDictionary *)responseObject;
        NSString *results = [self.dicResponse objectForKey:@"id"];
        if (completion)
            completion(results);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *results = [NSString stringWithFormat:@"%@", error];
        if (completion)
            completion(results);
    }];
}

- (void)askListWithCompletion:(void (^)(NSString *result))completion
{
    NSString *completeRequestUrl = [NSString stringWithFormat:@"http://5.135.166.171:8080/geko-manager/rest/autorisations/liste/token/51/0"];
    
    //NSLog([NSString stringWithFormat:@"STEP 2: %@", completeRequestUrl]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:completeRequestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dicResponse = [[NSDictionary alloc] init];
        self.dicResponse = (NSDictionary *)responseObject;
        NSString *results = [self.dicResponse objectForKey:@"status"];
        if (completion)
            completion(results);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *results = [NSString stringWithFormat:@"%@", error];
        if (completion)
            completion(results);
    }];
}

- (void)validePaymentWithToken:(NSString *)token PinCode:(NSString *)pincode AndCompletion:(void (^)(NSString *result))completion
{
    NSString *key = @"1REfdGRTOPc984^mmlf FPE40+877432FDFN VPEd3d1)";
    NSString *signature = [NSString stringWithFormat:@"%@", @"1234"];
    NSString *encodedSignature = [self encodeWithHmacsha1:key :signature];
    encodedSignature = [encodedSignature lowercaseString];
    
    NSString *completeRequestUrl = [NSString stringWithFormat:@"http://5.135.166.171:8080/geko-manager/rest/autorisations/finaliser/paiement/%@/%@", token, encodedSignature];
    //NSLog([NSString stringWithFormat:@"STEP 3: %@", completeRequestUrl]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:completeRequestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dicResponse = [[NSDictionary alloc] init];
        self.dicResponse = (NSDictionary *)responseObject;
        NSString *results = [self.dicResponse objectForKey:@"status"];
        if (completion)
            completion(results);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *results = [NSString stringWithFormat:@"%@", error];
        if (completion)
            completion(results);
    }];
}

#pragma mark - Crypto

- (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *base64String = [HMAC base64EncodedStringWithOptions:0];
    
    return base64String;
}

- (NSString *)encodeWithHmacsha1:(NSString *)k0 :(NSString *)m0
{
    const char *cKey  = [k0 cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [m0 cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *s = [NSString  stringWithFormat:
                   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                   cHMAC[0], cHMAC[1], cHMAC[2], cHMAC[3], cHMAC[4],
                   cHMAC[5], cHMAC[6], cHMAC[7],
                   cHMAC[8], cHMAC[9], cHMAC[10], cHMAC[11], cHMAC[12],
                   cHMAC[13], cHMAC[14], cHMAC[15],
                   cHMAC[16], cHMAC[17], cHMAC[18], cHMAC[19]
                   ];
    return s;
}

@end
