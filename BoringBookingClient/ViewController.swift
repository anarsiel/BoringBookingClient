//
//  ViewController.swift
//  BoringBookingClient
//
//  Created by Blagoi on 25.11.2021.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    var tableView: UITableView!
    
    var data: [Restaurant] = [Restaurant(), Restaurant()] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        setData { [weak self] (data) in
            self?.data = data
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0) ,
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0) ,
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
    }
    
    func setData(completion:@escaping ([Restaurant]) -> ()) {
        let url = URL(string: "https://boring-booking.herokuapp.com/restaurants")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let _ = data else { return }
            let decoder = JSONDecoder()
            
//            print(String(data: data!, encoding: .utf8))
            
            if let jsonRestaurants = try? decoder.decode([Restaurant].self, from: data!) {
                DispatchQueue.main.async {
                    completion(jsonRestaurants)
                }
            }
//            completion([String(data: data, encoding: .utf8)!])
        }

        task.resume()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
        
        let x = "\(data[indexPath.row].name)"
        print(x)
        cell.title.text = data[indexPath.row].name
        return cell
    }
}

extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        data.append(data[indexPath.row])
//        print(indexPath.row)
////        print(indexPath.row)
////        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        return indexPath
//    }
}

class MyCell: UITableViewCell {
    
    var title: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError ("init(coder:) has not been implemented")
    }

}

struct Restaurant: Codable {
    var id: String
    var name: String
    
    init() {
        id = "A"
        name = "B"
    }
}

struct Restaurants: Codable {
    var results: [Restaurant]
}
