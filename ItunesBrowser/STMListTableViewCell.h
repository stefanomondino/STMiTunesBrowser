//
//  STMListTableViewCell.h
//  ItunesBrowser
//
//  Created by Stefano Mondino on 05/11/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STMListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_cover;
@property (weak, nonatomic) IBOutlet UILabel *lbl_artistName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_collectionName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_trackName;
@property (weak, nonatomic) IBOutlet UISwitch *btn_favorite;
@end
