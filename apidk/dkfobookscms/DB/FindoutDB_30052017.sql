-- phpMyAdmin SQL Dump
-- version 4.0.10.10
-- http://www.phpmyadmin.net
--
-- Host: 213.171.200.85
-- Generation Time: May 30, 2017 at 04:14 AM
-- Server version: 5.6.36-log
-- PHP Version: 5.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `FindoutDB`
--
CREATE DATABASE IF NOT EXISTS `FindoutDB` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `FindoutDB`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcDashBoardTotals`(IN `intRegion` INT(10))
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

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcDeleteBookFromStore`(IN `bookID` INT)
    NO SQL
BEGIN

SET @BOOKID = bookID;

DELETE FROM books WHERE book_auto_id=@BOOKID;

END$$

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcGetEmail`(IN `strRegionCode` VARCHAR(3), IN `intType` TINYINT(2))
BEGIN
	#Routine body goes here...
SET @REGCODE = strRegionCode;
SET @TYPE= intType;

SELECT * FROM emails WHERE email_region_id = (SELECT region_auto_id FROM regions WHERE region_code =  @REGCODE  ) AND email_type = @TYPE LIMIT 1 ;

END$$

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcGetEPUB`(IN `intID` INT(11))
BEGIN
SET @ID = intID;

SELECT book_epub,book_sample_epub,book_auto_id FROM books WHERE book_auto_id = @ID LIMIT 1;

