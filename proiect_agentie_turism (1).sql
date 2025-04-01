CREATE DATABASE agentie_turism;
USE agentie_turism;

-- client: id(PK), nume, prenume, email, data_nastere
CREATE TABLE client(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nume VARCHAR(50) NOT NULL,
    prenume VARCHAR(50) NOT NULL,
    email VARCHAR(100) NULL,
    data_nastere DATE NOT NULL
);

-- sejur: id(PK), denumire, tip, data_inceput, data_sfarsit, durata, locatie, pret_persoana, locuri_disponibile
CREATE TABLE sejur(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    denumire VARCHAR(100) NOT NULL,
    tip ENUM('CIRCUIT', 'CITY BREAK', 'SARBATOARE', 'EXCURSIE'),
    data_inceput DATE NOT NULL,
    data_sfarsit DATE NOT NULL,
    durata TINYINT NOT NULL,
    locatie VARCHAR(200) NOT NULL,
    pret_persoana SMALLINT NOT NULL,
    locuri_disponibile TINYINT NOT NULL
);

-- ghid: id(PK), nume, prenume, nivel_experienta, rating
CREATE TABLE ghid(
	id TINYINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nume VARCHAR(50) NOT NULL,
    prenume VARCHAR(50) NOT NULL,
    nivel_experienta ENUM('INCEPATOR', 'MEDIU', 'AVANSAT', 'EXPERT') NOT NULL,
    rating TINYINT NULL
);
-- pachet: id(PK), data_achizitie, masa, transport, nr_persoane, discount, asigurare, pret_final, id_client(FK), id_sejur(FK)
CREATE TABLE pachet(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    data_achizitie DATE NOT NULL,
    masa ENUM('MIC DEJUN', 'DEMIPENSIUNE', 'PENSIUNE COMPLETA', 'ALL INCLUSIVE') NULL,
    transport ENUM('INDIVIDUAL', 'AVION', 'AUTOCAR') NOT NULL,
    nr_persoane TINYINT NOT NULL,
    discount TINYINT,
    asigurare BOOLEAN DEFAULT 0,
    pret_final DECIMAL NULL,
    id_client INT NOT NULL,
    id_sejur INT NOT NULL,
    FOREIGN KEY(id_client) REFERENCES client(id),
    FOREIGN KEY(id_sejur) REFERENCES sejur(id)
);

-- plata: id(PK), tip, avans, finalizata, termen, id_pachet(FK)
CREATE TABLE plata(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    tip ENUM('CASH', 'CARD', 'TRANSFER') NOT NULL,
    avans TINYINT NOT NULL,
    finalizata BOOLEAN NOT NULL,
    termen DATE NULL,
    id_pachet INT NOT NULL,
    FOREIGN KEY(id_pachet) REFERENCES pachet(id)
);

-- adaug id_ghid in sejur si il setez ca FK
ALTER TABLE sejur
ADD COLUMN id_ghid TINYINT NULL;

ALTER TABLE sejur
ADD CONSTRAINT fk_ghid
FOREIGN KEY(id_ghid) REFERENCES ghid(id);

-- ghid: rating ar trebui sa fie decimal
ALTER TABLE ghid MODIFY COLUMN rating DECIMAL(3,2);

-- plata: schimbam numele coloanei termen
ALTER TABLE plata CHANGE termen data_limita DATE;

-- sejur: stergem coloana durata
ALTER TABLE sejur DROP COLUMN durata;

