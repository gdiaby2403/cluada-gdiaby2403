/*1. La liste des employé·e·s avec le nom de leur service, triée par service puis par nom.*/
SELECT s.nom AS "Service", e.nom AS "Nom", e.prenom AS "Prenom"
FROM employe e
JOIN service s ON e.service_id = s.id
ORDER BY s.nom , e.nom ASC

/*2. Le nombre d'employé·e·s par service.*/

SELECT s.nom AS "Service", COUNT(service_id) AS "Nombre d'employes"
FROM employe e
JOIN service s ON e.service_id = s.id
GROUP BY s.nom

/*3. Le chiffre d'affaires total de la machine à café sur la période, en euros.*/
SELECT ROUND(SUM(prix_centimes)/100.0, 2) AS "Chiffre d'affaire total de la machine à café" 
FROM transaction_cafe

4. Le nombre de cafés tirés par boisson — quelle est la boisson la plus populaire chez Adakor ?
5. Le montant dépensé en café par personne (nom, prénom, total en euros), du plus dépensier au moins dépensier.
6. Les personnes qui tirent en moyenne plus de 4 cafés par jour de présence. Quelque chose te surprend ? Note-le en commentaire… puis va voir la question 7 avant de conclure.
7. Pour la personne repérée en 6 : à quelles heures tire-t-elle ses cafés ? Toutes les boissons sont-elles pour elle ? (Indice : personne ne boit 4 cappuccinos ET 3 chocolats ET 2 thés par jour. Hypothèse plausible : elle badge pour tout son open space. Une anomalie n'est pas une preuve.)*/