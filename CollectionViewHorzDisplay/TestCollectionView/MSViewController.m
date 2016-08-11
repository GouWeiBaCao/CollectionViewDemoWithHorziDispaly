//
//  MSViewController.m
//  TestCollectionView
//  Created by 刘卫林 on 15/08/27.
//
//屏幕宽度
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREEN_SCALE ([ UIScreen mainScreen ].bounds.size.width/320)
//随机色
#define LWLRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

#import "MSViewController.h"

@interface CollectionCell : UICollectionViewCell

@property(nonatomic, weak) UILabel *titleLabel;

@end

@implementation CollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:self.titleLabel];
    self.backgroundColor = LWLRandomColor;
  }
  return self;
}

@end

////////////////////////////////////////////////////////////////////////
@interface CollectionCellWhite : CollectionCell

@end

@implementation CollectionCellWhite

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

@end
////////////////////////////////////////////////////////////////////////
@interface MSViewController ()<UICollectionViewDataSource>

@property(nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, assign) NSUInteger pageCount;
@end

@implementation MSViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _items = @[ @"a", @"b", @"c", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"b", @"c", ];
  NSLog(@"%f", _items.count / 8.0);
  //  CGFloat pageC = _items.count / 4.0;
  _pageCount = _items.count;

   //一排显示四个,两排就是八个
  while (_pageCount % 8 != 0) {
    ++_pageCount;
    NSLog(@"%zd", _pageCount);
  }
  NSLog(@"%zd", _pageCount);
    //使用系统的默认会竖向布局.并不是一排排完了才换行排列.而是一上一下的排列
//  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
  UICollectionViewFlowLayout *layout =[[LWLCollectionViewHorizontalLayout alloc]init];
    
  layout.itemSize = CGSizeMake(SCREENW/4, SCREENW/4);
  layout.minimumInteritemSpacing = 0*SCREEN_SCALE;
  layout.minimumLineSpacing = 0*SCREEN_SCALE;
  layout.headerReferenceSize = CGSizeMake(0*SCREEN_SCALE, 0*SCREEN_SCALE);
  layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

  UICollectionView *collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0,SCREENH-SCREENW/2, SCREENW,SCREENW/2)
                         collectionViewLayout:layout];
  collectionView.backgroundColor = [UIColor whiteColor];
  collectionView.dataSource = self;
  collectionView.pagingEnabled = YES;
    collectionView.pagingEnabled = YES;
  [collectionView registerClass:[CollectionCellWhite class]
      forCellWithReuseIdentifier:@"CellWhite"];

  [collectionView registerClass:[CollectionCell class]
      forCellWithReuseIdentifier:@"Cell"];
  self.collectionView = collectionView;
  [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return _pageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifierCell = @"Cell";

  CollectionCell *cell = nil;
  if (indexPath.item >= 10) {
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellWhite"
                                                     forIndexPath:indexPath];
  } else {
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell
                                                     forIndexPath:indexPath];
    cell.titleLabel.text =
        [NSString stringWithFormat:@"第%ld个礼物", (long)indexPath.row];
  }
  return cell;
}

@end
