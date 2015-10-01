//
//  GekoPaiementViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/18/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoPaiementViewController.h"
#import "GekoTransactionViewController.h"

#import "GekoPaiementTableViewCell.h"


@interface GekoPaiementViewController ()

@end

@implementation GekoPaiementViewController {
    UITableView *gekoTableView;
    UIActivityIndicatorView *activityIndicator;
    UIView *whitearea;
    UIVisualEffect *blurEffect;    
    UIVisualEffectView *visualEffectView;
    
    int category;
    UIScrollView *categoryScroll;
    UIPageControl *pageControl;
    
    UIView *menuFont;
    BOOL menuShown;
    UIView *font0;
    
    NSArray *json;
    NSString *shopId;
    NSArray *categories;
    
    long long expectedLength;
    long long currentLength;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    for (int i = (int)self.view.subviews.count - 1; i>=0; i--) {
        [[self.view.subviews objectAtIndex:i] removeFromSuperview];
    }
    category = 0;
    
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

#pragma mark - setup

- (void)setupEnvironment {
    categories = [[NSArray alloc] initWithObjects:@"Stations service", @"Sport, loisir & voyage", @"Restauration & alimentation", @"Beauté et bien-être", @"Bricolage", @"Mode", @"Supermarché", @"Services", nil];
    GekoAPI *api = [[GekoAPI alloc] init];
    [api getAllShopWithCompletion:^(NSString *results){
        if ([results isEqual:@"OK"]) {
            json = api.arrayResponse;
        } else {
            // server error
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat:@"Erreur serveur, veuillez contacter la Geko Team."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }
        [self makeTheView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self makeLateralMenu];
    }];
}

- (void)makeLateralMenu {
    menuShown = NO;
    menuFont = [[UIView alloc] initWithFrame:CGRectMake(SWIDTH - 200, 40 - (SHEIGHT - 40), 200, SHEIGHT - 40)];
    menuFont.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    
    for (int i = 1; i < 8; i++) {
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(10, (5 + (menuFont.frame.size.height - 45) / 8) * i, menuFont.frame.size.width - 20, 1)];
        sep.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
        
        [menuFont addSubview:sep];
    }
    
    UIView *sepVert = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, menuFont.frame.size.height)];
    sepVert.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
    
    [menuFont addSubview:sepVert];
    
    [self.view addSubview:menuFont];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 5 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img1.image = [UIImage imageNamed:@"ic_menu_gas_gray_custom.png"];
    
    [menuFont addSubview:img1];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab1.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    lab1.font = [UIFont fontWithName:@"Arial" size:16];
    lab1.textAlignment = NSTextAlignmentLeft;
    lab1.text = @"Stations";
    
    [menuFont addSubview:lab1];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn1 setTag:0];
    [btn1 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn1];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 5 + (menuFont.frame.size.height - 45) / 8 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img2.image = [UIImage imageNamed:@"ic_paiement_2_white.png"];
    
    [menuFont addSubview:img2];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 + 5, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab2.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    lab2.font = [UIFont fontWithName:@"Arial" size:16];
    lab2.textAlignment = NSTextAlignmentLeft;
    lab2.text = @"Sport";
    
    [menuFont addSubview:lab2];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + (menuFont.frame.size.height - 45) / 8 + 5, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn2 setTag:1];
    [btn2 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn2];
    
    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 10 + ((menuFont.frame.size.height - 45) / 8) * 2 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img3.image = [UIImage imageNamed:@"ic_paiement_3_white.png"];
    
    [menuFont addSubview:img3];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 * 2 + 10, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab3.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    lab3.font = [UIFont fontWithName:@"Arial" size:16];
    lab3.textAlignment = NSTextAlignmentLeft;
    lab3.text = @"Restauration";
    
    [menuFont addSubview:lab3];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + ((menuFont.frame.size.height - 45) / 8) * 2 + 10, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn3 setTag:2];
    [btn3 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn3];
    
    UIImageView *img4 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 15 + ((menuFont.frame.size.height - 45) / 8) * 3 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img4.image = [UIImage imageNamed:@"ic_paiement_4_white.png"];
    
    [menuFont addSubview:img4];
    
    UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 * 3 + 15, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab4.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    lab4.font = [UIFont fontWithName:@"Arial" size:16];
    lab4.textAlignment = NSTextAlignmentLeft;
    lab4.text = @"Beauté";
    
    [menuFont addSubview:lab4];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + ((menuFont.frame.size.height - 45) / 8) * 3 + 15, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn4 setTag:3];
    [btn4 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn4];
    
    UIImageView *img5 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 20 + ((menuFont.frame.size.height - 45) / 8) * 4 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img5.image = [UIImage imageNamed:@"ic_paiement_5_white.png"];
    
    [menuFont addSubview:img5];
    
    UILabel *lab5 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 * 4 + 20, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab5.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    lab5.font = [UIFont fontWithName:@"Arial" size:16];
    lab5.textAlignment = NSTextAlignmentLeft;
    lab5.text = @"Bricolage";
    
    [menuFont addSubview:lab5];
    
    UIButton *btn5 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + ((menuFont.frame.size.height - 45) / 8) * 4 + 20, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn5 setTag:4];
    [btn5 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn5];
    
    UIImageView *img6 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 25 + ((menuFont.frame.size.height - 45) / 8) * 5 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img6.image = [UIImage imageNamed:@"ic_paiement_6_white.png"];
    
    [menuFont addSubview:img6];
    
    UILabel *lab6 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 * 5 + 25, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab6.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    lab6.font = [UIFont fontWithName:@"Arial" size:16];
    lab6.textAlignment = NSTextAlignmentLeft;
    lab6.text = @"Mode";
    
    [menuFont addSubview:lab6];
    
    UIButton *btn6 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + ((menuFont.frame.size.height - 45) / 8) * 5 + 25, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn6 setTag:5];
    [btn6 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn6];
    
    UIImageView *img7 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 30 + ((menuFont.frame.size.height - 45) / 8) * 6 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img7.image = [UIImage imageNamed:@"ic_paiement_7_white.png"];
    
    [menuFont addSubview:img7];
    
    UILabel *lab7 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 * 6 + 30, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab7.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    lab7.font = [UIFont fontWithName:@"Arial" size:16];
    lab7.textAlignment = NSTextAlignmentLeft;
    lab7.text = @"Supermarché";
    
    [menuFont addSubview:lab7];
    
    UIButton *btn7 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + ((menuFont.frame.size.height - 45) / 8) * 6 + 30, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn7 setTag:6];
    [btn7 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn7];
    
    UIImageView *img8 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 10, 35 + ((menuFont.frame.size.height - 45) / 8) * 7 + 10, (menuFont.frame.size.height - 45) / 8 - 20, (menuFont.frame.size.height - 45) / 8 - 20)];
    img8.image = [UIImage imageNamed:@"ic_paiement_8_white.png"];
    
    [menuFont addSubview:img8];
    
    UILabel *lab8 = [[UILabel alloc] initWithFrame:CGRectMake(15 + (menuFont.frame.size.height - 45) / 8, 5 + (menuFont.frame.size.height - 45) / 8 * 7 + 35, (menuFont.frame.size.height - 45) / 8 * 2.7, (menuFont.frame.size.height - 45) / 8)];
    lab8.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    lab8.font = [UIFont fontWithName:@"Arial" size:16];
    lab8.textAlignment = NSTextAlignmentLeft;
    lab8.text = @"Services";
    
    [menuFont addSubview:lab8];
    
    UIButton *btn8 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + ((menuFont.frame.size.height - 45) / 8) * 7 + 35, (menuFont.frame.size.height - 45) / 8 * 3.6, (menuFont.frame.size.height - 45) / 8)];
    [btn8 setTag:7];
    [btn8 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn8];
    
    [self.view addSubview:font0];
}

