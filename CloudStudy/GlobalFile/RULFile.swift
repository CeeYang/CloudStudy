//
//  RULFile.swift
//  ZhiXueYun
//
//  Created by pro on 16/4/25.
//  Copyright © 2016年 zhixueyun. All rights reserved.
//

import Foundation

let KiOSVersionURL = "http://demo.zhixueyun.com/app-new1/update-date.json"
let KiOSCONFIGURL  = "http://demo.zhixueyun.com/app-new1/ios-config.json"


//let BaseURLStr     = "http://demo.zhixueyun.com/mlds/"
let BaseURLStr     = "http://tc.zhixueyun.com/zxy-mobile-new/"

//MARK: - News
let NewsURL        = BaseURLStr + "news/newsList"

//MARK: - Course
let CourseNewDataURL  = BaseURLStr + "course/newestList"
let CourseHotDataURL  = BaseURLStr + "course/hotestList"
let CourseCategoryURL = BaseURLStr + "course/category"


//MARK: - Login && Register
let LoginURL       = BaseURLStr + "user/login"

//MARK: - DOC
let DocNewDataURL  = BaseURLStr + "doc/newestList"
let DocHotDataURL  = BaseURLStr + "doc/hotestList"
let DocCategoryURL = BaseURLStr + "doc/category"



//MARK: - My View
let MyCountDataURL = BaseURLStr + "user/personalInfo"


//MARK: - Message
let MessageDataURL   = BaseURLStr + "user/messageList"
let MessageDetailURL = BaseURLStr + "user/messageDetail"
        
