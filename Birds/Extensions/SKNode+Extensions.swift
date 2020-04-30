//
//  SKNode+Extensions.swift
//  Birds
//
//  Created by yaron mordechai on 14/04/2020.
//  Copyright © 2020 yaron mordechai. All rights reserved.
//

import SpriteKit


extension SKNode{
    
    func aspectScale(to size:CGSize,width:Bool,multiplier:CGFloat){
        let scale = width ? (size.width * multiplier) / self.frame.size.width : (size.height * multiplier) / self.frame.size.height
        
        self.setScale(scale)    }
    
}
