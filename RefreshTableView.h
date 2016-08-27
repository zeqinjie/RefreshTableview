//
//  RefreshTableView.h
//  Yanfang
//
//  Created by zhengzeqin on 16/3/26.
//  Copyright © 2016年 com.injoinow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "UITableView+Gzw.h"

typedef void(^RefreshTableViewLoadNewData) ();
typedef void(^RefreshTableViewLoadMoreData) ();

@interface RefreshTableView : UITableView
//头部提示语 注意 存储 三个 字符串
@property (strong, nonatomic) NSArray *headerTipStr;
//尾部提示语
@property (strong, nonatomic) NSArray *footerTipStr;
/** 下拉重新加载*/
@property (copy, nonatomic) RefreshTableViewLoadNewData loadNewDataBlock;
/** 上拉加载更多*/
@property (copy, nonatomic) RefreshTableViewLoadMoreData loadMoreDataBlock;
/**
 *  开启动画模式
 *
 *  @param isAnim            是否开启动画
 *  @param loadNewDataBlock  加载新数据回调
 *  @param loadMoreDataBlock 加载更多回调
 */
- (void)installAnimationStyle:(BOOL)isAnim
             loadNewDataBlock:(RefreshTableViewLoadNewData)loadNewDataBlock
            loadMoreDataBlock:(RefreshTableViewLoadMoreData)loadMoreDataBlock;
/** 开始header刷新 */
- (void)beginRefreshingHeader;
/** 结束刷新*/
- (void)endRefreshing;
/** 显示没有更多数据了 */
- (void)endRefreshWithNoMoreData;

/** 显示刷新状态，有mj_header 显示header刷新，没有则显示 菊花 */
- (void)showLoading;
/** 显示没有数据的默认页面 */
- (void)showNoData;


@end