INSERT INTO client (nume,prenume,data_nastere) VALUES ("Estes","Brian","1982-02-04"),("Wilder","Damian","1997-01-20"),("Dudley","Xandra","1992-09-18"),("Rosales","Althea","1994-04-24"),("Wooten","Xandra","1987-07-11"),("Travis","Casey","1987-09-07"),("Black","Alfreda","1997-11-06"),("Mejia","Natalie","1983-07-12"),("Glass","Cooper","1986-06-11"),("Pittman","Ian","1993-01-31"),("Rodriguez","Harriet","1989-01-18"),("Kaufman","Barrett","1992-03-28"),("Brock","Riley","1989-01-08"),("Bullock","Ramona","1982-04-28"),("Spears","Lawrence","1986-03-09");
INSERT INTO ghid (nume,prenume,nivel_experienta,rating) VALUES ("Santana","Silas","INCEPATOR","4.75"),("Brown","Zeus","INCEPATOR","4.89"),("Avery","Riley","INCEPATOR","4.9"),("Dixon","Jared","MEDIU","4.93"),("Bradford","Nasim","MEDIU","4.75"),("Flynn","Victor","MEDIU","4.89"),("Foley","Ira","AVANSAT","4.9"),("Witt","Simon","AVANSAT","4.93"),("Kemp","Cheyenne","AVANSAT","4.75"),("Dean","Camille","EXPERT","4.89"),("Riley","Brady","EXPERT","4.9"),("Weaver","Caesar","EXPERT","4.93");
INSERT INTO sejur(denumire, tip, data_inceput, data_sfarsit, locatie, pret_persoana, locuri_disponibile, id_ghid)
VALUES
('Un Weekend la Roma', 'CITY BREAK', 20210709, 20210712, 'Italia', 350, 50, 1),
('Weekend la Paris', 'CITY BREAK', 20210716, 20210719, 'Franta', 400, 50, 2),
('Praga in Weekend', 'CITY BREAK', 20210702, 20210705, 'Cehia', 300, 60, 3),
('Revelion Tenerife', 'SARBATOARE', 20211229, 20220104, 'Tenerife', 900, 40, 4),
('Revelion Bulgaria', 'SARBATOARE', 20211220, 20220102, 'Bulgaria', 500, 40, 5),
('Paste Bulgaria', 'SARBATOARE', 20220420, 20220426, 'Bulgaria', 450, 30, 6),
('Circuit Vara', 'CIRCUIT', 20210810, 20210824, 'Italia', 1000, 50, 12),
('Circuit Cultural', 'CIRCUIT', 20210710, 20210724, 'Viena-Praga', 900, 50, 12),
('Circuit Insule', 'CIRCUIT', 20210710, 20210720, 'Grecia', 900, 45, 12),
('Circuit Insule', 'CIRCUIT', 20210710, 20210720, 'Grecia', 900, 45, 3),
('Zakynthos', 'EXCURSIE', 20210710, 20210718, 'Grecia', 800, 55, 2),
('Bansko', 'EXCURSIE', 20211210, 20211218, 'Bulgaria', 700, 55, 2),
('Croatia', 'EXCURSIE', 20210910, 20210918, 'Croatia', 700, 55, 3),
('Viena', 'EXCURSIE', 20211203, 20211211, 'Austria', 700, 35, 4),
('Nessebar', 'EXCURSIE', 20210803, 20210811, 'Bulgaria', 500, 40, 4),
('Florenta', 'EXCURSIE', 20210803, 20210811, 'Italia', 700, 35, 4),
('Descopera Milano', 'CITY BREAK', 20210716, 20210719, 'Italia', 400, 45, 2);

