//
//  STMModel.h
//  ItunesBrowser
//
//  Created by Stefano Mondino on 05/11/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@interface STMModel : NSObject
+ (instancetype) shared;
- (RACSignal*) rac_queryWithSearchTerm:(NSString*) searchTerm;
- (NSFetchedResultsController *)fetchedResultsControllerForFavorites;
@end
