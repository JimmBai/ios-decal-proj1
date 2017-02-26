//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {

    @IBOutlet var hangmanState: UIImageView!
    @IBOutlet var guessDisplay: UILabel!
    @IBOutlet var userGuess: UITextField!
    @IBOutlet var incorrectGuess: UILabel!
    
    var hangmanGame = HangmanGame()
    var gameState = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hangmanPhrases = HangmanPhrases()
        // Generate a random phrase for the user to guess
        let phrase: String = hangmanPhrases.getRandomPhrase()
        print(phrase)
        hangmanGame = HangmanGame(phrase:phrase, hangmanPhrases:hangmanPhrases)
        defaultGuessDisplay(phrase:phrase)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func guessButton(_ sender: UIButton) {
        if let guessChara = userGuess.text {
            if guessChara.characters.count == 1 {
                if let alreadyGuess = guessDisplay.text {
                    if alreadyGuess.contains(guessChara) {
                        return
                    }
                }
                let index = hangmanGame.checkGuess(chara: Character(guessChara.uppercased()))
                updateDisplay(index:index, chara:guessChara.uppercased())
            }
            userGuess.text = ""
        }
    }

    func defaultGuessDisplay(phrase: String) {
        var defaultDispaly = ""
        for w in phrase.characters {
            if w == " " {
                defaultDispaly += "  "
            } else {
                defaultDispaly += "_ "
            }
        }
        if phrase.characters.count > 12 {
            guessDisplay.numberOfLines = phrase.characters.count / 12
        }
        guessDisplay.text = defaultDispaly
        hangmanState.image = UIImage(named: "hangman1")
        incorrectGuess.text = "Incorrect Guesses: 0"
        gameState = true
    }
    
    func updateDisplay(index: String, chara: String) {
        if !gameState {
            return
        }
        if index.characters.count == 0 {
            let incorrect = String(hangmanGame.getIncorrectGuess())
            incorrectGuess.text = "Incorrect Guesses: " + incorrect
            let imageName = "hangman" + String(hangmanGame.getIncorrectGuess()+1)
            hangmanState.image = UIImage(named: imageName)
            if hangmanGame.getIncorrectGuess() == 6 {
                showAlert(message: "Lose")
                gameState = false
            }
        } else {
            var temp = guessDisplay.text
            var id = ""
            for i in index.characters {
                if i != " " {
                    id += String(i)
                    continue
                }
                let pos = Int(String(id))!*2
                let start = temp?.index((temp?.startIndex)!, offsetBy:pos)
                let end = temp?.index((temp?.startIndex)!, offsetBy:pos+1)
                temp = temp?.replacingCharacters(in:start!..<end!, with: chara)
                id = ""
            }
            guessDisplay.text = temp
            if !(temp?.contains("_"))! {
                showAlert(message: "Win")
                gameState = false
            }
        }
    }
    
    func showAlert(message: String) {
        var titleContent = "Congratulations!"
        var messageContent = "You Win!"
        if message == "Lose" {
            titleContent = "Sorry"
            messageContent = "You Lose!"
        }
        let alertController = UIAlertController(title: titleContent, message:
            messageContent, preferredStyle: UIAlertControllerStyle.alert)
        let handle = { (action:UIAlertAction!) -> Void in
            self.reStart()
        }
        alertController.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.default,handler: handle))
        
        self.present(alertController, animated: true, completion: nil)
    }

    func reStart() {
        let phrase = hangmanGame.startOver()
        defaultGuessDisplay(phrase: phrase)
        print(phrase)
    }
    
    @IBAction func startOver(_ sender: UIBarButtonItem) {
        reStart()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
