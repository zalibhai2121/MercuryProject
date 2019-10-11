//
//  ViewController.swift
//  MercuryProject
//
//  Created by Zainab Alibhai on 10/10/19.
//  Copyright © 2019 Zainab Alibhai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    
    let urlString = "https://raw.githubusercontent.com/rmirabelli/mercuryserver/master/mercury.json"
          
    struct MercuryList: Codable {
        var mercury: [MercuryObject]
    }
    struct MercuryObject: Codable {
        var name: String
        var type: String
        var url: String
    }
        
    var objects: [MercuryObject] = []
          
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: request) {(data, response, error) in
                print(String(data:data!, encoding: .utf8)!)
                let list = try! JSONDecoder().decode(MercuryList.self, from: data!)
                        print(list.mercury.count)
                        for b in list.mercury{
                            print(b)
                    }
                self.objects = list.mercury
                DispatchQueue.main.async {
                    self.tableView.reloadData()
            }
        }
                task.resume()
                tableView.dataSource = self
            }
            
        }


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mercucycell = objects[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MercuryCell", for: indexPath)
        let name = mercucycell.name
        let type = mercucycell.type
        if let mercuryCell = cell as? MercuryCell {
            mercuryCell.mercurycell.text = name
            mercuryCell.mercurycell2.text = type
            mercuryCell.getImage(for: URL(string: mercucycell.url)!) { (url, image) in
                mercuryCell.mercuryImage.image = image
            }
            
            }
            return cell
        }
    

}
