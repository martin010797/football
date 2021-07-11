//
//  GameScene.swift
//  football
//
//  Created by Martin Kostelej on 09/07/2021.
//

import SpriteKit

class GameScene: SKScene {
    
    let firstSpriteNode = SKSpriteNode(color: UIColor.red, size: CGSize(width: 200.0, height: 200.0))
//    let secondSpriteNode = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 100.0, height: 100.0))
    let ballNode = SKSpriteNode(imageNamed: "ball")
    
    override func didMove(to view: SKView) {
//        addChild(firstSpriteNode)
//        firstSpriteNode.position = CGPoint(x: frame.midX, y: frame.midY)
//        firstSpriteNode.anchorPoint = CGPoint.zero
        addChild(ballNode)
        ballNode.size = CGSize(width: 200.0, height: 200.0)
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
        //priradenie fyzickeho tela pre loptu
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: ballNode.size.width/2)
//        textureNode.physicsBody!.allowsRotation = false
        //restitution reprezentuje kolko energie sa uvolni pri kolizii max je 1.0
        ballNode.physicsBody!.restitution = 1.0
        
        //nastavenie fyziky pre modry stvorec
//        secondSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: secondSpriteNode.size)
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
            if ballNode.contains(location) {
                print("hit")
                let posunX = (ballNode.frame.midX - location.x)*15
                var posunY = (ballNode.frame.midY - location.y)*15
//                if location.y > textureNode.frame.midY {
//                    posunY = (location.y - textureNode.frame.midY)*8
//                }
//                textureNode.physicsBody!.applyImpulse(CGVector(dx: Double.random(in: -100.0 ..< 100.0), dy: Double.random(in: -100.0 ..< 100.0)))
                ballNode.physicsBody!.applyImpulse(CGVector(dx: posunX, dy: posunY))
            }else{
                print("miss")
                let posunX = -(ballNode.physicsBody!.velocity.dx)*3
                var posunY = -(ballNode.physicsBody!.velocity.dy)*3
                ballNode.physicsBody!.applyImpulse(CGVector(dx: posunX, dy: posunY))
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
