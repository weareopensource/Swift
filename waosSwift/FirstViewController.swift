//
//  FirstViewController.swift
//  waosSwift
//
//  Created by pierre brisorgueil on 21/02/2019.
//  Copyright © 2019 WeAreOpenSource. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var viewTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewTitle.text = L10n.firstViewTitle
    }

}
