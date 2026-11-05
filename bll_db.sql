/*
SQLyog Community v13.2.1 (64 bit)
MySQL - 8.0.31-google : Database - smart
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`smart` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `smart`;

/*Table structure for table `api_sm_sales_confirmation` */

DROP TABLE IF EXISTS `api_sm_sales_confirmation`;

CREATE TABLE `api_sm_sales_confirmation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `request_date` date DEFAULT NULL,
  `request_day` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=230261 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `auth_cas` */

DROP TABLE IF EXISTS `auth_cas`;

CREATE TABLE `auth_cas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `service` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ticket` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `renew` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id__idx` (`user_id`),
  CONSTRAINT `auth_cas_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `auth_event` */

DROP TABLE IF EXISTS `auth_event`;

CREATE TABLE `auth_event` (
  `id` int NOT NULL AUTO_INCREMENT,
  `time_stamp` datetime DEFAULT NULL,
  `client_ip` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `origin` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `user_id__idx` (`user_id`),
  CONSTRAINT `auth_event_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `auth_group` */

DROP TABLE IF EXISTS `auth_group`;

CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `auth_membership` */

DROP TABLE IF EXISTS `auth_membership`;

CREATE TABLE `auth_membership` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `group_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id__idx` (`user_id`),
  KEY `group_id__idx` (`group_id`),
  CONSTRAINT `auth_membership_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `auth_membership_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `auth_permission` */

DROP TABLE IF EXISTS `auth_permission`;

CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int DEFAULT NULL,
  `name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `table_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `record_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id__idx` (`group_id`),
  CONSTRAINT `auth_permission_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `auth_user` */

DROP TABLE IF EXISTS `auth_user`;

CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registration_key` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reset_password_key` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registration_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `backup_sm_level` */

DROP TABLE IF EXISTS `backup_sm_level`;

CREATE TABLE `backup_sm_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_level_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_level_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_leaf` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id_list` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `special_territory_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depth` int DEFAULT NULL,
  `level0` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level4` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level4_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level5` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level5_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level6` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level6_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level7` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level7_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level8` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level8_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `territory_des` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `backup_sm_rep` */

DROP TABLE IF EXISTS `backup_sm_rep`;

CREATE TABLE `backup_sm_rep` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_no` bigint DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_code_servey` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_count` int DEFAULT NULL,
  `first_sync_date` datetime DEFAULT NULL,
  `last_sync_date` datetime DEFAULT NULL,
  `monthly_sms_count` int DEFAULT NULL,
  `monthly_voucher_count` int DEFAULT NULL,
  `java` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `wap` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `android` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_req_time` datetime DEFAULT NULL,
  `sync_flag` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_data` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `backup_sm_rep_area` */

DROP TABLE IF EXISTS `backup_sm_rep_area`;

CREATE TABLE `backup_sm_rep_area` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `backup_sm_supervisor_level` */

DROP TABLE IF EXISTS `backup_sm_supervisor_level`;

CREATE TABLE `backup_sm_supervisor_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sup_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sup_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_depth_no` int DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `district` */

DROP TABLE IF EXISTS `district`;

CREATE TABLE `district` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `district_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=511 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `district_thana` */

DROP TABLE IF EXISTS `district_thana`;

CREATE TABLE `district_thana` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `thana_id` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `district_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `district_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=875 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `division` */

DROP TABLE IF EXISTS `division`;

CREATE TABLE `division` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `division_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `division_district` */

DROP TABLE IF EXISTS `division_district`;

CREATE TABLE `division_district` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `district_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `district_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `division_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `division_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `doc_catagory` */

DROP TABLE IF EXISTS `doc_catagory`;

