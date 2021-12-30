//
//  OneTableViewController.swift
//  BoringBookingClient
//
//  Created by Благой Димитров on 29.12.2021.
//

import Foundation

import Foundation
import UIKit

class OneTableViewController: UIViewController {
    
    var pathToServer: String = "http://localhost:8080"
//    var pathToServer: String = "https://boring-booking.herokuapp.com"
    let restaurantId: String
    let tableId: String
    let token: String
        
    init(restarantId: String, tableId: String, token: String) {
        self.restaurantId = restarantId
        self.tableId = tableId
        self.token = token
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let button = StyledButton(title: "Create Reservation", frame: CGRect(x: 50, y: 50, width: 100, height: 50))
        button.addTarget(self, action: #selector(doReservation), for: .touchUpInside)
        
        view.addSubview(button)
    }
    
    @objc func doReservation(sender: UIButton!) throws {
        
//        let semaphore = DispatchSemaphore (value: 0)
//
//        let userId = getUserId()
//
//        let body =
//        """
//        {
//            "user" : {
//                "id": "\(userId)"
//            },
//            "restaurant": {
//                "id": "\(restaurantId)"
//            },
//            "table": {
//                "id": "\(tableId)"
//            },
//
//            "startTimestamp": "2021-12-20T12:30",
//            "endTimestamp": "2021-12-20T14:30",
//        }
//        """
//
//        let data = body.data(using: .utf8)!
//        let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as! [Dictionary<String,Any>]
//
//        let bodyData = try? JSONSerialization.data(
//            withJSONObject: jsonArray,
//            options: []
//        )
//
//        let request = createSecureUrlRequest(
//            url: "reservations/me/create/",
//            httpMethod: "POST",
//            httpBody: bodyData,
//            authToken: token
//        )
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let _ = data else {
//                semaphore.signal()
//                return
//            }
//            semaphore.signal()
//        }
//
//        task.resume()
//        semaphore.wait()
    }
    
    func getUserId() -> String {
        let url = createSecureUrlRequest(url: "users/me/", authToken: token)

        let (data, _, _) = URLSession.shared.synchronousDataTask(with: url)
        
        guard let _ = data else { return "Not Found" }
        let decoder = JSONDecoder()
        
        if let user = try? decoder.decode(Me.self, from: data!) {
            return user.id
        }
        return "Not Found"
    }
}
