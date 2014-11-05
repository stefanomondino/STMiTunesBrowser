//
//  STMListViewModel.h
//  ItunesBrowser
//
//  Created by Stefano Mondino on 05/11/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STMListViewModel : NSObject
- (instancetype)initWithSearch;
- (instancetype)initWithFavorites;
@property (nonatomic,strong) RACCommand* rac_searchCommand;
@property (nonatomic,strong) RACSignal* rac_signalForChanges;
- (NSInteger) numberOfItems ;
- (RACSignal*) rac_imageAtIndexPath:(NSIndexPath*) indexPath ;
- (RACSignal*) rac_artistNameAtIndexPath:(NSIndexPath*)indexPath;
- (RACSignal*) rac_collectionNameAtIndexPath:(NSIndexPath*)indexPath;
- (RACSignal*) rac_trackNameAtIndexPath:(NSIndexPath*)indexPath;
- (RACChannelTerminal*) rac_isFavoriteAtIndexPath:(NSIndexPath*) indexPath;
- (NSURL*) previewURLAtIndexPath:(NSIndexPath*) indexPath;
- (BOOL) isFavorite;
@end
