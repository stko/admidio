/******************************************************************************
 * Skript fuer die MySql-Datenbank
 *
 * Copyright    : (c) 2004 - 2005 The Admidio Team
 * Homepage     : http://www.admidio.org
 * Module-Owner : Markus Fassbender
 * License      : GNU Public License 2 http://www.gnu.org/licenses/gpl-2.0.html
 *
 ******************************************************************************/

set foreign_key_checks = 0;

drop table if exists %PREFIX%_announcements;
drop table if exists %PREFIX%_auto_login;
drop table if exists %PREFIX%_categories;
drop table if exists %PREFIX%_date_role;
drop table if exists %PREFIX%_dates;
drop table if exists %PREFIX%_files;
drop table if exists %PREFIX%_folder_roles;
drop table if exists %PREFIX%_folders;
drop table if exists %PREFIX%_guestbook;
drop table if exists %PREFIX%_guestbook_comments;
drop table if exists %PREFIX%_links;
drop table if exists %PREFIX%_list_columns;
drop table if exists %PREFIX%_lists;
drop table if exists %PREFIX%_members;
drop table if exists %PREFIX%_organizations;
drop table if exists %PREFIX%_photos;
drop table if exists %PREFIX%_preferences;
drop table if exists %PREFIX%_role_dependencies;
drop table if exists %PREFIX%_roles;
drop table if exists %PREFIX%_rooms;
drop table if exists %PREFIX%_sessions;
drop table if exists %PREFIX%_texts;
drop table if exists %PREFIX%_user_data;
drop table if exists %PREFIX%_user_fields;
drop table if exists %PREFIX%_users;


