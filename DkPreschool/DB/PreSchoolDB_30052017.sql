-- phpMyAdmin SQL Dump
-- version 4.0.10.10
-- http://www.phpmyadmin.net
--
-- Host: 213.171.218.233
-- Generation Time: May 30, 2017 at 04:34 AM
-- Server version: 5.1.73-log
-- PHP Version: 5.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `PreSchoolDB`
--
CREATE DATABASE IF NOT EXISTS `PreSchoolDB` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `PreSchoolDB`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `funcDashBoardTotals`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcDashBoardTotals`(IN `intRegion` INT(10))
BEGIN
	#Routine body goes here...

SET @BOOKTOT = 0;
SET @PROMOTOT = 0;
SET @FUNFACTS =  0;
SET @HELPTOT=  0;
SET @REGION = intRegion;

IF (@REGION=0)THEN
	SELECT COUNT(book_auto_id) INTO @BOOKTOT FROM books;
	SELECT COUNT(promo_auto_id) INTO @PROMOTOT FROM promotions;
	SELECT COUNT(funfact_auto_id) INTO @FUNFACTS FROM funfacts;
	SELECT COUNT(helppage_auto_id) INTO @HELPTOT FROM  helppages;

ELSE
	SELECT COUNT(book_auto_id) INTO @BOOKTOT FROM books WHERE book_region_id = @REGION;
	SELECT COUNT(promo_auto_id) INTO @PROMOTOT FROM promotions WHERE promo_region_id= @REGION;
	SELECT COUNT(funfact_auto_id) INTO @FUNFACTS FROM funfacts WHERE funfact_region_id = @REGION;
	SELECT COUNT(helppage_auto_id) INTO @HELPTOT FROM  helppages WHERE helppage_region_id = @REGION;

END IF;


SELECT @BOOKTOT as book_total, @PROMOTOT as promo_total, @FUNFACTS as funfacts_total, @HELPTOT as helppages_total;


END$$

DROP PROCEDURE IF EXISTS `funcGetEmail`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcGetEmail`(IN `strRegionCode` VARCHAR(3), IN `intType` TINYINT(2))
BEGIN
	#Routine body goes here...
SET @REGCODE = strRegionCode;
SET @TYPE= intType;

SELECT * FROM emails WHERE email_region_id = (SELECT region_auto_id FROM regions WHERE region_code =  @REGCODE  ) AND email_type = @TYPE LIMIT 1 ;

END$$

DROP PROCEDURE IF EXISTS `funcGetEPUB`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcGetEPUB`(IN `intID` INT(11))
BEGIN
SET @ID = intID;

SELECT book_epub,book_sample_epub,book_auto_id FROM books WHERE book_auto_id = @ID LIMIT 1;

END$$

DROP PROCEDURE IF EXISTS `funcGetFunfacts`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcGetFunfacts`(IN `strRegionCode` VARCHAR(3), IN `strStatus` VARCHAR(50))
BEGIN
	#Routine body goes here...
SET @REGCODE = strRegionCode;
SET @MODDATE = '';
SET @REGID = '';
SET @STAT = strStatus;

IF NOT  @STAT='DRAFT'  THEN
	SET @STAT = 'LIVE';
	SELECT funfact_datemodified,funfact_region_id INTO @MODATE,@REGID FROM  funfacts WHERE funfact_region_id = (SELECT region_auto_id FROM regions WHERE region_code =  @REGCODE  ) ORDER BY funfact_datemodified DESC LIMIT 1;
	SELECT (@MODATE) as lastmoddate,funfacts.* , DATEDIFF( funfact_startdate,NOW()),  DATEDIFF( funfact_enddate,NOW()) FROM funfacts WHERE funfact_region_id= @REGID AND funfact_status=@STAT AND  DATEDIFF( funfact_startdate,NOW()) <=0  AND DATEDIFF( funfact_enddate,NOW()) > 0  ORDER BY funfact_order ;
ELSE
	SELECT funfact_datemodified,funfact_region_id INTO @MODATE,@REGID FROM  funfacts WHERE funfact_region_id = (SELECT region_auto_id FROM regions WHERE region_code =  @REGCODE  ) ORDER BY funfact_datemodified DESC LIMIT 1;
	SELECT (@MODATE) as lastmoddate,funfacts.* , DATEDIFF( funfact_startdate,NOW()),  DATEDIFF( funfact_enddate,NOW()) FROM funfacts WHERE funfact_status=@STAT ORDER BY funfact_order ;
END IF;

END$$

DROP PROCEDURE IF EXISTS `funcGetHelppages`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcGetHelppages`(strRegionCode VARCHAR(3),strStatus VARCHAR(50))
BEGIN
	#Routine body goes here...
SET @REGCODE = strRegionCode;
SET @MODDATE = '';
SET @REGID = '';

SET @STAT = strStatus;

IF NOT  @STAT='DRAFT'  THEN
	SET @STAT = 'LIVE';
	SELECT helppage_dateadded,helppage_region_id INTO @MODATE,@REGID FROM  helppages WHERE helppage_region_id = (SELECT region_auto_id FROM regions WHERE region_code =  @REGCODE ) ORDER BY helppage_dateadded DESC LIMIT 1;
	SELECT (@MODATE) as lastmoddate,helppages.* FROM helppages WHERE helppage_region_id= @REGID AND helppage_status=@STAT  AND helppage_section_status =@STAT ORDER BY helppage_section_order,helppage_order ;
ELSE
	SELECT helppage_dateadded,helppage_region_id INTO @MODATE,@REGID FROM  helppages WHERE helppage_region_id = (SELECT region_auto_id FROM regions WHERE region_code =  @REGCODE ) ORDER BY helppage_dateadded DESC LIMIT 1;
	SELECT (@MODATE) as lastmoddate,helppages.* FROM helppages WHERE helppage_region_id= @REGID AND helppage_status=@STAT  AND helppage_section_status =@STAT ORDER BY helppage_section_order,helppage_order ;

END IF;


END$$

DROP PROCEDURE IF EXISTS `funcGetModDate`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcGetModDate`(IN `strRegionCode` VARCHAR(3))
BEGIN
	#Routine body goes here...
SET @REGCODE = strRegionCode;
SELECT book_datemodified FROM books WHERE book_region_id = (SELECT region_auto_id FROM regions WHERE region_code =  @REGCODE  ) ORDER BY book_datemodified DESC LIMIT 1;

END$$

DROP PROCEDURE IF EXISTS `funcGetPromos`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcGetPromos`(IN `strRegionCode` VARCHAR(3), IN `strStatus` VARCHAR(50))
BEGIN
	#Routine body goes here...
SET @REGCODE = strRegionCode;
SET @MODDATE = '';
SET @REGID = '';
SET @STAT = strStatus;

IF NOT  @STAT='DRAFT'  THEN
	SET @STAT = 'LIVE';
	SELECT promo_datemodified,promo_region_id INTO @MODATE,@REGID FROM  promotions WHERE promo_region_id = (SELECT region_auto_id FROM regions WHERE region_code =  @REGCODE  ) ORDER BY promo_datemodified DESC LIMIT 1;
	SELECT (@MODATE) as lastmoddate,promotions.* , DATEDIFF( promo_startdate,NOW()),  DATEDIFF( promo_enddate,NOW()) FROM promotions WHERE promo_region_id= @REGID AND promo_status=@STAT AND  DATEDIFF( promo_startdate,NOW()) <=0  AND DATEDIFF( promo_enddate,NOW()) > 0  ORDER BY promo_order ;
ELSE
	SELECT promo_datemodified,promo_region_id INTO @MODATE,@REGID FROM  promotions WHERE promo_region_id = (SELECT region_auto_id FROM regions WHERE region_code =  @REGCODE  ) ORDER BY promo_datemodified DESC LIMIT 1;
	SELECT (@MODATE) as lastmoddate,promotions.* , DATEDIFF( promo_startdate,NOW()),  DATEDIFF( promo_enddate,NOW()) FROM promotions WHERE  promo_status=@STAT ORDER BY promo_order ;
END IF;

END$$

DROP PROCEDURE IF EXISTS `funcGetRecords`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcGetRecords`(IN `strTable` VARCHAR(100), IN `strCols` VARCHAR(500), IN `strKeyword` VARCHAR(50), IN `strRecord` VARCHAR(50), IN `intRegion` TINYINT(4))
BEGIN

SET @TABLE = strTable;
SET @COLS = strCols;
SET @WHERE= 'WHERE 1 = 1';
SET @SQL = '';
SET @ID = strRecord;
SET @REGION = intRegion;
SET @SEARCH = strKeyword;

IF @ID <> '0' THEN
# filter by id
	SET @WHERE = CONCAT(@WHERE,' AND [#ID#] = "',@ID,'"');
END IF;

IF @REGION > 0 THEN
# filter by region id
	SET @WHERE = CONCAT(@WHERE,' AND [#REGION#] = ',@REGION );
END IF;


	CASE @TABLE
		WHEN  'books'  THEN # get data for books
			SET @WHERE = REPLACE(@WHERE,'[#ID#]','book_auto_id');
			SET @WHERE = REPLACE(@WHERE,'[#REGION#]','book_region_id');
			
			IF LENGTH(@SEARCH) > 0 THEN
				SET @WHERE  = CONCAT(@WHERE,' AND ( book_title LIKE "%',@SEARCH,'%" OR book_topics LIKE "%',@SEARCH,'%" OR book_author_name LIKE "%',@SEARCH,'%" OR book_short_desc LIKE "%',@SEARCH,'%")');
			END IF;
			SET @SQL =CONCAT('SELECT ',@COLS,' FROM books Inner Join regions ON regions.region_auto_id = books.book_region_id Inner Join readerlevel ON readerlevel.readerlevel_auto_id = books.book_reader_level  ',@WHERE);
		
		WHEN  'promos'  THEN # get data for promos
			SET @WHERE = REPLACE(@WHERE,'[#ID#]','promo_auto_id');
			SET @WHERE = REPLACE(@WHERE,'[#REGION#]','promo_region_id');
			
			IF LENGTH(@SEARCH) > 0 THEN
				SET @WHERE  = CONCAT(@WHERE,' AND ( promo_title LIKE "%',@SEARCH,'%)');
			END IF;

			SET @SQL =CONCAT('SELECT ',@COLS,' FROM promotions Inner Join regions ON regions.region_auto_id = promotions.promo_region_id  ',@WHERE,' ORDER BY promo_region_id,promo_order ');


		WHEN  'funfacts'  THEN # get data for  funfacts
			SET @WHERE = REPLACE(@WHERE,'[#ID#]','funfact_auto_id');
			SET @WHERE = REPLACE(@WHERE,'[#REGION#]','funfact_region_id');
			
			IF LENGTH(@SEARCH) > 0 THEN
				SET @WHERE  = CONCAT(@WHERE,' AND ( funfact_title LIKE "%',@SEARCH,'%)');
			END IF;

			SET @SQL =CONCAT('SELECT ',@COLS,' FROM funfacts Inner Join regions ON regions.region_auto_id = funfacts.funfact_region_id  ',@WHERE,' ORDER BY funfact_region_id,funfact_order ');

		WHEN 'helpmain' THEN
			SET @WHERE = REPLACE(@WHERE,'[#ID#]','helppage_section_guid');
			SET @WHERE = REPLACE(@WHERE,'[#REGION#]','helppage_region_id');

			IF LENGTH(@SEARCH) > 0 THEN
				SET @WHERE  = CONCAT(@WHERE,' AND ( helppage_section LIKE "%',@SEARCH,'%" OR  helppage_content LIKE "%',@SEARCH,'%")');
			END IF;

			SET @SQL = CONCAT('SELECT ',REPLACE(@COLS,'helppage_count','COUNT(helppage_auto_id) as helppage_count'),' FROM helppages Inner Join regions ON regions.region_auto_id = helppages.helppage_region_id  ',@WHERE,' GROUP BY helppage_section_guid ORDER BY helppage_region_id,helppage_section_order ');

		WHEN 'helpsub' THEN
			SET @WHERE = REPLACE(@WHERE,'[#ID#]','helppage_section_guid');
			SET @WHERE = REPLACE(@WHERE,'[#REGION#]','helppage_region_id');

			IF LENGTH(@SEARCH) > 0 THEN
				SET @WHERE  = CONCAT(@WHERE,' AND ( helppage_section LIKE "%',@SEARCH,'%" OR  helppage_content LIKE "%',@SEARCH,'%")');
			END IF;

			SET @SQL = CONCAT('SELECT ',@COLS,' FROM helppages Inner Join regions ON regions.region_auto_id = helppages.helppage_region_id  ',@WHERE,' ORDER BY helppage_order ');

		WHEN 'helpsubed' THEN
			SET @WHERE = REPLACE(@WHERE,'[#ID#]','helppage_auto_id');
			SET @WHERE = REPLACE(@WHERE,'[#REGION#]','helppage_region_id');

			IF LENGTH(@SEARCH) > 0 THEN
				SET @WHERE  = CONCAT(@WHERE,' AND ( helppage_section LIKE "%',@SEARCH,'%" OR  helppage_content LIKE "%',@SEARCH,'%")');
			END IF;

			SET @SQL = CONCAT('SELECT ',@COLS,' FROM helppages Inner Join regions ON regions.region_auto_id = helppages.helppage_region_id  ',@WHERE,' ORDER BY helppage_order ');

		WHEN  'regions'  THEN # get data for regions
			SET @SQL =  CONCAT('SELECT ',@COLS,' FROM regions ORDER BY region_code');

		WHEN  'readerlevel'  THEN # get data for readerlevel
			SET @SQL =  CONCAT('SELECT ',@COLS,' FROM readerlevel ORDER BY readerlevel_level');


		WHEN  'topics'  THEN # get data for book topics
			IF LENGTH(@SEARCH) > 0 THEN
				SET @WHERE  = CONCAT(@WHERE,' AND ( topic_name LIKE ',char(39),'%',@SEARCH,'%',char(39),')');
			END IF;
			SET @SQL =  CONCAT('SELECT ',@COLS,' FROM topics ',@WHERE,' ORDER BY topic_name');
	END CASE;

	PREPARE sqlcmd from @SQL;
	EXECUTE sqlcmd;
	# run sql string

END$$

DROP PROCEDURE IF EXISTS `funcGetStore`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcGetStore`(IN `strRegionCode` VARCHAR(3), IN `strStatus` VARCHAR(50))
BEGIN
	#Routine body goes here...
SET @REGCODE = strRegionCode;
SET @MODDATE = '';
SET @REGID = '';
SET @STAT = strStatus;

IF NOT  @STAT='DRAFT'  THEN
	SET @STAT = 'PUBLISHED';
	SELECT book_datemodified,book_region_id INTO @MODATE,@REGID FROM books WHERE book_region_id = (SELECT region_auto_id FROM regions WHERE region_code =  @REGCODE  ) ORDER BY book_datemodified DESC LIMIT 1;
	SELECT (@MODATE) as lastmoddate,readerlevel.readerlevel_level, books.* FROM books Inner Join readerlevel ON readerlevel.readerlevel_auto_id = books.book_reader_level WHERE book_region_id = @REGID AND book_status= @STAT AND DATEDIFF( book_publication_date,NOW()) <=0 ;
ELSE

SELECT book_datemodified,book_region_id INTO @MODATE,@REGID FROM books WHERE book_region_id = (SELECT region_auto_id FROM regions WHERE region_code =  @REGCODE  ) ORDER BY book_datemodified DESC LIMIT 1;
SELECT (@MODATE) as lastmoddate,readerlevel.readerlevel_level, books.* FROM books Inner Join readerlevel ON readerlevel.readerlevel_auto_id = books.book_reader_level WHERE book_status= @STAT;

END IF;


END$$

DROP PROCEDURE IF EXISTS `funcLogin`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcLogin`(IN `strUsername` VARCHAR(255), IN `strPassword` VARCHAR(255))
BEGIN
	#Routine body goes here...
