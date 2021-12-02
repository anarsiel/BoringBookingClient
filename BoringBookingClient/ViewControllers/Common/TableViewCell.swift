//
//  TableViewCell.swift
//  BoringBookingClient
//
//  Created by Blagoi on 02.12.2021.
//

import UIKit

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
