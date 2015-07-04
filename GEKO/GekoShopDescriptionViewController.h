//
//  GekoShopDescriptionViewController.h
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/21/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GekoShopDescriptionViewController : UIViewController

@property (nonatomic, strong) NSDictionary *infos;

- (id)initWithInformation:(NSDictionary *)information;

@end
