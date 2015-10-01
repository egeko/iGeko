//
//  GekoSettingViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/28/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoSettingViewController.h"

@interface GekoSettingViewController ()

@end

@implementation GekoSettingViewController {
    UIScrollView *background;
    UIAlertView *desactivation;
    
    UISwitch *switch9;
    
    UILabel *statutCarte;
    NSString *carte_statut;
    
    BOOL pref1;
    BOOL pref2;
    BOOL pref3;
    BOOL pref4;
    BOOL pref5;
    BOOL pref6;
    BOOL pref7;
    BOOL pref8;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupEnvironment];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup

- (void)setupEnvironment {
    desactivation = [[UIAlertView alloc] initWithTitle:@"Désactiver carte" message:@"Souhaitez-vous vraiment désactiver votre carte Geko?" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Désactiver", nil];
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"GekoDB.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT * FROM userPref"];
    while([results next]) {
        pref1 = [results boolForColumn:@"pref1"];
        pref2 = [results boolForColumn:@"pref2"];
        pref3 = [results boolForColumn:@"pref3"];
        pref4 = [results boolForColumn:@"pref4"];
        pref5 = [results boolForColumn:@"pref5"];
        pref6 = [results boolForColumn:@"pref6"];
        pref7 = [results boolForColumn:@"pref7"];
        pref8 = [results boolForColumn:@"pref8"];
    }
    [database close];
    
    [database open];
    FMResultSet *results2 = [database executeQuery:@"SELECT * FROM userInfos"];
    while([results2 next]) {
        carte_statut = [results2 stringForColumn:@"cartestatus"];
    }
    [database close];
    
    [self makeTheView];
}

#pragma mark - UI

