//
//  GekoTransactionViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 6/21/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoTransactionViewController.h"

#import "MMMaterialDesignSpinner.h"

@interface GekoTransactionViewController ()

@end

@implementation GekoTransactionViewController {
    UIView *font0;
    MMMaterialDesignSpinner *spinnerView;
    UILabel *paiement;
    UILabel *statut;
    UILabel *montant;
    UILabel *enseigne;
    UIView *cancelFont;
    UILabel *cancelLabel;
    UIButton *backBtn;
    UITextField *pinCode;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    int page;
    
    NSDictionary *firstResp;
    NSDictionary *secondResp;
    NSDictionary *thirdResp;
    NSString *token;
}

@synthesize infos = _infos;

- (id)initWithInfos:(NSString *)info {
    if (self = [super init]) {
        self.infos = info;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    page = 0;
    firstResp = [[NSDictionary alloc] init];
    secondResp = [[NSDictionary alloc] init];
    thirdResp = [[NSDictionary alloc] init];
    
    [self makeTheView];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)makeTheView {
    self.view.backgroundColor = [UIColor colorWithRed:57/255.0f green:62/255.0f blue:68/255.0f alpha:1.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    int yRep = 10;
    
    font0 = [[UIView alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH - 20, 40)];
    font0.backgroundColor = [UIColor colorWithRed:53/255.0f green:159/255.0f blue:219/255.0f alpha:1.0f];
    
    [self.view addSubview:font0];
    
    UILabel *title0 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, font0.frame.size.width - 100, font0.frame.size.height)];
    title0.text = @"Transaction";
    title0.textAlignment = NSTextAlignmentCenter;
    title0.font = [UIFont fontWithName:@"Arial" size:18];
    title0.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    
    [font0 addSubview:title0];
    yRep += font0.frame.size.height;
    
    /** canvas **/
    UIView *shadowCanvas = [[UIView alloc] initWithFrame:CGRectMake(10, yRep + 1, SWIDTH - 20, SHEIGHT - font0.frame.size.height - (SHEIGHT / 8))];
    shadowCanvas.backgroundColor = [UIColor colorWithRed:86/255.0f green:91/255.0f blue:95/255.0f alpha:1.0f];
    
    [self.view addSubview:shadowCanvas];
    
    UIView *canvas = [[UIView alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH - 20, SHEIGHT - font0.frame.size.height - (SHEIGHT / 8))];
    canvas.backgroundColor = [UIColor colorWithRed:40/255.0f green:43/255.0f blue:48/255.0f alpha:1.0f];
    
    [self.view addSubview:canvas];
    
    cancelFont = [[UIView alloc] initWithFrame:CGRectMake(SWIDTH / 2 - 70, SHEIGHT - 60, 140, 50)];
    cancelFont.backgroundColor = [UIColor colorWithRed:122/255.0f green:129/255.0f blue:134/255.0f alpha:1.0f];
    
    [self.view addSubview:cancelFont];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, canvas.frame.size.width, canvas.frame.size.height)];
    [scrollView setContentSize:CGSizeMake(canvas.frame.size.width * 4, canvas.frame.size.height)];
    scrollView.scrollEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [canvas addSubview:scrollView];
    
    // PAGE 1
    /** statut label **/
    statut = [[UILabel alloc] initWithFrame:CGRectMake(5, canvas.frame.size.height / 4 - 20, canvas.frame.size.width - 10, 40)];
    statut.text = @"Demande de transaction";
    statut.textAlignment = NSTextAlignmentCenter;
    statut.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    statut.textColor = [UIColor whiteColor];
    
    [scrollView addSubview:statut];
    
    /** spinner **/
    spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectZero];
    spinnerView.bounds = CGRectMake(0, 0, 100, 100);
    spinnerView.tintColor = [UIColor colorWithRed:53/255.0f green:159/255.0f blue:219/255.0f alpha:1.0f];
    spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:spinnerView];
    
    [spinnerView startAnimating];
    
    // PAGE 2
    /** infos **/
    paiement = [[UILabel alloc] initWithFrame:CGRectMake(5 + canvas.frame.size.width, 20, canvas.frame.size.width - 10, 40)];
    paiement.text = @"Paiement ";
    paiement.textAlignment = NSTextAlignmentCenter;
    paiement.font = [UIFont fontWithName:@"Arial" size:20];
    paiement.textColor = [UIColor whiteColor];
    
    [scrollView addSubview:paiement];
    
    montant = [[UILabel alloc] initWithFrame:CGRectMake(5 + canvas.frame.size.width, 60, canvas.frame.size.width - 10, 40)];
    montant.text = @"Montant:";
    montant.textAlignment = NSTextAlignmentCenter;
    montant.font = [UIFont fontWithName:@"Arial" size:20];
    montant.textColor = [UIColor whiteColor];
    
    [scrollView addSubview:montant];
    
    enseigne = [[UILabel alloc] initWithFrame:CGRectMake(5 + canvas.frame.size.width, 100, canvas.frame.size.width - 10, 40)];
    enseigne.text = @"Enseigne:";
    enseigne.textAlignment = NSTextAlignmentCenter;
    enseigne.font = [UIFont fontWithName:@"Arial" size:20];
    enseigne.textColor = [UIColor whiteColor];
    
    [scrollView addSubview:enseigne];
    
    /** label **/
    UILabel *statut2 = [[UILabel alloc] initWithFrame:CGRectMake(5 + canvas.frame.size.width, canvas.frame.size.height / 3 - 20, canvas.frame.size.width - 10, 40)];
    statut2.text = @"Code pin:";
    statut2.textAlignment = NSTextAlignmentCenter;
    statut2.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    statut2.textColor = [UIColor whiteColor];
    
    [scrollView addSubview:statut2];
    
    /** pin code **/
    pinCode = [[UITextField alloc] initWithFrame:CGRectMake(90 + canvas.frame.size.width, canvas.frame.size.height / 3 + 30, canvas.frame.size.width - 180, 60)];
    pinCode.backgroundColor = [UIColor whiteColor];
    [pinCode.layer setCornerRadius:8.0f];
    pinCode.textAlignment = NSTextAlignmentCenter;
    pinCode.secureTextEntry = YES;
    pinCode.delegate = self;
    
    [scrollView addSubview:pinCode];
    
    UIImageView *btnFont = [[UIImageView alloc] initWithFrame:CGRectMake(canvas.frame.size.width * 3 / 2 + 110, canvas.frame.size.height / 3 + 40, 40, 40)];
    btnFont.image = [UIImage imageNamed:@"ic_next_white.png"];
    
    [scrollView addSubview:btnFont];
    
    UIButton *btnNext = [[UIButton alloc] initWithFrame:CGRectMake(canvas.frame.size.width * 3 / 2 + 100, canvas.frame.size.height / 3 + 30, 60, 60)];
    [btnNext addTarget:self action:@selector(validPin) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:btnNext];
    
    // PAGE 3
    /** statut label **/
    UILabel *statut3 = [[UILabel alloc] initWithFrame:CGRectMake(5 + canvas.frame.size.width * 2, canvas.frame.size.height / 4 - 20, scrollView.frame.size.width - 10, 40)];
    statut3.text = @"Demande de paiement en cours...";
    statut3.textAlignment = NSTextAlignmentCenter;
    statut3.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    statut3.textColor = [UIColor whiteColor];
    
    [scrollView addSubview:statut3];
    
    // PAGE 4
    /** statut label **/
    UILabel *statut4 = [[UILabel alloc] initWithFrame:CGRectMake(5 + canvas.frame.size.width * 3, canvas.frame.size.height / 4 - 20, scrollView.frame.size.width - 10, 40)];
    statut4.text = @"Paiement validé!";
    statut4.textAlignment = NSTextAlignmentCenter;
    statut4.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    statut4.textColor = [UIColor whiteColor];
    
    [scrollView addSubview:statut4];
    
    /** page control **/
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, canvas.frame.size.height - 40, canvas.frame.size.width - 20, 20)];
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.enabled = NO;
    
    [canvas addSubview:pageControl];
    
    /** cancel button **/
    cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, cancelFont.frame.size.width - 10, cancelFont.frame.size.height - 10)];
    cancelLabel.text = @"Annuler";
    cancelLabel.textColor = [UIColor whiteColor];
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    
    [cancelFont addSubview:cancelLabel];
    
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cancelFont.frame.size.width, cancelFont.frame.size.height)];
    [backBtn addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelFont addSubview:backBtn];
    [self initTransactions];
}

