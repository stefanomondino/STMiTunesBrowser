//
//  STMItem.h
//  ItunesBrowser
//
//  Created by Stefano Mondino on 05/11/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData+MagicalRecord.h>

@interface STMSavedItem : NSManagedObject
@property (nonatomic,strong) NSNumber* trackId;
@property (nonatomic,strong) NSDictionary* dataDictionary;
@property (nonatomic,strong) NSDate* date;
+ (instancetype) newItemWithId:(NSNumber*) trackId dataDictionary:(NSDictionary*) dataDictionary;
+ (BOOL) itemIsFavoriteWithId:(NSNumber*) trackId ;
+ (void) removeFavoriteWithId:(NSNumber*) trackId;
+ (NSArray*) allFavorites;
+ (NSFetchedResultsController*) fetchedResultsControllerForFavorites;
@end

@interface STMItem : NSObject
+ (instancetype) itemWithDictionary:(NSDictionary*) dictionary;
@property (nonatomic, readonly) NSString* artistName;
@property (nonatomic, readonly) NSString* collectionName;
@property (nonatomic,readonly) NSString* trackName;
@property (nonatomic,readonly) NSNumber* trackId;
@property (nonatomic,readonly) NSURL* artworkUrl100;
@property (nonatomic,readonly) NSURL* previewUrl;
@property (nonatomic,readwrite) BOOL isFavorite;
+ (NSArray*) allFavorites;
- (void) saveAsFavorite;
- (void) removeFromFavorites;
@end
