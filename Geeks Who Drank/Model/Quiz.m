//
//  Quiz.m
//  Geeks Who Drank
//
//  Created by Dakota Scibilia on 7/1/13.
//  Copyright (c) 2013 csfds. All rights reserved.
//

#import "Quiz.h"
#import "Constants.h"

@implementation Quiz

-(NSComparisonResult)reverseCompare:(Quiz *)otherQuiz{
    NSNumber* myScore = [NSNumber numberWithInt:[self quizScore]];
    NSNumber* otherScore = [NSNumber numberWithInt:[otherQuiz quizScore]];
    return [otherScore compare:myScore];
}

-(NSComparisonResult)compare:(Quiz *)otherQuiz {
    NSNumber* myScore = [NSNumber numberWithInt:[self quizScore]];
    NSNumber* otherScore = [NSNumber numberWithInt:[otherQuiz quizScore]];
    return [myScore compare:otherScore];
}

-(NSMutableArray *)quizRounds {
    
    if (!_quizRounds) _quizRounds = [[NSMutableArray alloc] init];
    return _quizRounds;
}

-(NSString *)teamName {
    
    if (!_teamName) _teamName = @"";
    return  _teamName;
}

-(int)quizScore {
    
    int score = 0;
    
    if (self.quizRounds.count)
        for (QuizRound* r in self.quizRounds) {
            if (self.jokerRound == r.roundNumber-1 )
                score += [r roundScore]*2;
            else
                score += [r roundScore];
        }
    return score;
}

-(id)init {
    
    self = [super init];
    
    if (self) {
        for (int i = 0; i < ROUNDS_PER_QUIZ; i++) {
            QuizRound *round = [[QuizRound alloc] init];
            round.roundNumber = i+1;
            [self.quizRounds addObject:round];
        }
    }
    self.jokerRound = -1;
    return self;
}

-(id)initWithName:(NSString*)teamName {
    
    self = [self init];
    if (self)
        self.teamName = teamName;
    return self;
}

@end



