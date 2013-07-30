//
//  EventTableNewTeamCell.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/11/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "QuizTableNewTeamCell.h"

@implementation QuizTableNewTeamCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    [self setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:76.0f/255.0f blue:76.0f/255.0f alpha:1.0f]];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
