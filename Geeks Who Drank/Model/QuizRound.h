//
//  QuizRound.h
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/2/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizQuestion.h"

@interface QuizRound : NSObject

@property (nonatomic) int roundNumber;
@property (strong, nonatomic) NSArray *questions;
@property (nonatomic, getter=isJokered) BOOL jokered;

-(int)roundScore;

@end