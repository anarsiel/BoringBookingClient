//
//  ViewController.swift
//  BoringBookingClient
//
//  Created by Blagoi on 25.11.2021.
//

import UIKit

class RestaurantsViewController: UIViewController {
    
    var tableView: UITableView!
    
    var data: [Restaurant] = [Restaurant(id: "fakeId", name: "Loading...")] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
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
        tableView.rowHeight = 80
    }
    
    func setData(completion:@escaping ([Restaurant]) -> ()) {
        let url = URL(string: "https://boring-booking.herokuapp.com/restaurants")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let _ = data else { return }
            let decoder = JSONDecoder()
            
            if let jsonRestaurants = try? decoder.decode([Restaurant].self, from: data!) {
                DispatchQueue.main.async {
                    completion(jsonRestaurants)
                }
            }
        }

        task.resume()
    }
}

extension RestaurantsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
        
        cell.title.text = data[indexPath.row].name
        return cell
    }
}

extension RestaurantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newViewController = TablesViewController(restaurantId: data[indexPath.row].id)
        show(newViewController, sender: self)
    }
}
