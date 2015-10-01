//
//  GekoProfileViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/22/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoProfileViewController.h"

#import "GekoTransferViewController.h"
#import "GekoOfferViewController.h"

@interface GekoProfileViewController ()

@end

@implementation GekoProfileViewController {
    UIView *whitearea;
    NSString *userid;
    NSString *nom;
    NSString *prenom;
    NSString *carte_statut;
    
    NSDictionary *json;
    int state;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    json = [[NSDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    
    [database open];
    FMResultSet *results2 = [database executeQuery:@"SELECT * FROM userInfos"];
    while([results2 next]) {
        carte_statut = [results2 stringForColumn:@"cartestatus"];
    }
    [database close];
    
    GekoAPI *api = [[GekoAPI alloc] initWithKeys];
    [api getProfileWithUserId:userid AndCompletion:^(NSString *results){
        if ([results isEqual:@"Profile reached"]) {
            json = api.dicResponse;
        } else {
            // server error
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat:@"Erreur serveur, veuillez contacter la Geko Team."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
    font0.backgroundColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f];
    
    [self.view addSubview:font0];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    back.image = [UIImage imageNamed:@"ic_back_black.png"];
    
    [font0 addSubview:back];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    
    [font0 addSubview:backBtn];
    
    UILabel *title0 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, font0.frame.size.width - 100, font0.frame.size.height)];
    title0.text = @"Mon Compte Geko";
    title0.textAlignment = NSTextAlignmentCenter;
    title0.font = [UIFont fontWithName:@"Arial" size:18];
    title0.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [font0 addSubview:title0];
    yRep += font0.frame.size.height + 40;
    
    /** bling bling **/
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, 30)];
    name.text = [NSString stringWithFormat:@"%@ %@", nom, prenom];
    name.textAlignment = NSTextAlignmentCenter;
    name.font = [UIFont fontWithName:@"Arial-BoldMT" size:25];
    name.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [self.view addSubview:name];
    yRep += name.frame.size.height + 20;
    
    UIButton *credit = [[UIButton alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH / 2 - 15, 40)];
    [credit.layer setCornerRadius:8.0f];
    [credit.layer setBorderWidth:1.0f];
    [credit.layer setBorderColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f].CGColor];
    [credit setTitleColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [credit setTitle:@"Transférer €" forState:UIControlStateNormal];
    [credit setBackgroundColor:[UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f]];
    [credit addTarget:self action:@selector(goToTransfer) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:credit];
    
    UIButton *offrir = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH / 2 + 5, yRep, SWIDTH / 2 - 15, 40)];
    [offrir.layer setCornerRadius:8.0f];
    [offrir.layer setBorderWidth:1.0f];
    [offrir.layer setBorderColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f].CGColor];
    [offrir setTitleColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [offrir setTitle:@"Offrir Gekos" forState:UIControlStateNormal];
    [offrir setBackgroundColor:[UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f]];
    [offrir addTarget:self action:@selector(goToOffer) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:offrir];
    yRep += credit.frame.size.height + 20;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Solde", @"Transactions", @"Voucher", nil]];
    segmentedControl.frame = CGRectMake(-5, yRep, SWIDTH + 10, 50);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f];
    [segmentedControl.layer setCornerRadius:0.0];
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f]} forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f]} forState:UIControlStateSelected];
    
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
    
