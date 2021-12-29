//
//  UrlRequest.swift
//  BoringBookingClient
//
//  Created by Благой Димитров on 28.12.2021.
//

import Foundation
import UIKit

func createSecureUrlRequest(url: String, httpMethod: String = "GET", httpBody: Data? = nil, authToken: String? = nil, setContentTypeJSON: Bool = true) -> URLRequest {
    let host = "http://localhost:8080/"
    
    var request = URLRequest(url: URL(string: host + url)!, timeoutInterval: Double.infinity)
    request.httpMethod = httpMethod
    
    if (setContentTypeJSON) {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    authToken.map { authToken in
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    }
    
    httpBody.map { httpBody in
        request.httpBody = httpBody
    }
    
    return request
}

func createURL(url: String, httpMethod: String = "GET", httpBody: Data? = nil, authToken: String? = nil, setContentTypeJSON: Bool = true) -> URL {
    let host = "http://localhost:8080/"
    
    var request = URLRequest(url: URL(string: host + url)!, timeoutInterval: Double.infinity)
    request.httpMethod = httpMethod
    
    if (setContentTypeJSON) {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    authToken.map { authToken in
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    }
    
    httpBody.map { httpBody in
        request.httpBody = httpBody
    }
    
    return request.url!
}
