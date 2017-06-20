//
//  GameScene.swift
//  PoissonDiskSamplingExample
//
//  Created by Peter  Barsby on 6/20/17.
//  Copyright © 2017 Peter Barsby. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    
    override func didMove(to view: SKView) {
        
        let ordered = generatePoisson(wh: frame.size, minDist: 30)
        
        for item in ordered {
            let gamePiece = SKSpriteNode(imageNamed: "Spaceship")
            gamePiece.setScale(0.0625)
            gamePiece.position = item
            addChild(gamePiece)
        }
        
     
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
