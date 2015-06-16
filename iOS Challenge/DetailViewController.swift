//
//  DetailViewController.swift
//  iOS Challenge
//
//  Created by Daniel Griso Filho on 6/11/15.
//  Copyright (c) 2015 iOS Daniel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var webLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let title = self.titleLabel {
                if let author = self.authorLabel {
                    if let web = self.webLabel {
                        if let content = contentText {
                            if let date = self.dateLabel{
                                title.text = detail.valueForKey("title")!.description
                                author.text = detail.valueForKey("author")!.description
                                web.text = detail.valueForKey("website")!.description
                                content.text = detail.valueForKey("content")!.description
                                date.text = detail.valueForKey("date")!.description
                            }
                        }
                    }
                }
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

