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
    
    long long expectedLength;
    long long currentLength;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:57/255.0f green:62/255.0f blue:68/255.0f alpha:1.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    for (int i = (int)self.view.subviews.count - 1; i>=0; i--) {
        [[self.view.subviews objectAtIndex:i] removeFromSuperview];
    }
    category = 0;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    GekoAPI *api = [[GekoAPI alloc] init];
    [api getAllShopWithCompletion:^(NSString *results){
        if ([results isEqual:@"OK"]) {
            json = api.arrayResponse;
        } else {
            // server error
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Server error" message:[NSString stringWithFormat:@"error #%@", results] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }
        [self makeTheView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self makeLateralMenu];
    }];
}

- (void)makeLateralMenu {
    menuShown = NO;
    menuFont = [[UIView alloc] initWithFrame:CGRectMake(SWIDTH - 100, 40 - (SHEIGHT - 40), 100, SHEIGHT - 40)];
    menuFont.backgroundColor = [UIColor colorWithRed:53/255.0f green:159/255.0f blue:219/255.0f alpha:1.0f];
    
    for (int i = 0; i < 8; i++) {
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(10, (5 + (menuFont.frame.size.height - 45) / 8) * i, menuFont.frame.size.width - 20, 1)];
        sep.backgroundColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
        
        [menuFont addSubview:sep];
    }
    
    [self.view addSubview:menuFont];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img1.image = [UIImage imageNamed:@"ic_paiement_1_white.png"];
    
    [menuFont addSubview:img1];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    [btn1 setTag:0];
    [btn1 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn1];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5 + (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img2.image = [UIImage imageNamed:@"ic_paiement_2_white.png"];
    
    [menuFont addSubview:img2];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(15, 5 + (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    [btn2 setTag:1];
    [btn2 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn2];
    
    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10 + ((menuFont.frame.size.height - 45) / 8) * 2, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img3.image = [UIImage imageNamed:@"ic_paiement_3_white.png"];
    
    [menuFont addSubview:img3];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(15, 10 + ((menuFont.frame.size.height - 45) / 8) * 2, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    [btn3 setTag:2];
    [btn3 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn3];
    
    UIImageView *img4 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15 + ((menuFont.frame.size.height - 45) / 8) * 3, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img4.image = [UIImage imageNamed:@"ic_paiement_4_white.png"];
    
    [menuFont addSubview:img4];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(15, 15 + ((menuFont.frame.size.height - 45) / 8) * 3, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    [btn4 setTag:3];
    [btn4 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn4];
    
    UIImageView *img5 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20 + ((menuFont.frame.size.height - 45) / 8) * 4, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img5.image = [UIImage imageNamed:@"ic_paiement_5_white.png"];
    
    [menuFont addSubview:img5];
    
    UIButton *btn5 = [[UIButton alloc] initWithFrame:CGRectMake(15, 20 + ((menuFont.frame.size.height - 45) / 8) * 4, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    [btn5 setTag:4];
    [btn5 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn5];
    
    UIImageView *img6 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25 + ((menuFont.frame.size.height - 45) / 8) * 5, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img6.image = [UIImage imageNamed:@"ic_paiement_6_white.png"];
    
    [menuFont addSubview:img6];
    
    UIButton *btn6 = [[UIButton alloc] initWithFrame:CGRectMake(15, 25 + ((menuFont.frame.size.height - 45) / 8) * 5, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    [btn6 setTag:5];
    [btn6 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn6];
    
    UIImageView *img7 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30 + ((menuFont.frame.size.height - 45) / 8) * 6, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img7.image = [UIImage imageNamed:@"ic_paiement_7_white.png"];
    
    [menuFont addSubview:img7];
    
    UIButton *btn7 = [[UIButton alloc] initWithFrame:CGRectMake(15, 30 + ((menuFont.frame.size.height - 45) / 8) * 6, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    [btn7 setTag:6];
    [btn7 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn7];
    
    UIImageView *img8 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35 + ((menuFont.frame.size.height - 45) / 8) * 7, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    img8.image = [UIImage imageNamed:@"ic_paiement_8_white.png"];
    
    [menuFont addSubview:img8];
    
    UIButton *btn8 = [[UIButton alloc] initWithFrame:CGRectMake(15, 35 + ((menuFont.frame.size.height - 45) / 8) * 7, (menuFont.frame.size.height - 45) / 8, (menuFont.frame.size.height - 45) / 8)];
    [btn8 setTag:7];
    [btn8 addTarget:self action:@selector(goToCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuFont addSubview:btn8];
    
    [self.view addSubview:font0];
}

#pragma mark - UI

- (void)makeTheView {
    int yRep = 0;
    
    font0 = [[UIView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, 40)];
    font0.backgroundColor = [UIColor colorWithRed:53/255.0f green:159/255.0f blue:219/255.0f alpha:1.0f];
    
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
    title0.text = @"Geko Paiement";
    title0.textAlignment = NSTextAlignmentCenter;
    title0.font = [UIFont fontWithName:@"Arial" size:18];
    title0.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    
    [font0 addSubview:title0];
    yRep += font0.frame.size.height + 10;
    
    categoryScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH - 20, SWIDTH * 30 / 100)];
    categoryScroll.delegate = self;
    categoryScroll.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:categoryScroll];
    
    UIImageView *zone_station = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_station.image = [UIImage imageNamed:@"ic_paiement_1_white.png"];
    
    [categoryScroll addSubview:zone_station];
    
    UILabel *label_station = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, categoryScroll.frame.size.width - 20, categoryScroll.frame.size.height - 20)];
    label_station.text = @"STATIONS";
    label_station.font = [UIFont fontWithName:@"Arial-BoldMT" size:25];
    label_station.textColor = [UIColor whiteColor];
    label_station.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_station];
    
    UIImageView *zone_slv = [[UIImageView alloc] initWithFrame:CGRectMake(SWIDTH - 20 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_slv.image = [UIImage imageNamed:@"ic_paiement_2_white.png"];
    
    [categoryScroll addSubview:zone_slv];
    
    UILabel *label_slv = [[UILabel alloc] initWithFrame:CGRectMake(SWIDTH - 20 + 10, 10, categoryScroll.frame.size.width - 20, categoryScroll.frame.size.height - 20)];
    label_slv.text = @"CAT 2";
    label_slv.font = [UIFont fontWithName:@"Arial-BoldMT" size:25];
    label_slv.textColor = [UIColor whiteColor];
    label_slv.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_slv];
    
    UIImageView *zone_ra = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 2 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_ra.image = [UIImage imageNamed:@"ic_paiement_3_white.png"];
    
    [categoryScroll addSubview:zone_ra];
    
    UILabel *label_ra = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 2 + 10, 10, categoryScroll.frame.size.width - 20, categoryScroll.frame.size.height - 20)];
    label_ra.text = @"CAT 3";
    label_ra.font = [UIFont fontWithName:@"Arial-BoldMT" size:25];
    label_ra.textColor = [UIColor whiteColor];
    label_ra.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_ra];
    
    UIImageView *zone_bbe = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 3 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_bbe.image = [UIImage imageNamed:@"ic_paiement_4_white.png"];
    
    [categoryScroll addSubview:zone_bbe];
    
    UILabel *label_bbe = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 3 + 10, 10, categoryScroll.frame.size.width - 20, categoryScroll.frame.size.height - 20)];
    label_bbe.text = @"CAT 4";
    label_bbe.font = [UIFont fontWithName:@"Arial-BoldMT" size:25];
    label_bbe.textColor = [UIColor whiteColor];
    label_bbe.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_bbe];
    
    UIImageView *zone_bricolage = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 4 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_bricolage.image = [UIImage imageNamed:@"ic_paiement_5_white.png"];
    
    [categoryScroll addSubview:zone_bricolage];
    
    UILabel *label_bricolage = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 4 + 10, 10, categoryScroll.frame.size.width - 20, categoryScroll.frame.size.height - 20)];
    label_bricolage.text = @"CAT 5";
    label_bricolage.font = [UIFont fontWithName:@"Arial-BoldMT" size:25];
    label_bricolage.textColor = [UIColor whiteColor];
    label_bricolage.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_bricolage];
    
    UIImageView *zone_mode = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 5 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_mode.image = [UIImage imageNamed:@"ic_paiement_6_white.png"];
    
    [categoryScroll addSubview:zone_mode];
    
    UILabel *label_mode = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 5 + 10, 10, categoryScroll.frame.size.width - 20, categoryScroll.frame.size.height - 20)];
    label_mode.text = @"CAT 6";
    label_mode.font = [UIFont fontWithName:@"Arial-BoldMT" size:25];
    label_mode.textColor = [UIColor whiteColor];
    label_mode.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_mode];
    
    UIImageView *zone_supermarche = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 6 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_supermarche.image = [UIImage imageNamed:@"ic_paiement_7_white.png"];
    
    [categoryScroll addSubview:zone_supermarche];
    
    UILabel *label_supermarche = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 6 + 10, 10, categoryScroll.frame.size.width - 20, categoryScroll.frame.size.height - 20)];
    label_supermarche.text = @"CAT 7";
    label_supermarche.font = [UIFont fontWithName:@"Arial-BoldMT" size:25];
    label_supermarche.textColor = [UIColor whiteColor];
    label_supermarche.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_supermarche];
    
    UIImageView *zone_services = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 7 + 10, 10, SWIDTH * 30 / 100 - 20, SWIDTH * 30 / 100 - 20)];
    zone_services.image = [UIImage imageNamed:@"ic_paiement_8_white.png"];
    
    [categoryScroll addSubview:zone_services];
    
    UILabel *label_services = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 20) * 7 + 10, 10, categoryScroll.frame.size.width - 20, categoryScroll.frame.size.height - 20)];
    label_services.text = @"CAT 8";
    label_services.font = [UIFont fontWithName:@"Arial-BoldMT" size:25];
    label_services.textColor = [UIColor whiteColor];
    label_services.textAlignment = NSTextAlignmentCenter;
    
    [categoryScroll addSubview:label_services];
    yRep += categoryScroll.frame.size.height;
    
    [categoryScroll setContentSize:CGSizeMake((SWIDTH - 20) * 8, SWIDTH * 30 / 100)];
    [categoryScroll setPagingEnabled:YES];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20, yRep - 20, SWIDTH - 20, 20)];
    pageControl.numberOfPages = 8;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.enabled = NO;
    
    [self.view addSubview:pageControl];
    
    gekoTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, yRep + 10, SWIDTH - 20, SHEIGHT - yRep - 20)];
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
    
    GekoPaiementTableViewCell *cell = (GekoPaiementTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell = [[GekoPaiementTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault Illustration:[UIImage imageNamed:[NSString stringWithFormat:@"station4.jpg"]] Name:[item objectForKey:@"enseigne"] Adresse:[item objectForKey:@"adresse"] ReuseIdentifier:cellIdentifier];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
}

@end