SET @USER = strUsername;
SET @PASS = strPassword;

SELECT user_username,user_region_id FROM users WHERE user_username = @USER AND user_password = @PASS;

END$$

DROP PROCEDURE IF EXISTS `funcReOrder`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcReOrder`(IN `strTable` VARCHAR(50), IN `strDirect` VARCHAR(50), IN `intTo` INT(10), IN `intFrom` INT(10), IN `strField` VARCHAR(50), IN `strWhere` VARCHAR(50), IN `strID` VARCHAR(50))
BEGIN

SET @TABLE = strTable;
SET @DIREC = strDirect;

SET @ID= strID;
SET @TO = CAST(intTo AS CHAR);
SET @FROM =CAST( intFrom AS CHAR);
SET @FIELD =  strField;
SET @WHERE =  strWhere;
SET @SQL ='';

IF(@DIREC ='forward') THEN
	SET @SQL = CONCAT('UPDATE ',@TABLE,' SET ',@FIELD,' = ',@FIELD,'-1 WHERE ', @WHERE,@FIELD ,' > ', @FROM ,' AND ', @FIELD,' <= ', @TO);
ELSE
	SET @SQL = CONCAT('UPDATE ',@TABLE,' SET  ',@FIELD,' = ',@FIELD,'+1 WHERE ',@WHERE,@FIELD,' >= ',@TO,' AND ',@FIELD,'< ',@FROM);
	

END IF;

SELECT @SQL;
PREPARE sqlcmd from @SQL;
EXECUTE sqlcmd;

SET @SQL = CONCAT('UPDATE ',@TABLE,' SET  ',@FIELD,' = ',@TO,' WHERE ',@ID);

SELECT @SQL;
PREPARE sqlcmd from @SQL;
EXECUTE sqlcmd;


END$$

DROP PROCEDURE IF EXISTS `funcSaveBook`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcSaveBook`(IN `strAction` VARCHAR(50), IN `strBookTitle` VARCHAR(255), IN `strBookAuthor` VARCHAR(255), IN `strBookImage` VARCHAR(255), IN `strBookEpub` VARCHAR(255), IN `strBookSEpub` VARCHAR(255), IN `intBookLevel` TINYINT(1), IN `intBookRegion` TINYINT(5), IN `strBookShort` VARCHAR(255), IN `strBookLong` VARCHAR(3000), IN `intBookOffer` TINYINT(1), IN `intBookNew` TINYINT(1), IN `intBookFree` TINYINT(1), IN `intBookFeet` TINYINT(1), IN `intBookReadLoud` TINYINT(1), IN `dateBookPub` DATE, IN `strBookApple` VARCHAR(255), IN `strBookAndroid` VARCHAR(255), IN `strBookTopics` VARCHAR(10000), IN `strBookStatus` VARCHAR(50), IN `intBookID` INT(11))
BEGIN
 
SET @ACTION = strAction;
SET @TITLE = strBookTitle;
SET @AUTHOR = strBookAuthor;
SET @IMAGE = strBookImage;
SET @EPUB = strBookEpub;
SET @SEPUB = strBookSEpub;
SET @LEVEL = intBookLevel;
SET @REGION = intBookRegion;
SET @SHORT = strBookShort;
SET @LONG = strBookLong;
SET @NEW = intBookNew;
SET @FREE = intBookFree;
SET @FEET = intBookFeet;
SET @LOUD = intBookReadLoud;
SET @PUBDATE = dateBookPub;
SET @APPLE = strBookApple;
SET @ANDROID = strBookAndroid;
SET @TOPICS = strBookTopics;
SET @STAT = strBookStatus;
SET @OFFER = intBookOffer;

SET @ID = intBookID;

IF @ACTION = 'add' THEN
	# add new book here 
	INSERT INTO books (book_onoffer,book_title,book_author_name,book_image,book_epub,book_sample_epub,book_reader_level,book_region_id,book_short_desc,book_long_desc,book_new,book_free,book_feature,book_readaloud,book_publication_date,book_apple_purchase_id,book_android_purchase_id,book_topics,book_status,book_dateadded,book_datemodified) VALUES(@OFFER,@TITLE,@AUTHOR,@IMAGE,@EPUB,@SEPUB,@LEVEL,@REGION,@SHORT,@LONG,@NEW,@FREE,@FEET,@LOUD,@PUBDATE,@APPLE,@ANDROID,@TOPICS,@STAT,NOW(),NOW());
ELSE 
	## Edit book
	UPDATE books SET book_onoffer= @OFFER, book_title = @TITLE,book_author_name = @AUTHOR,book_image = @IMAGE,book_epub = @EPUB,book_sample_epub = @SEPUB,book_reader_level = @LEVEL,book_region_id = @REGION,book_short_desc = @SHORT,book_long_desc = @LONG,book_new = @NEW,book_free = @FREE,book_feature = @FEET,book_readaloud = @LOUD,book_publication_date = @PUBDATE,book_apple_purchase_id = @APPLE,book_android_purchase_id = @ANDROID,book_topics = @TOPICS,book_status = @STAT, book_datemodified = NOW() WHERE book_auto_id = @ID ;
END IF;

## sort tags/topics out here
CALL funcTags(@TOPICS);


END$$

DROP PROCEDURE IF EXISTS `funcSaveFunFact`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcSaveFunFact`(IN `strAction` VARCHAR(50), IN `strFunTitle` VARCHAR(255), IN `strFunImage` VARCHAR(255), IN `intFunRegion` TINYINT(5), IN `dateFunStart` DATE, IN `dateFunEnd` DATE, IN `strFunStatus` VARCHAR(50), IN `intFunID` INT(11))
BEGIN
 
SET @ACTION = strAction;
SET @REGION = intFunRegion;
SET @TITLE = strFunTitle;
SET @IMAGE = strFunImage;
SET @SDATE = dateFunStart;
SET @EDATE = dateFunEnd;
SET @STAT = strFunStatus;

SET @ID = intFunID;

IF @ACTION = 'add' THEN
	# add new funfact here 
	INSERT INTO funfacts (funfact_title,funfact_region_id,funfact_image,funfact_startdate,funfact_enddate,funfact_status,funfact_dateadded,funfact_datemodified) VALUES(@TITLE,@REGION,@IMAGE,@SDATE,@EDATE,@STAT,NOW(),NOW());
	## reorder funfacts so the new one is at the top
	UPDATE funfacts SET funfact_order = funfact_order+1 where funfact_region_id = @REGION AND NOT funfact_auto_id = LAST_INSERT_ID();


ELSE 
	## Edit funfact
	UPDATE funfacts SET funfact_title = @TITLE, funfact_region_id = @REGION, funfact_image = @IMAGE,funfact_startdate = @SDATE,funfact_enddate = @EDATE, funfact_status = @STAT, funfact_datemodified = NOW() WHERE funfact_auto_id = @ID ;
END IF;

END$$

DROP PROCEDURE IF EXISTS `funcSaveHelp`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcSaveHelp`(strAction VARCHAR(50), strHelpTitle VARCHAR(255),strHelpImage VARCHAR(255),intHelpRegion TINYINT(5),strHelpStatus VARCHAR(50), intHelpTempID INTEGER(11), strHelpCont VARCHAR(15000) , intHelpID INTEGER(11),strHelpGuid VARCHAR(50),intHelpSOrder INTEGER(11),  strHelpSTitle VARCHAR(255), strHelpSStatus VARCHAR(50))
BEGIN
 
SET @ACTION = strAction;
SET @REGION = intHelpRegion;
SET @TITLE = strHelpTitle;
SET @IMAGE = strHelpImage;
SET @STAT = strHelpStatus;
SET @TEMP = intHelpTempID;
SET @CONT = strHelpCont;
SET @ID = intHelpID;

SET @SID = strHelpGuid;
SET @SORDER = intHelpSOrder;
SET @STITLE =  strHelpSTitle;
SET @SSTAT =  strHelpSStatus;


IF @ACTION = 'add' THEN
	# add new help page here 
	
	INSERT INTO helppages (helppage_title,helppage_region_id,helppage_image,helppage_status,helppage_template_id, helppage_content,helppage_section_guid,helppage_section,helppage_section_status,helppage_dateadded,helppage_datemodified) VALUES(@TITLE,@REGION,@IMAGE,@STAT,@TEMP,@CONT,@SID,@STITLE,@SSTAT,NOW(),NOW());
	## reorder helppages so the new one is at the top
	IF @SORDER = 0 THEN
		UPDATE helppages SET helppage_section_order = helppage_section_order+1 WHERE helppage_region_id = @REGION AND NOT helppage_auto_id = LAST_INSERT_ID();
	END IF;

	UPDATE helppages SET helppage_order = helppage_order+1 WHERE helppage_region_id = @REGION AND helppage_section_guid = @SID AND NOT helppage_auto_id = LAST_INSERT_ID();


ELSE 
	## Edit helppage
	UPDATE helppages SET helppage_section = @STITLE, helppage_section_status = @SSTAT,  helppage_section_guid = @SID, helppage_title = @TITLE, helppage_region_id = @REGION, helppage_image = @IMAGE, helppage_status = @STAT, helppage_template_id = @TEMP,helppage_content = @CONT, helppage_datemodified = NOW() WHERE helppage_auto_id = @ID ;
	UPDATE helppages SET helppage_section = @STITLE, helppage_section_status = @SSTAT WHERE helppage_section_guid = @SID;

END IF;

END$$

DROP PROCEDURE IF EXISTS `funcSaveHelpSection`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcSaveHelpSection`(IN `strAction` VARCHAR(50), IN `strHelpSTitle` VARCHAR(255), IN `strHelpSStatus` VARCHAR(50), IN `strHelpSGUID` VARCHAR(50))
BEGIN
 
SET @ACTION = strAction;
SET @STITLE =  strHelpSTitle;
SET @SSTAT =  strHelpSStatus;
 SET @SID = strHelpSGUID ;


IF @ACTION = 'save' THEN
	# add new help section page here 
	UPDATE helppages SET helppage_section = @STITLE, helppage_section_status = @SSTAT WHERE helppage_section_guid = @SID;

END IF;

END$$

DROP PROCEDURE IF EXISTS `funcSavePromo`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcSavePromo`(IN `strAction` VARCHAR(50), IN `strPromoTitle` VARCHAR(255), IN `strPromoImage` VARCHAR(255), IN `strPromoImageLrg` VARCHAR(255), IN `intPromoRegion` TINYINT(5), IN `strBookIds` VARCHAR(255), IN `strPromoType` TINYINT(1), IN `datePromoStart` DATE, IN `datePromoEnd` DATE, IN `strPromoStatus` VARCHAR(50), IN `intPromoID` INT(11))
BEGIN
 
SET @ACTION = strAction;
SET @REGION = intPromoRegion;
SET @TITLE = strPromoTitle;
SET @IMAGE = strPromoImage;
SET @IMAGELRG = strPromoImageLrg;
SET @TYPE = strPromoType;
SET @BOOKIDS= strBookIds;
SET @SDATE = datePromoStart;
SET @EDATE = datePromoEnd;
SET @STAT = strPromoStatus;

SET @ID = intPromoID;

IF @ACTION = 'add' THEN
	# add new promo here 
	INSERT INTO promotions (promo_title,promo_region_id,promo_image,promo_image_lrg,promo_book_ids,promo_type,promo_startdate,promo_enddate,promo_status,promo_dateadded,promo_datemodified) VALUES(@TITLE,@REGION,@IMAGE,@IMAGELRG,@BOOKIDS,@TYPE,@SDATE,@EDATE,@STAT,NOW(),NOW());
	## reorder promos so the new one is at the top
	UPDATE promotions SET promo_order = promo_order+1 where promo_region_id = @REGION AND NOT promo_auto_id = LAST_INSERT_ID();


ELSE 
	## Edit promo
	UPDATE promotions SET promo_title = @TITLE, promo_region_id = @REGION, promo_image = @IMAGE,promo_image_lrg = @IMAGELRG,promo_type = @TYPE, promo_book_ids = @BOOKIDS,promo_startdate = @SDATE,promo_enddate = @EDATE, promo_status = @STAT, promo_datemodified = NOW() WHERE promo_auto_id = @ID ;
END IF;

END$$

