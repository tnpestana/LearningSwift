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
    var teamId: Int?
    var winPercentage: Double?
    var fullName: String?
    var shortName: String?
    var logoPath: String?
    var logo: UIImage?
    
    init(json: JSON)
    {
        teamId = json["teamId"].intValue
        winPercentage = json["winPercentage"].doubleValue
    }
    
    func fillInfo(json: JSON, teamId: Int)
    {
        fullName = json["api"]["teams"][0]["fullName"].stringValue
        shortName = json["api"]["teams"][0]["shortName"].stringValue
        logoPath = json["api"]["teams"][0]["logo"].stringValue
        let url = URL(string: self.logoPath!)
        if let data = try? Data(contentsOf: url!)
        {
            self.logo = UIImage(data: data)
        }
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
