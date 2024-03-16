//
//  UIView + ext.swift
//  People
//
//  Created by Roman Vakulenko on 11.03.2024.
//

import UIKit

extension UIView {
    class var ReuseId: String { //с прописной-заглавной, поскольку глобальная переменная
        "\(String(describing: self))Id"
    }
}
