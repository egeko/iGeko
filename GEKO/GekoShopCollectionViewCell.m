//
//  GekoShopCollectionViewCell.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/21/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoShopCollectionViewCell.h"

@implementation GekoShopCollectionViewCell

@synthesize canvas = _canvas;
@synthesize imageView = _imageView;
@synthesize title = _title;

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    {
        self.backgroundColor=[UIColor clearColor];
        
        UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(4, 6, self.frame.size.width - 10, self.frame.size.width - 10)];
        shadow.backgroundColor = [UIColor colorWithRed:205/255.0f green:205/255.0f blue:205/255.0f alpha:0.9f];
        
        [self addSubview:shadow];
        
        _canvas = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.width - 10)];
        _canvas.backgroundColor = [UIColor colorWithRed:253/255.0f green:253/255.0f blue:253/255.0f alpha:0.9f];
        
        [self addSubview:_canvas];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _canvas.frame.size.width - 20, _canvas.frame.size.width - 20)];
        
        [_canvas addSubview:_imageView];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.width, self.frame.size.width, self.frame.size.height - self.frame.size.width)];
        _title.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_title];
    }
    return self;
}

@end
