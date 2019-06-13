//
//  ViewController.swift
//  NBAStatsApp
//
//  Created by Tiago Pestana on 10/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController
{
    
    @IBOutlet weak var tableTeams: UITableView!
    
    let API_KEY = "c0c4fb5811mshd575afce09783fep109758jsna6fb51f722aa"
    
    let API_ENDPOIT = "https://api-nba-v1.p.rapidapi.com/"
    let STANDINGS_ENDPOINT = "standings/standard/2018/"
    let TEAM_ID_ENDPOINT = "teams/teamId/"

    let headers: HTTPHeaders = ["X-RapidAPI-Key" : "c0c4fb5811mshd575afce09783fep109758jsna6fb51f722aa"]
    
    var standings: StandingsDataModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        fetchStandings()
            {
                for i in 0...self.standings!.teams.count - 1
                {
                    self.fetchTeamInfo(index: i, onComplete:
                        { team in
                            print("ID: \(team.teamId!), Team: \(team.fullName!)")
                        })
                    
                }
            }
    }
    
    func fetchStandings(onComplete: @escaping () -> () )
    {
        Alamofire.request(API_ENDPOIT + STANDINGS_ENDPOINT, method: .get, headers: headers).responseJSON
            { (response) in
                if response.result.isSuccess
                {
                    print("succeeded")
                    let standingsJSON: JSON = JSON(response.result.value!)
                    self.standings = StandingsDataModel(json: standingsJSON)
                    onComplete()
                }
                else
                {
                    print("failed")
                }
        }
    }
    
    func fetchTeamInfo(index: Int, onComplete: @escaping (TeamDataModel) -> ())
    {
        let team  = standings!.teams[index]
        let url = API_ENDPOIT + TEAM_ID_ENDPOINT + team.teamId!
        Alamofire.request(url, method: .get, headers: headers).responseJSON(completionHandler:
            { (response) in
                if response.result.isSuccess
                {
                    let teamJSON = JSON(response.result.value!)
                    team.fillInfo(json: teamJSON, teamId: Int(team.teamId!)!)
                    onComplete(team)
                }
                else
                {
                    print("failed")
                }
            })
    }
}

