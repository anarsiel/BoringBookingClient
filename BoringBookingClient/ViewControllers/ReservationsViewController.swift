//
//  TablesViewController.swift
//  BoringBookingClient
//
//  Created by Blagoi on 02.12.2021.
//

import UIKit

class ReservationsViewController: UIViewController, UITableViewDelegate {
    
    var userId: String
    
    var tableView: UITableView!
    
    var data: [Reservation] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    init(userId: String) {
        self.userId = userId
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
    
    func setData(completion:@escaping ([Reservation]) -> ()) {
        let url = URL(string: "https://boring-booking.herokuapp.com/reservations/user/\(self.userId)")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let _ = data else { return }
            let decoder = JSONDecoder()
            
            if let jsonReservations = try? decoder.decode([Reservation].self, from: data!) {
                DispatchQueue.main.async {
                    completion(jsonReservations)
                }
            }
        }

        task.resume()
    }
}

extension ReservationsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
        
        let restaurantName = getRestaurantName(restaurantId: data[indexPath.row].restaurant.id)
        cell.title.text = restaurantName
        return cell
    }
}

func getRestaurantName(restaurantId: String) -> String {
    let url = URL(string: "https://boring-booking.herokuapp.com/restaurants/\(restaurantId)")!

    let (data, _, _) = URLSession.shared.synchronousDataTask(with: url)
    
    guard let _ = data else { return "Not Found" }
    let decoder = JSONDecoder()
                
    if let restaurant = try? decoder.decode(Restaurant.self, from: data!) {
        return restaurant.name!
    }
    return "Not Found"
}
