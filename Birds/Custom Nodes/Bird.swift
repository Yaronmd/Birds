//
//  Bird.swift
//  Birds
//
//  Created by yaron mordechai on 06/04/2020.
//  Copyright © 2020 yaron mordechai. All rights reserved.
//

import SpriteKit
// Bird Type retuen string of the  name cases
enum BirdType: String{
    case red,blue,yellow,gray
    
}
//Bird - create SKSpriteNode object with color, size and texture
class Bird: SKSpriteNode {
    
    let birdType : BirdType
    
    var flying = false{
        didSet{
            if flying{
                physicsBody?.isDynamic = true
                animateFlight(active: true)
            }
            else{
                animateFlight(active: false)
            }
        }
    }
    
    let flyingFrames : [SKTexture]
    
    var grabbed = false
    
    init(type:BirdType){
        self.birdType = type
        flyingFrames = AnamationHelper.loadTexture(from: SKTextureAtlas(named: type.rawValue), withName: type.rawValue)
        
        let texture = SKTexture(imageNamed: type.rawValue + "1")
        
        super.init(texture:texture, color: UIColor.clear, size: texture.size())
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func animateFlight(active:Bool){
        
        if active{
            
            
            run(SKAction.repeatForever(SKAction.animate(with: flyingFrames, timePerFrame: 0.1, resize: true, restore: true)))
            
        }
        else{
            removeAllActions()
        }
    }
    
}

//extension Bird
