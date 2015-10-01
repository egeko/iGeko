//
//  GekoPaiementTableViewCell.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/18/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoPaiementTableViewCell.h"

@implementation GekoPaiementTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style Illustration:(UIImage *)illustration Name:(NSString *)name Adresse:(NSString *)adresse ReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, SWIDTH / 4 - 10, 70)];
        imageView.image = illustration;
        
        [self addSubview:imageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SWIDTH / 4 + 10, 5, SWIDTH / 4 * 3 - 20, 20)];
        nameLabel.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
        nameLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13];
        nameLabel.text = name;
        
        [self addSubview:nameLabel];
        
        UILabel *adresseLabel = [[UILabel alloc] initWithFrame:CGRectMake(SWIDTH / 4 + 10, 28, SWIDTH / 4 * 3 - 60, 40)];
        adresseLabel.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1.0f];
        adresseLabel.text = adresse;
        adresseLabel.font = [UIFont fontWithName:@"Arial" size:11];
        adresseLabel.numberOfLines = 2;
        [adresseLabel sizeToFit];
        
        [self addSubview:adresseLabel];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 79, SWIDTH, 1)];
        sep.backgroundColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1.0f];
        
        [self addSubview:sep];
        
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
