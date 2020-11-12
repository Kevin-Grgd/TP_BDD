TEE TP4_fichier_sortie;

/**********************
 **     Création     **
 **    des tables    **
 **********************/

DROP TABLE IF EXISTS `User`;
--
-- Création table User
--
-- IP : Chaîne de caractère pour le format suivant : "XXX.XX.XXX.X", Clé primaire de la table
-- name : Chaîne de caractère, nom de l'utilisateur
-- firstname : Chaîne de caractère, prénom de l'utilisateur
--
CREATE TABLE User(
       IP VARCHAR(12) PRIMARY KEY NOT NULL,
       name VARCHAR(20),
       firstname VARCHAR(20)
       );


DROP TABLE IF EXISTS `Query`;
--
-- Création table Query
--
-- ID_Q : Entier, numéro de la recherche, Clé primaire de la table
-- IP : Chaîne de caractère, référence l'IP de l'utilisateur ayant fait la recherche
-- text_Q : Chaîne de caractère, recherche effectuée
--

CREATE TABLE Query(
       ID_Q INTEGER PRIMARY KEY NOT NULL,
       IP VARCHAR(13) REFERENCES User(IP),
       text_Q VARCHAR(255)
       );


DROP TABLE IF EXISTS `Key_word`;
--
-- Création table Key_word
--
-- ID_KW : Entier, Numéro du mot-clé, Clé primaire de la table
-- text : Chaîne de caractère, mot-clé
--
CREATE TABLE Key_word(
       ID_KW INTEGER PRIMARY KEY NOT NULL,
       text VARCHAR(20)
       );


DROP TABLE IF EXISTS `User_KW`;
--
-- Création table User_KW
--
-- IP : Chaîne de caractère, référence l'IP de l'utilisateur, Clé primaire de la table
-- ID_KW : Entier, référence le numéro du mot-clé, Clé primaire de la table
-- weight : Flottant, poids
-- lastUpDate : Date, renseigne la date de la dernière MAJ du poids
--
CREATE TABLE User_KW(
       IP VARCHAR(13) NOT NULL REFERENCES User(IP),
       ID_KW INTEGER  NOT NULL REFERENCES Key_word(ID_KW),
       weight FLOAT,
       lastUpDate DATE,
       PRIMARY KEY (IP,ID_KW)
       );


DROP TABLE IF EXISTS `Connection`;
--
-- Création table Connection
--
-- ID_C : Entier, Numéro de la connection, Clé Primaire
-- IP : Chaîne de caractère, référence l'IP de l'utilisateur qui se connecte
-- date : Date, date de la connection
-- time : Time, heure de la connection
-- duration : Time, durée de la connection
-- browserID : Entier, référence le navigateur web utilisé lors de la connection
--
CREATE TABLE Connection(
      ID_C INTEGER PRIMARY KEY NOT NULL,
      IP VARCHAR(12) REFERENCES User(IP),
      date DATE,
      time TIME,
      duration TIME,
      browserID INTEGER REFERENCES Browser(ID_B)
      );


DROP TABLE IF EXISTS `Browser`;
--
-- Création table Browser
--
-- ID_B : Entier, Numéro du navigateur web, Clé primaire
-- name_B : Chaîne de caractère, Nom du navigateur web
--
CREATE TABLE Browser(
       ID_B INTEGER PRIMARY KEY NOT NULL,
       name_B VARCHAR(50)
       );



/***********************
 **     Insertion     **
 **    des données    **
 ***********************/

--
-- Remplissage table User
INSERT INTO User (IP,name,firstname) VALUES ('000.00.000.0','Pup','Hugo');
INSERT INTO User (IP,name,firstname) VALUES ('000.00.000.1','Gourg','Kevkev');
INSERT INTO User (IP,name,firstname) VALUES ('000.00.000.2','Rousson','Guigui');
INSERT INTO User (IP,name,firstname) VALUES ('000.00.000.3','Momo','Thotho');
INSERT INTO User (IP,name,firstname) VALUES ('000.00.000.4','Besson','Neel');
INSERT INTO User (IP,name,firstname) VALUES ('000.00.000.5','Champ','Sylvie');
INSERT INTO User (IP,name,firstname) VALUES ('000.00.000.6','Lemonier','Gege');
INSERT INTO User (IP,name,firstname) VALUES ('721.12.589.7','Desse','Melinda');
INSERT INTO User (IP,name,firstname) VALUES ('666.66.666.6','Izzou','Fakir');
INSERT INTO User (IP,name,firstname) VALUES ('044.44.044.4','Hamilton','Lewis');
INSERT INTO User (IP,name,firstname) VALUES ('016.16.016.6','Leclerc','Charles');


