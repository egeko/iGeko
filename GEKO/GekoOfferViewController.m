//
//  GekoOfferViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 7/15/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoOfferViewController.h"

@interface GekoOfferViewController ()

@end

@implementation GekoOfferViewController {
    UITextField *chosenUser;
    UITextField *amount;
    NSString *userName;
    BOOL isTransfering;
    NSString *userId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    isTransfering = NO;
    
    [self setupEnvironment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupEnvironment {
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"GekoDB.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT * FROM userInfos"];
    while([results next]) {
        userId = [results stringForColumn:@"carteid"];
    }
    [database close];
    
    [self makeTheView];
}

#pragma mark - UI

- (void)makeTheView {
    int yRep = 0;
    
    /** nav bar **/
    UIView *font0 = [[UIView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, 40)];
    font0.backgroundColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f];
    
    [self.view addSubview:font0];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    back.image = [UIImage imageNamed:@"ic_back_white.png"];
    
    [font0 addSubview:back];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    
    [font0 addSubview:backBtn];
    
    UILabel *title0 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, font0.frame.size.width - 100, font0.frame.size.height)];
    title0.text = @"Offrir Gekos";
    title0.textAlignment = NSTextAlignmentCenter;
    title0.font = [UIFont fontWithName:@"Arial" size:18];
    title0.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [font0 addSubview:title0];
    yRep += font0.frame.size.height + 40;
    
    UILabel *chosenUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    chosenUserLabel.text = @"Numéro carte: ";
    chosenUserLabel.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [self.view addSubview:chosenUserLabel];
    yRep += 50;
    
    chosenUser = [[UITextField alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    [chosenUser.layer setCornerRadius:8.0f];
    [chosenUser.layer setBorderWidth:1.0f];
    chosenUser.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    [chosenUser.layer setCornerRadius:8.0f];
    chosenUser.delegate = self;
    chosenUser.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:chosenUser];
    yRep += 70;
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    amountLabel.text = @"Points à offrir: ";
    amountLabel.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [self.view addSubview:amountLabel];
    yRep += 50;
    
    amount = [[UITextField alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, 40)];
    [amount.layer setCornerRadius:8.0f];
    [amount.layer setBorderWidth:1.0f];
    amount.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    [amount.layer setCornerRadius:8.0f];
    amount.delegate = self;
    amount.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:amount];
    yRep += 70;
    
    UIButton *transfer = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH / 4, yRep, SWIDTH / 2, 40)];
    [transfer.layer setCornerRadius:8.0f];
    [transfer.layer setBorderWidth:1.0f];
    [transfer.layer setBorderColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f].CGColor];
    [transfer setTitleColor:[UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [transfer setTitle:@"Offrir" forState:UIControlStateNormal];
    [transfer setBackgroundColor:[UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f]];
    [transfer addTarget:self action:@selector(transfer) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:transfer];
}

#pragma mark - Actions

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)transfer {
    if ([amount.text length] > 0 && [chosenUser.text length] > 0) {
        GekoAPI *api = [[GekoAPI alloc] init];
        [api getDestWithUserId:chosenUser.text AndCompletion:^(NSString *results){
            if ([results isEqual:@"OK"]) {
                isTransfering = YES;
                userName = [NSString stringWithFormat:@"%@ %@", [api.dicResponse objectForKey:@"prenom"], [api.dicResponse objectForKey:@"nom"]];
                isTransfering = YES;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Transfert" message:[NSString stringWithFormat:@"Offrir %@ Gekos à %@?", amount.text, userName] delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"OK", nil];
                [av show];
            } else {
                // server error
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat:@"Votre destinataire n'est pas reconnu dans notre base."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
            }
        }];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Transfert" message:@"Veuillez renseigner tous les champs s'il vous plait" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
    }
}

#pragma mark - UIAlertView management

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (isTransfering) {
            GekoAPI *api = [[GekoAPI alloc] init];
            [api offerFromAccount:userId ToAccount:chosenUser.text WithAmount:amount.text AndCompletion:^(NSString *results){
                isTransfering = NO;
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            NSLog(@"pressed");
        }
    }
}

#pragma mark - textField management

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end
