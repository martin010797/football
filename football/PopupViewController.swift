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
    
    var started = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionButton.layer.cornerRadius = 10.0
        instructionsView.layer.cornerRadius = 10.0
        instructionsView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        instructionsTextView.isEditable = false

        startinImageView.image = UIImage(named: "startingImage")
    }
    
    @IBAction func startGame(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if isBeingDismissed && !started {
            NotificationCenter.default.post(name: NSNotification.Name("start"), object: nil)
            started = true
        }
    }
}
