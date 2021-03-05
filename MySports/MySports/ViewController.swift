//
//  ViewController.swift
//  MySports
//
//  Created by 민성홍 on 2021/03/01.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewMain: UITableView!
    @IBOutlet weak var plLogo: UIImageView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewMain.dequeueReusableCell(withIdentifier: "PLTableCell", for: indexPath) as! Type1
        
        let plTeamArray = teamInfoArray[indexPath.row]
        cell.teamImage.image = UIImage(data: try! Data(contentsOf: URL(string: plTeamArray.logoURL!)!))
        
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 {
            cell.cupCompetition.backgroundColor = .systemGreen
        } else if indexPath.row == 4{
            cell.cupCompetition.backgroundColor = .systemBlue
        } else if indexPath.row == 17 || indexPath.row == 18 || indexPath.row == 19{
            cell.cupCompetition.backgroundColor = .systemRed
        } else {
            cell.cupCompetition.backgroundColor = .none
        }
        
        cell.rankLabel.text = "\(indexPath.row + 1)"
        cell.teamNameLabel.text = plTeamArray.name
        cell.gameLabel.text = plTeamArray.game
        cell.winLabel?.text = plTeamArray.win
        cell.drawLabel.text = plTeamArray.draw
        cell.loseLabel.text = plTeamArray.lose
        cell.pointsLabel.text = plTeamArray.points
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crawlPL()
        
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        
        plLogo.layer.cornerRadius = plLogo.frame.height/2
        plLogo.clipsToBounds = true
        
        self.tableViewMain.rowHeight = 75
        
    }
}

var teamInfoArray : [TeamInfo] = []
var plLogoArray : [String?] = []

func crawlPL(){
    let url = URL(string: "https://www.premierleague.com/tables")

    guard let myURL = url else { return }

    do {
        let html = try String(contentsOf: myURL, encoding: .utf8)
        let doc: Document = try SwiftSoup.parse(html)
        
        let plInfo: [Element] = try doc.select("tbody.tableBodyContainer.isPL").select("td").array()
        
        let plLogo: Elements = try doc.select(".team").select("img")
        
        plLogoArray = plLogo.array().map { try? $0.attr("src").description }
        
                
        for i in 0..<280 {
            if i % 14 == 0 {
                teamInfoArray.append(TeamInfo())
            }
            if i % 14 == 2{
                teamInfoArray[i/14].name = try plInfo[i].text()
            } else if i % 14 == 3 {
                teamInfoArray[i/14].game = try plInfo[i].text()
            } else if i % 14 == 4 {
                teamInfoArray[i/14].win = try plInfo[i].text()
            } else if i % 14 == 5 {
                teamInfoArray[i/14].draw = try plInfo[i].text()
            } else if i % 14 == 6 {
                teamInfoArray[i/14].lose = try plInfo[i].text()
            } else if i % 14 == 10 {
                teamInfoArray[i/14].points = try plInfo[i].text()
            } else if i % 14 == 11 {
                teamInfoArray[i/14].fiveresult = try plInfo[i].text()
            } else if i % 14 == 12 {
                teamInfoArray[i/14].nextgame = try plInfo[i].text()
            }
        }
        for i in 0...19 {
            teamInfoArray[i].logoURL = plLogoArray[i]
        }
        
    } catch Exception.Error(let type, let message) {
        print("Message: \(message)")
        print("type: \(type)")
    } catch {
        print("error")
    }
}
