//
//  LoadingViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 7/30/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "LoadingViewController.h"

#import "ConnectionViewController.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController {
    UIProgressView *threadProgressView;
    int totalData;
    int currentData;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    totalData = 20;
    currentData = 0;
    
    [self setupEnvironment];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeTheView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupEnvironment {
//    GekoAPI *api = [[GekoAPI alloc] init];
//    [api getAllShopWithCompletion:^(NSString *results){
//        if ([results isEqual:@"OK"]) {
//            // OK
//        } else {
//            // server error
//            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat:@"Erreur serveur, veuillez contacter la Geko Team."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [av show];
//        }
//    }];
    if (currentData < totalData) {
        [self performSelectorOnMainThread:@selector(makeMyProgressBarMoving) withObject:nil waitUntilDone:NO];
        currentData++;
    }
}

- (void)makeTheView {
    UILabel *notice = [[UILabel alloc] initWithFrame:CGRectMake(10, SHEIGHT - 55, SWIDTH - 20, 20)];
    notice.text = @"Chargement...";
    
    [self.view addSubview:notice];
    
    threadProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, SHEIGHT - 20, SWIDTH - 20, 10)];
    threadProgressView.progress = 0.0;
    
    [self.view addSubview:threadProgressView];
}

- (void)makeMyProgressBarMoving {
    
    float actual = [threadProgressView progress];
    
    if (actual < 1) {
        threadProgressView.progress = actual + ((float)currentData/(float)totalData);
        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:NO];
    } else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *nc = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"rootnav"];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

@end
