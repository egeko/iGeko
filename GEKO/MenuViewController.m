//
//  MenuViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/18/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "MenuViewController.h"

#import "GekoPaiementViewController.h"
#import "GekoShopViewController.h"
#import "GekoMapViewController.h"
#import "GekoProfileViewController.h"
#import "GekoSettingViewController.h"
#import "GekoEventViewController.h"

static NSString * const kIdentifier = @"jaalee.Example";

@interface MenuViewController ()<JLEBeaconManagerDelegate>

@property (nonatomic, strong) JLEBeaconManager  *beaconManager;
@property (nonatomic, strong) JLEBeaconRegion  *beaconRegion;

@end

@implementation MenuViewController {
    UIScrollView *background;
    NSArray *listEvent;
    int minorReg;
    int majorReg;
    BOOL hasBeenDisplayed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    hasBeenDisplayed = NO;
    
    self.beaconManager = [[JLEBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    self.beaconRegion = [[JLEBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"EBEFD083-70A2-47C8-9837-E7B5634DF524"] identifier:kIdentifier];
    
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_logo_small.png"]];
    hud.labelText = @"Loading";
    hud.labelColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self setupEnvironment];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupEnvironment {
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    GekoAPI *api = [[GekoAPI alloc] init];
    [api getAllBeaconEventWithCompletion:^(NSString *results){
        if ([results isEqual:@"OK"]) {
            listEvent = api.arrayResponse;
        } else {
            // server error
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat:@"Erreur serveur, veuillez contacter la Geko Team."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }
        [self makeTheView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - UI

- (void)makeTheView {
    int yRep = 5;
    
    background = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, SHEIGHT)];
    background.bounces = NO;
    
    [background setShowsVerticalScrollIndicator:NO];
    
    [self.view addSubview:background];
    
    UIView *font0 = [[UIView alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH - 20, (SHEIGHT - 70) / 6)];
    
    [background addSubview:font0];
    
//    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, font0.frame.size.height - 40, font0.frame.size.height - 40)];
//    logo.image = [UIImage imageNamed:@"ic_logo_tiger_gray.png"];
//    
//    [font0 addSubview:logo];
    
    UIImageView *logo2 = [[UIImageView alloc] initWithFrame:CGRectMake(SWIDTH / 2 - (((font0.frame.size.height - 40) * 1.87) / 2), 15, (font0.frame.size.height - 40) * 1.87, font0.frame.size.height - 40)];
    logo2.image = [UIImage imageNamed:@"ic_logo_geko.png"];
    
    [font0 addSubview:logo2];
    yRep += font0.frame.size.height + 10;
    
    // Buttons
    UIView *font11 = [[UIView alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH - 20, (SHEIGHT - 70) / 6)];
    font11.backgroundColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f];
    
    [background addSubview:font11];
    
    UIImageView *pic11 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, font11.frame.size.height - 20, font11.frame.size.height - 20)];
    pic11.image = [UIImage imageNamed:@"ic_menu_pay.png"];
    
    [font11 addSubview:pic11];
    
    UILabel *title11 = [[UILabel alloc] initWithFrame:CGRectMake(pic11.frame.size.width + 20, font11.frame.size.height - 30, font11.frame.size.width - pic11.frame.size.width - 30, 20)];
    title11.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    title11.textAlignment = NSTextAlignmentRight;
    title11.font = [UIFont fontWithName:@"Arial" size:18];
    title11.text = @"Geko Pay";
    
    [font11 addSubview:title11];
    
    UIButton *btn11 = [[UIButton alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH - 20, (SHEIGHT - 70) / 6)];
    [btn11 addTarget:self action:@selector(goToGekoPaiement) forControlEvents:UIControlEventTouchUpInside];
    
    [background addSubview:btn11];
    yRep += btn11.frame.size.height + 10;
    
//    UIView *font12 = [[UIView alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH / 2 - 15, (SHEIGHT - 70) / 6)];
//    font12.backgroundColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
//    
//    [background addSubview:font12];
//    
//    UIImageView *pic12 = [[UIImageView alloc] initWithFrame:CGRectMake(font12.frame.size.width - font12.frame.size.height + 10, 10, font12.frame.size.height - 20, font12.frame.size.height - 20)];
//    pic12.image = [UIImage imageNamed:@"ic_menu_magasin_clear.png"];
//    
//    [font12 addSubview:pic12];
//    
//    UILabel *title12 = [[UILabel alloc] initWithFrame:CGRectMake(10, font12.frame.size.height - 30, font12.frame.size.width - 20, 20)];
//    title12.textColor = [UIColor colorWithRed:57/255.0f green:62/255.0f blue:68/255.0f alpha:1.0f];
//    title12.textAlignment = NSTextAlignmentLeft;
//    title12.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
//    title12.text = @"Geko Shop";
//    
//    [font12 addSubview:title12];
//    
//    UIButton *btn12 = [[UIButton alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH / 2 - 30, (SHEIGHT - 70) / 6)];
//    [btn12 addTarget:self action:@selector(goToGekoShop) forControlEvents:UIControlEventTouchUpInside];
//    
//    [background addSubview:btn12];
    
    UIView *font21 = [[UIView alloc] initWithFrame:CGRectMake(SWIDTH / 2 + 5, yRep, SWIDTH / 2 - 15, (SHEIGHT - 70) / 6 * 2 + 10)];
    font21.backgroundColor = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:61/255.0f alpha:1.0f];
    
    [background addSubview:font21];
    
    UIImageView *pic21 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, font21.frame.size.width - 20, font21.frame.size.width - 20)];
    pic21.image = [UIImage imageNamed:@"ic_menu_map_custom.png"];
    
    [font21 addSubview:pic21];
    
    UILabel *title21 = [[UILabel alloc] initWithFrame:CGRectMake(10, font21.frame.size.height - 30, font21.frame.size.width - 20, 20)];
    title21.textColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0f];
    title21.textAlignment = NSTextAlignmentCenter;
    title21.font = [UIFont fontWithName:@"Arial" size:18];
    title21.text = @"Geko Map";
    
    [font21 addSubview:title21];
    
    UIButton *btn21 = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH / 2 + 5, yRep, SWIDTH / 2 - 15, (SHEIGHT - 70) / 6 * 2 + 10)];
    [btn21 addTarget:self action:@selector(goToGekoMap) forControlEvents:UIControlEventTouchUpInside];
    
    [background addSubview:btn21];
    //yRep += font21.frame.size.height + 10;
    
    //UIView *font22 = [[UIView alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH / 2 - 15, (SHEIGHT - 70) / 6 * 2 + 10)];
    UIView *font22 = [[UIView alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH / 2 - 15, (SHEIGHT - 70) / 6 * 3 + 20)];
    font22.backgroundColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f];
    
    [background addSubview:font22];
    
    UIImageView *pic22 = [[UIImageView alloc] initWithFrame:CGRectMake(10, font22.frame.size.height - (font22.frame.size.width - 20 + 10), font22.frame.size.width - 20, font22.frame.size.width - 20)];
    pic22.image = [UIImage imageNamed:@"ic_menu_event_gray_custom.png"];
    
    [font22 addSubview:pic22];
    
    UILabel *title22 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, font22.frame.size.width - 20, 20)];
    title22.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    title22.textAlignment = NSTextAlignmentCenter;
    title22.font = [UIFont fontWithName:@"Arial" size:18];
    title22.text = @"Geko Events";
    
    [font22 addSubview:title22];
    
    UIButton *btn22 = [[UIButton alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH / 2 - 15, (SHEIGHT - 70) / 6 * 3 + 20)];
    [btn22 addTarget:self action:@selector(goToGekoEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [background addSubview:btn22];
    //yRep += font22.frame.size.height - font12.frame.size.height;
    yRep += (SHEIGHT - 70) / 6 * 2 + 20;
    
    UIView *font31 = [[UIView alloc] initWithFrame:CGRectMake(SWIDTH / 2 + 5, yRep, SWIDTH / 2 - 15, (SHEIGHT - 70) / 6)];
    font31.backgroundColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f];
    
    [background addSubview:font31];
    
    UIImageView *pic31 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, font31.frame.size.height - 20, font31.frame.size.height - 20)];
    pic31.image = [UIImage imageNamed:@"ic_menu_profile_gray_custom.png"];
    
    [font31 addSubview:pic31];
    
    UILabel *title31 = [[UILabel alloc] initWithFrame:CGRectMake(10, font31.frame.size.height - 30, font31.frame.size.width - 20, 20)];
    title31.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    title31.textAlignment = NSTextAlignmentRight;
    title31.font = [UIFont fontWithName:@"Arial" size:18];
    title31.text = @"Mon compte";
    
    [font31 addSubview:title31];
    
    UIButton *btn31 = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH / 2 + 5, yRep, SWIDTH / 2 - 15, (SHEIGHT - 70) / 6)];
    [btn31 addTarget:self action:@selector(goToGekoProfile) forControlEvents:UIControlEventTouchUpInside];
    
    [background addSubview:btn31];
    yRep += font31.frame.size.height + 10;
    
    UIView *font32 = [[UIView alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH - 20, (SHEIGHT - 70) / 6)];
    font32.backgroundColor = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:61/255.0f alpha:1.0f];
    
    [background addSubview:font32];
    
    UIImageView *pic32 = [[UIImageView alloc] initWithFrame:CGRectMake(font32.frame.size.width - (font32.frame.size.height - 20 + 10), 10, font32.frame.size.height - 20, font32.frame.size.height - 20)];
    pic32.image = [UIImage imageNamed:@"ic_menu_setting_custom.png"];
    
    [font32 addSubview:pic32];
    
    UILabel *title32 = [[UILabel alloc] initWithFrame:CGRectMake(10, font32.frame.size.height - 30, font32.frame.size.width - 20, 20)];
    title32.textColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0f];
    title32.textAlignment = NSTextAlignmentLeft;
    title32.font = [UIFont fontWithName:@"Arial" size:18];
    title32.text = @"Geko Settings";
    
    [font32 addSubview:title32];
    
    UIButton *btn32 = [[UIButton alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH - 20, (SHEIGHT - 70) / 6)];
    [btn32 addTarget:self action:@selector(goToGekoSetting) forControlEvents:UIControlEventTouchUpInside];
    
    [background addSubview:btn32];
    yRep += font32.frame.size.height;
    
    background.contentSize = CGSizeMake(SWIDTH, yRep);
}