END$$

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcGetFunfacts`(IN `strRegionCode` VARCHAR(3), IN `strStatus` VARCHAR(50))
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

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcGetHelppages`(IN `strRegionCode` VARCHAR(3), IN `strStatus` VARCHAR(50))
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

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcGetModDate`(IN `strRegionCode` VARCHAR(3))
BEGIN
	#Routine body goes here...
SET @REGCODE = strRegionCode;
SELECT book_datemodified FROM books WHERE book_region_id = (SELECT region_auto_id FROM regions WHERE region_code =  @REGCODE  ) ORDER BY book_datemodified DESC LIMIT 1;

END$$

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcGetPromos`(IN `strRegionCode` VARCHAR(3), IN `strStatus` VARCHAR(50))
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

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcGetRecords`(IN `strTable` VARCHAR(100), IN `strCols` VARCHAR(500), IN `strKeyword` VARCHAR(50), IN `strRecord` VARCHAR(50), IN `intRegion` TINYINT(4))
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

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcGetStore`(IN `strRegionCode` VARCHAR(3), IN `strStatus` VARCHAR(50))
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

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcLogin`(IN `strUsername` VARCHAR(255), IN `strPassword` VARCHAR(255))
BEGIN
	#Routine body goes here...
SET @USER = strUsername;
SET @PASS = strPassword;

SELECT user_username,user_region_id FROM users WHERE user_username = @USER AND user_password = @PASS;

END$$

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcReOrder`(IN `strTable` VARCHAR(50), IN `strDirect` VARCHAR(50), IN `intTo` INT(10), IN `intFrom` INT(10), IN `strField` VARCHAR(50), IN `strWhere` VARCHAR(50), IN `strID` VARCHAR(50))
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

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcSaveBook`(IN `strAction` VARCHAR(50), IN `strBookTitle` VARCHAR(255), IN `strBookAuthor` VARCHAR(255), IN `strBookImage` VARCHAR(255), IN `strBookEpub` VARCHAR(255), IN `strBookSEpub` VARCHAR(255), IN `intBookLevel` TINYINT(1), IN `intBookRegion` TINYINT(5), IN `strBookShort` VARCHAR(255), IN `strBookLong` VARCHAR(3000), IN `intBookOffer` TINYINT(1), IN `intBookNew` TINYINT(1), IN `intBookFree` TINYINT(1), IN `intBookFeet` TINYINT(1), IN `intBookReadLoud` TINYINT(1), IN `dateBookPub` DATE, IN `strBookApple` VARCHAR(255), IN `strBookAndroid` VARCHAR(255), IN `strBookTopics` VARCHAR(10000), IN `strBookStatus` VARCHAR(50), IN `intBookID` INT(11))
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

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcSaveFunFact`(IN `strAction` VARCHAR(50), IN `strFunTitle` VARCHAR(255), IN `strFunImage` VARCHAR(255), IN `intFunRegion` TINYINT(5), IN `dateFunStart` DATE, IN `dateFunEnd` DATE, IN `strFunStatus` VARCHAR(50), IN `intFunID` INT(11))
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

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcSaveHelp`(IN `strAction` VARCHAR(50), IN `strHelpTitle` VARCHAR(255), IN `strHelpImage` VARCHAR(255), IN `intHelpRegion` TINYINT(5), IN `strHelpStatus` VARCHAR(50), IN `intHelpTempID` INT(11), IN `strHelpCont` VARCHAR(15000), IN `intHelpID` INT(11), IN `strHelpGuid` VARCHAR(50), IN `intHelpSOrder` INT(11), IN `strHelpSTitle` VARCHAR(255), IN `strHelpSStatus` VARCHAR(50))
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

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcSaveHelpSection`(IN `strAction` VARCHAR(50), IN `strHelpSTitle` VARCHAR(255), IN `strHelpSStatus` VARCHAR(50), IN `strHelpSGUID` VARCHAR(50))
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

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcSavePromo`(IN `strAction` VARCHAR(50), IN `strPromoTitle` VARCHAR(255), IN `strPromoImage` VARCHAR(255), IN `strPromoImageLrg` VARCHAR(255), IN `intPromoRegion` TINYINT(5), IN `strBookIds` VARCHAR(255), IN `strPromoType` TINYINT(1), IN `datePromoStart` DATE, IN `datePromoEnd` DATE, IN `strPromoStatus` VARCHAR(50), IN `intPromoID` INT(11))
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

CREATE DEFINER=`DBdkfoadmin`@`%` PROCEDURE `funcTags`(IN `strTags` VARCHAR(10000))
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
CREATE DEFINER=`DBdkfoadmin`@`%` FUNCTION `split_string`(`stringToSplit` VARCHAR(256), `sign` VARCHAR(12), `position` INT) RETURNS varchar(256) CHARSET latin1
BEGIN
        RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(stringToSplit, sign, position),LENGTH(SUBSTRING_INDEX(stringToSplit, sign, position -1)) + 1), sign, '');
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=212 ;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`book_auto_id`, `book_region_id`, `book_title`, `book_reader_level`, `book_short_desc`, `book_long_desc`, `book_author_name`, `book_image`, `book_new`, `book_free`, `book_feature`, `book_onoffer`, `book_readaloud`, `book_epub`, `book_sample_epub`, `book_publication_date`, `book_apple_purchase_id`, `book_android_purchase_id`, `book_topics`, `book_status`, `book_dateadded`, `book_datemodified`) VALUES
(191, 1, 'Dinosaurs', 4, 'Find out about your favourite dinosaurs in the prehistoric world', '<b><i>DK findout! Dinosaurs</i></b> teaches kids everything they would want to know about their favourite dinosaurs in the prehistoric world. Discover how fossils are formed, find out which was the biggest dinosaur, and which was the size of a cat. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'dk_findout_dinosaur_1.jpg', 0, 0, 1, 0, 0, 'dk_findout_dinosaur_1.epub', 'dk_findout_dinosaur_sample_1.epub', '2016-06-16', '9780241293171', '9780241293263', '|Amphibians|,|Birds|,|Camouflage|,|Carnivores|,|Colour|,|Cretaceous period|,|Dinosaurs|,|Fish|,|Fossils|,|Herbivores|,|Insects|,|Invertebrates|,|Jurassic period|,|Mammals|,|Meteorites|,|Nests|,|Omnivores|,|Paleontologists|,|Plants|,|Reptiles|,|Scientists|,|Skeletons|,|Triassic period|,|Volcanoes|', 'PUBLISHED', '2016-06-17 18:20:50', '2017-01-16 09:59:30'),
(188, 1, 'Animals', 3, 'Everything to know about the animal kingdom', '<b><i>DK findout! Animals</b></i> teaches kids everything they would want to know about all their favourite creatures in the animal kingdom. Discover what makes up a bird and how animals use camouflage to hide, to which animal spends the longest time in bed. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'dk_findout_animals_6.jpg', 0, 0, 1, 0, 0, 'dk_findout_animals_2.epub', 'dk_findout_animals_sample_2.epub', '2016-06-12', '9780241293164', '9780241293249', '|Adaptation|,|Amphibians|,|Animals|,|Animal homes|,|Arachnids|,|Birds|,|Camouflage|,|Carnivores|,|Conservation|,|Coral reefs|,|Defences|,|Fish|,|Food|,|Forests|,|Habitats|,|Herbivores|,|Insects|,|Invertebrates|,|Life cycles|,|Mammals|,|Nests|,|Omnivores|,|Reproduction|,|Reptiles|,|Senses|,|Skeletons|,|Vertebrates|', 'PUBLISHED', '2016-06-13 18:24:19', '2017-01-16 09:59:19'),
(189, 1, 'Volcanoes', 6, 'Find out about the explosive world of volcanoes', '<b><i>DK findout! Volcanoes</b></i> teaches kids everything they would want to know about the explosive world of volcanoes. Discover what the biggest volcano in the solar system is, and which type of lava is the stickiest. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'dk_findout_volcanoes_4.jpg', 0, 0, 1, 0, 0, 'dk_findout_volcanoes_3.epub', 'dk_findout_volcanoes_sample_3.epub', '2016-06-12', '9780241293201', '9780241293287', '|Caves|,|Dinosaurs|,|Earth|,|Earthquakes|,|Gases|,|Gods and goddesses|,|Habitats|,|Hazards|,|Islands|,|Jupiter|,|Mars|,|Neptune|,|Rocks|,|Saturn|,|Space|,|Volcanoes|,|Water|', 'PUBLISHED', '2016-06-13 20:33:07', '2017-01-16 10:00:06'),
(190, 1, 'Ancient Rome', 2, 'Discover what life was like in ancient Rome', '<b><i>DK findout! Ancient Rome</i></b> takes kids back in time to discover what life was like in ancient Rome. Discover what Romans would have put in their shopping baskets, how to decode Roman numerals, and go into battle with the gladiators. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'dk_findout_ancient_rome_1.jpg', 0, 0, 1, 0, 0, 'dk_findout_ancient_rome_1.epub', 'dk_findout_ancient_rome_sample_1.epub', '2016-06-16', '9780241293157', '9780241293232', '|Ancient Greeks|,|Animals|,|Archaeology|,|Bridges|,|Buildings|,|Calendar|,|Children|,|Clothes|,|Colour|,|Education|,|Family life|,|Farmers|,|Gladiators|,|Gods and goddesses|,|Jewellery|,|Jupiter|,|Language|,|Mars|,|Medicine|,|Numbers|,|Roads|,|Roman emperors|,|Roman empire|,|Roman soldiers|,|Rome|,|Society|,|Volcanoes|,|Weapons|', 'PUBLISHED', '2016-06-17 18:18:28', '2017-01-16 09:59:07'),
(192, 1, 'Science', 5, 'Discover the exciting world of science', '<b><i>DK findout! Science</i></b> teaches kids everything they would want to know about the exciting world of science, from light and electricity, to animals and parts of the body. Discover how to make a rainbow and all about the states of matter, sparking the imagination of children while providing inspiration for science fair projects. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'dk_findout_science_1.jpg', 0, 0, 1, 0, 0, 'dk_findout_science_1.epub', 'dk_findout_science_sample_1.epub', '2016-06-16', '9780241293195', '9780241293270', '|Amphibians|,|Animals|,|Birds|,|Colour|,|Comets|,|Deserts|,|Digestion system|,|Earth|,|Electricity|,|Energy|,|Evolution|,|Fish|,|Flowers|,|Food|,|Forces|,|Friction|,|Fruit|,|Fungus|,|Gases|,|Gears|,|Gravity|,|Heart|,|Heat|,|Human body|,|Insects|,|Inventions|,|Inventors|,|Laws of motion|,|Light|,|Liquids|,|Lungs|,|Machines|,|Magnets|,|Mammals|,|Materials|,|Medicine|,|Metals|,|Mixtures|,|Moon|,|Muscles|,|Nutrition|,|Plants|,|Pollination|,|Reproduction|,|Rocks|,|Rockets|,|Science|,|Scientists|,|Seeds|,|Senses|,|Shadows|,|Skeletons|,|Solids|,|Sound|,|Space|,|Sun|,|Universe|,|Vertebrates|,|Water|,|Weather|', 'PUBLISHED', '2016-06-17 18:23:03', '2017-01-16 09:59:44'),
(193, 1, 'Solar System', 7, 'Discover the awe-inspiring solar system', '<b><i>DK findout! Solar System</i></b> teaches kids everything budding astronomers would want to know about the awe-inspiring solar system, from the planets to meteorites. Discover what the weather is like on Jupiter, or take a trip across Mars with the rover mission. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'dk_findout_solar_system_1.jpg', 0, 0, 1, 0, 0, 'solar_system_1.epub', 'solar_system_sample_1.epub', '2016-06-16', '9780241293225', '9780241293294', '|Asteroids|,|Astronauts|,|Comets|,|Dinosaurs|,|Earth|,|Energy|,|Exoplanets|,|Galaxies|,|Gravity|,|Jupiter|,|Mars|,|Mercury|,|Meteorites|,|Moon|,|Neptune|,|Planets|,|Saturn|,|Solar system|,|Space|,|Space race|,|Space Shuttle|,|space station|,|stars|,|Sun|,|Water|', 'PUBLISHED', '2016-06-17 18:25:19', '2017-01-16 09:59:55'),
(196, 1, 'Free Sample', 1, 'Free sample', 'Free sample\r\n', '', 'free_sample_1.jpg', 0, 1, 0, 0, 0, 'free_sample_1.epub', '', '2016-06-28', '', '', '', 'PUBLISHED', '2016-06-29 14:08:40', '2016-07-19 14:54:51'),
(197, 2, 'Ancient Rome', 2, 'Discover what life was like in Ancient Rome', '<b><i>DK findout! Ancient Rome</i></b> takes kids back in time to discover what life was like in Ancient Rome. Discover what Romans would have put in their shopping baskets, learn how to decode Roman numerals, and go into battle with the gladiators. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'ancient_rome_1.jpg', 0, 0, 1, 0, 0, 'ancient_rome_1.epub', 'ancient_rome_sample_1.epub', '2016-08-18', '9781465460677', '9781465461001', '|Ancient Greeks|,|Animals|,|Archaeology|,|Bridges|,|Buildings|,|Calendar|,|Children|,|Clothes|,|Color|,|Education|,|Family life|,|Farmers|,|Gladiators|,|Gods and goddesses|,|Jewelry|,|Jupiter|,|Language|,|Mars|,|Medicine|,|Numbers|,|Roads|,|Roman emperors|,|Roman empire|,|Roman soldiers|,|Rome|,|Society|,|Volcanoes|,|Weapons|', 'PUBLISHED', '2016-07-13 14:15:30', '2017-01-10 10:18:19'),
(202, 2, 'Solar System', 7, 'Discover the awe-inspiring solar system', '<b><i>DK findout! Solar System</i></b> teaches kids everything budding astronomers want to know about the awe-inspiring solar system, from the planets to meteorites. Discover what the weather is like on Jupiter, or take a trip across Mars with the rover mission. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'solar_system_1.jpg', 0, 0, 1, 0, 0, 'solar_system_2.epub', 'solar_system_sample_3.epub', '2016-08-02', '9781465460998', '9781465461056', '|Asteroids|,|Astronauts|,|Comets|,|Dinosaurs|,|Earth|,|Energy|,|Exoplanets|,|Galaxies|,|Gravity|,|Jupiter|,|Mars|,|Mercury|,|Meteorites|,|Moon|,|Neptune|,|Planets|,|Saturn|,|Solar system|,|Space|,|Space race|,|Space Shuttle|,|space station|,|stars|,|Sun|,|Water|', 'PUBLISHED', '2016-07-13 14:21:45', '2017-01-10 10:20:11'),
(203, 2, 'Volcanoes', 6, 'Find out about the explosive world of volcanoes', '<b><i>DK findout! Volcanoes</b></i> teaches kids everything they want to know about the explosive world of volcanoes. Discover everything from what the biggest volcano in the solar system is, to which type of lava is the stickiest. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'volcanoes_1.jpg', 0, 0, 1, 0, 0, 'volcanoes_1.epub', 'volcanoes_sample_1.epub', '2016-08-02', '9781465460981', '9781465461049', '|Caves|,|Dinosaurs|,|Earth|,|Earthquakes|,|Gases|,|Gods and goddesses|,|Habitats|,|Hazards|,|Islands|,|Jupiter|,|Mars|,|Neptune|,|Rocks|,|Saturn|,|Space|,|Volcanoes|,|Water|', 'PUBLISHED', '2016-07-13 14:22:46', '2017-01-10 10:38:35'),
(199, 2, 'Dinosaurs', 4, 'Find out about your favorite dinosaurs in the prehistoric world', '<b><i>DK findout! Dinosaurs</i></b> teaches kids everything they want to know about their favorite dinosaurs in the prehistoric world. Discover how fossils are formed, find out which was the biggest dinosaur, and learn which dinosaur was the size of a cat. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'dinosaurs_1.jpg', 0, 0, 1, 0, 0, 'dinosaurs_1.epub', 'dinosaurs_sample_1.epub', '2016-08-02', '9781465460691', '9781465461025', '|Amphibians|,|Birds|,|Camouflage|,|Carnivores|,|Color|,|Cretaceous period|,|Dinosaurs|,|Fish|,|Fossils|,|Herbivores|,|Insects|,|Invertebrates|,|Jurassic period|,|Mammals|,|Meteorites|,|Nests|,|Omnivores|,|Paleontologists|,|Plants|,|Reptiles|,|Scientists|,|Skeletons|,|Triassic period|,|Volcanoes|', 'PUBLISHED', '2016-07-13 14:18:42', '2017-01-10 10:19:07'),
(200, 2, 'Free Sample', 1, 'Free sample', 'Free sample', '', 'free_sample_3.jpg', 0, 1, 0, 0, 0, 'free_sample_2.epub', '', '2016-08-18', '', '', '', 'PUBLISHED', '2016-07-13 14:19:33', '2017-01-16 10:36:47'),
(201, 2, 'Science', 5, 'Discover the exciting world of science', '<b><i>DK findout! Science</i></b> teaches kids everything they want to know about the exciting world of science, from light and electricity to animals and parts of the body. Discover how to make a rainbow and all about the states of matter, sparking children''s imaginations while providing inspiration for school and science-fair projects. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'science_1.jpg', 0, 0, 1, 0, 0, 'science_1.epub', 'science_sample_1.epub', '2016-08-18', '9781465460974', '9781465461032', '|Amphibians|,|Animals|,|Birds|,|Color|,|Comets|,|Deserts|,|Digestion system|,|Earth|,|Electricity|,|Energy|,|Evolution|,|Fish|,|Flowers|,|Food|,|Forces|,|Friction|,|Fruit|,|Fungus|,|Gases|,|Gears|,|Gravity|,|Heart|,|Heat|,|Human body|,|Insects|,|Inventions|,|Inventors|,|Laws of motion|,|Light|,|Liquids|,|Lungs|,|Machines|,|Magnets|,|Mammals|,|Materials|,|Medicine|,|Metals|,|Mixtures|,|Moon|,|Muscles|,|Nutrition|,|Plants|,|Pollination|,|Reproduction|,|Rocks|,|Rockets|,|Science|,|Scientists|,|Seeds|,|Senses|,|Shadows|,|Skeletons|,|Solids|,|Sound|,|Space|,|Sun|,|Universe|,|Vertebrates|,|Water|,|Weather|', 'PUBLISHED', '2016-07-13 14:20:45', '2017-01-10 10:19:24'),
(198, 2, 'Animals', 3, 'Discover everything there is to know about the animal kingdom', '<b><i>DK findout! Animals</b></i> teaches kids everything they want to know about all their favorite creatures in the animal kingdom. Discover what makes up a bird, how animals use camouflage to hide, and which animal spends the longest time sleeping. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'animals_1.jpg', 0, 0, 1, 0, 0, 'animals_1.epub', 'animals_sample_1.epub', '2016-08-02', '9781465460684', '9781465461018', '|Adaptation|,|Amphibians|,|Animals|,|Animal homes|,|Arachnids|,|Birds|,|Camouflage|,|Carnivores|,|Conservation|,|Coral reefs|,|Defenses|,|Fish|,|Food|,|Forests|,|Habitats|,|Herbivores|,|Insects|,|Invertebrates|,|Life cycles|,|Mammals|,|Nests|,|Omnivores|,|Reproduction|,|Reptiles|,|Senses|,|Skeletons|,|Vertebrates|', 'PUBLISHED', '2016-07-13 14:17:22', '2017-01-10 10:18:35'),
(204, 1, 'Stone Age', 2, 'Discover some really fun facts about Stone Age life', '<b><i>DKfindout! Stone Age</i></b> takes kids back in time to discover what life was like in the Stone Ages. Discover what Stone Age people wore, sample some of their favourite foods and spot the Stone Age animal. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'stone_age_2.jpg', 1, 0, 0, 0, 0, 'stone_age_2.epub', 'stone_age_sample_2.epub', '2017-01-16', '9780241307335', '9780241307328', '|Africa|,|Animals|,|Archaeology|,|Arctic|,|Australia|,|Art|,|Beliefs|,|Boats|,|Bronze Age|,|Buildings|,|Carvings|,|Caves|,|Clothes|,|Cooking|,|Crafts|,|Crops|,|Europe|,|Family life|,|Farmers|,|Fire|,|Fish|,|Food|,|Fossils|,|Fruit|,|Homo sapiens|,|Hunter-gatherers|,|Ice Ages|,|Iron Age|,|Jewellery|,|Medicine|,|Megaliths|,|Mesolithic Age|,|Meteorites|,|Music|,|Neanderthals|,|Neolithic Age|,|North America|,|Plants|,|Shelters|,|South America|,|Stone Age|,|Tools|,|Trade|,|Tribes|,|Weapons|,|Writing|', 'PUBLISHED', '2016-12-12 14:56:27', '2017-01-16 09:58:18'),
(205, 2, 'Stone Age', 2, 'Discover some really fun facts about Stone Age life', '<b><i>DKfindout! Stone Age</i></b> takes kids back in time to discover what life was like in the Stone Ages. Discover what Stone Age people wore, sample some of their favorite foods and spot the Stone Age animal. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'stone_age_1.jpg', 1, 0, 0, 0, 0, 'stone_age_1.epub', 'stone_age_sample_1.epub', '2017-01-10', '9781465465023', '9781465465030', '|Africa|,|Animals|,|Archaeology|,|Arctic|,|Australia|,|Art|,|Beliefs|,|Boats|,|Bronze Age|,|Buildings|,|Carvings|,|Caves|,|Clothes|,|Cooking|,|Crafts|,|Crops|,|Europe|,|Family life|,|Farmers|,|Fire|,|Fish|,|Food|,|Fossils|,|Fruit|,|Homo sapiens|,|Hunter-gatherers|,|Ice Ages|,|Iron Age|,|Jewelry|,|Medicine|,|Megaliths|,|Mesolithic Age|,|Meteorites|,|Music|,|Neanderthals|,|Neolithic Age|,|North America|,|Plants|,|Shelters|,|South America|,|Stone Age|,|Tools|,|Trade|,|Tribes|,|Weapons|,|Writing|', 'PUBLISHED', '2016-12-13 12:20:52', '2017-01-10 10:32:41'),
(206, 1, 'Sharks', 3, 'Read and learn expert facts about sharks', 'For any kid that can''t get enough of shark facts, <b><i>DKfindout! Sharks</i></b> is packed with up-to-date information, fun quizzes, and incredible images of all their favourite sharks, including bullhead, carpet and angel sharks. Discover sharks from prehistoric times to matching sharks eggs to their parents. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'sharks_2.jpg', 1, 0, 0, 0, 0, 'sharks_2.epub', 'sharks_sample_2.epub', '2017-01-16', '9780241307342', '9780241307359', '|Animals|,|Birth|,|Conservation|,|Coral reefs|,|Diet|,|Ecosystem|,|Extinction|,|Fins|,|Fish|,|Fossils|,|Habitats|,|Heart|,|Hunting|,|Living things|,|Migration|,|Movement|,|Muscles|,|Parasites|,|Plankton|,|Pollution|,|Predators|,|Rays|,|Senses|,|Sharks|,|Skeletons|,|Speed|,|Vertebrates|', 'PUBLISHED', '2016-12-13 14:34:42', '2017-01-16 09:58:05'),
(207, 2, 'Sharks', 3, 'Read and learn expert facts about sharks', 'For any kid that can''t get enough of shark facts, <b><i>DKfindout! Sharks</i></b> is packed with up-to-date information, fun quizzes, and incredible images of all their favorite sharks, including bullhead, carpet, and angel sharks. Discover sharks from prehistoric times to matching sharks eggs to their parents. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'sharks_1.jpg', 1, 0, 0, 0, 0, 'sharks_1.epub', 'sharks_sample_1.epub', '2017-01-10', '9781465465047', '9781465465054', '|Animals|,|Birth|,|Conservation|,|Coral reefs|,|Diet|,|Ecosystem|,|Extinction|,|Fins|,|Fish|,|Fossils|,|Habitats|,|Heart|,|Hunting|,|Living things|,|Migration|,|Movement|,|Muscles|,|Parasites|,|Plankton|,|Pollution|,|Predators|,|Rays|,|Senses|,|Sharks|,|Skeletons|,|Speed|,|Vertebrates|', 'PUBLISHED', '2016-12-13 14:37:11', '2017-01-10 10:32:20'),
(208, 1, 'Ancient Egypt', 2, 'Find out fun facts about ancient Egyptian life', '<b><i>DKfindout! Ancient Egypt</i></b> takes kids back in time to discover what life was like in Ancient Egypt. Discover how the Egyptians built the pyramids, how to decode Egyptian hieroglyphs, and take a look inside a mummy sarcophagus. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'ancient_egypt_2.jpg', 1, 0, 0, 0, 0, 'ancient_egypt_2.epub', 'ancient_egypt_sample_2.epub', '2017-01-16', '9780241307373', '9780241307380', '|Afterlife|,|Animals|,|Architects|,|Art|,|Ancient Egyptians|,|Archaeology|,|Boats|,|Beliefs|,|Children|,|Clothes|,|Crafts|,|Deserts|,|Education|,|Empire|,|Excavations|,|Family life|,|Farmers|,|Festivals|,|Food|,|Gods and goddesses|,|Heart|,|Hieroglyphs|,|Homes|,|Jewellery|,|Language|,|Medicine|,|Metals|,|Mummies|,|Rivers|,|Pets|,|Pharoahs|,|Pyramids|,|Roman Empire|,|Society|,|Soldiers|,|Temples|,|Tombs|,|Trade|,|Weapons|,|Writing|', 'PUBLISHED', '2016-12-13 14:39:11', '2017-01-16 09:57:37'),
(209, 2, 'Ancient Egypt', 2, 'Find out fun facts about ancient Egyptian life', '<b><i>DKfindout! Ancient Egypt</i></b> takes kids back in time to discover what life was like in Ancient Egypt. Discover how the Egyptians built the pyramids, how to decode Egyptian hieroglyphs, and take a look inside a mummy sarcophagus. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'ancient_egypt_1.jpg', 1, 0, 0, 0, 0, 'ancient_egypt_1.epub', 'ancient_egypt_sample_1.epub', '2017-01-10', '9781465465061', '9781465465078', '|Afterlife|,|Animals|,|Architects|,|Art|,|Ancient Egyptians|,|Archaeology|,|Boats|,|Beliefs|,|Children|,|Clothes|,|Crafts|,|Deserts|,|Education|,|Empire|,|Excavations|,|Family life|,|Farmers|,|Festivals|,|Food|,|Gods and goddesses|,|Heart|,|Hieroglyphs|,|Homes|,|Jewelry|,|Language|,|Medicine|,|Metals|,|Mummies|,|Rivers|,|Pets|,|Pharoahs|,|Pyramids|,|Roman Empire|,|Society|,|Soldiers|,|Temples|,|Tombs|,|Trade|,|Weapons|,|Writing|', 'PUBLISHED', '2016-12-13 14:40:45', '2017-01-10 10:31:22'),
(210, 1, 'Pirates', 2, 'Discover the truth about the lives of pirates', '<b><i>DKfindout! Pirates</i></b> takes kids back in time to discover the truth behind the myth. Discover what pirates ate, what life was like onboard a ship, and the rules they had to follow. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'pirates_2.jpg', 1, 0, 0, 0, 0, 'pirates_2.epub', 'pirates_sample_2.epub', '2017-01-16', '9780241307410', '9780241307427', '|Africa|,|Ancient Egyptians|,|Ancient Greeks|,|Boats|,|Clothes|,|Flags|,|Food|,|Islands|,|Kings and Queens|,|Maps|,|Medicine|,|Music|,|North America|,|Oceans and Seas|,|Pirates|,|Punishments|,|Roman Empire|,|Shipwrecks|,|Trade|,|Treasure|,|Weapons|,|World War I|', 'PUBLISHED', '2016-12-13 14:44:02', '2017-01-16 09:57:51'),
(211, 2, 'Pirates', 2, 'Discover the truth about the lives of pirates', '<b><i>DKfindout! Pirates</i></b> takes kids back in time to discover the truth behind the myth. Discover what pirates ate, what life was like onboard a ship, and the rules they had to follow. With beautiful photography, lively illustrations, and key curriculum information, the <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!', '', 'pirates_1.jpg', 1, 0, 0, 0, 0, 'pirates_1.epub', 'pirates_sample_1.epub', '2017-01-10', '9781465465085', '9781465465092', '|Africa|,|Ancient Egyptians|,|Ancient Greeks|,|Boats|,|Clothes|,|Flags|,|Food|,|Islands|,|Kings and Queens|,|Maps|,|Medicine|,|Music|,|North America|,|Oceans and Seas|,|Pirates|,|Punishments|,|Roman Empire|,|Shipwrecks|,|Trade|,|Treasure|,|Weapons|,|World War I|', 'PUBLISHED', '2016-12-13 14:48:42', '2017-01-10 10:32:06');

-- --------------------------------------------------------

--
-- Table structure for table `emails`
--

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
(1, 'DK Reader - Pin Info', 'Please hang on to this email, it contains important info you''ll need to sign into your account.\r\n\r\nYour Pin Number: [#PIN#]\r\n\r\n', 1, 2),
(2, 'DK Reader - Pin Info', 'Please hang on to this email, it contains important info you''ll need to sign into your account.\r\n\r\nYour Pin Number: [#PIN#]\r\n\r\n', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `funfacts`
--

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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=74 ;

--
-- Dumping data for table `funfacts`
--

INSERT INTO `funfacts` (`funfact_auto_id`, `funfact_region_id`, `funfact_title`, `funfact_image`, `funfact_startdate`, `funfact_enddate`, `funfact_status`, `funfact_order`, `funfact_dateadded`, `funfact_datemodified`) VALUES
(65, 1, 'Fun Fact 1', 'fun_fact_1_1.png', '2016-06-10', '2019-04-30', 'DRAFT', 4, '2016-06-10 19:08:46', '2016-06-29 17:06:20'),
(66, 1, 'Fun Fact 2', 'fun_fact_2_1.png', '2016-06-10', '2019-06-24', 'LIVE', 3, '2016-06-10 19:11:26', '2016-06-27 11:07:23'),
(67, 1, 'Fun Fact 3', 'fun_fact_3_1.png', '2016-06-10', '2019-06-24', 'LIVE', 1, '2016-06-10 19:11:53', '2016-06-27 11:07:18'),
(68, 1, 'Fun Fact 4', 'fun_fact_4_1.png', '2016-06-10', '2019-06-24', 'DRAFT', 6, '2016-06-10 19:12:22', '2016-06-29 17:06:33'),
(69, 1, 'Fun Fact 5', 'fun_fact_5_1.png', '2016-06-10', '2019-06-24', 'DRAFT', 5, '2016-06-10 19:12:45', '2016-06-29 17:06:27'),
(70, 1, 'Fun Fact 6', 'fun_fact_6_1.png', '2016-06-10', '2019-06-24', 'LIVE', 2, '2016-06-10 19:13:07', '2016-06-27 11:07:30'),
(71, 2, 'Fun Fact 3', 'fun_fact_3_2.png', '2016-08-01', '2020-08-15', 'LIVE', 1, '2016-08-01 16:38:26', '2016-08-01 16:38:26'),
(72, 2, 'Fun Fact 6', 'fun_fact_6_2.png', '2016-08-01', '2020-08-15', 'LIVE', 2, '2016-08-01 16:39:05', '2016-08-01 16:39:05'),
(73, 2, 'Fun Fact 2', 'fun_fact_2_2.png', '2016-08-01', '2020-08-15', 'LIVE', 3, '2016-08-01 16:39:37', '2016-08-01 16:39:37');

-- --------------------------------------------------------

--
-- Table structure for table `helppages`
--

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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=22 ;

--
-- Dumping data for table `helppages`
--

INSERT INTO `helppages` (`helppage_auto_id`, `helppage_section_guid`, `helppage_section`, `helppage_section_status`, `helppage_section_order`, `helppage_template_id`, `helppage_title`, `helppage_image`, `helppage_region_id`, `helppage_content`, `helppage_order`, `helppage_status`, `helppage_dateadded`, `helppage_datemodified`) VALUES
(1, 'E62D03E551C1367C1AB0D4A0C99EF3CC', 'How this app works', 'LIVE', 1, 1, 'How this app works', 'how_this_app_works_1.jpg', 1, '<p>Welcome to the <b>DK findout!</b> app. The app provides a safe and self-contained bookstore packed with books from the <b>DK findout!</b> series to browse and buy. You can set up a bookshelf for each young reader in your home and fill it with <b>DK findout!</b> books for your child, to enjoy over and over again. Here is a quick guide to getting the most from this app.</p>\r\n\r\n<p>After the welcome screen, you will be asked to create a parentâ€™s PIN number. This ensures your child cannot make purchases without your permission. Weâ€™ll ask for your email address so if you forget your PIN we can send you a reminder.</p>\r\n\r\n<p>The next step is creating a bookshelf for your child. Weâ€™ll ask for each childâ€™s name. Get access to books directly from this bookshelf. Tap the â€œAdd Bookâ€ button and choose either the Bookstore, or from titles your family has already purchased.</p> \r\n\r\n<p>The <b>DK findout!</b> Bookstore contains a library of ebooks from the <b>DK findout!</b> series to browse and buy. You can tap on a title to bring up a short summary about the ebook, and download a sample to browse for free. If you decide to purchase the ebook, you will be asked for your PIN to proceed. It''s that simple.</p>\r\n\r\n<p>Now it''s over to your child. In the Bookstore, your child can browse through the ebooks with you and add titles to a wish list. When opening his or her bookshelf, your child can choose from a series of pictures to personalize the shelf.</p> \r\n\r\n<p>Get reading! Tap a book to open it. Mini-pages at the bottom of the screen show where your child is in the ebook. Finished? Click a button and your child is asked to let you know she or he has finished reading the book.</p> \r\n\r\n<p>Parents can access a page to see what their child has been reading, review purchases, reset PIN, and restore any purchases that may no longer be viewed. The <b>DK findout!</b> app is easy to use, and an easy way for your child to find out amazing facts on a range of topics.</p>    \r\n                                                                                                                                                     \r\n<p>At any time, clicking on the <b>DK findout!</b> logo, will take you or your child to <a href="http://www.dkfindout.com">www.dkfindout.com</a>, the only free encyclopedia a child will ever need. This is a safe, secure, and reliable site for your child to find out more information. Adult authorization is requested for leaving the app and entering the website.</p>\r\n\r\nFor questions or queries please contact customerservices@dk.com', 1, 'LIVE', '2013-11-12 10:27:03', '2016-06-30 14:13:59'),
(2, '5E2A2455FCDAEC8F8A166496A4C82C0D', 'About DK findout!', 'LIVE', 2, 2, 'About DK findout!', 'about_dk_findout_1.jpg', 1, '<p>Fun and factual, <b>DK findout!</b> is the innovative new childrenâ€™s reference series, packed with up-to-date information, surprising facts, fun quizzes, timelines, and interviews. Stunning photography brings each topic alive and they''ll help with school projects as well. The <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!</p>\r\n\r\n<p><b>DK findout!</b> is not just books! It''s a free, safe, secure, and reliable website, which allows your child to search, learn, and explore information. Perfect for help with homework, DK''s clear, up-to-date, and highly visual content covers all curriculum subjects and more! There are quizzes, videos, and animations, and new content being added all the time to engage and fascinate your child. The site encourages eager learners and develops your child''s research skills. There are also articles for parents explaining the curriculum your child is being taught, ideas about how you can help them, and quick links to other DK products that will support your child''s learning.</p> ', 1, 'LIVE', '2013-11-12 10:31:35', '2016-06-30 14:15:26'),
(11, '0D4B65F9456360BF899620EAC6BF7A10', 'Featured DK findout! books', 'LIVE', 3, 1, 'Featured DK findout! books', 'featured_dk_findout_books_1.jpg', 1, '<p>Each year the <b>DK findout!</b> series will grow with books on children''s favourite topics, such as Animals, Dinosaurs, Space, Science, and History. We''ll highlight the new titles in a banner so that they are easy to find.</p>', 1, 'LIVE', '2013-11-12 10:52:32', '2016-06-30 14:16:18'),
(12, 'F7793F4E422A575F43E51167B497038B', 'Free DK findout! sample', 'LIVE', 4, 2, 'Free DK findout! sample', 'free_dk_findout_sample_1.jpg', 1, '<p>To help you build your child''s <b>DK findout!</b> Bookshelf, we are delighted to offer a sample for you to download free. This includes a selection of pages from each of the first six titles in the series. We hope your child enjoys reading them and encourages him or her to want to find out more.</p>', 1, 'LIVE', '2013-11-12 10:53:30', '2016-06-30 14:29:56'),
(13, 'A3994C58129ACAD251433CD8424C2F96', 'About DK', 'LIVE', 5, 3, 'About DK', 'about_dk_1.jpg', 1, '<p>Established in 1974, DK creates best-selling, award-winning, and visually stunning information for adults and children, visit www.dk.com to find out more. From travel guides and activity books, through to food, history, gardening, and much more, DK makes ideas come to life.</p>\r\n\r\n<p>DK has established a worldwide reputation for its innovative nonfiction books in which the unrivaled clarity of the words and pictures come together to spectacular effect. DK content in all its forms is characterised by quality, expertise, and accessibility. DK is a brand that inspires trust and we pride ourselves in creating visual information with international appeal, working with companies worldwide who share our values and ethos.</p>\r\n\r\n<p>Our adult range spans from travel, including the award-winning Eyewitness Travel Guides to history, science, nature, sports, gardening, cookery, and parenting. We also publish an extensive children''s catalogue that showcases a fantastic store of knowledge for children, toddlers, and babies. Covering topics from history and the human body to animals and activities, DK children''s books combine outstanding information with magical illustration and design.</p>\r\n\r\n<p>We work closely with authors who are experts in their field, with authoritative institutions like the Royal Horticultural Society and the Smithsonian, as well as with well-known brands such as Star Wars and the LEGO Group, to produce world-class books and products.</p> \r\n\r\n<p>DK has offices in Delhi, London, Melbourne, Munich, New York, and Toronto.</p>', 1, 'LIVE', '2013-11-12 10:56:00', '2016-06-30 14:17:58'),
(14, 'A5BD3E688FCFA8A9CBB8BF68F9FCB034', 'How this app works', 'LIVE', 1, 1, 'How this app works', 'how_this_app_works_2.jpg', 2, '<p>Welcome to the <b>DK findout!</b> app. The app provides a safe and self-contained bookstore packed with books from the <b>DK findout!</b> series to browse and buy. You can set up a bookshelf for each young reader in your home and fill it with <b>DK findout!</b> books for your child, to enjoy over and over again. Here is a quick guide to getting the most from this app.</p> \r\n\r\n<p>After the welcome screen, you will be asked to create a parentâ€™s PIN. This ensures your child cannot make purchases without your permission. Weâ€™ll ask for your e-mail address so if you forget your PIN we can send you a reminder.</p> \r\n\r\n<p>The next step is creating a bookshelf for your child. Weâ€™ll ask for each childâ€™s name. Get access to books directly from this bookshelf. Tap the â€œAdd Bookâ€ button and choose either the Bookstore, or from titles your family has already purchased.</p> \r\n\r\n<p>The <b>DK findout!</b> Bookstore contains a library of e-books from the <b>DK findout!</b> series to browse and buy. You can tap on a title to bring up a short summary about the e-book, and download a sample to browse for free. If you decide to purchase the e-book, you will be asked for your PIN to proceed. It''s that simple.</p>\r\n\r\n<p>Now it''s over to your child. In the Bookstore, your child can browse through the e-books with you and add titles to a wish list. When opening his or her bookshelf, your child can choose from a series of pictures to personalize the shelf.</p> \r\n\r\n<p>Get reading! Tap a book to open it. Mini-pages at the bottom of the screen show where your child is in the e-book. Finished? Click a button and your child is asked to let you know she or he has finished reading the book.</p> \r\n\r\n<p>Parents can access a page to see what their child has been reading, review purchases, reset PIN, and restore any purchases that may no longer be viewed. The <b>DK findout!</b> app is easy to use, and an easy way for your child to find out amazing facts on a range of topics.</p>    \r\n                                                                                                                                                     \r\n<p>At any time, clicking on the <b>DK findout!</b> logo will take you or your child to www.dkfindout.com, the only free encyclopedia a child will ever need. This is a safe, secure, and reliable site for your child to find out more information. Adult authorization is requested for leaving the app and entering the website.</p>\r\n\r\n<p>For questions or queries please contact customerservices@dk.com</p>', 1, 'LIVE', '2013-12-06 19:12:29', '2016-07-13 14:11:47'),
(15, '29713E95FEC0E268D0BC3FAC4D35037F', 'About DK findout!', 'LIVE', 2, 2, 'About DK findout!', 'about_dk_findout_2.jpg', 2, '<p>Fun and factual, <b>DK findout!</b> is the innovative new childrenâ€™s reference series, packed with up-to-date information, surprising facts, fun quizzes, timelines, and interviews. Stunning photography brings each topic alive to inspire learning and help with school projects, too. The <b>DK findout!</b> series will satisfy any child who is eager to learn and acquire facts, and keep them coming back for more!</p>\r\n\r\nDK findout! is not just books. It''s a free, safe, secure, and reliable website that allows your child to search, learn, and explore information. Perfect for help with homework, DK''s clear, up-to-date, and highly visual content covers all curriculum subjects and more. There are quizzes, videos, and animations, and new content is being added all the time to engage and fascinate your child. The site encourages eager learners and develops your child''s research skills. There are also articles for parents offering ideas about how you can help your child, and quick links to other DK products that will support your child''s learning. ', 1, 'LIVE', '2013-12-06 19:13:50', '2016-06-30 14:26:56'),
(19, '36BEE5A21789DE41B13BF27FDCDAF0DA', 'Featured DK findout! books', 'LIVE', 3, 1, 'Featured DK findout! books', 'featured_dk_findout_books_2.jpg', 2, '<p>Each year the <b>DK findout!</b> series will grow with books on children''s favorite topics, such as Animals, Dinosaurs, Space, Science, and History. We''ll highlight the new titles in a banner so they are easy to find.</p>', 1, 'LIVE', '2013-12-06 19:17:55', '2016-06-30 14:27:29'),
(20, '2AE496930839105D93981B310BB5E51C', 'Free DK findout! sample', 'LIVE', 4, 2, 'Free DK findout! sample', 'free_dk_findout_sample_2.jpg', 2, '<p>To help you build your child''s <b>DK findout!</b> Bookshelf, we are delighted to offer a sample for you to download free. This includes a selection of pages from each of the first six titles in the series. We hope your child enjoys reading them, and that they encourage him or her to want to find out more.</p>', 1, 'LIVE', '2013-12-06 19:19:01', '2016-06-30 14:28:50'),
(21, '249F2F8CDED3DD02E890E34EAEB11565', 'About DK', 'LIVE', 5, 3, 'About DK', 'about_dk_2.jpg', 2, '<p>Established in 1974, DK creates best-selling, award-winning, and visually stunning information for adults and children. From travel guides and activity books, to food, history, gardening, and much more, DK makes ideas come to life. Visit www.dk.com to find out more.</p> \r\n\r\n<p>DK has established a worldwide reputation for its innovative nonfiction books in which the unrivaled clarity of the words and pictures come together to spectacular effect. DK content in all its forms is characterized by quality, expertise, and accessibility. DK is a brand that inspires trust, and we pride ourselves in creating visual information with international appeal, working with companies worldwide who share our values and ethos.</p>\r\n\r\n<p>Our adult range spans from travel, including the award-winning Eyewitness Travel Guides, to history, science, nature, sports, gardening, cooking, and parenting. We also publish an extensive children''s catalog that showcases a fantastic store of knowledge for children, toddlers, and babies. Covering topics from history and the human body to animals and activities, DK children''s books combine outstanding information with magical illustration and design.</p>\r\n\r\n<p>We work closely with authors who are experts in their field, with authoritative institutions like the Royal Horticultural Society and the Smithsonian, as well as with well-known brands such as Star Wars and the LEGO Group, to produce world-class books and products.</p> \r\n\r\n<p>DK has offices in Delhi, London, Melbourne, Munich, New York, and Toronto.</p>', 1, 'LIVE', '2013-12-06 19:20:01', '2016-06-30 14:29:43');

-- --------------------------------------------------------

--
-- Table structure for table `promotions`
--

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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=38 ;

--
-- Dumping data for table `promotions`
--

INSERT INTO `promotions` (`promo_auto_id`, `promo_region_id`, `promo_title`, `promo_image`, `promo_image_lrg`, `promo_type`, `promo_book_ids`, `promo_startdate`, `promo_enddate`, `promo_status`, `promo_dateadded`, `promo_datemodified`, `promo_order`) VALUES
(22, 1, 'New DK findout! books', 'new_dk_findout_books_1.png', '6_books_promo_tile_lrg_2.png', 1, '191,188,189,190,192,193', '2016-06-13', '2019-06-27', 'LIVE', '2016-06-13 16:08:24', '2016-07-13 12:13:41', 8),
(23, 1, 'Ancient Rome Promo Tile', 'ancient_rome_promo_tile_3.png', 'ancient_rome_promo_tile_lrg_2.png', 0, '190', '2016-06-13', '2019-06-27', 'LIVE', '2016-06-13 16:09:39', '2016-06-20 15:34:28', 7),
(24, 1, 'Animals Promo Tile', 'animals_promo_tile_2.png', 'animals_promo_tile_lrg_1.png', 0, '188', '2016-06-13', '2019-06-27', 'LIVE', '2016-06-13 16:10:36', '2016-06-20 15:34:18', 6),
(25, 1, 'Dinosaur Promo Tile', 'dinosaur_promo_tile_2.png', 'dinosaur_promo_tile_lrg_1.png', 0, '191', '2016-06-13', '2019-06-27', 'LIVE', '2016-06-13 16:11:18', '2016-06-20 15:34:10', 5),
(26, 1, 'Science Promo Tile', 'science_promo_tile_2.png', 'science_promo_tile_lrg_1.png', 0, '192', '2016-06-13', '2019-06-27', 'LIVE', '2016-06-13 16:13:04', '2016-06-20 15:33:58', 4),
(27, 1, 'Solar System Promo', 'solar_system_promo_2.png', 'solar_system_promo_lrg_1.png', 0, '193', '2016-06-13', '2019-06-27', 'LIVE', '2016-06-13 16:13:45', '2016-06-27 11:08:04', 3),
(28, 1, 'Volcano Promo Tile', 'volcano_promo_tile_2.png', 'volcano_promo_tile_lrg_1.png', 0, '189', '2016-06-13', '2019-06-27', 'LIVE', '2016-06-13 16:14:29', '2016-06-27 11:07:54', 2),
(29, 1, 'Website Promo', 'website_promo_2.png', 'website_promo_lrg_1.png', 0, '188', '2016-06-13', '2019-06-27', 'LIVE', '2016-06-13 16:15:16', '2016-06-27 11:07:49', 1),
(30, 2, 'Website Promo', 'website_promo_3.png', 'website_promo_lrg_2.png', 0, '197', '2016-07-13', '2020-07-27', 'LIVE', '2016-07-13 14:27:11', '2016-08-03 15:07:52', 1),
(31, 2, 'Volcano Promo Tile', 'volcano_promo_tile_3.png', 'volcano_promo_tile_lrg_3.png', 0, '203', '2016-08-01', '2020-08-15', 'LIVE', '2016-08-01 16:46:27', '2016-08-03 15:11:27', 8),
(32, 2, 'Science Promo Tile', 'science_promo_tile_3.png', 'science_promo_tile_lrg_3.png', 0, '201', '2016-08-01', '2020-08-15', 'LIVE', '2016-08-01 16:58:39', '2016-08-03 15:11:12', 7),
(33, 2, 'Solar System promo', 'solar_system_promo_3.png', 'solar_system_promo_lrg_3.png', 0, '202', '2016-08-01', '2020-08-15', 'LIVE', '2016-08-01 16:59:39', '2016-08-03 15:10:53', 6),
(34, 2, 'Dinosaur Promo Tile', 'dinosaur_promo_tile_3.png', 'dinosaur_promo_tile_lrg_3.png', 0, '199', '2016-08-01', '2020-08-15', 'LIVE', '2016-08-01 17:00:29', '2016-08-03 15:10:29', 5),
(35, 2, 'Animals Promo tile', 'animals_promo_tile_3.png', 'animals_promo_tile_lrg_3.png', 0, '198', '2016-08-01', '2020-08-15', 'LIVE', '2016-08-01 17:01:16', '2016-08-03 15:09:52', 4),
(36, 2, 'Ancient Rome Promo Tile', 'ancient_rome_promo_tile_4.png', 'ancient_rome_promo_tile_lrg_5.png', 0, '197', '2016-08-01', '2020-08-15', 'LIVE', '2016-08-01 17:02:01', '2016-08-03 15:09:22', 3),
(37, 2, 'New DK findout! books', 'new_dk_findout_books_2.png', 'new_dk_findout_books_lrg_1.png', 1, '197,202,203,199,201,198', '2016-08-01', '2020-08-15', 'LIVE', '2016-08-01 17:03:32', '2016-08-03 15:08:13', 2);

-- --------------------------------------------------------

--
-- Table structure for table `readerlevel`
--

CREATE TABLE IF NOT EXISTS `readerlevel` (
  `readerlevel_auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `readerlevel_name` varchar(100) DEFAULT NULL,
  `readerlevel_level` tinyint(2) DEFAULT NULL,
  PRIMARY KEY (`readerlevel_auto_id`),
  UNIQUE KEY `auto_id` (`readerlevel_auto_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=19 ;

--
-- Dumping data for table `readerlevel`
--

INSERT INTO `readerlevel` (`readerlevel_auto_id`, `readerlevel_name`, `readerlevel_level`) VALUES
(1, 'Sample', 1),
(2, 'History', 2),
(3, 'Animals', 3),
(4, 'Dinosaurs and Prehistoric Life', 4),
(5, 'Science', 5),
(6, 'Earth', 6),
(7, 'Space', 7),
(8, 'Nature', 8),
(9, 'Computer coding', 9),
(13, 'English', 11),
(12, 'Human Body', 10),
(14, 'Maths', 12),
(15, 'Music, Art, and Literature', 13),
(16, 'Sports', 14),
(17, 'Transport', 15),
(18, 'Festivals', 16);

-- --------------------------------------------------------

--
-- Table structure for table `regions`
--

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

CREATE TABLE IF NOT EXISTS `topics` (
  `topic_auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_name` varchar(100) DEFAULT NULL,
  `topic_used_count` int(11) DEFAULT '0',
  PRIMARY KEY (`topic_auto_id`),
  UNIQUE KEY `auto_id` (`topic_auto_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=212 ;

--
-- Dumping data for table `topics`
--

INSERT INTO `topics` (`topic_auto_id`, `topic_name`, `topic_used_count`) VALUES
(55, '|Science|', 1),
(56, '|Technology|', NULL),
(57, '|Animals|', 1),
(58, '|Birds|', 1),
(59, '|Mammals|', 1),
(60, '|Geology|', NULL),
(61, '|Adaptation|', 1),
(62, '|Amphibians|', 1),
(63, '|Animal homes|', 1),
(64, '|Arachnids|', 1),
(65, '|Camouflage|', 1),
(66, '|Carnivores|', 1),
(67, '|Conservation|', 1),
(68, '|Coral reefs|', 1),
(69, '|Defences|', 1),
(70, '|Fish|', 1),
(71, '|Food|', 1),
(72, '|Forests|', 1),
(73, '|Habitats|', 1),
(74, '|Herbivores|', 1),
(75, '|Insects|', 1),
(76, '|Invertebrates|', 1),
(77, '|Life cycles|', 1),
(78, '|Nests|', 1),
(79, '|Omnivores|', 1),
(80, '|Caves|', 1),
(81, '|Dinosaurs|', 1),
(82, '|Earth|', 1),
(83, '|Earthquakes|', 1),
(84, '|Gases|', 1),
(85, '|Gods and goddesses|', 1),
(86, '|Hazards|', 1),
(87, '|Islands|', 1),
(88, '|Jupiter|', 1),
(89, '|Mars|', 1),
(90, '|Neptune|', 1),
(91, '|Rocks|', 1),
(92, '|Saturn|', 1),
(93, '|Space|', 1),
(94, '|Volcanoes|', 1),
(95, '|Water|', 1),
(96, '|Ancient Greeks|', 1),
(97, '|Archaeology|', 1),
(98, '|Bridges|', 1),
(99, '|Buildings|', 1),
(100, '|Calendar|', 1),
(101, '|Children|', 1),
(102, '|Clothes|', 1),
(103, '|Colour|', 1),
(104, '|Education|', 1),
(105, '|Family life|', 1),
(106, '|Farmers|', 1),
(107, '|Gladiators|', 1),
(108, '|Jewellery|', 1),
(109, '|Language|', 1),
(110, '|Medicine|', 1),
(111, '|Numbers|', 1),
(112, '|Roads|', 1),
(113, '|Roman empero', 1),
(114, '|Cretaceous period|', 1),
(115, '|Fossils|', 1),
(116, '|Jurassic period|', 1),
(117, '|Meteorites|', 1),
(118, '|Paleontologists|', 1),
(119, '|Plants|', 1),
(120, '|Reptiles|', 1),
(121, '|Scientists|', 1),
(122, '|Comets|', 1),
(123, '|Deserts|', 1),
(124, '|Digestion system|', 1),
(125, '|Electricity|', 1),
(126, '|Energy|', 1),
(127, '|Evolution|', 1),
(128, '|Flowers|', 1),
(129, '|Forces|', 1),
(130, '|Friction|', 1),
(131, '|Fruit|', 1),
(132, '|Fungus|', 1),
(133, '|Gears|', 1),
(134, '|Gravity|', 1),
(135, '|Heart|', 1),
(136, '|Heat|', 1),
(137, '|Human body|', 1),
(138, '|Invention', 1),
(139, '|Asteroids|', 1),
(140, '|Astronauts|', 1),
(141, '|Exoplanets|', 1),
(142, '|Galaxies|', 1),
(143, '|Mercury|', 1),
(144, '|Moon|', 1),
(145, '|Planets|', 1),
(146, '|Solar system|', 1),
(147, '|Space race|', 1),
(148, '|Space Shuttle|', 1),
(149, '|space station|', 1),
(150, '|stars|', 1),
(151, '|Sun|', 1),
(152, '|Color|', 1),
(153, '|Jewelry|', 1),
(154, '|Roman emperors|', 1),
(155, '|Defenses|', 1),
(156, '|Inventions', 1),
(157, '|Africa|', 1),
(158, '|Arctic|', 1),
(159, '|Australia|', 1),
(160, '|Art|', 1),
(161, '|Beliefs|', 1),
(162, '|Boats|', 1),
(163, '|Bronze Age|', 1),
(164, '|Carvings|', 1),
(165, '|Cooking|', 1),
(166, '|Crafts|', 1),
(167, '|Crops|', 1),
(168, '|Europe|', 1),
(169, '|Fire|', 1),
(170, '|Homo sapiens|', 1),
(171, '|Hunter-ga', 1),
(172, '|Birth|', 1),
(173, '|Diet|', 1),
(174, '|Ecosystem|', 1),
(175, '|Extinction|', 1),
(176, '|Fins|', 1),
(177, '|Hunting|', 1),
(178, '|Living things|', 1),
(179, '|Migration|', 1),
(180, '|Movement|', 1),
(181, '|Muscles|', 1),
(182, '|Parasites|', 1),
(183, '|Plankton|', 1),
(184, '|Pollution|', 1),
(185, '|Predators|', 1),
(186, '|Rays|', 1),
(187, '|Senses|', 1),
(188, '|Sharks|', 1),
(189, '|Sk', 1),
(190, '|Afterlife|', 1),
(191, '|Architects|', 1),
(192, '|Ancient Egyptians|', 1),
(193, '|Empire|', 1),
(194, '|Excavations|', 1),
(195, '|Festivals|', 1),
(196, '|Hieroglyphs|', 1),
(197, '|H', 1),
(198, '|Flags|', 1),
(199, '|Kings and Queens|', 1),
(200, '|Maps|', 1),
(201, '|Music|', 1),
(202, '|North America|', 1),
(203, '|Oceans and Seas|', 1),
(204, '|Pirates|', 1),
(205, '|Punishments|', 1),
(206, '|Roman Empire|', 1),
(207, '|Shipwrecks|', 1),
(208, '|Trade|', 1),
(209, '|Treasure|', 1),
(210, '|Weapons|', 1),
(211, '|World ', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

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
(1, 'dkfoadmin', 'EF651CC4B8C8A018A3B78A7B96751999', 0),
(2, 'dkfoadmingb', 'EF651CC4B8C8A018A3B78A7B96751999', 1),
(3, 'dkfoadminus', 'EF651CC4B8C8A018A3B78A7B96751999', 2);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
