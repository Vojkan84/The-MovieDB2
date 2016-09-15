//
//  HeaderView.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/15/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class HeaderView:UITableViewHeaderFooterView{

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        
        self.contentView.backgroundColor = UIColor(white: 0.1, alpha: 0.95)
        
    }
}
