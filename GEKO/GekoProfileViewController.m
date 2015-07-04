//
//  GekoProfileViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/22/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoProfileViewController.h"

@interface GekoProfileViewController ()

@end

@implementation GekoProfileViewController {
    UIView *whitearea;
    NSString *userid;
    NSString *nom;
    NSString *prenom;
    
    NSDictionary *json;
    int state;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    json = [[NSDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:57/255.0f green:62/255.0f blue:68/255.0f alpha:1.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"GekoDB.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT * FROM userInfos"];
    while([results next]) {
        userid = [results stringForColumn:@"carteid"];
        nom = [results stringForColumn:@"nom"];
        prenom = [results stringForColumn:@"prenom"];
    }
    [database close];
    
    GekoAPI *api = [[GekoAPI alloc] initWithKeys];
    [api getProfileWithUserId:userid AndCompletion:^(NSString *results){
        if ([results isEqual:@"Profile reached"]) {
            json = api.dicResponse;
        } else {
            // server error
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Server error" message:[NSString stringWithFormat:@"error #%@", results] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }
        [self makeTheView];
    }];
}

#pragma mark - UI

- (void)makeTheView {
    int yRep = 0;
    
    /** nav bar **/
    UIView *font0 = [[UIView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, 40)];
    font0.backgroundColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    
    [self.view addSubview:font0];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    back.image = [UIImage imageNamed:@"ic_back_white.png"];
    
    [font0 addSubview:back];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    
    [font0 addSubview:backBtn];
    
    UILabel *title0 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, font0.frame.size.width - 100, font0.frame.size.height)];
    title0.text = @"Mon Compte Geko";
    title0.textAlignment = NSTextAlignmentCenter;
    title0.font = [UIFont fontWithName:@"Arial" size:18];
    title0.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    
    [font0 addSubview:title0];
    yRep += font0.frame.size.height + 40;
    
    /** bling bling **/
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, 30)];
    name.text = [NSString stringWithFormat:@"%@ %@", nom, prenom];
    name.textAlignment = NSTextAlignmentCenter;
    name.font = [UIFont fontWithName:@"Arial-BoldMT" size:25];
    name.textColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    
    [self.view addSubview:name];
    yRep += name.frame.size.height + 20;
    
    UIButton *credit = [[UIButton alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH / 2 - 15, 40)];
    [credit.layer setCornerRadius:8.0f];
    [credit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [credit setTitle:@"Transférer" forState:UIControlStateNormal];
    [credit setBackgroundColor:[UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f]];
    
    [self.view addSubview:credit];
    
    UIButton *offrir = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH / 2 + 5, yRep, SWIDTH / 2 - 15, 40)];
    [offrir.layer setCornerRadius:8.0f];
    [offrir setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [offrir setTitle:@"Offrir" forState:UIControlStateNormal];
    [offrir setBackgroundColor:[UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f]];
    
    [self.view addSubview:offrir];
    yRep += credit.frame.size.height + 20;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Solde", @"Transactions", @"Voucher", nil]];
    segmentedControl.frame = CGRectMake(-5, yRep, SWIDTH + 10, 50);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    [segmentedControl.layer setCornerRadius:0.0];
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    
    [self.view addSubview:segmentedControl];
    yRep += segmentedControl.frame.size.height;
    
    whitearea = [[UIView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, SHEIGHT - yRep)];
    whitearea.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.05];
    whitearea.layer.masksToBounds = YES;
    [whitearea setAlpha:0.95];
    
    [self.view addSubview:whitearea];
    yRep += whitearea.frame.size.height;
    
    [self displaySolde];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)displaySolde {
    for (int i = (int)whitearea.subviews.count - 1; i>=0; i--) {
        [[whitearea.subviews objectAtIndex:i] removeFromSuperview];
    }
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = whitearea.bounds;
    [whitearea addSubview:visualEffectView];
    
    UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(0, whitearea.frame.size.height / 4 - 1, whitearea.frame.size.width, 1)];
    sep1.backgroundColor = [UIColor whiteColor];
    
    [whitearea addSubview:sep1];
    
    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(0, whitearea.frame.size.height / 4 * 2 - 1, whitearea.frame.size.width, 1)];
    sep2.backgroundColor = [UIColor whiteColor];
    
    [whitearea addSubview:sep2];
    
    UIView *sep3 = [[UIView alloc] initWithFrame:CGRectMake(0, whitearea.frame.size.height / 4 * 3 - 1, whitearea.frame.size.width, 1)];
    sep3.backgroundColor = [UIColor whiteColor];
    
    [whitearea addSubview:sep3];
    
    NSDictionary *solde = [json objectForKey:@"solde"];
    
    UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whitearea.frame.size.width, whitearea.frame.size.height / 4)];
    money.text = [NSString stringWithFormat:@"Crédit: %@", [solde objectForKey:@"credit"]];
    money.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    money.textAlignment = NSTextAlignmentCenter;
    money.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    
    [whitearea addSubview:money];
    
    UILabel *gekopoint = [[UILabel alloc] initWithFrame:CGRectMake(0, whitearea.frame.size.height / 4, whitearea.frame.size.width, whitearea.frame.size.height / 4)];
    gekopoint.text = [NSString stringWithFormat:@"Geko Points: %@", [solde objectForKey:@"geko_points"]];
    gekopoint.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    gekopoint.textAlignment = NSTextAlignmentCenter;
    gekopoint.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    
    [whitearea addSubview:gekopoint];
    
    UILabel *anciennete = [[UILabel alloc] initWithFrame:CGRectMake(0, whitearea.frame.size.height / 4 * 2, whitearea.frame.size.width, whitearea.frame.size.height / 4)];
    anciennete.text = [NSString stringWithFormat:@"Ancienneté: %@ ans", @"2"];
    anciennete.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    anciennete.textAlignment = NSTextAlignmentCenter;
    anciennete.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    
    [whitearea addSubview:anciennete];
    
    UILabel *concours = [[UILabel alloc] initWithFrame:CGRectMake(0, whitearea.frame.size.height / 4 * 3, whitearea.frame.size.width, whitearea.frame.size.height / 4)];
    concours.text = [NSString stringWithFormat:@"Aucun concours en cours%@", @""];
    concours.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    concours.textAlignment = NSTextAlignmentCenter;
    concours.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    
    [whitearea addSubview:concours];
    state = 0;
}

