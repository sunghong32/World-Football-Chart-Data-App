//
//  ViewController.swift
//  MySports
//
//  Created by 민성홍 on 2021/03/01.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        crawl()
    }
}

var TeamInfoArray : [TeamInfo] = []

func crawl(){
    let url = URL(string: "https://www.premierleague.com/tables")
  
    guard let myURL = url else {   return    }
    
    do {
        let html = try String(contentsOf: myURL, encoding: .utf8)
        let doc: Document = try SwiftSoup.parse(html)
        let plInfo: [Element] = try doc.select("tbody.tableBodyContainer.isPL").select("td").array()
        
        for i in 0..<280 {
            if i % 14 == 0 {
                TeamInfoArray.append(TeamInfo())
            }
            if i % 14 == 2{
                TeamInfoArray[i/14].name = try plInfo[i].text()
            } else if i % 14 == 3 {
                TeamInfoArray[i/14].game = try plInfo[i].text()
            } else if i % 14 == 4 {
                TeamInfoArray[i/14].win = try plInfo[i].text()
            } else if i % 14 == 5 {
                TeamInfoArray[i/14].draw = try plInfo[i].text()
            } else if i % 14 == 6 {
                TeamInfoArray[i/14].lose = try plInfo[i].text()
            } else if i % 14 == 10 {
                TeamInfoArray[i/14].points = try plInfo[i].text()
            } else if i % 14 == 11 {
                TeamInfoArray[i/14].fiveresult = try plInfo[i].text()
            } else if i % 14 == 12 {
                TeamInfoArray[i/14].nextgame = try plInfo[i].text()
            }
        }
        
        print(TeamInfoArray[7])

    } catch Exception.Error(let type, let message) {
        print("Message: \(message)")
        print("type: \(type)")
    } catch {
        print("error")
    }
}


