//
//  Block.swift
//  Birds
//
//  Created by yaron mordechai on 07/04/2020.
//  Copyright © 2020 yaron mordechai. All rights reserved.
//

import SpriteKit

enum BlockType:String {
    case wood, stone, glass
}

class Block: SKSpriteNode {
    
    
    let type:BlockType
    var health:Int
    let damageTreshold:Int
    
    init(type:BlockType){
        self.type = type
        switch type {
            
        case .wood:
            health = 200
            
        case .stone:
            health = 500
        
        case .glass:
            health = 50
            
        }
        damageTreshold = health / 2
        let texture = SKTexture(imageNamed: type.rawValue)

        super.init(texture: texture, color: .clear, size: .zero)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createPhysicsBody(){
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.block
        physicsBody?.contactTestBitMask = PhysicsCategory.all
        physicsBody?.collisionBitMask = PhysicsCategory.all
    }
    
    func impact(with force:Int){
        
        
            
        self.health -= force
            print(self.type,",",self.health)
        
            if self.health < 1{
                self.removeFromParent()
                
        }
            else if self.health < self.damageTreshold{
                let brokenTexture = SKTexture(imageNamed: type.rawValue + "Broken")
                texture = brokenTexture
        }
        
    }
    

}
