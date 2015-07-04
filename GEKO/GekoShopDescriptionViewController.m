//
//  GekoShopDescriptionViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/21/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoShopDescriptionViewController.h"

@interface GekoShopDescriptionViewController ()

@end

@implementation GekoShopDescriptionViewController

@synthesize infos = _infos;

- (id)initWithInformation:(NSDictionary *)information {
    if (self = [super init]) {
        self.infos = information;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupEnvironment];
    [self makeTheView];
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup

- (void)setupEnvironment {
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - UI

- (void)makeTheView {
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    int yRep = 5;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, yRep, SWIDTH - 10, SWIDTH - 10)];
    imageView.image = [UIImage imageNamed:@"ic_shop_default_item.png"];
    
    [self.view addSubview:imageView];
    yRep += imageView.frame.size.height + 10;
    
    UILabel *nom_article = [[UILabel alloc] initWithFrame:CGRectMake(5, yRep, SWIDTH - 10, 30)];
    nom_article.text = [NSString stringWithFormat:@"Nom: %@", [_infos objectForKey:@"nom"]];
    
    [self.view addSubview:nom_article];
    yRep += nom_article.frame.size.height;
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(5, yRep, SWIDTH - 10, 30)];
    description.text = [NSString stringWithFormat:@"Description: %@", [_infos objectForKey:@"description"]];
    
    [self.view addSubview:description];
    yRep += description.frame.size.height;
    
    UILabel *stock = [[UILabel alloc] initWithFrame:CGRectMake(5, yRep, SWIDTH - 10, 30)];
    stock.text = [NSString stringWithFormat:@"En stock: %@", [_infos objectForKey:@"stock"]];
    
    [self.view addSubview:stock];
    yRep += stock.frame.size.height;
    
    UILabel *prix = [[UILabel alloc] initWithFrame:CGRectMake(5, yRep, SWIDTH - 10, 30)];
    prix.text = [NSString stringWithFormat:@"Prix: %@€ et %@ gekoPoints", [_infos objectForKey:@"prix monnaie"], [_infos objectForKey:@"prix point"]];
    
    [self.view addSubview:prix];
    yRep += prix.frame.size.height;
}

@end
