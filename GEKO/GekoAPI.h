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

- (void)connectWithUserId:(NSString *)userid Password:(NSString *)password AndCompletion:(void (^)(NSString *result))completion;
- (void)transfertFromAccount:(NSString *)userAccount ToAccount:(NSString *)destAccount WithAmount:(NSString *)amount AndCompletion:(void (^)(NSString *result))completion;
- (void)offerFromAccount:(NSString *)userAccount ToAccount:(NSString *)destAccount WithAmount:(NSString *)amount AndCompletion:(void (^)(NSString *result))completion;
- (void)getDestWithUserId:(NSString *)userid AndCompletion:(void (^)(NSString *result))completion;
- (void)getProfileWithUserId:(NSString *)userid AndCompletion:(void (^)(NSString *result))completion;
- (void)getMapInfoWithCompletion:(void (^)(NSString *result))completion;
- (void)getAllBeaconEventWithCompletion:(void (^)(NSString *result))completion;
- (void)getAllShopWithCompletion:(void (^)(NSString *result))completion;
- (void)initTransactionWithUserid:(NSString *)userid Sellingpoint:(NSString *)sellingpoint Completion:(void (^)(NSString *result))completion;
- (void)askListWithUserid:(NSString *)userid Token:(NSString *)token Completion:(void (^)(NSString *result))completion;
- (void)validePaymentWithToken:(NSString *)token PinCode:(NSString *)pincode AndCompletion:(void (^)(NSString *result))completion;
- (void)cancelPaymentWithToken:(NSString *)token Amount:(NSString *)amount AndCompletion:(void (^)(NSString *result))completion;
- (void)getAllPostWithCompletion:(void (^)(NSString *result))completion;
- (void)getAllEventWithCompletion:(void (^)(NSString *result))completion;
- (void)getAllPostAttachmentWithId:(NSString *)eventid Completion:(void (^)(NSString *result))completion;
- (void)getAllEventAttachmentWithId:(NSString *)eventid Completion:(void (^)(NSString *result))completion;
- (void)getGekoPayAnnounceWithIdCart:(NSString *)idCard Completion:(void (^)(NSString *result))completion;

@end
