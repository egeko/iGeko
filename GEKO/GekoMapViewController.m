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
    NSArray *json;
    CLLocationManager *locationManager;
    
    UIView *menuFont;
    BOOL menuShown;
    UIView *font0;
    UIView *footer;
    UILabel *title_footer;
    
    int currentCat;
    NSArray *liste;
    NSArray *categories;
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
    categories = [[NSArray alloc] initWithObjects:@"Stations", @"Sport", @"Restauration", @"Beauté", @"Bricolage", @"Mode", @"Supermarché", @"Services", nil];
    GekoAPI *api = [[GekoAPI alloc] init];
    [api getAllShopWithCompletion:^(NSString *results){
        if ([results isEqual:@"OK"]) {
            json = api.arrayResponse;
            currentCat = 1;
        } else {
            // server error
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat:@"Erreur serveur, veuillez contacter la Geko Team."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }
        [self makeTheView];
        [self makeLateralMenu];
    }];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void)makeLateralMenu {
    menuFont = [[UIView alloc] initWithFrame:CGRectMake(SWIDTH - 200, 40 - (SHEIGHT - 40), 200, SHEIGHT - 80)];
    menuFont.backgroundColor = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:61/255.0f alpha:1.0f];
    menuShown = NO;
    
    for (int i = 1; i < 8; i++) {
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(10, (5 + (menuFont.frame.size.height - 45) / 8) * i, menuFont.frame.size.width - 20, 1)];
        sep.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
        
        [menuFont addSubview:sep];
    }
    
    [self.view addSubview:menuFont];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 5 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img1.image = [UIImage imageNamed:@"ic_paiement_1_white.png"];
    
    [menuFont addSubview:img1];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab1.textColor = [UIColor whiteColor];
    lab1.font = [UIFont fontWithName:@"Arial" size:16];
    lab1.textAlignment = NSTextAlignmentLeft;
    lab1.text = @"Stations";
    
    [menuFont addSubview:lab1];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn1 setTag:1];
    [btn1 addTarget:self action:@selector(changeCat:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn1];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 5 + (menuFont.frame.size.height - 45) / 8 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img2.image = [UIImage imageNamed:@"ic_paiement_2_white.png"];
    
    [menuFont addSubview:img2];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 + 5, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab2.textColor = [UIColor whiteColor];
    lab2.font = [UIFont fontWithName:@"Arial" size:16];
    lab2.textAlignment = NSTextAlignmentLeft;
    lab2.text = @"Sport";
    
    [menuFont addSubview:lab2];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + (menuFont.frame.size.height - 45) / 8 + 5, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn2 setTag:2];
    [btn2 addTarget:self action:@selector(changeCat:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn2];
    
    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 10 + ((menuFont.frame.size.height - 45) / 8) * 2 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img3.image = [UIImage imageNamed:@"ic_paiement_3_white.png"];
    
    [menuFont addSubview:img3];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 * 2 + 10, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab3.textColor = [UIColor whiteColor];
    lab3.font = [UIFont fontWithName:@"Arial" size:16];
    lab3.textAlignment = NSTextAlignmentLeft;
    lab3.text = @"Restauration";
    
    [menuFont addSubview:lab3];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + ((menuFont.frame.size.height - 45) / 8) * 2 + 10, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn3 setTag:3];
    [btn3 addTarget:self action:@selector(changeCat:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn3];
    
    UIImageView *img4 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 15 + ((menuFont.frame.size.height - 45) / 8) * 3 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img4.image = [UIImage imageNamed:@"ic_paiement_4_white.png"];
    
    [menuFont addSubview:img4];
    
    UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 * 3 + 15, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab4.textColor = [UIColor whiteColor];
    lab4.font = [UIFont fontWithName:@"Arial" size:16];
    lab4.textAlignment = NSTextAlignmentLeft;
    lab4.text = @"Beauté";
    
    [menuFont addSubview:lab4];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + ((menuFont.frame.size.height - 45) / 8) * 3 + 15, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn4 setTag:4];
    [btn4 addTarget:self action:@selector(changeCat:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn4];
    
    UIImageView *img5 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 20 + ((menuFont.frame.size.height - 45) / 8) * 4 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img5.image = [UIImage imageNamed:@"ic_paiement_5_white.png"];
    
    [menuFont addSubview:img5];
    
    UILabel *lab5 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 * 4 + 20, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab5.textColor = [UIColor whiteColor];
    lab5.font = [UIFont fontWithName:@"Arial" size:16];
    lab5.textAlignment = NSTextAlignmentLeft;
    lab5.text = @"Bricolage";
    
    [menuFont addSubview:lab5];
    
    UIButton *btn5 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + ((menuFont.frame.size.height - 45) / 8) * 4 + 20, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn5 setTag:5];
    [btn5 addTarget:self action:@selector(changeCat:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn5];
    
    UIImageView *img6 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 25 + ((menuFont.frame.size.height - 45) / 8) * 5 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img6.image = [UIImage imageNamed:@"ic_paiement_6_white.png"];
    
    [menuFont addSubview:img6];
    
    UILabel *lab6 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 * 5 + 25, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab6.textColor = [UIColor whiteColor];
    lab6.font = [UIFont fontWithName:@"Arial" size:16];
    lab6.textAlignment = NSTextAlignmentLeft;
    lab6.text = @"Mode";
    
    [menuFont addSubview:lab6];
    
    UIButton *btn6 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + ((menuFont.frame.size.height - 45) / 8) * 5 + 25, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn6 setTag:6];
    [btn6 addTarget:self action:@selector(changeCat:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn6];
    
    UIImageView *img7 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 30 + ((menuFont.frame.size.height - 45) / 8) * 6 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img7.image = [UIImage imageNamed:@"ic_paiement_7_white.png"];
    
    [menuFont addSubview:img7];
    
    UILabel *lab7 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 * 6 + 30, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab7.textColor = [UIColor whiteColor];
    lab7.font = [UIFont fontWithName:@"Arial" size:16];
    lab7.textAlignment = NSTextAlignmentLeft;
    lab7.text = @"Supermarché";
    
    [menuFont addSubview:lab7];
    
    UIButton *btn7 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + ((menuFont.frame.size.height - 45) / 8) * 6 + 30, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn7 setTag:7];
    [btn7 addTarget:self action:@selector(changeCat:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn7];
    
    UIImageView *img8 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 35 + ((menuFont.frame.size.height - 45) / 8) * 7 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img8.image = [UIImage imageNamed:@"ic_paiement_8_white.png"];
    
    [menuFont addSubview:img8];
    
    UILabel *lab8 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 * 7 + 35, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab8.textColor = [UIColor whiteColor];
    lab8.font = [UIFont fontWithName:@"Arial" size:16];
    lab8.textAlignment = NSTextAlignmentLeft;
    lab8.text = @"Services";
    
    [menuFont addSubview:lab8];
    
    UIButton *btn8 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + ((menuFont.frame.size.height - 45) / 8) * 7 + 35, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn8 setTag:8];
    [btn8 addTarget:self action:@selector(changeCat:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn8];
    
    [self.view addSubview:font0];
}