- (void)makeTheView {
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    int yRep = 0;
    
    background = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT)];
    background.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:background];
    
    UIView *font0 = [[UIView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, 40)];
    font0.backgroundColor = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:61/255.0f alpha:1.0f];
    
    [self.view addSubview:font0];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    back.image = [UIImage imageNamed:@"ic_back_white.png"];
    
    [font0 addSubview:back];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    
    [font0 addSubview:backBtn];
    
    UILabel *title0 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, font0.frame.size.width - 100, font0.frame.size.height)];
    title0.text = @"Geko Setting";
    title0.textAlignment = NSTextAlignmentCenter;
    title0.font = [UIFont fontWithName:@"Arial" size:18];
    title0.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    
    [font0 addSubview:title0];
    yRep += font0.frame.size.height;
    yRep += 20;
    
    UIView *fontrub1 = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    fontrub1.backgroundColor = [UIColor clearColor];
    
    [background addSubview:fontrub1];
    
    UILabel *rub1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, fontrub1.frame.size.width - 20, fontrub1.frame.size.height)];
    rub1.text = @"Notifications";
    rub1.textAlignment = NSTextAlignmentCenter;
    rub1.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    rub1.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [fontrub1 addSubview:rub1];
    yRep += rub1.frame.size.height + 10;
    
    UIView *cat1shad = [[UIView alloc] initWithFrame:CGRectMake(20, yRep + 1, SWIDTH - 40, 40)];
    cat1shad.backgroundColor = [UIColor clearColor];
    [cat1shad.layer setBorderWidth:1.0f];
    [cat1shad.layer setBorderColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f].CGColor];
    
    [background addSubview:cat1shad];
    
    UIView *cat1 = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    cat1.backgroundColor = [UIColor clearColor];
    
    [background addSubview:cat1];
    
    UILabel *titlecat1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cat1.frame.size.width - 20, cat1.frame.size.height)];
    titlecat1.text = @"Station service";
    titlecat1.textAlignment = NSTextAlignmentLeft;
    titlecat1.font = [UIFont fontWithName:@"Arial" size:14];
    titlecat1.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [cat1 addSubview:titlecat1];
    
    UISwitch *switch1 = [[UISwitch alloc] initWithFrame:CGRectMake(cat1.frame.size.width - 56, 5, 51, cat1.frame.size.height - 10)];
    switch1.tintColor = [UIColor colorWithRed:70/255.0f green:75/255.0f blue:79/255.0f alpha:1.0f];
    switch1.onTintColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    [switch1 setTag:1];
    [switch1 setOn:pref1];
    [switch1 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [cat1 addSubview:switch1];
    yRep += cat1.frame.size.height + 10;
    
    UIView *cat2shad = [[UIView alloc] initWithFrame:CGRectMake(20, yRep + 1, SWIDTH - 40, 40)];
    cat2shad.backgroundColor = [UIColor clearColor];
    [cat2shad.layer setBorderWidth:1.0f];
    [cat2shad.layer setBorderColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f].CGColor];
    
    [background addSubview:cat2shad];
    
    UIView *cat2 = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    cat2.backgroundColor = [UIColor clearColor];
    
    [background addSubview:cat2];
    
    UILabel *titlecat2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cat2.frame.size.width - 20, cat2.frame.size.height)];
    titlecat2.text = @"Sport, loisir & voyage";
    titlecat2.textAlignment = NSTextAlignmentLeft;
    titlecat2.font = [UIFont fontWithName:@"Arial" size:14];
    titlecat2.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [cat2 addSubview:titlecat2];
    
    UISwitch *switch2 = [[UISwitch alloc] initWithFrame:CGRectMake(cat1.frame.size.width - 56, 5, 51, cat1.frame.size.height - 10)];
    switch2.tintColor = [UIColor colorWithRed:70/255.0f green:75/255.0f blue:79/255.0f alpha:1.0f];
    switch2.onTintColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    [switch2 setTag:2];
    [switch2 setOn:pref2];
    [switch2 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [cat2 addSubview:switch2];
    yRep += cat2.frame.size.height + 10;
    
    UIView *cat3shad = [[UIView alloc] initWithFrame:CGRectMake(20, yRep + 1, SWIDTH - 40, 40)];
    cat3shad.backgroundColor = [UIColor clearColor];
    [cat3shad.layer setBorderWidth:1.0f];
    [cat3shad.layer setBorderColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f].CGColor];
    
    [background addSubview:cat3shad];
    
    UIView *cat3 = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    cat3.backgroundColor = [UIColor clearColor];
    
    [background addSubview:cat3];
    
    UILabel *titlecat3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cat3.frame.size.width - 20, cat3.frame.size.height)];
    titlecat3.text = @"Restauration & alimentation";
    titlecat3.textAlignment = NSTextAlignmentLeft;
    titlecat3.font = [UIFont fontWithName:@"Arial" size:14];
    titlecat3.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [cat3 addSubview:titlecat3];
    
    UISwitch *switch3 = [[UISwitch alloc] initWithFrame:CGRectMake(cat1.frame.size.width - 56, 5, 51, cat1.frame.size.height - 10)];
    switch3.tintColor = [UIColor colorWithRed:70/255.0f green:75/255.0f blue:79/255.0f alpha:1.0f];
    switch3.onTintColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    [switch3 setTag:3];
    [switch3 setOn:pref3];
    [switch3 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [cat3 addSubview:switch3];
    yRep += cat3.frame.size.height + 10;
    
    UIView *cat4shad = [[UIView alloc] initWithFrame:CGRectMake(20, yRep + 1, SWIDTH - 40, 40)];
    cat4shad.backgroundColor = [UIColor clearColor];
    [cat4shad.layer setBorderWidth:1.0f];
    [cat4shad.layer setBorderColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f].CGColor];
    
    [background addSubview:cat4shad];
    
    UIView *cat4 = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    cat4.backgroundColor = [UIColor clearColor];
    
    [background addSubview:cat4];
    
    UILabel *titlecat4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cat4.frame.size.width - 20, cat4.frame.size.height)];
    titlecat4.text = @"Beauté et bien-être";
    titlecat4.textAlignment = NSTextAlignmentLeft;
    titlecat4.font = [UIFont fontWithName:@"Arial" size:14];
    titlecat4.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [cat4 addSubview:titlecat4];
    
    UISwitch *switch4 = [[UISwitch alloc] initWithFrame:CGRectMake(cat1.frame.size.width - 56, 5, 51, cat1.frame.size.height - 10)];
    switch4.tintColor = [UIColor colorWithRed:70/255.0f green:75/255.0f blue:79/255.0f alpha:1.0f];
    switch4.onTintColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    [switch4 setTag:4];
    [switch4 setOn:pref4];
    [switch4 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [cat4 addSubview:switch4];
    yRep += cat3.frame.size.height + 10;
    
    UIView *cat5shad = [[UIView alloc] initWithFrame:CGRectMake(20, yRep + 1, SWIDTH - 40, 40)];
    cat5shad.backgroundColor = [UIColor clearColor];
    [cat5shad.layer setBorderWidth:1.0f];
    [cat5shad.layer setBorderColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f].CGColor];
    
    [background addSubview:cat5shad];
    
    UIView *cat5 = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    cat5.backgroundColor = [UIColor clearColor];
    
    [background addSubview:cat5];
    
    UILabel *titlecat5 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cat5.frame.size.width - 20, cat5.frame.size.height)];
    titlecat5.text = @"Bricolage";
    titlecat5.textAlignment = NSTextAlignmentLeft;
    titlecat5.font = [UIFont fontWithName:@"Arial" size:14];
    titlecat5.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [cat5 addSubview:titlecat5];
    
    UISwitch *switch5 = [[UISwitch alloc] initWithFrame:CGRectMake(cat1.frame.size.width - 56, 5, 51, cat1.frame.size.height - 10)];
    switch5.tintColor = [UIColor colorWithRed:70/255.0f green:75/255.0f blue:79/255.0f alpha:1.0f];
    switch5.onTintColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    [switch5 setTag:5];
    [switch5 setOn:pref5];
    [switch5 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [cat5 addSubview:switch5];
    yRep += cat5.frame.size.height + 10;
    
    UIView *cat6shad = [[UIView alloc] initWithFrame:CGRectMake(20, yRep + 1, SWIDTH - 40, 40)];
    cat6shad.backgroundColor = [UIColor clearColor];
    [cat6shad.layer setBorderWidth:1.0f];
    [cat6shad.layer setBorderColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f].CGColor];
    
    [background addSubview:cat6shad];
    
    UIView *cat6 = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    cat6.backgroundColor = [UIColor clearColor];
    
    [background addSubview:cat6];
    
    UILabel *titlecat6 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cat6.frame.size.width - 20, cat6.frame.size.height)];
    titlecat6.text = @"Mode";
    titlecat6.textAlignment = NSTextAlignmentLeft;
    titlecat6.font = [UIFont fontWithName:@"Arial" size:14];
    titlecat6.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [cat6 addSubview:titlecat6];
    
    UISwitch *switch6 = [[UISwitch alloc] initWithFrame:CGRectMake(cat1.frame.size.width - 56, 5, 51, cat1.frame.size.height - 10)];
    switch6.tintColor = [UIColor colorWithRed:70/255.0f green:75/255.0f blue:79/255.0f alpha:1.0f];
    switch6.onTintColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    [switch6 setTag:6];
    [switch6 setOn:pref6];
    [switch6 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [cat6 addSubview:switch6];
    yRep += cat6.frame.size.height + 10;
    
    UIView *cat7shad = [[UIView alloc] initWithFrame:CGRectMake(20, yRep + 1, SWIDTH - 40, 40)];
    cat7shad.backgroundColor = [UIColor clearColor];
    [cat7shad.layer setBorderWidth:1.0f];
    [cat7shad.layer setBorderColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f].CGColor];
    
    [background addSubview:cat7shad];
    
    UIView *cat7 = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    cat7.backgroundColor = [UIColor clearColor];
    
    [background addSubview:cat7];
    
    UILabel *titlecat7 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cat7.frame.size.width - 20, cat7.frame.size.height)];
    titlecat7.text = @"Supermarché";
    titlecat7.textAlignment = NSTextAlignmentLeft;
    titlecat7.font = [UIFont fontWithName:@"Arial" size:14];
    titlecat7.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [cat7 addSubview:titlecat7];
    
    UISwitch *switch7 = [[UISwitch alloc] initWithFrame:CGRectMake(cat1.frame.size.width - 56, 5, 51, cat1.frame.size.height - 10)];
    switch7.tintColor = [UIColor colorWithRed:70/255.0f green:75/255.0f blue:79/255.0f alpha:1.0f];
    switch7.onTintColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    [switch7 setTag:7];
    [switch7 setOn:pref7];
    [switch7 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [cat7 addSubview:switch7];
    yRep += cat7.frame.size.height + 10;
    
    UIView *cat8shad = [[UIView alloc] initWithFrame:CGRectMake(20, yRep + 1, SWIDTH - 40, 40)];
    cat8shad.backgroundColor = [UIColor clearColor];
    [cat8shad.layer setBorderWidth:1.0f];
    [cat8shad.layer setBorderColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f].CGColor];
    
    [background addSubview:cat8shad];
    
    UIView *cat8 = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    cat8.backgroundColor = [UIColor clearColor];
    
    [background addSubview:cat8];
    
    UILabel *titlecat8 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cat8.frame.size.width - 20, cat8.frame.size.height)];
    titlecat8.text = @"Services";
    titlecat8.textAlignment = NSTextAlignmentLeft;
    titlecat8.font = [UIFont fontWithName:@"Arial" size:14];
    titlecat8.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [cat8 addSubview:titlecat8];
    
    UISwitch *switch8 = [[UISwitch alloc] initWithFrame:CGRectMake(cat1.frame.size.width - 56, 5, 51, cat1.frame.size.height - 10)];
    switch8.tintColor = [UIColor colorWithRed:70/255.0f green:75/255.0f blue:79/255.0f alpha:1.0f];
    switch8.onTintColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    [switch8 setTag:8];
    [switch8 setOn:pref8];
    [switch8 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [cat8 addSubview:switch8];
    yRep += cat8.frame.size.height + 20;
    
    UIView *fontrub2 = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    fontrub2.backgroundColor = [UIColor clearColor];
    
    [background addSubview:fontrub2];
    
    UILabel *rub2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, fontrub2.frame.size.width - 20, fontrub2.frame.size.height)];
    rub2.text = @"Ma carte";
    rub2.textAlignment = NSTextAlignmentCenter;
    rub2.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    rub2.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [fontrub2 addSubview:rub2];
    yRep += rub2.frame.size.height + 10;
    
    UIView *cat9shad = [[UIView alloc] initWithFrame:CGRectMake(20, yRep + 1, SWIDTH - 40, 40)];
    cat9shad.backgroundColor = [UIColor clearColor];
    [cat9shad.layer setBorderWidth:1.0f];
    [cat9shad.layer setBorderColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f].CGColor];
    
    [background addSubview:cat9shad];
    
    UIView *cat9 = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    cat9.backgroundColor = [UIColor clearColor];
    
    [background addSubview:cat9];
    
    UILabel *titlecat9 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cat8.frame.size.width - 20, cat8.frame.size.height)];
    titlecat9.text = @"Statut carte";
    titlecat9.textAlignment = NSTextAlignmentLeft;
    titlecat9.font = [UIFont fontWithName:@"Arial" size:14];
    titlecat9.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [cat9 addSubview:titlecat9];
    
    statutCarte = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cat8.frame.size.width - 75, cat8.frame.size.height)];
    statutCarte.text = @"Carte VALIDE";
    statutCarte.textAlignment = NSTextAlignmentRight;
    statutCarte.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    statutCarte.textColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    
    [cat9 addSubview:statutCarte];
    
    switch9 = [[UISwitch alloc] initWithFrame:CGRectMake(cat1.frame.size.width - 56, 5, 51, cat1.frame.size.height - 10)];
    switch9.tintColor = [UIColor colorWithRed:70/255.0f green:75/255.0f blue:79/255.0f alpha:1.0f];
    switch9.onTintColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    [switch9 setOn:YES];
    [switch9 setTag:9];
    [switch9 addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [switch9 setEnabled:NO];
    
    [cat9 addSubview:switch9];
    
    if ([carte_statut isEqualToString:@"INACTIVE"]) {
        [switch9 setOn:NO];
        [switch9 setEnabled:NO];
        statutCarte.text = @"Carte désactivée";
        statutCarte.textColor = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:61/255.0f alpha:1.0f];
    }
    yRep += cat9.frame.size.height + 20;
    
    UIView *font0b = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    font0b.backgroundColor = [UIColor clearColor];
    
    [background addSubview:font0b];
    
    UILabel *title0b = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, font0b.frame.size.width - 20, font0b.frame.size.height)];
    title0b.text = @"Deconnexion";
    title0b.textAlignment = NSTextAlignmentCenter;
    title0b.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    title0b.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [font0b addSubview:title0b];
    yRep += font0b.frame.size.height + 20;
    
    UIView *font1shad = [[UIView alloc] initWithFrame:CGRectMake(20, yRep + 1, SWIDTH - 40, 40)];
    font1shad.backgroundColor = [UIColor clearColor];
    [font1shad.layer setBorderWidth:1.0f];
    [font1shad.layer setBorderColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f].CGColor];
    
    [background addSubview:font1shad];
    
    UIView *font1 = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    font1.backgroundColor = [UIColor clearColor];
    
    [background addSubview:font1];
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, font1.frame.size.width - 20, font1.frame.size.height)];
    title1.text = @"Logout";
    title1.textAlignment = NSTextAlignmentCenter;
    title1.font = [UIFont fontWithName:@"Arial" size:14];
    title1.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [font1 addSubview:title1];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    [btn1 addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    [background addSubview:btn1];
    yRep += font1.frame.size.height + 10;
    
    background.contentSize = CGSizeMake(SWIDTH, yRep);
}

