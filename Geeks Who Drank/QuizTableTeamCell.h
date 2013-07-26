//
//  EventTableTeamCell.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/11/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizTableTeamCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *standingLabel;

@end
