//
//  GekoMapViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/21/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoMapViewController.h"

#import "MyLocation.h"

@interface GekoMapViewController ()

@end

@implementation GekoMapViewController {
    NSMutableArray *json;
    CLLocationManager *locationManager;
    
    UIView *menuFont;
    BOOL menuShown;
    UIView *font0;
}

@synthesize map = _map;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupEnvironment];
    [self makeTheView];
    [self makeLateralMenu];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = locationManager.location.coordinate.latitude;
    region.center.longitude = locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [_map setRegion:region animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup

- (void)setupEnvironment {
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"gps" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    json = [[NSMutableArray alloc] init];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void)makeLateralMenu {
    menuFont = [[UIView alloc] initWithFrame:CGRectMake(SWIDTH - 100, 40 - (SHEIGHT - 40), 100, SHEIGHT - 40)];
    menuFont.backgroundColor = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:61/255.0f alpha:1.0f];
    menuShown = NO;
    
    for (int i = 0; i < 8; i++) {
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(10, (5 + (menuFont.frame.size.height - 45) / 8) * i, menuFont.frame.size.width - 20, 1)];
        sep.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
        
        [menuFont addSubview:sep];
    }
    
    [self.view addSubview:menuFont];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img1.image = [UIImage imageNamed:@"ic_paiement_1_white.png"];
    
    [menuFont addSubview:img1];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5 + (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img2.image = [UIImage imageNamed:@"ic_paiement_2_white.png"];
    
    [menuFont addSubview:img2];
    
    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10 + ((menuFont.frame.size.height - 45) / 8) * 2, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img3.image = [UIImage imageNamed:@"ic_paiement_3_white.png"];
    
    [menuFont addSubview:img3];
    
    UIImageView *img4 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15 + ((menuFont.frame.size.height - 45) / 8) * 3, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img4.image = [UIImage imageNamed:@"ic_paiement_4_white.png"];
    
    [menuFont addSubview:img4];
    
    UIImageView *img5 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20 + ((menuFont.frame.size.height - 45) / 8) * 4, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img5.image = [UIImage imageNamed:@"ic_paiement_5_white.png"];
    
    [menuFont addSubview:img5];
    
    UIImageView *img6 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25 + ((menuFont.frame.size.height - 45) / 8) * 5, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img6.image = [UIImage imageNamed:@"ic_paiement_6_white.png"];
    
    [menuFont addSubview:img6];
    
    UIImageView *img7 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30 + ((menuFont.frame.size.height - 45) / 8) * 6, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img7.image = [UIImage imageNamed:@"ic_paiement_7_white.png"];
    
    [menuFont addSubview:img7];
    
    UIImageView *img8 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35 + ((menuFont.frame.size.height - 45) / 8) * 7, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img8.image = [UIImage imageNamed:@"ic_paiement_8_white.png"];
    
    [menuFont addSubview:img8];
    
    [self.view addSubview:font0];
}

- (void)plotCrimePositions:(NSArray *)responseData {
    for (id<MKAnnotation> annotation in _map.annotations) {
        [_map removeAnnotation:annotation];
    }
    
    for (NSDictionary *obj in responseData) {
        NSNumber *latitude = [obj objectForKey:@"lat"];
        NSNumber *longitude = [obj objectForKey:@"long"];
        NSString *crimeDescription = [obj objectForKey:@"SiteName"];
        NSString *address = [obj objectForKey:@"Street Address"];
        
        if (!([(NSString *)[obj objectForKey:@"lat"] isEqual:@"0"] && [(NSString *)[obj objectForKey:@"long"] isEqual:@"0"])) {
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = latitude.doubleValue;
            coordinate.longitude = longitude.doubleValue;
            MyLocation *annotation = [[MyLocation alloc] initWithName:crimeDescription address:address coordinate:coordinate] ;
            [_map addAnnotation:annotation];
        }
    }
}

#pragma mark - UI

- (void)makeTheView {
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    int yRep = 0;
    
    font0 = [[UIView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, 40)];
    font0.backgroundColor = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:61/255.0f alpha:1.0f];
    
    [self.view addSubview:font0];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    back.image = [UIImage imageNamed:@"ic_back_white.png"];
    
    [font0 addSubview:back];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    
    [font0 addSubview:backBtn];
    
    UIImageView *menu = [[UIImageView alloc] initWithFrame:CGRectMake(SWIDTH - 30, 10, 20, 20)];
    menu.image = [UIImage imageNamed:@"ic_navbar_menu_white.png"];
    
    [font0 addSubview:menu];
    
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH - 70, 0, 70, 50)];
    [menuBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [font0 addSubview:menuBtn];
    
    UILabel *title0 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, font0.frame.size.width - 100, font0.frame.size.height)];
    title0.text = @"Geko Map";
    title0.textAlignment = NSTextAlignmentCenter;
    title0.font = [UIFont fontWithName:@"Arial" size:18];
    title0.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    
    [font0 addSubview:title0];
    yRep += font0.frame.size.height;
    
    _map = [[MKMapView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, SHEIGHT - yRep)];
    _map.delegate = self;
    
    _map.delegate = self;
    
    _map.showsUserLocation = YES;
    [_map setMapType:MKMapTypeHybrid];
    [_map setZoomEnabled:YES];
    [_map setScrollEnabled:YES];
    
    [self.view addSubview:_map];
    [self plotCrimePositions:json];
}

#pragma mark - MKMap management

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_map dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"ic_engen_pins.png"];
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [_map setRegion:[_map regionThatFits:region] animated:YES];
}

#pragma mark - Actions

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMenu {
    if (menuShown) {
        [UIView animateWithDuration:0.5f animations:^{
            menuFont.frame = CGRectOffset(menuFont.frame, 0, -(SHEIGHT - 40));
        }];
        menuShown = NO;
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            menuFont.frame = CGRectOffset(menuFont.frame, 0, SHEIGHT - 40);
        }];
        menuShown = YES;
    }
    
}

@end