--
-- Remplissage table Query
INSERT INTO Query (ID_Q,IP,text_Q) VALUES (1,'000.00.000.0','Comment couler une douille');
INSERT INTO Query (ID_Q,IP,text_Q) VALUES (2,'000.00.000.1','Triplet feel Jeff Porcaro');


--
-- Remplissage table Key_word
INSERT INTO Key_word VALUES (1,'Triplet');
INSERT INTO Key_word VALUES (2,'Feel');
INSERT INTO Key_word VALUES (3,'Jeff');
INSERT INTO Key_word VALUES (4,'Porcaro');
INSERT INTO Key_word VALUES (5,'Cours');
INSERT INTO Key_word VALUES (6,'Batterie');
INSERT INTO Key_word VALUES (7,'Leçon');


--
-- Remplissage table User_KW
INSERT INTO User_KW VALUES ('000.00.000.1',1,1,'2019-09-10');
INSERT INTO User_KW VALUES ('000.00.000.0',7,1,'1997-12-27');


--
-- Remplissage table Connection
INSERT INTO Connection VALUES (1,'000.00.000.1','2019-09-10','12:30:42','00:45:02',2);
INSERT INTO Connection VALUES (2,'000.00.000.0','2019-11-10','17:18:18','00:05:15',3);


--
-- Remplissage table Browser
INSERT INTO Browser (ID_B,name_B) VALUES (1,'Firefox');
INSERT INTO Browser (ID_B,name_B) VALUES (2,'Google Chrome');
INSERT INTO Browser (ID_B,name_B) VALUES (3,'Internet Explorer');
INSERT INTO Browser (ID_B,name_B) VALUES (4,'Safari');



/***********************
 **     Affichage     **
 **    des tables     **
 ***********************/
 SELECT * FROM User;
 SELECT * FROM Query;
 SELECT * FROM Key_word;
 SELECT * FROM User_KW;
 SELECT * FROM Connection;
 SELECT * FROM Browser;



 
/**************************
 **       Ecriture       **
 **    des fonctions     **
 **************************/



SELECT '*******////*******FONCTIONS*******////*******';




--
-- Ajout/Modification User
-- Paramètres : IP, Nom, Prenom
-- Ajoute un utilisateur s'il n'existe pas sinon modifie ses valeurs d'après l'IP renseigné
-- Returne 1 si ok sinon 0 (erreur)
-- 
DROP FUNCTION IF EXISTS `Add_Modify_User`;
DELIMITER //

CREATE FUNCTION Add_Modify_User(ip_n VARCHAR(12), nom VARCHAR(20), prenom VARCHAR(20))
RETURNS INT

BEGIN
DECLARE done INT DEFAULT 0;
DECLARE ip_test VARCHAR(12);
DECLARE curseur CURSOR FOR
SELECT IP FROM User;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

OPEN curseur;

WHILE done = 0 DO
FETCH FROM curseur INTO ip_test;
IF ip_n = ip_test
THEN UPDATE User SET name = nom, firstname = prenom WHERE IP = ip_n;
RETURN 1;
END IF;
END WHILE;
CLOSE curseur;
INSERT INTO User(IP,name,firstname) VALUES (ip_n,nom,prenom);
RETURN 1;
END//

DELIMITER ;

SELECT Add_Modify_User('000.00.000.0','Pupino','Hugo');
SELECT * FROM User WHERE firstname = 'Hugo';
SELECT Add_Modify_User('000.00.000.0','Pu','Hugo');
SELECT * FROM User WHERE firstname = 'Hugo';
SELECT Add_Modify_User('000.00.000.0','Pup','Hugo');
SELECT * FROM User;


--
-- Ajout/Modification Key_word
-- Paramètres : Numéro mot-clé, mot-clé
-- Ajoute un mot-clé si inéxistant, sinon modifie ses valeurs en fonction du numéro renseigné
-- Retourne 1 si ok sinon 0 (erreur)
--
DROP FUNCTION IF EXISTS `Add_Modify_Key_word`;
DELIMITER //

