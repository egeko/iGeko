//
//  GekoShopViewController.m
//  GEKO
//
//  Created by sebastien FOCK CHOW THO on 5/21/15.
//  Copyright (c) 2015 eGokia. All rights reserved.
//

#import "GekoShopViewController.h"

#import "GekoShopDescriptionViewController.h"
#import "GekoShopCollectionViewCell.h"

@interface GekoShopViewController ()

@end

@implementation GekoShopViewController {
    NSArray *json;
    NSMutableArray *displayed;
    UICollectionView *gekoCollectionView;
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
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"shop" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    displayed = [[NSMutableArray alloc] init];
    for (int i = 0; i < [json count]; i++) {
        NSDictionary *toInsert = [json objectAtIndex:i];
        [displayed addObject:toInsert];
    }
}

#pragma mark - UI

- (void)makeTheView {
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    int yRep = 0;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    gekoCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, yRep, SWIDTH, SHEIGHT - yRep - 64) collectionViewLayout:layout];
    [gekoCollectionView setDataSource:self];
    [gekoCollectionView setDelegate:self];
    
    [gekoCollectionView setBackgroundColor:[UIColor clearColor]];
    
    [gekoCollectionView registerClass:[GekoShopCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [gekoCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GekoShopHeaderView"];
    
    [self.view addSubview:gekoCollectionView];
}

#pragma mark - CollectionView manager

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *obj = [displayed objectAtIndex:section];
    NSArray *array = [obj objectForKey:@"articles"];
    
    return [array count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [displayed count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *obj = [displayed objectAtIndex:indexPath.section];
    NSArray *array = [obj objectForKey:@"articles"];
    NSDictionary *article = [array objectAtIndex:indexPath.row];
    
    GekoShopCollectionViewCell *cell = (GekoShopCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.title.text = [article objectForKey:@"nom"];
    cell.imageView.image = [UIImage imageNamed:@"ic_shop_default_item.png"];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SWIDTH / 2 - 5, SWIDTH / 2 + 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GekoShopHeaderView" forIndexPath:indexPath];
        
        UIView *canvas = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height - 1)];
        canvas.backgroundColor = [UIColor whiteColor];
        
        [headerView addSubview:canvas];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, canvas.frame.size.width, canvas.frame.size.height)];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = [NSString stringWithFormat:@"header %li", (long)indexPath.section];
        
        [canvas addSubview:title];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, headerView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1.0f];
        
        [headerView addSubview:line];
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize size = CGSizeMake(SWIDTH, 30);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *obj = [displayed objectAtIndex:indexPath.section];
    NSArray *array = [obj objectForKey:@"articles"];
    NSDictionary *article = [array objectAtIndex:indexPath.row];
    
    GekoShopDescriptionViewController *gsdvc = [[GekoShopDescriptionViewController alloc] initWithInformation:article];
    [self.navigationController pushViewController:gsdvc animated:YES];
}

@end
