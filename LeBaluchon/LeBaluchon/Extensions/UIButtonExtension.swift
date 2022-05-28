//
//  UIButtonExtension.swift
//  LeBaluchon
//
//  Created by Ernesto Elias Aquino Cifuentes on 27/04/2022.
//

import Foundation
import UIKit

extension UIButton {
    /**
     This function rounds the button borders slightly.
     */
    func round() {
        layer.cornerRadius = 5
        clipsToBounds = true
    }
}
