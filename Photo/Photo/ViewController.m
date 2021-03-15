//
//  ViewController.m
//  Photo
//
//  Created by Vũ Quý Đạt  on 15/03/2021.
//

#import "ViewController.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *subCollectionView;

@end

@implementation ViewController {
#pragma khoá sự kiện cho mỗi collectionview. nếu collectionview 1 đang kích hoạt hàm scrollViewDidScroll(), thì sẽ cuộn collectionview 2, collectionview 2 lại tiếp tục gọi scrollViewDidScroll() sẽ tạo ra 1 vòng đệ quy, nên ta cần 2 biến để khoá sự kiện.
    BOOL mainScrollingState;
    BOOL subScrollingState;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // default value init.
    mainScrollingState = NO;
    subScrollingState = NO;
#pragma register cho cell.
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [_subCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
#pragma tạo layout cho 2 collectionview, bao gồm: hướng kéo(ngang hay dọc), khoảng cách giữa các cell, kích thước cell, toạ độ cell.
    UICollectionViewFlowLayout* mainLayout = [[UICollectionViewFlowLayout alloc]init];
    mainLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    mainLayout.itemSize = _mainCollectionView.frame.size;
    mainLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    mainLayout.minimumLineSpacing = 0;
    mainLayout.minimumLineSpacing = 0;
    _mainCollectionView.collectionViewLayout = mainLayout;
    
    UICollectionViewFlowLayout* subLayout = [[UICollectionViewFlowLayout alloc]init];
    subLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    subLayout.itemSize = CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3);
    subLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    subLayout.minimumLineSpacing = 0;
    subLayout.minimumLineSpacing = 0;
    _subCollectionView.collectionViewLayout = subLayout;
}

#pragma Datasource của collectionview.
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (NSInteger)50;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 0) {
        return _mainCollectionView.frame.size;
    } else {
        return CGSizeMake(100, 100);
    }
    
//    return CGSizeMake((self.view.frame.size.width - 2) / 3, (self.view.frame.size.width - 2) / 3);
}

#pragma Render ra các cell - lưu ý dùng hàm dequeueReusableCellWithReuseIdentifier thì cần phải register cell, xem dòng 30 và 31.
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

#pragma Hiệu ứng kéo đồng bộ.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 0) {
        /// Kéo bên trên và cuộn bên dưới.
        if (!subScrollingState) {
            mainScrollingState = YES;
            [_subCollectionView setContentOffset:CGPointMake((_mainCollectionView.contentOffset.x / self.view.frame.size.width) * 100.0, 0) animated:NO];
        }
    } else {
        /// Kéo bên dưới để cuộn bên trên.
        if (!mainScrollingState) {
            subScrollingState = YES;
            [_mainCollectionView setContentOffset:CGPointMake((_subCollectionView.contentOffset.x * self.view.frame.size.width) / 100.0, 0) animated:NO];
        }
    }
}

#pragma Nhận biết khi nào các collectionView đã cuộn xong để mở khoá.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _mainCollectionView) {
        mainScrollingState = NO;
    } else {
        subScrollingState = NO;
    }
    
}
@end
