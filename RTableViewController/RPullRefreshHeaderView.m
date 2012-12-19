//
//  RPullRefreshHeaderView.m
//  VMovier
//
//  Created by Alex Rezit on 25/11/2012.
//  Copyright (c) 2012 Seymour Dev. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RPullRefreshHeaderView.h"

@implementation RPullRefreshHeaderView

#pragma mark - Setters

- (void)setState:(RPullRefreshState)state
{
    switch (state) {
        case RPullRefreshStateNormal:
            _statusLabel.text = NSLocalizedString(@"Pull to refresh.", nil);
            _arrowImageLayer.hidden = NO;
            if (_state == RPullRefreshStateReady) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:0.15f];
                _arrowImageLayer.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            _arrowImageLayer.transform = CATransform3DIdentity;
            _successImageLayer.hidden = YES;
            _activityIndicator.hidden = YES;
            break;
        case RPullRefreshStateReady:
            _statusLabel.text = NSLocalizedString(@"Release to refresh.", nil);
            _arrowImageLayer.hidden = NO;
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.15f];
            _arrowImageLayer.transform = CATransform3DMakeRotation(M_PI * 1.0f, 0, 0, 1.0f);
            [CATransaction commit];
            _successImageLayer.hidden = YES;
            _activityIndicator.hidden = YES;
            break;
        case RPullRefreshStateLoading:
            _statusLabel.text = NSLocalizedString(@"Refreshing...", nil);
            _arrowImageLayer.hidden = YES;
            _arrowImageLayer.transform = CATransform3DIdentity;
            _successImageLayer.hidden = YES;
            [_activityIndicator startAnimating];
            _activityIndicator.hidden = NO;
            break;
        case RPullRefreshStateLoaded:
            _statusLabel.text = NSLocalizedString(@"Refresh success.", nil);
            _arrowImageLayer.hidden = YES;
            _arrowImageLayer.transform = CATransform3DIdentity;
            _successImageLayer.hidden = NO;
            [_activityIndicator stopAnimating];
            _activityIndicator.hidden = YES;
        default:
            break;
    }
    _state = state;
}

#pragma mark - Animations

- (void)addInsetToScrollView:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.15f animations:^{
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0, 0, 0);
    }];
}

- (void)removeInsetOfScrollView:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.15f animations:^{
        scrollView.contentInset = UIEdgeInsetsZero;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.15f animations:^{
                self.state = RPullRefreshStateNormal;
            }];
        }
    }];
}

#pragma mark - For delegate

- (void)pullRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_state == RPullRefreshStateLoading) {
        CGFloat offset = MAX(0 - scrollView.contentOffset.y, 0);
        offset = MIN(offset, 66);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0);
    } else if (scrollView.isDragging && ![self.delegate pullRefreshHeaderViewIsRefreshing]) {
        if (_state == RPullRefreshStateNormal && scrollView.contentOffset.y < - 66.0f) {
            self.state = RPullRefreshStateReady;
        } else if ((_state == RPullRefreshStateReady || _state == RPullRefreshStateLoaded) && scrollView.contentOffset.y > - 66.0f && scrollView.contentOffset.y < 0) {
            self.state = RPullRefreshStateNormal;
        }
    }
}

- (void)pullRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if (![self.delegate pullRefreshHeaderViewIsRefreshing] && scrollView.contentOffset.y < - 66.0f) {
        [self.delegate pullRefreshHeaderViewDidTriggerRefresh:self];
        self.state = RPullRefreshStateLoading;
        [self addInsetToScrollView:scrollView];
    }
}

- (void)pullRefreshScrollViewDidFinishLoading:(UIScrollView *)scrollView
{
    self.state = RPullRefreshStateLoaded;
    [self performSelector:@selector(removeInsetOfScrollView:) withObject:scrollView afterDelay:_successDelay];
}

#pragma mark - Life cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.statusLabel = [[[UILabel alloc] initWithFrame:CGRectMake(60.0f, frame.size.height - 43.0f, self.frame.size.width - 90.0f, 20.0f)] autorelease];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textColor = [UIColor darkGrayColor];
        _statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _statusLabel.shadowOffset = CGSizeMake(0, 1.0f);
        _statusLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_statusLabel];
        
        self.arrowImageLayer = [CALayer layer];
        _arrowImageLayer.frame = CGRectMake(30.0f, frame.size.height - 66.0f, 30.0f, 66.0f);
        _arrowImageLayer.contents = (id)[UIImage imageNamed:@"pullrefresh-arrow"].CGImage;
        [self.layer addSublayer:_arrowImageLayer];
        
        self.successImageLayer = [CALayer layer];
        _successImageLayer.frame = CGRectMake(35.0f, frame.size.height - 43.0f, 20.0f, 20.0f);
        _successImageLayer.contents = (id)[UIImage imageNamed:@"pullrefresh-success"].CGImage;
        [self.layer addSublayer:_successImageLayer];
        
        self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        _activityIndicator.frame = CGRectMake(35.0f, frame.size.height - 43.0f, 20.0f, 20.0f);
        [self addSubview:_activityIndicator];
        
        self.state = RPullRefreshStateNormal;
        
        self.successDelay = 0.4f;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
