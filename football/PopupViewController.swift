//
//  PopupViewController.swift
//  football
//
//  Created by Martin Kostelej on 14/07/2021.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var startinImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionButton.layer.cornerRadius = 10.0
        instructionsView.layer.cornerRadius = 10.0
        instructionsView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        startinImageView.image = UIImage(named: "startingImage")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startGame(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if isBeingDismissed {
            NotificationCenter.default.post(name: NSNotification.Name("start"), object: nil)
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
