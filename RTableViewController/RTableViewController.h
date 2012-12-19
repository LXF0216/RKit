//
//  RTableViewController.h
//  VMovier
//
//  Created by Alex Rezit on 25/11/2012.
//  Copyright (c) 2012 Seymour Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPullRefreshHeaderView.h"

@interface RTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RPullRefreshHeaderViewDelegate>

- (void)loadData;
- (void)refreshData;
- (void)loadDataInBackground;
- (void)refreshDataInBackground;
- (void)dataWillBeginLoading;
- (void)dataDidStopLoading;
- (void)dataWillBeginRefreshing;
- (void)dataDidStopRefreshing;

@end
