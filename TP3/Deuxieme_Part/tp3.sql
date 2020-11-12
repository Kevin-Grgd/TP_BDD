DELIMITER //



/*Question 1*/

DROP FUNCTION IF EXISTS `INSERT_PAYS`//

CREATE FUNCTION INSERT_PAYS (nom VARCHAR(32), abreviation VARCHAR(4), capitale VARCHAR(35), province VARCHAR(32), superficie INT, population INT, independance DATE, regime VARCHAR(120))
RETURNS INT
BEGIN
DECLARE EXIT HANDLER FOR SQLSTATE '23000'

BEGIN
RETURN -1;
END ;


INSERT INTO country(Name,Code,Capital,Province,Area,Population) VALUES (nom,abreviation,capitale,province,superficie,population);
INSERT INTO politics(Country,Independence,Government) VALUES (abreviation,independance,regime);
RETURN 1;
END //

DELIMITER ;

DELETE FROM country WHERE Name = 'Hugoslavia';
DELETE FROM politics WHERE Country = 'HP';
SELECT INSERT_PAYS('Hugoslavia','HP','Issou','Toutencarton',547030,60000000,'1997-12-27','dictature');
SELECT * FROM country WHERE Name = 'Hugoslavia';
SELECT * FROM politics WHERE Country = 'HP';



/*Question 2*/

DROP TABLE IF EXISTS `LISTCAP`;

CREATE TABLE LISTCAP (
Pays VARCHAR(32) PRIMARY KEY,
Capitale VARCHAR (35)
);

DROP PROCEDURE IF EXISTS `PAYS_CAP`;

DELIMITER //

/*Procédure List_cap*/
CREATE PROCEDURE PAYS_CAP (IN code VARCHAR(4), OUT erreur INT)
BEGIN
DECLARE var_pays VARCHAR(32);
DECLARE var_cap VARCHAR(35);
DECLARE EXIT HANDLER FOR SQLSTATE '23000'
BEGIN
SET erreur = -1;
END;
SELECT Name,Capital INTO var_pays, var_cap FROM country WHERE Code = code;
INSERT INTO LISTCAP VALUES(var_pays,var_cap);
SET erreur = 1;
END //

DELIMITER ;

/*Procédure Charge_cap*/
DROP PROCEDURE IF EXISTS `CHARGE_CAP`;

DELIMITER //

CREATE PROCEDURE CHARGE_CAP()
BEGIN
DECLARE boucle INTEGER DEFAULT 0;
DECLARE code_pays VARCHAR(4);
DECLARE erreur INTEGER DEFAULT 1;
DECLARE curseur CURSOR FOR SELECT Code FROM country;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET boucle = 1;
OPEN curseur;
WHILE boucle = 0 DO
FETCH FROM curseur INTO code_pays;
CALL PAYS_CAP(code_pays,erreur);
END WHILE;
CLOSE curseur;
END //


DELIMITER ;


CALL CHARGE_CAP();
SELECT * FROM LISTCAP;


/*Question3*/

ALTER TABLE country DROP COLUMN OldCap;
ALTER TABLE country DROP COLUMN ChangeDate;
ALTER TABLE country ADD COLUMN OldCap VARCHAR(20), ADD COLUMN ChangeDate DATE;

DROP TRIGGER IF EXISTS `changecap`;

DELIMITER //

CREATE TRIGGER changecap BEFORE UPDATE
ON country FOR EACH ROW
BEGIN
IF OLD.Capital <> NEW.Capital
THEN
SET NEW.ChangeDate = NOW();
SET NEW.OldCap = OLD.Capital;
END IF;
END //

DELIMITER ;
SELECT * FROM country WHERE Code = 'HP';
UPDATE country SET Capital = 'MontMartre' WHERE Code = 'HP';
SELECT * FROM country WHERE Code = 'HP';

/*Question 4*/

DROP PROCEDURE IF EXISTS `AJOUT_POPULA`;

DELIMITER //



CREATE PROCEDURE AJOUT_POPULA (IN X INT, IN nom_pays VARCHAR(32))
BEGIN
UPDATE country  SET Population = Population + (Population *X/100) WHERE country.Name = nom_pays;
END //



DELIMITER ;

CALL AJOUT_POPULA(6,'Hugoslavia');
SELECT * FROM country WHERE Code='HP';


/*Question 5*/

DROP PROCEDURE IF EXISTS `SOMME_POP_CONTINENT`;

DELIMITER //


CREATE PROCEDURE SOMME_POP_CONTINENT()
BEGIN
SELECT Continent, SUM(Population) AS Population_continent
FROM country, encompasses
WHERE country.Code = encompasses.Country
GROUP BY Continent;
END //



DELIMITER ;
CALL SOMME_POP_CONTINENT();



/*Question 6*/

/* Non fait */

/*Question 7*/
DROP PROCEDURE IF EXISTS `Long_Frontieres`;

DELIMITER //

CREATE PROCEDURE Long_Frontieres(IN continent VARCHAR(20))
BEGIN
SELECT Continent,country.Name AS Nom_Pays
FROM country,encompasses
WHERE country.Code = encompasses.Country
AND encompasses.Continent = continent;
END//

DELIMITER ;

CALL Long_Frontieres('America');
CALL Long_Frontieres('Europe');
CALL Long_Frontieres('Asia');
