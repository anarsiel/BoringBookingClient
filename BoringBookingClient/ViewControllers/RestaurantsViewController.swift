import UIKit

class RestaurantsViewController: UIViewController {
    
    var userLoginLabel: UILabel!
    var tableView: UITableView!
    
    var userId: String = "Not Found"
    var userLogin: String
    var pathToServer: String
    var token: String
    
    var data: [Restaurant] = [Restaurant(id: "fakeId", name: "Loading...")] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    init(userLogin: String, pathToServer: String, token: String) {
        self.userLogin = userLogin
        self.pathToServer = pathToServer
        self.token = token
        
        super.init(nibName: nil, bundle: nil)
        
        userId = getUserId(userLogin: userLogin)
        
        setTableView()
        
        setData { [weak self] (data) in
            self?.data = data
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLoginLabel = UILabel(frame: CGRect(x: 20, y: 60, width: 200, height: 35))
        userLoginLabel.text = "User: \(userLogin)"
        userLoginLabel.font = UIFont.systemFont(ofSize: CGFloat(30))
        
        let button = StyledButton(title: "My Reservations", frame: CGRect(x: 20, y: userLoginLabel.frame.maxY + 20, width: 200, height: 50))
        button.addTarget(self, action: #selector(didShowReservations), for: .touchUpInside)
        
        view.addSubview(userLoginLabel)
        view.addSubview(button)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0) ,
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20) ,
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.rowHeight = 80
    }
    
    func setTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setData(completion:@escaping ([Restaurant]) -> ()) {
        let urlRequest = createURLRequest(url: "restaurants/me", authToken: token)
        

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
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
    
    @objc func didShowReservations() {
        let reservationsViewController = ReservationsViewController(
            userId: self.userId,
            pathToServer: pathToServer,
            token: token
        )
        self.present(reservationsViewController, animated: true, completion: nil)
    }
    
    func getUserId(userLogin: String) -> String {
        let url = URL(string: "\(pathToServer)/users/byLogin/\(userLogin)")!
//        let url = createURL(url: "users/me/", authToken: token)

        let (data, _, _) = URLSession.shared.synchronousDataTask(with: url)
        
        guard let _ = data else { return "Not Found" }
        let decoder = JSONDecoder()
        
        print(String(data: data!, encoding: .utf8)!)
        
        if let user = try? decoder.decode(User.self, from: data!) {
            return user.id!
        }
        return "Not Found"
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
        
        let newViewController = TablesViewController(
            restaurantId: data[indexPath.row].id,
            pathToServer: pathToServer,
            token: token
        )
        show(newViewController, sender: self)
    }
}
