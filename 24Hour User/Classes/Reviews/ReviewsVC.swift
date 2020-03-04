//
//  ReviewsVC.swift
//  24Hour User
//
//  Created by mac on 04/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ReviewsVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tblView: UITableView!
    
    
    //MARK: VARIABLES
    
    
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ACTIONS
    @IBAction func actionBack(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: FUNCTIONS
    
}//Class End

extension ReviewsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}