#pragma mark - UI

- (void)makeTheView {
    int yRep = 0;
    
    font0 = [[UIView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, 40)];
    font0.backgroundColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f];
    
    [self.view addSubview:font0];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    back.image = [UIImage imageNamed:@"ic_back_black.png"];
    
    [font0 addSubview:back];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];

    [font0 addSubview:backBtn];
    
//    UIImageView *menu = [[UIImageView alloc] initWithFrame:CGRectMake(SWIDTH - 30, 10, 20, 20)];
//    menu.image = [UIImage imageNamed:@"ic_navbar_menu_black.png"];
//    
//    [font0 addSubview:menu];
//    
//    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH - 70, 0, 70, 50)];
//    [menuBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
//    
//    [font0 addSubview:menuBtn];
    
    UILabel *title0 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, font0.frame.size.width - 100, font0.frame.size.height)];
    title0.text = @"Geko Paiement";
    title0.textAlignment = NSTextAlignmentCenter;
    title0.font = [UIFont fontWithName:@"Arial" size:18];
    title0.textColor = [UIColor colorWithRed:27/255.0f green:28/255.0f blue:28/255.0f alpha:1.0f];
    
    [font0 addSubview:title0];
    yRep += font0.frame.size.height + 10;
    
    categoryScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH - 20, SWIDTH * 30 / 100)];
    categoryScroll.delegate = self;
    categoryScroll.showsHorizontalScrollIndicator = NO;
    categoryScroll.scrollEnabled = NO;
    
    [self.view addSubview:categoryScroll];
    
    UIImageView *zone_station = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_station.image = [UIImage imageNamed:@"ic_menu_gas_black.png"];
    
    [categoryScroll addSubview:zone_station];
    
    UILabel *label_station = [[UILabel alloc] initWithFrame:CGRectMake(10 + (SWIDTH * 30 / 100), 10, categoryScroll.frame.size.width - 20 - (SWIDTH * 30 / 100), categoryScroll.frame.size.height - 20)];
    label_station.text = [categories objectAtIndex:0];
    label_station.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    label_station.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    label_station.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_station];
    
    UIImageView *zone_slv = [[UIImageView alloc] initWithFrame:CGRectMake(SWIDTH - 20 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_slv.image = [UIImage imageNamed:@"ic_paiement_2_white.png"];
    
    [categoryScroll addSubview:zone_slv];
    
    UILabel *label_slv = [[UILabel alloc] initWithFrame:CGRectMake(SWIDTH - 20 + 10 + (SWIDTH * 30 / 100), 10, categoryScroll.frame.size.width - 20 - (SWIDTH * 30 / 100), categoryScroll.frame.size.height - 20)];
    label_slv.text = [categories objectAtIndex:1];
    label_slv.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    label_slv.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    label_slv.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_slv];
    
    UIImageView *zone_ra = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 2 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_ra.image = [UIImage imageNamed:@"ic_paiement_3_white.png"];
    
    [categoryScroll addSubview:zone_ra];
    
    UILabel *label_ra = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 2 + 10 + (SWIDTH * 30 / 100), 10, categoryScroll.frame.size.width - 20 - (SWIDTH * 30 / 100), categoryScroll.frame.size.height - 20)];
    label_ra.text = [categories objectAtIndex:2];
    label_ra.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    label_ra.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    label_ra.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_ra];
    
    UIImageView *zone_bbe = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 3 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_bbe.image = [UIImage imageNamed:@"ic_paiement_4_white.png"];
    
    [categoryScroll addSubview:zone_bbe];
    
    UILabel *label_bbe = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 3 + 10 + (SWIDTH * 30 / 100), 10, categoryScroll.frame.size.width - 20 - (SWIDTH * 30 / 100), categoryScroll.frame.size.height - 20)];
    label_bbe.text = [categories objectAtIndex:3];
    label_bbe.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    label_bbe.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    label_bbe.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_bbe];
    
    UIImageView *zone_bricolage = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 4 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_bricolage.image = [UIImage imageNamed:@"ic_paiement_5_white.png"];
    
    [categoryScroll addSubview:zone_bricolage];
    
    UILabel *label_bricolage = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 4 + 10 + (SWIDTH * 30 / 100), 10, categoryScroll.frame.size.width - 20 - (SWIDTH * 30 / 100), categoryScroll.frame.size.height - 20)];
    label_bricolage.text = [categories objectAtIndex:4];
    label_bricolage.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    label_bricolage.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    label_bricolage.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_bricolage];
    
    UIImageView *zone_mode = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 5 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_mode.image = [UIImage imageNamed:@"ic_paiement_6_white.png"];
    
    [categoryScroll addSubview:zone_mode];
    
    UILabel *label_mode = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 5 + 10 + (SWIDTH * 30 / 100), 10, categoryScroll.frame.size.width - 20 - (SWIDTH * 30 / 100), categoryScroll.frame.size.height - 20)];
    label_mode.text = [categories objectAtIndex:5];
    label_mode.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    label_mode.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    label_mode.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_mode];
    
    UIImageView *zone_supermarche = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 6 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_supermarche.image = [UIImage imageNamed:@"ic_paiement_7_white.png"];
    
    [categoryScroll addSubview:zone_supermarche];
    
    UILabel *label_supermarche = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 6 + 10 + (SWIDTH * 30 / 100), 10, categoryScroll.frame.size.width - 20 - (SWIDTH * 30 / 100), categoryScroll.frame.size.height - 20)];
    label_supermarche.text = [categories objectAtIndex:6];
    label_supermarche.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    label_supermarche.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    label_supermarche.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_supermarche];
    
    UIImageView *zone_services = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 7 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_services.image = [UIImage imageNamed:@"ic_paiement_8_white.png"];
    
    [categoryScroll addSubview:zone_services];
    
    UILabel *label_services = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 7 + 10 + (SWIDTH * 30 / 100), 10, categoryScroll.frame.size.width - 20 - (SWIDTH * 30 / 100), categoryScroll.frame.size.height - 20)];
    label_services.text = [categories objectAtIndex:7];
    label_services.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    label_services.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    label_services.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_services];
    yRep += categoryScroll.frame.size.height;
    
    [categoryScroll setContentSize:CGSizeMake((SWIDTH - 20) * 8, SWIDTH * 30 / 100)];
    [categoryScroll setPagingEnabled:YES];
    
