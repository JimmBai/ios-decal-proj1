//
//  HangmanGame.swift
//  Hangman
//
//  Created by Jim Bai on 2017/2/25.
//  Copyright © 2017年 Shawn D'Souza. All rights reserved.
//

import Foundation

class HangmanGame {
    
    var phrase = ""
    var hangmanPhrases = HangmanPhrases()
    var incorrectGuess = 0
    
    
    init(phrase: String, hangmanPhrases: HangmanPhrases) {
        self.phrase = phrase
        self.hangmanPhrases = hangmanPhrases
    }
    
    init() {
    }
    
    func startOver() -> String {
        self.phrase = hangmanPhrases.getRandomPhrase()
        incorrectGuess = 0
        return self.phrase
    }
    
    func checkGuess(chara: Character) -> String {
        var index = ""
        if self.phrase.uppercased().contains(String(chara)) {
            var count = 0
            for c in phrase.uppercased().characters {
                if c == chara {
                    index += String(count) + " "
                }
                count += 1
            }
        } else {
            incorrectGuess += 1
        }
        return index
    }
    
    func getIncorrectGuess() -> Int {
        return incorrectGuess
    }
}
