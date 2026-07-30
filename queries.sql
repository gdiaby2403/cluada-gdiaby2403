/*1. La liste des employé·e·s avec le nom de leur service, triée par service puis par nom.*/

SELECT s.nom AS "Service", e.nom AS "Nom", e.prenom AS "Prenom"
FROM employe e
JOIN service s ON e.service_id = s.id
ORDER BY s.nom , e.nom ASC;

/*2. Le nombre d'employé·e·s par service.*/

SELECT s.nom AS "Service", COUNT(service_id) AS "Nombre d'employes"
FROM employe e
JOIN service s ON e.service_id = s.id
GROUP BY s.nom;

/*3. Le chiffre d'affaires total de la machine à café sur la période, en euros.*/

SELECT ROUND(SUM(prix_centimes)/100.0, 2) AS "Chiffre d'affaire total de la machine à café" 
FROM transaction_cafe;

/* 904, 60 € sur la période */

/*4. Le nombre de cafés tirés par boisson — quelle est la boisson la plus populaire chez Adakor ?*/

SELECT DISTINCT boisson, COUNT(boisson) AS "Nombre de boisson tiré" 
FROM transaction_cafe
GROUP BY boisson
ORDER BY COUNT(boisson) DESC;

-- La boisson la plus populaire chez Adakor est : l'espresso

/*5. Le montant dépensé en café par personne (nom, prénom, total en euros), du plus dépensier au moins dépensier.*/
SELECT e.nom, e.prenom, ROUND(SUM(prix_centimes)/100.0, 2) AS "total en euros"
FROM transaction_cafe tc
JOIN employe e ON e.id = tc.employe_id
GROUP BY e.nom , e.prenom
ORDER BY "total en euros" DESC;



/*6. Les personnes qui tirent en moyenne plus de 4 cafés par jour de présence. Quelque chose te surprend ? Note-le en commentaire… puis va voir
la question 7 avant de conclure.*/

SELECT e.nom, e.prenom, COUNT(tc.boisson) AS "Nombre de boisson tiré par boisson"
FROM transaction_cafe tc
JOIN employe e ON e.id = tc.employe_id
GROUP BY e.nom , e.prenom
ORDER BY "Nombre de boisson tiré par boisson" DESC;



SELECT * COUNT(transaction_cafe.id)  AS total_cafe,
COUNT(DATE(tc.horodatage)) AS jour_presence
COUNT(tc.id)*1.0 / COUNT(DATE(tc.horodatage)) AS moyenne_cafe
FROM employe 
JOIN transaction_cafe tc ON tc.employe.id = employe.id


/*Marc Petit et Julien Weber tirent le plus de boissons à la machine*/ 

/*7. Pour la personne repérée en 6 : à quelles heures tire-t-elle ses cafés ? Toutes les boissons sont-elles pour elle ? (Indice : personne ne boit 4 cappuccinos ET 3 chocolats ET 2 thés par jour. Hypothèse plausible : elle badge pour tout son open space. Une anomalie n'est pas une preuve.)*/


/* 8. Tous les badgeages effectués après 21h, triés par date. Observe les sens : des sorties tardives, c'est normal. Et le reste ?*/

SELECT employe_id, horodatage, sens
FROM badgeage 
WHERE to_char(horodatage, 'HH24:MI') > '21:00'
GROUP BY employe_id, horodatage, sens
ORDER BY horodatage;


/* 9. Isole les entrées après 21h. Qui ? Quelle porte ? Quelles dates ?*/

SELECT e.nom, e.prenom, b.employe_id, b.horodatage, b.sens, porte
FROM badgeage b
JOIN employe e ON e.id = b.employe_id
WHERE to_char(horodatage, 'HH24:MI') > '21:00' AND sens = 'entree'
GROUP BY b.horodatage, b.sens, b.porte, b.employe_id, e.nom, e.prenom
ORDER BY b.horodatage;


/*10. Cette personne était-elle censée être là ? Croise avec la table conge : liste les badgeages effectués par un·e employé·e pendant l'un de ses congés.*/

SELECT e.nom, e.prenom, c.employe_id, b.horodatage, b.sens, porte, CONCAT(c.date_debut,' / ', c.date_fin) AS periode_conge
FROM badgeage b
JOIN conge c ON c.employe_id = b.employe_id
JOIN employe e ON e.id = b.employe_id
WHERE horodatage BETWEEN c.date_debut AND c.date_fin
GROUP BY b.horodatage, b.sens, b.porte, b.employe_id, c.employe_id, c.date_debut, c.date_fin, c.type, e.nom, e.prenom
ORDER BY b.horodatage;

/*11. Le badge a aussi servi à la machine à café ces soirs-là. Prouve-le.*/

SELECT e.nom, e.prenom, c.employe_id, CONCAT(c.date_debut,' / ', c.date_fin) AS periode_conge,
to_char(tc.horodatage, 'YYYY-MM-dd  HH24:MI:SS') AS date_tirage_boisson
FROM transaction_cafe tc

JOIN conge c ON c.employe_id = tc.employe_id
JOIN employe e ON e.id = c.employe_id

WHERE tc.horodatage BETWEEN c.date_debut AND c.date_fin
GROUP BY c.employe_id, c.date_debut, c.date_fin, e.nom, e.prenom, tc.horodatage
ORDER BY tc.horodatage;


/*12. La question à 1 million : qui était physiquement présent·e ces soirs-là ? Le badge de la porte peut s'emprunter… mais on vient en voiture avec son propre badge de parking. Croise les accès parking avec les horaires des badgeages suspects.*/

SELECT e.nom, e.prenom, b.employe_id, a.horodatage AS date_acces_parking, a.sens AS sens_acces_parking
FROM badgeage b

JOIN acces_parking a ON a.employe_id = b.employe_id
JOIN employe e ON e.id = b.employe_id

WHERE b.horodatage::time > '21:00' AND a.horodatage::time > '21:00'
GROUP BY b.sens, b.porte, b.employe_id, e.nom, e.prenom, a.horodatage, a.sens
ORDER BY  a.horodatage;

/*13. Vérifie ton hypothèse : la personne suspectée a-t-elle badgé à une porte avec son propre badge ces soirs-là ? Que faisait-elle les jours en question (ses badgeages en journée) ?*/