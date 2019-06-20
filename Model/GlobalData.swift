//
//  GlobalData.swift
//  CasAngel
//
//  Created by Admin on 29/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class GlobalData {
    private static var _categories: [CategoryDetails]? = nil
    private static var _post_categories: [PostCategory]? = nil
    
    public static func getCategories() -> [CategoryDetails]?{
        return _categories
    }
    
    public static func setCategories(categories: [CategoryDetails]?) {
        self._categories = categories
    }
    
    public static func setPostCategories(categories: [PostCategory]?) {
        self._post_categories = categories
    }
    
    public static func getPostCategories() -> [PostCategory]?{
        return self._post_categories
    }
    
}
