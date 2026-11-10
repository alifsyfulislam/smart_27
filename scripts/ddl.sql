-- ============================================================================
-- SSMS - Secondary Sales Management System  |  Database: smart_27
-- Connection: host localhost, user root, password NULL
-- Reviewed for MySQL 8 / MariaDB 10.4 compatibility.
-- Schema updates done as instructed by requirements ("check table desc
-- if update needed on type do it"):
--   * sm_item_hierarchy : added `status` (soft delete to INACTIVE)
--   * sm_item_batch     : added `status` (soft delete to INACTIVE)
--   * sm_depot_store    : added `status` (soft delete to INACTIVE)
--   * sm_category_type  : added `status` (soft delete to INACTIVE)
--   * new ACL tables    : sm_acl_user / sm_acl_role / sm_acl_permission
--                         sm_acl_user_role / sm_acl_user_permission /
--                         sm_acl_role_permission
--   * central change log: sm_audit_log (written automatically by the app)
--   * outlet master      : sm_client (Outlet module, exact columns from
--                          requirements, DESC index markers normalized like the
--                          other tables for MariaDB 10.4 compatibility)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `smart_27`.`sm_item_hierarchy` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `level_id` varchar(50) DEFAULT NULL,
  `level_name` varchar(200) DEFAULT NULL,
  `parent_level_id` varchar(50) DEFAULT NULL,
  `parent_level_name` varchar(200) DEFAULT NULL,
  `level0` varchar(50) DEFAULT NULL,
  `level0_name` varchar(200) DEFAULT NULL,
  `level1` varchar(50) DEFAULT NULL,
  `level1_name` varchar(200) DEFAULT NULL,
  `level2` varchar(50) DEFAULT NULL,
  `level2_name` varchar(200) DEFAULT NULL,
  `level3` varchar(50) DEFAULT NULL,
  `level3_name` varchar(200) DEFAULT NULL,
  `is_leaf` varchar(2) DEFAULT '1',
  `depth` int DEFAULT NULL,
  `image_path` varchar(200) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'ACTIVE',
  `field1` varchar(200) DEFAULT NULL,
  `field2` int DEFAULT '0',
  `note` varchar(200) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_level_id` (`cid`, `level_id`),
  KEY `cid_parent_level_id` (`cid`, `parent_level_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `smart_27`.`sm_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `detail_name` varchar(200) DEFAULT '-',
  `item_category` varchar(20) DEFAULT 'REGULAR',
  `status` varchar(20) DEFAULT 'ACTIVE',
  `item_id` varchar(50) DEFAULT NULL,
  `old_item_id` varchar(50) DEFAULT '-',
  `name` varchar(200) DEFAULT '-',
  `name_bn` varchar(200) DEFAULT '-',
  `short_name` varchar(200) DEFAULT '-',
  `des` varchar(200) DEFAULT '-',
  `image_path` varchar(200) DEFAULT '-',
  `pack_size` varchar(50) DEFAULT '-',
  `unit_type` varchar(20) DEFAULT 'PCS',
  `weight` double DEFAULT '0',
  `company_id` varchar(50) DEFAULT '-',
  `company_name` varchar(200) DEFAULT '-',
  `brand_id` varchar(50) DEFAULT '-',
  `brand_name` varchar(200) DEFAULT '-',
  `type_id` varchar(50) DEFAULT '-',
  `type_name` varchar(200) DEFAULT '-',
  `flavor_id` varchar(50) DEFAULT '-',
  `flavor_name` varchar(200) DEFAULT '-',
  `category_id` varchar(50) DEFAULT '-',
  `category_name` varchar(200) DEFAULT '-',
  `ctn_pcs_ratio` int DEFAULT '1',
  `item_carton` int DEFAULT '1',
  `item_chain` int DEFAULT '1',
  `sequence_no` int DEFAULT '1',
  `stock_cover_days` int DEFAULT '7',
  `dist_price` double DEFAULT '0',
  `invoice_price` double DEFAULT '0',
  `mrp` double DEFAULT '0',
  `price` double DEFAULT '0',
  `vat_amt` double DEFAULT '0',
  `total_amt` double DEFAULT '0',
  `intr_flag` int DEFAULT '1',
  `manufacturer` varchar(200) DEFAULT '-',
  `category_id_sp` varchar(200) DEFAULT '-',
  `sub_category_id` varchar(50) DEFAULT '-',
  `sub_category_name` varchar(200) DEFAULT '-',
  `field1` varchar(200) DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_item_id` (`cid`, `item_id`),
  KEY `cid_item_category` (`cid`, `item_category`),
  KEY `cid_item_id_status` (`cid`, `item_id`, `status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `smart_27`.`sm_item_batch` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `item_id` varchar(50) DEFAULT NULL,
  `name` varchar(200) DEFAULT '-',
  `batch_id` varchar(20) DEFAULT NULL,
  `expiary_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT 'ACTIVE',
  `field1` varchar(200) DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_item_id_batch_id` (`cid`, `item_id`, `batch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `smart_27`.`sm_depot` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `sup_depot_id` varchar(50) DEFAULT '-',
  `sup_depot_name` varchar(50) DEFAULT '-',
  `depot_id` varchar(50) DEFAULT NULL,
  `old_depot_id` varchar(50) DEFAULT '-',
  `name` varchar(200) DEFAULT '-',
  `name_bn` varchar(200) DEFAULT '-',
  `short_name` varchar(200) DEFAULT '-',
  `depot_category` varchar(50) DEFAULT 'DISTRIBUTOR',
  `email` varchar(100) DEFAULT '-',
  `contact` varchar(20) DEFAULT NULL,
  `contact_2` varchar(20) DEFAULT '0',
  `address` varchar(200) DEFAULT '-',
  `address_bn` varchar(200) DEFAULT '-',
  `wh_address` varchar(200) DEFAULT '-',
  `wh_address_bn` varchar(200) DEFAULT '-',
  `bin` varchar(50) DEFAULT '-',
  `owner_name` varchar(100) DEFAULT '-',
  `owner_name_bn` varchar(100) DEFAULT '-',
  `tin` varchar(50) DEFAULT '-',
  `town_id` varchar(50) DEFAULT '-',
  `town_name` varchar(50) DEFAULT '-',
  `latitude` varchar(20) DEFAULT '0.0',
  `longitude` varchar(20) DEFAULT '0.0',
  `requisition_sl` int DEFAULT '1000',
  `issue_sl` int DEFAULT '1000',
  `receive_sl` int DEFAULT '1000',
  `damage_sl` int DEFAULT '1000',
  `order_sl` int DEFAULT '0',
  `del_sl` int DEFAULT '1000',
  `return_sl` int DEFAULT '1000',
  `client_payment_sl` int DEFAULT '1000',
  `depot_payment_sl` int DEFAULT '1000',
  `stock_in_sl` int DEFAULT '1000',
  `dm_pass` varchar(50) DEFAULT '1234',
  `sequence_no` int DEFAULT '1',
  `status` varchar(20) DEFAULT 'ACTIVE',
  `field1` varchar(200) DEFAULT '-',
  `field2` int DEFAULT '0',
  `approval_flag` int DEFAULT '0' COMMENT '0 PSR, 1 DEPOT, 2 OPERATOR',
  `auto_del_cron_flag` int DEFAULT '0',
  `intr_flag` int DEFAULT '0',
  `sync_code` varchar(20) DEFAULT '1234',
  `sync_count` int DEFAULT '0',
  `note` varchar(200) DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_depot_id` (`cid`, `depot_id`),
  KEY `cid_depot_id_status` (`cid`, `depot_id`, `status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `smart_27`.`sm_depot_store` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `depot_id` varchar(50) DEFAULT NULL,
  `store_id` varchar(75) DEFAULT NULL,
  `store_name` varchar(100) DEFAULT NULL,
  `store_type` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'ACTIVE',
  `field1` varchar(200) DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_store` (`cid`, `depot_id`, `store_id`),
  KEY `cid_depot_id_store_id` (`cid`, `depot_id`, `store_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `smart_27`.`sm_category_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `type_name` varchar(50) DEFAULT NULL,
  `cat_type_id` varchar(50) DEFAULT NULL,
  `cat_type_name` varchar(200) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'ACTIVE',
  `field1` varchar(200) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_type_cid` (`cid`, `type_name`, `cat_type_id`),
  KEY `cid_typename` (`cid`, `type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `smart_27`.`sm_client` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT 'SMART',
  `client_id` varchar(100) DEFAULT NULL,
  `client_old_id` varchar(100) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `name_bn` varchar(200) DEFAULT NULL,
  `short_name` varchar(200) DEFAULT NULL,
  `owner_name` varchar(200) DEFAULT NULL,
  `owner_name_bn` varchar(200) DEFAULT NULL,
  `area_id` varchar(50) DEFAULT NULL,
  `area_name` varchar(100) DEFAULT NULL,
  `category_id` varchar(50) DEFAULT NULL,
  `category_name` varchar(100) DEFAULT NULL,
  `sub_category_id` varchar(50) DEFAULT NULL,
  `sub_category_name` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'ACTIVE',
  `address` varchar(200) DEFAULT NULL,
  `address_bn` varchar(200) DEFAULT NULL,
  `nid` varchar(200) DEFAULT NULL,
  `passport` varchar(200) DEFAULT NULL,
  `trade_license_no` varchar(100) DEFAULT NULL,
  `vat_registration_no` varchar(100) DEFAULT NULL,
  `bin_no` varchar(100) DEFAULT NULL,
  `drug_registration_num` varchar(100) DEFAULT NULL,
  `customer_grade` varchar(10) DEFAULT NULL,
  `location` varchar(200) DEFAULT NULL,
  `latitude` varchar(20) DEFAULT '0',
  `longitude` varchar(20) DEFAULT '0',
  `depot_id` varchar(50) DEFAULT NULL,
  `depot_name` varchar(200) DEFAULT NULL,
  `store_id` varchar(50) DEFAULT NULL,
  `store_name` varchar(200) DEFAULT NULL,
  `customer_type` varchar(100) DEFAULT NULL COMMENT 'auto: CATEGORY_ID|CATEGORY_NAME',
  `contact_no1` varchar(50) DEFAULT NULL,
  `contact_no2` varchar(50) DEFAULT NULL,
  `dob` date NOT NULL DEFAULT '2026-01-01',
  `doj` date NOT NULL DEFAULT '2026-01-01',
  `starting_year` int DEFAULT '2026',
  `monthly_sales_capacity` int DEFAULT NULL,
  `monthly_sales` int DEFAULT NULL,
  `shop_owner_status` varchar(20) DEFAULT '-',
  `warehouse_capacity` int DEFAULT NULL,
  `shop_size` int DEFAULT NULL,
  `shop_front_size` int DEFAULT NULL,
  `image_path` varchar(200) DEFAULT NULL,
  `field1` varchar(20) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  `district` varchar(50) DEFAULT NULL,
  `market_id` varchar(50) DEFAULT NULL,
  `market_name` varchar(200) DEFAULT NULL,
  `client_posm` int DEFAULT '0',
  `client_rak` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `CID_CLIENT_ID` (`cid`, `client_id`),
  KEY `cid_area_id_depot_id` (`cid`, `area_id`, `depot_id`),
  KEY `cid_area_id_status` (`cid`, `area_id`, `status`),
  KEY `cid_mobile_no` (`cid`, `contact_no1`),
  KEY `CID_CLIENT_ID_STATUS` (`cid`, `client_id`, `status`),
  KEY `CID_CLIENT_NAME_STATUS` (`cid`, `name`, `status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------
-- Access Control List
-- ------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `smart_27`.`sm_acl_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `user_id` varchar(50) NOT NULL,
  `name` varchar(100) DEFAULT '-',
  `email` varchar(100) DEFAULT '-',
  `password_hash` varchar(200) DEFAULT NULL,
  `is_super` int DEFAULT '0',
  `status` varchar(20) DEFAULT 'ACTIVE',
  `note` varchar(200) DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_user_id` (`cid`, `user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `smart_27`.`sm_acl_role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `role_id` varchar(50) NOT NULL,
  `role_name` varchar(100) DEFAULT '-',
  `status` varchar(20) DEFAULT 'ACTIVE',
  `note` varchar(200) DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_role_id` (`cid`, `role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `smart_27`.`sm_acl_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `perm_id` varchar(100) NOT NULL,
  `perm_name` varchar(200) DEFAULT '-',
  `module` varchar(50) DEFAULT '-',
  `status` varchar(20) DEFAULT 'ACTIVE',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_perm_id` (`cid`, `perm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `smart_27`.`sm_acl_user_role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `user_id` varchar(50) NOT NULL,
  `role_id` varchar(50) NOT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_uid_rid` (`cid`, `user_id`, `role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `smart_27`.`sm_acl_user_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `user_id` varchar(50) NOT NULL,
  `perm_id` varchar(100) NOT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_uid_pid` (`cid`, `user_id`, `perm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `smart_27`.`sm_acl_role_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `role_id` varchar(50) NOT NULL,
  `perm_id` varchar(100) NOT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_rid_pid` (`cid`, `role_id`, `perm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- ------------------------------------------------------------------
-- Central change log for every master-table change (app written only)
-- ------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `smart_27`.`sm_audit_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `table_name` varchar(64) DEFAULT '-',
  `record_key` varchar(100) DEFAULT '-',
  `action` varchar(20) DEFAULT '-',          -- CREATE / UPDATE / DELETE / RESTORE / LOGIN / LOGOUT
  `old_values` longtext DEFAULT NULL,        -- JSON snapshot before change
  `new_values` longtext DEFAULT NULL,        -- JSON snapshot after change
  `changed_by` varchar(50) DEFAULT '-',      -- acting user_id
  `user_ip` varchar(50) DEFAULT '-',
  `note` varchar(200) DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_table_key` (`cid`, `table_name`, `record_key`),
  KEY `cid_created_on` (`cid`, `created_on`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
