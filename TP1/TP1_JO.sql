SET FOREIGN_KEY_CHECKS = 1;

drop TABLE jeux;
drop TABLE nation;
drop TABLE athlete;
drop TABLE sport;
drop TABLE epreuve;
drop TABLE participe;
drop TABLE resultat;


CREATE TABLE jeux
       ( numjeux	INT
       , pays		VARCHAR(40)
       , ville		VARCHAR(40)
       , type		ENUM('E','H')
       , annee		INT
       , PRIMARY KEY(numjeux)
       ) ENGINE = InnoDB;



CREATE TABLE nation
	( numnation	INT 	
	, nom		VARCHAR(40)
	, continent	ENUM('Asie','Amerique','Afrique','Europe','Océanie')
	, PRIMARY KEY(numnation)
	) ENGINE = InnoDB;

CREATE TABLE athlete
	( numathlete	INT 	
	, nom		VARCHAR(40)
	, numnation	INT REFERENCES nation(numnation)
	, PRIMARY KEY(numathlete)
	) ENGINE = InnoDB;
	
CREATE TABLE sport
	( numsport	INT		
	, nom		VARCHAR(40)
	, PRIMARY KEY(numsport)
	) ENGINE = InnoDB;

CREATE TABLE epreuve
	( numepreuve	INT		
	, libelle	VARCHAR(40)
	, genre		ENUM('M','F')	
	, typeclass	ENUM('I','E')	
	, numsport	INT REFERENCES sport(numsport)
 	, PRIMARY KEY(numepreuve)
	) ENGINE = InnoDB;
	
CREATE TABLE participe
	( numjeux	INT REFERENCES jeux(numjeux)  	
	, numnation	INT REFERENCES nation(numnation)
	, PRIMARY KEY(numjeux,numnation)
	) ENGINE = InnoDB;

CREATE TABLE resultat
	( numjeux	INT REFERENCES jeux(numjeux)	
	, numepreuve	INT REFERENCES epreuve(numepreuve)		
	, numathlete	INT REFERENCES athlete(numathlete)
	, medaille	ENUM('O','A','B')
	, PRIMARY KEY(numjeux,numepreuve,numathlete) 
	) ENGINE = InnoDB;



	
-- Création du jeu de données

-- E veut signifier Eté; H: Hiver

INSERT INTO jeux VALUES (1, 'France', 'Lyon', 'E', 2016);
INSERT INTO jeux VALUES (2, 'Japon', 'Tokyo', 'E', 1964);
INSERT INTO jeux VALUES (3, 'Australie', 'Sidney', 'E', 2004);
INSERT INTO jeux VALUES (4, 'Japon', 'Nagano', 'H', 1998);
INSERT INTO jeux VALUES (5, 'France', 'Alberville', 'H', 1990);


INSERT INTO nation VALUES (1, 'Ethiopie', 'Afrique');
INSERT INTO nation VALUES (2, 'France', 'Europe');
INSERT INTO nation VALUES (3, 'USA', 'Amerique');
INSERT INTO nation VALUES (4, 'Italie', 'Europe');
INSERT INTO nation VALUES (5, 'Maroc', 'Afrique');

INSERT INTO athlete VALUES (1, 'Carl Lewis', 3);
INSERT INTO athlete VALUES (2, 'Laure Manaudou', 2);
INSERT INTO athlete VALUES (3, 'Marie Pierce', 2);
INSERT INTO athlete VALUES (4, 'Ali Zanou', 5);
INSERT INTO athlete VALUES (5, 'Lea Cassoli', 4);
INSERT INTO athlete VALUES (6, 'John Smith', 3);
INSERT INTO athlete VALUES (7, 'Moussad Marah', 1);
INSERT INTO athlete VALUES (8, 'David Douillet', 2);
INSERT INTO athlete VALUES (9, 'Thierry Lhermite', 2);
INSERT INTO athlete VALUES (10, 'Lukas Zala', 1);

INSERT INTO sport VALUES (1, 'Judo');
INSERT INTO sport VALUES (2, 'Athletisme');
INSERT INTO sport VALUES (3, 'Tennis');
INSERT INTO sport VALUES (4, 'Velo');

-- M= Masculin; F=Feminin
-- I= individuel, E=Equipe
	
INSERT INTO epreuve VALUES (1, '-52kg', 'M', 'I', 1);
INSERT INTO epreuve VALUES (2, '+52kg', 'F', 'E', 1);
INSERT INTO epreuve VALUES (3, '100m', 'M', 'I', 2);
INSERT INTO epreuve VALUES (4, '200m', 'M', 'I', 2);
INSERT INTO epreuve VALUES (5, 'simple', 'M', 'I', 3);
INSERT INTO epreuve VALUES (6, 'double', 'M', 'E', 3);
INSERT INTO epreuve VALUES (7, 'vitesse', 'M', 'E', 4);
INSERT INTO epreuve VALUES (8, 'sprint', 'M', 'E', 4);

