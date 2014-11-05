//
//  STMListViewModel.m
//  ItunesBrowser
//
//  Created by Stefano Mondino on 05/11/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import "STMListViewModel.h"
#import "STMModel.h"
#import "STMItem.h"
#import <Reachability+RACExtensions.h>
#import <SDWebImageManager.h>
@interface STMListViewModel() <NSFetchedResultsControllerDelegate>
@property (nonatomic,strong) NSArray* dataSource;
@property (nonatomic,strong) NSFetchedResultsController* fetchedResultsController;
@end

@implementation STMListViewModel
- (instancetype)initWithSearch {
    self = [super init];
    STMModel* model = [STMModel shared]; //Ensures that the STMModel singleton gets created 
    self.rac_searchCommand = [[RACCommand alloc] initWithEnabled:[Reachability rac_notifyReachable] signalBlock:^RACSignal *(id input) {
        if ([input isKindOfClass:[NSString class]]) {
            return [model rac_queryWithSearchTerm:input];
        }
        else return [RACSignal return:nil];
    }];
    self.rac_signalForChanges = [self.rac_searchCommand.executionSignals flatten];
    RAC(self,dataSource) = self.rac_signalForChanges;
    return self;
}
- (instancetype)initWithFavorites {
    self = [super init];
    self.fetchedResultsController = [[STMModel shared] fetchedResultsControllerForFavorites];
    self.fetchedResultsController.delegate = self;
    self.rac_signalForChanges = [self rac_signalForSelector:@selector(controllerDidChangeContent:) fromProtocol:@protocol(NSFetchedResultsControllerDelegate)];
    RAC(self,dataSource) = [[self.rac_signalForChanges startWith:nil] map:^id(id value) {
        return [STMItem allFavorites];
    }];
    [self.fetchedResultsController performFetch:nil];
    return self;
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {;}

- (void)dealloc {
    ;
}
- (STMItem*) itemAtIndexPath:(NSIndexPath*) indexPath {
    return self.dataSource[indexPath.row];
}
- (NSInteger) numberOfItems {
    return self.dataSource.count;
}
- (BOOL) isFavorite {
    return self.rac_searchCommand == nil;
}

- (RACSignal*) rac_imageAtIndexPath:(NSIndexPath*) indexPath {
    STMItem* item = [self itemAtIndexPath:indexPath];
    
    return [[[RACObserve(item, artworkUrl100) flattenMap:^RACStream *(NSURL* value) {
        
        SDWebImageManager* manager = [SDWebImageManager sharedManager];
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            id<SDWebImageOperation> operation =  [manager downloadImageWithURL:value
                                                                                          options:0
                                                                                         progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                       {}
                                                                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) 
                                                                                            
                                                                                        
                                       {
                                           if (image && finished && image.size.width>0 && image.size.height>0)
                                           {
                                               [subscriber sendNext:image];
                                               [subscriber sendCompleted];
                                           }
                                           else {
                                               [subscriber sendError:error];
                                           }
                                       }];
            return [RACDisposable disposableWithBlock:^{
                [operation cancel];
            }];
        }] catch:^RACSignal *(NSError *error) {
            return [RACSignal return:nil];
        }];
    }] startWith:nil] takeUntil:[self rac_willDeallocSignal]];
}
- (RACSignal*) rac_artistNameAtIndexPath:(NSIndexPath*)indexPath {
    STMItem* item = [self itemAtIndexPath:indexPath];
    return RACObserve(item,artistName);
}
- (RACSignal*) rac_collectionNameAtIndexPath:(NSIndexPath *)indexPath {
    STMItem* item = [self itemAtIndexPath:indexPath];
    return RACObserve(item,collectionName);
}
- (RACSignal*) rac_trackNameAtIndexPath:(NSIndexPath *)indexPath {
    STMItem* item = [self itemAtIndexPath:indexPath];
    return RACObserve(item,trackName);
}
- (RACChannelTerminal*) rac_isFavoriteAtIndexPath:(NSIndexPath*) indexPath {
    STMItem* item = [self itemAtIndexPath:indexPath];
    return RACChannelTo(item,isFavorite);
}
- (NSURL*) previewURLAtIndexPath:(NSIndexPath*) indexPath {
     STMItem* item = [self itemAtIndexPath:indexPath];
    return item.previewUrl;
}
@end
