//
//  LevelData.swift
//  Birds
//
//  Created by yaron mordechai on 15/04/2020.
//  Copyright © 2020 yaron mordechai. All rights reserved.
//

import Foundation

struct LevelData {
    let birds: [String]
    
    init?(level:Int){
        
        guard let levelDicationary = Levels.levelsDictionary["Level_\(level)"]  as? [String:Any]else {
            return nil
        }
        guard let birds = levelDicationary["Birds"] as? [String] else{
            return nil
        }
        self.birds = birds
    }
}
