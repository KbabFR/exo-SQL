/* exo 4 */
SELECT nom, prenom, ville
FROM abonne
WHERE ville = "MONTPELLIER"
ORDER BY 1, 2;

/* exo 5 */
SELECT DISTINCT prenom
FROM abonne
WHERE prenom LIKE 'L%'
ORDER BY 1;

/* exo 6 */
SELECT DISTINCT prenom
FROM abonne
WHERE prenom LIKE 'L%' OR prenom LIKE 'M%'
ORDER BY 1;

/* exo 7 */
SELECT nom, prenom, ville
FROM abonne
WHERE ville = 'MONTPELLIER' AND prenom LIKE 'F%'
ORDER BY 1, 2;

/* exo 8 */
SELECT CONCAT(UPPER(nom), ' ', prenom) AS NOM_m
FROM abonne
WHERE UPPER(ville) = 'MONTPELLIER'
ORDER BY 1;

/* exo 9 Récupérer tous les abonnés dont l’abonnement est valide ( date_fin_abo supérieure ou égale à la date courante) */
SELECT nom, prenom
FROM abonne
WHERE date_fin_abo >= CURDATE()/* AND date_inscription <= CURDATE()*/
ORDER BY 1, 2;

/* exo 10 Récupérer tous les abonnés ayant moins de 20 ans */
SELECT nom, prenom, TIMESTAMPDIFF(YEAR, date_naissance, CURDATE()) AS age
FROM abonne
WHERE TIMESTAMPDIFF(YEAR, date_naissance, CURDATE()) < 20
ORDER BY 3, 1, 2;

/* exo 11 Récupérer tous les abonnés dont l’anniversaire tombe le mois courant */
SELECT nom, prenom
FROM abonne
WHERE MONTH(date_naissance) = MONTH(CURDATE())
ORDER BY 1, 2;

/* exo 12 Récupérer tous les abonnés dont l’anniversaire tombe demain */
SELECT nom, prenom, CONCAT('HAPPY BIRTHDAY ', prenom, ' !') AS HB_message
FROM abonne
WHERE MONTH(date_naissance) = MONTH(DATE_ADD(CURDATE(), INTERVAL 1 DAY)) AND DAY(date_naissance) = DAY(DATE_ADD(CURDATE(), INTERVAL 1 DAY))
ORDER BY 1, 2;

/* exo 13 Récupérer tous les abonnés qui se sont abonnés la semaine dernière (de lundi de la semaine dernière à dimanche dernier) */
SELECT nom, prenom, date_inscription
FROM abonne
WHERE WEEKOFYEAR(date_inscription) = WEEKOFYEAR(DATE_SUB(CURDATE(), INTERVAL 1 WEEK))
ORDER BY 3, 1, 2;

/* exo 14 Compter le nombre d’abonnés */
SELECT COUNT(*) AS nb_abonnés
FROM abonne;

/* exo 15 Compter le nombre d’abonnés entre 30 et 40 ans*/
SELECT COUNT(*) AS nb_abonnés_trentenaire
FROM abonne
WHERE YEAR(DATE_SUB(CURDATE(), INTERVAL TO_DAYS(date_naissance) DAY)) >= 30
AND YEAR(DATE_SUB(CURDATE(), INTERVAL TO_DAYS(date_naissance) DAY)) < 40;

/* exo 16 Afficher le nombre d’abonné pour chaque ville et trier par ordre descendantdu nombre d'abonnés (Classement des villes par nombre d'abonnés) */
SELECT ville, COUNT(*) AS nb_abonnés_par_villes
FROM abonne
GROUP BY ville
ORDER BY 2 DESC, 1;

/* exo 17 Limiter le résultat précédant aux villes ayant au moins 20 abonnés */
SELECT ville, COUNT(*) AS nb_abonnés_par_villes
FROM abonne
GROUP BY ville HAVING COUNT(*) >= 20
ORDER BY 2 DESC, 1;

/* exo 18 Récupérer les abonnés dont le nom commence par A et afficher leur statut d’abonnement sous la forme “abonné jus qu’au dd/mm/yyyy” ou “expiré” */
SELECT nom, prenom, case
        when date_fin_abo >= CURDATE() 
        then CONCAT("abonné(e) jusqu'au ", date_format(date_fin_abo , "%d/%m/%Y"))
        when date_fin_abo < CURDATE()
        then "expiré"
		END AS statut
FROM abonne
WHERE nom LIKE 'A%'
ORDER BY date_fin_abo;

/* exo 19 Compter le nombre de membre de chaque famille (même nom) */
SELECT nom, COUNT(*) AS abonnés_dans_la_famille
FROM abonne
GROUP BY nom
ORDER BY 2 DESC, 1;

/* exo 20 exo precedent + retourner pour chacune la date de naissance du plus jeune et du plus vieux */
SELECT nom, COUNT(*) AS abonnés_dans_la_famille, MAX(date_naissance) AS date_jeune, MIN(date_naissance) AS date_vieu
FROM abonne
GROUP BY nom
ORDER BY 2 DESC, 1;

/* exo 21 exo precedent mais en age et non date*/
SELECT nom, COUNT(*) AS abonnés_dans_la_famille, MIN(TIMESTAMPDIFF(YEAR, date_naissance, CURDATE())) AS age_jeune, MAX(TIMESTAMPDIFF(YEAR, date_naissance, CURDATE())) AS age_vieu
FROM abonne
GROUP BY nom
ORDER BY 2 DESC, 1;

/* exo 22 Calculer le nombre d’abonné par tranche d'âge (10 20 ans, 20 30 ans, …) */
SELECT (CASE 
		WHEN TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)>=10 AND TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)<20 THEN 'tranche 10-20ans'
		WHEN TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)>=20 AND TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)<30 THEN 'tranche 20-30ans'
		WHEN TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)>=30 AND TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)<40 THEN 'tranche 30-40ans'
		WHEN TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)>=40 AND TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)<50 THEN 'tranche 40-50ans'
		WHEN TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)>=50 AND TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)<60 THEN 'tranche 50-60ans'
		WHEN TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)>=60 AND TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)<70 THEN 'tranche 60-70ans'
		ELSE 'other'
	END) AS tranche_age, COUNT(*) AS cnt
FROM abonne
GROUP BY (CASE 
		WHEN TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)>=10 AND TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)<20 THEN 'tranche 10-20ans'
		WHEN TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)>=20 AND TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)<30 THEN 'tranche 20-30ans'
		WHEN TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)>=30 AND TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)<40 THEN 'tranche 30-40ans'
		WHEN TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)>=40 AND TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)<50 THEN 'tranche 40-50ans'
		WHEN TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)>=50 AND TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)<60 THEN 'tranche 50-60ans'
		WHEN TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)>=60 AND TIMESTAMPDIFF(YEAR,date_naissance,CURRENT_DATE)<70 THEN 'tranche 60-70ans'
		ELSE 'other' 
	END);