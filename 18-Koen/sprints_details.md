# Planification Détaillée des Sprints (MVP 1.0.0) : Kōen

Ce document détaille la feuille de route de l'équipe pour la réalisation du MVP (Minimum Viable Product) de la plateforme **Kōen**. Le développement est structuré en **5 Sprints** (incluant le Sprint 0 d'initialisation), suivant une méthodologie Agile.

---

##  Sprint 0 : Fondations DevOps et Architecture
**Objectif :** Mettre en place l'environnement de travail collaboratif et l'infrastructure locale pour que toute l'équipe puisse coder sans bloquer sur des problèmes de configuration.

* **Durée estimée :** 1 semaine
* **Tâches techniques :**
  * Initialisation du dépôt GitHub (Monorepo `koen-platform`).
  * Configuration du tableau de suivi **GitHub Projects** (Kanban : *To Do, In Progress, Review, Done*).
  * Création de l'arborescence des dossiers (`/frontend`, `/backend`, `/docs`).
  * Rédaction du `docker-compose.yml` initial (PostgreSQL, Apache Kafka, Zookeeper).
  * Mise en place de la pipeline CI/CD avec **GitHub Actions** (vérification du build).
* **Livrable du Sprint :** Un développeur peut cloner le dépôt, taper `docker-compose up -d` et avoir une base de données et un cluster Kafka fonctionnels en local.

---

##  Sprint 1 : Socle Back-End & Base de Données
**Objectif :** Développer le cœur de l'API REST, sécuriser l'application et modéliser les données.
**User Stories ciblées :** US03 (Authentification), US04 (Dashboard Admin - partie API).

* **Durée estimée :** 2 semaines
* **Tâches techniques :**
  * Initialisation du projet **Spring Boot** (Dependencies : Web, Data JPA, Security, PostgreSQL Driver).
  * Modélisation de la base de données (Entités : `User`, `MangaMetadata`, `Promotion`).
  * Implémentation de **Spring Security** et des filtres de tokens **JWT** pour gérer les rôles (Visiteur, Éditeur, Admin).
  * Développement du client HTTP (RestTemplate/WebClient) pour interroger les APIs externes (**Jikan** et **AniList**) et enrichir la base de données locale.
* **Livrable du Sprint :** API fonctionnelle (sur `localhost:8080`) avec des routes sécurisées testables via Postman/Swagger.

---

##  Sprint 2 : Socle Front-End & Liseuse
**Objectif :** Mettre en place l'interface utilisateur (UI/UX), l'authentification côté client, et surtout la liseuse de scans sans publicité.
**User Stories ciblées :** US01 (Consultation Catalogue), US02 (Liseuse MangaDex).

* **Durée estimée :** 2 semaines
* **Tâches techniques :**
  * Initialisation du projet **Angular** et intégration de la bibliothèque de composants **ZardUI**.
  * Création des services `HttpClient` pour dialoguer avec l'API Spring Boot et gérer le token JWT (Interceptors).
  * Développement de la page d'accueil (Grille du catalogue, barre de recherche, filtres).
  * Intégration de l'**API MangaDex** : Logique de récupération directe des identifiants de chapitres et des images pour l'affichage de la liseuse.
* **Livrable du Sprint :** Application Angular navigable (sur `localhost:80`), connexion possible, et lecture fonctionnelle du premier chapitre d'un manga via MangaDex.

---

##  Sprint 3 : Asynchronisme & Monétisation (Le cœur du projet)
**Objectif :** Implémenter le modèle économique B2B et la mécanique événementielle temps réel (notre principal challenge technique).
**User Stories ciblées :** US05 (Promotion B2B), US06 (Notifications Live).

* **Durée estimée :** 2 semaines
* **Tâches techniques :**
  * Création du formulaire de soumission de promotion (Interface Éditeur) sur le Front-End.
  * Création de l'endpoint Back-End `POST /api/promotions` (simulation de validation de paiement).
  * Configuration du **Producer Kafka** : émission d'un événement `PromotionCreatedEvent` dans le topic Kafka dédié.
  * Configuration du **Consumer Kafka** : interception de l'événement par le backend.
  * Implémentation des **WebSockets** (Spring STOMP) pour envoyer l'alerte du backend vers les clients Angular connectés.
* **Livrable du Sprint :** Lorsqu'un Éditeur valide une promotion, une notification "toast" apparaît instantanément sur l'écran d'un Visiteur connecté, sans rechargement de page.

---

##  Sprint 4 : Phase de Stabilisation (MVP Release)
**Objectif :** Figer les développements, chasser les bugs et préparer la soutenance.

* **Durée estimée :** 1 semaine
* **Tâches techniques :**
  * Tests d'intégration (QA) et tests croisés entre Manaïa, Bryan et Rayann.
  * Résolution des bugs critiques (Priorité Haute) et nettoyage du code (Linting).
  * Vérification de la CI/CD (GitHub Actions doit être 100% au vert).
  * Finalisation du document de conception technique et du `README.md`.
  * Préparation du jeu de données de test (Mock data) pour la démonstration.
* **Livrable du Sprint :** Version **1.0.0** stable, déployable et prête pour la présentation à David.