#pragma mark - Actions

- (void)backView {
    // Add cancel request here
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelView {
    // Add cancel request here
    NSLog(@"call cancel ws");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goToNextStep:(UIButton *)btn {
    float fractionalPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSInteger pageRef = lround(fractionalPage);
    if (pageRef == 0 || pageRef == 2) {
        [spinnerView stopAnimating];
    } else if (pageRef == 1) {
        [spinnerView startAnimating];
    }
    
    if(pageRef == 2) {
        cancelLabel.text = @"Fermer";
        backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cancelFont.frame.size.width, cancelFont.frame.size.height)];
        [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (pageRef < 4) {
        page++;
        pageControl.currentPage = page;
        [scrollView setContentOffset:CGPointMake((scrollView.frame.size.width) * page, 0) animated:YES];
    }
}

- (void)validPin {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Valider paiement?" message:@"Vous êtes sur le point de valider votre transaction" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Ok", nil];
    [av show];
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 4 && range.length == 0)
        return NO;
    return string;
}

#pragma mark: server transations

- (void)initTransactions {
    GekoAPI *api = [[GekoAPI alloc] init];
    [api initTransactionWithCompletion:^(NSString *results){
        if ([results intValue] >= 0) {
            firstResp = api.dicResponse;
            token = [firstResp objectForKey:@"token"];
            statut.text = @"Récupération des infos paiement";
            [self findList];
        } else {
            // server error
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Server error" message:[NSString stringWithFormat:@"error #%@", results] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }
    }];
}

- (void)findList {
    GekoAPI *api = [[GekoAPI alloc] init];
    [api askListWithCompletion:^(NSString *results){
        if ([results isEqualToString:@"VALIDER"]) {
            secondResp = api.dicResponse;
            
            NSDictionary *terminal = [secondResp objectForKey:@"terminal"];
            NSDictionary *pointDeVente = [terminal objectForKey:@"pointDeVente"];
            
            montant.text = [NSString stringWithFormat:@"Montant: %@€", [secondResp objectForKey:@"montant"]];
            enseigne.text = [NSString stringWithFormat:@"Enseigne: %@", [pointDeVente objectForKey:@"enseigne"]];
            paiement.text = [NSString stringWithFormat:@"Paiement %@", [pointDeVente objectForKey:@"id"]];
            
            [self goToNextStep:nil];
        } else {
            [self findList];
        }
    }];
}

- (void)validWithPinCode:(NSString *)pinCode {
    GekoAPI *api = [[GekoAPI alloc] init];
    [api validePaymentWithToken:token PinCode:nil AndCompletion:^(NSString *results){
        if ([results isEqualToString:@"FINALISER"]) {
            thirdResp = api.dicResponse;
            [self goToNextStep:nil];
        } else {
            // server error
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Server error" message:[NSString stringWithFormat:@"error #%@", results] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];

        }
    }];
}

#pragma mark - UIAlertView management

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
            
        case 1:
            page++;
            pageControl.currentPage = page;
            [scrollView setContentOffset:CGPointMake((scrollView.frame.size.width) * page, 0) animated:YES];
            [self validWithPinCode:pinCode.text];
            break;
            
        default:
            break;
    }
}

@end
