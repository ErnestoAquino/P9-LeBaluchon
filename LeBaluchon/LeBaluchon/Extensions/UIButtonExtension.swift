//
//  UIButtonExtension.swift
//  LeBaluchon
//
//  Created by Ernesto Elias Aquino Cifuentes on 27/04/2022.
//

import Foundation
import UIKit

extension UIButton {
    func round() {
        layer.cornerRadius = 5
        clipsToBounds = true
    }
}
