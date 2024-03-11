//
//  DetailViewController.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import UIKit

final class DetailViewController: UIViewController {


    let viewModel: DetailViewModel


    // MARK: - Init
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
