//
//  PullToRefreshTableViewController.h
//  TableViewPull
//
//  Created by Jesse Collis on 1/07/10.
//  Copyright 2010 JC Multimedia Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface PullToRefreshTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
	EGORefreshTableHeaderView *refreshHeaderView;
    
    UITableView         *tableView;
    UISearchBar         *searchBar;

	BOOL _reloading;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UISearchBar *searchBar;
@property(assign,getter=isReloading) BOOL reloading;
@property(nonatomic,readonly) EGORefreshTableHeaderView *refreshHeaderView;

- (void)reloadTableViewDataSource;
- (void)dataSourceDidFinishLoadingNewData;


@end
