//
//  ConnectionViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/18/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "ConnectionViewController.h"

#import "MenuViewController.h"

static NSString * const kIdentifier = @"jaalee.Example";

@interface ConnectionViewController ()<JLEBeaconManagerDelegate>

@property (nonatomic, strong) JLEBeaconManager  *beaconManager;
@property (nonatomic, strong) JLEBeaconRegion  *beaconRegion;

@end

@implementation ConnectionViewController {
    UIScrollView *scrollView;
    UITextField *activeField;
    UITextField *password;
    UITextField *username;
    
    NSDictionary *userObject;
}

- (void)viewDidLoad {
    userObject = [[NSDictionary alloc] init];
    
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self registerForKeyboardNotifications];
    [self makeTheView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)makeTheView {
    self.view.backgroundColor = [UIColor colorWithRed:57/255.0f green:62/255.0f blue:68/255.0f alpha:1.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /** Background **/
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT)];
    background.image = [UIImage imageNamed:@"bc_connection_background2.png"];
    
    [self.view addSubview:background];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT)];
    scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];
    int yRep = SHEIGHT / 10;
    
    /** Logo area **/
    UIView *whitearea = [[UIView alloc] initWithFrame:CGRectMake(20, yRep, SWIDTH - 40, SWIDTH - 180)];
    whitearea.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.0f];
    [whitearea setAlpha:0.95];
    
    [scrollView addSubview:whitearea];
    
//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    
//    visualEffectView.frame = whitearea.bounds;
//    [whitearea addSubview:visualEffectView];
    yRep += 20;
    
    /** Logo **/
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(60, 40, whitearea.frame.size.width - 120, whitearea.frame.size.height - 80)];
    logo.image = [UIImage imageNamed:@"bc_connection_logo.png"];
    
    [whitearea addSubview:logo];
    yRep += SHEIGHT / 10 * 5;
    
    /** Connection **/
    UIView *username_bc = [[UIView alloc] initWithFrame:CGRectMake(30, yRep, SWIDTH - 60, 40)];
    username_bc.backgroundColor = [UIColor whiteColor];
    [username_bc.layer setCornerRadius:8.0];
    [username_bc.layer setBorderColor:[UIColor colorWithRed:223/250.0f green:223/250.0f blue:223/250.0f alpha:1.0f].CGColor];
    [username_bc.layer setBorderWidth:1.0];
    
    [scrollView addSubview:username_bc];
    
    UIImageView *username_ic = [[UIImageView alloc] initWithFrame:CGRectMake(40, yRep + 10, 20, 20)];
    username_ic.image = [UIImage imageNamed:@"ic_home_user.png"];
    
    [scrollView addSubview:username_ic];
    
    username = [[UITextField alloc] initWithFrame:CGRectMake(40, 5, username_bc.frame.size.width - 45, username_bc.frame.size.height - 10)];
    username.placeholder = @"nom d'utilisateur";
    [username.layer setCornerRadius:8.0];
    username.delegate = self;
    
    [username_bc addSubview:username];
    yRep += username.frame.size.height + 20;
    
    UIView *password_bc = [[UIView alloc] initWithFrame:CGRectMake(30, yRep, SWIDTH - 60, 40)];
    password_bc.backgroundColor = [UIColor whiteColor];
    [password_bc.layer setCornerRadius:8.0];
    [password_bc.layer setBorderColor:[UIColor colorWithRed:223/250.0f green:223/250.0f blue:223/250.0f alpha:1.0f].CGColor];
    [password_bc.layer setBorderWidth:1.0];
    
    [scrollView addSubview:password_bc];
    
    UIImageView *password_ic = [[UIImageView alloc] initWithFrame:CGRectMake(40, yRep + 10, 20, 20)];
    password_ic.image = [UIImage imageNamed:@"ic_home_pass.png"];
    
    [scrollView addSubview:password_ic];
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(40, 5, password_bc.frame.size.width - 45, password_bc.frame.size.height - 10)];
    password.placeholder = @"mot de passe";
    [password.layer setCornerRadius:8.0];
    password.secureTextEntry = YES;
    password.delegate = self;
    
    [password_bc addSubview:password];
    yRep += password.frame.size.height + 40;
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(60, yRep, SWIDTH - 120, 40)];
    btn1.backgroundColor = [UIColor whiteColor];
    [btn1.layer setCornerRadius:8.0];
    [btn1 addTarget:self action:@selector(connectController) forControlEvents:UIControlEventTouchUpInside];
    [btn1.layer setBorderColor:[UIColor colorWithRed:188/250.0f green:189/250.0f blue:190/250.0f alpha:1.0f].CGColor];
    [btn1.layer setBorderWidth:1.0];
    
    [scrollView addSubview:btn1];
    
    UILabel *btn1design = [[UILabel alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, 40)];
    btn1design.textColor = [UIColor colorWithRed:33/255.0f green:49/255.0f blue:120/255.0f alpha:1.0f];
    btn1design.font = [UIFont fontWithName:@"Arial" size:20];
    btn1design.text = @"Connexion";
    btn1design.textAlignment = NSTextAlignmentCenter;
    
    [scrollView addSubview:btn1design];
    
    UIImageView *btn1pic = [[UIImageView alloc] initWithFrame:CGRectMake(65, yRep + 5, 30, 29)];
    btn1pic.image = [UIImage imageNamed:@""];
    
    [scrollView addSubview:btn1pic];
    
    yRep += btn1.frame.size.height + 20;
    
}

#pragma mark - actions

- (void)connectController {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_logo_small.png"]];
    hud.labelText = @"Loading";
    hud.labelColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        GekoAPI *api = [[GekoAPI alloc] initWithKeys];
        [api connectWithUserId:username.text Password:password.text AndCompletion:^(NSString *results){
            if ([results isEqual:@"OK"]) {
                userObject = api.dicResponse;
                
                NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDir = [docPaths objectAtIndex:0];
                NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"GekoDB.sqlite"];
                
                FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
                [database open];
                [database executeUpdate:@"DELETE FROM userInfos"];
                [database executeUpdate:@"INSERT INTO userInfos (id, nom, prenom, carteid, cartestatus, password) VALUES (?, ?, ?, ?, ?, ?)", [NSNumber numberWithInt:[[userObject objectForKey:@"id"] intValue]], [NSString stringWithFormat:@"%@", [userObject objectForKey:@"nom"]], [NSString stringWithFormat:@"%@", [userObject objectForKey:@"prenom"]], [NSString stringWithFormat:@"%@", username.text], [userObject objectForKey:@"status"], [NSString stringWithFormat:@"%@", password.text], nil];
                [database close];
                
                username.text = @"";
                password.text = @"";
                [self.view endEditing:YES];
                
                MenuViewController *mvc = [[MenuViewController alloc] init];
                [self.navigationController pushViewController:mvc animated:YES];
                
            } else {
                // server error
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat:@"Erreur serveur, veuillez contacter la Geko Team."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [scrollView setContentSize:CGSizeMake(SWIDTH, SHEIGHT)];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - setup

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - textField management

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end