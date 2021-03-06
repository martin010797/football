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
    var soundsTurnedOff = false
    var reachedScore = 0
    
    var ignoreTimer = Timer()
    var ignorePauseButton = true
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
        soundButton.setImage(UIImage(named: "soundimage"), for: .normal)
        
        soundsTurnedOff = UserDefaults.standard.bool(forKey: SOUNDS_ON_OFF_KEY)
        if soundsTurnedOff {
            soundButton.setImage(UIImage(named: "noSound"), for: .normal)
        }else{
            soundButton.setImage(UIImage(named: "soundimage"), for: .normal)
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill
                gameScene = scene as? GameScene
                
                gameScene?.viewController = self
                                
                // Present the scene
                view.presentScene(scene)
            }

            view.ignoresSiblingOrder = true
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
        reachedScore = 0
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
    
    @IBAction func soundButtonPressed(_ sender: Any) {
        soundsTurnedOff = !soundsTurnedOff
        if soundsTurnedOff {
            soundButton.setImage(UIImage(named: "noSound"), for: .normal)
        }else{
            soundButton.setImage(UIImage(named: "soundimage"), for: .normal)
        }
        UserDefaults.standard.set(soundsTurnedOff, forKey: SOUNDS_ON_OFF_KEY)
        gameScene?.soundsButtonePressed()
    }
    
    func gameOver(score: Int){
        ignorePauseButton = true
        reachedScore = score
        performSegue(withIdentifier: "showScoreTableSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showScoreTableSegue" {
            let scoreTableViewController = segue.destination as! ScoreTableViewController
            scoreTableViewController.reachedScore = self.reachedScore
        }
    }
}
