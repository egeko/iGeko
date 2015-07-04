//
//  GekoTransactionViewController.h
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 6/21/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GekoTransactionViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSString *infos;

- (id)initWithInfos:(NSString *)info;

@end
