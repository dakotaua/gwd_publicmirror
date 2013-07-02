//
//  Quiz.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/1/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizRound.h"

@interface Quiz : NSObject

@property (strong, nonatomic) NSString *teamName;
@property (nonatomic) int jokerRound;
@property (strong, nonatomic) NSArray *quizRounds;

-(int)quizScore;

@end