INSERT INTO pachet (data_achizitie,masa,transport,nr_persoane,discount,asigurare,id_client,id_sejur) VALUES ("2021-07-01 ","MIC DEJUN","INDIVIDUAL",5,9,"0",1,7),("2021-07-01 ","DEMIPENSIUNE","INDIVIDUAL",5,7,"0",3,5),("2021-06-29 ","PENSIUNE COMPLETA","AVION",1,8,"1",12,13),("2021-06-28 ","ALL INCLUSIVE","AVION",5,7,"1",15,13),("2021-07-08 ","MIC DEJUN","AUTOCAR",2,5,"0",10,5),("2021-07-05 ","DEMIPENSIUNE","AUTOCAR",2,7,"0",6,7),("2021-06-27 ","PENSIUNE COMPLETA","INDIVIDUAL",4,5,"1",9,11),("2021-06-29 ","ALL INCLUSIVE","INDIVIDUAL",3,8,"1",11,3),("2021-06-30 ","MIC DEJUN","AVION",3,7,"0",9,5),("2021-06-30 ","DEMIPENSIUNE","AVION",4,10,"0",9,10);
INSERT INTO pachet (data_achizitie,masa,transport,nr_persoane,discount,asigurare,id_client,id_sejur) VALUES ("2021-07-03 ","PENSIUNE COMPLETA","AUTOCAR",1,10,"1",12,2),("2021-06-28 ","ALL INCLUSIVE","AUTOCAR",3,9,"1",7,12),("2021-06-27 ","MIC DEJUN","INDIVIDUAL",4,7,"0",3,6),("2021-07-01 ","DEMIPENSIUNE","INDIVIDUAL",3,7,"0",9,3),("2021-07-01 ","PENSIUNE COMPLETA","AVION",1,5,"0",3,13),("2021-07-02 ","ALL INCLUSIVE","AVION",3,6,"1",13,6),("2021-07-01 ","MIC DEJUN","AUTOCAR",2,10,"1",2,4),("2021-06-27 ","DEMIPENSIUNE","AUTOCAR",1,6,"1",11,2),("2021-07-07 ","PENSIUNE COMPLETA","INDIVIDUAL",5,8,"1",1,12),("2021-07-06 ","ALL INCLUSIVE","INDIVIDUAL",5,9,"1",8,9);
INSERT INTO pachet (data_achizitie,masa,transport,nr_persoane,discount,asigurare,id_client,id_sejur) VALUES ("2021-07-01 ","MIC DEJUN","AVION",2,10,"0",10,11),("2021-07-07 ","DEMIPENSIUNE","AVION",3,9,"1",8,10),("2021-07-08 ","PENSIUNE COMPLETA","AUTOCAR",2,6,"1",7,2),("2021-06-29 ","ALL INCLUSIVE","AUTOCAR",3,9,"0",14,2),("2021-07-04 ","MIC DEJUN","INDIVIDUAL",5,6,"1",8,5),("2021-07-07 ","DEMIPENSIUNE","INDIVIDUAL",5,8,"0",9,9),("2021-06-29 ","PENSIUNE COMPLETA","AVION",4,9,"1",11,8),("2021-06-28 ","ALL INCLUSIVE","AVION",4,8,"0",2,2),("2021-07-03 ","MIC DEJUN","AUTOCAR",3,7,"1",7,1),("2021-07-06 ","DEMIPENSIUNE","AUTOCAR",5,5,"1",2,13);
INSERT INTO pachet (data_achizitie,masa,transport,nr_persoane,discount,asigurare,id_client,id_sejur) VALUES ("2021-06-27 ","PENSIUNE COMPLETA","INDIVIDUAL",2,7,"0",4,1),("2021-07-08 ","ALL INCLUSIVE","INDIVIDUAL",5,10,"0",6,4),("2021-06-30 ","MIC DEJUN","AVION",3,6,"0",4,10),("2021-07-04 ","DEMIPENSIUNE","AVION",3,10,"1",11,13),("2021-07-05 ","PENSIUNE COMPLETA","AUTOCAR",2,9,"1",5,7),("2021-07-07 ","ALL INCLUSIVE","AUTOCAR",1,10,"1",7,11),("2021-07-04 ","MIC DEJUN","INDIVIDUAL",2,8,"0",8,11),("2021-07-01 ","DEMIPENSIUNE","INDIVIDUAL",2,9,"1",11,4),("2021-06-28 ","PENSIUNE COMPLETA","AVION",5,6,"1",15,9),("2021-06-29 ","ALL INCLUSIVE","AVION",2,8,"1",10,4);
INSERT INTO pachet (data_achizitie,masa,transport,nr_persoane,discount,asigurare,id_client,id_sejur) VALUES ("2021-07-02 ","MIC DEJUN","AUTOCAR",3,6,"1",10,5),("2021-06-28 ","DEMIPENSIUNE","AUTOCAR",3,5,"0",4,8),("2021-07-02 ","PENSIUNE COMPLETA","INDIVIDUAL",5,6,"1",2,11),("2021-06-27 ","ALL INCLUSIVE","INDIVIDUAL",4,5,"0",13,5),("2021-07-06 ","MIC DEJUN","AVION",5,6,"1",14,8),("2021-07-03 ","DEMIPENSIUNE","AVION",1,9,"1",11,8),("2021-07-08 ","PENSIUNE COMPLETA","AUTOCAR",2,8,"1",2,11),("2021-07-02 ","ALL INCLUSIVE","AUTOCAR",3,6,"0",7,5),("2021-07-02 ","MIC DEJUN","INDIVIDUAL",2,5,"0",9,2),("2021-07-05 ","DEMIPENSIUNE","INDIVIDUAL",1,10,"1",15,5);

INSERT INTO plata (tip,avans,finalizata,id_pachet) VALUES ("CASH","50","1",1),("CASH","50","0",2),("CARD","50","1",3),("CARD","75","1",4),("TRANSFER","75","1",5),("TRANSFER","75","1",6),("CASH","100","1",7),("CASH","100","1",8),("CARD","100","1",9),("CARD","50","0",10),("TRANSFER","50","1",11),("TRANSFER","50","0",12),("CASH","75","0",13),("CASH","75","0",14),("CARD","75","1",15),("CARD","100","1",16),("TRANSFER","100","0",17),("TRANSFER","100","0",18),("CASH","50","1",19),("CASH","50","1",20),("CARD","50","1",21),("CARD","75","1",22),("TRANSFER","75","1",23),("TRANSFER","75","0",24),("CASH","100","0",25),("CASH","100","1",26),("CARD","100","0",27),("CARD","50","1",28),("TRANSFER","50","1",29),("TRANSFER","50","1",30),("CASH","75","0",31),("CASH","75","0",32),("CARD","75","1",33),("CARD","100","1",34),("TRANSFER","100","1",35),("TRANSFER","100","1",36),("CASH","50","1",37),("CASH","50","1",38),("CARD","50","1",39),("CARD","75","0",40),("TRANSFER","75","0",41),("TRANSFER","75","0",42),("CASH","100","0",43),("CASH","100","1",44),("CARD","100","1",45),("CARD","50","0",46),("TRANSFER","50","0",47),("TRANSFER","50","1",48),("CASH","75","0",49),("CASH","75","1",50);
UPDATE pachet INNER JOIN sejur ON pachet.id_sejur = sejur.id SET pret_final = pret_persoana*nr_persoane*((100-discount)/100);

