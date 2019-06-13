//
//  TeamDataModel.swift
//  NBAStatsApp
//
//  Created by Tiago Pestana on 13/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import Foundation
import SwiftyJSON

class TeamDataModel
{
    var teamId: String?
    var fullName: String?
    var shortName: String?
    var logoPath: String?
    var standing: String?
    
    init(json: JSON)
    {
        teamId = json["teamId"].stringValue
    }
    
    func fillInfo(json: JSON, teamId: Int)
    {
        fullName = json["api"]["teams"][0]["fullName"].stringValue
        shortName = json["api"]["teams"][0]["shortName"].stringValue
        logoPath = json["api"]["teams"][0]["logo"].stringValue
    }
}

class StandingsDataModel
{
    var teams: [TeamDataModel] = []
    
    init(json: JSON)
    {
        let teamsJson = json["api"]["standings"].arrayValue
        
        for i in 0...teamsJson.count - 1
        {
            teams.append(TeamDataModel(json: teamsJson[i]))
            print("Pos \(30 - i): \(teams[i].teamId!)")
        }
    }
}
