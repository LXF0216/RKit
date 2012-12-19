//
//  RTableViewController.m
//  VMovier
//
//  Created by Alex Rezit on 25/11/2012.
//  Copyright (c) 2012 Seymour Dev. All rights reserved.
//

#import "RTableViewController.h"

@interface RTableViewController ()

@property (nonatomic, strong) RPullRefreshHeaderView *pullRefreshHeaderView;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RTableViewController

#pragma mark - Data Control

// For override: DO NOT MODIFY!!! MUST OVERRIDE THEM IN CHILD CLASS!!!
- (void)loadData
{
    NSLog(@"R Table View Controller: You have to override this method. ");
}

- (void)refreshData
{
    NSLog(@"R Table View Controller: You have to override this method. ");
}

// Active
- (void)loadDataInBackground
{
    if (_isLoading || _isRefreshing) {
        return;
    }
    [self dataWillBeginLoading];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dataDidStopLoading];
        });
    });
}

- (void)refreshDataInBackground
{
    if (_isLoading || _isRefreshing) {
        return;
    }
    [self dataWillBeginRefreshing];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self refreshData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dataDidStopRefreshing];
        });
    });
}

// Passive

- (void)dataWillBeginLoading
{
    self.isLoading = YES;
}

- (void)dataDidStopLoading
{
    self.isLoading = NO;
}

- (void)dataWillBeginRefreshing
{
    self.isRefreshing = YES;
}

- (void)dataDidStopRefreshing
{
    self.isRefreshing = NO;
    [_pullRefreshHeaderView pullRefreshScrollViewDidFinishLoading:self.tableView];
}

#pragma mark - Life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds] autorelease];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    CGRect tableViewBounds = self.tableView.bounds;
    self.pullRefreshHeaderView = [[[RPullRefreshHeaderView alloc] initWithFrame:CGRectMake(tableViewBounds.origin.x, tableViewBounds.origin.y - tableViewBounds.size.height, tableViewBounds.size.width, tableViewBounds.size.height)] autorelease];
    _pullRefreshHeaderView.delegate = self;
    [self.tableView addSubview:_pullRefreshHeaderView];
    
    self.isRefreshing = NO;
    self.isLoading = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark -  Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_pullRefreshHeaderView pullRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_pullRefreshHeaderView pullRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - Pull refresh header view delegate

- (void)pullRefreshHeaderViewDidTriggerRefresh:(RPullRefreshHeaderView *)pullRefreshHeaderView
{
    [self refreshDataInBackground];
}

- (BOOL)pullRefreshHeaderViewIsRefreshing
{
    return _isRefreshing;
}

@end
