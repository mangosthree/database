-- ----------------------------------------------------------------
-- This is an attempt to create a full transactional MaNGOS update
-- Now compatible with newer MySql Databases (v1.5)
-- ----------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`; 

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mangos`()
BEGIN
    DECLARE bRollback BOOL  DEFAULT FALSE ;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `bRollback` = TRUE;

    -- Current Values (TODO - must be a better way to do this)
    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cCurStructure := (SELECT `structure` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cCurContent := (SELECT `content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);

    -- Expected Values
    SET @cOldVersion = '22'; 
    SET @cOldStructure = '04'; 
    SET @cOldContent = '047';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '04';
    SET @cNewContent = '048';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'creature_addon_Startup';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Fix_creature_addon_Startup_errors: has spell xxxx defined in `auras` field in `creature_addon, but spell is no self-only spell`.';

    -- Evaluate all settings
    SET @cCurResult := (SELECT `description` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cOldResult := (SELECT `description` FROM `db_version` WHERE `version`=@cOldVersion AND `structure`=@cOldStructure AND `content`=@cOldContent);
    SET @cNewResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

    IF (@cCurResult = @cOldResult) THEN    -- Does the current version match the expected version
        -- APPLY UPDATE
        START TRANSACTION;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        -- -- PLACE UPDATE SQL BELOW -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=56706; -- has spell 31271
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=56728; -- has spell 31271
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=56892; -- has spell 34086
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=57097; -- has spell 34303
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=57106; -- has spell 34303
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=57221; -- has spell 34086
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=57235; -- has spell 34086
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=57387; -- has spell 38966
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=58093; -- has spell 34062
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=58095; -- has spell 34062
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=59189; -- has spell 34086
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=62654; -- has spell 34871
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=65042; -- has spell 34871
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=69066; -- has spell 31271
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=71348; -- has spell 3149
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=73066; -- has spell 32423
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=73068; -- has spell 32423
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=73776; -- has spell 35190
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=73810; -- has spell 35190
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=73875; -- has spell 35190
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=73903; -- has spell 35190
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=75551; -- has spell 38966
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=78783; -- has spell 35190
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=78784; -- has spell 35190
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=82583; -- has spell 34303
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=82587; -- has spell 34303
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=82605; -- has spell 34303
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=82613; -- has spell 34303
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=83346; -- has spell 32924
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=83352; -- has spell 32924
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=83353; -- has spell 32924
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=83354; -- has spell 32924
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=83358; -- has spell 32924
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=83359; -- has spell 32924
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=84162; -- has spell 38446
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=84164; -- has spell 38446
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=84165; -- has spell 38446
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=84199; -- has spell 38034
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=84208; -- has spell 38034
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=84283; -- has spell 35782
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=84284; -- has spell 35782
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=84286; -- has spell 35782
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=91983; -- has spell 31628
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=91987; -- has spell 31631
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=112589; -- has spell 55838
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=112592; -- has spell 55840
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=112593; -- has spell 55841
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=112657; -- has spell 55840
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=112658; -- has spell 55838
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=112659; -- has spell 55841
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=112660; -- has spell 55840
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=112662; -- has spell 55838
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=112663; -- has spell 55841
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=123169; -- has spell 31411
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=123170; -- has spell 31412
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=123171; -- has spell 31413
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=123172; -- has spell 31414
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=163685; -- has spell 78909
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=166091; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=166092; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=203607; -- has spell 77854
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=203663; -- has spell 77854
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=203689; -- has spell 77855
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226617; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226621; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226623; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226642; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226645; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226649; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226762; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226781; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226794; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226795; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226796; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226797; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226801; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226802; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226803; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226834; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226835; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226860; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226862; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226863; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226864; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226886; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226887; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226889; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226893; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226904; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226910; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226941; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226942; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226944; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226946; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226947; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226948; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226949; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226950; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226967; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226968; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226969; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226971; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226972; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226973; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226991; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226992; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226993; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226996; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=226997; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227006; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227007; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227009; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227010; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227011; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227012; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227013; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227026; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227027; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227030; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227033; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227040; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227042; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227043; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227045; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227046; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227047; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227048; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227049; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227050; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227051; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227052; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227058; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227062; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227063; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227065; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227067; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227073; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227076; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227077; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227078; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227080; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227088; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227089; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227090; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227093; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227094; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227095; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227099; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227102; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227105; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227108; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227110; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227111; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227112; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227115; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227119; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227120; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227121; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227122; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227123; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227124; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227126; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227129; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227130; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227133; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227134; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227135; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227136; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227137; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227138; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227139; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227140; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227141; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227145; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227148; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227151; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227153; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227155; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227158; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=227160; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=228194; -- has spell 79976
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=273228; -- has spell 54219
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=273380; -- has spell 54219
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=273400; -- has spell 54219
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=273470; -- has spell 54219
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=281835; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282099; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282132; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282323; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282328; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282329; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282331; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282336; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282355; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282356; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282357; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282362; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282363; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282365; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282367; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282370; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282374; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282376; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282377; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282379; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282383; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282386; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282395; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282398; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=282400; -- has spell 14178
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=283360; -- has spell 15876
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=283363; -- has spell 15876
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=283408; -- has spell 15876
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=283614; -- has spell 15876
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=283671; -- has spell 15876
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=283674; -- has spell 15876
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=285482; -- has spell 21157
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=293625; -- has spell 100913
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=318130; -- has spell 45857
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=318134; -- has spell 45857
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=319483; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=319669; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=320384; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=320389; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=320390; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=320392; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=320471; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=320473; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=320477; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=320480; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=320506; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=320667; -- has spell 39550
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=322450; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=322451; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=322452; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=322454; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=322456; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=322457; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=322705; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=322739; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=322886; -- has spell 12380
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=323219; -- has spell 21157
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=323223; -- has spell 21157
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=323543; -- has spell 39550
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=323545; -- has spell 39550
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324182; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324185; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324267; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324269; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324270; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324272; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324273; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324366; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324369; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324370; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324373; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324374; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324387; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324388; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324390; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324393; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324433; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324440; -- has spell 9798
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324701; -- has spell 21157
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=324704; -- has spell 21157
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=325291; -- has spell 7083
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=325292; -- has spell 7083
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=326856; -- has spell 95514
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=326858; -- has spell 95514
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=326859; -- has spell 95514
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=326860; -- has spell 95514
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=327601; -- has spell 74911
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=327612; -- has spell 74912
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=328407; -- has spell 90169
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=328429; -- has spell 90169
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=328476; -- has spell 90169
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=328494; -- has spell 90169
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329075; -- has spell 83698
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329080; -- has spell 83697
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329380; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329381; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329382; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329383; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329384; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329385; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329386; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329388; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329389; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329390; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329391; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329392; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329393; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329394; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329395; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329396; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329397; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329398; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329399; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329400; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329401; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329402; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329403; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329404; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329405; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329406; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329407; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=329408; -- has spell 77026
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=334307; -- has spell 78017
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=334328; -- has spell 78017
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=339753; -- has spell 103678
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=340654; -- has spell 102293
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=340657; -- has spell 102293
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=340658; -- has spell 102293
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=352048; -- has spell 52871
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=356368; -- has spell 101570
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=367198; -- has spell 37119
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=367199; -- has spell 37119
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=367200; -- has spell 37119
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=367201; -- has spell 37119
UPDATE `creature_addon` SET `auras`=NULL WHERE `GUID`=367202; -- has spell 37119

        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        -- -- PLACE UPDATE SQL ABOVE -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

        -- If we get here ok, commit the changes
        IF bRollback = TRUE THEN
            ROLLBACK;
            SHOW ERRORS;
            SELECT '* UPDATE FAILED *' AS `===== Status =====`,@cCurResult AS `===== DB is on Version: =====`;
        ELSE
            COMMIT;
            -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
            -- UPDATE THE DB VERSION
            -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
            INSERT INTO `db_version` VALUES (@cNewVersion, @cNewStructure, @cNewContent, @cNewDescription, @cNewComment);
            SET @cNewResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

            SELECT '* UPDATE COMPLETE *' AS `===== Status =====`,@cNewResult AS `===== DB is now on Version =====`;
        END IF;
    ELSE    -- Current version is not the expected version
        IF (@cCurResult = @cNewResult) THEN    -- Does the current version match the new version
            SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cCurResult AS `===== DB is already on Version =====`;
        ELSE    -- Current version is not one related to this update
            IF(@cCurResult IS NULL) THEN    -- Something has gone wrong
                SELECT '* UPDATE FAILED *' AS `===== Status =====`,'Unable to locate DB Version Information' AS `============= Error Message =============`;
            ELSE
                IF(@cOldResult IS NULL) THEN    -- Something has gone wrong
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SET @cOldResult = CONCAT('Rel',@cOldVersion, '_', @cOldStructure, '_', @cOldContent, ' - ','IS NOT APPLIED');
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cOldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
                ELSE
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cOldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
                END IF;
            END IF;
        END IF;
    END IF;
END $$

DELIMITER ;

-- Execute the procedure
CALL update_mangos();

-- Drop the procedure
DROP PROCEDURE IF EXISTS `update_mangos`;


