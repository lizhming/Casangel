//
//  ProductDetails.swift
//  CasAngel
//
//  Created by Admin on 29/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import ObjectMapper

class ProductDetails: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _slug <- map["slug"]
        _permalink <- map["permalink"]
        _date_created <- map["date_created"]
        _date_created_gmt <- map["date_created_gmt"]
        _date_modified <- map["date_modified"]
        _date_modified_gmt <- map["date_modified_gmt"]
        print(self)
        _image <- map["image"]
        _product_image <- map["product_image"]
        _status <- map["status"]
        //_featured <- map["featured"]
        //_type <- map["type"]
        _catalog_visibility <- map["catalog_visibility"]
        _description <- map["description"]
        _short_description <- map["short_description"]
        _sku <- map["sku"]
        _price <- map["price"]
        _regular_price <- map["regular_price"]
        _sale_price <- map["sale_price"]
        _date_on_sale_from <- map["date_on_sale_from"]
        _date_on_sale_from_gmt <- map["date_on_sale_from_gmt"]
        _date_on_sale_to <- map["date_on_sale_to"]
        _date_on_sale_to_gmt <- map["date_on_sale_to_gmt"]
        _price_html <- map["price_html"]
        _on_sale <- map["on_sale"]
        _purchasable <- map["purchasable"]
        _total_sales <- map["total_sales"]
        _virtual <- map["virtual"]
        _downloadable <- map["downloadable"]
        _downloads <- map["downloads"]
        _download_limit <- map["download_limit"]
        _download_expiry <- map["download_expiry"]
        _external_url <- map["external_url"]
        _button_text <- map["button_text"]
        _tax_status <- map["tax_status"]
        _tax_class <- map["tax_class"]
        _manage_stock <- map["manage_stock"]
        _stock_quantity <- map["stock_quantity"]
        _in_stock <- map["in_stock"]
        _backorders <- map["backorders"]
        _backorders_allowed <- map["backorders_allowed"]
        _backordered <- map["backordered"]
        _sold_individually <- map["sold_individually"]
        _weight <- map["weight"]
        _dimensions <- map["dimensions"]
        _shipping_required <- map["shipping_required"]
        _shipping_taxable <- map["shipping_taxable"]
        _shipping_class <- map["shipping_class"]
        _shipping_class_id <- map["shipping_class_id"]
        _reviews_allowed <- map["reviews_allowed"]
        _rating_count <- map["rating_count"]
        _related_ids <- map["related_ids"]
        _upsell_ids <- map["upsell_ids"]
        _cross_sell_ids <- map["cross_sell_ids"]
        _parent_id <- map["parent_id"]
        _purchase_note <- map["purchase_note"]
        _categories <- map["categories"]
        _tags <- map["tags"]
        _images <- map["images"]
        _attributes <- map["attributes"]
        _default_attributes <- map["default_attributes"]
        _variations <- map["variations"]
        _grouped_products <- map["grouped_products"]
        _menu_order <- map["menu_order"]
        __links <- map["_links"]
        _isLiked <- map["isLiked"]
        _attributes_price <- map["attributes_price"]
        _final_price <- map["final_price"]
        _total_price <- map["total_price"]
        _customers_basket_quantity <- map["customers_basket_quantity"]
        _category_ids <- map["category_ids"]
        _category_names <- map["category_names"]
        _store <- map["store"]
        _selected_variation <- map["selected_variation"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _slug: String?
    
    var _permalink: String?
    
    var _date_created: String?
    
    var _date_created_gmt: String?
    
    var _date_modified: String?
    
    var _date_modified_gmt: String?
    
    var _type: String?
    
    var _status: String?
    
    var _featured: Bool?
    
    var _catalog_visibility: String?
    
    var _description: String?
    
    var _short_description: String?
    
    var _sku: String?
    
    var _price: String?
    
    var _regular_price: String?
    
    var _sale_price: String?
    
    var _date_on_sale_from: String?
    
    var _date_on_sale_from_gmt: String?
    
    var _date_on_sale_to: String?
    
    var _date_on_sale_to_gmt: String?
    
    var _price_html: String?
    
    var _on_sale: String?
    
    var _purchasable: Bool?
    
    var _total_sales: Int?
    
    var _virtual: Bool?
    
    var _downloadable: Bool?
    
    var _downloads: [ProductDownloads]?
    
    var _download_limit: Int?
    
    var _download_expiry: Int?
    
    var _external_url: String?
    
    var _button_text: String?
    
    var _tax_status: String?
    
    var _tax_class: String?
    
    var _manage_stock: Bool?
    
    var _stock_quantity: String?
    
    var _in_stock: Bool?
    
    var _backorders: String?
    
    var _backorders_allowed: Bool?
    
    var _backordered: Bool?
    
    var _sold_individually: Bool?
    
    var _weight: String?
    
    var _dimensions: ProductDimensions?
    
    var _shipping_required: Bool?
    
    var _shipping_taxable: Bool?
    
    var _shipping_class: String?
    
    var _shipping_class_id: Int?
    
    var _reviews_allowed: Bool?
    
    var _average_rating: String?
    
    var _rating_count: Int?
    
    var _related_ids: [Int]?
    
    var _upsell_ids: [Int]?
    
    var _cross_sell_ids: [Int]?
    
    var _parent_id: Int?
    
    var _purchase_note: String?
    
    var _categories: [ProductCategories]?
    
    var _tags: [ProductTags]?

    var _images: [ProductImages]?
    
    var _attributes: [ProductAttributes]?
    
    var _default_attributes: [ProductDefaultAttributes]?
    
    var _variations: [Int]?
    
    var _grouped_products: [Int]?
    
    var _menu_order: Int?
    
    var __links: Links?
    
    var _isLiked: String?
    
    var _attributes_price: String?
    
    var _final_price: String?
    
    var _total_price: String?
    
    var _customers_basket_quantity: Int?
    
    var _category_ids: String?
    
    var _category_names: String?
    
    var _product_image: String?
    
    var _store: Store?
    
    var _image: ProductImages?
    
    var _selected_variation: Int?
}