/*==============================================================*/
/* Table: adm_announcements                                     */
/*==============================================================*/
create table %PREFIX%_announcements
(
   ann_id                         int(11) unsigned               not null AUTO_INCREMENT,
   ann_org_shortname              varchar(10)                    not null,
   ann_global                     tinyint(1) unsigned            not null default 0,
   ann_headline                   varchar(100)                   not null,
   ann_description                text,
   ann_usr_id_create              int(11) unsigned,
   ann_timestamp_create           datetime                       not null,
   ann_usr_id_change              int(11) unsigned,
   ann_timestamp_change           datetime,
   primary key (ann_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_announcements add index ANN_ORG_FK (ann_org_shortname);
alter table %PREFIX%_announcements add index ANN_USR_FK(ann_usr_id_create);
alter table %PREFIX%_announcements add index ANN_USR_CHANGE_FK (ann_usr_id_change);

-- Constraints
alter table %PREFIX%_announcements add constraint %PREFIX%_FK_ANN_ORG foreign key (ann_org_shortname)
      references %PREFIX%_organizations (org_shortname) on delete restrict on update restrict;
alter table %PREFIX%_announcements add constraint %PREFIX%_FK_ANN_USR_CREATE foreign key (ann_usr_id_create)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;
alter table %PREFIX%_announcements add constraint %PREFIX%_FK_ANN_USR_CHANGE foreign key (ann_usr_id_change)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;

/*==============================================================*/
/* Table: adm_auto_login                                        */
/*==============================================================*/
create table %PREFIX%_auto_login
(
   atl_session_id                 varchar(35)                    not null,
   atl_org_id                     tinyint(4)                     not null,
   atl_usr_id                     int(11) unsigned               not null,
   atl_last_login                 datetime                       not null,
   atl_ip_address                 varchar(15)                    not null,
   primary key (atl_session_id)
)
engine = InnoDB
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_auto_login add index ATL_USR_FK (atl_usr_id);
alter table %PREFIX%_auto_login add index ATL_ORG_FK (atl_org_id);

-- Constraints
alter table %PREFIX%_auto_login add constraint %PREFIX%_FK_ATL_USR foreign key (atl_usr_id)
      references %PREFIX%_users (usr_id) on delete restrict on update restrict;

alter table %PREFIX%_auto_login add constraint %PREFIX%_FK_ATL_ORG foreign key (atl_org_id)
      references %PREFIX%_organizations (org_id) on delete restrict on update restrict;

/*==============================================================*/
/* Table: adm_categories                                        */
/*==============================================================*/
create table %PREFIX%_categories
(
   cat_id                         int (11) unsigned              not null AUTO_INCREMENT,
   cat_org_id                     tinyint(4),
   cat_type                       varchar(10)                    not null,
   cat_name_intern                varchar(110)                   not null,
   cat_name                       varchar(100)                    not null,
   cat_hidden                     tinyint(1) unsigned            not null default 0,
   cat_system                     tinyint(1) unsigned            not null default 0,
   cat_sequence                   smallint                       not null,
   cat_usr_id_create              int(11) unsigned,
   cat_timestamp_create           datetime                       not null,
   cat_usr_id_change              int(11) unsigned,
   cat_timestamp_change           datetime,
   primary key (cat_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_categories add index CAT_ORG_FK (cat_org_id);

-- Constraints
alter table %PREFIX%_categories add constraint %PREFIX%_FK_CAT_ORG foreign key (cat_org_id)
      references %PREFIX%_organizations (org_id) on delete restrict on update restrict;
alter table %PREFIX%_categories add constraint %PREFIX%_FK_CAT_USR_CREATE foreign key (cat_usr_id_create)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;
alter table %PREFIX%_categories add constraint %PREFIX%_FK_CAT_USR_CHANGE foreign key (cat_usr_id_change)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;

/*==============================================================*/
/* Table: adm_date_role                                         */
/*==============================================================*/

create table %PREFIX%_date_role
(
    dtr_id                          int(11) unsigned                not null auto_increment,
    dtr_dat_id                      int(11) unsigned                not null,
    dtr_rol_id                      int(11) unsigned,
    primary key (dtr_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_date_role add index DTR_DAT_FK (dtr_dat_id);
alter table %PREFIX%_date_role add index DTR_ROL_FK (dtr_rol_id);

-- Constraints
alter table %PREFIX%_date_role add constraint %PREFIX%_FK_DTR_DAT foreign key (dtr_dat_id)
      references %PREFIX%_dates (dat_id) on delete restrict on update restrict;
alter table %PREFIX%_date_role add constraint %PREFIX%_FK_DTR_ROL foreign key (dtr_rol_id)
      references %PREFIX%_roles (rol_id) on delete restrict on update restrict;

/*==============================================================*/
/* Table: adm_dates                                             */
/*==============================================================*/
create table %PREFIX%_dates
(
   dat_id                         int(11) unsigned               not null AUTO_INCREMENT,
   dat_cat_id                     int(11) unsigned               not null,
   dat_global                     tinyint(1) unsigned            not null default 0,
   dat_begin                      datetime                       not null,
   dat_end                        datetime                       not null,
   dat_all_day                    tinyint(1) unsigned            not null default 0,
   dat_description                text,
   dat_location                   varchar(100),
   dat_country                    varchar(100),
   dat_headline                   varchar(100)                   not null,
   dat_usr_id_create              int(11) unsigned,
   dat_timestamp_create           datetime                       not null,
   dat_usr_id_change              int(11) unsigned,
   dat_timestamp_change           datetime,
   dat_rol_id                     int(11) unsigned, 
   dat_room_id                    int(11) unsigned,
   dat_max_members                int(11) unsigned               not null,                      
   primary key (dat_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_dates add index DAT_CAT_FK (dat_cat_id);
alter table %PREFIX%_dates add index DAT_USR_FK (dat_usr_id_create);
alter table %PREFIX%_dates add index DAT_USR_CHANGE_FK (dat_usr_id_change);

-- Constraints
alter table %PREFIX%_dates add constraint %PREFIX%_FK_DAT_CAT foreign key (dat_cat_id)
      references %PREFIX%_categories (cat_id) on delete restrict on update restrict;
alter table %PREFIX%_dates add constraint %PREFIX%_FK_DAT_USR_CREATE foreign key (dat_usr_id_create)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;
alter table %PREFIX%_dates add constraint %PREFIX%_FK_DAT_USR_CHANGE foreign key (dat_usr_id_change)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;


/*==============================================================*/
/* Table: adm_files                                             */
/*==============================================================*/
create table %PREFIX%_files
(
   fil_id                         int(11) unsigned               not null AUTO_INCREMENT,
   fil_fol_id                     int(11) unsigned               not null,
   fil_name                       varchar(255)                   not null,
   fil_description                text,
   fil_locked                     tinyint(1) unsigned            not null default 0,
   fil_counter                    int,
   fil_usr_id                     int(11) unsigned,
   fil_timestamp                  datetime                       not null,
   primary key (fil_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_files add index FIL_FOL_FK (fil_fol_id);
alter table %PREFIX%_files add index FIL_USR_FK (fil_usr_id);

-- Constraints
alter table %PREFIX%_files add constraint %PREFIX%_FK_FIL_FOL foreign key (fil_fol_id)
      references %PREFIX%_folders (fol_id) on delete restrict on update restrict;
alter table %PREFIX%_files add constraint %PREFIX%_FK_FIL_USR foreign key (fil_usr_id)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;

/*==============================================================*/
/* Table: adm_folder_roles                                      */
/*==============================================================*/
create table %PREFIX%_folder_roles
(
   flr_fol_id                     int(11) unsigned               not null,
   flr_rol_id                     int(11) unsigned               not null,
   primary key (flr_fol_id, flr_rol_id)
)
engine = InnoDB
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_folder_roles add index FLR_FOL_FK (flr_fol_id);
alter table %PREFIX%_folder_roles add index FLR_ROL_FK (flr_rol_id);

-- Constraints
alter table %PREFIX%_folder_roles add constraint %PREFIX%_FK_FLR_FOL foreign key (flr_fol_id)
      references %PREFIX%_folders (fol_id) on delete restrict on update restrict;

alter table %PREFIX%_folder_roles add constraint %PREFIX%_FK_FLR_ROL foreign key (flr_rol_id)
      references %PREFIX%_roles (rol_id) on delete restrict on update restrict;

/*==============================================================*/
/* Table: adm_folders                                           */
/*==============================================================*/
create table %PREFIX%_folders
(
   fol_id                         int(11) unsigned               not null AUTO_INCREMENT,
   fol_org_id                     tinyint(4)                     not null,
   fol_fol_id_parent              int(11) unsigned,
   fol_type                       varchar(10)                    not null,
   fol_name                       varchar(255)                   not null,
   fol_description                text,
   fol_path                       varchar(255)                   not null,
   fol_locked                     tinyint (1) unsigned           not null default 0,
   fol_public                     tinyint (1) unsigned           not null default 0,
   fol_usr_id                     int(11) unsigned,
   fol_timestamp                  datetime                       not null,
   primary key (fol_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_folders add index FOL_ORG_FK (fol_org_id);
alter table %PREFIX%_folders add index FOL_FOL_PARENT_FK (fol_fol_id_parent);
alter table %PREFIX%_folders add index FOL_USR_FK (fol_usr_id);

-- Constraints
alter table %PREFIX%_folders add constraint %PREFIX%_FK_FOL_ORG foreign key (fol_org_id)
      references %PREFIX%_organizations (org_id) on delete restrict on update restrict;
alter table %PREFIX%_folders add constraint %PREFIX%_FK_FOL_FOL_PARENT foreign key (fol_fol_id_parent)
      references %PREFIX%_folders (fol_id) on delete restrict on update restrict;
alter table %PREFIX%_folders add constraint %PREFIX%_FK_FOL_USR foreign key (fol_usr_id)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;

/*==============================================================*/
/* Table: adm_guestbook                                         */
/*==============================================================*/
create table %PREFIX%_guestbook
(
   gbo_id                         int(11) unsigned               not null AUTO_INCREMENT,
   gbo_org_id                     tinyint(4)                     not null,
   gbo_name                       varchar(60)                    not null,
   gbo_text                       text                           not null,
   gbo_email                      varchar(50),
   gbo_homepage                   varchar(50),
   gbo_ip_address                 varchar(15)                    not null,
   gbo_locked                     tinyint (1) unsigned           not null default 0,
   gbo_usr_id_create              int(11) unsigned,
   gbo_timestamp_create           datetime                       not null,
   gbo_usr_id_change              int(11) unsigned,
   gbo_timestamp_change           datetime,
   primary key (gbo_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_guestbook add index GBO_ORG_FK (gbo_org_id);
alter table %PREFIX%_guestbook add index GBO_USR_CREATE_FK (gbo_usr_id_create);
alter table %PREFIX%_guestbook add index GBO_USR_CHANGE_FK (gbo_usr_id_change);

-- Constraints
alter table %PREFIX%_guestbook add constraint %PREFIX%_FK_GBO_ORG foreign key (gbo_org_id)
      references %PREFIX%_organizations (org_id) on delete restrict on update restrict;
alter table %PREFIX%_guestbook add constraint %PREFIX%_FK_GBO_USR_CREATE foreign key (gbo_usr_id_create)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;
alter table %PREFIX%_guestbook add constraint %PREFIX%_FK_GBO_USR_CHANGE foreign key (gbo_usr_id_change)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;

/*==============================================================*/
/* Table: adm_guestbook_comments                                */
/*==============================================================*/
create table %PREFIX%_guestbook_comments
(
   gbc_id                         int(11) unsigned               not null AUTO_INCREMENT,
   gbc_gbo_id                     int(11) unsigned               not null,
   gbc_name                       varchar(60)                    not null,
   gbc_text                       text                           not null,
   gbc_email                      varchar(50),
   gbc_ip_address                 varchar(15)                    not null,
   gbc_usr_id_create              int(11) unsigned,
   gbc_timestamp_create           datetime                       not null,
   gbc_usr_id_change              int(11) unsigned,
   gbc_timestamp_change           datetime,
   primary key (gbc_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_guestbook_comments add index GBC_GBO_FK (gbc_gbo_id);
alter table %PREFIX%_guestbook_comments add index GBC_USR_CREATE_FK (gbc_usr_id_create);
alter table %PREFIX%_guestbook_comments add index GBC_USR_CHANGE_FK (gbc_usr_id_change);

-- Constraints
alter table %PREFIX%_guestbook_comments add constraint %PREFIX%_FK_GBC_GBO foreign key (gbc_gbo_id)
      references %PREFIX%_guestbook (gbo_id) on delete restrict on update restrict;
alter table %PREFIX%_guestbook_comments add constraint %PREFIX%_FK_GBC_USR_CREATE foreign key (gbc_usr_id_create)
      references %PREFIX%_users (usr_id) on delete restrict on update restrict;
alter table %PREFIX%_guestbook_comments add constraint %PREFIX%_FK_GBC_USR_CHANGE foreign key (gbc_usr_id_change)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;

/*==============================================================*/
/* Table: adm_links                                             */
/*==============================================================*/
create table %PREFIX%_links
(
   lnk_id                         int(11) unsigned               not null AUTO_INCREMENT,
   lnk_cat_id                     int(11) unsigned               not null,
   lnk_name                       varchar(255)                   not null,
   lnk_description                text,
   lnk_url                        varchar(255)                   not null,
   lnk_counter                    tinyint(1) unsigned            not null default 0,
   lnk_usr_id_create              int(11) unsigned,
   lnk_timestamp_create           datetime                       not null,
   lnk_usr_id_change              int(11) unsigned,
   lnk_timestamp_change           datetime,
   primary key (lnk_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_links add index LNK_CAT_FK (lnk_cat_id);
alter table %PREFIX%_links add index LNK_USR_FK (lnk_usr_id_create);
alter table %PREFIX%_links add index LNK_USR_CHANGE_FK (lnk_usr_id_change);

-- Constraints
alter table %PREFIX%_links add constraint %PREFIX%_FK_LNK_CAT foreign key (lnk_cat_id)
      references %PREFIX%_categories (cat_id) on delete restrict on update restrict;
alter table %PREFIX%_links add constraint %PREFIX%_FK_LNK_USR_CREATE foreign key (lnk_usr_id_create)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;
alter table %PREFIX%_links add constraint %PREFIX%_FK_LNK_USR_CHANGE foreign key (lnk_usr_id_change)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;

/*==============================================================*/
/* Table: adm_lists                                             */
/*==============================================================*/
create table %PREFIX%_lists
(
   lst_id                         int(11) unsigned               not null AUTO_INCREMENT,
   lst_org_id                     tinyint(4)                     not null,
   lst_usr_id                     int(11) unsigned               not null,
   lst_name                       varchar(255),
   lst_timestamp                  datetime                       not null,
   lst_global                     tinyint(1) unsigned            not null default 0,
   lst_default                    tinyint(1) unsigned            not null default 0,
   primary key (lst_id)
)
type = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_lists add index LST_USR_FK (lst_usr_id);
alter table %PREFIX%_lists add index LST_ORG_FK (lst_org_id);

-- Constraints
alter table %PREFIX%_lists add constraint %PREFIX%_FK_LST_USR foreign key (lst_usr_id)
      references %PREFIX%_users (usr_id) on delete restrict on update restrict;
alter table %PREFIX%_lists add constraint %PREFIX%_FK_LST_ORG foreign key (lst_org_id)
      references %PREFIX%_organizations (org_id) on delete restrict on update restrict;

/*==============================================================*/
/* Table: adm_list_columns                                       */
/*==============================================================*/
create table %PREFIX%_list_columns
(
   lsc_id                         int(11) unsigned               not null AUTO_INCREMENT,
   lsc_lst_id                     int(11) unsigned               not null,
   lsc_number                     smallint                       not null,
   lsc_usf_id                     int(11) unsigned,
   lsc_special_field              varchar(255),
   lsc_sort                       varchar(5),
   lsc_filter                     varchar(255),
   primary key (lsc_id)
)
type = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_list_columns add index LSC_LST_FK (lsc_lst_id);
alter table %PREFIX%_list_columns add index LSC_USF_FK (lsc_usf_id);

-- Constraints
alter table %PREFIX%_list_columns add constraint %PREFIX%_FK_LSC_LST foreign key (lsc_lst_id)
      references %PREFIX%_lists (lst_id) on delete restrict on update restrict;

alter table %PREFIX%_list_columns add constraint %PREFIX%_FK_LSC_USF foreign key (lsc_usf_id)
      references %PREFIX%_user_fields (usf_id) on delete restrict on update restrict;

/*==============================================================*/
/* Table: adm_members                                           */
/*==============================================================*/
create table %PREFIX%_members
(
   mem_id                         int(11)                        not null AUTO_INCREMENT,
   mem_rol_id                     int(11) unsigned               not null,
   mem_usr_id                     int(11) unsigned               not null,
   mem_begin                      date                           not null,
   mem_end                        date                           not null default '9999-12-31',
   mem_leader                     tinyint(1) unsigned            not null default 0,
   primary key (mem_id),
   unique ak_rol_usr_id (mem_rol_id, mem_usr_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_members add index MEM_ROL_FK (mem_rol_id);
alter table %PREFIX%_members add index MEM_USR_FK (mem_usr_id);

-- Constraints
alter table %PREFIX%_members add constraint %PREFIX%_FK_MEM_ROL foreign key (mem_rol_id)
      references %PREFIX%_roles (rol_id) on delete restrict on update restrict;
alter table %PREFIX%_members add constraint %PREFIX%_FK_MEM_USR foreign key (mem_usr_id)
      references %PREFIX%_users (usr_id) on delete restrict on update restrict;

/*==============================================================*/
/* Table: adm_organizations                                     */
/*==============================================================*/
create table %PREFIX%_organizations
(
   org_id                         tinyint(4)                     not null AUTO_INCREMENT,
   org_longname                   varchar(60)                    not null,
   org_shortname                  varchar(10)                    not null,
   org_org_id_parent              tinyint(4),
   org_homepage                   varchar(60)                    not null,
   primary key (org_id),
   unique ak_shortname (org_shortname)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_organizations add index ORG_ORG_PARENT_FK (org_org_id_parent);

-- Constraints
alter table %PREFIX%_organizations add constraint %PREFIX%_FK_ORG_ORG_PARENT foreign key (org_org_id_parent)
      references %PREFIX%_organizations (org_id) on delete set null on update restrict;

/*==============================================================*/
/* Table: adm_photos                                            */
/*==============================================================*/
create table %PREFIX%_photos
(
   pho_id                         int(11) unsigned               not null auto_increment,
   pho_org_shortname              varchar(10)                    not null,
   pho_quantity                   int(11) unsigned               not null default 0,
   pho_name                       varchar(50)                    not null,
   pho_begin                      date                           not null,
   pho_end                        date                           not null,
   pho_photographers              varchar(100),
   pho_locked                     tinyint(1) unsigned            not null default 0,
   pho_pho_id_parent              int(11) unsigned,
   pho_usr_id_create              int(11) unsigned,
   pho_timestamp_create           datetime                       not null,
   pho_usr_id_change              int(11) unsigned,
   pho_timestamp_change           datetime,
   primary key (pho_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_photos add index PHO_ORG_FK (pho_org_shortname);
alter table %PREFIX%_photos add index PHO_USR_FK (pho_usr_id_create);
alter table %PREFIX%_photos add index PHO_USR_CHANGE_FK (pho_usr_id_change);
alter table %PREFIX%_photos add index FK_PHO_PHO_PARENT_FK (pho_pho_id_parent);

-- Constraints
alter table %PREFIX%_photos add constraint %PREFIX%_FK_PHO_PHO_PARENT foreign key (pho_pho_id_parent)
      references %PREFIX%_photos (pho_id) on delete set null on update restrict;
alter table %PREFIX%_photos add constraint %PREFIX%_FK_PHO_ORG foreign key (pho_org_shortname)
      references %PREFIX%_organizations (org_shortname) on delete restrict on update restrict;
alter table %PREFIX%_photos add constraint %PREFIX%_FK_PHO_USR_CREATE foreign key (pho_usr_id_create)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;
alter table %PREFIX%_photos add constraint %PREFIX%_FK_PHO_USR_CHANGE foreign key (pho_usr_id_change)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;

/*==============================================================*/
/* Table: adm_preferences                                       */
/*==============================================================*/
create table %PREFIX%_preferences
(
   prf_id                         int(11) unsigned               not null AUTO_INCREMENT,
   prf_org_id                     tinyint(4)                     not null,
   prf_name                       varchar(30)                    not null,
   prf_value                      varchar(255),
   primary key (prf_id),
   unique ak_org_id_name (prf_org_id, prf_name)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_preferences add index PRF_ORG_FK (prf_org_id);

-- Constraints
alter table %PREFIX%_preferences add constraint %PREFIX%_FK_PRF_ORG foreign key (prf_org_id)
      references %PREFIX%_organizations (org_id) on delete restrict on update restrict;

/*==============================================================*/
/* Table: adm_role_dependencies                                 */
/*==============================================================*/
create table %PREFIX%_role_dependencies
(
   rld_rol_id_parent              int(11) unsigned               not null,
   rld_rol_id_child               int(11) unsigned               not null,
   rld_comment                    text,
   rld_usr_id                     int(11) unsigned,
   rld_timestamp                  datetime                       not null,
   primary key (rld_rol_id_parent, rld_rol_id_child)
)
engine = InnoDB
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_role_dependencies add index RLD_USR_FK (rld_usr_id);
alter table %PREFIX%_role_dependencies add index RLD_ROL_PARENT_FK (rld_rol_id_parent);
alter table %PREFIX%_role_dependencies add index RLD_ROL_CHILD_FK (rld_rol_id_child);

-- Constraints
alter table %PREFIX%_role_dependencies add constraint %PREFIX%_FK_RLD_ROL_CHILD foreign key (rld_rol_id_child)
      references %PREFIX%_roles (rol_id) on delete restrict on update restrict;
alter table %PREFIX%_role_dependencies add constraint %PREFIX%_FK_RLD_ROL_PARENT foreign key (rld_rol_id_parent)
      references %PREFIX%_roles (rol_id) on delete restrict on update restrict;
alter table %PREFIX%_role_dependencies add constraint %PREFIX%_FK_RLD_USR foreign key (rld_usr_id)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;

/*==============================================================*/
/* Table: adm_roles                                             */
/*==============================================================*/
create table %PREFIX%_roles
(
   rol_id                         int(11) unsigned               not null AUTO_INCREMENT,
   rol_cat_id                     int(11) unsigned               not null,
   rol_name                       varchar(30)                    not null,
   rol_description                varchar(255),
   rol_assign_roles               tinyint(1) unsigned            not null default 0,
   rol_approve_users              tinyint(1) unsigned            not null default 0,
   rol_announcements              tinyint(1) unsigned            not null default 0,
   rol_dates                      tinyint(1) unsigned            not null default 0,
   rol_download                   tinyint(1) unsigned            not null default 0,
   rol_edit_user                  tinyint(1) unsigned            not null default 0,
   rol_guestbook                  tinyint(1) unsigned            not null default 0,
   rol_guestbook_comments         tinyint(1) unsigned            not null default 0,
   rol_inventory				  tinyint(1) unsigned            not null default 0,
   rol_mail_to_all                tinyint(1) unsigned            not null default 0,
   rol_mail_this_role             tinyint(1) unsigned            not null default 0,
   rol_photo                      tinyint(1) unsigned            not null default 0,
   rol_profile                    tinyint(1) unsigned            not null default 0,
   rol_weblinks                   tinyint(1) unsigned            not null default 0,
   rol_this_list_view             tinyint(1) unsigned            not null default 0,
   rol_all_lists_view             tinyint(1) unsigned            not null default 0,
   rol_start_date                 date,
   rol_start_time                 time,
   rol_end_date                   date,
   rol_end_time                   time,
   rol_weekday                    tinyint(1),
   rol_location                   varchar(30),
   rol_max_members                smallint(3) unsigned,
   rol_cost                       float unsigned,
   rol_cost_period				  smallint(3) unsigned,
   rol_usr_id_create              int(11) unsigned,
   rol_timestamp_create           datetime                       not null,
   rol_usr_id_change              int(11) unsigned,
   rol_timestamp_change           datetime,
   rol_valid                      tinyint(1) unsigned            not null default 1,
   rol_system                     tinyint(1) unsigned            not null default 0,
   rol_visible                    tinyint(1) unsigned            not null default 1,
   primary key (rol_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_roles add index ROL_CAT_FK (rol_cat_id);
alter table %PREFIX%_roles add index ROL_USR_CREATE_FK (rol_usr_id_create);
alter table %PREFIX%_roles add index ROL_USR_CHANGE_FK (rol_usr_id_change);

-- Constraints
alter table %PREFIX%_roles add constraint %PREFIX%_FK_ROL_CAT foreign key (rol_cat_id)
      references %PREFIX%_categories (cat_id) on delete restrict on update restrict;
alter table %PREFIX%_roles add constraint %PREFIX%_FK_ROL_USR_CREATE foreign key (rol_usr_id_create)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;
alter table %PREFIX%_roles add constraint %PREFIX%_FK_ROL_USR_CHANGE foreign key (rol_usr_id_change)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;

/*==============================================================*/
/* Table: adm_rooms                                             */
/*==============================================================*/

create table %PREFIX%_rooms
(
    room_id                         int(11) unsigned                not null auto_increment,
    room_name                       varchar(50)                     not null,
    room_description                varchar(255),
    room_capacity                   int(11) unsigned                not null,
    room_overhang                   int(11) unsigned,
    room_usr_id_create              int(11) unsigned,
    room_timestamp_create           datetime                        not null,
    room_usr_id_change              int(11) unsigned,
    room_timestamp_change           datetime,
    primary key (room_id)                                                                       
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

/*==============================================================*/
/* Table: adm_sessions                                          */
/*==============================================================*/
create table %PREFIX%_sessions
(
   ses_id                         int(11) unsigned               not null AUTO_INCREMENT,
   ses_usr_id                     int(11) unsigned               default NULL,
   ses_org_id                     tinyint(4)                     not null,
   ses_session_id                 varchar(35)                    not null,
   ses_begin                      datetime                       not null,
   ses_timestamp                  datetime                       not null,
   ses_ip_address                 varchar(15)                    not null,
   ses_blob                       blob,
   ses_renew                      tinyint(1) unsigned            not null default 0,
   primary key (ses_id),
   key ak_session (ses_session_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_sessions add index SES_USR_FK (ses_usr_id);
alter table %PREFIX%_sessions add index SES_ORG_FK (ses_org_id);

-- Constraints
alter table %PREFIX%_sessions add constraint %PREFIX%_FK_SES_ORG foreign key (ses_org_id)
      references %PREFIX%_organizations (org_id) on delete restrict on update restrict;
alter table %PREFIX%_sessions add constraint %PREFIX%_FK_SES_USR foreign key (ses_usr_id)
      references %PREFIX%_users (usr_id) on delete restrict on update restrict;

/*==============================================================*/
/* Table: adm_texts                                             */
/*==============================================================*/
create table %PREFIX%_texts
(
   txt_id                         int(11) unsigned               not null AUTO_INCREMENT,
   txt_org_id                     tinyint(4)                     not null,
   txt_name                       varchar(30)                    not null,
   txt_text                       text,
   primary key (txt_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_texts add index TXT_ORG_FK (txt_org_id);

-- Constraints
alter table %PREFIX%_texts add constraint %PREFIX%_FK_TXT_ORG foreign key (txt_org_id)
      references %PREFIX%_organizations (org_id) on delete restrict on update restrict;

/*==============================================================*/
/* Table: adm_user_fields                                       */
/*==============================================================*/
create table %PREFIX%_user_fields
(
   usf_id                         int(11) unsigned               not null AUTO_INCREMENT,
   usf_cat_id                     int(11) unsigned               not null,
   usf_type                       varchar(10)                    not null,
   usf_name_intern                varchar(110)                   not null,
   usf_name                       varchar(100)                   not null,
   usf_description                text,
   usf_system                     tinyint(1) unsigned            not null default 0,
   usf_disabled                   tinyint(1) unsigned            not null default 0,
   usf_hidden                     tinyint(1) unsigned            not null default 0,
   usf_mandatory                  tinyint(1) unsigned            not null default 0,
   usf_sequence                   smallint                       not null,
   usf_usr_id_create              int(11) unsigned,
   usf_timestamp_create           datetime                       not null,
   usf_usr_id_change              int(11) unsigned,
   usf_timestamp_change           datetime,
   primary key (usf_id),
   unique ak_name_intern (usf_name_intern)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_user_fields add index USF_CAT_FK (usf_cat_id);

-- Constraints
alter table %PREFIX%_user_fields add constraint %PREFIX%_FK_USF_CAT foreign key (usf_cat_id)
      references %PREFIX%_categories (cat_id) on delete restrict on update restrict;
alter table %PREFIX%_user_fields add constraint %PREFIX%_FK_USF_USR_CREATE foreign key (usf_usr_id_create)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;
alter table %PREFIX%_user_fields add constraint %PREFIX%_FK_USF_USR_CHANGE foreign key (usf_usr_id_change)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;

/*==============================================================*/
/* Table: adm_user_data                                         */
/*==============================================================*/
create table %PREFIX%_user_data
(
   usd_id                         int(11) unsigned               not null AUTO_INCREMENT,
   usd_usr_id                     int(11) unsigned               not null,
   usd_usf_id                     int(11) unsigned               not null,
   usd_value                      varchar(255),
   primary key (usd_id),
   unique ak_usr_usf_id (usd_usr_id, usd_usf_id)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_user_data add index USD_USF_FK (usd_usf_id);
alter table %PREFIX%_user_data add index USD_USR_FK (usd_usr_id);

-- Constraints
alter table %PREFIX%_user_data add constraint %PREFIX%_FK_USD_USF foreign key (usd_usf_id)
      references %PREFIX%_user_fields (usf_id) on delete restrict on update restrict;
alter table %PREFIX%_user_data add constraint %PREFIX%_FK_USD_USR foreign key (usd_usr_id)
      references %PREFIX%_users (usr_id) on delete restrict on update restrict;

/*==============================================================*/
/* Table: adm_users                                             */
/*==============================================================*/
create table %PREFIX%_users
(
   usr_id                         int(11) unsigned               not null AUTO_INCREMENT,
   usr_login_name                 varchar(35),
   usr_password                   varchar(35),
   usr_new_password               varchar(35),
   usr_photo                      blob,
   usr_text                       text,
   usr_activation_code              varchar(10),
   usr_last_login                 datetime,
   usr_actual_login               datetime,
   usr_number_login               smallint(5) unsigned           not null default 0,
   usr_date_invalid               datetime,
   usr_number_invalid             tinyint(3) unsigned            not null default 0,
   usr_usr_id_create              int(11) unsigned,
   usr_timestamp_create           datetime                       not null,
   usr_usr_id_change              int(11) unsigned,
   usr_timestamp_change           datetime,
   usr_valid                      tinyint(1) unsigned            not null default 0,
   usr_reg_org_shortname          varchar(10),
   primary key (usr_id),
   unique ak_usr_login_name (usr_login_name)
)
engine = InnoDB
auto_increment = 1
default character set = utf8
collate = utf8_unicode_ci;

-- Index
alter table %PREFIX%_users add index USR_USR_CREATE_FK (usr_usr_id_create);
alter table %PREFIX%_users add index USR_USR_CHANGE_FK (usr_usr_id_change);
alter table %PREFIX%_users add index USR_ORG_REG_FK (usr_reg_org_shortname);

-- Constraints
alter table %PREFIX%_users add constraint %PREFIX%_FK_USR_USR_CREATE foreign key (usr_usr_id_create)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;
alter table %PREFIX%_users add constraint %PREFIX%_FK_USR_USR_CHANGE foreign key (usr_usr_id_change)
      references %PREFIX%_users (usr_id) on delete set null on update restrict;
alter table %PREFIX%_users add constraint %PREFIX%_FK_USR_ORG_REG foreign key (usr_reg_org_shortname)
      references %PREFIX%_organizations (org_shortname) on delete restrict on update restrict;

set foreign_key_checks = 1;
