//
//  MMFlowLayout.h
//  MiauMall
//
//  Created by 吕松松 on 2022/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MMFlowLayout;
@protocol MMFlowLayoutDataSource;

@interface MMFlowLayout : UICollectionViewLayout
@property (nonatomic, strong) id<MMFlowLayoutDataSource> dataSource;
@property (nonatomic, assign) CGFloat minimumLineSpacing; // default 0.0
@property (nonatomic, assign) CGFloat minimumInteritemSpacing; // default 0.0
@property (nonatomic, assign)BOOL sectionHeadersPinToVisibleBounds; // default NO
//@property (nonatomic, assign) IBInspectable BOOL sectionFootersPinToVisibleBounds;

@end


#pragma mark -

@protocol MMFlowLayoutDataSource<NSObject>

@required
/// Return per section's column number(must be greater than 0).
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(MMFlowLayout*)layout numberOfColumnInSection:(NSInteger)section;
/// Return per item's height
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(MMFlowLayout*)layout itemWidth:(CGFloat)width
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
/// Column spacing between columns
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(MMFlowLayout*)layout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
/// The spacing between rows and rows
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(MMFlowLayout*)layout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
///
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(MMFlowLayout*)layout insetForSectionAtIndex:(NSInteger)section;
/// Return per section header view height.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(MMFlowLayout*)layout referenceHeightForHeaderInSection:(NSInteger)section;
/// Return per section footer view height.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(MMFlowLayout*)layout referenceHeightForFooterInSection:(NSInteger)section;
@end

NS_ASSUME_NONNULL_END
