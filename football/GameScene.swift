//
//  GameScene.swift
//  football
//
//  Created by Martin Kostelej on 09/07/2021.
//

import SpriteKit

let DEFAULT_WIDTH = 200.0
let DEFAULT_HEIGHT = 200.0
let BALL_CATEGORY: UInt32 = 1
let GOAL_CATEGORY: UInt32 = 2
let OUTSIDE_GOAL_CATEGORY: UInt32 = 4
let NO_CATEGORY: UInt32 = 128
let Y_COORD_DEFAULT_MIN_SPEED:Double = -500
let Y_COORD_DEFAULT_MAX_SPEED:Double = -700
let X_COORD_DEFAULT_MIN_SPEED:Double = -200
let X_COORD_DEFAULT_MAX_SPEED:Double = 200
let DEFAULT_NUMBER_OF_LIVES = 3
let DEFAULT_SCORE = 0
let CLASSIC_BALL_PROBABILITY_PERCENTAGE = 70

let LEVEL_2_BALLS_COUNT = 5
let LEVEL_3_BALLS_COUNT = 10
let LEVEL_4_BALLS_COUNT = 15
let LEVEL_5_BALLS_COUNT = 20
let LEVEL_6_BALLS_COUNT = 30
let LEVEL_7_BALLS_COUNT = 40
let LEVEL_8_BALLS_COUNT = 50
let LEVEL_9_BALLS_COUNT = 70
let LEVEL_10_BALLS_COUNT = 100

let MAX_COMBO = 4


class GameScene: SKScene {
    
//    let firstSpriteNode = SKSpriteNode(color: UIColor.red, size: CGSize(width: 200.0, height: 200.0))
//    let secondSpriteNode = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 100.0, height: 100.0))
    var balls :[SKSpriteNode] = [SKSpriteNode]()
    var timerBalls = Timer()
    var numberOfBallsShot = 0
    var isGamePaused = false
    
    var yCoordMinSpeed = Y_COORD_DEFAULT_MIN_SPEED
    var yCoordMaxSpeed = Y_COORD_DEFAULT_MAX_SPEED
    var xCoordMinSpeed = X_COORD_DEFAULT_MIN_SPEED
    var xCoordMaxSpeed = X_COORD_DEFAULT_MAX_SPEED
        
    var numberOfLives = DEFAULT_NUMBER_OF_LIVES
    var score = DEFAULT_SCORE
    
    let livesLabelNode = SKLabelNode(fontNamed: "Verdana-Bold")
    let scoreLabelNode = SKLabelNode(fontNamed: "Verdana-Bold")
    let pauseLabelNode = SKLabelNode(fontNamed: "Verdana-Bold")
    
    var countdownLabel = SKLabelNode(fontNamed: "Verdana-Bold")
    var countdown = 0
    
    let ballNode = SKSpriteNode(imageNamed: "ball")
    let background = SKSpriteNode(imageNamed: "background2")
    let topInfoBar = SKSpriteNode(color: UIColor.systemGreen, size: CGSize(width: DEFAULT_WIDTH, height: DEFAULT_HEIGHT))
    let goalNode = SKSpriteNode(imageNamed: "goal")
    let goalPlayerNode = SKSpriteNode(imageNamed: "goal")
    
    var comboGoals = 0
    
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        background.zPosition = -1
        
        pauseLabelNode.text = "Hra je pozastavená"
        pauseLabelNode.fontColor = UIColor.black
        pauseLabelNode.fontSize = 60
        pauseLabelNode.horizontalAlignmentMode = .center
        pauseLabelNode.verticalAlignmentMode = .center
        scoreLabelNode.zPosition = 100
        addChild(pauseLabelNode)
        pauseLabelNode.isHidden = true
        
        topInfoBar.size.width = frame.width
        topInfoBar.size.height = frame.height / 10
        topInfoBar.position = CGPoint(x: frame.midX, y: frame.height / 2 - topInfoBar.size.height / 2)
        
        background.addChild(goalNode)
        goalNode.position = CGPoint(x: frame.midX, y: topInfoBar.position.y - topInfoBar.size.height + 40)
        goalNode.size.width = frame.width / 4
        goalNode.size.height = frame.height / 12
        goalNode.zPosition = 2
        
        background.addChild(topInfoBar)
        topInfoBar.zPosition = 3
        
        background.addChild(goalPlayerNode)
        goalPlayerNode.position = CGPoint(x: frame.midX, y: frame.midY - frame.height / 2 + 40)
        goalPlayerNode.zRotation = CGFloat(Double.pi)
        goalPlayerNode.size.width = frame.width * 3 / 4
        goalPlayerNode.size.height = frame.height / 10
        goalPlayerNode.zPosition = 4
        