DROP PROCEDURE IF EXISTS `funcTags`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` PROCEDURE `funcTags`(IN `strTags` VARCHAR(10000))
BEGIN
   
    DECLARE x INT DEFAULT 0;
    DECLARE y INT DEFAULT 0;
    SET y = 1; 
    SET @TAGS = strTags ;
	
    IF NOT @TAGS IS NULL THEN

           SELECT LENGTH(@TAGS) - LENGTH(REPLACE(@TAGS, ',', '')) INTO @noOfCommas;
     
           IF  @noOfCommas = 0 THEN
		## No Commas just one tag
		IF LENGTH(REPLACE(@TAGS,' ',''))>1  THEN
			IF  NOT EXISTS(SELECT * FROM topics WHERE topic_name = @TAGS) THEN
                		 INSERT INTO topics (topic_name,topic_used_count) VALUES(@TAGS,1);
			END IF;
		END IF;
          ELSE
		## multiple tags
                SET x = @noOfCommas + 1;
                WHILE y  <=  x DO
                   SELECT split_string(@TAGS, ',', y) INTO @tagName;
			IF LENGTH(REPLACE(@tagName,' ',''))>1  THEN
				IF  NOT EXISTS(SELECT * FROM topics WHERE topic_name = @tagName) THEN
    					 INSERT INTO topics (topic_name,topic_used_count) VALUES(@tagName,1);
				END IF;
			END IF;

                   SET  y = y + 1;
                END WHILE;
        END IF;

	## Recalculate totals and remove all unused tags
	UPDATE topics SET topic_used_count = (SELECT COUNT(book_auto_id) FROM books WHERE books.book_topics  LIKE CONCAT('%',topics.topic_name,'%')  GROUP BY book_auto_id);
	##  get tags_used totals
	DELETE FROM topics WHERE topic_used_count = 0;
	## delete unused tags

    END IF;
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `split_string`$$
CREATE DEFINER=`PreSchoolAdmin`@`%` FUNCTION `split_string`(`stringToSplit` VARCHAR(256), `sign` VARCHAR(12), `position` INT) RETURNS varchar(256) CHARSET latin1
BEGIN
        RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(stringToSplit, sign, position),LENGTH(SUBSTRING_INDEX(stringToSplit, sign, position -1)) + 1), sign, '');
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
CREATE TABLE IF NOT EXISTS `books` (
  `book_auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `book_region_id` tinyint(5) DEFAULT NULL,
  `book_title` varchar(255) DEFAULT NULL,
  `book_reader_level` tinyint(1) DEFAULT '0' COMMENT '1-5',
  `book_short_desc` varchar(255) DEFAULT NULL,
  `book_long_desc` varchar(3000) DEFAULT NULL,
  `book_author_name` varchar(255) DEFAULT NULL,
  `book_image` varchar(255) DEFAULT NULL,
  `book_new` tinyint(1) DEFAULT '0' COMMENT '0 = false 1 = true',
  `book_free` tinyint(1) DEFAULT '0' COMMENT '0 = false 1 = true',
  `book_feature` tinyint(1) DEFAULT '0' COMMENT '0 = false 1 = true',
  `book_onoffer` tinyint(1) DEFAULT '0' COMMENT '0 = false 1 = true',
  `book_readaloud` tinyint(1) DEFAULT '0' COMMENT '0 = false 1 = true',
  `book_epub` varchar(255) DEFAULT NULL,
  `book_sample_epub` varchar(255) DEFAULT NULL,
  `book_publication_date` date DEFAULT NULL,
  `book_apple_purchase_id` varchar(255) DEFAULT NULL,
  `book_android_purchase_id` varchar(255) DEFAULT NULL,
  `book_topics` varchar(10000) DEFAULT NULL,
  `book_status` varchar(50) DEFAULT 'DRAFT' COMMENT 'DRAFT,PUBLISHED,UNPUBLISHED',
  `book_dateadded` datetime DEFAULT NULL,
  `book_datemodified` datetime DEFAULT NULL,
  PRIMARY KEY (`book_auto_id`),
  UNIQUE KEY `auto_id` (`book_auto_id`),
  KEY `region` (`book_region_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=245 ;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`book_auto_id`, `book_region_id`, `book_title`, `book_reader_level`, `book_short_desc`, `book_long_desc`, `book_author_name`, `book_image`, `book_new`, `book_free`, `book_feature`, `book_onoffer`, `book_readaloud`, `book_epub`, `book_sample_epub`, `book_publication_date`, `book_apple_purchase_id`, `book_android_purchase_id`, `book_topics`, `book_status`, `book_dateadded`, `book_datemodified`) VALUES
(170, 1, 'Little Hide and Seek: Animals', 2, 'Play I-spy with your toddler as they learn about animals with this interactive ebook. ', 'Get busy searching these lively hide-and-seek scenes. \r\n\r\nFully interactive with fun sounds and fun animation, your child will want to return to it again and again. \r\n\r\nLook, learn and play together!', '', 'little_hide_and_seek_animals_2.jpg', 0, 0, 0, 0, 0, 'little_hide_and_seek_animals_1.epub', 'little_hide_and_seek_animals_sample_1.epub', '2015-01-28', '9780241239414', '', '|Animals|,|Little Hide and Seek|', 'PUBLISHED', '2015-02-27 11:37:03', '2016-04-21 09:46:01'),
(171, 1, 'Baby Hide and Seek!', 6, 'Help your baby learn as you play hide and seek in this interactive ebook. ', 'Your little one will love playing hide and seek and looking for the hidden animals: from a smiley hippo to a playful monkey!\r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_hide_and_seek_6.jpg', 0, 0, 0, 0, 0, 'baby_hide_and_seek_1.epub', 'baby_hide_and_seek_sample_1.epub', '2015-02-27', '9780241239315', '', '|Hide and Seek|,|Baby|', 'PUBLISHED', '2015-02-27 17:19:16', '2016-04-21 09:43:21'),
(172, 1, 'Baby Peekaboo!', 6, 'Help your baby learn as you play peekaboo in this interactive ebook.', 'Your baby will love playing peekaboo and looking for their toys: from a cuddly teddy to a shaggy dog! \r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_peekaboo_3.jpg', 0, 0, 0, 0, 0, 'baby_peekaboo_1.epub', 'baby_peekaboo_sample_1.epub', '2015-03-03', '9780241239322', '', '|Hide and Seek|,|Baby|', 'PUBLISHED', '2015-03-03 11:40:29', '2016-04-21 09:43:51'),
(173, 1, 'Baby Tractor!', 6, 'Help your baby learn as you play find the tractor in this interactive ebook. ', 'From an old vintage tractor to a mighty eight-wheeled tractor, your baby will have fun looking for all the different kind of tractors!\r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_tractor_7.jpg', 0, 0, 0, 0, 0, 'baby_tractor_1.epub', 'baby_tractor_sample_1.epub', '2015-03-03', '9780241239353', '', '|Farm|,|Baby|,|Trucks|', 'PUBLISHED', '2015-03-03 19:14:08', '2015-04-14 15:47:18'),
(174, 1, 'Baby Animals!', 6, 'Help your baby learn all about baby animals with this interactive ebook.', 'From fluffy kittens to cute puppies, your baby will have fun looking at these adorable baby animals! \r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_animals_2.jpg', 0, 0, 0, 0, 0, 'baby_animals_2.epub', 'baby_animals_sample_1.epub', '2015-03-03', '9781409377221', '', '|Animals|,|Baby|', 'UNPUBLISHED', '2015-03-03 19:15:00', '2016-06-21 14:09:58'),
(175, 1, 'Baby Bedtime!', 6, 'Help your baby learn all about bedtime with this interactive ebook. ', 'From fluffy blankets to cuddly teddies, your baby will love learning about bedtime!\r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_bedtime_2.jpg', 0, 0, 1, 0, 0, 'baby_bedtime_1.epub', 'baby_bedtime_sample_1.epub', '2015-03-03', '9780241239278', '', '|Bedtime|,|Baby|', 'PUBLISHED', '2015-03-03 19:15:53', '2016-05-03 12:36:43'),
(176, 1, 'Little Hide and Seek: Words', 2, 'Play I-spy with your toddler as they learn first words with this interactive ebook. ', 'With hide-and-seek scenes and a teddy hiding on each one, your toddler will love finding objects in each scene and learning first words as they hunt! \r\n\r\nFully interactive, with entertaining sounds and lively animation, your child will want to return to this ebook again and again! \r\n\r\nLook, learn and play together.', '', 'little_hide_and_seek_words_3.jpg', 0, 0, 1, 0, 0, 'little_hide_and_seek_words_1.epub', 'little_hide_and_seek_words_sample_1.epub', '2015-03-03', '9780241239421', '', '|Words|,|Little Hide and Seek|', 'PUBLISHED', '2015-03-03 19:17:12', '2016-05-03 12:39:46'),
(177, 1, 'Sophie la girafeÂ®: Sophie Pop-Up Peekaboo!', 4, 'Play peekaboo with Sophie and her friends. Where is Sophie hiding?', 'Toddlers and babies will giggle in delight at the animated surprises in this adorable interactive ebook with rhyming text. \r\n\r\nSophie''s playing peekaboo with her little cat, Lazare. Is Sophie in the toy box? Come out Sophie, wherever you are! \r\n\r\nAvailable with text that lights up as you read along and playful images and sounds.', '', 'sophie_la_girafe_sophie_popup_peekaboo_1.jpg', 0, 0, 0, 0, 0, 'sophie_la_girafe_sophie_popup_peekaboo_1.epub', 'sophie_la_girafe_sophie_popup_peekaboo_sample_1.epub', '2015-03-03', '9780241239537', '', '|Storytime|,|Hide and Seek|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-03 19:18:25', '2016-04-21 12:02:53'),
(178, 1, 'Sophie la girafeÂ®: Playtime with Sophie', 4, 'Come and play with Sophie and her friends! ', 'Babies will love Playtime with Sophie, an interactive story with sound and animation, which will have them giggling in delight. \r\n\r\nWith playful sounds and animation, watch your little one bounce the ball, rev the train and pop the bubbles in this exciting ebook.', '', 'sophie_la_girafe_playtime_with_sophie_1.jpg', 0, 0, 0, 0, 0, 'sophie_la_girafe_playtime_with_sophie_1.epub', 'sophie_la_girafe_playtime_with_sophie_sample_1.epub', '2015-03-03', '9780241239513', '', '|Storytime|,|Playtime|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-03 19:19:24', '2016-04-21 12:02:20'),
(179, 1, 'Sophie la girafeÂ®: Sophie and Friends', 4, 'Meet Sophie and her five special friends. ', 'This lovely story combines lively text, beautiful illustration, sound and animation to introduce your child to Sophie''s five little friends; meet Lazare the cat, Kiwi the bird, Margot the turtle, Josephine the mouse, and Gabin the bear. \r\n\r\nExplore Sophie''s house and discover all the things Sophie and her friends love to do. Play games in the living room, cook in the kitchen, pick fruit in the garden, and pile on the bed for storytime!', '', 'sophie_la_girafe_sophie_and_friends_1.jpg', 0, 0, 0, 0, 0, 'sophie_la_girafe_sophie_and_friends_1.epub', 'sophie_la_girafe_sophie_and_friends_sample_1.epub', '2015-03-03', '9780241239520', '', '|Storytime|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-03 19:20:32', '2015-03-26 12:42:32'),
(180, 1, 'Who am I? Pets', 5, 'Can you guess which pets are hiding?', 'Who Am I? Pets is perfect for inquisitive toddlers. Who lives in water and has orange scales? A goldfish, of course! \r\n\r\nBright pages, great images, sounds and playful animations, will keep your toddler engaged over and over again. A perfect combination of learning and play.', '', 'who_am_i_pets_3.jpg', 0, 0, 0, 0, 0, 'who_am_i_pets_1.epub', 'who_am_i_pets_sample_1.epub', '2015-03-03', '9780241239568', '', '|Animals|,|Who am I?|', 'PUBLISHED', '2015-03-03 19:21:40', '2015-04-14 16:07:24'),
(181, 1, 'Who am I? Wild Animals', 5, 'Can you guess which wild animals are hiding?', 'Who Am I? Wild Animals is perfect for inquisitive toddlers. Who lives in the trees and has bright feathers? A parrot, of course! \r\n\r\nBright pages, great images, sounds and playful animations, will keep your toddler engaged over and over again. A perfect combination of learning and play.', '', 'who_am_i_wild_animals_3.jpg', 0, 0, 0, 0, 0, 'who_am_i_wild_animals_1.epub', 'who_am_i_wild_animals_sample_1.epub', '2015-03-03', '9780241239575', '', '|Animals|,|Who am I?|', 'PUBLISHED', '2015-03-03 19:22:47', '2015-04-14 16:07:36'),
(182, 1, 'Baby Colours!', 6, 'Help your baby learn all about colours with this ebook.', 'From finding smiley green frogs to a pretty red windmill, your baby will enjoy learning about colours! \r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_colours_3.jpg', 0, 0, 0, 0, 0, 'baby_colours_1.epub', 'baby_colours_sample_1.epub', '2015-03-06', '9780241239292', '', '|Baby|,|Colours|', 'PUBLISHED', '2015-03-06 14:40:00', '2015-04-14 15:45:33'),
(183, 1, 'My First Animals: Let''s Squeak and Squawk!', 1, 'Let''s get busy and learn about animals with this interactive ebook.', 'With lots of colourful images, fun-filled questions on pets, farm animals and even mini-beasts, your toddler will love learning about animals which squeak and squawk with this ebook.\r\n\r\nFrom counting tropical fish to mimicking a parrot, fun questions on every page will help develop early speaking and listening skills. \r\n\r\nThe playful images in this ebook are enhanced with animations and sounds and will be loved by all.', '', 'my_first_animals_lets_squeak_and_squawk_4.jpg', 0, 0, 0, 0, 0, 'my_first_animals_lets_squeak_and_squawk_1.epub', 'my_first_animals_lets_squeak_and_squawk_sample_1.epub', '2015-03-10', '9780241239360', '', '|Animals|,|Let''s get busy|', 'PUBLISHED', '2015-03-10 11:43:25', '2016-04-21 09:46:28'),
(184, 1, 'My First Farm: Let''s Get Working!', 1, 'Let''s get busy and learn all about life on the farm with this interactive ebook. ', 'With lots of colourful images, fun-filled questions, amazing animals and noisy machines, your toddler will love learning about things that work on a farm with this ebook. \r\n\r\nFrom counting tractors to finding animals, fun questions on every page will help develop early speaking and listening skills. \r\n\r\nThe playful images in this ebook are enhanced with animations and sounds making this a truly interactive experience.', '', 'my_first_farm_lets_get_working_4.jpg', 0, 0, 0, 0, 0, 'my_first_farm_lets_get_working_1.epub', 'my_first_farm_lets_get_working_sample_1.epub', '2015-03-10', '9780241239384', '', '|Farm|,|Let''s get busy|', 'PUBLISHED', '2015-03-10 11:45:51', '2016-04-21 09:46:53'),
(185, 1, 'My First Words: Let''s Get Talking!', 1, 'Let''s get busy and learn lots of new words with this interactive ebook.', 'With lots of fun-filled images, simple questions and things to name, your toddler will love learning first words using this colourful ebook. \r\n\r\nIdentify the goldfish, teddy and car, and even encourage your child to choose their favourite pet! This ebook makes teaching your toddler first words as easy as A B C. \r\n\r\nThe playful images in this ebook are enhanced with animations and sounds making this a truly interactive experience.', '', 'my_first_words_lets_get_talking_3.jpg', 0, 0, 0, 0, 0, 'my_first_words_lets_get_talking_1.epub', 'my_first_words_lets_get_talking_sample_1.epub', '2015-03-10', '', '', '|Words|,|Let''s get busy|', 'UNPUBLISHED', '2015-03-10 11:47:23', '2016-06-21 14:09:47'),
(186, 2, 'Baby Woof Woof!', 6, 'Help your baby learn all about baby animals with this interactive ebook.', 'From fluffy kittens to cute puppies, your baby will have fun looking at these adorable baby animals! \r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_woof_woof_2.jpg', 0, 0, 0, 0, 0, 'baby_woof_woof_1.epub', 'baby_woof_woof_sample_1.epub', '2015-03-19', '9781465444325', '', '|Baby|,|Animals|', 'PUBLISHED', '2015-03-19 13:11:42', '2016-04-21 09:45:50'),
(187, 1, 'Baby Baa Baa!', 6, 'Help your baby learn all about farm animals with this interactive ebook.', 'From finding a woolly sheep to a cute yellow duck, your baby will love learning about farm animals! \r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_baa_baa_3.jpg', 0, 0, 0, 0, 0, 'baby_baa_baa_1.epub', 'baby_baa_baa_sample_1.epub', '2015-03-19', '9780241239254', '', '|Baby|,|Animals|,|Farm|', 'PUBLISHED', '2015-03-19 13:14:52', '2015-04-14 15:44:38'),
(188, 2, 'Baby Baa Baa!', 6, 'Help your baby learn all about farm animals with this interactive ebook.', 'From finding a woolly sheep to a cute yellow duck, your baby will love learning about farm animals! \r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_baa_baa_4.jpg', 0, 0, 0, 0, 0, 'baby_baa_baa_2.epub', 'baby_baa_baa_sample_2.epub', '2015-03-19', '9781465444332', '', '|Baby|,|Farm|,|Animals|', 'PUBLISHED', '2015-03-19 13:15:48', '2015-04-14 15:49:30'),
(189, 1, 'Baby Bathtime!', 6, 'Help your baby learn all about bathtime with this interactive ebook.', 'From fluffy towels to a cute rubber duck, your baby will love learning about bathtime!\r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_bathtime_3.jpg', 0, 0, 1, 0, 0, 'baby_bathtime_1.epub', 'baby_bathtime_sample_1.epub', '2015-03-19', '9780241239261', '', '|Baby|,|Bathtime|', 'PUBLISHED', '2015-03-19 13:20:16', '2016-05-03 12:36:22'),
(190, 2, 'Baby Bathtime!', 6, 'Help your baby learn all about bathtime with this interactive ebook.', 'From fluffy towels to a cute rubber duck, your baby will love learning about bathtime!\r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_bathtime_4.jpg', 0, 0, 0, 0, 0, 'baby_bathtime_2.epub', 'baby_bathtime_sample_2.epub', '2015-03-19', '9781465444349', '', '|Baby|,|Bathtime|', 'PUBLISHED', '2015-03-19 13:25:53', '2016-04-21 09:42:11'),
(191, 2, 'Baby Night Night!', 6, 'Help your baby learn all about bedtime with this interactive ebook. ', 'From fluffy blankets to cuddly teddy bears, your baby will love learning about bedtime!\r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_night_night_2.jpg', 0, 0, 1, 0, 0, 'baby_night_night_1.epub', 'baby_night_night_sample_1.epub', '2015-03-19', '9781465444356', '', '|Baby|,|Bedtime|', 'PUBLISHED', '2015-03-19 13:27:00', '2016-05-03 12:37:15'),
(192, 1, 'Baby Beep! Beep!', 6, 'Help your baby learn all about transport with this interactive ebook.', 'From a tough dump truck to a shiny red fire engine, your baby will love looking for and learning about vehicles!\r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_beep_beep_3.jpg', 0, 0, 0, 0, 0, 'baby_beep_beep_1.epub', 'baby_beep_beep_sample_1.epub', '2015-03-19', '9780241239285', '', '|Baby|,|Trucks|', 'PUBLISHED', '2015-03-19 13:28:01', '2015-04-14 15:45:11'),
(193, 2, 'Baby Beep! Beep!', 6, 'Help your baby learn all about transport with this interactive ebook.', 'From a tough dump truck to a shiny red fire engine, your baby will love looking for and learning about vehicles!\r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_beep_beep_4.jpg', 0, 0, 0, 0, 0, 'baby_beep_beep_2.epub', 'baby_beep_beep_sample_2.epub', '2015-03-19', '9781465444363', '', '|Baby|,|Trucks|', 'PUBLISHED', '2015-03-19 13:28:58', '2015-04-14 15:49:53'),
(194, 2, 'Baby Colors!', 6, 'Help your baby learn all about colors with this ebook.', 'From finding smiley green frogs to a pretty red pinwheel, your baby will enjoy learning about colors!\r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_colors_3.jpg', 0, 0, 0, 0, 0, 'baby_colors_1.epub', 'baby_colors_sample_1.epub', '2015-03-19', '9781465444370', '', '|Baby|,|Colors|', 'PUBLISHED', '2015-03-19 13:29:59', '2015-04-14 15:56:05'),
(195, 1, 'Baby Faces!', 6, 'Help your baby discover adorable baby faces in this ebook. ', 'From a happy baby to a sleepy baby, your little one will love looking at these adorable baby faces! \r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_faces_3.jpg', 0, 0, 0, 0, 0, 'baby_faces_1.epub', 'baby_faces_sample_1.epub', '2015-03-19', '9780241239308', '', '|Baby|', 'PUBLISHED', '2015-03-19 13:30:51', '2015-04-14 15:45:43'),
(196, 2, 'Baby Faces!', 6, 'Help your baby discover adorable baby faces in this ebook. ', 'From a happy baby to a sleepy baby, your child will love looking at these adorable baby faces! \r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_faces_4.jpg', 0, 0, 0, 0, 0, 'baby_faces_2.epub', 'baby_faces_sample_2.epub', '2015-03-19', '9781465446053', '', '|Baby|', 'PUBLISHED', '2015-03-19 13:33:03', '2015-04-14 15:56:24'),
(197, 2, 'Baby Hide and Seek!', 6, 'Help your baby learn as you play hide and seek in this interactive ebook. ', 'Your baby will love playing hide and seek and looking for the hidden animals: from a smiley hippo to a playful monkey!\r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_hide_and_seek_7.jpg', 0, 0, 0, 0, 0, 'baby_hide_and_seek_2.epub', 'baby_hide_and_seek_sample_2.epub', '2015-03-19', '9781465444387', '', '|Baby|,|Hide and Seek|', 'PUBLISHED', '2015-03-19 13:34:10', '2016-04-21 09:43:30'),
(198, 2, 'Baby Peekaboo!', 6, 'Help your baby learn as you play peekaboo in this interactive ebook.', 'Your baby will love playing peekaboo and looking for their toys: from a cuddly teddy bear to a shaggy dog! \r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_peekaboo_4.jpg', 0, 0, 0, 0, 0, 'baby_peekaboo_2.epub', 'baby_peekaboo_sample_2.epub', '2015-03-19', '9781465444394', '', '|Baby|,|Hide and Seek|', 'PUBLISHED', '2015-03-19 13:35:16', '2016-04-21 09:43:59'),
(199, 1, 'Baby Pets!', 6, 'Help baby discover the world of pets with this interactive ebook.', 'From a sparkly-eyed cat to a twinkly goldfish, your child will love discovering all about pets! \r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_pets_3.jpg', 0, 0, 0, 0, 0, 'baby_pets_1.epub', 'baby_pets_sample_1.epub', '2015-03-19', '9780241239339', '', '|Baby|,|Animals|', 'PUBLISHED', '2015-03-19 13:36:12', '2015-04-14 15:46:52'),
(200, 2, 'Baby Pets!', 6, 'Help baby discover the world of pets with this interactive ebook. ', 'From a sparkly-eyed cat to a twinkly goldfish, your child will love discovering all about pets! \r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_pets_4.jpg', 0, 0, 0, 0, 0, 'baby_pets_2.epub', 'baby_pets_sample_2.epub', '2015-03-19', '9781465444400', '', '|Baby|,|Animals|', 'PUBLISHED', '2015-03-19 13:37:01', '2015-04-14 15:57:05'),
(201, 1, 'Baby Playtime!', 6, 'Help your baby learn all about playtime with this interactive ebook. ', 'Your baby will have fun finding the hidden toys in this ebook! \r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_playtime_3.jpg', 0, 0, 0, 0, 0, 'baby_playtime_1.epub', 'baby_playtime_sample_1.epub', '2015-03-19', '9780241239346', '', '|Baby|,|Playtime|', 'PUBLISHED', '2015-03-19 13:38:02', '2016-04-21 09:44:14'),
(202, 2, 'Baby Playtime!', 6, 'Help your baby learn all about playtime with this interactive ebook. ', 'Your baby will have fun finding the hidden toys in this ebook! \r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_playtime_4.jpg', 0, 0, 0, 0, 0, 'baby_playtime_2.epub', 'baby_playtime_sample_2.epub', '2015-03-19', '9781465444417', '', '|Baby|,|Playtime|', 'PUBLISHED', '2015-03-19 13:38:53', '2015-04-14 15:57:16'),
(203, 2, 'Baby Tractor!', 6, 'Help your baby learn as you play find the tractor in this interactive ebook. ', 'From an old vintage tractor to a mighty eight-wheeled tractor, your baby will have fun looking for all the different kind of tractors!\r\n\r\nWith lively photographic images and text, enhanced with playful animation and sound, your little one will want to explore this ebook again and again! \r\n\r\nThe DK ''baby'' book series is perfect for reading together and reading aloud to encourage early word recognition.', '', 'baby_tractor_8.jpg', 0, 0, 0, 0, 0, 'baby_tractor_2.epub', 'baby_tractor_sample_2.epub', '2015-03-19', '9781465444424', '', '|Baby|,|Trucks|,|Farm|', 'PUBLISHED', '2015-03-19 13:39:54', '2015-04-14 15:57:31'),
(204, 2, 'Little Hide and Seek: Animals', 2, 'Play I-spy with your toddler as they learn about animals with this interactive ebook. ', 'Get busy searching these lively hide-and-seek scenes. \r\n\r\nFully interactive with fun sounds and fun animation, your child will want to return to it again and again. \r\n\r\nLook, learn, and play together!', '', 'little_hide_and_seek_animals_3.jpg', 0, 0, 0, 0, 0, 'little_hide_and_seek_animals_2.epub', 'little_hide_and_seek_animals_sample_2.epub', '2015-03-19', '9781465444431', '', '|Little Hide and Seek|,|Animals|', 'PUBLISHED', '2015-03-19 13:42:42', '2016-04-21 09:46:11'),
(205, 2, 'Little Hide and Seek: Words', 2, 'Play I-spy with your toddler as they learn first words with this interactive ebook. ', 'With hide-and-seek scenes and a teddy bear hiding on each one, your toddler will love finding objects in each scene and learning first words as they hunt! \r\n\r\nFully interactive, with entertaining sounds and lively animation, your child will want to return to this ebook again and again! \r\n\r\nLook, learn, and play together.', '', 'little_hide_and_seek_words_4.jpg', 0, 0, 1, 0, 0, 'little_hide_and_seek_words_2.epub', 'little_hide_and_seek_words_sample_2.epub', '2015-03-19', '9781465444448', '', '|Little Hide and Seek|,|Animals|', 'PUBLISHED', '2015-03-19 13:43:44', '2016-05-03 12:40:00'),
(206, 2, 'My First Animals: Let''s Squeak and Squawk!', 1, 'Let''s get busy and learn about animals with this interactive ebook.', 'With lots of colorful images, fun-filled questions on pets, farm animals, and even creepy crawlies, your toddler will love learning about animals which squeak and squawk with this ebook.\r\n\r\nFrom counting tropical fish to mimicking a parrot, fun questions on every page will help develop early speaking and listening skills. \r\n\r\nThe playful images in this ebook are enhanced with animations and sounds and will be loved by all.', '', 'my_first_animals_lets_squeak_and_squawk_3.jpg', 0, 0, 0, 0, 0, 'my_first_animals_lets_squeak_and_squawk_4.epub', 'my_first_animals_lets_squeak_and_squawk_sample_4.epub', '2015-03-23', '9781465444486', '', '|Animals|', 'PUBLISHED', '2015-03-23 11:29:39', '2016-04-21 09:46:36'),
(207, 1, 'My First Things That Go: Let''s Get Moving', 1, 'Let''s get busy and learn all about things that go with this interactive ebook.', 'With lots of colourful pictures, fun-filled questions and amazing vehicles, your toddler will love learning about things that move in this playful ebook.\r\n\r\nCount the blue cars, and explore the fire engines, tractors and trains! A great way to teach your teach your child about things that go.\r\n\r\nThe playful images in this ebook are enhanced with animations and sounds making this a truly interactive experience.', '', 'my_first_things_that_go_lets_get_moving_1.jpg', 0, 0, 0, 0, 0, 'my_first_things_that_go_lets_get_moving_1.epub', 'my_first_things_that_go_lets_get_moving_sample_1.epub', '2015-03-23', '9780241239391', '', '|Trucks|,|Let''s get busy|', 'PUBLISHED', '2015-03-23 11:58:29', '2015-04-14 14:26:10'),
(208, 2, 'My First Farm: Let''s Get Working!', 1, 'Let''s get busy and learn all about life on the farm with this interactive ebook. ', 'With lots of colorful images, fun-filled questions, amazing animals, and noisy machines, your toddler will love learning about things that work on a farm with this ebook. \r\n\r\nFrom counting tractors to finding animals, fun questions on every page will help develop early speaking and listening skills. \r\n\r\nThe playful images in this ebook are enhanced with animations and sounds making this a truly interactive experience.', '', 'my_first_farm_lets_get_working_3.jpg', 0, 0, 0, 0, 0, 'my_first_farm_lets_get_working_3.epub', 'my_first_farm_lets_get_working_sample_3.epub', '2015-03-23', '9781465444509', '', '|Farm|,|Let''s get busy|', 'PUBLISHED', '2015-03-23 12:00:16', '2016-04-21 09:47:16'),
(209, 2, 'My First Things That Go: Let''s Get Moving', 1, 'Let''s get busy and learn all about things that go with this interactive ebook.', 'With lots of colorful pictures, fun-filled questions, and amazing vehicles, your toddler will love learning about things that go in this playful ebook.\r\n\r\nCount the blue cars, and explore the fire engines, tractors, and trains! A great way to teach your teach your child about things that go.\r\n\r\nThe playful images in this ebook are enhanced with animations and sounds making this a truly interactive experience.', 'DK', 'my_first_things_that_go_lets_get_moving_2.jpg', 0, 0, 0, 0, 0, 'my_first_things_that_go_lets_get_moving_2.epub', 'my_first_things_that_go_lets_get_moving_sample_2.epub', '2015-03-23', '9781465445278', '', '|Trucks|,|Let''s get busy|', 'PUBLISHED', '2015-03-23 12:01:51', '2015-04-14 14:26:31'),
(210, 2, 'My First Words: Let''s Get Talking!', 1, 'Let''s get busy and learn lots of new words with this interactive ebook. ', 'With lots of fun-filled images, simple questions, and things to name, your toddler will love learning first words using this colorful ebook. \r\n\r\nIdentify the goldfish, teddy bear, and car, and even encourage your child to choose their favorite pet! This ebook makes teaching your toddler first words as easy as A B C. \r\n\r\nThe playful images in this ebook are enhanced with animations and sounds making this a truly interactive experience.', '', 'my_first_words_lets_get_talking_2.jpg', 0, 0, 0, 0, 0, 'my_first_words_lets_get_talking_2.epub', 'my_first_words_lets_get_talking_sample_2.epub', '2015-03-23', '9781465445285', '', '|Words|,|Let''s get busy|', 'PUBLISHED', '2015-03-23 12:03:33', '2016-04-21 09:47:40'),
(211, 1, 'Sophie la girafeÂ®: Colours', 4, 'Help your child learn all about colours with Sophie and her friends.', 'Your baby will love finding Sophie and her friends in this adorable ebook! Can you find Josephine the Mouse? Where are Margot the Turtle and Kiwi the Bird? All are here, ready to be revealed! \r\n\r\nPerfect for reading aloud and encouraging first-word learning and essential pre-reading skills, you and your little one will want to explore this ebook again and again.', '', 'sophie_la_girafe_colours_1.jpg', 0, 0, 0, 0, 0, 'sophie_la_girafe_colours_1.epub', 'sophie_la_girafe_colours_sample_1.epub', '2015-03-23', '9780241239483', '', '|Colours|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-23 12:05:52', '2016-04-21 12:01:37'),
(212, 2, 'Sophie la girafeÂ®: Colors', 4, 'Help your child learn all about colors with Sophie and her friends.', 'Your baby will love finding Sophie and her friends in this adorable ebook! Can you find Josephine the Mouse? Where are Margot the Turtle and Kiwi the Bird? All are here, ready to be revealed! \r\n\r\nPerfect for reading aloud and encouraging first-word learning and essential pre-reading skills, you and your little one will want to explore this ebook again and again.', '', 'sophie_la_girafe_colors_1.jpg', 0, 0, 0, 0, 0, 'sophie_la_girafe_colors_1.epub', 'sophie_la_girafe_colors_sample_1.epub', '2015-03-23', '9781465445292', '', '|Colors|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-23 12:07:24', '2016-04-21 09:47:46'),
(213, 1, 'Sophie la girafeÂ®: First Words', 4, 'Learn lots of new words to use around the home and garden with Sophie and her friends.  ', 'Your baby will love finding Sophie''s toys, food, and other everyday objects in Sophie la girafeÂ® First Words. \r\n\r\nWhich bedroom object hiding behind Sophie''s bed goes tick-tock? What says quack quack that''s hiding in Sophie''s toy box? All the home and garden objects are here, ready to be revealed! \r\n\r\nFilled with engaging illustrations and text, babies and toddlers will want to explore this ebook again and again.', '', 'sophie_la_girafe_first_words_3.jpg', 0, 0, 1, 0, 0, 'sophie_la_girafe_first_words_1.epub', 'sophie_la_girafe_first_words_sample_1.epub', '2015-03-23', '9780241239490', '', '|Words|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-23 12:09:38', '2016-05-03 12:46:18'),
(214, 2, 'Sophie la girafeÂ®: First Words', 4, 'Learn lots of new words to use around the home and garden with Sophie and her friends. ', 'Your baby will love finding Sophie''s toys, food, and other everyday objects in Sophie la girafeÂ® First Words. \r\n\r\nWhich bedroom object hiding behind Sophie''s bed goes tick-tock? What says quack quack that''s hiding in Sophie''s toy box? All the home and garden objects are here, ready to be revealed! \r\n\r\nFilled with engaging illustrations and text, babies and toddlers will want to explore this ebook again and again.', '', 'sophie_la_girafe_first_words_2.jpg', 0, 0, 1, 0, 0, 'sophie_la_girafe_first_words_2.epub', 'sophie_la_girafe_first_words_sample_2.epub', '2015-03-23', '9781465445308', '', '|Words|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-23 12:11:17', '2016-05-03 12:46:12'),
(215, 2, 'Sophie la girafeÂ®: Let''s Get Counting!', 4, 'Let''s get counting with Sophie la girafeÂ®!', 'Join Sophie and friends and get counting with this interactive ebook. This interactive ebook has sound and animation and will have them giggling in delight!', '', 'sophie_la_girafe_lets_get_counting_1.jpg', 0, 0, 0, 0, 0, 'sophie_la_girafe_lets_get_counting_1.epub', 'sophie_la_girafe_lets_get_counting_sample_1.epub', '2015-03-23', '9781465445315', '', '|Numbers|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-23 12:13:17', '2015-03-26 12:41:58'),
(216, 1, 'Sophie la girafeÂ®: Peekaboo Sophie!', 4, 'Let''s play peekaboo with Sophie and her friends!', 'Play peekaboo with Sophie and her friends and hear your baby giggle in delight as hidden surprises are revealed! \r\n\r\nProviding your baby with hours of peekaboo fun, watch as Sophie finds Josephine the Mouse and Kiwi the Bird. And what''s under the flower? It''s Lazare the cat! \r\n\r\nYour little one will love this interactive ebook which is the ideal way to develop imagination, early reading, and fine motor skills.', '', 'sophie_la_girafe_peekaboo_sophie_1.jpg', 0, 0, 1, 0, 0, 'sophie_la_girafe_peekaboo_sophie_1.epub', 'sophie_la_girafe_peekaboo_sophie_sample_1.epub', '2015-03-23', '9780241239506', '', '|Hide and Seek|,|Storytime|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-23 12:15:23', '2016-05-03 12:46:22'),
(217, 2, 'Sophie la girafeÂ®: Peekaboo Sophie!', 4, 'Let''s play peekaboo with Sophie and her friends!', 'Play peekaboo with Sophie and her friends and hear your baby giggle in delight as hidden surprises are revealed! \r\n\r\nProviding your baby with hours of peekaboo fun, watch as Sophie finds Josephine the Mouse and Kiwi the Bird. And what''s under the flower? It''s Lazare the cat! \r\n\r\nYour little one will love this interactive ebook which is the ideal way to develop imagination, early reading, and fine motor skills.', '', 'sophie_la_girafe_peekaboo_sophie_2.jpg', 0, 0, 1, 0, 0, 'sophie_la_girafe_peekaboo_sophie_2.epub', 'sophie_la_girafe_peekaboo_sophie_sample_2.epub', '2015-03-23', '9781465445322', '', '|Hide and Seek|,|Storytime|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-23 12:17:05', '2016-05-03 12:46:28'),
(218, 2, 'Sophie la girafeÂ®: Playtime with Sophie', 4, 'Come and play with Sophie and her friends! ', 'Babies will love Playtime with Sophie, an interactive story with sound and animation, which will have them giggling in delight. \r\n\r\nWith playful sounds and animation, let your little one bounce the ball, rev the train, and pop the bubbles in this exciting ebook.', '', 'sophie_la_girafe_playtime_with_sophie_2.jpg', 0, 0, 0, 0, 0, 'sophie_la_girafe_playtime_with_sophie_2.epub', 'sophie_la_girafe_playtime_with_sophie_sample_2.epub', '2015-03-23', '9781465445339', '', '|Storytime|,|Playtime|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-23 12:18:45', '2016-04-21 12:02:32'),
(219, 2, 'Sophie la girafeÂ®: Sophie and Friends', 4, 'Meet Sophie and her five special friends. ', 'This lovely story combines lively text, beautiful illustrations, sound, and animation to introduce your child to Sophie''s five little friends. Meet Lazare the cat, Kiwi the bird, Margot the turtle, Josephine the mouse, and Gabin the bear. \r\n\r\nExplore Sophie''s house and discover all the things Sophie and her friends love to do. Play games in the living room, cook in the kitchen, pick fruit in the garden, and pile on the bed for storytime!', '', 'sophie_la_girafe_sophie_and_friends_2.jpg', 0, 0, 0, 0, 0, 'sophie_la_girafe_sophie_and_friends_2.epub', 'sophie_la_girafe_sophie_and_friends_sample_2.epub', '2015-03-23', '9781465445346', '', '|Storytime|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-23 12:20:30', '2015-03-26 12:42:39'),
(220, 2, 'Sophie la girafeÂ®: Sophie Pop-Up Peekaboo!', 4, 'Play peekaboo with Sophie and her friends. Where is Sophie hiding?', 'Toddlers and babies will giggle in delight at the animated surprises in this adorable interactive ebook with rhyming text. \r\n\r\nSophie''s playing peekaboo with her little cat, Lazare. Is Sophie in the toy box? Come out Sophie, wherever you are! \r\n\r\nAvailable with text that lights up as you read along, and playful images and sounds.', '', 'sophie_la_girafe_sophie_popup_peekaboo_2.jpg', 0, 0, 0, 0, 0, 'sophie_la_girafe_sophie_popup_peekaboo_2.epub', 'sophie_la_girafe_sophie_popup_peekaboo_sample_2.epub', '2015-03-23', '9781465445353', '', '|Storytime|,|Hide and Seek|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-23 12:22:24', '2016-04-21 12:03:02'),
(221, 2, 'Sophie la girafeÂ®: Sophie''s Busy Day', 4, 'Join Sophie and her friends on their very busy day!', 'Sophie''s friends are being very helpful today! Join them as they go shopping and bake a cake! With sound and animation, this is an engaging title for you and your little one to enjoy together.', '', 'sophie_la_girafe_sophies_busy_day_1.jpg', 0, 0, 0, 0, 0, 'sophie_la_girafe_sophies_busy_day_1.epub', 'sophie_la_girafe_sophies_busy_day_sample_1.epub', '2015-03-23', '9781465445360', '', '|Storytime|,|Sophie la girafeÂ®|', 'PUBLISHED', '2015-03-23 12:24:25', '2015-03-26 12:43:02'),
(222, 1, 'Who am I? Baby Animals', 5, 'Can you guess which baby animals are hiding? ', 'Who Am I? Baby Animals is perfect for inquisitive toddlers. Who likes to eat lettuce and lives in a hutch? A bunny rabbit, of course! \r\n\r\nBright pages, great images, sounds and playful animations, will keep your toddler engaged over and over again. A perfect combination of learning and play.', '', 'who_am_i_baby_animals_3.jpg', 0, 0, 0, 0, 0, 'who_am_i_baby_animals_1.epub', 'who_am_i_baby_animals_sample_1.epub', '2015-03-23', '9780241239544', '', '|Animals|,|Who am I?|', 'PUBLISHED', '2015-03-23 12:28:22', '2016-04-21 12:03:12'),
(223, 2, 'Who am I? Baby Animals', 5, 'Can you guess which baby animals are hiding? ', 'Who Am I? Baby Animals is perfect for inquisitive toddlers. Who likes to eat lettuce and lives in a hutch? A bunny rabbit, of course! \r\n\r\nBright pages, great images, sounds, and playful animations will keep your toddler engaged over and over again. A perfect combination of learning and play.', '', 'who_am_i_baby_animals_4.jpg', 0, 0, 0, 0, 0, 'who_am_i_baby_animals_2.epub', 'who_am_i_baby_animals_sample_2.epub', '2015-03-23', '9781465445377', '', '|Who am I?|,|Animals|', 'PUBLISHED', '2015-03-23 12:29:55', '2016-04-21 12:03:27'),
(224, 1, 'Who am I? Farm Animals', 5, 'Can you guess which farm animals are hiding? ', 'Who Am I? Farm Animals is perfect for inquisitive toddlers. Which baby farm animal has a snout for a nose? A piglet, of course! \r\n\r\nBright pages, great images, sounds and playful animations, will keep your toddler engaged over and over again. A perfect combination of learning and play.', '', 'who_am_i_farm_animals_3.jpg', 0, 0, 0, 0, 0, 'who_am_i_farm_animals_1.epub', 'who_am_i_farm_animals_sample_1.epub', '2015-03-23', '9780241239551', '', '|Who am I?|,|Animals|,|Farm|', 'PUBLISHED', '2015-03-23 12:32:52', '2016-04-21 12:03:35'),
(225, 2, 'Who am I? Farm Animals', 5, 'Can you guess which farm animals are hiding? ', 'Who Am I? Farm Animals is perfect for inquisitive toddlers. Which baby farm animal has a snout for a nose? A piglet, of course! \r\n\r\nBright pages, great images, sounds, and playful animations will keep your toddler engaged over and over again. A perfect combination of learning and play. ', '', 'who_am_i_farm_animals_4.jpg', 0, 0, 0, 0, 0, 'who_am_i_farm_animals_2.epub', 'who_am_i_farm_animals_sample_2.epub', '2015-03-23', '9781465445384', '', '|Who am I?|,|Animals|,|Farm|', 'PUBLISHED', '2015-03-23 12:34:12', '2016-04-21 12:03:42'),
(226, 2, 'Who am I? Pets', 5, 'Can you guess which pets are hiding?', 'Who Am I? Pets is perfect for inquisitive toddlers. Who lives in water and has orange scales? A goldfish, of course! \r\n\r\nBright pages, great images, sounds, and playful animations will keep your toddler engaged over and over again. A perfect combination of learning and play.', '', 'who_am_i_pets_4.jpg', 0, 0, 0, 0, 0, 'who_am_i_pets_2.epub', 'who_am_i_pets_sample_2.epub', '2015-03-23', '9781465445391', '', '|Who am I?|,|Animals|', 'PUBLISHED', '2015-03-23 12:35:56', '2015-04-14 16:08:19'),
(227, 2, 'Who am I? Wild Animals', 5, 'Can you guess which wild animals are hiding?', 'Who Am I? Wild Animals is perfect for inquisitive toddlers. Who lives in the trees and has bright feathers? A parrot, of course! \r\n\r\nBright pages, great images, sounds, and playful animations will keep your toddler engaged over and over again. A perfect combination of learning and play.', '', 'who_am_i_wild_animals_4.jpg', 0, 0, 0, 0, 0, 'who_am_i_wild_animals_2.epub', 'who_am_i_wild_animals_sample_2.epub', '2015-03-23', '9781465445407', '', '|Who am I?|,|Animals|', 'PUBLISHED', '2015-03-23 12:37:27', '2015-04-14 16:08:32'),
(228, 1, 'My First Busy Home: Let''s Look and Learn!', 1, 'Let''s get busy and learn what''s in and around the home with this interactive ebook.', 'Packed with colourful pictures and activities, your toddler will love discovering familiar things from around the home with this ebook. \r\n\r\nBright, busy pages transport you to different rooms in the home: from a bedroom to a kitchen and even a shed! Fun-filled questions on every page will help develop early speaking and listening skills. \r\n\r\nThe playful images in this ebook are enhanced with animations and sounds and will be loved by all.', '', 'my_first_busy_home_lets_look_and_learn_8.jpg', 0, 0, 0, 0, 0, 'my_first_busy_home_lets_look_and_learn_8.epub', 'my_first_busy_home_lets_look_and_learn_sample_8.epub', '2015-04-15', '9780241239377', '', '|Let''s get busy|,|Home|', 'PUBLISHED', '2015-04-15 10:55:43', '2015-04-15 11:01:56'),
(229, 2, 'My First Busy Home: Let''s Look and Learn!', 1, 'Let''s get busy and learn what''s in and around the home with this interactive ebook.', 'Packed with colorful pictures and activities, your toddler will love discovering familiar things from around the home with this ebook. \r\n\r\nBright, busy pages transport you to different rooms in the home: from a bedroom to a kitchen and even a shed! Fun-filled questions on every page will help develop early speaking and listening skills. \r\n\r\nThe playful images in this ebook are enhanced with animations and sounds and will be loved by all.', '', 'my_first_busy_home_lets_look_and_learn_10.jpg', 0, 0, 0, 0, 0, 'my_first_busy_home_lets_look_and_learn_10.epub', 'my_first_busy_home_lets_look_and_learn_sample_10.epub', '2015-04-15', '9781465444493', '', '|Home|,|Let''s get busy|', 'PUBLISHED', '2015-04-15 11:29:09', '2015-04-15 14:21:56'),
(230, 1, 'Happy Birthday Sophie!', 4, 'Toddlers and babies will giggle in delight as Sophie la girafe finds birthday surprises and her playful friends hiding in this bright and fun ebook.', 'Join in the fun and celebrate Sophie''s birthday with this beautiful peekaboo ebook for babies and toddlers. Sophie la girafe Pop-up Peekaboo Happy Birthday is ideal for fans who use the Sophie toy when teething and makes a great early learning toddler gift, especially for birthdays!\r\n\r\nPerfect for reading aloud at bedtime this peekaboo ebook encourages first words and early learning. Surprises encourage memory skills and fine motor skills, while the fun rhymes foster language and early reading skills. Your little one will love the bright images, interactive elements and playful characters - perfect for toddlers'' early learning and development.\r\n\r\nNow available with text that lights up as you read-along and playful images and sounds.', 'DK', 'happy_birthday_sophie_1.jpg', 0, 0, 0, 0, 0, 'happy_birthday_sophie_1.epub', 'happy_birthday_sophie_sample_1.epub', '2016-02-29', '', '', '', 'DRAFT', '2016-03-01 11:19:07', '2016-04-22 12:08:03'),
(231, 1, 'My First 123', 3, 'Help your toddler learn all about numbers and counting in My First 123.', 'Count from 1 to 10 with your toddler, and help them learn to add and take away with this engaging ebook which keeps early learning simple. With 16-pages of colourful, bright photographs alongside clear word-labels your little one will master numbers in no time.\r\n\r\nPerfect for encouraging children to build numeracy skills My First 123 helps toddlers grasp early concepts. Your little one will love discovering numbers. Read it together and help them learn all about adding up and taking away.\r\n\r\nNow available with text that lights up as you read-along and playful images and sounds.', '', 'my_first_123_1.jpg', 1, 1, 0, 0, 0, 'my_first_123_1.epub', 'my_first_123_sample_1.epub', '2016-03-31', '9780241239155', '', '|Numbers|', 'PUBLISHED', '2016-04-21 14:51:55', '2016-04-21 14:51:55'),
(232, 1, 'My First ABC', 3, 'Help your toddler learn their ABC in My First ABC.', 'With 16-pages of colourful, bright photographs alongside clear word-labels your little one will master their ABC in no time. From A to Z each page introduces the next letter of the alphabet with one clear object to engage your toddler and make early learning simple and fun!\r\n\r\nPerfect for encouraging children to build vocabulary and language skills My First ABC helps toddlers grasp early concepts. Your little one will love discovering their letters. Read it together and help them learn.', '', 'my_first_abc_1.jpg', 1, 0, 0, 0, 0, 'my_first_abc_1.epub', 'my_first_abc_sample_1.epub', '2016-03-31', '9780241239131', '', '|Words|', 'PUBLISHED', '2016-04-21 14:56:33', '2016-05-03 12:42:03'),
(233, 1, 'My First Animals', 3, 'Help your toddler learn all about animals in My First Animals.', 'From tiny minibeasts and huge bears to stripy animals and sea creatures My First Animals helps your toddler explore the wild world of creatures big and small. Each page introduces a new animal group such as farm animals or baby animals to keep early learning simple and fun. With 16-pages of colourful, bright photographs alongside clear word-labels your little one will know their beasties from their butterflies in no time.\r\n\r\nPerfect for encouraging children to build vocabulary and language skills My First Animals helps toddlers grasp early concepts. Your little one will love discovering the animal kingdom. Read it together and help them learn about the animal world.\r\n\r\nNow available with text that lights up as you read-along and playful images and sounds.', '', 'my_first_animals_1.jpg', 1, 0, 0, 0, 0, 'my_first_animals_1.epub', 'my_first_animals_sample_1.epub', '2016-03-31', '9780241239148', '', '|Animals|', 'PUBLISHED', '2016-04-21 14:59:14', '2016-05-03 12:43:20'),
(234, 1, 'My First Colours', 3, 'Help your toddler learn all about colours in My First Colours.', 'With 16-pages of colourful, bright photographs alongside clear word-labels your little one will begin to recognise red from yellow and even multi-coloured objects too. Each page introduces one colour using an object or animal to fully engage your toddler and keep early learning simple. \r\n\r\nPerfect for encouraging children to build vocabulary and language skills My First Colours helps toddlers grasp early concepts. Your little one will love discovering colours. Read it together and help them learn all about colour.\r\n\r\nNow available with text that lights up as you read-along and playful images and sounds.', '', 'my_first_colours_1.jpg', 1, 0, 0, 0, 0, 'my_first_colours_1.epub', 'my_first_colours_sample_1.epub', '2016-03-31', '9780241239216', '', '|Colours|', 'PUBLISHED', '2016-04-21 15:01:55', '2016-05-03 12:43:40'),
(235, 1, 'My First Trucks', 3, 'Help your toddler learn all about trucks in My First Trucks.', 'With 16-pages of colourful, bright photographs alongside clear word-labels your little one will be delighted with all the different types of trucks inside. From counting trucks to different truck colours and even matching trucks to their driver My First Truck keeps early learning simple with a different truck or activity on each page.\r\n\r\nPerfect for encouraging children to build vocabulary and language skills My First Trucks helps toddlers grasp early concepts including counting and colours. Read it together and help them learn all about trucks.\r\n\r\nNow available with text that lights up as you read-along and playful images and sounds.', '', 'my_first_trucks_1.jpg', 1, 0, 0, 0, 0, 'my_first_trucks_1.epub', 'my_first_trucks_sample_1.epub', '2016-03-31', '9780241239209', '', '|Trucks|', 'PUBLISHED', '2016-04-21 15:04:32', '2016-05-03 12:43:47');
INSERT INTO `books` (`book_auto_id`, `book_region_id`, `book_title`, `book_reader_level`, `book_short_desc`, `book_long_desc`, `book_author_name`, `book_image`, `book_new`, `book_free`, `book_feature`, `book_onoffer`, `book_readaloud`, `book_epub`, `book_sample_epub`, `book_publication_date`, `book_apple_purchase_id`, `book_android_purchase_id`, `book_topics`, `book_status`, `book_dateadded`, `book_datemodified`) VALUES
(236, 1, 'My First Words', 3, 'Help your toddler learn their all important first words with My First Words.', 'With 16-pages of colourful, bright photographs alongside clear word-labels your little one will begin to recognise common everyday words. Each page introduces a new area including the kitchen, bedroom, the park and more, highlighting the key words with a bright image. Straightforward and clear My First Words fully engages your toddler to keep early learning simple. \r\n\r\nPerfect for encouraging children to build vocabulary and language skills My First Words helps toddlers grasp early concepts. Your little one will love discovering words and language. Read it together and help them learn their first words.\r\n\r\nNow available with text that lights up as you read-along and playful images and sounds.', '', 'my_first_words_1.jpg', 1, 0, 0, 0, 0, 'my_first_words_1.epub', 'my_first_words_sample_1.epub', '2016-03-31', '9780241239193', '', '|Words|', 'PUBLISHED', '2016-04-21 15:07:02', '2016-05-03 12:44:01'),
(237, 1, 'Happy Birthday Sophie!', 4, 'Toddlers and babies will giggle in delight as Sophie la girafe finds pop-up birthday surprises in this bright and fun peekaboo ebook.', 'Join in the fun and celebrate Sophie''s birthday with this beautiful peekaboo ebook for babies and toddlers. Sophie la girafe Pop-up Peekaboo Happy Birthday is ideal for fans who use the Sophie toy when teething and makes a great early learning toddler gift, especially for birthdays!\r\n\r\nPerfect for reading aloud at bedtime this peekaboo ebook is just the right size for your toddler''s little hands to hold and encourages first words and early learning too. Pop-ups and lift-the-flap surprises encourage memory skills and fine motor skills, while the fun rhymes foster language and early reading skills. Your little one will love the bright images and playful characters - perfect for toddlers'' early learning and development.', '', 'sophie_la_girafe_popup_peekaboo_happy_birthday_sophie_1.jpg', 1, 1, 0, 0, 0, 'sophie_la_girafe_popup_peekaboo_happy_birthday_sophie_1.epub', 'sophie_la_girafe_popup_peekaboo_happy_birthday_sophie_sample_1.epub', '2016-03-31', '9780241239230', '', '|Playtime|,|Sophie la girafe Â®|,|Sophie la girafeÂ®|', 'PUBLISHED', '2016-04-21 15:12:18', '2016-04-22 12:08:19'),
(238, 2, 'Happy Birthday Sophie!', 4, 'You''re invited to Sophie''s birthday party!', 'Join Sophie and her friends Josephine, Gabin, Lazare, Margot, and Kiwi as they celebrate with balloons, cake, party hats, presents, and more! There are also peekaboo surprises to keep your little one''s attention!', '', 'sophie_la_girafe_popup_peekaboo_happy_birthday_sophie_2.jpg', 1, 1, 0, 0, 0, 'sophie_la_girafe_popup_peekaboo_happy_birthday_sophie_2.epub', 'sophie_la_girafe_popup_peekaboo_happy_birthday_sophie_sample_2.epub', '2016-03-31', '9781465445421', '', '|Sophie la girafe Â®|,|Sophie la girafeÂ®|,|Playtime|', 'PUBLISHED', '2016-04-21 15:15:12', '2016-04-22 12:08:34'),
(239, 2, 'My First Words', 3, 'Encourage talking and build vocabulary with this fun first word-and-picture book!', 'My First Words features 17 spreads of objects illustrating first familiar words. Clear word labels accompany each image. Spreads include: All about me/My  Body, Around the house, Food, In the bathroom, In the kitchen, In the garden, In the garage, Animals, Shopping, Things that go, On the farm, Seashore, Toys, Shapes, Feelings.', '', 'my_first_words_2.jpg', 1, 0, 0, 0, 0, 'my_first_words_2.epub', 'my_first_words_sample_2.epub', '2016-03-31', '9781465445452', '', '|Words|', 'PUBLISHED', '2016-04-21 15:18:35', '2016-05-03 12:44:07'),
(240, 2, 'My First Trucks', 3, 'Encourage talking and build vocabulary with this fun first picture book.', 'My First Trucks features 17 spreads of trucks and vehicles. Clear word labels accompany each image. Spreads include: Trucks, Diggers, Gas tanker, Car  transporter, Emergency, Road trains, Snow plow, Logging truck, Find  the load, Monster truck, Excavator, Bulldozer, Tractor, Road roller,  Colorful trucks, and Truck shapes.', '', 'my_first_trucks_2.jpg', 1, 0, 0, 0, 0, 'my_first_trucks_2.epub', 'my_first_trucks_sample_2.epub', '2016-03-31', '9781465445445', '', '|Trucks|', 'PUBLISHED', '2016-04-21 15:20:54', '2016-05-03 12:43:53'),
(241, 2, 'My First Colors', 3, 'Learn colors and build vocabulary with this fun first word-and-picture book.', 'My First Colors features 17 spreads of objects that illustrate a comprehensive selection of colors, including red, green, blue, orange, yellow, brown, purple, pink, white, gold, silver, and rainbow! Clear word labels accompany each image.', '', 'my_first_colors_1.jpg', 1, 0, 0, 0, 0, 'my_first_colors_1.epub', 'my_first_colors_sample_1.epub', '2016-03-31', '9781465445438', '', '|Colors|', 'PUBLISHED', '2016-04-21 15:22:47', '2016-05-03 12:43:34'),
(242, 2, 'My First Animals', 3, 'Encourage talking and build vocabulary with this fun animal picture book!', 'My First Animals features 17 spreads of animal images with clear word labels. Spreads include: Desert, Garden, Rainforest, Grassland, Underground, Jungle, Sea, Air, Mountain, Forest, River, Farm, Snow, Home (pets), Prehistoric, Baby Animals.', '', 'my_first_animals_3.jpg', 1, 0, 0, 0, 0, 'my_first_animals_2.epub', 'my_first_animals_sample_2.epub', '2016-03-31', '9781465444479', '', '|Animals|', 'PUBLISHED', '2016-04-21 15:24:06', '2016-05-03 12:43:27'),
(243, 2, 'My First ABC', 3, 'Learn the alphabet and letter sounds with this fun first ABC book!', 'My First ABC features 17 spreads of objects illustrating each letter of the alphabet. Clear word labels accompany each image to promote reading readiness and key observational skills.', '', 'my_first_abc_2.jpg', 1, 0, 0, 0, 0, 'my_first_abc_2.epub', 'my_first_abc_sample_2.epub', '2016-03-31', '9781465444462', '', '|Words|', 'PUBLISHED', '2016-04-21 15:26:25', '2016-05-03 12:43:11'),
(244, 2, 'My First 123', 3, 'Encourage counting and number skills with this fun first picture book!', 'My First 123 features 17 spreads of objects illustrating numbers 1-10, 20, 50, and 100. Clear word labels accompany each image. My First 123 also contains spreads about subtraction, addition, and counting.', '', 'my_first_123_2.jpg', 1, 1, 0, 0, 0, 'my_first_123_2.epub', 'my_first_123_sample_2.epub', '2016-03-31', '9781465444455', '', '|Numbers|', 'PUBLISHED', '2016-04-21 15:28:00', '2016-04-21 15:28:00');

-- --------------------------------------------------------

--
-- Table structure for table `emails`
--

DROP TABLE IF EXISTS `emails`;
CREATE TABLE IF NOT EXISTS `emails` (
  `email_auto_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email_subject` varchar(255) DEFAULT NULL,
  `email_body` varchar(15000) DEFAULT NULL,
  `email_type` tinyint(2) DEFAULT '0' COMMENT '1 = forgotten pin',
  `email_region_id` tinyint(5) DEFAULT NULL,
  PRIMARY KEY (`email_auto_id`),
  UNIQUE KEY `auto_id` (`email_auto_id`),
  KEY `region` (`email_region_id`),
  KEY `type` (`email_type`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `emails`
--

INSERT INTO `emails` (`email_auto_id`, `email_subject`, `email_body`, `email_type`, `email_region_id`) VALUES
(1, 'DK Preschool - PIN Retrieval', 'You have chosen to retrieve your PIN for the DK Preschool app. \r\n \r\nPlease keep this email safe, it contains important info you''ll need to sign into your account.\r\n\r\nYour Pin Number: [#PIN#]\r\n\r\n', 1, 2),
(2, 'DK Preschool - PIN Retrieval', 'You have chosen to retrieve your PIN for the DK Preschool app. \r\n \r\nPlease keep this email safe, it contains important info you''ll need to sign into your account.\r\n\r\nYour Pin Number: [#PIN#]\r\n\r\n', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `funfacts`
--

DROP TABLE IF EXISTS `funfacts`;
CREATE TABLE IF NOT EXISTS `funfacts` (
  `funfact_auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `funfact_region_id` int(11) DEFAULT '0',
  `funfact_title` varchar(255) DEFAULT NULL,
  `funfact_image` varchar(255) DEFAULT NULL,
  `funfact_startdate` date DEFAULT NULL,
  `funfact_enddate` date DEFAULT NULL,
  `funfact_status` varchar(20) DEFAULT 'DRAFT' COMMENT 'DRAFT,PUBLISHED',
  `funfact_order` int(11) DEFAULT '1',
  `funfact_dateadded` datetime DEFAULT NULL,
  `funfact_datemodified` datetime DEFAULT NULL,
  PRIMARY KEY (`funfact_auto_id`),
  UNIQUE KEY `auto_id` (`funfact_auto_id`),
  KEY `region` (`funfact_region_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=90 ;

--
-- Dumping data for table `funfacts`
--

INSERT INTO `funfacts` (`funfact_auto_id`, `funfact_region_id`, `funfact_title`, `funfact_image`, `funfact_startdate`, `funfact_enddate`, `funfact_status`, `funfact_order`, `funfact_dateadded`, `funfact_datemodified`) VALUES
(89, 2, 'Sweet', 'sweet_2.png', '2015-03-10', '2018-12-31', 'LIVE', 12, '2015-03-24 11:24:19', '2017-01-10 11:04:50'),
(88, 2, 'Rainbow', 'rainbow_2.png', '2015-03-10', '2018-12-31', 'LIVE', 2, '2015-03-24 11:24:08', '2017-01-10 11:02:25'),
(87, 2, 'Rabbit', 'rabbit_2.png', '2015-03-10', '2018-12-31', 'LIVE', 5, '2015-03-24 11:23:57', '2017-01-10 11:03:26'),
(86, 2, 'Pink car', 'pink_car_2.png', '2015-03-24', '2016-12-31', 'LIVE', 6, '2015-03-24 11:23:47', '2016-04-21 12:37:52'),
(85, 2, 'Penguin', 'penguin_2.png', '2015-03-10', '2018-12-31', 'LIVE', 8, '2015-03-24 11:23:34', '2017-01-10 11:03:51'),
(84, 2, 'Lemon', 'lemon_2.png', '2015-03-10', '2018-12-31', 'LIVE', 7, '2015-03-24 11:23:23', '2017-01-10 11:03:40'),
(82, 2, 'Kitten', 'kitten_3.png', '2015-03-10', '2018-12-31', 'LIVE', 10, '2015-03-24 11:22:33', '2017-01-10 11:04:30'),
(81, 2, 'Green bag', 'green_bag_2.png', '2015-03-10', '2018-12-31', 'LIVE', 3, '2015-03-24 11:22:19', '2017-01-10 11:02:52'),
(80, 2, 'Boat', 'boat_2.png', '2015-03-10', '2018-12-31', 'LIVE', 9, '2015-03-24 11:22:04', '2017-01-10 11:04:07'),
(79, 2, 'Blue bike', 'blue_bike_2.png', '2015-03-10', '2018-12-31', 'LIVE', 4, '2015-03-24 11:20:49', '2017-01-10 11:03:12'),
(78, 2, 'Balloon', 'balloon_2.png', '2015-03-10', '2018-12-31', 'LIVE', 1, '2015-03-24 11:20:23', '2017-01-10 11:02:11'),
(77, 2, 'Ball', 'ball_3.png', '2015-03-10', '2018-12-31', 'LIVE', 11, '2015-03-24 11:20:10', '2017-01-10 11:04:20'),
(76, 1, 'Sweet', 'sweet_1.png', '2015-03-10', '2018-12-31', 'LIVE', 12, '2015-03-10 13:34:08', '2017-01-10 11:02:03'),
(75, 1, 'Rainbow', 'rainbow_1.png', '2015-03-10', '2018-12-31', 'LIVE', 2, '2015-03-10 13:33:58', '2017-01-10 11:00:36'),
(74, 1, 'Rabbit', 'rabbit_1.png', '2015-03-10', '2018-12-31', 'LIVE', 5, '2015-03-10 13:33:46', '2017-01-10 11:01:08'),
(73, 1, 'Pink car', 'pink_car_1.png', '2015-03-10', '2018-12-31', 'LIVE', 6, '2015-03-10 13:33:34', '2017-01-10 11:01:17'),
(72, 1, 'Penguin', 'penguin_1.png', '2015-03-10', '2018-12-31', 'LIVE', 8, '2015-03-10 13:33:22', '2017-01-10 11:01:33'),
(71, 1, 'Lemon', 'lemon_1.png', '2015-03-10', '2018-12-31', 'LIVE', 7, '2015-03-10 13:33:09', '2017-01-10 11:01:25'),
(70, 1, 'Kitten', 'kitten_2.png', '2015-03-10', '2018-12-31', 'LIVE', 10, '2015-03-10 13:32:59', '2017-01-10 11:01:47'),
(69, 1, 'Green bag', 'green_bag_1.png', '2015-03-10', '2018-12-31', 'LIVE', 3, '2015-03-10 13:32:44', '2017-01-10 11:00:44'),
(68, 1, 'Boat', 'boat_1.png', '2015-03-10', '2018-12-31', 'LIVE', 9, '2015-03-10 13:32:26', '2017-01-10 11:01:39'),
(67, 1, 'Ball', 'ball_2.png', '2015-03-10', '2018-12-31', 'LIVE', 11, '2015-03-03 11:23:41', '2017-01-10 11:01:55'),
(66, 1, 'Balloon', 'balloon_1.png', '2015-03-10', '2018-12-31', 'LIVE', 1, '2015-03-03 11:23:20', '2017-01-10 11:00:24'),
(65, 1, 'Blue bike', 'blue_bike_1.png', '2015-03-10', '2018-12-31', 'LIVE', 4, '2015-02-27 17:00:35', '2017-01-10 11:00:55');

-- --------------------------------------------------------

--
-- Table structure for table `helppages`
--

DROP TABLE IF EXISTS `helppages`;
CREATE TABLE IF NOT EXISTS `helppages` (
  `helppage_auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `helppage_section_guid` varchar(50) DEFAULT '0',
  `helppage_section` varchar(255) DEFAULT NULL,
  `helppage_section_status` varchar(50) DEFAULT NULL,
  `helppage_section_order` int(11) DEFAULT '1',
  `helppage_template_id` tinyint(1) DEFAULT '1' COMMENT '1=??? 2=??? 3=???',
  `helppage_title` varchar(255) DEFAULT NULL,
  `helppage_image` varchar(255) DEFAULT NULL,
  `helppage_region_id` tinyint(5) DEFAULT NULL,
  `helppage_content` varchar(15000) DEFAULT NULL,
  `helppage_order` int(11) DEFAULT '1',
  `helppage_status` varchar(50) DEFAULT 'DRAFT' COMMENT 'DRAFT, PUBLISHED',
  `helppage_dateadded` datetime DEFAULT NULL,
  `helppage_datemodified` datetime DEFAULT NULL,
  PRIMARY KEY (`helppage_auto_id`),
  UNIQUE KEY `auto_id` (`helppage_auto_id`),
  KEY `region` (`helppage_region_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=33 ;

--
-- Dumping data for table `helppages`
--

INSERT INTO `helppages` (`helppage_auto_id`, `helppage_section_guid`, `helppage_section`, `helppage_section_status`, `helppage_section_order`, `helppage_template_id`, `helppage_title`, `helppage_image`, `helppage_region_id`, `helppage_content`, `helppage_order`, `helppage_status`, `helppage_dateadded`, `helppage_datemodified`) VALUES
(22, 'B193431A707E5614DB796ACF03AD38E0', 'How this app works', 'LIVE', 1, 1, 'How this app works', 'how_this_app_works_7.jpg', 1, 'Welcome to the DK Preschool app! \r\n\r\nOur app contains a safe and self-contained bookstore packed with preschool books to browse, sample and buy. You can set up a bookshelf for each young reader in your home and fill it with the right DK Preschool books for your child. They can enjoy these ebooks over and over again! And, when they outgrow this app, you can download the DK Readers app. The DK Readers app has reading levels to guide your child through the earliest stages of reading.\r\n\r\nGetting startedâ€¦\r\n\r\nWhen setting up the app, you will be asked to create a parentâ€™s PIN number. This ensures your child cannot make purchases without your permission.\r\n\r\nThe next step is creating a bookshelf for your child. Weâ€™ll ask for your childâ€™s name and you can then add books to their bookshelf from the bookstore, or from titles you have already purchased. If you have more than one preschooler, you can create and personalize a bookshelf for each. Your child will love to personalize their bookshelf by choosing from a range of fun pictures!\r\n\r\nThe bookstoreâ€¦\r\n\r\nThe DK Preschool bookstore contains a library of ebooks for you to browse, sample and buy. You can find out more about each title before you purchase, by tapping on the title to bring up a short summary and downloading a free sample. If you decide to purchase an ebook, you will be asked for your PIN before you can proceed. If you would like to purchase an ebook at a later date, add the book to your childâ€™s wish list. Itâ€™s that simple!\r\n\r\nGet readingâ€¦\r\n\r\nTap to open your ebook. Mini-pages at the bottom of the screen show where you and your child are in the ebook. Just double-tap the centre of the page if youâ€™d like to change any settings, navigate, or exit the ebook at any time. \r\n\r\nFinished? Your child just needs to press a button to let you know. Parents can access a page to see what their child is reading, review purchases, reset their PIN, and restore any purchases that may no longer be viewed. \r\n\r\nThis app is easy to use, and an easy way to get your child reading and interacting with what they read.\r\n\r\nFor questions or queries, please contact customerservices@dk.com', 1, 'LIVE', '2015-03-03 18:12:59', '2015-04-24 11:14:23'),
(23, '28B1C927F74623B7FF0D042862155472', 'About DK Preschool', 'LIVE', 2, 3, 'About DK Preschool', 'about_dk_preschool_1.jpg', 1, 'DK Preschool books are a fun and educational introduction to the world of reading. The beautiful photography and illustrations, combined with simple text labels, encourage word-and-picture association and help children engage with each page.\r\n\r\nDK Preschool ebooks include sound and animation, encouraging little ones to interact with the pages and watch them come to life. The simple text can either be read by or read to a child, either by a parent or through the ebook narration function. Children will love swiping the screen to help turn the pages, tapping on words to hear narration, or pressing images to see if they make noises or even move!\r\n\r\nEach book is designed to capture a childâ€™s interest while developing his or her manual dexterity and first reading skills. DK Preschool ebooks are educational and fun, encouraging play and sparking imagination, which will ultimately lead to a love of reading!', 1, 'LIVE', '2015-03-03 18:15:20', '2015-04-14 15:02:52'),
(24, '5E6219DC9FCA726D0D34DD172922F22E', 'Why reading with your child matters', 'LIVE', 3, 1, 'Why reading with your child matters', 'why_reading_with_your_child_matters_1.jpg', 1, 'Learning how to read is an educational must. Helping children to become confident readers will help them succeed not just in all areas at school, but in life. As well as giving your child access to a whole world of information, reading for pleasure builds creative imagination, a sense of adventure, and enjoyment. \r\n\r\nEbooks are convenient â€“ you can access a whole library while you are out and about. Animated ebooks have an element of play that is perfect to help little ones engage with books and reading. Share this app with your child and give your little one the gift of a lifetime love of reading.', 1, 'LIVE', '2015-03-03 18:15:52', '2015-04-14 15:03:18'),
(25, '4CC05C5C0520CE97E21CC6456B46B72A', 'Tips to support young readers', 'LIVE', 4, 1, 'Tips to support young readers', 'tips_to_support_young_readers_1.jpg', 1, 'Adult participation is essential when learning to read and can make learning easier and more fun for your child. So here are a few tips on how to use your DK Preschool books and ebooks with your child.\r\n\r\nPlay. Reading should be fun so encourage your child to explore their books for example by lifting the flaps on their book or by swiping to turn the pages on their ebooks.\r\n\r\nKeep talking! Talking about what you have read is a great way to reinforce learning. When you prepare a meal, describe the objects and how many there are: four plates, is that enough? We need two more forksâ€¦\r\n\r\nExplore and play! Encourage your child to explore what they read, whether it be a physical book or ebook. They can get involved by lifting the flaps or swiping the pages of their ebooks!\r\n\r\nCollect it! Buttons, shells, mini figures â€“ excellent for counting, comparing size, shapes and colour.\r\n\r\nGo on a hunt and further your childâ€™s understanding of what youâ€™ve read. If youâ€™ve been reading about colours or shapes, go for a walk and see how many green or square things you can find.\r\n\r\nRepeat after me! Repetition will help your child to learn. Donâ€™t be afraid to read and re-read your ebooks as this will enable your child to develop a thorough understanding of concepts and to learn anything they might have found too challenging on the first reading.\r\n\r\nPut learning into practice. Talk about what you see and what familiar animals and objects are similar to what they have seen. Eg, the ladybird in your book is spotty like your jumper. \r\n\r\nJoin in with any rhymes, words, sounds or noises in your chosen ebooks! After you have read the ebook, discuss what youâ€™ve learnt and go back if you need to. What was your favourite animal? Can you remember what noise a duck makes?\r\n\r\nEmphasise letters and sounds while you read. Point while you read to reinforce the connection between the letter and the sound.\r\n\r\nPraise your child if they identify animals, colours or sounds correctly. If your child gets things wrong, give some praise for trying!\r\n\r\nRead regularly or as often as you can. A reading routine is helpful and if itâ€™s before bedtime, it can be relaxing, too!\r\n\r\nAbove all, relax, enjoy, and have fun with what youâ€™re reading!', 1, 'LIVE', '2015-03-03 18:16:46', '2015-04-14 15:04:19'),
(27, 'AF753775F4C9399C4E0701B435920BBE', 'About DK', 'LIVE', 6, 2, 'About DK ', 'about_dk__1.jpg', 1, 'Established in 1974, DK creates best-selling, award-winning, and visually stunning information for adults and children, visit www.dk.com to find out more. From travel guides and activity books, through to food, history, gardening, and much more, DK makes ideas come to life.\r\n\r\nDK has established a worldwide reputation for its innovative nonfiction books in which the unrivaled clarity of the words and pictures come together to spectacular effect. DK content in all its forms is characterised by quality, expertise, and accessibility. DK is a brand that inspires trust and we pride ourselves in creating visual information with international appeal, working with companies worldwide who share our values and ethos.\r\n\r\nOur adult range spans from travel, including the award-winning Eyewitness Travel Guides to history, science, nature, sports, gardening, cookery, and parenting. We also publish an extensive children''s catalogue that showcases a fantastic store of knowledge for children, toddlers, and babies. Covering topics from history and the human body to animals and activities, DK children''s books combine outstanding information with magical illustration and design.\r\n\r\nWe work closely with authors who are experts in their field, with authoritative institutions like the Royal Horticultural Society and the Smithsonian, as well as with well-known brands such as Star Wars and the LEGO Group, to produce world-class books and products. \r\n\r\nDK has offices in Delhi, London, Melbourne, Munich, New York, and Toronto.', 1, 'LIVE', '2015-03-03 18:18:29', '2015-04-14 15:05:06'),
(28, '15C65AE63F409ADF1C88C7ED366D0C31', 'How this app works', 'LIVE', 1, 1, 'How this app works', 'how_this_app_works_8.jpg', 2, 'Welcome to the DK Preschool app! \r\n\r\nOur app contains a safe and self-contained bookstore packed with preschool books to browse, sample, and buy. You can set up a bookshelf for each young reader in your home and fill it with the right DK Preschool books for your child. They can enjoy these ebooks over and over again! And, when they outgrow this app, you can download the DK Readers app. The DK Readers app has reading levels to guide your child through the earliest stages of reading.\r\n\r\nGetting startedâ€¦\r\n\r\nWhen setting up the app, you will be asked to create a parentâ€™s PIN number. This ensures your child cannot make purchases without your permission.\r\n\r\nThe next step is creating a bookshelf for your child. Weâ€™ll ask for your childâ€™s name and you can then add books to their bookshelf from the bookstore, or from titles you have already purchased. If you have more than one preschooler, you can create and personalize a bookshelf for each. Your child will love to personalize their bookshelf by choosing from a range of fun pictures!\r\n\r\nThe bookstoreâ€¦\r\n\r\nThe DK Preschool bookstore contains a library of ebooks for you to browse, sample, and buy. You can find out more about each title before you purchase by tapping on the title to bring up a short summary and downloading a free sample. If you decide to purchase an ebook, you will be asked for your PIN before you can proceed. If you would like to purchase an ebook at a later date, add the book to your childâ€™s wish list. Itâ€™s that simple!\r\n\r\nGet readingâ€¦\r\n\r\nTap to open your ebook. Mini-pages at the bottom of the screen show where you and your child are in the ebook. Just double-tap the center of the page if youâ€™d like to change any settings, navigate, or exit the ebook at any time. \r\n\r\nFinished? Your child just needs to press a button to let you know. Parents can access a page to see what their child is reading, review purchases, reset their PIN, and restore any purchases that may no longer be viewed. \r\n\r\nThis app is easy to use, and an easy way to get your child reading and interacting with what they read.\r\n\r\nFor questions or queries, please contact customerservices@dk.com', 1, 'LIVE', '2015-04-14 15:10:11', '2015-04-24 11:14:12'),
(29, 'A05C44D724C4D3883177282777F15672', 'About DK Preschool', 'LIVE', 2, 3, 'About DK Preschool', 'about_dk_preschool_2.jpg', 2, 'DK Preschool books are a fun and educational introduction to the world of reading. The beautiful photography and illustrations, combined with simple text labels, encourage word-and-picture association and help children engage with each page.\r\n\r\nDK Preschool ebooks include sound and animation, encouraging little ones to interact with the pages and watch them come to life. The simple text can either be read by or read to a child, either by a parent or through the ebook narration function. Children will love swiping the screen to help turn the pages, tapping on words to hear narration, or pressing images to see if they make noises or even move!\r\n\r\nEach book is designed to capture a childâ€™s interest while developing his or her manual dexterity and first reading skills. DK Preschool ebooks are educational and fun, encouraging play and sparking imagination, which will ultimately lead to a love of reading!', 1, 'LIVE', '2015-04-14 15:10:55', '2015-04-24 11:14:44'),
(30, '0BD6CEE5E410CD1A193B0F259CEFF900', 'Why reading with your child matters', 'LIVE', 3, 1, 'Why reading with your child matters', 'why_reading_with_your_child_matters_2.jpg', 2, 'Learning how to read is an educational must. Helping children to become confident readers will help them succeed not just in all areas at school, but also in life. As well as giving your child access to a whole world of information, reading for pleasure builds creative imagination, a sense of adventure, and enjoyment. \r\n\r\nEbooks are convenientâ€”you can access a whole library while you are out and about. Animated ebooks have an element of play that is perfect to help little ones engage with books and reading. Share this app with your child and give your little one the gift of a lifetime love of reading.', 1, 'LIVE', '2015-04-14 15:11:35', '2015-04-24 11:15:14'),
(31, 'DBD5A1C3A3E9FE5963E0E1666CF540A9', 'Tips to support young readers', 'LIVE', 4, 2, 'Tips to support young readers', 'tips_to_support_young_readers_2.jpg', 2, 'Adult participation is essential when a child is learning to read, and can make learning easier and more fun. So here are a few tips on how to use your DK Preschool books and ebooks with your child.\r\n\r\nPlay. Reading should be fun, so encourage your child to explore their books by lifting the flaps on their book, for example, or by swiping to turn the pages on their ebooks.\r\n\r\nKeep talking! Talking about what you have read is a great way to reinforce learning. When you prepare a meal, describe the objects and count how many there are: four plates, is that enough? We need two more forksâ€¦\r\n\r\nExplore and play! Encourage your child to explore what they read, whether it is  a physical book or an ebook. They can get involved by lifting the flaps or swiping the pages of their ebooks!\r\n\r\nCollect it! Buttons, shells, coinsâ€”excellent for counting, comparing size, shapes, and color.\r\n\r\nGo on a hunt and further your childâ€™s understanding of what youâ€™ve read. If youâ€™ve been reading about colors or shapes, go for a walk and see how many green or square things you can find.\r\n\r\nRepeat after me! Repetition will help your child to learn. Donâ€™t be afraid to read and re-read your ebooks. This will enable your child to develop a thorough understanding of concepts, and help your little one to learn anything they might have found too challenging on the first reading.\r\n\r\nPut learning into practice. Talk about what you see and what familiar animals and objects are similar to what they have seen. Eg, the ladybug in your book has spots like your sweater. \r\n\r\nJoin in with any rhymes, words, sounds, or noises in your chosen ebooks!\r\nAfter you have read the ebook, discuss what youâ€™ve learned and go back if you need to. What was your favorite animal? Can you remember what noise a duck makes?\r\n\r\nEmphasize letters and sounds while you read. Point while you read to reinforce the connection between the letter and the sound.\r\n\r\nPraise your child if they identify animals, colors, or sounds correctly. If your child gets things wrong, praise them for trying!\r\n\r\nRead regularly or as often as you can. A reading routine is helpful and if itâ€™s before bedtime, it can be relaxing, too!\r\n\r\nAbove all, relax, enjoy, and have fun with what youâ€™re reading!', 1, 'LIVE', '2015-04-14 15:12:48', '2015-04-24 11:16:23'),
(32, '99DDE361E2C7CC4087B4CC36B955D039', 'About DK', 'LIVE', 5, 2, 'About DK ', 'about_dk__2.jpg', 2, 'Established in 1974, DK creates bestselling, award-winning, and visually stunning information for adults and children, visit www.dk.com to find out more. From travel guides and activity books, through to food, history, gardening, and much more, DK makes ideas come to life.\r\n\r\nDK has established a worldwide reputation for its innovative nonfiction books in which the unrivaled clarity of the words and pictures come together to spectacular effect. DK content in all its forms is characterized by quality, expertise, and accessibility. DK is a brand that inspires trust and we pride ourselves in creating visual information with international appeal, working with companies worldwide who share our values and ethos.\r\n\r\nOur adult range spans from travel, including the award-winning Eyewitness Travel Guides to history, science, nature, sports, gardening, cookery, and parenting. We also publish an extensive children''s catalog that showcases a fantastic store of knowledge for children, toddlers, and babies. Covering topics from history and the human body to animals and activities, DK children''s books combine outstanding information with magical illustration and design.\r\n\r\nWe work closely with authors who are experts in their field, with authoritative institutions like the Royal Horticultural Society and the Smithsonian, as well as with well-known brands such as Star Wars and the LEGO Group, to produce world-class books and products. \r\n\r\nDK has offices in Delhi, London, Melbourne, Munich, New York, and Toronto.', 1, 'LIVE', '2015-04-14 15:13:54', '2015-04-14 15:13:54');

-- --------------------------------------------------------

--
-- Table structure for table `promotions`
--

DROP TABLE IF EXISTS `promotions`;
CREATE TABLE IF NOT EXISTS `promotions` (
  `promo_auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `promo_region_id` tinyint(5) DEFAULT NULL,
  `promo_title` varchar(255) DEFAULT NULL,
  `promo_image` varchar(255) DEFAULT NULL,
  `promo_image_lrg` varchar(255) DEFAULT NULL,
  `promo_type` tinyint(1) DEFAULT NULL,
  `promo_book_ids` varchar(2000) DEFAULT NULL,
  `promo_startdate` date DEFAULT NULL,
  `promo_enddate` date DEFAULT NULL,
  `promo_status` varchar(20) DEFAULT 'DRAFT' COMMENT 'DRAFT,LIVE,DELETE',
  `promo_dateadded` datetime DEFAULT NULL,
  `promo_datemodified` datetime DEFAULT NULL,
  `promo_order` int(11) DEFAULT '1',
  PRIMARY KEY (`promo_auto_id`),
  UNIQUE KEY `auto_id` (`promo_auto_id`),
  KEY `region` (`promo_region_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=32 ;

--
-- Dumping data for table `promotions`
--

INSERT INTO `promotions` (`promo_auto_id`, `promo_region_id`, `promo_title`, `promo_image`, `promo_image_lrg`, `promo_type`, `promo_book_ids`, `promo_startdate`, `promo_enddate`, `promo_status`, `promo_dateadded`, `promo_datemodified`, `promo_order`) VALUES
(22, 1, 'Baby', 'baby_2.png', 'baby_lrg_3.png', 1, '171,172,173,174,175,182,187,189,192,195,199,201', '2015-03-10', '2018-12-31', 'LIVE', '2015-03-03 11:36:18', '2017-01-10 10:54:32', 5),
(23, 1, 'Little Hide and Seek', 'little_hide_and_seek_2.png', 'little_hide_and_seek_lrg_2.png', 1, '170,176', '2015-03-10', '2018-12-31', 'LIVE', '2015-03-03 11:36:46', '2017-01-10 10:54:13', 4),
(24, 1, 'Sophie', 'sophie_2.png', 'sophie_lrg_3.png', 1, '177,178,179,211,213,216', '2015-03-10', '2018-12-31', 'LIVE', '2015-03-03 19:24:15', '2017-01-10 10:53:56', 3),
(25, 1, 'Lets get busy', 'lets_get_busy_6.png', 'lets_get_busy_lrg_5.png', 1, '183,184,185,207,228', '2015-03-10', '2018-12-31', 'LIVE', '2015-03-10 11:23:21', '2017-01-10 10:53:32', 2),
(26, 1, 'Who am I', 'who_am_i_2.png', 'who_am_i_lrg_2.png', 1, '180,181,222,224', '2015-03-10', '2018-12-31', 'LIVE', '2015-03-10 11:24:11', '2017-01-10 10:53:11', 1),
(27, 2, 'Baby', 'baby_3.png', 'baby_lrg_4.png', 1, '186,188,190,191,193,194,196,197,198,200,202,203', '2015-03-10', '2018-12-31', 'LIVE', '2015-03-24 11:11:40', '2017-01-10 10:55:37', 5),
(28, 2, 'Lets get busy', 'lets_get_busy_8.png', 'lets_get_busy_lrg_7.png', 1, '206,208,209,210,229,215', '2015-03-10', '2018-12-31', 'LIVE', '2015-03-24 11:13:58', '2017-01-10 10:55:20', 4),
(29, 2, 'Little Hide and Seek', 'little_hide_and_seek_3.png', 'little_hide_and_seek_lrg_3.png', 1, '204,205', '2015-03-10', '2018-12-31', 'LIVE', '2015-03-24 11:16:27', '2017-01-10 10:55:05', 3),
(30, 2, 'Sophie', 'sophie_3.png', 'sophie_lrg_4.png', 1, '212,214,215,217,218,219,220,221', '2015-03-10', '2018-12-31', 'LIVE', '2015-03-24 11:17:48', '2017-01-10 10:54:50', 2),
(31, 2, 'Who am I', 'who_am_i_3.png', 'who_am_i_lrg_3.png', 1, '223,225,226,227', '2015-03-24', '2016-12-31', 'LIVE', '2015-03-24 11:18:18', '2016-04-21 12:29:07', 1);

-- --------------------------------------------------------

--
-- Table structure for table `readerlevel`
--

DROP TABLE IF EXISTS `readerlevel`;
CREATE TABLE IF NOT EXISTS `readerlevel` (
  `readerlevel_auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `readerlevel_name` varchar(100) DEFAULT NULL,
  `readerlevel_level` tinyint(2) DEFAULT NULL,
  PRIMARY KEY (`readerlevel_auto_id`),
  UNIQUE KEY `auto_id` (`readerlevel_auto_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `readerlevel`
--

INSERT INTO `readerlevel` (`readerlevel_auto_id`, `readerlevel_name`, `readerlevel_level`) VALUES
(1, 'My First Learning', 1),
(2, 'Little Hide and Seek', 2),
(3, 'My First', 3),
(4, 'Sophie la Girafe', 4),
(5, 'Who am I?', 5),
(6, 'Baby', 6);

-- --------------------------------------------------------

--
-- Table structure for table `regions`
--

DROP TABLE IF EXISTS `regions`;
CREATE TABLE IF NOT EXISTS `regions` (
  `region_auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `region_name` varchar(100) DEFAULT NULL,
  `region_code` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`region_auto_id`),
  UNIQUE KEY `auto_id` (`region_auto_id`),
  KEY `region` (`region_code`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `regions`
--

INSERT INTO `regions` (`region_auto_id`, `region_name`, `region_code`) VALUES
(1, 'Great Britain', 'GB'),
(2, 'United States', 'US');

-- --------------------------------------------------------

--
-- Table structure for table `topics`
--

DROP TABLE IF EXISTS `topics`;
CREATE TABLE IF NOT EXISTS `topics` (
  `topic_auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_name` varchar(100) DEFAULT NULL,
  `topic_used_count` int(11) DEFAULT '0',
  PRIMARY KEY (`topic_auto_id`),
  UNIQUE KEY `auto_id` (`topic_auto_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=75 ;

--
-- Dumping data for table `topics`
--

INSERT INTO `topics` (`topic_auto_id`, `topic_name`, `topic_used_count`) VALUES
(55, '|Animals|', 1),
(56, '|Hide and Seek|', 1),
(57, '|Things That Go|', 1),
(58, '|Farm|', 1),
(59, '|Bedtime|', 1),
(60, '|Sophie la girafe Â®|', 1),
(61, '|Baby|', 1),
(62, '|Colours|', 1),
(63, '|Trucks|', 1),
(64, '|Words|', 1),
(65, '|Storytime|', 1),
(66, '|Playtime|', 1),
(67, '|Bathtime|', 1),
(68, '|Colors|', 1),
(69, '|Little Hide and Seek|', 1),
(70, '|Let''s get busy|', 1),
(71, '|Numbers|', 1),
(72, '|Who am I?|', 1),
(73, '|Sophie la girafeÂ®|', 1),
(74, '|Home|', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `user_auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_username` varchar(100) DEFAULT NULL,
  `user_password` varchar(255) DEFAULT NULL,
  `user_region_id` int(11) DEFAULT '0' COMMENT '0 = All Regions or restrict by region auto id',
  PRIMARY KEY (`user_auto_id`),
  UNIQUE KEY `auto_id` (`user_auto_id`),
  KEY `region` (`user_region_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_auto_id`, `user_username`, `user_password`, `user_region_id`) VALUES
(1, 'dkpreschool', '3dcf34a6023633a0d92521ec9c8d5ae4', 0),
(2, 'dkpreschoolgb', '3dcf34a6023633a0d92521ec9c8d5ae4', 1),
(3, 'dkpreschoolus', '3dcf34a6023633a0d92521ec9c8d5ae4', 2);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
