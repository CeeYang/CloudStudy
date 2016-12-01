//
//  DocNewViewController.swift
//  CloudStudy
//
//  Created by pro on 2016/11/27.
//  Copyright © 2016年 daisy. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON

class DocNewViewController: UIViewController {

    //MARK: - Public Method
    public func updateTableViewData(with directoryModel:DirectoryModel) {
        ruleID = directoryModel.rule_id!
        header.beginRefreshing()
    }
    
    //MARK: - Private Method
    fileprivate var tableView  = UITableView()
    fileprivate var header     = MJRefreshNormalHeader()
    fileprivate var footer     = MJRefreshAutoNormalFooter()
    fileprivate var dataObject : BaseTableViewDataObject?
    fileprivate var docArray   : Array<DocFileModel> = []
    
    fileprivate var pageNumber : Int    = 1
    fileprivate var ruleID     : String = ""
    
    fileprivate var isHeaderRefresh = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = kAppBaseColor

        setupUI()
        addRefrsh()
    }
    
    fileprivate func setupUI()  {
        
        /** main scrollview */
        tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = nil
        tableView.isScrollEnabled = true
        tableView.backgroundView  = nil
        tableView.separatorStyle  = .none
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.rowHeight       = 120
        tableView.backgroundColor = UIColor.clear
        tableView.register(DocListTableViewCell.self, forCellReuseIdentifier: DocListCellReuseIdentifier)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(kScreenHeight - 64 - 44 + 2)
        }
    }
    
    //MARK: - Refresh -
    fileprivate func addRefrsh() {
        header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.isHeaderRefresh = true
            self?.sendDocNewListDataRequestWith(page:1)
            })
        tableView.mj_header = header
        
        footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.isHeaderRefresh = false
            self?.pageNumber     += 1
            self?.sendDocNewListDataRequestWith(page:(self?.pageNumber)!)
            })
        tableView.mj_footer = footer
        header.beginRefreshing()
    }
    
    fileprivate func sendDocNewListDataRequestWith(page:Int) {
        HUD.show(.label("loading..."))
        
        let parameters : NSMutableDictionary = [:]
        parameters["sid"]             = UserInfo.shared.sid
        parameters["rule_id"]         = ruleID
        parameters["pageSize"]        = kPageSize
        parameters["pageNumber"]      = page
        
        RequestManager.shared.requestCommonDataWith(url: DocNewestListURL, parameters: parameters) { [weak self](response) in
            HUD.hide()
            self?.header.endRefreshing()
            self?.footer.endRefreshing()
            switch response.result {
            case .success(let value):
                let json          = JSON(value)
                let listArr       = json["data"]["list"].arrayValue
                self?.parseDocListDataWith(listArr)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    fileprivate func parseDocListDataWith(_ listArr:Array<JSON>) {
        var tempDocModelArr:Array<DocFileModel> = []
        for dic in listArr {
            let model = DocFileModel()
            model.parseData(json: dic)
            model.Description = dic["description"].stringValue
            tempDocModelArr.append(model)
        }
        if isHeaderRefresh {
            docArray.removeAll()
        }
        docArray.append(contentsOf: tempDocModelArr)
        
        if docArray.count < 0 {
            //tableView.showDefaultView
        } else {
            //tableView.hidenDefaultView
        }
        
        tableView.reloadData()
    }
    
    deinit {
        print("\(self) deinit success")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension DocNewViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocListCellReuseIdentifier, for: indexPath) as! DocListTableViewCell
        cell.configCellWith(docArray[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printLog(indexPath)
    }
}
