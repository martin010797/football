//
//  GameViewController.swift
//  football
//
//  Created by Martin Kostelej on 09/07/2021.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var gameScene:GameScene?
    var isPaused = false
    
    var ignoreTimer = Timer()
    var ignorePauseButton = true
    @IBOutlet weak var pauseButton: UIButton!
    //    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.startGame), name: "myNotification", object: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        pauseButton.tintColor = UIColor.black
        pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                gameScene = scene as? GameScene
//                gameScene?.startGame()
                
                // Present the scene
                view.presentScene(scene)
            }
            

            view.ignoresSiblingOrder = true

            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true

        }
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.startGame), name: NSNotification.Name("start"), object: nil)
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "showPopup", sender: self)
        }
        
        
    }
    
    @objc func stopIgnoring(){
        ignorePauseButton = false
    }
    
    @objc func startGame(){
        gameScene?.startGame(count: 3)
        ignoreTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: Selector("stopIgnoring"), userInfo: nil, repeats: false)
    }
    @IBAction func pauseButtonPressed(_ sender: Any) {
        if !ignorePauseButton {
            if isPaused {
                pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
                isPaused = false
                
                ignorePauseButton = true
                ignoreTimer.invalidate()
                ignoreTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: Selector("stopIgnoring"), userInfo: nil, repeats: false)
            }else{
                pauseButton.setImage(UIImage(named: "playButton"), for: .normal)
                isPaused = true
            }
            gameScene?.pauseButtonePressed()
        }
    }
}
