//
//  HomeViewController.swift
//  CloudStudy
//
//  Created by pro on 2016/10/20.
//  Copyright © 2016年 daisy. All rights reserved.
//

import UIKit
import MJRefresh
import EZSwiftExtensions

class HomeViewController: UIViewController,UIScrollViewDelegate {
    
    var navigationBar : HomeSearchBar!
    var topContainer  : HomeTopContainer!
    var tableView     : UITableView!
    var header        : MJRefreshNormalHeader!
    var footer        : MJRefreshAutoNormalFooter!
    var dataSource    : HomeDataModelObject!
    let homeRequestManger = HomeDataRequestObject.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        addAction()
        addRefrsh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = true
        
        dataSource = HomeDataModelObject()
        
        /** main scrollview */
        tableView = UITableView(frame:UIEdgeInsetsInsetRect(view.frame, UIEdgeInsetsMake(-20, 0, 0, 0)))
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        topContainer  = HomeTopContainer(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 200))
        tableView.tableHeaderView = topContainer
        tableView.tableFooterView = nil
        tableView.isScrollEnabled = true
        tableView.backgroundView  = nil
        tableView.delegate        = dataSource
        tableView.dataSource      = dataSource
        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor.clear
        view.addSubview(tableView)
        
        /** Search Bar */
        let searchBar = HomeSearchBar()
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        navigationBar = searchBar
    }
    
    //MARK: - Actions -
    func addAction() {
        weak var weakSelf = self
        navigationBar.searchBtnAction  = { (sender:UIButton) in
            print(sender)
        }
        navigationBar.messageBtnAction = { (sender:UIButton) in
            print(sender)
        }
        navigationBar.qrCodeBtnAction  = { (sender:UIButton) in
            print(sender)
        }
        
        homeRequestManger.reloadBannerClosure = { (bannerArr) in
            weakSelf?.endRefresh()
            weakSelf?.topContainer.reloadBanner(bannerArr: bannerArr)
        }
        
        dataSource.updateSearchBarStatus = { (offSetY) in
            weakSelf?.updateSearchBarStatusWith(offY: offSetY + 20) //加上状态栏高度 20
        }
    }
    
    //MARK: - Refresh -
    func addRefrsh() {
        header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.homeRequestManger.sendHomeLayoutRequest()
        })
        tableView.mj_header = header
        
        footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.footer.endRefreshing()
            }
        })
        tableView.mj_footer = footer
        
        header.beginRefreshing()
    }
    
    func updateSearchBarStatusWith(offY:CGFloat) {
        
        if offY  < 0 {
            navigationBar.isHidden = true
        } else if offY <= topContainer.height {
            navigationBar.isHidden = false
            navigationBar.updateNavigationBarStatus(alpha:offY/topContainer.height)
        } else {
            navigationBar.isHidden = false
        }
    }
    
    func endRefresh() {
        if header != nil {
            if header.isRefreshing() {
                header.endRefreshing()
            }
        }
        if footer != nil {
            if footer.isRefreshing() {
                footer.endRefreshing()
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        header = nil
        footer = nil
    }
}