        livesLabelNode.text = "❤️ " + String(numberOfLives)
        livesLabelNode.fontColor = UIColor.black
        livesLabelNode.fontSize = 40
        livesLabelNode.zPosition = 5
        livesLabelNode.horizontalAlignmentMode = .left
        livesLabelNode.verticalAlignmentMode = .top
        livesLabelNode.position = CGPoint(x: frame.midX - frame.size.width * 4 / 10, y: frame.midY - 10)
        topInfoBar.addChild(livesLabelNode)
        
        scoreLabelNode.text = "Skóre: " + String(score)
        scoreLabelNode.fontColor = UIColor.black
        scoreLabelNode.fontSize = 40
        scoreLabelNode.zPosition = 6
        scoreLabelNode.horizontalAlignmentMode = .right
        scoreLabelNode.verticalAlignmentMode = .top
        scoreLabelNode.position = CGPoint(x: frame.midX + frame.size.width * 4 / 10, y: frame.midY - 10)
        topInfoBar.addChild(scoreLabelNode)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        
        
        self.view?.isPaused = true
    }
    
    func startGame(count: Int) {
        self.view?.isPaused = false
        countdownLabel.position = CGPoint(x: frame.midX, y: frame.midY + 30)
        countdownLabel.fontColor = SKColor.black
        countdownLabel.fontSize = 140
        countdownLabel.text = "\(count)"
        countdown = count
        addChild(countdownLabel)

        let counterDecrement = SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run(countdownAction)])
        run(SKAction.sequence([SKAction.repeat(counterDecrement, count: count), SKAction.run(endCountdown)]))
    }
    
    func countdownAction() {
        countdown -= 1
        countdownLabel.text = "\(countdown)"
    }
    
    func endCountdown() {
        countdownLabel.removeFromParent()
        nastavRychlost(kazdychSekund: 4)
        addBall()
    }
    
    func pauseButtonePressed() {
        if isGamePaused {
            unpauseTheGame()
        }else{
            pauseTheGame()
        }
    }
    
    func pauseTheGame() {
        pauseLabelNode.isHidden = false
        isGamePaused = true
        timerBalls.invalidate()
        for ball in balls {
            ball.isPaused = true
        }
        physicsWorld.speed = 0
    }
    
    func unpauseTheGame() {
        pauseLabelNode.isHidden = true
        
        countdownLabel.position = CGPoint(x: frame.midX, y: frame.midY + 30)
        countdownLabel.fontColor = SKColor.black
        countdownLabel.fontSize = 140
        countdownLabel.text = "3"
        countdown = 3
        addChild(countdownLabel)

        let counterDecrement = SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run(countdownAction)])
        run(SKAction.sequence([SKAction.repeat(counterDecrement, count: 3), SKAction.run(endCountdownAfterPause)]))
    }
    
    func endCountdownAfterPause() {
        countdownLabel.removeFromParent()
        for ball in balls {
            ball.isPaused = false
        }
        if numberOfBallsShot < LEVEL_2_BALLS_COUNT{
            nastavRychlost(kazdychSekund: 4)
        }else if numberOfBallsShot < LEVEL_4_BALLS_COUNT{
            nastavRychlost(kazdychSekund: 3)
        }else if numberOfBallsShot < LEVEL_5_BALLS_COUNT{
            nastavRychlost(kazdychSekund: 2)
        }else if numberOfBallsShot < LEVEL_7_BALLS_COUNT{
            nastavRychlost(kazdychSekund: 1.5)
        }else{
            nastavRychlost(kazdychSekund: 1)
        }
        physicsWorld.speed = 1
        isGamePaused = false
    }
    
    func nastavRychlost(kazdychSekund: Double) {
        if timerBalls.isValid {
            timerBalls.invalidate()
            timerBalls = Timer.scheduledTimer(timeInterval: kazdychSekund, target: self, selector: Selector("addBall"), userInfo: nil, repeats: true)
        }else{
//            timerBalls.invalidate()
            timerBalls = Timer.scheduledTimer(timeInterval: kazdychSekund, target: self, selector: Selector("addBall"), userInfo: nil, repeats: true)
        }
    }

    
    @objc func addBall() {
        if numberOfBallsShot < LEVEL_7_BALLS_COUNT || (numberOfBallsShot >= LEVEL_7_BALLS_COUNT && (Int.random(in: 0 ..< 100)) < 80) {
            
            if Int.random(in: 0 ..< 100) <= CLASSIC_BALL_PROBABILITY_PERCENTAGE {
                ballCreation(imageName: "ball")
            }else{
                ballCreation(imageName: "golden_ball")
            }
            
            numberOfBallsShot += 1
            changeDifficulty()
        }
    }
    
    func ballCreation(imageName: String){
        let ball = SKSpriteNode(imageNamed: imageName)
        background.addChild(ball)
        ball.zPosition = 1
        ball.size = CGSize(width: 150.0, height: 150.0)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody!.categoryBitMask = BALL_CATEGORY
        ball.physicsBody!.collisionBitMask = NO_CATEGORY
        ball.physicsBody!.restitution = 1.0
        ball.userData = NSMutableDictionary()
        if imageName == "ball" {
            ball.userData?.setValue(false, forKey: "golden")
        }else{
            ball.userData?.setValue(true, forKey: "golden")
        }
        ball.userData?.setValue(false, forKey: "hitted")
        balls.append(ball)

        let randomDx = Double.random(in: xCoordMinSpeed ..< xCoordMaxSpeed)
        let randomDy = Double.random(in: yCoordMaxSpeed ..< yCoordMinSpeed)
        ball.physicsBody!.applyImpulse(CGVector(dx: randomDx, dy: randomDy))
        
        let randomXPosition = Double.random(in: (Double(frame.midX) - Double(frame.size.width) * 2 / 5) ..< (Double(frame.midX) + Double(frame.size.width) * 2 / 5))
        ball.position = CGPoint(x: CGFloat(randomXPosition), y: frame.midY + frame.size.height * 1/4)

    }
    
    func changeDifficulty() {
        switch numberOfBallsShot {
        case LEVEL_2_BALLS_COUNT:
            yCoordMaxSpeed = -800
            yCoordMinSpeed = -600
            nastavRychlost(kazdychSekund: 3)
            print("level 2")
        case LEVEL_3_BALLS_COUNT:
            yCoordMaxSpeed = -900
            yCoordMinSpeed = -650
            print("level 3")
        case LEVEL_4_BALLS_COUNT:
            yCoordMaxSpeed = -900
            yCoordMinSpeed = -700
            nastavRychlost(kazdychSekund: 2)
            print("level 4")
        case LEVEL_5_BALLS_COUNT:
            yCoordMaxSpeed = -1000
            yCoordMinSpeed = -750
            nastavRychlost(kazdychSekund: 1.5)
            print("level 5")
        case LEVEL_6_BALLS_COUNT:
            yCoordMaxSpeed = -1100
            yCoordMinSpeed = -750
            print("level 6")
        case LEVEL_7_BALLS_COUNT:
            yCoordMaxSpeed = -1150
            yCoordMinSpeed = -750
            nastavRychlost(kazdychSekund: 1)
            print("level 7")
        case LEVEL_8_BALLS_COUNT:
            yCoordMaxSpeed = -1150
            yCoordMinSpeed = -800
            print("level 8")
        case LEVEL_9_BALLS_COUNT:
            yCoordMaxSpeed = -1250
            yCoordMinSpeed = -800
            print("level 9")
        case LEVEL_10_BALLS_COUNT:
            yCoordMaxSpeed = -1350
            yCoordMinSpeed = -800
            print("level 10")
        default:
            print("no change")
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGamePaused {
            for touch in touches {
                let location = touch.location(in: self)
                for b in balls {
                    if b.contains(location) && location.y <= 0 {
                        print("hit")
                        var posunX = (b.frame.midX - location.x)*15
                        var posunY = (b.frame.midY - location.y)*15
                        print(" posX: \(posunX) posY: \(posunY)")
                        print(b.physicsBody!.velocity)
                        let rychlost = abs(b.physicsBody!.velocity.dx) + abs(b.physicsBody!.velocity.dy)
                        print(rychlost)
                        
                        if (b.frame.midX - location.x) > 0 {
                            posunX = (b.frame.midX - location.x) + abs(b.frame.midX - location.x) / (abs(b.frame.midX - location.x) + abs(b.frame.midY - location.y)) * rychlost
                        }else{
                            posunX = (b.frame.midX - location.x) - abs(b.frame.midX - location.x) / (abs(b.frame.midX - location.x) + abs(b.frame.midY - location.y)) * rychlost
                        }
                        if (b.frame.midY - location.y) > 0 {
                            posunY = (b.frame.midY - location.y) + abs(b.frame.midY - location.y) / (abs(b.frame.midX - location.x) + abs(b.frame.midY - location.y)) * rychlost
                        }else{
                            posunY = (b.frame.midY - location.y) - abs(b.frame.midY - location.y) / (abs(b.frame.midX - location.x) + abs(b.frame.midY - location.y)) * rychlost
                        }
                        posunX = posunX + posunX * 2 / 3
                        posunY = posunY + posunY * 2 / 3
                        print(" posX2: \(posunX) posY2: \(posunY)")
                        
                        b.physicsBody!.applyImpulse(CGVector(dx: posunX, dy: posunY))
                        b.userData?.setValue(true, forKey: "hitted")
                    }
                }
                
            }
        }
//        textureNode.physicsBody!.applyImpulse(CGVector(dx: -100.0, dy: -2.0))
        
        //otacanie node
//        textureNode.run(SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration: 2.0))
        //secondSpriteNode.run(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 2.0))
        
        //aby sa otacal stale
//        if !secondSpriteNode.hasActions() {
            //samotne tocenie sa
//            secondSpriteNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 2.0)))
            //viacero akcii napriklad tocenie a zmensovanie. cez group sa vykonava naraz
//            secondSpriteNode.run(SKAction.group([SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 2.0), SKAction.scale(by: 0.9, duration: 2.0)]))
            //viacero akcii ale cez sequence sa vykonavaju postupne
//            secondSpriteNode.run(SKAction.sequence([SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 2.0), SKAction.scale(by: 0.9, duration: 2.0)]))
//        }else{
//            secondSpriteNode.removeAllActions()
//        }
//
        //ked si takto vytovrim akciu tak sa k nej môzem hocikedy odvolat pomocou klucu
//        if let _ = textureNode.action(forKey: "Rotation") {
//            textureNode.removeAction(forKey: "Rotation")
//        }else{
//            textureNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration: 2.0)), withKey: "Rotation")
//        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        checkGoal()
        checkCrossinngHalf()
    }
    
    func checkCrossinngHalf() {
        for ball in balls {
            if (ball.userData!.value(forKey: "hitted") != nil) {
                let value = ball.userData!.value(forKey: "hitted") as? Bool ?? false
                if value && (ball.position.y > frame.midY + ball.size.height / 2) {
                    score += 1
                    scoreLabelNode.text = "Skóre: " + String(score)
                    ball.userData!.setValue(false, forKey: "hitted")
                    
                    scoreLabel(node: ball, value: String(1))
                }
            }
        }
    }
    
    func scoreLabel(node: SKSpriteNode, value: String) {
        let scoreLabel = SKLabelNode(fontNamed: "Verdana-Bold")
        scoreLabel.position = node.position
        scoreLabel.fontColor = UIColor.blue
        if value == "❤️" {
            scoreLabel.position.y -= 50
            scoreLabel.fontColor = UIColor.red
        }
        scoreLabel.fontSize = 35
        scoreLabel.text = "+"+value
        addChild(scoreLabel)
        scoreLabel.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()]) )
    }
    
    func removeBall(ball: SKSpriteNode, index: Int) {
        if index < balls.count{
            ball.removeFromParent()
            balls.remove(at: index)
        }
    }
    
    func checkGoal() {
        for (index, ball) in balls.enumerated() {
            //removing stuck balls
            if (abs(ball.physicsBody!.velocity.dx) + abs(ball.physicsBody!.velocity.dy)) < 300 {
                removeBall(ball: ball, index: index)
            }
            if ball.position.y < (frame.midY - frame.size.height * 4 / 10) {
                removeBall(ball: ball, index: index)
                print("hrac dostal gol")
                numberOfLives -= 1
                livesLabelNode.text = "❤️ " + String(numberOfLives)
            }else if ball.position.y > (frame.midY + frame.size.height * 30 / 100) {
                if ball.position.x > (frame.midX - frame.size.width / 8) && ball.position.x < (frame.midX + frame.size.width / 8) {
                    if let sparks = SKEmitterNode(fileNamed: "Spark") {
                        sparks.position = ball.position
                        addChild(sparks)
                        sparks.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
                    }
                    if comboGoals < MAX_COMBO {
                        comboGoals += 1
                    }
                    score = score + comboGoals * 3
                    scoreLabelNode.text = "Skóre: " + String(score)
                    scoreLabel(node: ball, value: String(comboGoals * 3))
                    if (ball.userData!.value(forKey: "golden") != nil) {
                        let value = ball.userData!.value(forKey: "golden") as? Bool ?? false
                        if value{
                            numberOfLives += 1
                            livesLabelNode.text = "❤️ " + String(numberOfLives)
                            scoreLabel(node: ball, value: "❤️")
                        }
                    }
                    print("GOL!")
                }else{
                    comboGoals = 0
                    print("Mimo brany")
                }
                removeBall(ball: ball, index: index)
            }
            
        }
    }
}
