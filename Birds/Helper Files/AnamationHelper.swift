//
//  AnamationHelper.swift
//  Birds
//
//  Created by yaron mordechai on 15/04/2020.
//  Copyright © 2020 yaron mordechai. All rights reserved.
//

import SpriteKit

class AnamationHelper {
    
    
    static func loadTexture(from atlas:SKTextureAtlas,withName name:String) ->[SKTexture]
    {
        
        var textures = [SKTexture]()
        
        
        for index in 0..<atlas.textureNames.count {
            let textureName = name + String(index+1)
            textures.append(atlas.textureNamed(textureName))
        }
        
        
        
        return textures
        
    }
    
}
