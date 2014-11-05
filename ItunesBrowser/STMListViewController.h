//
//  STMListViewController.h
//  ItunesBrowser
//
//  Created by Stefano Mondino on 05/11/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import "SMQuickViewControllers.h"
@class STMListViewModel;
@interface STMListViewController : SMQuickTableViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) STMListViewModel * viewModel;
@end
