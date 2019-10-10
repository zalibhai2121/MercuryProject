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
        if let mercuryCell = cell as? MercuryCell {
            mercuryCell.mercurycell.text = "\(mercucycell)"
            mercuryCell.mercurycell2.text = "\(mercucycell)"
            self.getImage(for: URL(string: mercucycell.url)!) { (url, image) in
                DispatchQueue.main.async {
                    mercuryCell.mercuryImage.image = image
                }
            }
            
        }
               return cell
    }
    
    func getImage(for url: URL, completion: @escaping ((URL, UIImage) -> Void)) {
    // download the image, and call the completion with the url and image.
    // the cell can then verify that the image being returned is the one
    // requested.
    // you may even keep a dictionary of results, and then call the completion
    // with an entry from that dictionary, if one exists, otherwise make the
    // network call and store its result in the dictionary as well as calling
    // the completion. This would allow the _second_ call for any image to not
    // perform a network operation!
    let session = URLSession(configuration: .ephemeral)
    let task = session.dataTask(with: url) { (data, response, error) in
       if let data = data {
           var image = UIImage(data: data)
           DispatchQueue.main.async {
            image = image
           }
        }
    }
    task.resume()
}

}
