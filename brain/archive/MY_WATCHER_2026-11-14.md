1. i want to add a menu group Fieldforce info under Item info
under the  sub section

National Structure (Master table with central log) Table_name : sm_top_level

National > Area > Zone > Terriotry

H0001 | HOS (level_id, level_name) depth 0
A0001 | DHAKA CENTRAL (level_id, level_name) depth 1
Z0001 | DC (level_id, level_name) depth 2
T0001 | DC GULSHAN (level_id, level_name) depth 3

no more depth here its last depth Terriotry,  here auto incremental code, similar like brand module

Field Structure (Master table with central log) Table_name : sm_level

Territory > Town > Route > Beat

its comes from National Structure  depth 3 in suggestion when i create Terriotry it will dropdwon sm_top_level depth 3 list
T0001 | DC GULSHAN (level_id, level_name) depth 0
TW0001 | GULSHAN (level_id, level_name) depth 1
R0000006 | BANANI_03 (level_id, level_name) depth 2
B0000033 | PURBACHAL (level_id, level_name) depth 1 


no more depth here its last depth Beat,  here auto incremental code, similar like brand module

(Master table with central log)
its similar like sm_item/sm_distributor table integration or manully create
cid, rep_id unique
Employee ( two type of user [rep,sup] rep is PSR, sup is supervisor) Table_name : sm_rep

eployee id auto genarated from desination name , auto incremental and never be edited
like Head of Sales -> HOS0001
like Sales Operation Manager -> SOM0001
like Area Sales Manager -> ASM0001
like Area Sales Executive -> ASE0001
like Customer Executive -> CE0001
like Pre Sales Executive -> PSR0001
like Delivery Man -> DM0001

(Master table with central log)
Supervisor Area (supervisor can be added on national or field any tier) sm_rep user type sup
table: sm_supervisor_level
(Master table with central log)
PSR Area (psr can add only route ) Table_name : sm_rep_area sm_rep user_type rep

here psr and route selectable option on form but when save it will inseted all Beat under route at the same time it will insert 
Table_name : sm_visit_plan
(Master table with central log)
PSR Visit Plan -> it will extended version of sm_rep_area where addinal information are added which Beat in which weekday visit by default
which area should go which day Sunday, Monday, Tuesday, Wednesday, Friday, Saturday order_col_day 

delivery_day will be the next day 

(Master table with central log)
Outlet Visit Plan exceptional outlet visit plan here table : sm_client_visit_plan

all table structure are given below


CREATE TABLE `sm_top_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
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
  `is_leaf` varchar(2) DEFAULT NULL,
  `depth` int DEFAULT NULL,
  `image_path` varchar(200) DEFAULT NULL,
  `field1` varchar(200) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `CID_LEVEL3` (`cid` DESC,`level3` DESC),
  KEY `CID_IS_LEAF` (`cid` DESC,`is_leaf` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;



CREATE TABLE `sm_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
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
  `is_leaf` varchar(2) DEFAULT NULL,
  `depth` int DEFAULT NULL,
  `depot_id` varchar(50) DEFAULT NULL,
  `depot_name` varchar(200) DEFAULT NULL,
  `level4` varchar(50) DEFAULT NULL,
  `level4_name` varchar(200) DEFAULT NULL,
  `level5` varchar(50) DEFAULT NULL,
  `level5_name` varchar(200) DEFAULT NULL,
  `level6` varchar(50) DEFAULT NULL,
  `level6_name` varchar(200) DEFAULT NULL,
  `level7` varchar(50) DEFAULT NULL,
  `level7_name` varchar(200) DEFAULT NULL,
  `level8` varchar(50) DEFAULT NULL,
  `level8_name` varchar(200) DEFAULT NULL,
  `area_id_list` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `territory_des` varchar(200) DEFAULT NULL,
  `special_territory_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `field1` varchar(200) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid_levelid_isleaf` (`cid` DESC,`level_id` DESC,`is_leaf` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;



CREATE TABLE `sm_rep` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_username` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_bn` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_bn` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_no` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alt_mobile_no` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `doj` date DEFAULT NULL,
  `nid` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tin` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_path` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_code_servey` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_count` int DEFAULT NULL,
  `first_sync_date` datetime DEFAULT NULL,
  `last_sync_date` datetime DEFAULT NULL,
  `monthly_sms_count` int DEFAULT NULL,
  `monthly_voucher_count` int DEFAULT NULL,
  `java` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `wap` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `android` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `designation_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `designation_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_req_time` datetime DEFAULT NULL,
  `sync_flag` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_data` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  UNIQUE KEY `CID_REP_ID` (`cid` DESC,`rep_id` DESC),
  KEY `CID_REP_ID_MOBILE` (`cid` DESC,`rep_id` DESC,`mobile_no` DESC),
  KEY `CID_REP_ID_PASSWORD_STATUS_SYNC_CODE_NOTE` (`cid` DESC,`rep_id` DESC,`password` DESC,`status` DESC,`sync_code` DESC,`note` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sm_supervisor_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sup_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sup_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_depth_no` int DEFAULT NULL,
  `field1` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `CID_LEVEL_ID_LEVEL_DEPTH_NO` (`sup_id` DESC,`level_id` DESC,`level_depth_no` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `sm_rep_area` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_category` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid_rep_id_area_id` (`cid` DESC,`rep_id` DESC,`area_id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE `sm_visit_plan` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_man_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_man_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_bn` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_col_day` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_day` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seq_no` int DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `visit_plan_api` (`cid` DESC,`rep_id` DESC,`order_col_day` DESC,`status` DESC),
  KEY `cid_rep_id_status` (`cid` DESC,`rep_id` DESC,`status` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE `sm_client_visit_plan` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) NOT NULL DEFAULT 'SMART',
  `area_id` varchar(50) DEFAULT NULL,
  `client_id` varchar(50) DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `route_plan` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `w1` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `w2` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `w3` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `w4` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `w5` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `sat` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `sun` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `mon` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `tue` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `wed` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `thu` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `fri` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `seq_no` int DEFAULT '0',
  `status` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'ACTIVE',
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid` (`cid` DESC,`area_id` DESC,`status` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
