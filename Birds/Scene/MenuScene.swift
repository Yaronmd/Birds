//
//  menuScene.swift
//  Birds
//
//  Created by yaron mordechai on 14/04/2020.
//  Copyright © 2020 yaron mordechai. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {

    var sceneManageDelegate:SceneManagerDelegate?
    
    
    override func didMove(to view: SKView) {
        setupMenu()
        
        
    }
    func setupMenu(){
        
        
        let background = SKSpriteNode(imageNamed: "menuBackground")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.aspectScale(to: frame.size, width: true, multiplier: 1.0)
        background.zPosition = ZPosition.background
        addChild(background)
        
        let button = SpriteKitButton(defaultButtonImage: "playButton", action: goToLevelSence(_:), index: 0)
        button.position = CGPoint(x: frame.midX, y: frame.midY*0.8)
        button.aspectScale(to: frame.size, width: false, multiplier: 0.2)
        button.zPosition = ZPosition.hudLabel
        addChild(button)
        
   
    }
    func goToLevelSence(_:Int){
        sceneManageDelegate?.presentLevelSence()
    }
    
    
    
}