UPDATE plata INNER JOIN pachet ON plata.id_pachet = pachet.id INNER JOIN sejur ON pachet.id_sejur = sejur.id SET data_limita = data_inceput - INTERVAL 2 WEEK;

-- completam automat adresele de email
-- prenume_nume1999@gmail.com
UPDATE client SET email = CONCAT(LOWER(prenume), '_', LOWER(nume), YEAR(data_nastere), '@gmail.com');

-- toate sejururile
SELECT * FROM sejur;

-- toate sejururile cu pret per persoana mai mic de 800
SELECT * 
FROM sejur 
WHERE pret_persoana < 700;

-- pachetele cu pret intre 1200 si 3000
SELECT *
FROM pachet
WHERE pret_final >= 1200 AND pret_final <= 3000;

SELECT *
FROM pachet
WHERE pret_final BETWEEN 1200 AND 3000;

-- toate city break-urile ordonate dupa pret
SELECT *
FROM sejur
WHERE tip = 'CITY BREAK'
ORDER BY pret_persoana;

SELECT *
FROM sejur
WHERE tip = 'CITY BREAK'
ORDER BY pret_persoana, denumire;

-- rating min, max, avg pt ghizi
SELECT 
MIN(rating) rating_minim,
MAX(rating) rating_maxim,
AVG(rating) rating_mediu
FROM ghid;

-- numele sejurului si durata lui 
SELECT denumire, datediff(data_sfarsit, data_inceput) durata_zile
FROM sejur
ORDER BY durata_zile;

-- sejururi cu weekend in denumire
SELECT * 
FROM sejur
WHERE denumire LIKE '%Weekend%';

-- cel mai scump sejur/al doilea cel mai scump
SELECT *
FROM sejur
ORDER BY pret_persoana DESC
LIMIT 1;

SELECT *
FROM sejur
ORDER BY pret_persoana DESC
LIMIT 1, 1;
-- numarul de plati finalizate/nefinalizate
SELECT finalizata, COUNT(*) nr_plati
FROM plata
GROUP BY finalizata;

SELECT IF(finalizata = 1, 'plata finalizata', 'plata nefinalizata') finalizata, COUNT(*) nr_plati
FROM plata
GROUP BY finalizata;

-- nr de ghizi, grupati dupa experienta
SELECT nivel_experienta, COUNT(*)
FROM ghid
GROUP BY nivel_experienta;

-- pretul total al pachetelor, grupat dupa transport
SELECT transport, SUM(pret_final)
FROM pachet
GROUP BY transport;

-- numele sejururilor, grupate dupa tip
SELECT tip, GROUP_CONCAT(denumire) lista_sejururi
FROM sejur
GROUP BY tip;

-- numarul sejururilor, grupate dupa tip, doar daca sunt mai mult de 3
SELECT tip, COUNT(*) nr
FROM sejur
GROUP BY tip
HAVING nr > 3;

-- numarul sejururilor, grupate dupa tip, cu pretul mai mare de 400
SELECT tip, COUNT(*)
FROM sejur
WHERE pret_persoana > 400
GROUP BY tip;

-- numarul sejururilor, grupate dupa tip, doar daca sunt mai mult de 2 si anul inceperii este 2021
SELECT tip, COUNT(*) nr
FROM sejur
WHERE YEAR(data_inceput) = 2021
GROUP BY tip
HAVING nr > 2;

-- pretul mediu pentru excursie si circuit, dar numai daca este peste 850
SELECT tip, AVG(pret_persoana) pret_mediu
FROM sejur
WHERE tip IN ('EXCURSIE', 'CIRCUIT')
GROUP BY tip
HAVING pret_mediu > 850;

