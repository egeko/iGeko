//
//  GekoEventTableViewCell.h
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 7/21/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GekoEventTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *content;

- (id)initWithStyle:(UITableViewCellStyle)style Message:(NSString *)message Time:(NSString *)time Idmess:(NSString *)idmess ReuseIdentifier:(NSString *)reuseIdentifier;

@end
