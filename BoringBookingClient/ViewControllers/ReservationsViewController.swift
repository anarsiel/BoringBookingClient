import UIKit

class ReservationsViewController: UIViewController, UITableViewDelegate {
    
    var userId: String
    
    var tableView: UITableView!
    
    var data: [Reservation] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var pathToServer: String
    var token: String
    
    init(userId: String, pathToServer: String, token: String) {
        self.userId = userId
        self.pathToServer = pathToServer
        self.token = token
        
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
        let urlReq = createSecureUrlRequest(
            url: "reservations/me/get/userId",
            httpMethod: "GET",
            authToken: token
        )

        let task = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
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
        
        let restaurantName = getRestaurantName(restaurantId: data[indexPath.row].restaurant!.id)
        cell.title.text = restaurantName
        return cell
    }
    
    func getRestaurantName(restaurantId: String) -> String {
        let url = createSecureUrlRequest(
            url: "restaurants/me/get/id/\(restaurantId)",
            httpMethod: "GET",
            authToken: token
        )

        let (data, _, _) = URLSession.shared.synchronousDataTask(with: url)
        
        guard let _ = data else { return "Not Found" }
        let decoder = JSONDecoder()
        
        print(String(data: data!, encoding: .utf8)!)
                    
        if let restaurant = try? decoder.decode(Restaurant.self, from: data!) {
            return restaurant.name!
        }
        return "Not Found"
    }

}
