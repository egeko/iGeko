//
//  AppDelegate.h
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/18/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

