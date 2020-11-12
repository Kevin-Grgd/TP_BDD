delimiter |

/*Q1*/
DROP PROCEDURE IF EXISTS `P1`|

CREATE PROCEDURE P1 (IN p INT, IN n INT)

BEGIN
DECLARE i INT DEFAULT 0;
WHILE i < n DO
      SET p = p + i;
      SET i = i + 1;
END WHILE;
SELECT p;
END |


CALL P1 (5, 10)|

/*Q2*/
DROP PROCEDURE IF EXISTS `P2`|

CREATE PROCEDURE P2 (IN n INT, IN p INT, OUT q INT)

BEGIN
SET q = n * p;
END |


DROP PROCEDURE IF EXISTS `P3`|

CREATE PROCEDURE P3 (IN n INT, IN p INT)

BEGIN
CALL P2 (n,p,@out);
SELECT @out AS q;
END|

CALL P3 (9,9)|

/*Q4*/
DROP FUNCTION IF EXISTS `F1`|

CREATE FUNCTION F1 (n INT, p INT)
RETURNS INT;

DECLARE resultat INT;
BEGIN
SET resultat = n * p;
RETURN resultat;
END|

DROP PROCEDURE IF EXISTS `P4`|

CREATE PROCEDURE P4(IN n INT, IN p INT)

BEGIN
CALL F1 (n,p);
END|

delimiter ;
