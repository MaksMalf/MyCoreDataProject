//
//  UITextField+Ext.swift
//  MyCoreDataProject
//
//  Created by Maksim Malofeev on 28/08/2022.
//

import UIKit

extension UITextField {
    func setIcon(_ image: String) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iconView.contentMode = .scaleAspectFit
        iconView.image = UIImage(systemName: image)
        iconView.tintColor = .label
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}
