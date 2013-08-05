//
//  QuizRound.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/2/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "QuizRound.h"
#import "Constants.h"

@interface QuizRound()

@property (readwrite, strong, nonatomic) NSDictionary *jsonDict;

@end

@implementation QuizRound

-(NSDictionary *)jsonDict {
    _jsonDict = @{@"round_number": [NSNumber numberWithInt:self.roundNumber],
                  @"questions": [[NSMutableArray alloc] init]};
    
    for (id q in self.questions) {
        if ([q isMemberOfClass:[QuizQuestion class]]) {
            QuizQuestion *question = (QuizQuestion *) q;
            [_jsonDict[@"questions"] addObject:question.jsonDict];
        }
    }

    return _jsonDict;
}

-(NSDictionary *)serialize {
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    
    for (QuizQuestion *question in self.questions) {
        [questions addObject:[question serialize]];
    }

    return @{@"roundNumber":[NSNumber numberWithInt:self.roundNumber],
             @"questions":questions};
}

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
            QuizQuestion *question = [[QuizQuestion alloc] init];
            question.questionNumber = i+1;
            question.score = 0;
            [self.questions addObject:question];
        }
    }
    return self;
}

@end