class ProductDownloads: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _file <- map["file"]
    }
    
    var _id: String?
    
    var _name: String?
    
    var _file: String?
}

class ProductAttributes: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _position <- map["position"]
        _visible <- map["visible"]
        _variation <- map["variation"]
        _option <- map["option"]
        _options <- map["options"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _position: Int?
    
    var _visible: Bool?
    
    var _variation: Bool?
    
    var _option: String?
    
    var _options: [String]?
}

class Store: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _shop_name <- map["shop_name"]
        _url <- map["url"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _shop_name: String?
    
    var _url: String?
}

class ProductDimensions: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _length <- map["length"]
        _width <- map["width"]
        _height <- map["height"]
    }
    
    var _length: String?
    var _width: String?
    var _height: String?
}

class ProductImages: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _date_created <- map["date_created"]
        _date_created_gmt <- map["date_created_gmt"]
        _date_modified <- map["date_modified"]
        _date_modified_gmt <- map["date_modified_gmt"]
        _src <- map["src"]
        _name <- map["name"]
        _alt <- map["alt"]
        _position <- map["position"]
    }
    
    var _id: Int?
    
    var _date_created: String?
    
    var _date_created_gmt: String?
    
    var _date_modified: String?
    
    var _date_modified_gmt: String?
    
    var _src: String?
    
    var _name: String?
    
    var _alt: String?
    
    var _position: Int?
}

class ProductCategories: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _slug <- map["slug"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _slug: String?
}

class ProductDefaultAttributes: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _option <- map["option"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _option: String?
}

class ProductTags: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        _name <- map["name"]
        _slug <- map["slug"]
    }
    
    var _id: Int?
    
    var _name: String?
    
    var _slug: String?
}

