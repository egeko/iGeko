//
//  GekoEventTableViewCell.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 7/21/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoEventTableViewCell.h"

@implementation GekoEventTableViewCell

@synthesize content = _content;

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

- (id)initWithStyle:(UITableViewCellStyle)style Message:(NSString *)message Time:(NSString *)time Idmess:(NSString *)idmess ReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *cadre = [[UIView alloc] initWithFrame:CGRectMake(10, 5, SWIDTH - 20, 140 - 10)];
        cadre.backgroundColor = [UIColor clearColor];
        [cadre.layer setCornerRadius:6.0f];
        
        [self addSubview:cadre];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        NSDate *date  = [dateFormatter dateFromString:time];
        
        // Convert to new Date Format
        [dateFormatter setDateFormat:@"dd-MM-yy HH:mm"];
        NSString *newDate = [dateFormatter stringFromDate:date];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 12, 150, 15)];
        titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:10];
        titleLabel.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
        titleLabel.text = newDate;
        
        [self addSubview:titleLabel];
        
//        UIImageView *typeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SWIDTH - 32, 12, 10, 14)];
//        typeIcon.image = [UIImage imageNamed:@"ic_event_tick.png"];
//        
//        [self addSubview:typeIcon];
//        
//        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SWIDTH - 140, 12, 100, 15)];
//        typeLabel.font = [UIFont fontWithName:@"Arial" size:9];
//        typeLabel.textAlignment = NSTextAlignmentRight;
//        typeLabel.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
//        typeLabel.text = @"type";
//        
//        [self addSubview:typeLabel];
        
        /******/
        UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(20, 140 / 12 * 3, SWIDTH - 40, 1)];
        sep1.backgroundColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
        
        [self addSubview:sep1];
        /******/
        
        UIImageView *illustration = [[UIImageView alloc] initWithFrame:CGRectMake(22, 140 / 12 * 3 + 10, SWIDTH / 3, 140 / 12 * 7 - 20)];
        illustration.contentMode = UIViewContentModeScaleAspectFill;
        illustration.image = [UIImage imageNamed:@"ic_logo_geko.png"];
        
        [self addSubview:illustration];
        
        _content = [[UILabel alloc] initWithFrame:CGRectMake(22 + (SWIDTH / 3) + 5, 140 / 12 * 3 + 10, SWIDTH / 3 * 2 - 50, 140 / 12 * 7 - 20)];
        _content.font = [UIFont fontWithName:@"Arial" size:9];
        _content.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
        _content.numberOfLines = 10;
        _content.text = message;
        
        [self addSubview:_content];
        
        /******/
        UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(20, 140 / 12 * 10, SWIDTH - 40, 1)];
        sep2.backgroundColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
        
        [self addSubview:sep2];
        /******/
        
//        UIImageView *locateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(22, 140 - 12 - 14, 10, 14)];
//        locateIcon.image = [UIImage imageNamed:@"ic_event_location.png"];
//        
//        [self addSubview:locateIcon];
        
        UILabel *locateLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 140 - 12 - 14, 100, 15)];
        locateLabel.font = [UIFont fontWithName:@"Arial" size:9];
        locateLabel.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
        locateLabel.text = @"";
        
        [self addSubview:locateLabel];
        
//        UIImageView *shareIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SWIDTH - 36, 140 - 12 - 14, 14, 14)];
//        shareIcon.image = [UIImage imageNamed:@"ic_event_share_light_gray.png"];
//        
//        [self addSubview:shareIcon];
        
        UIView *gradient_effect = [[UIView alloc] initWithFrame:CGRectMake(5, 140 - 5, SWIDTH - 10, 1)];
        gradient_effect.backgroundColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f];
        
        [self addSubview:gradient_effect];
        
        GekoAPI *api = [[GekoAPI alloc] init];
        [api getAllPostAttachmentWithId:idmess Completion:^(NSString *results){
            NSArray *data = [api.dicResponse objectForKey:@"data"];
            NSDictionary *first = [data firstObject];
            NSDictionary *media = [first objectForKey:@"media"];
            NSDictionary *image = [media objectForKey:@"image"];
            NSString *url_to_inject = [image objectForKey:@"src"];
            illustration.contentMode = UIViewContentModeScaleAspectFit;
            
            if (url_to_inject) {
               [illustration setImageWithURL:[NSURL URLWithString:url_to_inject]];
            } else {
                [api getAllEventAttachmentWithId:idmess Completion:^(NSString *results){
                    NSDictionary *cover = [api.dicResponse objectForKey:@"cover"];
                    NSString *url_to_inject = [cover objectForKey:@"source"];
                    illustration.contentMode = UIViewContentModeScaleAspectFit;
                    
                    if (url_to_inject) {
                        [illustration setImageWithURL:[NSURL URLWithString:url_to_inject]];
                    } else {
                        // server error
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat:@"Erreur serveur, veuillez contacter la Geko Team."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [av show];
                    }
                }];
            }
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