#pragma mark - Action

- (void)logout {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeSwitch:(id)sender{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"GekoDB.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    switch ([sender tag]) {
        case 1:
            if([sender isOn]){
                [database executeUpdate:@"UPDATE userPref set pref1= ? where id= ?", [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil];
            } else{
                [database executeUpdate:@"UPDATE userPref set pref1= ? where id= ?", [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
            }
            break;
        case 2:
            if([sender isOn]){
                [database executeUpdate:@"UPDATE userPref set pref2= ? where id= ?", [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil];
            } else{
                [database executeUpdate:@"UPDATE userPref set pref2= ? where id= ?", [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
            }
            break;
        case 3:
            if([sender isOn]){
                [database executeUpdate:@"UPDATE userPref set pref3= ? where id= ?", [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil];
            } else{
                [database executeUpdate:@"UPDATE userPref set pref3= ? where id= ?", [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
            }
            break;
        case 4:
            if([sender isOn]){
                [database executeUpdate:@"UPDATE userPref set pref4= ? where id= ?", [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil];
            } else{
                [database executeUpdate:@"UPDATE userPref set pref4= ? where id= ?", [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
            }
            break;
        case 5:
            if([sender isOn]){
                [database executeUpdate:@"UPDATE userPref set pref5= ? where id= ?", [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil];
            } else{
                [database executeUpdate:@"UPDATE userPref set pref5= ? where id= ?", [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
            }
            break;
        case 6:
            if([sender isOn]){
                [database executeUpdate:@"UPDATE userPref set pref6= ? where id= ?", [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil];
            } else{
                [database executeUpdate:@"UPDATE userPref set pref6= ? where id= ?", [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
            }
            break;
        case 7:
            if([sender isOn]){
                [database executeUpdate:@"UPDATE userPref set pref7= ? where id= ?", [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil];
            } else{
                [database executeUpdate:@"UPDATE userPref set pref7= ? where id= ?", [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
            }
            break;
        case 8:
            if([sender isOn]){
                [database executeUpdate:@"UPDATE userPref set pref8= ? where id= ?", [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil];
            } else{
                [database executeUpdate:@"UPDATE userPref set pref8= ? where id= ?", [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
            }
            break;
        case 9:
            if([sender isOn]){
                //
            } else{
                [desactivation show];
            }
            break;
            
        default:
            break;
    }
    [database close];
}

#pragma mark - AlertView management

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [switch9 setOn:YES animated:YES];
        statutCarte.text = @"Carte VALIDE";
        statutCarte.textColor = [UIColor colorWithRed:56/255.0f green:197/255.0f blue:166/255.0f alpha:1.0f];
    }
    
    if (buttonIndex == 1)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Désactivation de votre carte" message:@"Votre carte a été désactivée" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
        [switch9 setEnabled:NO];
        statutCarte.text = @"Carte désactivée";
        statutCarte.textColor = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:61/255.0f alpha:1.0f];
    }
}

@end
