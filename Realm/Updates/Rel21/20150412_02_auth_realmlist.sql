-- This update would not apply using the stored procedure method

    -- Apply the Version Change from Old Version to New Version
    ALTER TABLE realmd_db_version CHANGE COLUMN `required_20150412_warden_db_log` `required_20150412_auth_realmlist` BIT;
    
    ALTER TABLE realmlist ADD COLUMN `localAddress` VARCHAR(255) NOT NULL DEFAULT '127.0.0.1' AFTER `address`;
    ALTER TABLE realmlist ADD COLUMN `localSubnetMask` VARCHAR(255) NOT NULL DEFAULT '255.255.255.0' AFTER `localAddress`;
    