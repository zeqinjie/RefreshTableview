//
//  RefreshTableView.h
//  Yanfang
//
//  Created by zhengzeqin on 16/3/26.
//  Copyright © 2016年 com.injoinow. All rights reserved.
//

#import "RefreshTableView.h"
@interface RefreshTableView()
@property (strong, nonatomic) NSMutableArray *idleImages;
@property (strong, nonatomic) NSMutableArray *refreshingImages;
@end
@implementation RefreshTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //默认加载刷新类型
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
//    NSLog(@"--- awakeFromNib ---");
    //默认加载刷新类型
    [self initView];
    
}

- (void)initView{
    self.tableFooterView = [[UIView alloc] init];
    self.buttonText = @"再次请求";
    self.buttonNormalColor = [UIColor redColor];
    self.buttonHighlightColor = [UIColor yellowColor];
    //    self.loadedImageName = @"58x58";
    self.descriptionText = @"破网络，你还是再请求一次吧";
    //    self.dataVerticalOffset = 200;
}


- (void)setHeaderTipStr:(NSArray *)headerTipStr{
    _headerTipStr = headerTipStr;
    assert(headerTipStr.count == 3);
    if ([self.mj_header isKindOfClass:[MJRefreshNormalHeader class]]) {
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.mj_header;
        [header setTitle:headerTipStr[0] forState:MJRefreshStateIdle];
        [header setTitle:headerTipStr[1] forState:MJRefreshStatePulling];
        [header setTitle:headerTipStr[2] forState:MJRefreshStateRefreshing];
    }

}

- (void)setFooterTipStr:(NSArray *)footerTipStr{
    _footerTipStr = footerTipStr;
    assert(footerTipStr.count == 3);
    if ([self.mj_header isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mj_footer;
        [footer setTitle:footerTipStr[0] forState:MJRefreshStateIdle];
        [footer setTitle:footerTipStr[1] forState:MJRefreshStateRefreshing];
        [footer setTitle:footerTipStr[2] forState:MJRefreshStateNoMoreData];
    }
}

#pragma mark - setter && getter

- (void)setLoadNewDataBlock:(RefreshTableViewLoadNewData)loadNewDataBlock
{
    _loadNewDataBlock = loadNewDataBlock;
    if (!self.mj_header) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = NO;
        
        // 马上进入刷新状态
//        [header beginRefreshing];
        
        // 设置文字
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"正在刷新中 ..." forState:MJRefreshStateRefreshing];
        // 设置字体
        header.stateLabel.font = [UIFont systemFontOfSize:14];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
        // 设置颜色
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        
        
        // 设置header
        self.mj_header = header;
    }
    
}

- (void)setLoadMoreDataBlock:(RefreshTableViewLoadMoreData)loadMoreDataBlock
{
    _loadMoreDataBlock = loadMoreDataBlock;
//    NSLog(@"--loadMoreDataBlock--");
    
    /******************** footer ********************/
    if (!self.mj_footer) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.automaticallyHidden = YES;
        // 设置文字
        [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"加载中，请稍后..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
        // 设置字体
        footer.stateLabel.font = [UIFont systemFontOfSize:14];
        // 设置颜色
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        
        self.mj_footer = footer;
    }
    
}

- (NSMutableArray *)refreshingImages{
    if (!_refreshingImages) {
        _refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
            [_refreshingImages addObject:image];
        }
    }
    return _refreshingImages;
}

- (NSMutableArray *)idleImages{
    if (!_idleImages) {
        _idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=60; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
            [_idleImages addObject:image];
        }

    }
    return _idleImages;
}

#pragma mark - function

- (void)installAnimationStyle:(BOOL)isAnim
             loadNewDataBlock:(RefreshTableViewLoadNewData)loadNewDataBlock
            loadMoreDataBlock:(RefreshTableViewLoadMoreData)loadMoreDataBlock{

    if (isAnim) {
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        // 设置普通状态的动画图片
        [header setImages:self.idleImages forState:MJRefreshStateIdle];
         // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [header setImages:self.refreshingImages forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [header setImages:self.refreshingImages forState:MJRefreshStateRefreshing];
        self.mj_header = header;
        
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        // 设置正在刷新状态的动画图片
        [footer setImages:self.refreshingImages forState:MJRefreshStateRefreshing];
        self.mj_footer = footer;
    }else{
        self.loadNewDataBlock = loadNewDataBlock;
        self.loadMoreDataBlock = loadMoreDataBlock;
    }
}

//下拉重新加载
- (void)loadNewData
{
    if (self.mj_footer) {
        [self.mj_footer resetNoMoreData];
    }
    
    if (self.loadNewDataBlock) {
        self.loadNewDataBlock();
    }
}
//上拉加载更多
- (void)loadMoreData
{
    if (self.loadMoreDataBlock) {
        self.loadMoreDataBlock();
    }
}
//结束刷新
- (void)endRefreshing
{
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
    if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
    }
}

- (void)beginRefreshingHeader
{
    if (self.mj_header) {
        [self.mj_header beginRefreshing];
    }
}

- (void)endRefreshWithNoMoreData
{
    if (self.mj_footer) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)showLoading
{
    self.loading = YES;
    if (!self.mj_header) {
        self.showIndicatorView = YES;
    }
}

- (void)showNoData
{
    self.loading = NO;
}



@end
