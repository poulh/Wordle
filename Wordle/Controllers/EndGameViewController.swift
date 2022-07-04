//
//  EndGameViewController.swift
//  Wordle
//
//  Created by Poul Hornsleth on 7/4/22.
//

import UIKit

class EndGameViewController: UIViewController {

    @IBOutlet weak var winStatusLabel: UILabel!
    var winStatus : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let winStatus = winStatus {
            winStatusLabel.text = winStatus
        }
        // Do any additional setup after loading the view.
    }


    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            print("post dismiss")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
