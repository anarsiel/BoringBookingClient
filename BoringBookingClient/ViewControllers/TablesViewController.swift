import UIKit

class TablesViewController: UIViewController, UITableViewDelegate {
    
    var pathToServer: String
    var restaurantId: String
    var token: String
    
    var tableView: UITableView!
    
    var data: [Table] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    init(restaurantId: String, pathToServer: String, token: String) {
        self.restaurantId = restaurantId
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
    
    func setData(completion:@escaping ([Table]) -> ()) {
        let urlRequest = createSecureUrlRequest(url: "/tables/me/filter/\(self.restaurantId)/false/false/false/false", authToken: token)

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let _ = data else { return }
            let decoder = JSONDecoder()
            
            if let jsonTables = try? decoder.decode([Table].self, from: data!) {
                DispatchQueue.main.async {
                    completion(jsonTables)
                }
            }
        }

        task.resume()
    }
}

extension TablesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
        
        cell.title.text = String(data[indexPath.row].number!)
        return cell
    }
}
