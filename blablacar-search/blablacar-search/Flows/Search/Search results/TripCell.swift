//
//  TripCell.swift
//  blablacar-search
//
//  Created by Benoît Durand on 18/11/2020.
//

import UIKit


class TripCell: UITableViewCell {
    private var userPicture = UIImageView(image: nil, contentMode: .scaleToFill)
    private var userName = UILabel(title: "", type: .medium, color: .secondary, size: 14, lines: 1, alignment: .left)
    private var departureDate = UILabel(title: "", type: .regular, color: .gray, size: 13, lines: 1, alignment: .left)
    private var departureLocation = UILabel(title: "", type: .regular, color: .gray, size: 13, lines: 1, alignment: .left)
    private var destinationLocation = UILabel(title: "", type: .regular, color: .gray, size: 13, lines: 1, alignment: .left)
    private var priceLabel = UILabel(title: "", type: .bold, color: .secondary, size: 15, lines: 1, alignment: .right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        let container = UIView(backgroundColor: .white)
        let arrow = UIImageView(image: UIImage(systemName: "arrow.down") ?? UIImage(), contentMode: .scaleAspectFit)
        
        contentView.addSubview(container)
        container.addSubviews([userPicture, priceLabel, userName, departureDate, departureLocation, arrow, destinationLocation])
        
        container.snp.makeConstraints { cm in
            cm.top.bottom.equalToSuperview().inset(8)
            cm.left.right.equalToSuperview().inset(16)
            cm.height.equalTo(120)
            
            container.cornerRadius = 12
            
            userPicture.snp.makeConstraints { cm in
                cm.left.top.equalToSuperview().inset(16)
                cm.size.equalTo(40)
            }
            userPicture.cornerRadius = 20
            userPicture.layer.borderWidth = 1.0
            userPicture.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
            
            userName.snp.makeConstraints { cm in
                cm.left.equalTo(userPicture.snp.right).offset(8)
                cm.right.equalToSuperview()
                cm.top.equalToSuperview().offset(20)
            }
            
            priceLabel.snp.makeConstraints { cm in
                cm.top.equalToSuperview().offset(20)
                cm.right.equalToSuperview().offset(-16)
            }
            
            departureDate.snp.makeConstraints { cm in
                cm.left.equalTo(userName)
                cm.right.equalToSuperview()
                cm.top.equalTo(userName.snp.bottom).offset(4)
            }
            
            departureLocation.snp.makeConstraints { cm in
                cm.left.equalTo(userName)
                cm.right.equalToSuperview()
                cm.top.equalTo(departureDate.snp.bottom).offset(4)
            }
            
            arrow.snp.makeConstraints { cm in
                cm.height.equalTo(16)
                cm.left.equalTo(userName)
                cm.top.equalTo(departureLocation.snp.bottom).offset(3)
            }
            
            destinationLocation.snp.makeConstraints { cm in
                cm.left.equalTo(userName)
                cm.right.equalToSuperview()
                cm.top.equalTo(arrow.snp.bottom).offset(4)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(_ content: TripCellDataRepresentable) {
        if let url = content.driverPicture {
            userPicture.load(url: url)
        }
        departureDate.text = content.startDate
        userName.text = content.driver
        priceLabel.text = content.price
        departureLocation.attributedText = content.start
        destinationLocation.attributedText = content.destination
    }
}