#pragma mark - Actions

- (void)goToGekoPaiement {
    GekoPaiementViewController *gpvc = [[GekoPaiementViewController alloc] init];
    [self.navigationController pushViewController:gpvc animated:YES];
}

- (void)goToGekoShop {
    GekoShopViewController *gsvc = [[GekoShopViewController alloc] init];
    [self.navigationController pushViewController:gsvc animated:YES];
}

- (void)goToGekoMap {
    GekoMapViewController *gmvc = [[GekoMapViewController alloc] init];
    [self.navigationController pushViewController:gmvc animated:YES];
}

- (void)goToGekoProfile {
    GekoProfileViewController *gpvc = [[GekoProfileViewController alloc] init];
    [self.navigationController pushViewController:gpvc animated:YES];
}

- (void)goToGekoSetting {
    GekoSettingViewController *gsvc = [[GekoSettingViewController alloc] init];
    [self.navigationController pushViewController:gsvc animated:YES];
}

- (void)goToGekoEvent {
    GekoEventViewController *gevc = [[GekoEventViewController alloc] init];
    [self.navigationController pushViewController:gevc animated:YES];
}

#pragma mark - JLEBeaconManager delegate

- (void)beaconManager:(JLEBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(JLEBeaconRegion *)region
{
    JLEBeacon *temp = [beacons firstObject];
//    NSLog([NSString stringWithFormat:@"%@\n%d\n%d\n%.2f", [temp.proximityUUID UUIDString], [temp.major intValue], [temp.minor intValue], temp.accuracy]);
//    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Geko Prenium!" message:[NSString stringWithFormat:@"Profitez de l'offre <beacon id pour dététerminer l'offre: %@", [temp.proximityUUID UUIDString]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [av show];
    
    if (!hasBeenDisplayed && [temp.proximityUUID UUIDString]) {
        minorReg = [temp.minor intValue];
        majorReg = [temp.major intValue];
        for (int i = 0; i < [listEvent count]; i++) {
            NSDictionary *beaconEvent = [listEvent objectAtIndex:i];
            if ([[beaconEvent objectForKey:@"major"] intValue] == majorReg && [[beaconEvent objectForKey:@"minor"] intValue] == minorReg) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Espace Geko" message:[NSString stringWithFormat:@"%@", [beaconEvent objectForKey:@"message"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
                hasBeenDisplayed = YES;
            }
        }
    } else {
        if (![temp.proximityUUID UUIDString] || minorReg != [temp.minor intValue]) {
            hasBeenDisplayed = NO;
        }
    }
    
}

- (void)beaconManager:(JLEBeaconManager *)manager didEnterRegion:(JLEBeaconRegion *)region
{
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Vous entrez dans un espace Geko!";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)beaconManager:(JLEBeaconManager *)manager didExitRegion:(JLEBeaconRegion *)region
{
//    UILocalNotification *notification = [UILocalNotification new];
//    notification.alertBody = @"Vous venez de quitter un espace Geko";
//    
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    hasBeenDisplayed = NO;
}

@end