INSERT INTO participe VALUES (1, 1);
INSERT INTO participe VALUES (1, 2);
INSERT INTO participe VALUES (2, 1);
INSERT INTO participe VALUES (2, 3);
INSERT INTO participe VALUES (3, 1);
INSERT INTO participe VALUES (3, 4);
INSERT INTO participe VALUES (4, 2);
INSERT INTO participe VALUES (4, 5);
INSERT INTO participe VALUES (5, 2);
INSERT INTO participe VALUES (5, 4);


-- O=Or; A=Argent; B=Bronze

INSERT INTO resultat VALUES (2, 1, 8, 'A');
INSERT INTO resultat VALUES (2, 1, 2, 'A');
INSERT INTO resultat VALUES (2, 2, 8, 'B');
INSERT INTO resultat VALUES (2, 2, 2, 'B');
INSERT INTO resultat VALUES (1, 3, 1, 'O');
INSERT INTO resultat VALUES (3, 4, 1, 'A');
INSERT INTO resultat VALUES (5, 3, 1, 'B');
INSERT INTO resultat VALUES (2, 5, 7, 'O');
INSERT INTO resultat VALUES (3, 5, 7, 'O');
INSERT INTO resultat VALUES (4, 3, 7, 'O');
INSERT INTO resultat VALUES (1, 6, 8, 'O');
INSERT INTO resultat VALUES (2, 7, 9, 'O');
INSERT INTO resultat VALUES (3, 8, 9, 'O');
INSERT INTO resultat VALUES (3, 6, 9, 'O');



-- QUESTION 4.A --

INSERT INTO epreuve VALUES (4, 'Pool Party', 'F', 'E', 2); -- Erreur : Doublons
INSERT INTO participe VALUES (3, 4); -- Erreur : Doublons



-- QUESTION 5 --
UPDATE resultat
SET  medaille = 'O'
WHERE numathlete IN (SELECT numathlete
      		     FROM athlete
		     WHERE nom = 'David Douillet');

SELECT *
FROM resultat
WHERE numathlete IN (SELECT numathlete
      		     FROM athlete
		     WHERE nom = 'David Douillet');


-- QUESTION 6.A --
SELECT nom,medaille
FROM resultat,athlete
WHERE numjeux IN (SELECT numjeux
      	      	  FROM jeux
		  WHERE annee = 1964
		  AND type = 'E'
		  AND ville = 'Tokyo')
AND numepreuve IN (SELECT numepreuve
    	       	   FROM epreuve
		   WHERE numsport IN (SELECT numsport
		   	 	      FROM sport
				      WHERE nom = 'Tennis'))
AND resultat.numathlete = athlete.numathlete;
				      


-- QUESTION 6.B --
SELECT pays,ville,annee,libelle,medaille
FROM resultat,jeux,epreuve
WHERE numathlete IN (SELECT numathlete
      		     FROM athlete
		     WHERE nom = 'Carl Lewis')
AND epreuve.numepreuve = resultat.numepreuve
AND jeux.numjeux = resultat.numjeux;


-- QUESTION 6.C --
SELECT DISTINCT jeux.pays,jeux.annee,athlete.nom
FROM jeux,resultat,athlete
WHERE resultat.numathlete = athlete.numathlete
AND jeux.numjeux = resultat.numjeux
AND athlete.numathlete IN (SELECT numathlete
    		       	   FROM athlete
			   WHERE nom LIKE 'L%'
			   OR nom LIKE 'D%');


-- QUESTION 6.D --
SELECT pays,ville,annee,libelle
FROM jeux,epreuve,resultat,participe,nation,sport
WHERE nation.nom = 'Ethiopie'
AND resultat.medaille = 'O'
AND sport.nom = 'Athletisme'
AND sport.numsport = epreuve.numsport
AND epreuve.numepreuve = resultat.numepreuve
AND nation.numnation = participe.numnation
AND participe.numjeux = resultat.numjeux
AND resultat.numjeux = jeux.numjeux;


-- QUESTION 6.E --
SELECT pays,ville,annee,libelle,medaille
FROM jeux,resultat,epreuve,participe,nation
WHERE epreuve.typeclass = 'E'
AND nation.nom = 'France'
AND nation.numnation = participe.numnation
AND participe.numjeux = resultat.numjeux
AND epreuve.numepreuve = resultat.numepreuve
AND jeux.numjeux = resultat.numjeux;


-- QUESTION 6.F & 6.G --
SELECT continent, COUNT(medaille)
FROM resultat,nation,participe
WHERE resultat.numjeux = participe.numjeux
AND participe.numnation = nation.numnation
GROUP BY continent;