CREATE FUNCTION Add_Modify_Key_word(n_idkw INT, n_kw VARCHAR(20))
RETURNS INT

BEGIN
DECLARE done INT DEFAULT 0;
DECLARE idkw_test INT;
DECLARE curseur CURSOR FOR
SELECT ID_KW FROM Key_word;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

OPEN curseur;

WHILE done = 0 DO
FETCH FROM curseur INTO idkw_test;
IF n_idkw = idkw_test
THEN UPDATE Key_word SET text = n_kw WHERE ID_KW = n_idkw;
RETURN 1;
END IF;
END WHILE;
CLOSE curseur;
INSERT INTO Key_word(ID_KW,text) VALUES (n_idkw,n_kw);
RETURN 1;
END//

DELIMITER ;

SELECT Add_Modify_Key_word(8,'Couler');
SELECT Add_Modify_Key_word(9,'Douile');
SELECT * FROM Key_word;


--
-- Ajout dans User_KW
-- Paramètres : IP Utilisateur, Numéro mot-clé
-- Ajoute un tuple dans la table User_KW si inexistant sinon ajout +1 à son poids. Mise à jour de la date
-- Retourne 1 si ok sinon 0
--
DROP FUNCTION IF EXISTS `Add_Modify_UserKW`;
DELIMITER //

CREATE FUNCTION Add_Modify_UserKW(ipu VARCHAR(12),idkw INT)
RETURNS INT

BEGIN
DECLARE done INT DEFAULT 0;
DECLARE ip_test VARCHAR(13);
DECLARE idkw_test INT;
DECLARE curseur CURSOR FOR
SELECT IP,ID_KW FROM User_KW;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

OPEN curseur;

WHILE done = 0 DO
FETCH FROM curseur INTO ip_test,idkw_test;
IF ipu = ip_test AND idkw = idkw_test
THEN UPDATE User_KW SET weight = weight + 1 WHERE ID_KW = idkw;
RETURN 1;
END IF;
END WHILE;
CLOSE curseur;
INSERT INTO User_KW VALUES (ipu,idkw,1,NOW());
RETURN 1;
END//

DELIMITER ;

SELECT Add_Modify_UserKW('000.00.000.1',1);
SELECT Add_Modify_UserKW('000.00.000.0',6);
SELECT Add_Modify_UserKW('000.00.000.1',2);
SELECT Add_Modify_UserKW('000.00.000.1',3);
SELECT Add_Modify_UserKW('000.00.000.1',3);
SELECT * FROM User_KW;



--
-- Maintenance table User_KW
-- Paramètre : Entier X (correspond à un nombre d'années)
-- Vérifie pour chaque tuple de la table User_KW si date est inférieur ou non à X. Si date supérieur à X, poids remis à 0
-- Retourne 1 si ok sinon 0
--
DROP FUNCTION IF EXISTS `Maintenance_User`;
DELIMITER //

CREATE FUNCTION Maintenance_User(X INT)
RETURNS INT

BEGIN
DECLARE done INT DEFAULT 0;
DECLARE date_test DATE;
DECLARE curseur CURSOR FOR
SELECT lastUpDate FROM User_KW;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

OPEN curseur;

WHILE done = 0 DO
FETCH FROM curseur INTO date_test;
IF CAST(YEAR(NOW()) AS SIGNED INTEGER) -CAST(YEAR(date_test) AS SIGNED INTEGER)   >= X
THEN UPDATE User_KW SET weight = 0 WHERE lastUpDate = date_test;
RETURN 1;
END IF;
END WHILE;
CLOSE curseur;
END//

DELIMITER ;

SELECT Maintenance_User(5);
SELECT * FROM User_KW;




--
-- Les Similaires
--
DROP TABLE IF EXISTS `LesSimilaires`;
CREATE TABLE LesSimilaires(
       U VARCHAR(12) PRIMARY KEY REFERENCES User(IP),
       U1 VARCHAR(12) REFERENCES User(IP),
       U2 VARCHAR(12) REFERENCES User(IP),
       U3 VARCHAR(12) REFERENCES User(IP),
       U4 VARCHAR(12) REFERENCES User(IP),
       U5 VARCHAR(12) REFERENCES User(IP)
);

/*
DROP PROCEDURE IF EXISTS `Similarité`;

CREATE PROCEDURE Similarité()
BEGIN
DECLARE done INT DEFAULT 0;
*/

NOTEE;
