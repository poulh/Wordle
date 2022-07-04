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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let entryText = entryTextField.text {
            if entryText.count < maxWordLength {
                textField.text = ""
                updateCurrWordLabel(with: "") { label, letter in
                    label.text = letter
                    
                }
            } else {
                if possibleWords.contains(entryText) {
                    textField.text = ""
                    
                    if entryText == todaysWord {
                        win()
                    } else {
                        currWord += 1
                        if currWord >= maxAttempts {
                            lose()
                        }
                    }
                } else {
                    updateCurrWordLabel(with: entryText) { label, letter in
                        label.textColor = .red
                    }
                }
                
                print(currWord)
            }
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("stop?")
        return true
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
               let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,
                                                             with: string)
               return (newString.count <= maxWordLength)
           }
           
        return false
   
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
        if let entryText = sender.text {
            updateCurrWordLabel(with: entryText) { label, letter in
                label.text = letter
                label.textColor = .white
            }
        }
    }
    
    func updateCurrWordLabel(with string:String, action: (UILabel, String)->()) {
        let wordStackView = wordListStackView.arrangedSubviews[currWord] as! UIStackView

        
        for (idx, letter) in string.enumerated() {
            if let letterLabel = wordStackView.arrangedSubviews[idx] as? UILabel {
                action(letterLabel, String(letter))
            }
        }
        
        for idx in string.count..<maxWordLength {
            if let letterLabel = wordStackView.arrangedSubviews[idx] as? UILabel {
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

