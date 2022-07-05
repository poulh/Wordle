//
//  ViewController.swift
//  Wordle
//
//  Created by Poul Hornsleth on 7/3/22.
//

import UIKit

class ViewController: UIViewController,  UITextFieldDelegate {

    @IBOutlet weak var wordListStackView: UIStackView!

    @IBOutlet weak var entryTextField: UITextField!
    
    let possibleWords: Set = ["RAISE", "TOUCH", "FEAST", "RIVAL", "EGRET", "FAVOR", "TRIST", "STEEL"]
    let todaysWord = "FEAST"
    
    let maxWordLength = 5
    let maxAttempts = 5
    let emptyValue = " "
    
    var currWord = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryTextField.delegate = self
        entryTextField.isHidden = false
        entryTextField.becomeFirstResponder()
        
        createGameBoard()
        
        let char = todaysWord[todaysWord.index(todaysWord.startIndex, offsetBy: 3)]
        print(char)
        
    }
    
   
    fileprivate func createGameBoard() {
        for _ in 0..<maxAttempts {
            let wordStackView = UIStackView()
            
            wordStackView.distribution = .fillEqually
            wordStackView.spacing = 0
            wordStackView.axis = .horizontal
            for _ in 0..<maxWordLength {
                let letterLabel = UILabel()
                letterLabel.frame = CGRect(x: 0, y: 0, width: 64, height: 64  )
                letterLabel.text = emptyValue
                letterLabel.font = letterLabel.font.withSize(48)
                
                letterLabel.backgroundColor = .black
                letterLabel.textColor = .white
                letterLabel.layer.borderColor = UIColor.white.cgColor
                letterLabel.layer.borderWidth = 1.0
                
                letterLabel.textAlignment = .center
                wordStackView.addArrangedSubview(letterLabel)
            }
            wordListStackView.addArrangedSubview(wordStackView)
        }
    }
    
    fileprivate func newGame() {
        currWord = 0
        
        for index in 0..<maxAttempts {
            updateCurrWordLabel(at: index, with: "") { label, letter in
                label.text = letter
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let entryText = textField.text else {
            return false
        }
        var clearText = true

        if entryText.count < maxWordLength {
            updateCurrWordLabel(at: currWord, with: "") { label, letter in
                label.text = letter
            }
        } else if entryText == todaysWord {
            win()
            newGame()
        }
        else if possibleWords.contains(entryText) {
                
            currWord += 1
            if currWord >= maxAttempts {
                lose()
                newGame()
            }
                
        } else {
            clearText = false
            updateCurrWordLabel(at: currWord, with: entryText) { label, letter in
                label.textColor = .red
            }
        }
        if clearText {
            textField.text = ""
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("stop?")
        return true
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldString = textField.text else {
            return false
        }
        
        let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
        return (newString.count <= maxWordLength)
    }
    
    func win() {
        print("win")
        self.performSegue(withIdentifier: "endGame", sender: self)
    }
    
    func lose() {
        print("lose")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("end")
        entryTextField.text = ""
    }
    
    @IBAction func enttryTextFieldEditingChanged(_ sender: UITextField) {
        guard let entryText = sender.text else {
            return
        }
        
        updateCurrWordLabel(at: currWord, with: entryText) { label, letter in
            label.text = letter
            label.textColor = .white
        }
    }
    
    func updateCurrWordLabel(at wordIndex:Int, with string:String, action: (UILabel, String)->()) {
        guard let wordStackView = wordListStackView.arrangedSubviews[wordIndex] as? UIStackView else {
            return
        }
        
        for (letterIndex, letter) in string.enumerated() {
            if let letterLabel = wordStackView.arrangedSubviews[letterIndex] as? UILabel {
                action(letterLabel, String(letter))
            }
        }
        
        for letterIndex in string.count..<maxWordLength {
            if let letterLabel = wordStackView.arrangedSubviews[letterIndex] as? UILabel {
                action(letterLabel, emptyValue)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
        if segue.identifier == "endGame" {
            if let destinationVC = segue.destination as? EndGameViewController {
                destinationVC.winStatus = "Win"
            }
        }
    }
}

