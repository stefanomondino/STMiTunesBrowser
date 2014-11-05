//
//  STMModel.m
//  ItunesBrowser
//
//  Created by Stefano Mondino on 05/11/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import "STMModel.h"
#import <CoreData+MagicalRecord.h>
#import <AFNetworking.h>
#import "STMItem.h"
@interface STMModel()
@property (nonatomic,strong) AFHTTPRequestOperationManager * manager;
@end

@implementation STMModel


+ (instancetype) shared {
    static id _shared;
    if (!_shared) {
        _shared = [self new];
    }
    return _shared;
}

- (instancetype)init {
    self = [super init];
    [self setup];
    return self;
}

- (void) setup {
    self.manager = [AFHTTPRequestOperationManager manager];
    [MagicalRecord setupAutoMigratingCoreDataStack];
}
- (NSFetchedResultsController *)fetchedResultsControllerForFavorites {
    return [STMSavedItem fetchedResultsControllerForFavorites];
}
- (RACSignal*) rac_queryRemoteServiceWithParameters:(NSDictionary*) parameters {
    AFHTTPRequestOperationManager* manager = self.manager;
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation* operation = [manager GET:@"https://itunes.apple.com/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray* responseObjects = [responseObject objectForKey:@"results"];
            
            NSArray* mappedResults = [[responseObjects.rac_sequence
                                       map:^id(NSDictionary* value) {
                                           return [STMItem itemWithDictionary:value];
                                       }]
                                      array];
            [subscriber sendNext:mappedResults];
            [subscriber sendCompleted];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

- (RACSignal*) rac_queryWithSearchTerm:(NSString*) searchTerm{
    if (searchTerm) {
        return [self rac_queryRemoteServiceWithParameters:@{@"term":searchTerm, @"media":@"music"}];
    }
    else {
        return [RACSignal error:[NSError errorWithDomain:@"myDomain.noParameter" code:1 userInfo:nil]];
    }
    
}
@end
