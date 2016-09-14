//
//  MovieLegendRow.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/14/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class MovieLegendRow:UITableViewCell{

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var caledarView:UIImageView!
    @IBOutlet weak var releaseDateTextField: UITextField!
    
    @IBOutlet weak var voteAverageImageView: UIImageView!
    @IBOutlet weak var voteAverageTextField: UITextField!
    @IBOutlet weak var overviewTextView: UITextView!
}
