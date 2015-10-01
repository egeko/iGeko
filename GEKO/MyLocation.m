//
//  MyLocation.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/21/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "MyLocation.h"
#import <AddressBook/AddressBook.h>

@interface MyLocation ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *typePic;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@end

@implementation MyLocation

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate typepic:(NSString *)typepic cat:(int)cat {
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"";
        }
        self.address = address;
        self.theCoordinate = coordinate;
        
        NSString *picValue = [self checkTypePinsWithLibele:typepic andCat:cat];
        self.typePic = picValue;
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

- (NSString *)getType {
    return self.typePic;
}

- (NSString *)checkTypePinsWithLibele:(NSString *)libelle andCat:(int)cat {
    if ([libelle isEqualToString:@"ENGEN"]) {
        return @"ic_engen_pins.png";
    } else {
        switch (cat) {
            case 1:
                return @"ic_red_pins.png";
                break;
                
            case 2:
                return @"ic_orange_pins.png";
                break;
                
            case 3:
                return @"ic_yellow_pins.png";
                break;
                
            case 4:
                return @"ic_green_pins.png";
                break;
                
            case 5:
                return @"ic_blue_pins.png";
                break;
                
            case 6:
                return @"ic_indigo_pins.png";
                break;
                
            case 7:
                return @"ic_brown_pins.png";
                break;
                
            case 8:
                return @"ic_pink_pins.png";
                break;
                
            default:
                return @"ic_black_pins.png";
                break;
        }
    }
}

@end