- (void)displayTransaction {
    for (int i = (int)whitearea.subviews.count - 1; i>=0; i--) {
        [[whitearea.subviews objectAtIndex:i] removeFromSuperview];
    }
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = whitearea.bounds;
    [whitearea addSubview:visualEffectView];
    
    UITableView *transactionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, whitearea.frame.size.width, whitearea.frame.size.height)];
    transactionTableView.backgroundColor = [UIColor clearColor];
    transactionTableView.delegate = self;
    transactionTableView.dataSource = self;
    transactionTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
    [whitearea addSubview:transactionTableView];
}

- (void)displayVoucher {
    for (int i = (int)whitearea.subviews.count - 1; i>=0; i--) {
        [[whitearea.subviews objectAtIndex:i] removeFromSuperview];
    }
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = whitearea.bounds;
    [whitearea addSubview:visualEffectView];
    
    UITableView *voucherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, whitearea.frame.size.width, whitearea.frame.size.height)];
    voucherTableView.backgroundColor = [UIColor clearColor];
    voucherTableView.delegate = self;
    voucherTableView.dataSource = self;
    voucherTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
    [whitearea addSubview:voucherTableView];
}

#pragma mark - Actions

- (void)valueChanged:(UISegmentedControl *)segment {
    
    if(segment.selectedSegmentIndex == 0) {
        state = 0;
        [self displaySolde];
    }else if(segment.selectedSegmentIndex == 1){
        state = 1;
        [self displayTransaction];
    }else if(segment.selectedSegmentIndex == 2){
        state = 2;
        [self displayVoucher];
    }
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView management

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (state == 1) {
        NSArray *transaction = [json objectForKey:@"transactions"];
        return [transaction count];
    } else {
        NSArray *transaction = [json objectForKey:@"vouchers"];
        return [transaction count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HistoryCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    
    if (state == 1) {
        NSArray *transaction = [json objectForKey:@"transactions"];
        NSDictionary *currentItem = [transaction objectAtIndex:indexPath.row];
        if ([[currentItem objectForKey:@"type"] isEqualToString:@"paiement"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ : - %@€ (- %@ points)", [currentItem objectForKey:@"date_transaction"], [currentItem objectForKey:@"montant_monnaie"], ([currentItem objectForKey:@"montant_point"] != nil) ? [currentItem objectForKey:@"montant_point"] : @"0"];
            cell.textLabel.textColor = [UIColor whiteColor];
            
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ : + %@€ (+ %@ points)", [currentItem objectForKey:@"date_transaction"], [currentItem objectForKey:@"montant_monnaie"], ([currentItem objectForKey:@"montant_point"] != nil) ? [currentItem objectForKey:@"montant_point"] : @"0"];
            cell.textLabel.textColor = [UIColor redColor];
        }
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"Voucher #%ld", (long)indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    
    
    return cell;
}

@end
