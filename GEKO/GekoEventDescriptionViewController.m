//
//  GekoEventDescriptionViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 7/21/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoEventDescriptionViewController.h"

@interface GekoEventDescriptionViewController ()

@end

@implementation GekoEventDescriptionViewController {
    NSArray *json;
    UIView *font0;
    UIScrollView *background;
    BOOL shareShown;
    UIView *shareView;
    
    NSString *content_passed;
    NSString *date_passed;
    NSString *id_passed;
    NSString *title_passed;
}

- (id)initWithMessage:(NSString *)message Date:(NSString *)date Idmess:(NSString *)idmess {
    if (self = [super init]) {
        content_passed = message;
        date_passed = date;
        id_passed = idmess;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    for (int i = (int)self.view.subviews.count - 1; i>=0; i--) {
        [[self.view.subviews objectAtIndex:i] removeFromSuperview];
    }
    
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

#pragma mark - setup

- (void)setupEnvironment {
    shareShown = NO;
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
    }];
}

#pragma mark - UI

- (void)makeTheView {
    int yRep = 0;
    
    background = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT)];
    background.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:background];
    
    font0 = [[UIView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, 40)];
    font0.backgroundColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f];
    
    [self.view addSubview:font0];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    back.image = [UIImage imageNamed:@"ic_back_black.png"];
    
    [font0 addSubview:back];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    
    [font0 addSubview:backBtn];
    
    UILabel *title0 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, font0.frame.size.width - 100, font0.frame.size.height)];
    title0.text = @"BON PLAN";
    title0.textAlignment = NSTextAlignmentCenter;
    title0.font = [UIFont fontWithName:@"Arial" size:18];
    title0.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [font0 addSubview:title0];
    
    UIImageView *share = [[UIImageView alloc] initWithFrame:CGRectMake(SWIDTH - 40, 0, 40, 40)];
    share.image = [UIImage imageNamed:@"ic_event_share.png"];
    
    [font0 addSubview:share];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH - 40, 0, 40, 40)];
    [shareButton addTarget:self action:@selector(shareContent) forControlEvents:UIControlEventTouchUpInside];
    
    [font0 addSubview:shareButton];
    yRep += font0.frame.size.height + 10;
    
    UIImageView *illustration = [[UIImageView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, SHEIGHT / 2.5)];
    
    [background addSubview:illustration];
    yRep += illustration.frame.size.height + 10;
    
    GekoAPI *api = [[GekoAPI alloc] init];
    [api getAllPostAttachmentWithId:id_passed Completion:^(NSString *results){
        NSArray *data = [api.dicResponse objectForKey:@"data"];
        NSDictionary *first = [data firstObject];
        NSDictionary *media = [first objectForKey:@"media"];
        NSDictionary *image = [media objectForKey:@"image"];
        NSString *url_to_inject = [image objectForKey:@"src"];
        illustration.contentMode = UIViewContentModeScaleAspectFit;
        
        if (url_to_inject) {
            [illustration setImageWithURL:[NSURL URLWithString:url_to_inject]];
        } else {
            [api getAllEventAttachmentWithId:id_passed Completion:^(NSString *results){
                NSDictionary *cover = [api.dicResponse objectForKey:@"cover"];
                NSString *url_to_inject = [cover objectForKey:@"source"];
                illustration.contentMode = UIViewContentModeScaleAspectFit;
                
                if (url_to_inject) {
                    [illustration setImageWithURL:[NSURL URLWithString:url_to_inject]];
                } else {
                    // server error
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat:@"Erreur serveur, veuillez contacter la Geko Team."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [av show];
                }
            }];
        }
    }];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *date  = [dateFormatter dateFromString:date_passed];
    
    // Convert to new Date Format
    [dateFormatter setDateFormat:@"dd-MM-yy HH:mm"];
    NSString *newDate = [dateFormatter stringFromDate:date];
    
    UITextView *titre = [[UITextView alloc] initWithFrame:CGRectMake(5, yRep, SWIDTH - 10, 200)];
    titre.text = newDate;
    titre.textAlignment = NSTextAlignmentCenter;
    titre.font = [UIFont fontWithName:@"Arial" size:18];
    titre.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    titre.backgroundColor = [UIColor clearColor];
    [titre sizeToFit];
    
    [background addSubview:titre];
    yRep += titre.frame.size.height + 9;
    
    UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, 1)];
    sep1.backgroundColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f];
    
    [self.view addSubview:sep1];
    yRep += 11;
    
    UITextView *content = [[UITextView alloc] initWithFrame:CGRectMake(10, yRep, SWIDTH - 20, 1000)];
    content.text = content_passed;
    [content sizeToFit];
    content.backgroundColor = [UIColor clearColor];
    [content setEditable:NO];
    content.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [background addSubview:content];
    yRep += content.frame.size.height + 10;
    
    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, 1)];
    sep2.backgroundColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f];
    
    [background addSubview:sep2];
    
    background.contentSize = CGSizeMake(SWIDTH, yRep);
    
    shareView = [[UIView alloc] initWithFrame:CGRectMake(0, SHEIGHT, SWIDTH, 150)];
    shareView.backgroundColor = [UIColor colorWithRed:53/255.0f green:159/255.0f blue:219/255.0f alpha:1.0f];
    
    [self.view addSubview:shareView];
    
    UILabel *titleshare = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, shareView.frame.size.width - 40, 40)];
    titleshare.text = @"Partager sur mes réseaux sociaux:";
    titleshare.font = [UIFont fontWithName:@"Arial" size:16];
    titleshare.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    
    [shareView addSubview:titleshare];
}

#pragma mark - Actions

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showShareView {
    if (shareShown) {
        [UIView animateWithDuration:0.5f animations:^{
            shareView.frame = CGRectOffset(shareView.frame, 0, 150);
        }];
        shareShown = NO;
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            shareView.frame = CGRectOffset(shareView.frame, 0, - 150);
        }];
        shareShown = YES;
    }
}

- (void)shareContent {
    NSString *message = content_passed;
    UIImage *image = [UIImage imageNamed:@"ic_logo.png"];
    
    NSArray *shareItems = @[message, image];
    
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    
    [self presentViewController:avc animated:YES completion:nil];
}

@end
