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
    
    
    
    var standings: StandingsDataModel?
    let teamCellId = "teamCell"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        getUpdatedStandings
        {
            self.tableTeams.delegate = self
            self.tableTeams.dataSource = self
            self.tableTeams.reloadData()
        }
    }
    
    func getUpdatedStandings(onComplete: @escaping () -> ())
    {
        Networking().fetchStandings()
        { standings in
            self.standings = standings
            for i in (0...self.standings!.teams.count - 1)
            {
                Networking().fetchTeamInfo(standings: self.standings!, index: i, onComplete:
                { team in
                    print("ID: \(String(format: "%02d", team.teamId!)), Team: \(team.fullName!)")
                    self.standings?.teams[i] = team
                    
                    if i == self.standings!.teams.count - 1
                    {
                        self.standings?.teams.sort(by: { $0.winPercentage! > $1.winPercentage! })
                        self.tableTeams.delegate = self
                        self.tableTeams.dataSource = self
                        self.tableTeams.reloadData()
                    }
                })
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.standings!.teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: teamCellId) as! TeamCell
        cell.lbl.text = "\(String(format: "%02d", indexPath.row + 1)) - \(standings!.teams[indexPath.row].fullName!)"
        return cell
    }
}

class TeamCell: UITableViewCell
{
    @IBOutlet weak var lbl: UILabel!
}
