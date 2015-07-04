//
//  GekoAPI.h
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 6/9/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GekoAPI : NSObject<NSURLConnectionDelegate>

@property (nonatomic, strong) NSDictionary *dicResponse;
@property (nonatomic, strong) NSArray *arrayResponse;

- (id)initWithKeys;

- (NSString *)getProfileWithUserId:(NSString *)userid;
- (void)connectWithUserId:(NSString *)userid Password:(NSString *)password AndCompletion:(void (^)(NSString *result))completion;
- (void)getProfileWithUserId:(NSString *)userid AndCompletion:(void (^)(NSString *result))completion;
- (void)getMapInfoWithCompletion:(void (^)(NSString *result))completion;
- (void)getProfileWithCompletion:(void (^)(NSString *result))completion;
- (void)getAllShopWithCompletion:(void (^)(NSString *result))completion;
- (void)initTransactionWithCompletion:(void (^)(NSString *result))completion;
- (void)askListWithCompletion:(void (^)(NSString *result))completion;
- (void)validePaymentWithToken:(NSString *)token PinCode:(NSString *)pincode AndCompletion:(void (^)(NSString *result))completion;

@end
