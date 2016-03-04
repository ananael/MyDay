//
//  CollectionViewCell.h
//  MyDay
//
//  Created by Michael Hoffman on 3/3/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;


@end
