//
//  GameScene.swift
//  football
//
//  Created by Martin Kostelej on 09/07/2021.
//

import SpriteKit

let DEFAULT_WIDTH = 200.0
let DEFAULT_HEIGHT = 200.0

class GameScene: SKScene {
    
//    let firstSpriteNode = SKSpriteNode(color: UIColor.red, size: CGSize(width: 200.0, height: 200.0))
//    let secondSpriteNode = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 100.0, height: 100.0))
    var balls :[SKSpriteNode] = [SKSpriteNode]()
    var timerBalls = Timer()
    
    let ballNode = SKSpriteNode(imageNamed: "ball")
    let background = SKSpriteNode(imageNamed: "background")
    let topInfoBar = SKSpriteNode(color: UIColor.systemGreen, size: CGSize(width: DEFAULT_WIDTH, height: DEFAULT_HEIGHT))
    let goalNode = SKSpriteNode(imageNamed: "goal")
    let goalPlayerNode = SKSpriteNode(imageNamed: "goal")
    
    override func didMove(to view: SKView) {
//        addChild(firstSpriteNode)
//        firstSpriteNode.position = CGPoint(x: frame.midX, y: frame.midY)
//        firstSpriteNode.anchorPoint = CGPoint.zero
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        background.zPosition = -1
        
        background.addChild(ballNode)
        ballNode.zPosition = 1
        ballNode.size = CGSize(width: 150.0, height: 150.0)
        //priradenie fyzickeho tela pre loptu
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: ballNode.size.width/2)
//        textureNode.physicsBody!.allowsRotation = false
        //restitution reprezentuje kolko energie sa uvolni pri kolizii max je 1.0
        ballNode.physicsBody!.restitution = 1.0
        
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
        
//        firstSpriteNode.addChild(ballNode)
        //z urcuje poradie vo vykreslovani
//        ballNode.zPosition = 1
//        firstSpriteNode.addChild(secondSpriteNode)
//        secondSpriteNode.zPosition = 2
//        secondSpriteNode.position = CGPoint(x: firstSpriteNode.size.width/2, y: firstSpriteNode.size.height/2)
        
        //Fyzika pre loptu
        //gravitacia po xovej a yovej osi. na zemi je skoro -10
//        physicsWorld.gravity = CGVector(dx: -1.0, dy: -2.0)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        //oramovanie displeja ako hranice
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        
        shootBall()
        
        //nastavenie fyziky pre modry stvorec
//        secondSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: secondSpriteNode.size)
    }
    
    func nastavRychlost(kazdychSekund: Double) {
        if timerBalls.isValid {
            timerBalls = Timer.scheduledTimer(timeInterval: kazdychSekund, target: self, selector: Selector("shootBall"), userInfo: nil, repeats: true)
        }else{
            timerBalls.invalidate()
            timerBalls = Timer.scheduledTimer(timeInterval: kazdychSekund, target: self, selector: Selector("shootBall"), userInfo: nil, repeats: true)
        }
    }
    
    func shootBall() {
        ballNode.physicsBody!.applyImpulse(CGVector(dx: 40.0, dy: -500.0))
        ballNode.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/3)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //pouzitie akcie aby sa presunul node
        //len presunnutie
//        textureNode.run(SKAction.move(to: CGPoint(x: firstSpriteNode.size.width, y: firstSpriteNode.size.height), duration: 2.0))
        
        //presunutie a ked je kompletnne tak vrati spat
//        textureNode.run(SKAction.move(to: CGPoint(x: firstSpriteNode.size.width, y: firstSpriteNode.size.height), duration: 2.0)) {
//            self.textureNode.position = CGPoint.zero
//        }
        for touch in touches {
            let location = touch.location(in: self)
            if ballNode.contains(location) && location.y <= 0 {
                print("hit")
                var posunX = (ballNode.frame.midX - location.x)*15
                var posunY = (ballNode.frame.midY - location.y)*15
                print(" posX: \(posunX) posY: \(posunY)")
                print(ballNode.physicsBody!.velocity)
                let rychlost = abs(ballNode.physicsBody!.velocity.dx) + abs(ballNode.physicsBody!.velocity.dy)
                print(rychlost)
                

                
                if (ballNode.frame.midX - location.x) > 0 {
                    posunX = (ballNode.frame.midX - location.x) + abs(ballNode.frame.midX - location.x) / (abs(ballNode.frame.midX - location.x) + abs(ballNode.frame.midY - location.y)) * rychlost
                }else{
                    posunX = (ballNode.frame.midX - location.x) - abs(ballNode.frame.midX - location.x) / (abs(ballNode.frame.midX - location.x) + abs(ballNode.frame.midY - location.y)) * rychlost
                }
                if (ballNode.frame.midY - location.y) > 0 {
                    posunY = (ballNode.frame.midY - location.y) + abs(ballNode.frame.midY - location.y) / (abs(ballNode.frame.midX - location.x) + abs(ballNode.frame.midY - location.y)) * rychlost
                }else{
                    posunY = (ballNode.frame.midY - location.y) - abs(ballNode.frame.midY - location.y) / (abs(ballNode.frame.midX - location.x) + abs(ballNode.frame.midY - location.y)) * rychlost
                }
                posunX = posunX + posunX * 2 / 3
                posunY = posunY + posunY * 2 / 3
                print(" posX2: \(posunX) posY2: \(posunY)")
                
                ballNode.physicsBody!.applyImpulse(CGVector(dx: posunX, dy: posunY))

                
//                if location.y > textureNode.frame.midY {
//                    posunY = (location.y - textureNode.frame.midY)*8
//                }
            }else{
//                print(ballNode.physicsBody!.velocity)
//                let posunX = -(ballNode.physicsBody!.velocity.dx)*3
//                let posunY = -(ballNode.physicsBody!.velocity.dy)*3
//                ballNode.physicsBody!.applyImpulse(CGVector(dx: posunX, dy: posunY))
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
        
    }
}
