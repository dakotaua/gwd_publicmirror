//
//  QuizRound.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/2/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "QuizRound.h"
#import "Constants.h"

@implementation QuizRound

-(NSMutableArray *)questions {
    
    if (!_questions) _questions = [[NSMutableArray alloc] init];
    return _questions;
}

-(int)roundScore {
    
    int score = 0;

    if (self.questions.count) 
        for (QuizQuestion* q in self.questions)
            score += q.score;
    
    return score;
}

-(id)init {
    
    self = [super init];
    
    if (self) {
        for (int i = 0; i < QUESTIONS_PER_ROUND; i++) {
            QuizQuestion *qq = [[QuizQuestion alloc] init];
            [self.questions addObject:qq];
        }
    }
    return self;
}

@end
