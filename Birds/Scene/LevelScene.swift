//
//  LevelScene.swift
//  Birds
//
//  Created by yaron mordechai on 14/04/2020.
//  Copyright © 2020 yaron mordechai. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene {
    var sceneManageDelegate:SceneManagerDelegate?
    
    override func didMove(to view: SKView) {
        setupLevelSelection()
    }

    func setupLevelSelection(){
        
        let background = SKSpriteNode(imageNamed: "levelBackground")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.aspectScale(to: frame.size, width: true, multiplier: 1.0)
        background.zPosition = ZPosition.background
        addChild(background)
        
        var level = 1
        //uppper left
        let columStartingPoint = frame.midX / 2
        let rowStartingPoint = frame.midY + frame.midY / 2
        
        for row in 0..<3{
            for colum in  0..<3{
                let levelBoxButton = SpriteKitButton(defaultButtonImage: "woodButton", action: goToGameSceneFor, index: level)
                
                levelBoxButton.position = CGPoint(x: columStartingPoint + CGFloat(colum) * columStartingPoint, y: rowStartingPoint - CGFloat(row) * frame.midY/2)
                
                levelBoxButton.zPosition = ZPosition.hudBackground
                addChild(levelBoxButton)
                
                let levelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
                levelLabel.fontSize = 200.0
                levelLabel.verticalAlignmentMode = .center
                levelLabel.text = "\(level)"
                levelLabel.aspectScale(to: levelBoxButton.size, width: false, multiplier: 0.5)
                
                levelLabel.zPosition = ZPosition.hudLabel
                levelBoxButton.addChild(levelLabel)
                
                levelBoxButton.aspectScale(to: frame.size, width: false, multiplier: 0.2)
                level += 1
            }
            
        
        }
        
        
        
        
    }
    func goToGameSceneFor(level:Int){
        
        sceneManageDelegate?.presentGameSenceFor(level: level)
    }
}