//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    
//    visualEffectView.frame = whitearea.bounds;
//    [whitearea addSubview:visualEffectView];
    
    UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(0, whitearea.frame.size.height / 4 - 1, whitearea.frame.size.width, 1)];
    sep1.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];
    
    [whitearea addSubview:sep1];
    
    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(0, whitearea.frame.size.height / 4 * 2 - 1, whitearea.frame.size.width, 1)];
    sep2.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];
    
    [whitearea addSubview:sep2];
    
    UIView *sep3 = [[UIView alloc] initWithFrame:CGRectMake(0, whitearea.frame.size.height / 4 * 3 - 1, whitearea.frame.size.width, 1)];
    sep3.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];
    
    [whitearea addSubview:sep3];
    
    NSDictionary *solde = [json objectForKey:@"solde"];
    
    UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, whitearea.frame.size.width - 30, whitearea.frame.size.height / 4)];
    money.numberOfLines = 2;
    money.text = [NSString stringWithFormat:@"Crédit: \n%@", [solde objectForKey:@"credit"]];
    money.font = [UIFont fontWithName:@"Arial" size:20];
    money.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [whitearea addSubview:money];
    
    UILabel *gekopoint = [[UILabel alloc] initWithFrame:CGRectMake(15, whitearea.frame.size.height / 4, whitearea.frame.size.width - 30, whitearea.frame.size.height / 4)];
    gekopoint.numberOfLines = 2;
    gekopoint.text = [NSString stringWithFormat:@"Geko Points: \n%@", [solde objectForKey:@"geko_points"]];
    gekopoint.font = [UIFont fontWithName:@"Arial" size:20];
    gekopoint.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [whitearea addSubview:gekopoint];
    
    UILabel *anciennete = [[UILabel alloc] initWithFrame:CGRectMake(15, whitearea.frame.size.height / 4 * 2, whitearea.frame.size.width - 30, whitearea.frame.size.height / 4)];
    anciennete.numberOfLines = 2;
    anciennete.text = [NSString stringWithFormat:@"Ancienneté: \n%@ ans", @"2"];
    anciennete.font = [UIFont fontWithName:@"Arial" size:20];
    anciennete.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [whitearea addSubview:anciennete];
    
    UILabel *concours = [[UILabel alloc] initWithFrame:CGRectMake(15, whitearea.frame.size.height / 4 * 3, whitearea.frame.size.width - 30, whitearea.frame.size.height / 4)];
    concours.numberOfLines = 2;
    concours.text = [NSString stringWithFormat:@"Aucun concours en cours%@", @""];
    concours.font = [UIFont fontWithName:@"Arial" size:20];
    concours.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [whitearea addSubview:concours];
    state = 0;
}

- (void)displayTransaction {
    for (int i = (int)whitearea.subviews.count - 1; i>=0; i--) {
        [[whitearea.subviews objectAtIndex:i] removeFromSuperview];
    }
    
//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    
//    visualEffectView.frame = whitearea.bounds;
//    [whitearea addSubview:visualEffectView];
    
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
    
//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    
//    visualEffectView.frame = whitearea.bounds;
//    [whitearea addSubview:visualEffectView];
    
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

- (void)goToTransfer {
    if ([carte_statut isEqualToString:@"INACTIVE"]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Carte Inactive" message:@"Votre carte est désactivée, vous n'avez pas accès au transfert de monnaie." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
    } else {
        GekoTransferViewController *gtvc = [[GekoTransferViewController alloc] init];
        [self.navigationController pushViewController:gtvc animated:YES];
    }
}

- (void)goToOffer {
    if ([carte_statut isEqualToString:@"INACTIVE"]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Carte Inactive" message:@"Votre carte est désactivée, vous n'avez pas accès au partage de points." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
    } else {
        GekoOfferViewController *govc = [[GekoOfferViewController alloc] init];
        [self.navigationController pushViewController:govc animated:YES];
    }
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
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[currentItem objectForKey:@"date_transaction"] doubleValue] / 1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yy' 'HH:mm'"];
        NSString *localDateString = [dateFormatter stringFromDate:date];
        if ([[currentItem objectForKey:@"type"] isEqualToString:@"debit pm"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ : - %@€ (- %@ GP)", [NSString stringWithFormat:@"%@", localDateString], [currentItem objectForKey:@"montant_monnaie"], ([currentItem objectForKey:@"montant_point"] != nil) ? [currentItem objectForKey:@"montant_point"] : @"0"];
            cell.textLabel.textColor = [UIColor redColor];
            
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ : + %@€ (+ %@ GP)", [NSString stringWithFormat:@"%@", localDateString], [currentItem objectForKey:@"montant_monnaie"], ([currentItem objectForKey:@"montant_point"] != nil) ? [currentItem objectForKey:@"montant_point"] : @"0"];
            cell.textLabel.textColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
        }
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"Voucher #%ld", (long)indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

@end
