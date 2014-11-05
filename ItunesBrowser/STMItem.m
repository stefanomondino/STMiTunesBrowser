//
//  STMItem.m
//  ItunesBrowser
//
//  Created by Stefano Mondino on 05/11/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import "STMItem.h"
@interface STMItem()
@property (nonatomic,strong) NSDictionary* dataDictionary;
@end

@implementation STMItem
+ (instancetype) itemWithDictionary:(NSDictionary*) dictionary {
    STMItem* item = [self new];
    item.dataDictionary = dictionary;
    return item;
}


- (NSString *)artistName {
    return self.dataDictionary[@"artistName"];
}
- (NSString *)collectionName {
    return self.dataDictionary[@"collectionName"];
}
- (NSString *)trackName {
    return self.dataDictionary[@"trackName"];
}
- (NSString *)trackId {
    return self.dataDictionary[@"trackId"];
}
- (NSURL *)artworkUrl100 {
    return [NSURL URLWithString:self.dataDictionary[@"artworkUrl100"]];
}
- (NSURL *)previewUrl {
    return [NSURL URLWithString:self.dataDictionary[@"previewUrl"]];
}
- (void) saveAsFavorite {
    [STMSavedItem newItemWithId:self.trackId dataDictionary:self.dataDictionary];
}
- (void)setIsFavorite:(BOOL)isFavorite {
    if (isFavorite) [self saveAsFavorite];
    else [self removeFromFavorites];
}
- (BOOL) isFavorite {
    return [STMSavedItem itemIsFavoriteWithId:self.trackId];
}
- (void) removeFromFavorites {
    [STMSavedItem removeFavoriteWithId:self.trackId];
}
+ (NSArray*) allFavorites {
    return [[[STMSavedItem allFavorites].rac_sequence map:^id(STMSavedItem* value) {
        return [STMItem itemWithDictionary:value.dataDictionary];
    }] array];
}
@end

@implementation STMSavedItem
@dynamic trackId,dataDictionary,date;
+ (STMSavedItem*) itemWithId:(NSNumber*) trackId {
    return [self MR_findFirstByAttribute:@"trackId" withValue:trackId];
}
+ (instancetype) newItemWithId:(NSNumber*) trackId dataDictionary:(NSDictionary*) dataDictionary {
    STMSavedItem* item = [self itemWithId:trackId];
    if (!item) {
        item = [self MR_createEntity];
    }
    item.trackId = trackId;
    item.dataDictionary = dataDictionary;
    item.date = [NSDate date];
    [item.managedObjectContext MR_saveToPersistentStoreAndWait];
    return item;
}
+ (BOOL) itemIsFavoriteWithId:(NSNumber*) trackId {
    return [self itemWithId:trackId]!=nil;
}
+ (void) removeFavoriteWithId:(NSNumber*) trackId {
    STMSavedItem* item= [self itemWithId:trackId];
    NSManagedObjectContext* moc= item.managedObjectContext;
    [item MR_deleteEntity];
    [moc MR_saveToPersistentStoreAndWait];
}
+ (NSArray*) allFavorites {
    return [self MR_findAllSortedBy:@"date" ascending:NO];
}
+ (NSFetchedResultsController*) fetchedResultsControllerForFavorites {
    return [self MR_fetchAllSortedBy:@"date" ascending:NO withPredicate:[NSPredicate predicateWithValue:YES] groupBy:nil delegate:nil];
}
@end