-- data achizitie pachet, masa, transport si numele sejurului 
SELECT data_achizitie, masa, transport, denumire
FROM pachet JOIN sejur
ON pachet.id_sejur = sejur.id;
-- numele sejurului, data inceput, data sfarsit si numele ghidului
SELECT denumire, data_inceput, data_sfarsit, CONCAT(nume, ' ', prenume) ghid
FROM sejur JOIN ghid
ON sejur.id_ghid = ghid.id;
-- id pachet, data achizitie a pachetului si termenul limita al platii
SELECT pachet.id, data_achizitie, data_limita
FROM pachet, plata
WHERE pachet.id = plata.id_pachet;
-- nume client, nume sejur, masa, transport, pentru pachetele cu cel putin 3 persoane
SELECT CONCAT(nume, ' ', prenume) client, denumire, masa, transport
FROM client JOIN pachet ON client.id = pachet.id_client 
JOIN sejur ON sejur.id = pachet.id_sejur
WHERE nr_persoane >= 3;
-- nume client, nume sejur, nume ghid pentru city breaks
SELECT CONCAT(client.nume, ' ', client.prenume) client, denumire, CONCAT(ghid.nume, ' ', ghid.prenume) ghid
FROM client, sejur, pachet, ghid
WHERE
client.id = pachet.id_client AND
sejur.id = pachet.id_sejur AND
ghid.id = sejur.id_ghid AND 
tip = 'CITY BREAK';
-- nume client, cate pachete a achizitionat
SELECT CONCAT(client.nume, ' ', client.prenume) client, COUNT(*) nr
FROM client, pachet
WHERE client.id = pachet.id_client
GROUP BY client
ORDER BY nr DESC;
-- nume sejur si o lista cu numele clientilor
SELECT denumire, GROUP_CONCAT(CONCAT(client.nume, ' ', client.prenume)) lista_clienti
FROM sejur, client, pachet
WHERE
sejur.id = pachet.id_sejur AND 
client.id = pachet.id_client
GROUP BY denumire; 
-- sejururile de tip city break care au fost achizitionate de cel putin 2 ori
SELECT denumire, COUNT(*) nr
FROM sejur JOIN pachet
ON sejur.id = pachet.id_sejur
WHERE tip = 'CITY BREAK'
GROUP BY denumire
HAVING nr >= 2;

-- nume ghid si lista de sejururi, daca exista
SELECT CONCAT(nume, ' ', prenume) ghid, GROUP_CONCAT(denumire)
FROM sejur RIGHT JOIN ghid
ON sejur.id_ghid = ghid.id
GROUP BY ghid;

-- ghizi fara sejururi
SELECT CONCAT(nume, ' ', prenume) ghid
FROM sejur RIGHT JOIN ghid
ON sejur.id_ghid = ghid.id
WHERE denumire IS NULL;

-- sejururile care nu au fost achizitionate niciodata
SELECT denumire
FROM sejur LEFT JOIN pachet
ON sejur.id = pachet.id_sejur
WHERE pachet.id IS NULL;

-- sejururile cu acelasi tip ca 4
SELECT * 
FROM sejur 
WHERE tip = (SELECT tip FROM sejur WHERE id = 4);
-- sejururile cu pretul mai mare decat pretul mediu
SELECT *
FROM sejur
WHERE pret_persoana > (SELECT AVG(pret_persoana) FROM sejur);
-- sejururile cu acelasi tip si data inceput ca cel cu id-ul 2
SELECT * 
FROM sejur
WHERE (tip, data_inceput) = (SELECT tip, data_inceput FROM sejur WHERE id = 2);
-- pachetele cu acelasi tip de transport si nr de persoane ca 5
SELECT *
FROM pachet
WHERE (transport, nr_persoane) = (SELECT transport, nr_persoane FROM pachet WHERE id = 5);
-- ghizii pentru circuite
SELECT *
FROM ghid
WHERE id IN (SELECT id_ghid FROM sejur WHERE tip = 'CIRCUIT'); 
-- pachetele de tip city break
SELECT *
FROM pachet
WHERE id_sejur IN (SELECT id FROM sejur WHERE tip = 'CITY BREAK');
-- denumirea si masa pentru pachetele cu excursii
SELECT denumire, masa 
FROM pachet JOIN (SELECT id, denumire FROM sejur WHERE tip = 'EXCURSIE') excursie
ON pachet.id_sejur = excursie.id;
-- detalii sejururi italia: locatie, data inceput, data sfarsit, pret_persoana
CREATE VIEW sejur_italia AS
SELECT locatie, data_inceput, data_sfarsit, pret_persoana
FROM sejur
WHERE locatie LIKE '%Italia%';

SELECT * FROM sejur_italia;

-- nume client, denumire pachet, data inceput, pret, tip plata
CREATE VIEW detalii_comanda AS
SELECT nume, prenume, denumire, data_inceput, data_sfarsit, pret_final, plata.tip tip_plata
FROM client, sejur, pachet, plata
WHERE
client.id = pachet.id_client AND
sejur.id = pachet.id_sejur AND
pachet.id = plata.id_pachet;

