//
//  RPullRefreshHeaderView.h
//  VMovier
//
//  Created by Alex Rezit on 25/11/2012.
//  Copyright (c) 2012 Seymour Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RPullRefreshHeaderView;

@protocol RPullRefreshHeaderViewDelegate <NSObject>

- (void)pullRefreshHeaderViewDidTriggerRefresh:(RPullRefreshHeaderView *)pullRefreshHeaderView;
- (BOOL)pullRefreshHeaderViewIsRefreshing;

@end

typedef enum {
    RPullRefreshStateNormal = 0,
    RPullRefreshStateReady,
    RPullRefreshStateLoading,
    RPullRefreshStateLoaded
} RPullRefreshState;

@interface RPullRefreshHeaderView : UIView

@property (nonatomic, assign) id<RPullRefreshHeaderViewDelegate> delegate;

@property (nonatomic, assign) RPullRefreshState state;

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CALayer *arrowImageLayer;
@property (nonatomic, strong) CALayer *successImageLayer;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, assign) NSTimeInterval successDelay;

- (void)pullRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)pullRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)pullRefreshScrollViewDidFinishLoading:(UIScrollView *)scrollView;

@end
