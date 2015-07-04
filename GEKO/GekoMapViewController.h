//
//  GekoMapViewController.h
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/21/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface GekoMapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) MKMapView *map;

@end