SELECT * FROM detalii_comanda;

-- detalii pachet: locatie, pret, concatenate
DELIMITER //
CREATE FUNCTION detalii_pachet(id INT) RETURNS VARCHAR(200)
BEGIN
	DECLARE rezultat VARCHAR(200);
    SELECT CONCAT(locatie, ': ', pret_final) INTO rezultat
    FROM sejur JOIN pachet 
    ON sejur.id = pachet.id_sejur
    WHERE pachet.id = id;
    
    RETURN rezultat;
END;
//
DELIMITER ;

SELECT detalii_pachet(1);
-- calculeaza discount: 5% daca a luat mai mult de 3 pachete+10%daca il ia de ziua lui
DELIMITER //
CREATE FUNCTION calculeaza_discount(id_pachet INT) RETURNS TINYINT
BEGIN
	DECLARE discount TINYINT DEFAULT 0;
    DECLARE nr_pachete TINYINT;
    DECLARE zi_nastere INT;
    DECLARE luna_nastere INT;
    
    SELECT COUNT(*) INTO nr_pachete
    FROM pachet
    WHERE id_client = (SELECT id_client FROM pachet WHERE id = id_pachet);
    
    SELECT DAY(data_nastere), MONTH(data_nastere) INTO zi_nastere, luna_nastere
    FROM client
    WHERE id = (SELECT id_client FROM pachet WHERE id = id_pachet);
    
    IF nr_pachete > 3 THEN
		SET discount = discount + 5;
	END IF;
    
    IF DAY(CURDATE()) = zi_nastere AND MONTH(CURDATE()) = luna_nastere THEN
		SET discount = discount + 10;
	END IF;
    
    RETURN discount;
END;
//
DELIMITER ;

