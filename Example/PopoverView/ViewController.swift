//
//  ViewController.swift
//  PopoverView
//
//  Created by Vaibhav Jain on 07/20/2023.
//  Copyright (c) 2023 Vaibhav Jain. All rights reserved.
//

import UIKit
import PopoverView

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton){
        let popverView = iOSPopoverView.init(frame: CGRect.init(x: 0, y: 0, width: button.frame.size.width, height: 300), titles: [])
        popverView.listHeight = 300
        popverView.searchDefaulttText = ""
        popverView.selectedIndex = 2
        popverView.delegate = self
        popverView.resetTitles(titles: ["Vaibhav","Vaidik","Ashish","Apoorva","Deepika"])
        view.addSubview(popverView)
        popverView.showFromSourceView(source: button, baseView: self.view)
    }

}

extension ViewController: iOSPopoverViewDelegate {
    func popoverView(_ popver: PopoverView.iOSPopoverView, index: Int, selectedText: String, sourceIndex: Int) {
        
    }
    func popoverViewDismiss(index: Int) {
        
    }
}
