//
//  GekoEventViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 7/21/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoEventViewController.h"

#import "GekoEventTableViewCell.h"
#import "GekoEventDescriptionViewController.h"

@interface GekoEventViewController ()

@end

@implementation GekoEventViewController {
    NSArray *json;
    NSArray *json2;
    UIView *font0;
    UITableView *gekoEventTableView;
    int state;
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
    state = 0;
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
    GekoAPI *api = [[GekoAPI alloc] init];
    [api getAllPostWithCompletion:^(NSString *results){
        if ([results isEqual:@"OK"]) {
            json = [api.dicResponse objectForKey:@"data"];
        } else {
            // server error
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat:@"Erreur serveur, veuillez contacter la Geko Team."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
        }
        [api getAllEventWithCompletion:^(NSString *results){
            if ([results isEqual:@"OK"]) {
                json2 = [api.dicResponse objectForKey:@"data"];
            } else {
                // server error
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat:@"Erreur serveur, veuillez contacter la Geko Team."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
            }
            [self makeTheView];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }];
}

#pragma mark - UI

- (void)makeTheView {
    int yRep = 0;
    
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
    title0.text = @"Geko Event";
    title0.textAlignment = NSTextAlignmentCenter;
    title0.font = [UIFont fontWithName:@"Arial" size:18];
    title0.textColor = [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f];
    
    [font0 addSubview:title0];
    yRep += font0.frame.size.height;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Bon Plans", @"Events", nil]];
    segmentedControl.frame = CGRectMake(-5, yRep, SWIDTH + 10, 50);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor colorWithRed:210/255.0f green:214/255.0f blue:217/255.0f alpha:1.0f];
    [segmentedControl.layer setCornerRadius:0.0];
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f]} forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:26/255.0f green:27/255.0f blue:27/255.0f alpha:1.0f]} forState:UIControlStateSelected];
    
    [self.view addSubview:segmentedControl];
    yRep += segmentedControl.frame.size.height;
    
    gekoEventTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, SHEIGHT - yRep)];
    gekoEventTableView.backgroundColor = [UIColor clearColor];
    gekoEventTableView.delegate = self;
    gekoEventTableView.dataSource = self;
    gekoEventTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:gekoEventTableView];
}

#pragma mark - Actions

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)valueChanged:(UISegmentedControl *)segment {
    
    if(segment.selectedSegmentIndex == 0) {
        state = 0;
    } else if(segment.selectedSegmentIndex == 1){
        state = 1;
    }
    
    [gekoEventTableView reloadData];
}

#pragma mark - UITableView management

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (state) {
        case 0:
            return [json count];
            break;
            
        case 1:
            return [json2 count];
            break;
            
        default:
            return [json count];
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HistoryCell";
    
    GekoEventTableViewCell *cell = (GekoEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *mess;
    
    switch (state) {
        case 0:
            mess = [json objectAtIndex:indexPath.row];
            cell = [[GekoEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault Message:[mess objectForKey:@"message"] Time:[mess objectForKey:@"created_time"] Idmess:[mess objectForKey:@"id"] ReuseIdentifier:cellIdentifier];
            break;
            
        case 1:
            mess = [json2 objectAtIndex:indexPath.row];
            cell = [[GekoEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault Message:[mess objectForKey:@"description"] Time:[mess objectForKey:@"start_time"] Idmess:[mess objectForKey:@"id"] ReuseIdentifier:cellIdentifier];
            break;
            
        default:
            mess = [json objectAtIndex:indexPath.row];
            cell = [[GekoEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault Message:[mess objectForKey:@"message"] Time:[mess objectForKey:@"created_time"] Idmess:[mess objectForKey:@"id"] ReuseIdentifier:cellIdentifier];
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *mess;
    GekoEventDescriptionViewController *gedvc;
    
    switch (state) {
        case 0:
            mess = [json objectAtIndex:indexPath.row];
            gedvc = [[GekoEventDescriptionViewController alloc] initWithMessage:[mess objectForKey:@"message"] Date:[mess objectForKey:@"created_time"] Idmess:[mess objectForKey:@"id"]];
            break;
            
        case 1:
            mess = [json2 objectAtIndex:indexPath.row];
            gedvc = [[GekoEventDescriptionViewController alloc] initWithMessage:[mess objectForKey:@"description"] Date:[mess objectForKey:@"start_time"] Idmess:[mess objectForKey:@"id"]];
            break;
            
        default:
            mess = [json objectAtIndex:indexPath.row];
            gedvc = [[GekoEventDescriptionViewController alloc] initWithMessage:[mess objectForKey:@"message"] Date:[mess objectForKey:@"created_time"] Idmess:[mess objectForKey:@"id"]];
            break;
    }
    
    [self.navigationController pushViewController:gedvc animated:YES];
}

@end
