-- This update would not apply using the stored procedure method 

-- Apply the Version Change from Old Version to New Version
ALTER TABLE realmd_db_version CHANGE COLUMN `required_20150420_warden_db_log` `required_20150722_01_realmcharacters_remove_constraint` BIT;

    /*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
    ALTER TABLE `realmcharacters` DROP FOREIGN KEY `realmcharacters_ibfk_2` ;
    /*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
    