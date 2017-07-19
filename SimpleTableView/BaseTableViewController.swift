//
//  BaseTableViewController.swift
//  DoorDashThird
//
//  Created by apple on 13/7/2017.
//  Copyright © 2017 greatwall. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, UISearchBarDelegate {

    internal var searchBar = UISearchBar()
    
    private var leftNavigationButton: UIBarButtonItem!
    
    private var rightNavigationButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.subviews[0].subviews.flatMap { $0 as? UITextView }.first?.tintColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }

    private func setNavigationBar() {
        navigationItem.titleView = nil
        navigationItem.title = "Restaurant"
        
        leftNavigationButton = UIBarButtonItem(title: "Map", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))

        rightNavigationButton = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showSearchBar))
        
        navigationItem.leftBarButtonItem = leftNavigationButton
        navigationItem.rightBarButtonItem = rightNavigationButton
    }
    
    func back() {
        dismiss(animated: true, completion: nil)
    }
    
    func showSearchBar() {
        navigationItem.titleView = searchBar
        navigationItem.title = nil
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        
        searchBar.becomeFirstResponder()
        searchBar.placeholder = "enter an address"
        searchBar.showsCancelButton = true
        searchBar.delegate = self
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setNavigationBar()
    }
    
}
