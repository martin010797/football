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
//    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.startGame), name: "myNotification", object: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @objc func startGame(){
        gameScene?.startGame(count: 3)
    }
}