//    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20, yRep - 20, SWIDTH - 20, 20)];
//    pageControl.numberOfPages = 8;
//    pageControl.currentPage = 0;
//    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
//    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//    pageControl.enabled = NO;
//    
//    [self.view addSubview:pageControl];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, yRep +9, SWIDTH, 1)];
    sep.backgroundColor = [UIColor colorWithRed:27/255.0f green:28/255.0f blue:28/255.0f alpha:1.0f];
    
    [self.view addSubview:sep];
    
    gekoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yRep + 10, SWIDTH, SHEIGHT - yRep - 10)];
    gekoTableView.backgroundColor = [UIColor clearColor];
    gekoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    gekoTableView.delegate = self;
    gekoTableView.dataSource = self;
    
    [self.view addSubview:gekoTableView];
}

#pragma mark - UITableView management

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *cat = [json objectAtIndex:category];
    NSArray *obj = [cat objectForKey:@"liste"];
    return [obj count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HistoryCell";
    
    NSDictionary *cat = [json objectAtIndex:category];
    NSArray *obj = [cat objectForKey:@"liste"];
    NSDictionary *item = [obj objectAtIndex:indexPath.row];
    
    NSString *add = [NSString stringWithFormat:@"%@, %@", [item objectForKey:@"adresse"], [item objectForKey:@"ville"]];
    
    NSString *logo = [self checkTypeLogoWithLibele:[item objectForKey:@"logo"]];
    
    GekoPaiementTableViewCell *cell = (GekoPaiementTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell = [[GekoPaiementTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault Illustration:[UIImage imageNamed:logo] Name:[item objectForKey:@"enseigne"] Adresse:add ReuseIdentifier:cellIdentifier];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GekoAPI *api = [[GekoAPI alloc] init];
    [api getGekoPayAnnounceWithIdCart:@"51" Completion:^(NSString *results){
        NSDictionary *answer = api.dicResponse;
        if ([[answer objectForKey:@"day_left"] intValue] >= 1) {
            NSLog(@"> 0 jours");
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Annonce Geko" message:[answer objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        } else if([[answer objectForKey:@"day_left"] intValue] == 0) {
            NSLog(@"0 jours");
            NSDictionary *cat = [json objectAtIndex:category];
            NSArray *liste = [cat objectForKey:@"liste"];
            NSDictionary *selected = [liste objectAtIndex:indexPath.row];
            
            NSArray *term = [selected objectForKey:@"terminals"];
            if ([term count] > 0) {
                shopId = [selected objectForKey:@"id"];
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Demande de transaction" message:[NSString stringWithFormat:@"Éffectuer un paiement pour %@?", [selected objectForKey:@"enseigne"]] delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Ok", nil];
                [av setTag:1];
                [av show];
            } else {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Demande de transaction" message:[NSString stringWithFormat:@"Le point de vente %@ ne possède aucun terminal de paiement actuellement", [selected objectForKey:@"enseigne"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
            }
        } else {
            // server error
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Geko Pay" message:[NSString stringWithFormat:@"Bientôt disponible!"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }
    }];
}

- (void)goToTransactionWithIdPdv:(NSString *)pdv {
    GekoTransactionViewController *gtvc = [[GekoTransactionViewController alloc] initWithInfos:pdv];
    [self.navigationController pushViewController:gtvc animated:YES];
}

#pragma mark - ScrollView management

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = categoryScroll.frame.size.width;
    float fractionalPage = categoryScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
    category = (int)page;
    [gekoTableView reloadData];
}

#pragma mark - AlertView management

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 1) {
        switch (buttonIndex) {
            case 0:
                break;
                
            case 1:
                [self goToTransactionWithIdPdv:shopId];
                break;
                
            default:
                break;
        }
    }
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

- (void)goToCategory:(UIButton *)btn {
    [categoryScroll setContentOffset:CGPointMake((SWIDTH - 20) * [btn tag], 0) animated:YES];
    [self showMenu];
}

- (NSString *)checkTypeLogoWithLibele:(NSString *)libelle {
    if ([libelle isEqualToString:@"ENGEN"]) {
        return @"ic_logo_engen.png";
    } else {
        return @"ic_logo_geko.png";
    }
}

@end