CREATE TABLE `doc_catagory` (
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `category` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `doc_speciality` */

DROP TABLE IF EXISTS `doc_speciality`;

CREATE TABLE `doc_speciality` (
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `specialty` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '-',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `level_name_settings` */

DROP TABLE IF EXISTS `level_name_settings`;

CREATE TABLE `level_name_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depth` int DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `starting_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `lifting_plan` */

DROP TABLE IF EXISTS `lifting_plan`;

CREATE TABLE `lifting_plan` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `plan_date` date DEFAULT NULL,
  `distributor_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distributor_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `super_depot_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `super_depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mode` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `t_1` int NOT NULL DEFAULT '0',
  `a_1` int NOT NULL DEFAULT '0',
  `t_2` int NOT NULL DEFAULT '0',
  `a_2` int NOT NULL DEFAULT '0',
  `t_3` int NOT NULL DEFAULT '0',
  `a_3` int NOT NULL DEFAULT '0',
  `t_4` int NOT NULL DEFAULT '0',
  `a_4` int NOT NULL DEFAULT '0',
  `t_5` int NOT NULL DEFAULT '0',
  `a_5` int NOT NULL DEFAULT '0',
  `t_6` int NOT NULL DEFAULT '0',
  `a_6` int NOT NULL DEFAULT '0',
  `t_7` int NOT NULL DEFAULT '0',
  `a_7` int NOT NULL DEFAULT '0',
  `t_8` int NOT NULL DEFAULT '0',
  `a_8` int NOT NULL DEFAULT '0',
  `t_9` int NOT NULL DEFAULT '0',
  `a_9` int NOT NULL DEFAULT '0',
  `t_10` int NOT NULL DEFAULT '0',
  `a_10` int NOT NULL DEFAULT '0',
  `t_11` int NOT NULL DEFAULT '0',
  `a_11` int NOT NULL DEFAULT '0',
  `t_12` int NOT NULL DEFAULT '0',
  `a_12` int NOT NULL DEFAULT '0',
  `t_13` int NOT NULL DEFAULT '0',
  `a_13` int NOT NULL DEFAULT '0',
  `t_14` int NOT NULL DEFAULT '0',
  `a_14` int NOT NULL DEFAULT '0',
  `t_15` int NOT NULL DEFAULT '0',
  `a_15` int NOT NULL DEFAULT '0',
  `t_16` int NOT NULL DEFAULT '0',
  `a_16` int NOT NULL DEFAULT '0',
  `t_17` int NOT NULL DEFAULT '0',
  `a_17` int NOT NULL DEFAULT '0',
  `t_18` int NOT NULL DEFAULT '0',
  `a_18` int NOT NULL DEFAULT '0',
  `t_19` int NOT NULL DEFAULT '0',
  `a_19` int NOT NULL DEFAULT '0',
  `t_20` int NOT NULL DEFAULT '0',
  `a_20` int NOT NULL DEFAULT '0',
  `t_21` int NOT NULL DEFAULT '0',
  `a_21` int NOT NULL DEFAULT '0',
  `t_22` int NOT NULL DEFAULT '0',
  `a_22` int NOT NULL DEFAULT '0',
  `t_23` int NOT NULL DEFAULT '0',
  `a_23` int NOT NULL DEFAULT '0',
  `t_24` int NOT NULL DEFAULT '0',
  `a_24` int NOT NULL DEFAULT '0',
  `t_25` int NOT NULL DEFAULT '0',
  `a_25` int NOT NULL DEFAULT '0',
  `t_26` int NOT NULL DEFAULT '0',
  `a_26` int NOT NULL DEFAULT '0',
  `t_27` int NOT NULL DEFAULT '0',
  `a_27` int NOT NULL DEFAULT '0',
  `t_28` int NOT NULL DEFAULT '0',
  `a_28` int NOT NULL DEFAULT '0',
  `t_29` int NOT NULL DEFAULT '0',
  `a_29` int NOT NULL DEFAULT '0',
  `t_30` int NOT NULL DEFAULT '0',
  `a_30` int NOT NULL DEFAULT '0',
  `t_31` int NOT NULL DEFAULT '0',
  `a_31` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `medicine_list` */

DROP TABLE IF EXISTS `medicine_list`;

CREATE TABLE `medicine_list` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `brand` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `generic` varchar(70) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `strength` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `formation` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `b` (`brand`),
  KEY `n` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `rep_profile` */

DROP TABLE IF EXISTS `rep_profile`;

CREATE TABLE `rep_profile` (
  `cid` int NOT NULL,
  `distributor` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `supervisor` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `designation` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alt_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_bangla` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `short_name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `education` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_birth` date NOT NULL,
  `date_of_joining` date NOT NULL,
  `Permanent_add` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nid` int NOT NULL,
  `profile_image` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `photo_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sequence` int NOT NULL,
  `reference` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `scheduler_run` */

DROP TABLE IF EXISTS `scheduler_run`;

CREATE TABLE `scheduler_run` (
  `id` int NOT NULL AUTO_INCREMENT,
  `task_id` int DEFAULT NULL,
  `status` varchar(512) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `stop_time` datetime DEFAULT NULL,
  `run_output` longtext,
  `run_result` longtext,
  `traceback` longtext,
  `worker_name` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `task_id__idx` (`task_id`),
  CONSTRAINT `scheduler_run_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `scheduler_task` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `scheduler_task` */

DROP TABLE IF EXISTS `scheduler_task`;

CREATE TABLE `scheduler_task` (
  `id` int NOT NULL AUTO_INCREMENT,
  `application_name` varchar(512) DEFAULT NULL,
  `task_name` varchar(512) DEFAULT NULL,
  `group_name` varchar(512) DEFAULT NULL,
  `status` varchar(512) DEFAULT NULL,
  `broadcast` char(1) DEFAULT NULL,
  `function_name` varchar(512) DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `args` longtext,
  `vars` longtext,
  `enabled` char(1) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `next_run_time` datetime DEFAULT NULL,
  `stop_time` datetime DEFAULT NULL,
  `repeats` int DEFAULT NULL,
  `retry_failed` int DEFAULT NULL,
  `period` int DEFAULT NULL,
  `prevent_drift` char(1) DEFAULT NULL,
  `cronline` varchar(512) DEFAULT NULL,
  `timeout` int DEFAULT NULL,
  `sync_output` int DEFAULT NULL,
  `times_run` int DEFAULT NULL,
  `times_failed` int DEFAULT NULL,
  `last_run_time` datetime DEFAULT NULL,
  `assigned_worker_name` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `scheduler_task_deps` */

DROP TABLE IF EXISTS `scheduler_task_deps`;

CREATE TABLE `scheduler_task_deps` (
  `id` int NOT NULL AUTO_INCREMENT,
  `job_name` varchar(512) DEFAULT NULL,
  `task_parent` int DEFAULT NULL,
  `task_child` int DEFAULT NULL,
  `can_visit` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `task_child__idx` (`task_child`),
  CONSTRAINT `scheduler_task_deps_ibfk_1` FOREIGN KEY (`task_child`) REFERENCES `scheduler_task` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `scheduler_worker` */

DROP TABLE IF EXISTS `scheduler_worker`;

CREATE TABLE `scheduler_worker` (
  `id` int NOT NULL AUTO_INCREMENT,
  `worker_name` varchar(255) DEFAULT NULL,
  `first_heartbeat` datetime DEFAULT NULL,
  `last_heartbeat` datetime DEFAULT NULL,
  `status` varchar(512) DEFAULT NULL,
  `is_ticker` char(1) DEFAULT NULL,
  `group_names` longtext,
  `worker_stats` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `worker_name` (`worker_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_approved_return` */

DROP TABLE IF EXISTS `sm_approved_return`;

CREATE TABLE `sm_approved_return` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `process_date` date DEFAULT NULL,
  `process_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_approved_return_details` */

DROP TABLE IF EXISTS `sm_approved_return_details`;

CREATE TABLE `sm_approved_return_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `process_date` date DEFAULT NULL,
  `process_datetime` datetime DEFAULT NULL,
  `item_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actual_tp` double DEFAULT NULL,
  `actual_vat` double DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `bonus_qty` int DEFAULT NULL,
  `price` double DEFAULT NULL,
  `item_vat` double DEFAULT NULL,
  `item_unit` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_carton` int DEFAULT NULL,
  `short_note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount` double DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_area_team_process_schedule` */

DROP TABLE IF EXISTS `sm_area_team_process_schedule`;

CREATE TABLE `sm_area_team_process_schedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_area_team_temp` */

DROP TABLE IF EXISTS `sm_area_team_temp`;

CREATE TABLE `sm_area_team_temp` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firstdate` date DEFAULT NULL,
  `zone_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zone_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `territory_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `territory_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `territory_des` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `special_territory_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zm_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zm_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zm_mobile_no` bigint NOT NULL DEFAULT '0',
  `rsm_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rsm_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rsm_mobile_no` bigint NOT NULL DEFAULT '0',
  `fm_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fm_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fm_mobile_no` bigint NOT NULL DEFAULT '0',
  `mso_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mso_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mso_mobile_no` bigint NOT NULL DEFAULT '0',
  `mso_category` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zone_flag` int NOT NULL DEFAULT '0',
  `region_flag` int NOT NULL DEFAULT '0',
  `area_flag` int NOT NULL DEFAULT '0',
  `territory_flag` int NOT NULL DEFAULT '0',
  `first_part_flag` int NOT NULL DEFAULT '0',
  `zm_flag` int NOT NULL DEFAULT '0',
  `rsm_flag` int NOT NULL DEFAULT '0',
  `fm_flag` int NOT NULL DEFAULT '0',
  `mso_flag` int NOT NULL DEFAULT '0',
  `second_part_flag` int NOT NULL DEFAULT '0',
  `des` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fmflag_specialcode` (`fm_flag`,`special_territory_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_area_team_temp_backup` */

DROP TABLE IF EXISTS `sm_area_team_temp_backup`;

CREATE TABLE `sm_area_team_temp_backup` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firstdate` date DEFAULT NULL,
  `currentdate` date DEFAULT NULL,
  `zone_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zone_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `territory_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `territory_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `territory_des` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `special_territory_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zm_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zm_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rsm_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rsm_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fm_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fm_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mso_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mso_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mso_category` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fm_mobile_no` bigint DEFAULT NULL,
  `rsm_mobile_no` bigint DEFAULT NULL,
  `zm_mobile_no` bigint DEFAULT NULL,
  `mso_mobile_no` bigint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_attendance` */

DROP TABLE IF EXISTS `sm_attendance`;

CREATE TABLE `sm_attendance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attend_date` datetime DEFAULT NULL,
  `in_time` datetime DEFAULT NULL,
  `out_time` datetime DEFAULT NULL,
  `notice` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_block_territory` */

DROP TABLE IF EXISTS `sm_block_territory`;

CREATE TABLE `sm_block_territory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `block_date` date DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_brand` */

DROP TABLE IF EXISTS `sm_brand`;

CREATE TABLE `sm_brand` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_path` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_campaign_product_bonus` */

DROP TABLE IF EXISTS `sm_campaign_product_bonus`;

CREATE TABLE `sm_campaign_product_bonus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `min_qty` int DEFAULT NULL,
  `min_amount` double NOT NULL DEFAULT '0',
  `circular_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `until_stock_last` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `allowed_credit_inv` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `regular_discount_apply` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_campaign_product_bonus_bonuses` */

DROP TABLE IF EXISTS `sm_campaign_product_bonus_bonuses`;

CREATE TABLE `sm_campaign_product_bonus_bonuses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `refrowid` int DEFAULT NULL,
  `circular_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `bonus_product_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bonus_product_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bonus_qty` int DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_campaign_product_bonus_products` */

DROP TABLE IF EXISTS `sm_campaign_product_bonus_products`;

CREATE TABLE `sm_campaign_product_bonus_products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `refrowid` int DEFAULT NULL,
  `circular_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `product_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_category_type` */

DROP TABLE IF EXISTS `sm_category_type`;

CREATE TABLE `sm_category_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cat_type_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cat_type_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_typename` (`cid`,`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=953 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_channel` */

DROP TABLE IF EXISTS `sm_channel`;

CREATE TABLE `sm_channel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_channel_wise_scheme` */

DROP TABLE IF EXISTS `sm_channel_wise_scheme`;

CREATE TABLE `sm_channel_wise_scheme` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'SMART',
  `channel_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `channel_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `shop_owner_status` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `target` float DEFAULT '0',
  `achieve_percentage` float DEFAULT '0',
  `discount_percentage` float DEFAULT '0',
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_client` */

DROP TABLE IF EXISTS `sm_client`;

CREATE TABLE `sm_client` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_old_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_bn` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `short_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owner_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owner_name_bn` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_category_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_bn` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `passport` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trade_license_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vat_registration_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bin_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `drug_registration_num` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_grade` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `longitude` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_no1` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_no2` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dob` date NOT NULL DEFAULT '2025-01-01',
  `doj` date NOT NULL DEFAULT '2025-01-01',
  `starting_year` int DEFAULT NULL,
  `monthly_sales_capacity` int DEFAULT NULL,
  `monthly_sales` int DEFAULT NULL,
  `shop_owner_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `warehouse_capacity` int DEFAULT NULL,
  `shop_size` int DEFAULT NULL,
  `shop_front_size` int DEFAULT NULL,
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=245586 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_client_archive_2` */

DROP TABLE IF EXISTS `sm_client_archive_2`;

CREATE TABLE `sm_client_archive_2` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_old_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_bn` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `short_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owner_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owner_name_bn` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_category_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_bn` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `passport` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trade_license_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vat_registration_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bin_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `drug_registration_num` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_grade` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `longitude` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_no1` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_no2` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `doj` date DEFAULT NULL,
  `starting_year` int DEFAULT NULL,
  `monthly_sales_capacity` int DEFAULT NULL,
  `monthly_sales` int DEFAULT NULL,
  `shop_owner_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warehouse_capacity` int DEFAULT NULL,
  `shop_size` int DEFAULT NULL,
  `shop_front_size` int DEFAULT NULL,
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `district` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_posm` int DEFAULT '0',
  `client_rak` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_client_id` (`client_id`,`cid`),
  KEY `cid_area_id_depot_id` (`cid`,`area_id`,`depot_id`),
  KEY `area_wise_client` (`cid`,`area_id`,`status`),
  KEY `cid_contact` (`cid`,`contact_no1`),
  KEY `CID_CLIENT_ID_STATUS` (`cid`,`client_id`,`status`),
  KEY `CID_CLIENT_NAME_STATUS` (`cid`,`name`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=187163 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_client_cr_limit_days_update` */

DROP TABLE IF EXISTS `sm_client_cr_limit_days_update`;

CREATE TABLE `sm_client_cr_limit_days_update` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prev_limit` int NOT NULL DEFAULT '0',
  `prev_limit_days` int DEFAULT '0',
  `update_limit` int NOT NULL DEFAULT '0',
  `update_limit_days` int NOT NULL DEFAULT '0',
  `update_date` date DEFAULT NULL,
  `exp_date` date DEFAULT NULL,
  `chk_flag` int DEFAULT '0',
  `field1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT '0',
  `note` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_client_credit` */

DROP TABLE IF EXISTS `sm_client_credit`;

CREATE TABLE `sm_client_credit` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `credit_limit` double DEFAULT NULL,
  `credit_limit_days` int DEFAULT NULL,
  `field1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_client_grade_channel_temp` */

DROP TABLE IF EXISTS `sm_client_grade_channel_temp`;

CREATE TABLE `sm_client_grade_channel_temp` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT 'SMART',
  `upload_batch` int DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `client_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `client_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cl_category_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cl_category_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `shop_owner_status` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `customer_grade` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `status` int DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `upload_batch` (`upload_batch`,`cid`),
  KEY `status` (`cid`,`status`),
  KEY `ym_date` (`cid`,`ym_date`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1010710 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_client_id_map` */

DROP TABLE IF EXISTS `sm_client_id_map`;

CREATE TABLE `sm_client_id_map` (
  `old_client_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `new_client_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  KEY `idx_old_client_id` (`old_client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_client_payment` */

DROP TABLE IF EXISTS `sm_client_payment`;

CREATE TABLE `sm_client_payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paytype` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pay_date` datetime DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `narration` longtext COLLATE utf8mb4_unicode_ci,
  `depot_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_client_sales_volume` */

DROP TABLE IF EXISTS `sm_client_sales_volume`;

CREATE TABLE `sm_client_sales_volume` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `submit_date` date NOT NULL,
  `first_date` date NOT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sales_daily` double DEFAULT '0',
  `sales_monthly` double DEFAULT '0',
  `depot_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_client_user` */

DROP TABLE IF EXISTS `sm_client_user`;

CREATE TABLE `sm_client_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_no` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_count` int DEFAULT NULL,
  `first_sync_date` datetime DEFAULT NULL,
  `last_sync_date` datetime DEFAULT NULL,
  `monthly_sms_count` int DEFAULT NULL,
  `monthly_voucher_count` int DEFAULT NULL,
  `java` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `wap` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `android` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_client_visit_plan` */

DROP TABLE IF EXISTS `sm_client_visit_plan`;

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
  `status` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'ACTIVE',
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid` (`cid` DESC,`area_id` DESC,`status` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=6107 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_client_visit_report` */

DROP TABLE IF EXISTS `sm_client_visit_report`;

CREATE TABLE `sm_client_visit_report` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rsm_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rsm_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fm_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fm_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tr` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tr_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_1` int DEFAULT NULL,
  `d_2` int DEFAULT NULL,
  `d_3` int DEFAULT NULL,
  `d_4` int DEFAULT NULL,
  `d_5` int DEFAULT NULL,
  `d_6` int DEFAULT NULL,
  `d_7` int DEFAULT NULL,
  `d_8` int DEFAULT NULL,
  `d_9` int DEFAULT NULL,
  `d_10` int DEFAULT NULL,
  `d_11` int DEFAULT NULL,
  `d_12` int DEFAULT NULL,
  `d_13` int DEFAULT NULL,
  `d_14` int DEFAULT NULL,
  `d_15` int DEFAULT NULL,
  `d_16` int DEFAULT NULL,
  `d_17` int DEFAULT NULL,
  `d_18` int DEFAULT NULL,
  `d_19` int DEFAULT NULL,
  `d_20` int DEFAULT NULL,
  `d_21` int DEFAULT NULL,
  `d_22` int DEFAULT NULL,
  `d_23` int DEFAULT NULL,
  `d_24` int DEFAULT NULL,
  `d_25` int DEFAULT NULL,
  `d_26` int DEFAULT NULL,
  `d_27` int DEFAULT NULL,
  `d_28` int DEFAULT NULL,
  `d_29` int DEFAULT NULL,
  `d_30` int DEFAULT NULL,
  `d_31` int DEFAULT NULL,
  `a_1` int DEFAULT NULL,
  `a_2` int DEFAULT NULL,
  `a_3` int DEFAULT NULL,
  `a_4` int DEFAULT NULL,
  `a_5` int DEFAULT NULL,
  `a_6` int DEFAULT NULL,
  `a_7` int DEFAULT NULL,
  `a_8` int DEFAULT NULL,
  `a_9` int DEFAULT NULL,
  `a_10` int DEFAULT NULL,
  `a_11` int DEFAULT NULL,
  `a_12` int DEFAULT NULL,
  `a_13` int DEFAULT NULL,
  `a_14` int DEFAULT NULL,
  `a_15` int DEFAULT NULL,
  `a_16` int DEFAULT NULL,
  `a_17` int DEFAULT NULL,
  `a_18` int DEFAULT NULL,
  `a_19` int DEFAULT NULL,
  `a_20` int DEFAULT NULL,
  `a_21` int DEFAULT NULL,
  `a_22` int DEFAULT NULL,
  `a_23` int DEFAULT NULL,
  `a_24` int DEFAULT NULL,
  `a_25` int DEFAULT NULL,
  `a_26` int DEFAULT NULL,
  `a_27` int DEFAULT NULL,
  `a_28` int DEFAULT NULL,
  `a_29` int DEFAULT NULL,
  `a_30` int DEFAULT NULL,
  `a_31` int DEFAULT NULL,
  `y_month` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rpt_date` date DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_comp_mobile` */

DROP TABLE IF EXISTS `sm_comp_mobile`;

CREATE TABLE `sm_comp_mobile` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_no` bigint DEFAULT NULL,
  `user_type` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_company_settings` */

DROP TABLE IF EXISTS `sm_company_settings`;

CREATE TABLE `sm_company_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `http_pass` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subscription_model` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `clean_Data` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `keep_history` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subscription_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `admin_mobile_no` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_list` longtext COLLATE utf8mb4_unicode_ci,
  `item_list_mobile` longtext COLLATE utf8mb4_unicode_ci,
  `temp_item_list` longtext COLLATE utf8mb4_unicode_ci,
  `field1` longtext COLLATE utf8mb4_unicode_ci,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_cp_approved` */

DROP TABLE IF EXISTS `sm_cp_approved`;

CREATE TABLE `sm_cp_approved` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approved_date` date DEFAULT NULL,
  `branch_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `credit_amount` double DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_depotid_clientid` (`cid`,`branch_id`,`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_cp_rsm` */

DROP TABLE IF EXISTS `sm_cp_rsm`;

CREATE TABLE `sm_cp_rsm` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approved_date` date DEFAULT NULL,
  `region_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `branch_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `credit_amount` double DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_cp_special` */

DROP TABLE IF EXISTS `sm_cp_special`;

CREATE TABLE `sm_cp_special` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approved_date` date DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `credit_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `branch_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `credit_amount` double DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_customer_grade` */

DROP TABLE IF EXISTS `sm_customer_grade`;

CREATE TABLE `sm_customer_grade` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_damage` */

DROP TABLE IF EXISTS `sm_damage`;

CREATE TABLE `sm_damage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sl` int DEFAULT NULL,
  `transfer_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type_sl` int NOT NULL DEFAULT '0',
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id_to` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name_to` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `damage_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `adjustment_reference` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `adjustment_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `dist_rate` double DEFAULT NULL,
  `item_unit` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_carton` int NOT NULL DEFAULT '0',
  `expiary_date` date DEFAULT NULL,
  `short_note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid_depot_id_sl` (`cid` DESC,`depot_id` DESC,`sl` DESC),
  KEY `CID_DDATE_STATUS` (`cid` DESC,`damage_date` DESC,`status` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=9707 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_damage_head` */

DROP TABLE IF EXISTS `sm_damage_head`;

CREATE TABLE `sm_damage_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sl` int DEFAULT NULL,
  `transfer_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type_sl` int NOT NULL DEFAULT '0',
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id_to` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name_to` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `damage_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `adjustment_reference` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `adjustment_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  UNIQUE KEY `cid_depot_id_sl` (`cid` DESC,`depot_id` DESC,`sl` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=1127 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_damage_return` */

DROP TABLE IF EXISTS `sm_damage_return`;

CREATE TABLE `sm_damage_return` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `order_sl` int DEFAULT '0',
  `transfer_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type_sl` int DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id_to` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name_to` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `damage_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `adjustment_reference` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `adjustment_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `brand_id` varchar(70) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actual_tp` double DEFAULT '0',
  `quantity` int DEFAULT NULL,
  `dist_rate` double DEFAULT NULL,
  `atp` double NOT NULL DEFAULT '0',
  `item_unit` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_carton` int DEFAULT NULL,
  `expiary_date` date DEFAULT NULL,
  `short_note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `invoice_sl` int DEFAULT '0',
  `dam_item_id` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dam_item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dam_item_quantity` int DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `dump_data` (`cid` DESC,`order_sl` DESC,`depot_id` DESC,`item_id` DESC),
  KEY `cid_depot_id_order_sl` (`cid` DESC,`depot_id` DESC,`order_sl` DESC),
  KEY `cid_depot_id_sl` (`cid` DESC,`depot_id` DESC,`sl` DESC),
  KEY `CID_DDATE_STATUS` (`cid` DESC,`damage_date` DESC,`status` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=590316 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_damage_return_head` */

DROP TABLE IF EXISTS `sm_damage_return_head`;

CREATE TABLE `sm_damage_return_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `order_sl` int DEFAULT NULL,
  `transfer_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type_sl` int DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id_to` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name_to` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `damage_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `adjustment_reference` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `adjustment_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `brand_id` varchar(70) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `invoice_sl` int DEFAULT '0',
  PRIMARY KEY (`id` DESC),
  KEY `CID_DEPOT_ID_SL` (`cid` DESC,`depot_id` DESC,`sl` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=482619 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_data_clean` */

DROP TABLE IF EXISTS `sm_data_clean`;

CREATE TABLE `sm_data_clean` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `object_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `day_before` int DEFAULT NULL,
  `des` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_delivery_man` */

DROP TABLE IF EXISTS `sm_delivery_man`;

CREATE TABLE `sm_delivery_man` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_man_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_no` bigint DEFAULT NULL,
  `password` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_count` int DEFAULT NULL,
  `first_sync_date` datetime DEFAULT NULL,
  `last_sync_date` datetime DEFAULT NULL,
  `monthly_sms_count` int DEFAULT NULL,
  `monthly_voucher_count` int DEFAULT NULL,
  `java` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `wap` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `android` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_depotid_dp` (`cid`,`depot_id`,`d_man_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_depot` */

DROP TABLE IF EXISTS `sm_depot`;

CREATE TABLE `sm_depot` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sup_depot_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `sup_depot_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_depot_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `name_bn` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `short_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `depot_category` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'DISTRIBUTOR',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `contact` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_2` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `address` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `address_bn` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `wh_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `wh_address_bn` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `bin` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `owner_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `owner_name_bn` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `tin` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `town_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `town_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `latitude` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0.0',
  `longitude` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0.0',
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
  `dm_pass` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1234',
  `sequence_no` int DEFAULT '1',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVE',
  `field1` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `approval_flag` int DEFAULT '0' COMMENT '0 PSR, 1 DEPOT, 2 OPERATOR',
  `auto_del_cron_flag` int DEFAULT '0',
  `intr_flag` int DEFAULT '0',
  `sync_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '1234',
  `sync_count` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid_depot_id_status` (`cid` DESC,`depot_id` DESC,`status` DESC),
  KEY `cid_depot_id` (`cid` DESC,`depot_id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=712 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_depot_archive` */

DROP TABLE IF EXISTS `sm_depot_archive`;

CREATE TABLE `sm_depot_archive` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sup_depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sup_depot_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_bn` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `short_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_category` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT 'Distributor',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_2` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_bn` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `wh_address` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `wh_address_bn` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bin` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owner_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owner_name_bn` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tin` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `town_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `town_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '0.0000',
  `longitude` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '0.0000',
  `requisition_sl` int DEFAULT '0',
  `issue_sl` int DEFAULT '0',
  `receive_sl` int DEFAULT '0',
  `damage_sl` int DEFAULT '0',
  `order_sl` int DEFAULT '0',
  `del_sl` int DEFAULT '0',
  `return_sl` int DEFAULT '0',
  `client_payment_sl` int DEFAULT '0',
  `depot_payment_sl` int DEFAULT '0',
  `stock_in_sl` int DEFAULT '0',
  `dm_pass` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '1234',
  `sequence_no` int DEFAULT '1',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVE',
  `field1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `approval_flag` int DEFAULT '0' COMMENT '0 PSR, 1 DEPOT, 2 OPERATOR',
  `auto_del_cron_flag` int DEFAULT '0',
  `intr_flag` int DEFAULT '0',
  `sync_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '1234',
  `sync_count` int DEFAULT '0',
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid` (`cid`,`depot_id`),
  KEY `cid_depot_status` (`cid`,`depot_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=633 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_depot_belt` */

DROP TABLE IF EXISTS `sm_depot_belt`;

CREATE TABLE `sm_depot_belt` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `belt_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=755 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_depot_market` */

DROP TABLE IF EXISTS `sm_depot_market`;

CREATE TABLE `sm_depot_market` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=845 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_depot_payment` */

DROP TABLE IF EXISTS `sm_depot_payment`;

CREATE TABLE `sm_depot_payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `from_depot` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_from_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `to_depot` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_to_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `pay_date` datetime DEFAULT NULL,
  `issue_ref` int DEFAULT NULL,
  `receive_ref` int DEFAULT NULL,
  `paytype` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `narration` longtext COLLATE utf8mb4_unicode_ci,
  `depot_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_depot_rack_stock_balance` */

DROP TABLE IF EXISTS `sm_depot_rack_stock_balance`;

CREATE TABLE `sm_depot_rack_stock_balance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rack_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rack_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rack_code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rack_url` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_r_condition` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `expiary_date` date DEFAULT NULL,
  `field1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rack_list` (`cid`,`depot_id`,`client_id`),
  KEY `cid_rack_code` (`rack_code`,`cid`)
) ENGINE=InnoDB AUTO_INCREMENT=99549 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_depot_settings` */

DROP TABLE IF EXISTS `sm_depot_settings`;

CREATE TABLE `sm_depot_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_to_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id_from_to` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_depot_stock_balance` */

DROP TABLE IF EXISTS `sm_depot_stock_balance`;

CREATE TABLE `sm_depot_stock_balance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expiary_date` date DEFAULT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `block_qty` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id` DESC),
  KEY `CID_DEPOT_STORE_ITEM` (`cid` DESC,`depot_id` DESC,`store_id` DESC,`item_id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=351153 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_depot_stock_process_schedule` */

DROP TABLE IF EXISTS `sm_depot_stock_process_schedule`;

CREATE TABLE `sm_depot_stock_process_schedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_depot_stock_snap` */

DROP TABLE IF EXISTS `sm_depot_stock_snap`;

CREATE TABLE `sm_depot_stock_snap` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'SMART',
  `depot_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `snap_date` date DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `CID_SNAP_DATE_DEPOT_ID_STORE_ID` (`cid` DESC,`depot_id` DESC,`store_id` DESC,`snap_date` DESC),
  KEY `CID_SNAP_DATE` (`cid` DESC,`snap_date` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=5686475 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_depot_stock_tran_snapshot` */

DROP TABLE IF EXISTS `sm_depot_stock_tran_snapshot`;

CREATE TABLE `sm_depot_stock_tran_snapshot` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `process_date` date DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expiary_date` date DEFAULT NULL,
  `gr_qty` int DEFAULT NULL,
  `issue_qty` int DEFAULT NULL,
  `ret_qty` int DEFAULT NULL,
  `transfer_in_qty` int NOT NULL DEFAULT '0',
  `transfer_qty` int DEFAULT NULL,
  `inv_b_qty` int DEFAULT NULL,
  `inv_qty` int DEFAULT NULL,
  `adj_incr_qty` int DEFAULT NULL,
  `ret_b_qty` int DEFAULT NULL,
  `adj_decr_qty` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_depot_store` */

DROP TABLE IF EXISTS `sm_depot_store`;

CREATE TABLE `sm_depot_store` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  UNIQUE KEY `unique_store` (`cid` DESC,`depot_id` DESC,`store_id` DESC),
  KEY `cid_depot_id_store_id` (`cid` DESC,`depot_id` DESC,`store_id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=1407 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_depot_user` */

DROP TABLE IF EXISTS `sm_depot_user`;

CREATE TABLE `sm_depot_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=291 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_designation` */

DROP TABLE IF EXISTS `sm_designation`;

CREATE TABLE `sm_designation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_direct_sale_user` */

DROP TABLE IF EXISTS `sm_direct_sale_user`;

CREATE TABLE `sm_direct_sale_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) NOT NULL DEFAULT 'SMART',
  `rep_id` varchar(50) DEFAULT NULL,
  `sales_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_doc_feedback` */

DROP TABLE IF EXISTS `sm_doc_feedback`;

CREATE TABLE `sm_doc_feedback` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `doctor_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visit_date` datetime DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `feed_back` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doc_visit_gift` */

DROP TABLE IF EXISTS `sm_doc_visit_gift`;

CREATE TABLE `sm_doc_visit_gift` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `doc_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doc_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visited_flag` int DEFAULT NULL,
  `visit_sl` int DEFAULT NULL,
  `visit_date` date DEFAULT NULL,
  `status` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`,`visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doc_visit_ppm` */

DROP TABLE IF EXISTS `sm_doc_visit_ppm`;

CREATE TABLE `sm_doc_visit_ppm` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `doc_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doc_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visited_flag` int DEFAULT NULL,
  `visit_sl` int DEFAULT NULL,
  `visit_date` date DEFAULT NULL,
  `status` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`,`visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doc_visit_prop` */

DROP TABLE IF EXISTS `sm_doc_visit_prop`;

CREATE TABLE `sm_doc_visit_prop` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `doc_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doc_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visited_flag` int DEFAULT NULL,
  `visit_sl` int DEFAULT NULL,
  `visit_date` date DEFAULT NULL,
  `status` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_cat` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_brand` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`,`visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doc_visit_report` */

DROP TABLE IF EXISTS `sm_doc_visit_report`;

CREATE TABLE `sm_doc_visit_report` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rsm_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rsm_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `fm_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fm_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `tr` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tr_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `doc` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doc_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `d_1` int NOT NULL DEFAULT '0',
  `d_2` int NOT NULL DEFAULT '0',
  `d_3` int NOT NULL DEFAULT '0',
  `d_4` int NOT NULL DEFAULT '0',
  `d_5` int NOT NULL DEFAULT '0',
  `d_6` int NOT NULL DEFAULT '0',
  `d_7` int NOT NULL DEFAULT '0',
  `d_8` int NOT NULL DEFAULT '0',
  `d_9` int NOT NULL DEFAULT '0',
  `d_10` int NOT NULL DEFAULT '0',
  `d_11` int NOT NULL DEFAULT '0',
  `d_12` int NOT NULL DEFAULT '0',
  `d_13` int NOT NULL DEFAULT '0',
  `d_14` int NOT NULL DEFAULT '0',
  `d_15` int NOT NULL DEFAULT '0',
  `d_16` int NOT NULL DEFAULT '0',
  `d_17` int NOT NULL DEFAULT '0',
  `d_18` int NOT NULL DEFAULT '0',
  `d_19` int NOT NULL DEFAULT '0',
  `d_20` int NOT NULL DEFAULT '0',
  `d_21` int NOT NULL DEFAULT '0',
  `d_22` int NOT NULL DEFAULT '0',
  `d_23` int NOT NULL DEFAULT '0',
  `d_24` int NOT NULL DEFAULT '0',
  `d_25` int NOT NULL DEFAULT '0',
  `d_26` int NOT NULL DEFAULT '0',
  `d_27` int NOT NULL DEFAULT '0',
  `d_28` int NOT NULL DEFAULT '0',
  `d_29` int NOT NULL DEFAULT '0',
  `d_30` int NOT NULL DEFAULT '0',
  `d_31` int NOT NULL DEFAULT '0',
  `y_month` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `rpt_date` date DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT '0',
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doc_visit_report_fm` */

DROP TABLE IF EXISTS `sm_doc_visit_report_fm`;

CREATE TABLE `sm_doc_visit_report_fm` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rsm_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rsm_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fm_level_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fm_level_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tr` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tr_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fm_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fm_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `doc` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doc_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_1` int DEFAULT '0',
  `d_2` int DEFAULT '0',
  `d_3` int DEFAULT '0',
  `d_4` int DEFAULT '0',
  `d_5` int DEFAULT '0',
  `d_6` int DEFAULT '0',
  `d_7` int DEFAULT '0',
  `d_8` int DEFAULT '0',
  `d_9` int DEFAULT '0',
  `d_10` int DEFAULT '0',
  `d_11` int DEFAULT '0',
  `d_12` int DEFAULT '0',
  `d_13` int DEFAULT '0',
  `d_14` int DEFAULT '0',
  `d_15` int DEFAULT '0',
  `d_16` int DEFAULT '0',
  `d_17` int DEFAULT '0',
  `d_18` int DEFAULT '0',
  `d_19` int DEFAULT '0',
  `d_20` int DEFAULT '0',
  `d_21` int DEFAULT '0',
  `d_22` int DEFAULT '0',
  `d_23` int DEFAULT '0',
  `d_24` int DEFAULT '0',
  `d_25` int DEFAULT '0',
  `d_26` int DEFAULT '0',
  `d_27` int DEFAULT '0',
  `d_28` int DEFAULT '0',
  `d_29` int DEFAULT '0',
  `d_30` int DEFAULT '0',
  `d_31` int DEFAULT '0',
  `y_month` date DEFAULT NULL,
  `rpt_date` date DEFAULT NULL,
  `field1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doc_visit_sample` */

DROP TABLE IF EXISTS `sm_doc_visit_sample`;

CREATE TABLE `sm_doc_visit_sample` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `doc_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doc_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trDesc` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `depot_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visited_flag` int DEFAULT NULL,
  `visit_sl` int DEFAULT NULL,
  `visit_date` date DEFAULT NULL,
  `status` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_cat` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_brand` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qty` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`,`visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doctor` */

DROP TABLE IF EXISTS `sm_doctor`;

CREATE TABLE `sm_doctor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doc_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doc_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `specialty` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `degree` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `password` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile` bigint DEFAULT NULL,
  `sync_code` int DEFAULT NULL,
  `des` longtext COLLATE utf8mb4_unicode_ci,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attached_institution` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `designation` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `mar_day` date DEFAULT NULL,
  `doctors_category` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_docid` (`cid`,`doc_id`),
  UNIQUE KEY `i1` (`doc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doctor_area` */

DROP TABLE IF EXISTS `sm_doctor_area`;

CREATE TABLE `sm_doctor_area` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doc_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doc_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `district` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `thana` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `depot_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` int DEFAULT NULL,
  `longitude` int DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_docid_areaid` (`cid`,`doc_id`,`area_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doctor_gift` */

DROP TABLE IF EXISTS `sm_doctor_gift`;

CREATE TABLE `sm_doctor_gift` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gift_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gift_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_brand` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item_price` double NOT NULL DEFAULT '0',
  `des` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doctor_inbox` */

DROP TABLE IF EXISTS `sm_doctor_inbox`;

CREATE TABLE `sm_doctor_inbox` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `mobile_no` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms_date` datetime DEFAULT NULL,
  `sms` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `error_in_sms` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` int DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doctor_ppm` */

DROP TABLE IF EXISTS `sm_doctor_ppm`;

CREATE TABLE `sm_doctor_ppm` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gift_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gift_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_brand` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item_price` double NOT NULL DEFAULT '0',
  `des` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doctor_sample` */

DROP TABLE IF EXISTS `sm_doctor_sample`;

CREATE TABLE `sm_doctor_sample` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_brand` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item_price` double NOT NULL DEFAULT '0',
  `des` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_type` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `manufacturer` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pack_size` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doctor_visit` */

DROP TABLE IF EXISTS `sm_doctor_visit`;

CREATE TABLE `sm_doctor_visit` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doc_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doc_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `feedback` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `special_rsm_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `special_fm_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `special_territory_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visit_dtime` datetime DEFAULT NULL,
  `visit_date` date DEFAULT NULL,
  `visit_firstdate` date DEFAULT NULL,
  `giftnsample` longtext COLLATE utf8mb4_unicode_ci,
  `latitude` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `longitude` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location_detail` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '-',
  `last_location` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `imageName` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `r_flag` int NOT NULL DEFAULT '0',
  `by_level_2` int NOT NULL DEFAULT '0',
  `r_flag_level_2` int NOT NULL DEFAULT '0',
  `by_level_3` int NOT NULL DEFAULT '0',
  `r_flag_level_3` int NOT NULL DEFAULT '0',
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_routeid_docid_repid` (`cid`,`route_id`,`doc_id`,`rep_id`),
  KEY `level` (`level0_id`,`level1_id`,`level2_id`,`level3_id`),
  KEY `cid_visitDate` (`cid`,`visit_date`),
  KEY `cid` (`cid`,`visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_doctor_visit_plan` */

DROP TABLE IF EXISTS `sm_doctor_visit_plan`;

CREATE TABLE `sm_doctor_visit_plan` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `doc_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doc_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visited_flag` int DEFAULT NULL,
  `visit_sl` int DEFAULT NULL,
  `visit_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`,`visit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_download_table` */

DROP TABLE IF EXISTS `sm_download_table`;

CREATE TABLE `sm_download_table` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `table_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `primary_key` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `insert_query` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delete_query` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `update_query` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_download_url` */

DROP TABLE IF EXISTS `sm_download_url`;

CREATE TABLE `sm_download_url` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `download_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `update_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_farm` */

DROP TABLE IF EXISTS `sm_farm`;

CREATE TABLE `sm_farm` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `farm_id` bigint NOT NULL DEFAULT '0',
  `farm_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(350) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `longitude` varchar(350) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `farm_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owner_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_no` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `medicine` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `manger_name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `consultant_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birds_animal` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rearing_housing` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `feeding` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `watering` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `brooding` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `poandsSize` int DEFAULT NULL,
  `status` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVE',
  `field1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `anniversary` date DEFAULT NULL,
  `dob` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_file_info` */

DROP TABLE IF EXISTS `sm_file_info`;

CREATE TABLE `sm_file_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_url` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_free_sales` */

DROP TABLE IF EXISTS `sm_free_sales`;

CREATE TABLE `sm_free_sales` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cid` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `day_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `free_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`,`free_date`)
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_gift_submit` */

DROP TABLE IF EXISTS `sm_gift_submit`;

CREATE TABLE `sm_gift_submit` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `doctor_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gift_date` datetime DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gift_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gift_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `price` double DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_gsp_dispatch` */

DROP TABLE IF EXISTS `sm_gsp_dispatch`;

CREATE TABLE `sm_gsp_dispatch` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `submit_date` date DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `ref_disp` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `emp_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emp_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `gsp_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gsp_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gsp_brand` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `gsp_price` double NOT NULL DEFAULT '0',
  `gsp_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gsp_qty` int DEFAULT NULL,
  `gsp_rec_date` date DEFAULT NULL,
  `gsp_rec_qty` int NOT NULL DEFAULT '0',
  `status` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rec_flag` int NOT NULL DEFAULT '0',
  `field1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `i1` (`cid`,`emp_id`,`rec_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_gsp_receive` */

DROP TABLE IF EXISTS `sm_gsp_receive`;

CREATE TABLE `sm_gsp_receive` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rec_date` date DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `ref` int NOT NULL DEFAULT '0',
  `emp_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emp_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `gsp_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gsp_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gsp_brand` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `gsp_price` double NOT NULL DEFAULT '0',
  `gsp_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gsp_rec_qty` int DEFAULT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_inbox` */

DROP TABLE IF EXISTS `sm_inbox`;

CREATE TABLE `sm_inbox` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `depot_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_no` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms_date` datetime DEFAULT NULL,
  `sms` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `error_in_sms` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` int DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_integration_log` */

DROP TABLE IF EXISTS `sm_integration_log`;

CREATE TABLE `sm_integration_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'SMART',
  `api_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `integration_date` datetime DEFAULT NULL,
  `intr_flag` int DEFAULT '0',
  `push_flag` int DEFAULT '0',
  `status` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Draft',
  `column_1` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_2` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_3` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_4` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_5` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_6` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_7` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_8` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_9` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_10` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_11` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_12` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_13` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_14` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_15` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_16` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_17` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_18` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_19` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_20` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_21` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_22` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_23` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_24` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_25` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_26` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_27` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_28` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_29` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `column_30` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `CID_TYPE_TIME` (`cid`,`api_type`,`integration_date`),
  KEY `CID_TYPE_TIME_FLAG` (`cid`,`api_type`,`integration_date`,`push_flag`),
  KEY `LOG_TO_REC` (`cid`,`api_type`,`push_flag`,`column_2`,`column_10`),
  KEY `SEARCH_LOG_TO_REC` (`cid`,`api_type`,`push_flag`)
) ENGINE=InnoDB AUTO_INCREMENT=265909 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_invoice` */

DROP TABLE IF EXISTS `sm_invoice`;

CREATE TABLE `sm_invoice` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'SMART',
  `depot_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `depot_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `sl` int DEFAULT NULL,
  `store_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `store_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Commercial',
  `order_sl` int DEFAULT '0',
  `order_datetime` datetime DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `payment_mode` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'CASH',
  `credit_note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `client_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `client_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `rep_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `rep_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `market_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `market_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `d_man_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'DM001',
  `d_man_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'DM001',
  `area_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `area_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level0_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level0_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level1_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level1_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level2_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level2_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level3_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level3_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `cl_category_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `cl_category_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `cl_sub_category_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `cl_sub_category_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `special_rsm_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `special_fm_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `special_territory_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `invoice_media` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'WEB',
  `device_user_agent` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `ip_ref` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `sc_discount` float DEFAULT '0',
  `discount` double DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `invoice_ym_date` date DEFAULT NULL,
  `category_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `category_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `item_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `item_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `item_unit` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `weight` float DEFAULT '0',
  `batch_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `item_carton` int NOT NULL DEFAULT '0',
  `actual_tp` double NOT NULL DEFAULT '0',
  `actual_vat` double NOT NULL DEFAULT '0',
  `item_vat` double NOT NULL DEFAULT '0',
  `price` double NOT NULL DEFAULT '0',
  `quantity` int DEFAULT NULL,
  `bonus_qty` int DEFAULT NULL,
  `mr_qty` int DEFAULT '0',
  `replacement_qty` int DEFAULT '0',
  `return_qty` int NOT NULL DEFAULT '0',
  `return_bonus_qty` int NOT NULL DEFAULT '0',
  `return_rate` double NOT NULL DEFAULT '0',
  `sp_discount_item` double NOT NULL DEFAULT '0',
  `return_sp_discount_item` double NOT NULL DEFAULT '0',
  `promotion_type` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `bonus_applied_on_qty` int NOT NULL DEFAULT '0',
  `circular_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `discount_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `item_discount` double NOT NULL DEFAULT '0',
  `item_discount_percent` double NOT NULL DEFAULT '0',
  `discount_type_quantity` int NOT NULL DEFAULT '0',
  `ret_discount_type_quantity` int NOT NULL DEFAULT '0',
  `short_note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `status` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `depot_status` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `ho_status` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `flag_depot_stock` int DEFAULT '0',
  `flag_depot_stock_balance` int DEFAULT '0',
  `flag_data` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `posted_on` datetime DEFAULT NULL,
  `posted_by` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `msoCategory` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `itembaseGroup` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `team` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'General',
  `visit_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Scheduled',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  PRIMARY KEY (`id` DESC),
  UNIQUE KEY `ci_depot_id_sl_item_id` (`cid` DESC,`depot_id` DESC,`sl` DESC,`item_id` DESC,`store_id` DESC),
  KEY `cid_delivery_depot_area_status` (`cid` DESC,`delivery_date` DESC,`depot_id` DESC,`area_id` DESC,`status` DESC),
  KEY `cid_delivery_rep` (`cid` DESC,`delivery_date` DESC,`rep_id` DESC),
  KEY `dump_data` (`cid` DESC,`delivery_date` DESC,`status` DESC),
  KEY `sales_confirmation_mobile_api` (`cid` DESC,`delivery_date` DESC,`client_id` DESC,`invoice_media` DESC,`status` DESC),
  KEY `cid_inv_date_status` (`cid` DESC,`invoice_date` DESC,`status` DESC),
  KEY `idx_invoice_100` (`cid` DESC,`client_id` DESC,`status` DESC,`sl` DESC),
  KEY `cid_client_id_item_id` (`cid` DESC,`client_id` DESC,`item_id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=41808259 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_invoice_head` */

DROP TABLE IF EXISTS `sm_invoice_head`;

CREATE TABLE `sm_invoice_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'SMART',
  `depot_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `depot_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `sl` int DEFAULT NULL,
  `store_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `store_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Commercial',
  `order_sl` int DEFAULT '0',
  `order_datetime` datetime DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `payment_mode` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'CASH',
  `credit_note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `client_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `client_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `rep_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `rep_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `market_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `market_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `d_man_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'DM001',
  `d_man_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'DM001',
  `area_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `area_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level0_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level0_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level1_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level1_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level2_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level2_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level3_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `level3_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `cl_category_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `cl_category_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `cl_sub_category_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `cl_sub_category_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `special_rsm_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `special_fm_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `special_territory_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `status` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Draft',
  `invoice_media` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'WEB',
  `device_user_agent` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `ip_ref` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `shipment_no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `actual_total_tp` double NOT NULL DEFAULT '0',
  `regular_disc_tp` double NOT NULL DEFAULT '0',
  `flat_disc_tp` double NOT NULL DEFAULT '0',
  `approved_disc_tp` double NOT NULL DEFAULT '0',
  `others_disc_tp` double NOT NULL DEFAULT '0',
  `no_disc_tp` double NOT NULL DEFAULT '0',
  `ret_actual_total_tp` double NOT NULL DEFAULT '0',
  `ret_regular_disc_tp` double NOT NULL DEFAULT '0',
  `ret_flat_disc_tp` double NOT NULL DEFAULT '0',
  `ret_approved_disc_tp` double NOT NULL DEFAULT '0',
  `ret_others_disc_tp` double NOT NULL DEFAULT '0',
  `total_amount` double NOT NULL DEFAULT '0',
  `discount` double NOT NULL DEFAULT '0',
  `vat_total_amount` double NOT NULL DEFAULT '0',
  `collection_amount` double NOT NULL DEFAULT '0',
  `discount_precent` double NOT NULL DEFAULT '0',
  `adjust_amount` double NOT NULL DEFAULT '0',
  `return_tp` double NOT NULL DEFAULT '0',
  `return_vat` double NOT NULL DEFAULT '0',
  `return_discount` double NOT NULL DEFAULT '0',
  `sp_discount` double NOT NULL DEFAULT '0',
  `sp_flat` double NOT NULL DEFAULT '0',
  `sp_approved` double NOT NULL DEFAULT '0',
  `sp_others` double NOT NULL DEFAULT '0',
  `return_sp_discount` double NOT NULL DEFAULT '0',
  `ret_sp_flat` double NOT NULL DEFAULT '0',
  `ret_sp_approved` double NOT NULL DEFAULT '0',
  `ret_sp_others` double NOT NULL DEFAULT '0',
  `return_count` int NOT NULL DEFAULT '0',
  `previous_ost_amt` double NOT NULL DEFAULT '0',
  `client_limit_amt` double NOT NULL DEFAULT '0',
  `ym_date` date DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `invoice_ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `ho_status` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `flag_depot_stock` int DEFAULT '0',
  `flag_depot_stock_balance` int DEFAULT '0',
  `flag_data` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `client_limit_over` int NOT NULL DEFAULT '0',
  `empty_batch_flag` int NOT NULL DEFAULT '0',
  `acknowledge_flag` int NOT NULL DEFAULT '0',
  `promo_ref` int NOT NULL DEFAULT '0',
  `inv_pending_flag` int NOT NULL DEFAULT '0',
  `rpt_trans_flag` int NOT NULL DEFAULT '0',
  `posted_on` datetime DEFAULT NULL,
  `posted_by` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `visit_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Scheduled',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  PRIMARY KEY (`id` DESC),
  UNIQUE KEY `cid_depot_id_sl` (`cid` DESC,`depot_id` DESC,`sl` DESC),
  KEY `updated_on` (`updated_on` DESC),
  KEY `mobile_api` (`cid` DESC,`depot_id` DESC,`delivery_date` DESC,`client_id` DESC,`area_id` DESC),
  KEY `CID_DEPOT_ID_STATUS` (`cid` DESC,`depot_id` DESC,`status` DESC),
  KEY `CID_DEPOT_ID_SL_STATUS` (`cid` DESC,`depot_id` DESC,`sl` DESC,`status` DESC),
  KEY `CID_DELIVERY_DATE_REP_ID` (`cid` DESC,`delivery_date` DESC,`rep_id` DESC),
  KEY `X_STATUS` (`cid` DESC,`delivery_date` DESC,`rep_id` DESC,`status` DESC),
  KEY `X_INV_MEDIA` (`cid` DESC,`delivery_date` DESC,`client_id` DESC,`status` DESC,`invoice_media` DESC),
  KEY `CID_STATUS` (`cid` DESC,`status` DESC),
  KEY `CID_DELIVERY_DATE_CLIENT_ID_STATUS` (`cid` DESC,`delivery_date` DESC,`client_id` DESC,`status` DESC),
  KEY `idx_invoice_head_100` (`cid` DESC,`client_id` DESC,`delivery_date` DESC,`status` DESC,`invoice_media` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=13440973 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_invoice_manual` */

DROP TABLE IF EXISTS `sm_invoice_manual`;

CREATE TABLE `sm_invoice_manual` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) DEFAULT 'SMART',
  `delivery_date` date DEFAULT NULL,
  `client_id` varchar(20) DEFAULT NULL,
  `item_id` varchar(50) DEFAULT NULL,
  `quantity` int DEFAULT '0',
  `mr_qty` int DEFAULT '0',
  `process_flag` int DEFAULT '0',
  `note` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_d_date_client_item` (`cid`,`delivery_date`,`client_id`,`item_id`),
  KEY `search_inv` (`cid`,`process_flag`),
  KEY `pick_inv` (`cid`,`delivery_date`,`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

/*Table structure for table `sm_invoice_process` */

DROP TABLE IF EXISTS `sm_invoice_process`;

CREATE TABLE `sm_invoice_process` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `process_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `depot_id` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `CID_PROCESS_ID` (`cid` DESC,`process_id` DESC),
  KEY `CID_PROCESS_ID_DEPOT_ID` (`cid` DESC,`process_id` DESC,`depot_id` DESC),
  KEY `CID_DEPOT_ID` (`cid` DESC,`depot_id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=713 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_invoice_processing_log` */

DROP TABLE IF EXISTS `sm_invoice_processing_log`;

CREATE TABLE `sm_invoice_processing_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `item_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `message1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `message2` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `flag` int DEFAULT '0',
  `created_on` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`,`depot_id`,`sl`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=69371 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_issue` */

DROP TABLE IF EXISTS `sm_issue`;

CREATE TABLE `sm_issue` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `depot_id` varchar(50) DEFAULT NULL,
  `depot_name` varchar(100) NOT NULL DEFAULT '',
  `sl` int DEFAULT NULL,
  `store_id` varchar(50) DEFAULT NULL,
  `store_name` varchar(100) DEFAULT NULL,
  `issued_to` varchar(50) DEFAULT NULL,
  `depot_to_name` varchar(100) NOT NULL DEFAULT '',
  `issue_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `issue_process_status` varchar(20) DEFAULT NULL,
  `total_discount` double DEFAULT NULL,
  `transaction_cause` varchar(200) DEFAULT NULL,
  `req_sl` int DEFAULT NULL,
  `item_id` varchar(50) DEFAULT NULL,
  `item_name` varchar(100) DEFAULT NULL,
  `batch_id` varchar(20) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `bonus_qty` int DEFAULT NULL,
  `dist_rate` double DEFAULT NULL,
  `item_unit` varchar(20) DEFAULT NULL,
  `item_carton` int NOT NULL DEFAULT '0',
  `expiary_date` date DEFAULT NULL,
  `short_note` varchar(255) DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) DEFAULT NULL,
  `ho_status` varchar(2) DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(2) DEFAULT NULL,
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid_depotid_sl` (`cid` DESC,`depot_id` DESC,`sl` DESC),
  KEY `CID_IDATE_STATUS` (`cid` DESC,`issue_date` DESC,`status` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_issue_head` */

DROP TABLE IF EXISTS `sm_issue_head`;

CREATE TABLE `sm_issue_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `depot_id` varchar(50) DEFAULT NULL,
  `depot_name` varchar(100) NOT NULL DEFAULT '',
  `sl` int DEFAULT NULL,
  `store_id` varchar(50) DEFAULT NULL,
  `store_name` varchar(100) DEFAULT NULL,
  `issued_to` varchar(50) DEFAULT NULL,
  `depot_to_name` varchar(100) NOT NULL DEFAULT '',
  `issue_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `issue_process_status` varchar(20) DEFAULT NULL,
  `total_discount` double DEFAULT NULL,
  `transaction_cause` varchar(200) DEFAULT NULL,
  `req_sl` int DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) DEFAULT NULL,
  `ho_status` varchar(2) DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(2) DEFAULT NULL,
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  UNIQUE KEY `cid_depotid_sl` (`cid` DESC,`depot_id` DESC,`sl` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_item` */

DROP TABLE IF EXISTS `sm_item`;

CREATE TABLE `sm_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'SMART',
  `detail_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `item_category` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'REGULAR',
  `status` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'INACTIVE',
  `item_id` varchar(50) DEFAULT NULL,
  `old_item_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `name_bn` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `short_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `des` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `image_path` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `pack_size` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `unit_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'PCS',
  `weight` double DEFAULT '0',
  `company_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `company_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `brand_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `brand_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `type_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `type_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `flavor_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `flavor_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `category_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `category_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
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
  `manufacturer` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `category_id_sp` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `sub_category_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `sub_category_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  UNIQUE KEY `cid_item_id` (`cid` DESC,`item_id` DESC),
  KEY `cid_item_category` (`cid` DESC,`item_category` DESC),
  KEY `cid_item_id_status` (`cid` DESC,`item_id` DESC,`status` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=1026 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_item_archive` */

DROP TABLE IF EXISTS `sm_item_archive`;

CREATE TABLE `sm_item_archive` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `item_id` varchar(50) DEFAULT NULL,
  `old_item_id` varchar(50) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `name_bn` varchar(200) DEFAULT NULL,
  `short_name` varchar(200) DEFAULT NULL,
  `des` varchar(200) DEFAULT NULL,
  `image_path` varchar(200) DEFAULT NULL,
  `pack_size` varchar(50) DEFAULT NULL,
  `unit_type` varchar(50) DEFAULT NULL,
  `company_id` varchar(100) DEFAULT NULL,
  `company_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `brand_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `brand_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `type_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `type_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `flavor_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `flavor_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `ctn_pcs_ratio` int DEFAULT '1',
  `manufacturer` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `item_carton` int DEFAULT '1',
  `item_chain` int DEFAULT '1',
  `sequence_no` int DEFAULT '1',
  `stock_cover_days` int DEFAULT '7',
  `invoice_price` double DEFAULT '0',
  `dist_price` double DEFAULT '0',
  `mrp` double DEFAULT '0',
  `price` double DEFAULT '0',
  `vat_amt` double DEFAULT '0',
  `total_amt` double DEFAULT '0',
  `weight` double DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(200) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(200) DEFAULT NULL,
  `category_id` varchar(50) DEFAULT NULL,
  `category_name` varchar(200) DEFAULT NULL,
  `category_id_sp` varchar(200) DEFAULT NULL,
  `sub_category_id` varchar(50) DEFAULT NULL,
  `sub_category_name` varchar(200) DEFAULT NULL,
  `intr_flag` int DEFAULT '1',
  `detail_name` varchar(100) DEFAULT NULL,
  `item_category` varchar(20) DEFAULT 'REGULAR',
  PRIMARY KEY (`id`),
  UNIQUE KEY `item_id` (`item_id`),
  KEY `cid_item_id_status` (`cid`,`item_id`,`status`),
  KEY `cid` (`cid`,`item_id`),
  KEY `cid_2` (`cid`,`item_category`)
) ENGINE=InnoDB AUTO_INCREMENT=245 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_item_batch` */

DROP TABLE IF EXISTS `sm_item_batch`;

CREATE TABLE `sm_item_batch` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'SMART',
  `item_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `batch_id` varchar(20) DEFAULT NULL,
  `expiary_date` date DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid_item_id_batch_id` (`cid` DESC,`item_id` DESC,`batch_id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=954 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_item_prescription` */

DROP TABLE IF EXISTS `sm_item_prescription`;

CREATE TABLE `sm_item_prescription` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) DEFAULT NULL,
  `item_id` varchar(512) DEFAULT NULL,
  `name` varchar(512) DEFAULT NULL,
  `des` varchar(512) DEFAULT NULL,
  `category_id` varchar(512) DEFAULT NULL,
  `category_id_sp` varchar(512) DEFAULT NULL,
  `unit_type` varchar(512) DEFAULT NULL,
  `manufacturer` varchar(512) DEFAULT NULL,
  `item_carton` int DEFAULT NULL,
  `item_identity` varchar(512) DEFAULT NULL,
  `status` varchar(512) DEFAULT NULL,
  `field1` varchar(512) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_item_process_schedule` */

DROP TABLE IF EXISTS `sm_item_process_schedule`;

CREATE TABLE `sm_item_process_schedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `process_flag` int DEFAULT NULL,
  `item_list_str` longtext,
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_item_temp` */

DROP TABLE IF EXISTS `sm_item_temp`;

CREATE TABLE `sm_item_temp` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `item_id` varchar(10) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `des` varchar(255) DEFAULT NULL,
  `category_id` varchar(20) DEFAULT NULL,
  `category_id_sp` varchar(20) DEFAULT NULL,
  `unit_type` varchar(20) DEFAULT NULL,
  `manufacturer` varchar(50) DEFAULT NULL,
  `item_carton` int NOT NULL DEFAULT '0',
  `price` double DEFAULT NULL,
  `dist_price` double DEFAULT NULL,
  `vat_amt` double DEFAULT NULL,
  `total_amt` double DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `process_flag` int NOT NULL DEFAULT '0',
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_level` */

DROP TABLE IF EXISTS `sm_level`;

CREATE TABLE `sm_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `level_id` varchar(20) DEFAULT NULL,
  `level_name` varchar(100) DEFAULT NULL,
  `parent_level_id` varchar(20) DEFAULT NULL,
  `parent_level_name` varchar(100) DEFAULT NULL,
  `is_leaf` varchar(20) DEFAULT NULL,
  `depth` int DEFAULT NULL,
  `depot_id` varchar(20) DEFAULT NULL,
  `depot_name` varchar(100) DEFAULT NULL,
  `level0` varchar(20) DEFAULT NULL,
  `level0_name` varchar(100) DEFAULT NULL,
  `level1` varchar(20) DEFAULT NULL,
  `level1_name` varchar(100) DEFAULT NULL,
  `level2` varchar(20) DEFAULT NULL,
  `level2_name` varchar(100) DEFAULT NULL,
  `level3` varchar(20) DEFAULT NULL,
  `level3_name` varchar(100) DEFAULT NULL,
  `level4` varchar(20) DEFAULT NULL,
  `level4_name` varchar(100) DEFAULT NULL,
  `level5` varchar(20) DEFAULT NULL,
  `level5_name` varchar(100) DEFAULT NULL,
  `level6` varchar(20) DEFAULT NULL,
  `level6_name` varchar(100) DEFAULT NULL,
  `level7` varchar(20) DEFAULT NULL,
  `level7_name` varchar(100) DEFAULT NULL,
  `level8` varchar(20) DEFAULT NULL,
  `level8_name` varchar(100) DEFAULT NULL,
  `area_id_list` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `territory_des` varchar(100) DEFAULT NULL,
  `special_territory_code` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid_levelid_isleaf` (`cid` DESC,`level_id` DESC,`is_leaf` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=4070 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_linkpath` */

DROP TABLE IF EXISTS `sm_linkpath`;

CREATE TABLE `sm_linkpath` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) DEFAULT NULL,
  `link_name` varchar(512) DEFAULT NULL,
  `link_path` varchar(512) DEFAULT NULL,
  `user_type` varchar(512) DEFAULT NULL,
  `field1` varchar(512) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_login_device` */

DROP TABLE IF EXISTS `sm_login_device`;

CREATE TABLE `sm_login_device` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `user_id` varchar(20) DEFAULT NULL,
  `device_name` varchar(100) DEFAULT NULL,
  `user_agent` varchar(100) DEFAULT NULL,
  `sync_code` varchar(20) DEFAULT NULL,
  `request_ip` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_login_log` */

DROP TABLE IF EXISTS `sm_login_log`;

CREATE TABLE `sm_login_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `user_id` varchar(20) DEFAULT NULL,
  `device_name` varchar(100) DEFAULT NULL,
  `user_agent` varchar(100) DEFAULT NULL,
  `request_ip` varchar(100) DEFAULT NULL,
  `sync_code` varchar(20) DEFAULT '',
  `login_time` datetime DEFAULT NULL,
  `logout_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_userid` (`cid`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=221020 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_mail_mt_report` */

DROP TABLE IF EXISTS `sm_mail_mt_report`;

CREATE TABLE `sm_mail_mt_report` (
  `id` int NOT NULL AUTO_INCREMENT,
  `zone` varchar(20) DEFAULT NULL,
  `territory_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ce_ase` varchar(100) DEFAULT NULL,
  `db_code` varchar(30) DEFAULT NULL,
  `db_name` varchar(200) DEFAULT NULL,
  `brand` varchar(50) DEFAULT NULL,
  `yago_ton` double DEFAULT NULL,
  `pago_ton` double DEFAULT NULL,
  `mtd_ton` double DEFAULT NULL,
  `per_growth_ton` double DEFAULT NULL,
  `pago_gr_per_ton` double DEFAULT NULL,
  `ytd_ton` double DEFAULT NULL,
  `yago_sale` double DEFAULT NULL,
  `pago_sale` double DEFAULT NULL,
  `mtd_sale` double DEFAULT NULL,
  `growth_per_sale` double DEFAULT NULL,
  `pago_gr_per_sale` double DEFAULT NULL,
  `ytd_sale` double DEFAULT NULL,
  `report_date` date DEFAULT NULL,
  `field1` varchar(512) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16245 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_mail_report_viewer` */

DROP TABLE IF EXISTS `sm_mail_report_viewer`;

CREATE TABLE `sm_mail_report_viewer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `report_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `territory_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `sup_type` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `sup_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `sup_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `sup_email` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `status` int DEFAULT '1',
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=467 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_mail_send` */

DROP TABLE IF EXISTS `sm_mail_send`;

CREATE TABLE `sm_mail_send` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mail_info` varchar(200) DEFAULT NULL,
  `mail_to` varchar(50) DEFAULT NULL,
  `mail_cc` varchar(50) DEFAULT NULL,
  `mail_from` varchar(50) DEFAULT NULL,
  `mail_subject` varchar(200) DEFAULT NULL,
  `mail_body` varchar(500) DEFAULT NULL,
  `attachment` varchar(50) DEFAULT NULL,
  `mail_send_date` date DEFAULT NULL,
  `mail_status` int DEFAULT NULL,
  `field1` varchar(512) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_mail_smart_all_report` */

DROP TABLE IF EXISTS `sm_mail_smart_all_report`;

CREATE TABLE `sm_mail_smart_all_report` (
  `id` int NOT NULL AUTO_INCREMENT,
  `zone` varchar(20) DEFAULT NULL,
  `territory_id` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ce_ase` varchar(100) DEFAULT NULL,
  `db_code` varchar(30) DEFAULT NULL,
  `db_name` varchar(200) DEFAULT NULL,
  `brand` varchar(50) DEFAULT NULL,
  `yago_ton` double DEFAULT NULL,
  `pago_ton` double DEFAULT NULL,
  `mtd_ton` double DEFAULT NULL,
  `per_growth_ton` double DEFAULT NULL,
  `pago_gr_per_ton` double DEFAULT NULL,
  `ytd_ton` double DEFAULT NULL,
  `yago_sale` double DEFAULT NULL,
  `pago_sale` double DEFAULT NULL,
  `mtd_sale` double DEFAULT NULL,
  `growth_per_sale` double DEFAULT NULL,
  `pago_gr_per_sale` double DEFAULT NULL,
  `ytd_sale` double DEFAULT NULL,
  `report_date` date DEFAULT NULL,
  `field1` varchar(512) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1237 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_market_day` */

DROP TABLE IF EXISTS `sm_market_day`;

CREATE TABLE `sm_market_day` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `area_id` varchar(20) DEFAULT NULL,
  `area_name` varchar(100) DEFAULT NULL,
  `depot_id` varchar(10) DEFAULT NULL,
  `depot_name` varchar(100) DEFAULT NULL,
  `day_name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_merchandizing_item` */

DROP TABLE IF EXISTS `sm_merchandizing_item`;

CREATE TABLE `sm_merchandizing_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `item_id` varchar(10) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `des` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_microunion` */

DROP TABLE IF EXISTS `sm_microunion`;

CREATE TABLE `sm_microunion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) DEFAULT NULL,
  `microunion_id` varchar(512) DEFAULT NULL,
  `microunion_name` varchar(512) DEFAULT NULL,
  `area_id` varchar(512) DEFAULT '',
  `area_name` varchar(512) DEFAULT '',
  `level0` varchar(512) DEFAULT '',
  `level0_name` varchar(512) DEFAULT '',
  `level1` varchar(512) DEFAULT '',
  `level1_name` varchar(512) DEFAULT '',
  `level2` varchar(512) DEFAULT '',
  `level2_name` varchar(512) DEFAULT '',
  `level3` varchar(512) DEFAULT '',
  `level3_name` varchar(512) DEFAULT '',
  `level4` varchar(512) DEFAULT '',
  `level4_name` varchar(512) DEFAULT '',
  `level5` varchar(512) DEFAULT '',
  `level5_name` varchar(512) DEFAULT '',
  `level6` varchar(512) DEFAULT '',
  `level6_name` varchar(512) DEFAULT '',
  `level7` varchar(512) DEFAULT '',
  `level7_name` varchar(512) DEFAULT '',
  `level8` varchar(512) DEFAULT '',
  `level8_name` varchar(512) DEFAULT '',
  `territory_des` varchar(512) DEFAULT '',
  `field1` varchar(512) DEFAULT NULL,
  `field2` int DEFAULT '0',
  `note` varchar(512) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_mobile_settings` */

DROP TABLE IF EXISTS `sm_mobile_settings`;

CREATE TABLE `sm_mobile_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `s_key` varchar(20) DEFAULT NULL,
  `s_value` varchar(20) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_mobile_settings_pharma` */

DROP TABLE IF EXISTS `sm_mobile_settings_pharma`;

CREATE TABLE `sm_mobile_settings_pharma` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `s_key` varchar(50) DEFAULT NULL,
  `s_value` varchar(20) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_notice` */

DROP TABLE IF EXISTS `sm_notice`;

CREATE TABLE `sm_notice` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `notice_date` datetime DEFAULT NULL,
  `notice` varchar(255) DEFAULT NULL,
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_order` */

DROP TABLE IF EXISTS `sm_order`;

CREATE TABLE `sm_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `vsl` int DEFAULT NULL,
  `depot_id` varchar(50) DEFAULT NULL,
  `depot_name` varchar(100) DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(50) DEFAULT NULL,
  `store_name` varchar(100) DEFAULT NULL,
  `client_id` varchar(20) DEFAULT NULL,
  `client_name` varchar(100) DEFAULT NULL,
  `rep_id` varchar(20) DEFAULT NULL,
  `rep_name` varchar(100) DEFAULT NULL,
  `market_id` varchar(20) DEFAULT NULL,
  `market_name` varchar(100) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `order_datetime` datetime DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `collection_date` date DEFAULT NULL,
  `payment_mode` varchar(20) DEFAULT NULL,
  `area_id` varchar(20) DEFAULT NULL,
  `area_name` varchar(100) DEFAULT NULL,
  `level0_id` varchar(20) DEFAULT NULL,
  `level0_name` varchar(100) DEFAULT NULL,
  `level1_id` varchar(20) DEFAULT NULL,
  `level1_name` varchar(100) DEFAULT NULL,
  `level2_id` varchar(20) DEFAULT NULL,
  `level2_name` varchar(100) DEFAULT NULL,
  `level3_id` varchar(20) DEFAULT NULL,
  `level3_name` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `invoice_ref` int DEFAULT NULL,
  `item_id` varchar(20) DEFAULT NULL,
  `item_name` varchar(100) DEFAULT NULL,
  `category_id` varchar(20) DEFAULT NULL,
  `category_id_sp` varchar(100) DEFAULT NULL,
  `quantity` int DEFAULT '0',
  `bonus_qty` int DEFAULT '0',
  `price` double NOT NULL DEFAULT '0',
  `item_vat` double NOT NULL DEFAULT '0',
  `discount` float DEFAULT '0',
  `ap_discount` float DEFAULT '0',
  `sc_discount` float DEFAULT '0',
  `el_discount` float DEFAULT '0',
  `item_unit` varchar(20) DEFAULT NULL,
  `item_carton` int NOT NULL DEFAULT '0',
  `order_media` varchar(20) DEFAULT NULL,
  `device_user_agent` varchar(50) DEFAULT NULL,
  `ip_ref` varchar(50) DEFAULT NULL,
  `ym_date` varchar(50) DEFAULT NULL,
  `depot_status` varchar(2) DEFAULT NULL,
  `ho_status` varchar(2) DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_data` varchar(2) DEFAULT NULL,
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid_vsl` (`cid` DESC,`vsl` DESC),
  KEY `cid_depot_id_area_id_delivery_date` (`cid` DESC,`depot_id` DESC,`delivery_date` DESC,`area_id` DESC),
  KEY `dump_data` (`cid` DESC,`status` DESC,`order_date` DESC),
  KEY `dump_data2` (`cid` DESC,`sl` DESC),
  KEY `dashboard` (`cid` DESC,`depot_id` DESC,`order_date` DESC,`area_id` DESC,`field1` DESC),
  KEY `cid_depot_sl` (`cid` DESC,`depot_id` DESC,`sl` DESC),
  KEY `cid_delivery_date` (`cid` DESC,`delivery_date` DESC),
  KEY `REP_HISTORY` (`cid` DESC,`rep_id` DESC,`order_date` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=37801724 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_order_head` */

DROP TABLE IF EXISTS `sm_order_head`;

CREATE TABLE `sm_order_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `depot_id` varchar(50) DEFAULT NULL,
  `depot_name` varchar(100) DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(50) DEFAULT NULL,
  `store_name` varchar(100) DEFAULT NULL,
  `client_id` varchar(20) DEFAULT NULL,
  `client_name` varchar(100) DEFAULT NULL,
  `rep_id` varchar(20) DEFAULT NULL,
  `rep_name` varchar(100) DEFAULT NULL,
  `d_man_id` varchar(20) DEFAULT NULL,
  `d_man_name` varchar(100) DEFAULT NULL,
  `market_id` varchar(20) DEFAULT NULL,
  `market_name` varchar(100) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `order_datetime` datetime DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `collection_date` date DEFAULT NULL,
  `payment_mode` varchar(20) DEFAULT NULL,
  `area_id` varchar(20) DEFAULT NULL,
  `area_name` varchar(100) DEFAULT NULL,
  `level0_id` varchar(20) DEFAULT NULL,
  `level0_name` varchar(100) DEFAULT NULL,
  `level1_id` varchar(20) DEFAULT NULL,
  `level1_name` varchar(100) DEFAULT NULL,
  `level2_id` varchar(20) DEFAULT NULL,
  `level2_name` varchar(100) DEFAULT NULL,
  `level3_id` varchar(20) DEFAULT NULL,
  `level3_name` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `invoice_ref` int DEFAULT '0',
  `order_media` varchar(20) DEFAULT NULL,
  `device_user_agent` varchar(50) DEFAULT NULL,
  `ip_ref` varchar(512) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) DEFAULT NULL,
  `ho_status` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT '0',
  `flag_data` varchar(2) DEFAULT NULL,
  `visit_type` varchar(50) DEFAULT NULL,
  `user_type` varchar(20) DEFAULT NULL,
  `mobile_no` varchar(20) DEFAULT NULL,
  `client_cat` varchar(100) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `lat_long` varchar(50) DEFAULT '0',
  `location_detail` varchar(50) NOT NULL DEFAULT '-',
  `last_location` varchar(10) NOT NULL DEFAULT '0',
  `visit_image` varchar(100) NOT NULL DEFAULT '',
  `promo_ref` int NOT NULL DEFAULT '0',
  `rak_list` varchar(200) DEFAULT NULL,
  `rak_image` varchar(200) DEFAULT NULL,
  `gps_flag` varchar(20) DEFAULT NULL,
  `r_flag` int NOT NULL,
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT '0',
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  UNIQUE KEY `cid_depot_id_sl` (`cid` DESC,`depot_id` DESC,`sl` DESC),
  KEY `cid_depotid_sl_storeid_areaid` (`cid` DESC,`depot_id` DESC,`sl` DESC,`store_id` DESC,`area_id` DESC),
  KEY `order_pending` (`cid` DESC,`flag_data` DESC,`field1` DESC),
  KEY `invoice_process` (`cid` DESC,`depot_id` DESC,`delivery_date` DESC,`status` DESC,`flag_data` DESC,`field1` DESC,`field2` DESC),
  KEY `cid_order_date` (`cid` DESC,`order_date` DESC),
  KEY `cid_depot_area_order_Date_field1` (`cid` DESC,`depot_id` DESC,`order_date` DESC,`area_id` DESC,`field1` DESC),
  KEY `order_2_invoice_sch` (`cid` DESC,`order_date` DESC,`status` DESC,`flag_data` DESC,`field1` DESC,`field2` DESC,`depot_id` DESC),
  KEY `cid_delivery_date_status_field1` (`cid` DESC,`delivery_date`,`status` DESC,`field1` DESC),
  KEY `ORDER_MODIFY` (`cid` DESC,`client_id` DESC,`order_date` DESC,`status` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=14557279 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_order_log` */

DROP TABLE IF EXISTS `sm_order_log`;

CREATE TABLE `sm_order_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `json` text,
  `repid` varchar(50) DEFAULT NULL,
  `oder_modify` varchar(50) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `sm_outlet_target` */

DROP TABLE IF EXISTS `sm_outlet_target`;

CREATE TABLE `sm_outlet_target` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `reporting_level_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `reporting_level_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `depot_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `depot_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `rep_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `rep_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `client_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `client_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `brand_id` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `brand_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `item_price` double DEFAULT '0',
  `target_qty` int DEFAULT '0',
  `achievement_qty` int DEFAULT '0',
  `target_amount` double DEFAULT '0',
  `achievement_amount` double DEFAULT '0',
  `ho_status` int DEFAULT '0',
  `depot_status` int DEFAULT '0',
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT NULL,
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(200) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `CID_YM_DATE` (`cid` DESC,`ym_date` DESC),
  KEY `CID_YM_DATE_DEPOT_ID_REP_ID` (`cid` DESC,`ym_date` DESC,`depot_id` DESC,`rep_id` DESC),
  KEY `X_CLIENT_ID` (`cid` DESC,`ym_date` DESC,`depot_id` DESC,`rep_id` DESC,`client_id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=7662623 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_payment_collection` */

DROP TABLE IF EXISTS `sm_payment_collection`;

CREATE TABLE `sm_payment_collection` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `depot_id` varchar(10) DEFAULT NULL,
  `depot_name` varchar(100) DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `head_rowid` int DEFAULT NULL,
  `store_id` varchar(10) DEFAULT NULL,
  `store_name` varchar(100) DEFAULT NULL,
  `order_sl` int DEFAULT NULL,
  `order_datetime` datetime DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `payment_mode` varchar(20) DEFAULT NULL,
  `credit_note` varchar(100) NOT NULL DEFAULT '',
  `payment_type` varchar(20) DEFAULT NULL,
  `client_id` varchar(20) DEFAULT NULL,
  `client_name` varchar(100) DEFAULT NULL,
  `rep_id` varchar(20) DEFAULT NULL,
  `rep_name` varchar(100) DEFAULT NULL,
  `market_id` varchar(20) DEFAULT NULL,
  `market_name` varchar(100) DEFAULT NULL,
  `d_man_id` varchar(20) DEFAULT NULL,
  `d_man_name` varchar(100) DEFAULT NULL,
  `area_id` varchar(20) DEFAULT NULL,
  `area_name` varchar(100) DEFAULT NULL,
  `level0_id` varchar(20) DEFAULT NULL,
  `level0_name` varchar(100) DEFAULT NULL,
  `level1_id` varchar(20) DEFAULT NULL,
  `level1_name` varchar(100) DEFAULT NULL,
  `level2_id` varchar(20) DEFAULT NULL,
  `level2_name` varchar(100) DEFAULT NULL,
  `level3_id` varchar(20) DEFAULT NULL,
  `level3_name` varchar(100) DEFAULT NULL,
  `cl_category_id` varchar(20) DEFAULT '',
  `cl_category_name` varchar(100) DEFAULT '',
  `cl_sub_category_id` varchar(20) DEFAULT '',
  `cl_sub_category_name` varchar(100) DEFAULT '',
  `special_territory_code` varchar(20) DEFAULT '',
  `invoice_date` date DEFAULT NULL,
  `invoice_ym_date` date DEFAULT NULL,
  `collection_date` date DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `collection_batch` varchar(20) DEFAULT NULL,
  `collection_note` varchar(200) DEFAULT NULL,
  `shipment_no` varchar(20) DEFAULT NULL,
  `doc_number` varchar(20) DEFAULT NULL,
  `receipt_description` varchar(200) DEFAULT NULL,
  `transaction_type` varchar(20) DEFAULT NULL,
  `transaction_cause` varchar(200) DEFAULT NULL,
  `collection_flag` int NOT NULL DEFAULT '0',
  `total_inv_amount` double DEFAULT NULL,
  `receivable_amount` double DEFAULT NULL,
  `collection_amount` double DEFAULT NULL,
  `payment_collection_date` date DEFAULT NULL,
  `payment_ym_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `rpt_trans_flag` int NOT NULL DEFAULT '0',
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_depotid_sl` (`cid`,`depot_id`,`sl`)
) ENGINE=InnoDB AUTO_INCREMENT=2250 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_prescription_details` */

DROP TABLE IF EXISTS `sm_prescription_details`;

CREATE TABLE `sm_prescription_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `submit_date` date NOT NULL,
  `first_date` date NOT NULL,
  `submit_by_id` varchar(100) NOT NULL,
  `submit_by_name` varchar(100) NOT NULL,
  `user_type` varchar(100) NOT NULL,
  `area_id` varchar(100) NOT NULL,
  `doctor_id` varchar(100) NOT NULL,
  `doctor_name` varchar(100) NOT NULL,
  `doctor_category` varchar(20) NOT NULL,
  `medicine_id` varchar(100) NOT NULL,
  `medicine_name` varchar(100) DEFAULT NULL,
  `med_type` varchar(50) NOT NULL,
  `brand` varchar(100) NOT NULL,
  `generic` varchar(100) NOT NULL,
  `strength` varchar(100) NOT NULL,
  `formation` varchar(100) NOT NULL,
  `company` varchar(100) NOT NULL,
  `ff_present` int NOT NULL DEFAULT '0',
  `associated_call` int NOT NULL DEFAULT '0',
  `associated_call_others` int NOT NULL DEFAULT '0',
  `update_flag` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`,`sl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_prescription_head` */

DROP TABLE IF EXISTS `sm_prescription_head`;

CREATE TABLE `sm_prescription_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `submit_date` date DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `submit_by_id` varchar(20) DEFAULT NULL,
  `submit_by_name` varchar(100) DEFAULT NULL,
  `user_type` varchar(20) DEFAULT NULL,
  `doctor_id` varchar(20) NOT NULL,
  `doctor_name` varchar(100) DEFAULT NULL,
  `doctor_category` varchar(20) NOT NULL,
  `doctor_speciality` varchar(100) NOT NULL,
  `doctor_degree` varchar(100) NOT NULL,
  `doctor_chamber_address` varchar(200) NOT NULL,
  `thana_id` varchar(100) NOT NULL,
  `thana` varchar(100) NOT NULL,
  `district_id` varchar(100) NOT NULL,
  `district` varchar(100) NOT NULL,
  `image_name` varchar(100) DEFAULT NULL,
  `image_path` varchar(200) DEFAULT NULL,
  `lat_long` varchar(100) DEFAULT NULL,
  `area_id` varchar(20) NOT NULL,
  `area_name` varchar(100) NOT NULL,
  `tl_id` varchar(20) NOT NULL,
  `tl_name` varchar(100) NOT NULL,
  `reg_id` varchar(20) NOT NULL,
  `reg_name` varchar(100) NOT NULL,
  `zone_id` varchar(100) NOT NULL,
  `zone_name` varchar(100) NOT NULL,
  `level2_sup_id` varchar(100) NOT NULL,
  `level2_sup_name` varchar(100) NOT NULL,
  `level1_sup_name` varchar(100) NOT NULL,
  `level1_sup_id` varchar(100) NOT NULL,
  `level0_sup_name` varchar(100) NOT NULL,
  `level0_sup_id` varchar(100) NOT NULL,
  `ff_present` int NOT NULL DEFAULT '0',
  `associated_call` int NOT NULL DEFAULT '0',
  `associated_call_others` int NOT NULL DEFAULT '0',
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  `update_flag` int NOT NULL DEFAULT '0',
  `update_details_flag` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sl` (`sl`),
  KEY `cid` (`cid`,`submit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_product_hierarchy` */

DROP TABLE IF EXISTS `sm_product_hierarchy`;

CREATE TABLE `sm_product_hierarchy` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) DEFAULT NULL,
  `level_id` varchar(512) DEFAULT NULL,
  `level_name` varchar(512) DEFAULT NULL,
  `parent_level_id` varchar(512) DEFAULT NULL,
  `parent_level_name` varchar(512) DEFAULT NULL,
  `level0` varchar(512) DEFAULT NULL,
  `level0_name` varchar(512) DEFAULT NULL,
  `level1` varchar(512) DEFAULT NULL,
  `level1_name` varchar(512) DEFAULT NULL,
  `level2` varchar(512) DEFAULT NULL,
  `level2_name` varchar(512) DEFAULT NULL,
  `level3` varchar(512) DEFAULT NULL,
  `level3_name` varchar(512) DEFAULT NULL,
  `is_leaf` varchar(512) DEFAULT NULL,
  `depth` int DEFAULT NULL,
  `image_path` varchar(200) DEFAULT NULL,
  `field1` varchar(512) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_promo_approved_rate` */

DROP TABLE IF EXISTS `sm_promo_approved_rate`;

CREATE TABLE `sm_promo_approved_rate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `circular_number` varchar(200) DEFAULT NULL,
  `cl_category_id` varchar(20) NOT NULL DEFAULT 'ALL',
  `depot_id` varchar(50) DEFAULT 'ALL',
  `client_id` varchar(50) DEFAULT 'ALL',
  `product_id` varchar(50) DEFAULT 'ALL',
  `depot_name` varchar(100) DEFAULT NULL,
  `client_name` varchar(100) DEFAULT NULL,
  `distributor_id` varchar(100) NOT NULL,
  `product_name` varchar(100) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `brand` varchar(50) NOT NULL,
  `weight` double NOT NULL,
  `bonus_type` varchar(20) DEFAULT NULL,
  `fixed_percent_rate` double DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_clientid_itemid` (`cid`,`client_id`,`product_id`),
  KEY `promo_apply` (`cid`,`cl_category_id`,`depot_id`,`client_id`,`product_id`,`brand`,`weight`,`status`,`from_date`,`to_date`),
  KEY `id` (`id`,`cid`)
) ENGINE=InnoDB AUTO_INCREMENT=318 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_promo_declared_item` */

DROP TABLE IF EXISTS `sm_promo_declared_item`;

CREATE TABLE `sm_promo_declared_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `approved_date` date DEFAULT NULL,
  `product_id` varchar(10) DEFAULT NULL,
  `product_name` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_itemid` (`cid`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_promo_flat_rate` */

DROP TABLE IF EXISTS `sm_promo_flat_rate`;

CREATE TABLE `sm_promo_flat_rate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `campaign_ref` varchar(100) DEFAULT NULL,
  `product_id` varchar(10) DEFAULT NULL,
  `product_name` varchar(100) DEFAULT NULL,
  `mrp` double DEFAULT NULL,
  `tp` double DEFAULT NULL,
  `vat` double DEFAULT NULL,
  `min_qty` int DEFAULT NULL,
  `flat_rate` double DEFAULT NULL,
  `allowed_credit_inv` varchar(5) NOT NULL DEFAULT 'NO',
  `regular_discount_apply` varchar(5) NOT NULL DEFAULT 'NO',
  `allow_bundle` varchar(10) NOT NULL DEFAULT 'NO',
  `status` varchar(20) DEFAULT NULL,
  `field1` varchar(255) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_itemid` (`cid`,`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_promo_gift_bonus_details` */

DROP TABLE IF EXISTS `sm_promo_gift_bonus_details`;

CREATE TABLE `sm_promo_gift_bonus_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `circular_code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_percentage` double DEFAULT NULL,
  `field1` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `circular_code` (`circular_code`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_promo_gift_bonus_head` */

DROP TABLE IF EXISTS `sm_promo_gift_bonus_head`;

CREATE TABLE `sm_promo_gift_bonus_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `circular_code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `circular_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `cl_category_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `target_amount` double DEFAULT '0',
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `circular_code` (`circular_code`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_promo_gift_bonus_item_details` */

DROP TABLE IF EXISTS `sm_promo_gift_bonus_item_details`;

CREATE TABLE `sm_promo_gift_bonus_item_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `circular_code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT '1',
  `field1` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `circular_code` (`circular_code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_promo_product_bonus` */

DROP TABLE IF EXISTS `sm_promo_product_bonus`;

CREATE TABLE `sm_promo_product_bonus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `min_qty` int DEFAULT NULL,
  `circular_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `until_stock_last` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NA',
  `allowed_credit_inv` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NO',
  `regular_discount_apply` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NO',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_promo_product_bonus_bonuses` */

DROP TABLE IF EXISTS `sm_promo_product_bonus_bonuses`;

CREATE TABLE `sm_promo_product_bonus_bonuses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `refrowid` int DEFAULT NULL,
  `circular_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `bonus_product_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bonus_product_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bonus_qty` int DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_refid_itemid` (`cid`,`refrowid`,`bonus_product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_promo_product_bonus_products` */

DROP TABLE IF EXISTS `sm_promo_product_bonus_products`;

CREATE TABLE `sm_promo_product_bonus_products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `refrowid` int DEFAULT NULL,
  `circular_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `product_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_refid_itemid` (`cid`,`refrowid`,`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_promo_regular_discount` */

DROP TABLE IF EXISTS `sm_promo_regular_discount`;

CREATE TABLE `sm_promo_regular_discount` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `min_amount` double DEFAULT NULL,
  `discount_precent` double DEFAULT NULL,
  `discount_amount` double DEFAULT NULL,
  `circular_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_promo_scheme_bonus_item` */

DROP TABLE IF EXISTS `sm_promo_scheme_bonus_item`;

CREATE TABLE `sm_promo_scheme_bonus_item` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'SMART',
  `scheme_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scheme_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `field2` int DEFAULT '0' COMMENT 'SCHEME_ID_INT',
  `field3` int DEFAULT '0' COMMENT 'SCHEME_SLAB_ID_INT',
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `CID_SCHEME_SLAB_IDS` (`cid`,`field2`,`field3`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_promo_scheme_brand` */

DROP TABLE IF EXISTS `sm_promo_scheme_brand`;

CREATE TABLE `sm_promo_scheme_brand` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_id` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `brand_id` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `weight` float DEFAULT NULL,
  `actual_tp` float DEFAULT NULL,
  `discount` float DEFAULT NULL,
  `item_chain` int DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0' COMMENT 'SCHEME_ID_INT',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_2` (`cid`,`scheme_id`,`brand_id`,`weight`,`actual_tp`,`item_chain`),
  KEY `cid` (`cid`,`scheme_id`),
  KEY `Find Brand Weight` (`cid`,`brand_id`,`weight`,`field2`)
) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_promo_scheme_channel` */

DROP TABLE IF EXISTS `sm_promo_scheme_channel`;

CREATE TABLE `sm_promo_scheme_channel` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_id` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `channel_id` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0' COMMENT 'SCHEME_ID_INT',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`,`scheme_id`),
  KEY `cid_2` (`cid`,`scheme_id`,`channel_id`),
  KEY `cid_3` (`cid`,`scheme_id`,`channel_id`),
  KEY `FIND_CHANNEL` (`cid`,`channel_id`,`field2`)
) ENGINE=InnoDB AUTO_INCREMENT=208 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_promo_scheme_client` */

DROP TABLE IF EXISTS `sm_promo_scheme_client`;

CREATE TABLE `sm_promo_scheme_client` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_id` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `client_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0' COMMENT 'SCHEME_ID_INT',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_3` (`cid`,`scheme_id`,`client_id`),
  KEY `cid` (`cid`,`scheme_id`),
  KEY `cid_2` (`cid`,`scheme_id`,`client_id`),
  KEY `Find Client` (`cid`,`client_id`,`field2`)
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_promo_scheme_depot` */

DROP TABLE IF EXISTS `sm_promo_scheme_depot`;

CREATE TABLE `sm_promo_scheme_depot` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_id` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `depot_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0' COMMENT 'SCHEME_ID_INT',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_3` (`cid`,`scheme_id`,`depot_id`),
  KEY `cid` (`cid`,`scheme_id`),
  KEY `FIND_DEPOT` (`cid`,`field2`,`depot_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3491 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_promo_scheme_head` */

DROP TABLE IF EXISTS `sm_promo_scheme_head`;

CREATE TABLE `sm_promo_scheme_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_id` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `status` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `scheme_id` (`scheme_id`,`cid`),
  KEY `cid` (`cid`,`scheme_id`),
  KEY `cid_2` (`cid`,`from_date`,`to_date`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_promo_scheme_item` */

DROP TABLE IF EXISTS `sm_promo_scheme_item`;

CREATE TABLE `sm_promo_scheme_item` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_id` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `item_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0' COMMENT 'SCHEME_ID_INT',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_3` (`cid`,`scheme_id`,`item_id`),
  KEY `cid` (`cid`,`scheme_id`),
  KEY `cid_2` (`cid`,`scheme_id`,`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=422 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_promo_scheme_slab` */

DROP TABLE IF EXISTS `sm_promo_scheme_slab`;

CREATE TABLE `sm_promo_scheme_slab` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_id` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `scheme_slab` int DEFAULT NULL,
  `scheme_value` float DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0' COMMENT 'SCHEME_ID_INT',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_2` (`cid`,`scheme_id`,`scheme_slab`,`scheme_value`,`scheme_type`,`note`),
  KEY `cid` (`cid`,`scheme_id`),
  KEY `Find Slab` (`cid`,`field2`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_promo_special_rate` */

DROP TABLE IF EXISTS `sm_promo_special_rate`;

CREATE TABLE `sm_promo_special_rate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `campaign_ref` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mrp` double DEFAULT NULL,
  `tp` double DEFAULT NULL,
  `vat` double DEFAULT NULL,
  `min_qty` int DEFAULT NULL,
  `special_rate_tp` double DEFAULT NULL,
  `special_rate_vat` double DEFAULT NULL,
  `allowed_credit_inv` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NO',
  `regular_discount_apply` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NO',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_itemid` (`cid`,`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_psr_brand_target` */

DROP TABLE IF EXISTS `sm_psr_brand_target`;

CREATE TABLE `sm_psr_brand_target` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'SMART',
  `ym_date` date DEFAULT NULL,
  `reporting_level_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `reporting_level_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `depot_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rep_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rep_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `brand_id` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `brand_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `route_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `route_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_amount` double DEFAULT '0',
  `achievement_amount` double DEFAULT '0',
  `ho_status` int DEFAULT '0',
  `depot_status` int DEFAULT '0',
  `field1` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `target_api` (`cid` DESC,`ym_date` DESC,`rep_id` DESC),
  KEY `cid_ym_date` (`cid` DESC,`ym_date` DESC),
  KEY `figma` (`cid` DESC,`ym_date` DESC,`depot_id` DESC,`rep_id` DESC,`route_id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=18142 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_rack` */

DROP TABLE IF EXISTS `sm_rack`;

CREATE TABLE `sm_rack` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rack_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rack_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `expiary_date` date DEFAULT NULL,
  `image_path` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid_status_issue_date_expiary_date` (`cid` DESC,`status` DESC,`issue_date` DESC,`expiary_date` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_rack_movement_log` */

DROP TABLE IF EXISTS `sm_rack_movement_log`;

CREATE TABLE `sm_rack_movement_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rack_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rack_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rack_code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rack_url` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_r_condition` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `expiary_date` date DEFAULT NULL,
  `field1` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT '0',
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=246 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_receive` */

DROP TABLE IF EXISTS `sm_receive`;

CREATE TABLE `sm_receive` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '-',
  `sl` bigint DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receive_from` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_from_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '-',
  `receive_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receive_process_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_discount` double DEFAULT NULL,
  `transaction_cause` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ref_sl` int DEFAULT NULL,
  `item_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `bonus_qty` int DEFAULT '0',
  `dist_rate` double DEFAULT NULL,
  `item_unit` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_carton` int NOT NULL DEFAULT '0',
  `expiary_date` date DEFAULT NULL,
  `short_note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `ho_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `flag_depot_stock` int DEFAULT '0',
  `flag_depot_stock_balance` int DEFAULT '0',
  `flag_data` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid_depotid_sl_storeid_itemid_batchid` (`cid` DESC,`depot_id` DESC,`sl` DESC,`store_id` DESC,`item_id` DESC,`batch_id` DESC),
  KEY `cid_depotid_sl` (`cid` DESC,`depot_id` DESC,`sl` DESC),
  KEY `CID_RDATE_STATUS` (`cid` DESC,`receive_date` DESC,`status` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=652757 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_receive_head` */

DROP TABLE IF EXISTS `sm_receive_head`;

CREATE TABLE `sm_receive_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sl` bigint DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receive_from` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendor_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendor_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_from_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `receive_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receive_process_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_discount` double DEFAULT NULL,
  `transaction_cause` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ref_sl` int DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  UNIQUE KEY `cid_depotid_sl` (`cid` DESC,`depot_id` DESC,`sl` DESC),
  KEY `cid_depotid_sl_storeid` (`cid` DESC,`depot_id` DESC,`sl` DESC,`store_id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=79293 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_rep` */

DROP TABLE IF EXISTS `sm_rep`;

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
  `sync_flag` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_data` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  UNIQUE KEY `CID_REP_ID` (`cid` DESC,`rep_id` DESC),
  KEY `CID_REP_ID_MOBILE` (`cid` DESC,`rep_id` DESC,`mobile_no` DESC),
  KEY `CID_REP_ID_PASSWORD_STATUS_SYNC_CODE_NOTE` (`cid` DESC,`rep_id` DESC,`password` DESC,`status` DESC,`sync_code` DESC,`note` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=576 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_rep_area` */

DROP TABLE IF EXISTS `sm_rep_area`;

CREATE TABLE `sm_rep_area` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_category` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid_rep_id_area_id` (`cid` DESC,`rep_id` DESC,`area_id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=3889 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_rep_daily_visit_plan` */

DROP TABLE IF EXISTS `sm_rep_daily_visit_plan`;

CREATE TABLE `sm_rep_daily_visit_plan` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) NOT NULL DEFAULT 'SMART',
  `order_date` date DEFAULT NULL,
  `rep_id` varchar(50) DEFAULT NULL,
  `area_id` varchar(50) DEFAULT NULL,
  `client_id` varchar(50) DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `route_plan` varchar(3) DEFAULT NULL,
  `w1` varchar(3) DEFAULT NULL,
  `w2` varchar(3) DEFAULT NULL,
  `w3` varchar(3) DEFAULT NULL,
  `w4` varchar(3) DEFAULT NULL,
  `w5` varchar(3) DEFAULT NULL,
  `sat` varchar(3) DEFAULT NULL,
  `sun` varchar(3) DEFAULT NULL,
  `mon` varchar(3) DEFAULT NULL,
  `tue` varchar(3) DEFAULT NULL,
  `wed` varchar(3) DEFAULT NULL,
  `thu` varchar(3) DEFAULT NULL,
  `fri` varchar(3) DEFAULT NULL,
  `seq_no` int DEFAULT NULL,
  `status` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'ADMIN',
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'ADMIN',
  PRIMARY KEY (`id` DESC),
  KEY `CID_ORDER_DATE` (`cid` DESC,`order_date` DESC),
  KEY `CID_ORDER_DATE_REP_ID` (`cid` DESC,`order_date` DESC,`rep_id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=15833733 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_report` */

DROP TABLE IF EXISTS `sm_report`;

CREATE TABLE `sm_report` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT 'SMART',
  `category` varchar(100) DEFAULT '-',
  `name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '-',
  `desc` longtext,
  `h_columns` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT 'hidden',
  `t_columns` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT 'tree',
  `p_columns` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT 'pivot',
  `c_columns` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT 'sum',
  `a_columns` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT 'averege',
  `f_columns` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT 'filter',
  `status` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'ACTIVE',
  `field1` varchar(200) DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) DEFAULT '-',
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT '-',
  PRIMARY KEY (`id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_report_user_mapping` */

DROP TABLE IF EXISTS `sm_report_user_mapping`;

CREATE TABLE `sm_report_user_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) DEFAULT 'SMART',
  `report_id` int DEFAULT NULL,
  `user_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `user_type` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `user_email` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '-',
  `status` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'ACTIVE',
  `field1` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_requisition` */

DROP TABLE IF EXISTS `sm_requisition`;

CREATE TABLE `sm_requisition` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sl` int DEFAULT NULL,
  `requisition_to` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_to_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `req_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `req_process_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `dist_rate` double DEFAULT NULL,
  `short_note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_data` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_depotid_sl_itemid` (`cid`,`depot_id`,`sl`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_requisition_head` */

DROP TABLE IF EXISTS `sm_requisition_head`;

CREATE TABLE `sm_requisition_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sl` int DEFAULT NULL,
  `requisition_to` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_to_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `req_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `req_process_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_data` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid_depotid_sl` (`cid`,`depot_id`,`sl`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_restricted_item` */

DROP TABLE IF EXISTS `sm_restricted_item`;

CREATE TABLE `sm_restricted_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_cat` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `dist_price` double NOT NULL DEFAULT '0',
  `retail_price` double NOT NULL DEFAULT '0',
  `item_qty` int DEFAULT NULL,
  `auto_voucher` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_return` */

DROP TABLE IF EXISTS `sm_return`;

CREATE TABLE `sm_return` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rep_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `market_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `market_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `d_man_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '-',
  `d_man_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '-',
  `shipment_no` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `invoice_ym_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `ret_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Bounce',
  `order_sl` int DEFAULT '0',
  `invoice_sl` int DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `level0_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `cl_category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `cl_sub_category_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `cl_sub_category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `special_territory_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_media` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'WEB',
  `device_user_agent` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `ip_ref` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `discount` double DEFAULT '0',
  `item_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actual_tp` double NOT NULL DEFAULT '0',
  `actual_vat` double NOT NULL DEFAULT '0',
  `quantity` int DEFAULT NULL,
  `bonus_qty` int DEFAULT NULL,
  `mr_qty` int DEFAULT NULL,
  `replacement_qty` int DEFAULT NULL,
  `price` double DEFAULT NULL,
  `item_vat` double NOT NULL DEFAULT '0',
  `item_unit` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_carton` int NOT NULL DEFAULT '0',
  `inv_promotion_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '-',
  `inv_bonus_applied_on_qty` int NOT NULL DEFAULT '0',
  `inv_circular_no` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '-',
  `discount_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '-',
  `item_discount` double NOT NULL DEFAULT '0',
  `inv_item_discount_percent` double NOT NULL DEFAULT '0',
  `inv_discount_type_quantity` int NOT NULL DEFAULT '0',
  `return_item_discount` double NOT NULL DEFAULT '0',
  `ret_discount_type_quantity` int NOT NULL DEFAULT '0',
  `short_note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `inv_quantity` int NOT NULL DEFAULT '0',
  `inv_bonus_qty` int NOT NULL DEFAULT '0',
  `inv_price` double NOT NULL DEFAULT '0',
  `inv_item_vat` double NOT NULL DEFAULT '0',
  `prev_return_qty` int NOT NULL DEFAULT '0',
  `prev_return_bonus_qty` int NOT NULL DEFAULT '0',
  `inv_discount` double NOT NULL DEFAULT '0',
  `prev_return_discount` double NOT NULL DEFAULT '0',
  `invdet_rowid` int NOT NULL DEFAULT '0',
  `sp_discount_item` double NOT NULL DEFAULT '0',
  `inv_sp_discount_item` double NOT NULL DEFAULT '0',
  `prev_return_sp_discount_item` double NOT NULL DEFAULT '0',
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `ho_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `returned_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `returned_on` datetime DEFAULT NULL,
  `msoCategory` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '-',
  `itembaseGroup` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '-',
  `field1` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `cid_depotid_sl_itemid_storeid` (`cid` DESC,`depot_id` DESC,`sl` DESC,`item_id` DESC,`store_id` DESC),
  KEY `CID_RDATE_STATUS` (`cid` DESC,`return_date` DESC,`status` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=34977 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_return_approved` */

DROP TABLE IF EXISTS `sm_return_approved`;

CREATE TABLE `sm_return_approved` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_man_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_man_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipment_no` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `invoice_ym_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `ret_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_sl` int DEFAULT NULL,
  `invoice_sl` int DEFAULT NULL,
  `neg_invoice_sl` int DEFAULT NULL,
  `area_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_sub_category_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_sub_category_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `special_territory_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_media` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_user_agent` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip_ref` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount` double DEFAULT NULL,
  `item_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actual_tp` double DEFAULT NULL,
  `actual_vat` double DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `bonus_qty` int DEFAULT NULL,
  `price` double DEFAULT NULL,
  `item_vat` double DEFAULT NULL,
  `item_unit` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_carton` int DEFAULT NULL,
  `inv_promotion_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `inv_bonus_applied_on_qty` int DEFAULT NULL,
  `inv_circular_no` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_discount` double DEFAULT NULL,
  `inv_item_discount_percent` double DEFAULT NULL,
  `inv_discount_type_quantity` int DEFAULT NULL,
  `return_item_discount` double DEFAULT NULL,
  `ret_discount_type_quantity` int DEFAULT NULL,
  `short_note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `inv_quantity` int DEFAULT NULL,
  `inv_bonus_qty` int DEFAULT NULL,
  `inv_price` double DEFAULT NULL,
  `inv_item_vat` double DEFAULT NULL,
  `prev_return_qty` int DEFAULT NULL,
  `prev_return_bonus_qty` int DEFAULT NULL,
  `inv_discount` double DEFAULT NULL,
  `prev_return_discount` double DEFAULT NULL,
  `invdet_rowid` int DEFAULT NULL,
  `sp_discount_item` double DEFAULT NULL,
  `inv_sp_discount_item` double DEFAULT NULL,
  `prev_return_sp_discount_item` double DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `returned_on` datetime DEFAULT NULL,
  `returned_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `msoCategory` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `itembaseGroup` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_return_cancel` */

DROP TABLE IF EXISTS `sm_return_cancel`;

CREATE TABLE `sm_return_cancel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sl` int DEFAULT NULL,
  `store_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `market_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `market_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `d_man_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `d_man_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `shipment_no` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `invoice_ym_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `ret_reason` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `order_sl` int DEFAULT NULL,
  `invoice_sl` int DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level0_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `cl_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `cl_sub_category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `cl_sub_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `special_territory_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_media` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_user_agent` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip_ref` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount` double DEFAULT NULL,
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actual_tp` double NOT NULL DEFAULT '0',
  `actual_vat` double NOT NULL DEFAULT '0',
  `quantity` int DEFAULT NULL,
  `bonus_qty` int DEFAULT NULL,
  `price` double DEFAULT NULL,
  `item_vat` double NOT NULL DEFAULT '0',
  `item_unit` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_carton` int NOT NULL DEFAULT '0',
  `inv_promotion_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `inv_bonus_applied_on_qty` int NOT NULL DEFAULT '0',
  `inv_circular_no` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `discount_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item_discount` double NOT NULL DEFAULT '0',
  `inv_item_discount_percent` double NOT NULL DEFAULT '0',
  `inv_discount_type_quantity` int NOT NULL DEFAULT '0',
  `return_item_discount` double NOT NULL DEFAULT '0',
  `ret_discount_type_quantity` int NOT NULL DEFAULT '0',
  `short_note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `inv_quantity` int NOT NULL DEFAULT '0',
  `inv_bonus_qty` int NOT NULL DEFAULT '0',
  `inv_price` double NOT NULL DEFAULT '0',
  `inv_item_vat` double NOT NULL DEFAULT '0',
  `prev_return_qty` int NOT NULL DEFAULT '0',
  `prev_return_bonus_qty` int NOT NULL DEFAULT '0',
  `inv_discount` double NOT NULL DEFAULT '0',
  `prev_return_discount` double NOT NULL DEFAULT '0',
  `invdet_rowid` int NOT NULL DEFAULT '0',
  `sp_discount_item` double NOT NULL DEFAULT '0',
  `inv_sp_discount_item` double NOT NULL DEFAULT '0',
  `prev_return_sp_discount_item` double NOT NULL DEFAULT '0',
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `returned_on` datetime DEFAULT NULL,
  `returned_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_depotid_sl_itemid_storeid` (`cid`,`depot_id`,`sl`,`item_id`,`store_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_return_head` */

DROP TABLE IF EXISTS `sm_return_head`;

CREATE TABLE `sm_return_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `market_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `market_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `d_man_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_man_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipment_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `invoice_date` date DEFAULT NULL,
  `invoice_ym_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `ret_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Bounce',
  `order_sl` int DEFAULT '0',
  `invoice_sl` int DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `level0_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_sub_category_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `cl_sub_category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `special_territory_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_media` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'WEB',
  `device_user_agent` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `ip_ref` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `inv_actual_total_tp` double NOT NULL DEFAULT '0',
  `inv_regular_disc_tp` double NOT NULL DEFAULT '0',
  `inv_flat_disc_tp` double NOT NULL DEFAULT '0',
  `inv_approved_disc_tp` double NOT NULL DEFAULT '0',
  `inv_others_disc_tp` double NOT NULL DEFAULT '0',
  `inv_no_disc_tp` double NOT NULL DEFAULT '0',
  `ret_actual_total_tp` double NOT NULL DEFAULT '0',
  `ret_regular_disc_tp` double NOT NULL DEFAULT '0',
  `ret_flat_disc_tp` double NOT NULL DEFAULT '0',
  `ret_approved_disc_tp` double NOT NULL DEFAULT '0',
  `ret_others_disc_tp` double NOT NULL DEFAULT '0',
  `total_amount` double NOT NULL DEFAULT '0',
  `vat_total_amount` double NOT NULL DEFAULT '0',
  `discount` double DEFAULT NULL,
  `inv_vat_total_amount` double NOT NULL DEFAULT '0',
  `inv_discount` double NOT NULL DEFAULT '0',
  `inv_discount_precent` double NOT NULL DEFAULT '0',
  `prev_return_discount` double NOT NULL DEFAULT '0',
  `sp_discount` double NOT NULL DEFAULT '0',
  `ret_sp_flat` double NOT NULL DEFAULT '0',
  `ret_sp_approved` double NOT NULL DEFAULT '0',
  `ret_sp_others` double NOT NULL DEFAULT '0',
  `inv_sp_discount` double NOT NULL DEFAULT '0',
  `prev_return_sp_discount` double NOT NULL DEFAULT '0',
  `inv_sp_flat` double NOT NULL DEFAULT '0',
  `inv_sp_approved` double NOT NULL DEFAULT '0',
  `inv_sp_others` double NOT NULL DEFAULT '0',
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `ho_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `rpt_trans_flag` int NOT NULL DEFAULT '0',
  `returned_by` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `returned_on` datetime DEFAULT NULL,
  `field1` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  UNIQUE KEY `cid_depot_id_sl` (`cid` DESC,`depot_id` DESC,`sl` DESC),
  KEY `cid_depot_id_invoice_sl` (`cid` DESC,`depot_id` DESC,`invoice_sl` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=5406 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_return_head_approved` */

DROP TABLE IF EXISTS `sm_return_head_approved`;

CREATE TABLE `sm_return_head_approved` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_man_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_man_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipment_no` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `invoice_ym_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `ret_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_sl` int DEFAULT NULL,
  `invoice_sl` int DEFAULT NULL,
  `neg_invoice_sl` int DEFAULT NULL,
  `area_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_sub_category_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_sub_category_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `special_territory_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_media` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_user_agent` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip_ref` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `inv_actual_total_tp` double DEFAULT NULL,
  `inv_regular_disc_tp` double DEFAULT NULL,
  `inv_flat_disc_tp` double DEFAULT NULL,
  `inv_approved_disc_tp` double DEFAULT NULL,
  `inv_others_disc_tp` double DEFAULT NULL,
  `inv_no_disc_tp` double DEFAULT NULL,
  `ret_actual_total_tp` double DEFAULT NULL,
  `ret_regular_disc_tp` double DEFAULT NULL,
  `ret_flat_disc_tp` double DEFAULT NULL,
  `ret_approved_disc_tp` double DEFAULT NULL,
  `ret_others_disc_tp` double DEFAULT NULL,
  `total_amount` double DEFAULT NULL,
  `vat_total_amount` double DEFAULT NULL,
  `discount` double DEFAULT NULL,
  `inv_vat_total_amount` double DEFAULT NULL,
  `inv_discount` double DEFAULT NULL,
  `inv_discount_precent` double DEFAULT NULL,
  `prev_return_discount` double DEFAULT NULL,
  `sp_discount` double DEFAULT NULL,
  `ret_sp_flat` double DEFAULT NULL,
  `ret_sp_approved` double DEFAULT NULL,
  `ret_sp_others` double DEFAULT NULL,
  `inv_sp_discount` double DEFAULT NULL,
  `prev_return_sp_discount` double DEFAULT NULL,
  `inv_sp_flat` double DEFAULT NULL,
  `inv_sp_approved` double DEFAULT NULL,
  `inv_sp_others` double DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rpt_trans_flag` int DEFAULT NULL,
  `returned_on` datetime DEFAULT NULL,
  `returned_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_rpt_transaction` */

DROP TABLE IF EXISTS `sm_rpt_transaction`;

CREATE TABLE `sm_rpt_transaction` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `inv_rowid` int DEFAULT NULL,
  `inv_sl` int DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `transaction_type` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `transaction_ref` int NOT NULL DEFAULT '0',
  `transaction_ref_date` date DEFAULT NULL,
  `trans_net_amt` double DEFAULT NULL,
  `tp_amt` double DEFAULT NULL,
  `vat_amt` double DEFAULT NULL,
  `disc_amt` double DEFAULT NULL,
  `spdisc_amt` double DEFAULT NULL,
  `adjust_amount` double DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `payment_mode` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `credit_note` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_sub_category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_sub_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_limit_amt` double DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_man_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_man_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipment_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_depot_store_headrow_trdate` (`cid`,`depot_id`,`store_id`,`inv_rowid`,`transaction_date`),
  KEY `invoice_process` (`cid`,`depot_id`,`inv_sl`,`transaction_type`)
) ENGINE=InnoDB AUTO_INCREMENT=5578735 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_rpt_transaction_log` */

DROP TABLE IF EXISTS `sm_rpt_transaction_log`;

CREATE TABLE `sm_rpt_transaction_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rpt_row_id` int NOT NULL DEFAULT '0',
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `inv_rowid` int DEFAULT NULL,
  `inv_sl` int DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `transaction_type` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `transaction_ref` int NOT NULL DEFAULT '0',
  `transaction_ref_date` date DEFAULT NULL,
  `trans_net_amt` double DEFAULT NULL,
  `tp_amt` double DEFAULT NULL,
  `vat_amt` double DEFAULT NULL,
  `disc_amt` double DEFAULT NULL,
  `spdisc_amt` double DEFAULT NULL,
  `adjust_amount` double DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `payment_mode` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `credit_note` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_sub_category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_sub_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_limit_amt` double DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_man_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_man_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipment_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_depot_store_headrow_trdate` (`cid`,`depot_id`,`store_id`,`inv_rowid`,`transaction_date`),
  KEY `forreport` (`cid`,`depot_id`,`transaction_date`,`store_id`),
  KEY `cid` (`cid`,`depot_id`,`inv_sl`,`transaction_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_sample_submit` */

DROP TABLE IF EXISTS `sm_sample_submit`;

CREATE TABLE `sm_sample_submit` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `doctor_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `submit_date` datetime DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `price` double DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_search_date` */

DROP TABLE IF EXISTS `sm_search_date`;

CREATE TABLE `sm_search_date` (
  `id` int NOT NULL AUTO_INCREMENT,
  `from_dt` date DEFAULT NULL,
  `to_dt` date DEFAULT NULL,
  `from_date` datetime DEFAULT NULL,
  `to_date` datetime DEFAULT NULL,
  `from_dt_2` date DEFAULT NULL,
  `to_dt_2` date DEFAULT NULL,
  `from_dt_3` date DEFAULT NULL,
  `to_dt_3` date DEFAULT NULL,
  `from_dt_4` date DEFAULT NULL,
  `to_dt_4` date DEFAULT NULL,
  `from_dt_5` date DEFAULT NULL,
  `to_dt_5` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_settings` */

DROP TABLE IF EXISTS `sm_settings`;

CREATE TABLE `sm_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `s_key` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `s_value` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_keyname` (`cid`,`s_key`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_settings_pharma` */

DROP TABLE IF EXISTS `sm_settings_pharma`;

CREATE TABLE `sm_settings_pharma` (
  `id` int NOT NULL,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `s_key` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `s_value` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_stock_ledger` */

DROP TABLE IF EXISTS `sm_stock_ledger`;

CREATE TABLE `sm_stock_ledger` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `transaction_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `item_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT '0',
  `bonus_qty` int DEFAULT '0',
  `replacement_qty` int DEFAULT '0',
  `field1` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE_SL_ITEM` (`cid`,`depot_id`,`sl`,`item_id`),
  KEY `CID_DEPOT_ID_SL` (`cid`,`depot_id`,`sl`)
) ENGINE=InnoDB AUTO_INCREMENT=7010964 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_sup_depot` */

DROP TABLE IF EXISTS `sm_sup_depot`;

CREATE TABLE `sm_sup_depot` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sup_depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_bn` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_2` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_bn` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sequence_no` int DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_supervisor_level` */

DROP TABLE IF EXISTS `sm_supervisor_level`;

CREATE TABLE `sm_supervisor_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sup_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sup_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_depth_no` int DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `CID_LEVEL_ID_LEVEL_DEPTH_NO` (`sup_id` DESC,`level_id` DESC,`level_depth_no` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=406 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_target` */

DROP TABLE IF EXISTS `sm_target`;

CREATE TABLE `sm_target` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'SMART',
  `ym_date` date DEFAULT NULL,
  `reporting_level_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `reporting_level_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `depot_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rep_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rep_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `route_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `route_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_amount` double DEFAULT '0',
  `achievement_amount` double DEFAULT '0',
  `ho_status` int DEFAULT '0',
  `depot_status` int DEFAULT '0',
  `field1` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `target_api` (`cid` DESC,`ym_date` DESC,`rep_id` DESC),
  KEY `cid_ym_date` (`cid` DESC,`ym_date` DESC),
  KEY `figma` (`cid` DESC,`ym_date` DESC,`depot_id` DESC,`rep_id` DESC,`route_id` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=6772 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_target_setup` */

DROP TABLE IF EXISTS `sm_target_setup`;

CREATE TABLE `sm_target_setup` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `ym_date_m1` date DEFAULT NULL,
  `ym_date_m2` date DEFAULT NULL,
  `ym_date_m3` date DEFAULT NULL,
  `target_amount` float DEFAULT '0',
  `field1` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `field2` int DEFAULT '0',
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '-',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  UNIQUE KEY `CID_YM_DATE` (`cid` DESC,`ym_date` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_temp_report` */

DROP TABLE IF EXISTS `sm_temp_report`;

CREATE TABLE `sm_temp_report` (
  `id` int NOT NULL,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `month_date` date DEFAULT NULL,
  `process_key` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tl_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tl_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mpo_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mpo_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `m1_amt` double DEFAULT '0',
  `m2_amt` double DEFAULT '0',
  `m1_order_count` int DEFAULT '0',
  `m2_order_count` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_temp_report_process` */

DROP TABLE IF EXISTS `sm_temp_report_process`;

CREATE TABLE `sm_temp_report_process` (
  `id` int NOT NULL,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `month_1` date DEFAULT NULL,
  `month_2` date DEFAULT NULL,
  `process_key` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status_flag` int DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_top_level` */

DROP TABLE IF EXISTS `sm_top_level`;

CREATE TABLE `sm_top_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) DEFAULT NULL,
  `level_id` varchar(512) DEFAULT NULL,
  `level_name` varchar(512) DEFAULT NULL,
  `parent_level_id` varchar(512) DEFAULT NULL,
  `parent_level_name` varchar(512) DEFAULT NULL,
  `level0` varchar(512) DEFAULT NULL,
  `level0_name` varchar(512) DEFAULT NULL,
  `level1` varchar(512) DEFAULT NULL,
  `level1_name` varchar(512) DEFAULT NULL,
  `level2` varchar(512) DEFAULT NULL,
  `level2_name` varchar(512) DEFAULT NULL,
  `level3` varchar(512) DEFAULT NULL,
  `level3_name` varchar(512) DEFAULT NULL,
  `is_leaf` varchar(512) DEFAULT NULL,
  `depth` int DEFAULT NULL,
  `image_path` varchar(200) DEFAULT NULL,
  `field1` varchar(512) DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `CID_LEVEL3` (`cid` DESC,`level3` DESC),
  KEY `CID_IS_LEAF` (`cid` DESC,`is_leaf` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=198 DEFAULT CHARSET=utf8mb3;

/*Table structure for table `sm_tp_rules_temp_process` */

DROP TABLE IF EXISTS `sm_tp_rules_temp_process`;

CREATE TABLE `sm_tp_rules_temp_process` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `order_datetime` datetime DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `payment_mode` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_media` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `client_cat` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `bonus_qty` int DEFAULT '0',
  `price` double DEFAULT '0',
  `item_vat` double DEFAULT '0',
  `item_unit` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_carton` int NOT NULL DEFAULT '0',
  `item_flag` int DEFAULT NULL,
  `prio_flag` int NOT NULL DEFAULT '0',
  `ar_flag` int DEFAULT NULL,
  `pb_flag` int DEFAULT NULL,
  `sr_flag` int DEFAULT NULL,
  `fr_flag` int DEFAULT NULL,
  `di_flag` int DEFAULT NULL,
  `rd_flag` int DEFAULT NULL,
  `discount` double DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cid_depotid_sl_itemid` (`cid`,`depot_id`,`sl`,`item_id`),
  KEY `cid_depot_sl` (`cid`,`depot_id`,`sl`)
) ENGINE=InnoDB AUTO_INCREMENT=11455249 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_tp_rules_temp_process_manual` */

DROP TABLE IF EXISTS `sm_tp_rules_temp_process_manual`;

CREATE TABLE `sm_tp_rules_temp_process_manual` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `order_datetime` datetime DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `payment_mode` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_media` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `client_cat` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actual_tp` double NOT NULL DEFAULT '0',
  `actual_vat` double NOT NULL DEFAULT '0',
  `quantity` int DEFAULT NULL,
  `bonus_qty` int DEFAULT '0',
  `mr_qty` int DEFAULT '0',
  `replacement_qty` int DEFAULT '0',
  `price` double DEFAULT NULL,
  `item_vat` double DEFAULT NULL,
  `item_unit` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_carton` int NOT NULL DEFAULT '0',
  `item_flag` int DEFAULT NULL,
  `prio_flag` int NOT NULL DEFAULT '0',
  `ar_flag` int DEFAULT NULL,
  `pb_flag` int DEFAULT NULL,
  `sr_flag` int DEFAULT NULL,
  `fr_flag` int DEFAULT NULL,
  `di_flag` int DEFAULT NULL,
  `rd_flag` int DEFAULT NULL,
  `discount` float DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cid_depotid_sl_itemid` (`cid`,`depot_id`,`sl`,`item_id`),
  KEY `re_process` (`cid`,`depot_id`,`sl`)
) ENGINE=InnoDB AUTO_INCREMENT=780547 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_tp_rules_temp_return` */

DROP TABLE IF EXISTS `sm_tp_rules_temp_return`;

CREATE TABLE `sm_tp_rules_temp_return` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `return_sl` int DEFAULT NULL,
  `invoice_sl` int DEFAULT NULL,
  `ret_rowid` int DEFAULT NULL,
  `store_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `payment_mode` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `inv_discount` double DEFAULT NULL,
  `prev_return_discount` double DEFAULT NULL,
  `promo_ref` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actual_tp` double NOT NULL DEFAULT '0',
  `actual_vat` double NOT NULL DEFAULT '0',
  `ret_price` double DEFAULT NULL,
  `ret_item_vat` double DEFAULT NULL,
  `inv_price` double DEFAULT NULL,
  `inv_item_vat` double DEFAULT NULL,
  `item_flag` int DEFAULT NULL,
  `prio_flag` int DEFAULT NULL,
  `ar_flag` int DEFAULT NULL,
  `pb_flag` int DEFAULT NULL,
  `sr_flag` int DEFAULT NULL,
  `fr_flag` int DEFAULT NULL,
  `di_flag` int DEFAULT NULL,
  `rd_flag` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_tp_rules_temp_return_invoice` */

DROP TABLE IF EXISTS `sm_tp_rules_temp_return_invoice`;

CREATE TABLE `sm_tp_rules_temp_return_invoice` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `return_sl` int DEFAULT NULL,
  `invoice_sl` int DEFAULT NULL,
  `ret_rowid` int DEFAULT NULL,
  `discount` double DEFAULT NULL,
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `bonus_qty` int NOT NULL DEFAULT '0',
  `price` double DEFAULT NULL,
  `item_vat` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_tpcp_rules` */

DROP TABLE IF EXISTS `sm_tpcp_rules`;

CREATE TABLE `sm_tpcp_rules` (
  `id` int NOT NULL,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `campaign_ref` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_cat` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `for_any_item` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_amt_qty` int DEFAULT NULL,
  `to_amt_qty` int DEFAULT NULL,
  `bonus_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `b_item_id1` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `b_item_name1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `b_item_qty1` int DEFAULT NULL,
  `b_item_id2` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `b_item_name2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `b_item_qty2` int DEFAULT NULL,
  `b_item_id3` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `b_item_name3` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `b_item_qty3` int DEFAULT NULL,
  `disc_amt_per` int DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_tracking_table` */

DROP TABLE IF EXISTS `sm_tracking_table`;

CREATE TABLE `sm_tracking_table` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `longitude` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tracking_on` datetime DEFAULT NULL,
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=231 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_transaction` */

DROP TABLE IF EXISTS `sm_transaction`;

CREATE TABLE `sm_transaction` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `txid` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tx_date` datetime DEFAULT NULL,
  `tx_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tx_account` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `opposite_account` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tx_op_balance` double DEFAULT NULL,
  `tx_amount` double DEFAULT NULL,
  `tx_closing_balance` double DEFAULT NULL,
  `tx_des` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sales_type` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `row_flag` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_acc_opacc` (`cid`,`tx_account`,`opposite_account`)
) ENGINE=InnoDB AUTO_INCREMENT=87687 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_transaction_dispute` */

DROP TABLE IF EXISTS `sm_transaction_dispute`;

CREATE TABLE `sm_transaction_dispute` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issu_sl` int DEFAULT NULL,
  `recieve_sl` int DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dispute_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issued_quantity` int NOT NULL DEFAULT '0',
  `recieved_quantity` int NOT NULL DEFAULT '0',
  `issued_bonus_qty` int NOT NULL DEFAULT '0',
  `recieved_bonus_qty` int NOT NULL DEFAULT '0',
  `quantity` int DEFAULT NULL,
  `bonus_qty` int DEFAULT '0',
  `price` double DEFAULT NULL,
  `item_unit` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_carton` int NOT NULL DEFAULT '0',
  `expiary_date` date DEFAULT NULL,
  `dispute_date` date DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=352 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_transaction_dispute_head` */

DROP TABLE IF EXISTS `sm_transaction_dispute_head`;

CREATE TABLE `sm_transaction_dispute_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dispute_date` date DEFAULT NULL,
  `issu_sl` int DEFAULT NULL,
  `recieve_sl` int DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dispute_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_unit` */

DROP TABLE IF EXISTS `sm_unit`;

CREATE TABLE `sm_unit` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_updatelog` */

DROP TABLE IF EXISTS `sm_updatelog`;

CREATE TABLE `sm_updatelog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tbl_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ref_id` int DEFAULT NULL,
  `details` longtext COLLATE utf8mb4_unicode_ci,
  `update_date` date DEFAULT NULL,
  `notification_flag` int DEFAULT NULL,
  `field1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=385 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_vat_01` */

DROP TABLE IF EXISTS `sm_vat_01`;

CREATE TABLE `sm_vat_01` (
  `ID` bigint NOT NULL AUTO_INCREMENT,
  `CompanyCode` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BranchCode` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `InvoiceNo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CustomerCode` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CustomerName` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CustomerAddress` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CustomerVATRegNo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IssueDate` datetime DEFAULT NULL,
  `IssueTime` time DEFAULT NULL,
  `DeliveryDate` datetime DEFAULT NULL,
  `DeliveryTime` time DEFAULT NULL,
  `Place` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Car` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Remarks` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ChallanType` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DistChannel` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ProductCode` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IssueQty` double DEFAULT NULL,
  `UnitTP` double DEFAULT NULL,
  `TotalWithoutSD` double DEFAULT NULL,
  `TotalSD` double DEFAULT NULL,
  `TotalWithoutVAT` double DEFAULT NULL,
  `TotalVAT` double DEFAULT NULL,
  `TotalWithVAT` double DEFAULT NULL,
  `NetAmount` double DEFAULT NULL,
  `Discount` double DEFAULT NULL,
  `AIT` double DEFAULT NULL,
  `ErrorMessage` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `STATUS` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `AddedDate` datetime DEFAULT NULL,
  `UpdatedDate` datetime DEFAULT NULL,
  `TransferTo` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RefLineId` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CPC` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ItemNo` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ChallanNo` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OfficeCode` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Grade` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MRNo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Advertiser` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TotalHDSC` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `VATRate` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SDRate` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_vat` double DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `ProductCode` (`ProductCode`),
  KEY `ProductCode_2` (`ProductCode`,`UnitTP`),
  KEY `CustomerCode` (`CustomerCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_vendor` */

DROP TABLE IF EXISTS `sm_vendor`;

CREATE TABLE `sm_vendor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendor_id` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendor_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vendor_phone` bigint DEFAULT NULL,
  `contact_person` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_visit_plan` */

DROP TABLE IF EXISTS `sm_visit_plan`;

CREATE TABLE `sm_visit_plan` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_man_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_man_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_bn` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_col_day` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_day` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seq_no` int DEFAULT NULL,
  `status` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id` DESC),
  KEY `visit_plan_api` (`cid` DESC,`rep_id` DESC,`order_col_day` DESC,`status` DESC),
  KEY `cid_rep_id_status` (`cid` DESC,`rep_id` DESC,`status` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=3234 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `sm_web_settings` */

DROP TABLE IF EXISTS `sm_web_settings`;

CREATE TABLE `sm_web_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `s_key` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `s_value` int DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `target_vs_achievement` */

DROP TABLE IF EXISTS `target_vs_achievement`;

CREATE TABLE `target_vs_achievement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `target_date` date DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `territory_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `target_qty` int DEFAULT NULL,
  `achievement_qty` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `target_vs_achievement_field_force` */

DROP TABLE IF EXISTS `target_vs_achievement_field_force`;

CREATE TABLE `target_vs_achievement_field_force` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `target_year` int DEFAULT NULL,
  `target_month` int DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `target_amount` double DEFAULT NULL,
  `achievement_amount` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `task` */

DROP TABLE IF EXISTS `task`;

CREATE TABLE `task` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `submit_date` date DEFAULT NULL,
  `task_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spo_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spo_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `task` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `task_datetime` datetime DEFAULT NULL,
  `task_date` date DEFAULT NULL,
  `complete_datetime` datetime DEFAULT NULL,
  `complete_date` date DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `temp_closing_stock` */

DROP TABLE IF EXISTS `temp_closing_stock`;

CREATE TABLE `temp_closing_stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `process_date` date DEFAULT NULL,
  `depot_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expiary_date` date DEFAULT NULL,
  `gr_qty` int DEFAULT NULL,
  `transfer_in_qty` int NOT NULL DEFAULT '0',
  `issue_qty` int DEFAULT NULL,
  `transfer_qty` int DEFAULT NULL,
  `adj_incr_qty` int DEFAULT NULL,
  `adj_decr_qty` int DEFAULT NULL,
  `inv_qty` int DEFAULT NULL,
  `inv_b_qty` int DEFAULT NULL,
  `ret_qty` int DEFAULT NULL,
  `ret_b_qty` int DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=832 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `temp_duplicate_invoice` */

DROP TABLE IF EXISTS `temp_duplicate_invoice`;

CREATE TABLE `temp_duplicate_invoice` (
  `id` int NOT NULL AUTO_INCREMENT,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `min_row_id` int DEFAULT NULL,
  `repeatation` int DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `temp_duplicate_invoice_head` */

DROP TABLE IF EXISTS `temp_duplicate_invoice_head`;

CREATE TABLE `temp_duplicate_invoice_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `min_row_id` int DEFAULT NULL,
  `repeatation` int DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=208 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `temp_sm_invoice` */

DROP TABLE IF EXISTS `temp_sm_invoice`;

CREATE TABLE `temp_sm_invoice` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_sl` int DEFAULT NULL,
  `order_datetime` datetime DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `payment_mode` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `credit_note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_man_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_man_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `cl_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `cl_sub_category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `cl_sub_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `special_rsm_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `special_fm_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `special_territory_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `invoice_media` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_user_agent` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip_ref` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount` double DEFAULT NULL,
  `ym_date` date DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `invoice_ym_date` date DEFAULT NULL,
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actual_tp` double NOT NULL DEFAULT '0',
  `actual_vat` double NOT NULL DEFAULT '0',
  `quantity` int DEFAULT NULL,
  `bonus_qty` int DEFAULT NULL,
  `price` double NOT NULL DEFAULT '0',
  `item_vat` double NOT NULL DEFAULT '0',
  `item_unit` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_carton` int NOT NULL DEFAULT '0',
  `return_qty` int NOT NULL DEFAULT '0',
  `return_bonus_qty` int NOT NULL DEFAULT '0',
  `return_rate` double NOT NULL DEFAULT '0',
  `sp_discount_item` double NOT NULL DEFAULT '0',
  `return_sp_discount_item` double NOT NULL DEFAULT '0',
  `promotion_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `bonus_applied_on_qty` int NOT NULL DEFAULT '0',
  `circular_no` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `discount_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item_discount` double NOT NULL DEFAULT '0',
  `item_discount_percent` double NOT NULL DEFAULT '0',
  `discount_type_quantity` int NOT NULL DEFAULT '0',
  `ret_discount_type_quantity` int NOT NULL DEFAULT '0',
  `short_note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `posted_on` datetime DEFAULT NULL,
  `posted_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `msoCategory` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `itembaseGroup` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_dpid_sl_item_storeid` (`cid`,`depot_id`,`sl`,`item_id`,`store_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `temp_sm_invoice_head` */

DROP TABLE IF EXISTS `temp_sm_invoice_head`;

CREATE TABLE `temp_sm_invoice_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sl` int DEFAULT NULL,
  `store_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_sl` int DEFAULT NULL,
  `order_datetime` datetime DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `payment_mode` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `credit_note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `market_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `d_man_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `d_man_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cl_category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `cl_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `cl_sub_category_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `cl_sub_category_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `special_rsm_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `special_fm_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `special_territory_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `invoice_media` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_user_agent` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip_ref` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipment_no` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actual_total_tp` double NOT NULL DEFAULT '0',
  `regular_disc_tp` double NOT NULL DEFAULT '0',
  `flat_disc_tp` double NOT NULL DEFAULT '0',
  `approved_disc_tp` double NOT NULL DEFAULT '0',
  `others_disc_tp` double NOT NULL DEFAULT '0',
  `no_disc_tp` double NOT NULL DEFAULT '0',
  `ret_actual_total_tp` double NOT NULL DEFAULT '0',
  `ret_regular_disc_tp` double NOT NULL DEFAULT '0',
  `ret_flat_disc_tp` double NOT NULL DEFAULT '0',
  `ret_approved_disc_tp` double NOT NULL DEFAULT '0',
  `ret_others_disc_tp` double NOT NULL DEFAULT '0',
  `total_amount` double NOT NULL DEFAULT '0',
  `discount` double NOT NULL DEFAULT '0',
  `vat_total_amount` double NOT NULL DEFAULT '0',
  `collection_amount` double NOT NULL DEFAULT '0',
  `discount_precent` double NOT NULL DEFAULT '0',
  `adjust_amount` double NOT NULL DEFAULT '0',
  `return_tp` double NOT NULL DEFAULT '0',
  `return_vat` double NOT NULL DEFAULT '0',
  `return_discount` double NOT NULL DEFAULT '0',
  `sp_discount` double NOT NULL DEFAULT '0',
  `sp_flat` double NOT NULL DEFAULT '0',
  `sp_approved` double NOT NULL DEFAULT '0',
  `sp_others` double NOT NULL DEFAULT '0',
  `return_sp_discount` double NOT NULL DEFAULT '0',
  `ret_sp_flat` double NOT NULL DEFAULT '0',
  `ret_sp_approved` double NOT NULL DEFAULT '0',
  `ret_sp_others` double NOT NULL DEFAULT '0',
  `return_count` int NOT NULL DEFAULT '0',
  `previous_ost_amt` double NOT NULL DEFAULT '0',
  `client_limit_amt` double NOT NULL DEFAULT '0',
  `ym_date` date DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `invoice_ym_date` date DEFAULT NULL,
  `depot_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ho_status` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_depot_stock` int DEFAULT NULL,
  `flag_depot_stock_balance` int DEFAULT NULL,
  `flag_data` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_limit_over` int NOT NULL DEFAULT '0',
  `empty_batch_flag` int NOT NULL DEFAULT '0',
  `acknowledge_flag` int NOT NULL DEFAULT '0',
  `promo_ref` int NOT NULL DEFAULT '0',
  `inv_pending_flag` int NOT NULL DEFAULT '0',
  `rpt_trans_flag` int NOT NULL DEFAULT '0',
  `posted_on` datetime DEFAULT NULL,
  `posted_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid_depotid_sl_storeid` (`cid`,`depot_id`,`sl`,`store_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `temp_sm_level` */

DROP TABLE IF EXISTS `temp_sm_level`;

CREATE TABLE `temp_sm_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_level_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_level_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_leaf` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id_list` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `special_territory_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depth` int DEFAULT NULL,
  `level0` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level0_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level1_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level2_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level4` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level4_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level5` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level5_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level6` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level6_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level7` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level7_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level8` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level8_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `territory_des` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `temp_sm_rep` */

DROP TABLE IF EXISTS `temp_sm_rep`;

CREATE TABLE `temp_sm_rep` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile_no` bigint DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_code_servey` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_count` int DEFAULT NULL,
  `first_sync_date` datetime DEFAULT NULL,
  `last_sync_date` datetime DEFAULT NULL,
  `monthly_sms_count` int DEFAULT NULL,
  `monthly_voucher_count` int DEFAULT NULL,
  `java` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `wap` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `android` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sms` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_req_time` datetime DEFAULT NULL,
  `sync_flag` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sync_data` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `temp_sm_rep_area` */

DROP TABLE IF EXISTS `temp_sm_rep_area`;

CREATE TABLE `temp_sm_rep_area` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `temp_sm_supervisor_level` */

DROP TABLE IF EXISTS `temp_sm_supervisor_level`;

CREATE TABLE `temp_sm_supervisor_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sup_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sup_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level_depth_no` int DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `trade_promotional_offer` */

DROP TABLE IF EXISTS `trade_promotional_offer`;

CREATE TABLE `trade_promotional_offer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `offer_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `target_qty` int DEFAULT NULL,
  `reward` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bonus_con` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `visit_client_offer` */

DROP TABLE IF EXISTS `visit_client_offer`;

CREATE TABLE `visit_client_offer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vsl` int DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `visit_date` date DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `offer_id` int DEFAULT NULL,
  `offer_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `offer_from_date` date DEFAULT NULL,
  `offer_to_date` date DEFAULT NULL,
  `last_flag` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `visit_market_info` */

DROP TABLE IF EXISTS `visit_market_info`;

CREATE TABLE `visit_market_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SL` int DEFAULT NULL,
  `brand_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `brand_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `monthly_sales` int DEFAULT NULL,
  `stock` int DEFAULT NULL,
  `credit_amt` int DEFAULT NULL,
  `price` int DEFAULT NULL,
  `free_bag` int DEFAULT NULL,
  `retailer_commission` double DEFAULT NULL,
  `trade_promotion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remarks` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_date` date NOT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `region_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `area_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `territory_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `market_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `monthly_last_flag` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `visit_merchandising` */

DROP TABLE IF EXISTS `visit_merchandising`;

CREATE TABLE `visit_merchandising` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SL` int DEFAULT NULL,
  `client_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `m_item_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qty` int DEFAULT NULL,
  `installation_date` date DEFAULT NULL,
  `new_flag` int DEFAULT NULL,
  `visible` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `condition_value` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dismantled` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_flag` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `watermark` */

DROP TABLE IF EXISTS `watermark`;

CREATE TABLE `watermark` (
  `id` bigint NOT NULL,
  `cid` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` datetime DEFAULT NULL,
  `vlaue2` datetime DEFAULT NULL,
  `type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`),
  KEY `cid_2` (`cid`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `watermark_log` */

DROP TABLE IF EXISTS `watermark_log`;

CREATE TABLE `watermark_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cid` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` datetime DEFAULT NULL,
  KEY `id` (`id`),
  KEY `cid` (`cid`,`value`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `z_dd` */

DROP TABLE IF EXISTS `z_dd`;

CREATE TABLE `z_dd` (
  `id` int NOT NULL AUTO_INCREMENT,
  `depot_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stock_qty` int DEFAULT NULL,
  `block_qty` int DEFAULT NULL,
  `total_qty` int DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=926 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `z_mso_area` */

DROP TABLE IF EXISTS `z_mso_area`;

CREATE TABLE `z_mso_area` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_date` date DEFAULT NULL,
  `area_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sp_area_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level0_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level0_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level1_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level1_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level2_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level2_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `rep_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rep_category` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `z_opening` */

DROP TABLE IF EXISTS `z_opening`;

CREATE TABLE `z_opening` (
  `id` int NOT NULL AUTO_INCREMENT,
  `inv_no` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dp_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `z_sm_depot_stock_snapshot` */

DROP TABLE IF EXISTS `z_sm_depot_stock_snapshot`;

CREATE TABLE `z_sm_depot_stock_snapshot` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `process_date` date DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `store_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `batch_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `quantity` int DEFAULT '0',
  `bonus_qty` int DEFAULT '0',
  `tr_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`,`depot_id`,`store_id`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `z_sm_depot_submitted_qty` */

DROP TABLE IF EXISTS `z_sm_depot_submitted_qty`;

CREATE TABLE `z_sm_depot_submitted_qty` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_qty` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `i1` (`cid`,`depot_id`,`store_id`,`item_id`,`batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `z_temp_block_item_batch` */

DROP TABLE IF EXISTS `z_temp_block_item_batch`;

CREATE TABLE `z_temp_block_item_batch` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `store_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `batch_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `update_flag` int DEFAULT '0',
  `field1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `field2` int DEFAULT '0',
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `z_temp_client_cat` */

DROP TABLE IF EXISTS `z_temp_client_cat`;

CREATE TABLE `z_temp_client_cat` (
  `client_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cat_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cat_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `z_temp_recon_item` */

DROP TABLE IF EXISTS `z_temp_recon_item`;

CREATE TABLE `z_temp_recon_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `store_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `update_flag` int DEFAULT '0',
  `field1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `field2` int DEFAULT '0',
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `z_temp_recon_item_batch` */

DROP TABLE IF EXISTS `z_temp_recon_item_batch`;

CREATE TABLE `z_temp_recon_item_batch` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `ref_id` int NOT NULL DEFAULT '0',
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `store_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `batch_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `expiary_date` date DEFAULT NULL,
  `stock_qty` int DEFAULT '0',
  `recon_qty` int DEFAULT '0',
  `diff_qty` int DEFAULT '0',
  `update_flag` int DEFAULT '0',
  `field1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `field2` int DEFAULT '0',
  `note` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `cid` (`cid`,`depot_id`,`store_id`,`item_id`,`batch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `z_temp_rep` */

DROP TABLE IF EXISTS `z_temp_rep`;

CREATE TABLE `z_temp_rep` (
  `empid` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mobile` bigint NOT NULL,
  PRIMARY KEY (`empid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `z_tr_report` */

DROP TABLE IF EXISTS `z_tr_report`;

CREATE TABLE `z_tr_report` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rpt_date` date DEFAULT NULL,
  `item_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int DEFAULT NULL,
  `actual_tp` double DEFAULT NULL,
  `category_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `msoCategory` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `itembaseGroup` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `s_text` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `z_tr_report_cteam` */

DROP TABLE IF EXISTS `z_tr_report_cteam`;

CREATE TABLE `z_tr_report_cteam` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cid` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rpt_date` date DEFAULT NULL,
  `item_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `actual_tp` double DEFAULT NULL,
  `category_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level3_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `special_territory_code` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `msoCategory` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `itembaseGroup` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `s_text` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field2` int DEFAULT NULL,
  `note` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_on` datetime DEFAULT NULL,
  `created_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `updated_by` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `zz_blocked_qty` */

DROP TABLE IF EXISTS `zz_blocked_qty`;

CREATE TABLE `zz_blocked_qty` (
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `store_id` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch_id` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `block_qty` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`cid`,`depot_id`,`store_id`,`item_id`,`batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Table structure for table `zz_depot_stock_temp_fix` */

DROP TABLE IF EXISTS `zz_depot_stock_temp_fix`;

CREATE TABLE `zz_depot_stock_temp_fix` (
  `id` int NOT NULL,
  `cid` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depot_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `store_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch_id` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `block_qty` int NOT NULL DEFAULT '0',
  `submitted_qty` int DEFAULT NULL,
  `q_sq` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cid` (`cid`,`depot_id`,`store_id`,`item_id`,`batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* Procedure structure for procedure `GetOrdersForWeek` */

/*!50003 DROP PROCEDURE IF EXISTS  `GetOrdersForWeek` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`smart`@`%` PROCEDURE `GetOrdersForWeek`()
BEGIN
    DECLARE start_date DATE;
    DECLARE end_date DATE;
    
    SET start_date = CURDATE();
    SET end_date = DATE_ADD(CURDATE(), INTERVAL 7 DAY);
    
    SELECT * FROM sm_order_head WHERE delivery_date BETWEEN start_date AND end_date;
END */$$
DELIMITER ;

/*Table structure for table `smart_dump` */

DROP TABLE IF EXISTS `smart_dump`;

/*!50001 DROP VIEW IF EXISTS `smart_dump` */;
/*!50001 DROP TABLE IF EXISTS `smart_dump` */;

/*!50001 CREATE TABLE  `smart_dump`(
 `OrderDate` date ,
 `InvoiceDate` date ,
 `PSRID` varchar(20) ,
 `PSRName` varchar(100) ,
 `RsmName` varchar(100) ,
 `AreaID` varchar(512) ,
 `AreaName` varchar(512) ,
 `AsmName` varchar(100) ,
 `ZoneID` varchar(512) ,
 `ZoneName` varchar(512) ,
 `TerritoryID` varchar(20) ,
 `TerritoryName` varchar(100) ,
 `TownID` varchar(20) ,
 `Townname` varchar(100) ,
 `AseName` varchar(100) ,
 `DBID` varchar(50) ,
 `DBName` varchar(100) ,
 `RouteID` varchar(20) ,
 `RouteName` varchar(100) ,
 `BeatID` varchar(20) ,
 `BeatName` varchar(100) ,
 `CustomerID` varchar(20) ,
 `Customername` varchar(100) ,
 `ChannelID` varchar(50) ,
 `ChannelName` varchar(100) ,
 `SKUID` varchar(50) ,
 `SKUName` varchar(100) ,
 `BrandName` varchar(200) ,
 `FlavorName` varchar(200) ,
 `Weight` double ,
 `OrderValue` varchar(22) ,
 `GrossSales` varchar(22) ,
 `StaleValue` varchar(22) ,
 `NetSales` varchar(22) ,
 `OrderVolumeKg` varchar(22) ,
 `GrossSalesVolumeKg` varchar(22) ,
 `StalesVolumeKg` varchar(22) ,
 `NetSalesVolumeKg` varchar(22) 
)*/;

/*View structure for view smart_dump */

/*!50001 DROP TABLE IF EXISTS `smart_dump` */;
/*!50001 DROP VIEW IF EXISTS `smart_dump` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`smart`@`%` SQL SECURITY DEFINER VIEW `smart_dump` AS select ifnull(`Final`.`OrderDate`,`Final`.`InvoiceDate`) AS `OrderDate`,`Final`.`InvoiceDate` AS `InvoiceDate`,`Final`.`PSRID` AS `PSRID`,`Final`.`PSRName` AS `PSRName`,`s2`.`sup_name` AS `RsmName`,`m`.`level1` AS `AreaID`,`m`.`level1_name` AS `AreaName`,`s3`.`sup_name` AS `AsmName`,`m`.`level2` AS `ZoneID`,`m`.`level2_name` AS `ZoneName`,`Final`.`TerritoryID` AS `TerritoryID`,`Final`.`TerritoryName` AS `TerritoryName`,`Final`.`TownID` AS `TownID`,`Final`.`TownName` AS `Townname`,`s4`.`sup_name` AS `AseName`,`Final`.`DBID` AS `DBID`,`Final`.`DBName` AS `DBName`,`Final`.`RouteID` AS `RouteID`,`Final`.`RouteName` AS `RouteName`,`Final`.`BeatID` AS `BeatID`,`Final`.`BeatName` AS `BeatName`,`Final`.`CustomerID` AS `CustomerID`,`Final`.`CustomerName` AS `Customername`,`Final`.`ChannelID` AS `ChannelID`,`Final`.`ChannelName` AS `ChannelName`,`Final`.`SKUID` AS `SKUID`,`Final`.`SKUName` AS `SKUName`,`Final`.`BrandName` AS `BrandName`,`Final`.`FlavorName` AS `FlavorName`,`Final`.`Weight` AS `Weight`,ifnull(`Final`.`OrderValue`,'0') AS `OrderValue`,ifnull(`Final`.`GrossSales`,'0') AS `GrossSales`,ifnull(`Final`.`StaleValue`,'0') AS `StaleValue`,ifnull(`Final`.`NetSales`,'0') AS `NetSales`,ifnull(`Final`.`OrderVolumeKg`,'0') AS `OrderVolumeKg`,ifnull(`Final`.`GrossSalesVolumeKg`,'0') AS `GrossSalesVolumeKg`,ifnull(`Final`.`StalesVolumeKg`,'0') AS `StalesVolumeKg`,ifnull(`Final`.`NetSalesVolumeKg`,'0') AS `NetSalesVolumeKg` from ((((((select max(`T`.`OrderDate`) AS `OrderDate`,`T`.`InvoiceDate` AS `InvoiceDate`,`T`.`TerritoryID` AS `TerritoryID`,max(`T`.`TerritoryName`) AS `TerritoryName`,`T`.`TownID` AS `TownID`,max(`T`.`TownName`) AS `TownName`,`T`.`DBID` AS `DBID`,max(`T`.`DBName`) AS `DBName`,`T`.`RouteID` AS `RouteID`,max(`T`.`RouteName`) AS `RouteName`,`T`.`BeatID` AS `BeatID`,max(`T`.`BeatName`) AS `BeatName`,`T`.`PSRID` AS `PSRID`,max(`T`.`PSRName`) AS `PSRName`,`T`.`CustomerID` AS `CustomerID`,max(`T`.`CustomerName`) AS `CustomerName`,`T`.`ChannelID` AS `ChannelID`,max(`T`.`ChannelName`) AS `ChannelName`,sum(`T`.`INV_SL`) AS `INV_SL`,`T`.`SKUID` AS `SKUID`,max(`T`.`SKUName`) AS `SKUName`,max(`T`.`BrandName`) AS `BrandName`,max(`T`.`FlavorName`) AS `FlavorName`,`T`.`Weight` AS `Weight`,sum(`T`.`OrderValue`) AS `OrderValue`,sum(`T`.`GrossSales`) AS `GrossSales`,sum(`T`.`StaleVelue`) AS `StaleValue`,(sum(`T`.`GrossSales`) - sum(`T`.`StaleVelue`)) AS `NetSales`,sum(`T`.`OrderVolumeKg`) AS `OrderVolumeKg`,sum(round(`T`.`StalesVolumeKg`,2)) AS `StalesVolumeKg`,sum(`T`.`GrossSalesVolumeKg`) AS `GrossSalesVolumeKg`,(sum(`T`.`GrossSalesVolumeKg`) - sum(round(`T`.`StalesVolumeKg`,2))) AS `NetSalesVolumeKg` from (select `inv`.`level0_id` AS `TerritoryID`,`inv`.`level0_name` AS `TerritoryName`,`inv`.`level1_id` AS `TownID`,`inv`.`level1_name` AS `TownName`,`inv`.`level2_id` AS `RouteID`,`inv`.`level2_name` AS `RouteName`,`inv`.`area_id` AS `BeatID`,`inv`.`area_name` AS `BeatName`,`inv`.`depot_id` AS `DBID`,`inv`.`depot_name` AS `DBName`,`inv`.`rep_id` AS `PSRID`,`inv`.`rep_name` AS `PSRName`,`inv`.`client_id` AS `CustomerID`,`inv`.`client_name` AS `CustomerName`,`inv`.`sl` AS `INV_SL`,`inv`.`item_id` AS `SKUID`,`inv`.`item_name` AS `SKUName`,`itm`.`brand_id` AS `BrandID`,`itm`.`brand_name` AS `BrandName`,`itm`.`flavor_id` AS `FlavorID`,`itm`.`flavor_name` AS `FlavorName`,`inv`.`cl_category_id` AS `ChannelID`,`inv`.`cl_category_name` AS `ChannelName`,`itm`.`weight` AS `Weight`,0 AS `OrderValue`,cast(`inv`.`order_datetime` as date) AS `OrderDate`,`inv`.`delivery_date` AS `InvoiceDate`,(`inv`.`actual_tp` * `inv`.`quantity`) AS `GrossSales`,0 AS `StaleVelue`,(`inv`.`price` * `inv`.`quantity`) AS `NetSales`,round(((`inv`.`quantity` * `itm`.`weight`) / 1000),2) AS `GrossSalesVolumeKg`,0 AS `StalesVolumeKg`,0 AS `OrderVolumeKg` from (`sm_invoice` `inv` join `sm_item` `itm` on((`inv`.`item_id` = `itm`.`item_id`))) where ((`inv`.`cid` = 'SMART') and (`inv`.`delivery_date` >= '2024-09-01') and (`inv`.`status` = 'Invoiced')) union all select `o`.`level0_id` AS `TerritoryID`,`o`.`level0_name` AS `TerritoryName`,`o`.`level1_id` AS `TownID`,`o`.`level1_name` AS `TownName`,`o`.`level2_id` AS `RouteID`,`o`.`level2_name` AS `RouteName`,`o`.`area_id` AS `BeatID`,`o`.`area_name` AS `BeatName`,`o`.`depot_id` AS `DBID`,`o`.`depot_name` AS `DBName`,`o`.`rep_id` AS `PSRID`,`o`.`rep_name` AS `PSRName`,`o`.`client_id` AS `CustomerID`,`o`.`client_name` AS `CustomerName`,0 AS `INV_SL`,`o`.`item_id` AS `SKUID`,`o`.`item_name` AS `SKUName`,`sit`.`brand_id` AS `BrandID`,`sit`.`brand_name` AS `BrandName`,`sit`.`flavor_id` AS `FlavorID`,`sit`.`flavor_name` AS `FlavorName`,`cln`.`category_id` AS `ChannelID`,`cln`.`category_name` AS `ChannelName`,`sit`.`weight` AS `Weight`,round((`o`.`quantity` * `o`.`price`),2) AS `OrderValue`,`o`.`order_date` AS `OrderDate`,`o`.`delivery_date` AS `InvoiceDate`,0 AS `GrossSales`,round((`sd`.`actual_tp` * `sd`.`quantity`),2) AS `StaleVelue`,0 AS `NetSales`,0 AS `GrossSalesVolumeKg`,round(((`sit`.`weight` * `sd`.`quantity`) / 1000),2) AS `StalesVolumeKg`,round(((`sit`.`weight` * `o`.`quantity`) / 1000),2) AS `OrderVolumeKg` from (((`sm_order` `o` left join `sm_damage_return` `sd` on(((`o`.`cid` = `sd`.`cid`) and (`o`.`sl` = `sd`.`order_sl`) and (`o`.`depot_id` = `sd`.`depot_id`) and (`o`.`item_id` = `sd`.`item_id`)))) left join `sm_item` `sit` on((`o`.`item_id` = `sit`.`item_id`))) left join `sm_client` `cln` on((`o`.`client_id` = `cln`.`client_id`))) where ((`o`.`cid` = 'SMART') and (`o`.`order_date` >= '2024-09-01') and (`o`.`status` = 'Invoiced'))) `T` group by `T`.`InvoiceDate`,`T`.`TerritoryID`,`T`.`TownID`,`T`.`DBID`,`T`.`RouteID`,`T`.`BeatID`,`T`.`CustomerID`,`T`.`SKUID`,`T`.`PSRID`,`T`.`ChannelID`,`T`.`BrandID`,`T`.`FlavorID`,`T`.`Weight`) `Final` left join `sm_supervisor_level` `s4` on(((`Final`.`TerritoryID` = `s4`.`level_id`) and (`s4`.`level_depth_no` = '0') and (`s4`.`sup_id` like '%ASE%')))) left join `sm_supervisor_level` `s3` on(((`Final`.`TerritoryID` = `s3`.`level_id`) and (`s3`.`level_depth_no` = '0') and (`s3`.`sup_id` like '%ASM%')))) left join `sm_supervisor_level` `s2` on(((`Final`.`TerritoryID` = `s2`.`level_id`) and (`s2`.`level_depth_no` = '0') and (`s2`.`sup_id` like '%RSM%')))) left join `sm_supervisor_level` `s1` on(((`Final`.`TerritoryID` = `s1`.`level_id`) and (`s1`.`level_depth_no` = '0') and (`s1`.`sup_id` like '%HOS%')))) left join `sm_top_level` `m` on((`Final`.`TerritoryID` = `m`.`level3`))) */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
