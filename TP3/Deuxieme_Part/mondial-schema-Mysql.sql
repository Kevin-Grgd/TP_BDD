
CREATE TABLE country
(Name VARCHAR(32) NOT NULL UNIQUE,
 Code VARCHAR(4) PRIMARY KEY,
 Capital VARCHAR(35),
 Province VARCHAR(32),
 Area INTEGER,
 Population INTEGER );

CREATE TABLE city
(Name VARCHAR(35),
 Country VARCHAR(4),
 Province VARCHAR(32),
 Population INTEGER, 
 Longitude INTEGER, 
 Latitude INTEGER, 
 CONSTRAINT CityKey PRIMARY KEY (Name, Country, Province));

CREATE TABLE province
(Name VARCHAR(32) NOT NULL ,
 Country  VARCHAR(4) NOT NULL ,
 Population INTEGER, 
 Area INTEGER, 
 Capital VARCHAR(35),
 CapProv VARCHAR(32),
 CONSTRAINT PrKey PRIMARY KEY (Name, Country));

CREATE TABLE economy
(Country VARCHAR(4) PRIMARY KEY,
 GDP INTEGER,
 Agriculture INTEGER,
 Service INTEGER,
 Industry INTEGER,
 Inflation INTEGER);

CREATE TABLE population
(Country VARCHAR(4) PRIMARY KEY,
 Population_Growth INTEGER,
 Infant_Mortality INTEGER);

CREATE TABLE politics
(Country VARCHAR(4) PRIMARY KEY,
 Independence DATE,
 Government VARCHAR(120));

CREATE TABLE language
(Country VARCHAR(4),
 Name VARCHAR(50),
 Percentage INTEGER,
 CONSTRAINT LanguageKey PRIMARY KEY (Name, Country));

CREATE TABLE religion
(Country VARCHAR(4),
 Name VARCHAR(50),
 Percentage INTEGER, 
 CONSTRAINT ReligionKey PRIMARY KEY (Name, Country));

CREATE TABLE ethnic_group
(Country VARCHAR(4),
 Name VARCHAR(50),
 Percentage INTEGER, 
 CONSTRAINT EthnicKey PRIMARY KEY (Name, Country));

CREATE TABLE continent
(Name VARCHAR(20) PRIMARY KEY,
 Area INTEGER(10));

CREATE TABLE borders
(Country1 VARCHAR(4),
 Country2 VARCHAR(4),
 Length INTEGER ,
 CONSTRAINT BorderKey PRIMARY KEY (Country1,Country2) );

CREATE TABLE encompasses
(Country VARCHAR(4) NOT NULL,
 Continent VARCHAR(20) NOT NULL,
 Percentage INTEGER,
 CONSTRAINT EncompassesKey PRIMARY KEY (Country,Continent));

CREATE TABLE organization
(Abbreviation VARCHAR(12) PRIMARY KEY,
 Name VARCHAR(80) NOT NULL,
 City VARCHAR(35) ,
 Country VARCHAR(4) , 
 Province VARCHAR(32) ,
 Established DATE
 );

CREATE TABLE is_member
(Country VARCHAR(4),
 Organization VARCHAR(12),
 Type VARCHAR(30) DEFAULT 'member',
 CONSTRAINT MemberKey PRIMARY KEY (Country,Organization) );

CREATE TABLE mountain
(Name VARCHAR(20) PRIMARY KEY,
 Height INTEGER,
 Longitude INTEGER,
 Latitude INTEGER );

CREATE TABLE desert
(Name VARCHAR(25) PRIMARY KEY,
 Area INTEGER);

CREATE TABLE island
(Name VARCHAR(25) PRIMARY KEY,
 Islands VARCHAR(25),
 Area INTEGER,
 Longitude INTEGER,
 Latitude INTEGER );

CREATE TABLE lake
(Name VARCHAR(25) PRIMARY KEY,
 Area INTEGER );

CREATE TABLE sea
(Name VARCHAR(25) PRIMARY KEY,
 Depth INTEGER );

CREATE TABLE river
(Name VARCHAR(20) PRIMARY KEY,
 River VARCHAR(20),
 Lake VARCHAR(20),
 Sea VARCHAR(25),
 Length INTEGER); 

CREATE TABLE geo_mountain
(Mountain VARCHAR(20) ,
 Country VARCHAR(4) ,
 Province VARCHAR(32) ,
 CONSTRAINT GMountainKey PRIMARY KEY (Province,Country,Mountain) );

CREATE TABLE geo_desert
(Desert VARCHAR(25) ,
 Country VARCHAR(4) ,
 Province VARCHAR(32) ,
 CONSTRAINT GDesertKey PRIMARY KEY (Province, Country, Desert) );

CREATE TABLE geo_island
(Island VARCHAR(25) , 
 Country VARCHAR(4) ,
 Province VARCHAR(32) ,
 CONSTRAINT GIslandKey PRIMARY KEY (Province, Country, Island) );

CREATE TABLE geo_river
(River VARCHAR(20) , 
 Country VARCHAR(4) ,
 Province VARCHAR(32) ,
 CONSTRAINT GRiverKey PRIMARY KEY (Province ,Country, River) );

CREATE TABLE geo_sea
(Sea VARCHAR(25) ,
 Country VARCHAR(4)  ,
 Province VARCHAR(32) ,
 CONSTRAINT GSeaKey PRIMARY KEY (Province, Country, Sea) );

CREATE TABLE geo_lake
(Lake VARCHAR(25) ,
 Country VARCHAR(4) ,
 Province VARCHAR(32) ,
 CONSTRAINT GLakeKey PRIMARY KEY (Province, Country, Lake) );

CREATE TABLE merges_with
(Sea1 VARCHAR(25) ,
 Sea2 VARCHAR(25) ,
 CONSTRAINT MergesWithKey PRIMARY KEY (Sea1,Sea2) );

CREATE TABLE located
(City VARCHAR(35) ,
 Province VARCHAR(32) ,
 Country VARCHAR(4) ,
 River VARCHAR(20),
 Lake VARCHAR(25),
 Sea VARCHAR(25));