- (void)plotCrimePositions:(NSArray *)responseData {
    for (id<MKAnnotation> annotation in _map.annotations) {
        [_map removeAnnotation:annotation];
    }
    
    for (NSDictionary *obj in responseData) {
        NSNumber *latitude = [obj objectForKey:@"gpsLatitude"];
        NSNumber *longitude = [obj objectForKey:@"gpsLongitude"];
        NSString *crimeDescription = [obj objectForKey:@"enseigne"];
        NSString *address = [obj objectForKey:@"adresse"];
        NSString *type = [obj objectForKey:@"logo"];
        
        if(!([obj objectForKey:@"gpsLatitude"] == (id)[NSNull null] || [obj objectForKey:@"gpsLongitude"] == (id)[NSNull null])){
            if (!([(NSString *)[obj objectForKey:@"gpsLatitude"] isEqual:@"0"] && [(NSString *)[obj objectForKey:@"gpsLongitude"] isEqual:@"0"])) {
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = latitude.doubleValue;
                coordinate.longitude = longitude.doubleValue;
                MyLocation *annotation = [[MyLocation alloc] initWithName:crimeDescription address:address coordinate:coordinate typepic:type cat:currentCat] ;
                [_map addAnnotation:annotation];
            }
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
    
    _map = [[MKMapView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, SHEIGHT - yRep - 40)];
    _map.delegate = self;
    
    _map.delegate = self;
    
    _map.showsUserLocation = YES;
    [_map setMapType:MKMapTypeHybrid];
    [_map setZoomEnabled:YES];
    [_map setScrollEnabled:YES];
    
    [self.view addSubview:_map];
    
    UIButton *centerMap = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH - 60, SHEIGHT - 100, 40, 40)];
    [centerMap setImage:[UIImage imageNamed:@"ic_map_center.png"] forState:UIControlStateNormal];
    [centerMap addTarget:self action:@selector(centerMap) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:centerMap];
    
    footer = [[UIView alloc] initWithFrame:CGRectMake(0, SHEIGHT - 40, SWIDTH, 40)];
    footer.backgroundColor = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:61/255.0f alpha:1.0f];
    
    [self.view addSubview:footer];
    
    title_footer = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, font0.frame.size.width - 100, font0.frame.size.height)];
    title_footer.text = @"Stations services";
    title_footer.textAlignment = NSTextAlignmentCenter;
    title_footer.font = [UIFont fontWithName:@"Arial" size:18];
    title_footer.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    
    [footer addSubview:title_footer];
    
    NSDictionary *type = [json objectAtIndex:(currentCat - 1)];
    liste = [type objectForKey:@"liste"];
    [self plotCrimePositions:liste];
}

#pragma mark - MKMap management

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_map dequeueReusableAnnotationViewWithIdentifier:identifier];
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        MyLocation *test = (MyLocation *)annotation;
        NSString *temp2 = [test getType];
        annotationView.image = [UIImage imageNamed:temp2];
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
}

- (void)centerMap {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_map.userLocation.coordinate, 800, 800);
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

- (void)changeCat:(UIButton *)button {
    currentCat = (int)[button tag];
    title_footer.text = [categories objectAtIndex:(currentCat - 1)];
    NSDictionary *type = [json objectAtIndex:(currentCat - 1)];
    liste = [type objectForKey:@"liste"];
    [self plotCrimePositions:liste];
    [self showMenu];
}

@end
