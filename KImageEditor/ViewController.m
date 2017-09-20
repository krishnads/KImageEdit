//
//  ViewController.m
//  KImageEditor
//
//  Created by Krishana on 9/19/17.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewCell.h"
#import "ImageModel.h"
#import "Config.h"
#import "DrawImageVC.h"
#import "DrawTextVC.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSMutableArray *arrayImages;

}

/**
 *  Reference to Image collection view
 */
@property (weak) IBOutlet UICollectionView *imageCollectionView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelectedImage;


- (IBAction)drawButtonAction:(id)sender;

- (IBAction)addTextbuttonAction:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Edit Image";
    
    arrayImages = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <=30; i++) {
        ImageModel *mdl = [[ImageModel alloc] init];
        mdl.imageURL = [NSString stringWithFormat:@"i%d", i];
        mdl.imageId = [NSString stringWithFormat:@"%d", i];
        [arrayImages addObject:mdl];
    }
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.sectionInset     = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
    self.imageCollectionView.collectionViewLayout = layOut;
    [self.imageCollectionView reloadData];
    
    ImageModel *mdl = [arrayImages objectAtIndex:0];
    self.imageViewSelectedImage.image = [UIImage imageNamed:mdl.imageURL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Mark - Collection View Delegate and Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrayImages.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue cell
    ImageViewCell* cell = (ImageViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    ImageModel *model = [arrayImages objectAtIndex:indexPath.row];
    cell.feedImage.image = [UIImage imageNamed:model.imageURL];
    [cell.indicatorView setHidden:YES];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(120.f, 145.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return COLLECTION_CELL_MIN_LINE_SPACING;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return COLLECTION_CELL_INTER_ITEMS_PADDING;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageModel *model = [arrayImages objectAtIndex:indexPath.row];
    self.imageViewSelectedImage.image = [UIImage imageNamed:model.imageURL];
}

- (IBAction)drawButtonAction:(id)sender {
    
}

- (IBAction)addTextbuttonAction:(id)sender {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[DrawImageVC class]]) {
        DrawImageVC *imgVC = [segue destinationViewController];
        imgVC.selectedImage = self.imageViewSelectedImage.image;
    }
    else {
        DrawTextVC *imgVC = [segue destinationViewController];
        imgVC.selectedImage = self.imageViewSelectedImage.image;
    }
}


@end