SELECT calculeaza_discount(17);
-- pt un pachet, detalii plata: nume client, nume sejur, daca s-a facut plata integral sub forma de mesaj (gigel a platit pentru sejur integral//avans x%)
DELIMITER //
CREATE FUNCTION mesaj_plata(id_pachet INT) RETURNS VARCHAR(500)
BEGIN
	DECLARE rezultat VARCHAR(500);
    DECLARE nume_client VARCHAR(100);
    DECLARE avans TINYINT;
    DECLARE sejur VARCHAR(50);
    
    SELECT CONCAT(nume, ' ', prenume), plata.avans, denumire INTO nume_client, avans, sejur
    FROM client, pachet, sejur, plata
    WHERE
    client.id = pachet.id_client AND
    sejur.id = pachet.id_sejur AND
    pachet.id = plata.id_pachet AND
    pachet.id = id_pachet;
    
    IF avans = 100 THEN
		SET rezultat = CONCAT_WS(' ', nume_client, 'a platit pentru', sejur, 'suma integrala');
	ELSE
		SET rezultat = CONCAT_WS(' ', nume_client, 'a platit pentru', sejur, avans, '%');
	END IF;
    
    RETURN rezultat;
END;
//
DELIMITER ;

SELECT mesaj_plata(7);

-- detalii pachet: nume client, locatie, data inceput, pret 
DELIMITER //
CREATE PROCEDURE detalii_pachet(IN id_pachet INT)
BEGIN
	SELECT CONCAT(nume, ' ', prenume) client, locatie, data_inceput, pret_final
    FROM 
    client JOIN pachet ON client.id = pachet.id_client
    JOIN sejur ON sejur.id = pachet.id_sejur
    WHERE pachet.id = id_pachet; 
END;
//
DELIMITER ;

CALL detalii_pachet(7);

-- actualizeaza pret: pret_persoana*nr_persoane + 200*nr_persoane daca e all inclusive - 50*nr_persoane daca ee transport individual, 
	-- la care aplicam si disocunt
DELIMITER //
CREATE PROCEDURE actualizeaza_pret(IN id_pachet INT)
BEGIN
	DECLARE pret_persoana INT;
    DECLARE nr_persoane TINYINT;
    DECLARE masa VARCHAR(50);
    DECLARE transport VARCHAR(50);
    DECLARE pret INT;
    DECLARE discount TINYINT;
    
    SELECT sejur.pret_persoana, pachet.nr_persoane, pachet.masa, pachet.transport, sejur.pret_persoana*pachet.nr_persoane, pachet.discount
    INTO pret_persoana, nr_persoane,masa, transport, pret, discount
    FROM pachet JOIN sejur ON pachet.id_sejur = sejur.id
    WHERE pachet.id = id_pachet;
    
    IF masa = 'ALL INCLUSIVE' THEN
		SET pret = pret + (200*nr_persoane);
	END IF;
    
    IF transport = 'INDIVIDUAL' THEN
		SET pret = pret - (50*nr_persoane);
	END IF;
    
    SET pret = pret * ((100-discount)/100);
    
    UPDATE pachet SET pret_final = pret WHERE id = id_pachet;
END;
//
DELIMITER ;     

CALL actualizeaza_pret(1);

-- pret total: nume client, cat a platit pe pachete pana acum 
DELIMITER //
CREATE PROCEDURE pret_total(IN nume_complet VARCHAR(100), OUT pret INT)
BEGIN
	SELECT SUM(pret_final) INTO pret
    FROM pachet JOIN client ON client.id = pachet.id_client
    WHERE CONCAT(nume, ' ', prenume) = nume_complet;
END;
//
DELIMITER ;

CALL pret_total('Pittman Ian', @pret_pachete);
SELECT @pret_pachete;

create table platit_integral(
	id int not null primary key auto_increment,
    id_pachet int not null,
    nume_client varchar(100) not null,
    nume_sejur varchar(50) not null,
    data_inceput date not null,
    foreign key(id_pachet) references pachet(id)
);

DELIMITER //
CREATE PROCEDURE populeaza_platit_integral()
BEGIN
	DECLARE id_pachet INT;
    DECLARE nume_client VARCHAR(50);
    DECLARE nume_sejur VARCHAR(50);
    DECLARE data_inceput DATE;
    DECLARE avans TINYINT;
    
    DECLARE ok TINYINT DEFAULT 1;
    DECLARE cursor_pachete CURSOR FOR
		SELECT pachet.id, CONCAT(nume, ' ', prenume), denumire, sejur.data_inceput, plata.avans
        FROM pachet, sejur, client, plata
        WHERE 
        pachet.id = plata.id_pachet AND
        sejur.id = pachet.id_sejur AND
        client.id = pachet.id_client;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET ok = 0;
    OPEN cursor_pachete;
    
    TRUNCATE platit_integral;
    pachete: LOOP
		FETCH cursor_pachete INTO id_pachet, nume_client, nume_sejur, data_inceput, avans;
        IF ok = 0 THEN
			LEAVE pachete;
		ELSE
			IF avans = 100 THEN
				INSERT INTO platit_integral VALUES(NULL, id_pachet, nume_client, nume_sejur, data_inceput);
			END IF;
        END IF;
    END LOOP pachete;
    
    CLOSE cursor_pachete;
END;
//
DELIMITER ;

CALL populeaza_platit_integral();
SELECT * FROM platit_integral;

-- lista cu sejur:ghid->pret pentru un anumit tip de sejur, unde pretul este cu 10% mai mic daca ghidul este incepator
DELIMITER //
CREATE FUNCTION lista_sejur(tip VARCHAR(50)) RETURNS TEXT
BEGIN
	DECLARE nume_ghid VARCHAR(100);
    DECLARE sejur VARCHAR(50);
    DECLARE pret INT;
    DECLARE experienta VARCHAR(50);
    DECLARE detalii_sejur VARCHAR(300);
    DECLARE rezultat TEXT;
    DECLARE ok TINYINT DEFAULT 1;
    
    DECLARE cursor_sejururi CURSOR FOR
		SELECT CONCAT(nume, ' ', prenume), nivel_experienta, pret_final, denumire
        FROM ghid, sejur, pachet
        WHERE 
        ghid.id = sejur.id_ghid AND
        sejur.id = pachet.id_sejur AND
        sejur.tip = tip;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET ok = 0;
    OPEN cursor_sejururi;
    sejururi: LOOP
		FETCH cursor_sejururi INTO nume_ghid, experienta, pret, sejur;
        IF ok = 0 THEN
			LEAVE sejururi;
		ELSE
			IF experienta = 'INCEPATOR' THEN
				SET pret = pret*0.9;
			END IF;
            SET detalii_sejur = CONCAT(sejur, ': ', nume_ghid, '->', pret);
            SET rezultat = CONCAT_WS('//', rezultat, detalii_sejur);
        END IF;
    END LOOP sejururi;
    CLOSE cursor_sejururi;
    
    RETURN rezultat;
END;
//
DELIMITER ;

SELECT lista_sejur('EXCURSIE');
-- Zakynthos: Brown Zeus->2736//Zakynthos: Brown Zeus->1296//Zakynthos: Brown Zeus->648//Zakynthos: Brown Zeus->1325//Zakynthos: Brown Zeus->3384//Zakynthos: Brown Zeus->1325//Bansko: Brown Zeus->1720//Bansko: Brown Zeus->2898//Croatia: Avery Riley->580//Croatia: Avery Riley->2930//Croatia: Avery Riley->599//Croatia: Avery Riley->2993//Croatia: Avery Riley->1701
-- lista cu client->nume sejur, pentru un tip de sejur daca nr persoane este mai mare de x//nr persoane se verifica in cursor
DELIMITER //
CREATE FUNCTION client_sejur(tip_sejur VARCHAR(50), nr_pers TINYINT) RETURNS TEXT
BEGIN
	DECLARE client VARCHAR(100);
    DECLARE sejur VARCHAR(50);
    DECLARE nr TINYINT;
    DECLARE rezultat TEXT;
    DECLARE ok TINYINT DEFAULT 1;
    DECLARE cursor_clienti CURSOR FOR
		SELECT CONCAT(nume, ' ', prenume), denumire, nr_persoane
        FROM client JOIN pachet ON client.id = pachet.id_client JOIN sejur ON sejur.id = pachet.id_sejur
        WHERE tip = tip_sejur;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET ok = 0;
    
    OPEN cursor_clienti;
    clienti: LOOP
		FETCH cursor_clienti INTO client, sejur, nr;
        IF ok = 0 THEN
			LEAVE clienti;
		ELSE 
			IF nr > nr_pers THEN
				SET rezultat = CONCAT_WS('//', rezultat, CONCAT(client, '->', sejur));
			END IF;
		END IF;
    END LOOP clienti;
    
    CLOSE cursor_clienti;
    RETURN rezultat;
END;
//
DELIMITER ;

SELECT client_sejur('EXCURSIE', 3);
-- Estes Brian->Bansko//Wilder Damian->Croatia//Wilder Damian->Zakynthos//Glass Cooper->Zakynthos//Spears Lawrence->Croatia

create table log_sejur(
	id int not null primary key auto_increment,
    id_sejur int not null,
    eveniment varchar(100) not null,
    detalii text,
    foreign key(id_sejur) references sejur(id)
); 
-- dupa update de ghid facem insert in log_sejur: ghid schimbat, ghid vechi -> ghid nou
DELIMITER //
CREATE OR REPLACE TRIGGER au_sejur AFTER UPDATE
ON sejur FOR EACH ROW
BEGIN
	DECLARE ghid_vechi VARCHAR(100);
	DECLARE ghid_nou VARCHAR(100);
    IF OLD.id_ghid != NEW.id_ghid THEN
		SELECT CONCAT(nume, ' ', prenume) INTO ghid_vechi FROM ghid WHERE id = OLD.id_ghid;
		SELECT CONCAT(nume, ' ', prenume) INTO ghid_nou FROM ghid WHERE id = NEW.id_ghid;
        INSERT INTO log_sejur VALUES(NULL, NEW.id, 'ghid schimbat', CONCAT(ghid_vechi, ' -> ', ghid_nou));
	END IF;
END;
//
DELIMITER ;
UPDATE sejur SET id_ghid = 1 WHERE id = 3;
SELECT * FROM log_sejur;
-- inainte de insert verificam daca mai sunt locuri disponibile si daca nu dam eroare
DELIMITER //
CREATE TRIGGER bi_pachet BEFORE INSERT
ON pachet FOR EACH ROW
BEGIN
	DECLARE nr_locuri TINYINT;
    DECLARE locuri_ocupate TINYINT;
    DECLARE eroare TEXT;
    
    SELECT locuri_disponibile INTO nr_locuri FROM sejur WHERE id = NEW.id_sejur;
    SELECT SUM(nr_persoane) INTO locuri_ocupate FROM pachet WHERE pachet.id_sejur = NEW.id_sejur;
    
    IF NEW.nr_persoane > (nr_locuri - locuri_ocupate) THEN
		SET eroare = CONCAT('mai sunt doar ', nr_locuri - locuri_ocupate, ' locuri disponibile');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = eroare;
	END IF;
END;
//
DELIMITER ;

INSERT INTO pachet (data_achizitie,masa,transport,nr_persoane,discount,asigurare,id_client,id_sejur) 
VALUES ("2021-07-02 ","MIC DEJUN","AUTOCAR",1,6,"1",10,5);

-- inainte de a sterge un ghid punem in sejur id_ghid = null
DELETE FROM ghid WHERE id = 12;
DELIMITER //
CREATE TRIGGER bd_ghid BEFORE DELETE
ON ghid FOR EACH ROW
BEGIN
	UPDATE sejur SET id_ghid = NULL WHERE id_ghid = OLD.id;
END;
//
DELIMITER ;

DELETE FROM ghid WHERE id = 12;
SELECT * FROM sejur;













