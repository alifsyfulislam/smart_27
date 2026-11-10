

Task and update your required docs accordingly


Menu
    # Menu item-batch when active menu item and item-batch both are active but it should only item-batch same Distributor and distributor store as well
    
    
    
    
    Brand
        -> First of all module eg /brand ,/item ,/item-batch, /distributor, /distributore-store and later module  there will be download button 

        -> if the module is like hierarchy it will download hierarchy based template else normal moode 

        -> /brand delete button will be invisible if node has no child or leaf=0 

    ITEM

        -> /item Item list page there i want filter Brand filter it comes from sm_item_hirarchy (brand_id - brand_name) 

        -> /item/create (cid , item_id) must be unique, Hierarchy Tagging dropdown keyup search 

        -> /item/edit/id Hierarchy Tagging value will be auto select dropdown  

        -> in edit from dropdown database record value auto select all in the form 

        eg: Status, Item Category, Unit Type, packsize,  Company > Brand > Type > Flavor.

        -> update all other module and load this into your skills 

        -> weight, Invoice Price, Price, VAT Amount, Total Amount, mrp here float value must accpeted and price+vat auto calculate
        total_amount

        -> item status if not active than actually that status will be reflcted if item has existance on batch it will be goes same status

    ITEM Batch 

        ->  /item-batch/create (cid , item_id, batch_id) must be unique

        -> here item_id will be select dropdown i can here input search here search option 
        -> /item Item list page there i want filter Brand filter it comes from sm_item_hirarchy (brand_id - brand_name) 
        value comes from sm_item( brand_name | item_id item_name ) all active only

        -> expiary_date default on the form 31st december 2100


        according above doc make and read my full project build required skills and implemnt all other module


        Add a new module Dashboard sidebar under Distributor Info 

        Outlet Info
            Outlet




        CREATE TABLE `sm_client` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_old_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_bn` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `short_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owner_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owner_name_bn` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_category_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_bn` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nid` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `passport` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trade_license_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vat_registration_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bin_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `drug_registration_num` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_grade` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `longitude` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_no1` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_no2` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dob` date NOT NULL DEFAULT '2026-01-01',
  `doj` date NOT NULL DEFAULT '2026-01-01',
  `starting_year` int DEFAULT '2026',
  `monthly_sales_capacity` int DEFAULT NULL,
  `monthly_sales` int DEFAULT NULL,
  `shop_owner_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `warehouse_capacity` int DEFAULT NULL,
  `shop_size` int DEFAULT NULL,
  `shop_front_size` int DEFAULT NULL,
  `image_path` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `district` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_posm` int DEFAULT '0',
  `client_rak` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  UNIQUE KEY `CID_CLIENT_ID` (`cid` DESC,`client_id` DESC),
  KEY `cid_area_id_depot_id` (`cid` DESC,`area_id` DESC,`depot_id` DESC),
  KEY `cid_area_id_status` (`cid` DESC,`area_id` DESC,`status` DESC),
  KEY `cid_mobile_no` (`cid` DESC,`contact_no1` DESC),
  KEY `CID_CLIENT_ID_STATUS` (`cid` DESC,`client_id` DESC,`status` DESC),
  KEY `CID_CLIENT_NAME_STATUS` (`cid` DESC,`name` DESC,`status` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;





  `category_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,

  Here sm_category_type 
  
  Outlet_Category OC001 KR0 ACTIVE

  customer_type itt will auto genarate from category_id|category_name


   `sub_category_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,


  Outlet_Sub_Category OSC001 KR0-1 ACTIVE


  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,

  come from sm_depot, sm_depot_store options