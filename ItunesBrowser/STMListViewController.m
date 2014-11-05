//
//  STMListViewController.m
//  ItunesBrowser
//
//  Created by Stefano Mondino on 05/11/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import "STMListViewController.h"
#import "STMListViewModel.h"
#import "STMListTableViewCell.h"
@import MediaPlayer;
@interface STMListViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btn_favorites;
@property (nonatomic,strong) MPMoviePlayerViewController* playerController;
@end

@implementation STMListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.searchBar) {
        self.viewModel = [[STMListViewModel alloc] initWithSearch];
    }
    else {
          self.viewModel = [[STMListViewModel alloc] initWithFavorites];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"STMListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listCellId"];
    @weakify(self);
    
    
    
    [self.viewModel.rac_signalForChanges subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    self.searchBar.delegate = (id<UISearchBarDelegate>)self;
    RACSignal* signalForSearchClicked = [[[self rac_signalForSelector:@selector(searchBarSearchButtonClicked:) fromProtocol:@protocol(UISearchBarDelegate)] map:^id(RACTuple* value) {
        return [(UISearchBar*)value.first text];
    }] filter:^BOOL(NSString* value) {
        return value.length > 0;
    }];
    
    [self.viewModel.rac_searchCommand rac_liftSelector:@selector(execute:) withSignalsFromArray:@[signalForSearchClicked]];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STMListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"listCellId" forIndexPath:indexPath];
    RAC(cell.lbl_artistName,text) = [[self.viewModel rac_artistNameAtIndexPath:indexPath] takeUntil:cell.rac_prepareForReuseSignal];
        RAC(cell.lbl_collectionName,text) = [[self.viewModel rac_collectionNameAtIndexPath:indexPath] takeUntil:cell.rac_prepareForReuseSignal];
    RAC(cell.lbl_trackName,text) = [[self.viewModel rac_trackNameAtIndexPath:indexPath] takeUntil:cell.rac_prepareForReuseSignal];
    RAC(cell.img_cover, image) = [[self.viewModel rac_imageAtIndexPath:indexPath] takeUntil:cell.rac_prepareForReuseSignal];

    RACChannelTerminal* switchTerminal = [cell.btn_favorite rac_newOnChannel];
    RACChannelTerminal* modelTerminal = [self.viewModel rac_isFavoriteAtIndexPath:indexPath];
    [[modelTerminal takeUntil:cell.rac_prepareForReuseSignal] subscribe:switchTerminal];
    [[switchTerminal takeUntil:cell.rac_prepareForReuseSignal] subscribe:modelTerminal];
   
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItems];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSURL * url = [self.viewModel previewURLAtIndexPath:indexPath];
    if (!url) return;
    MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [playerController.moviePlayer prepareToPlay];
    [self presentMoviePlayerViewControllerAnimated:playerController];
}



@end
