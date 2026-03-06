# GameTrade – Marketplace de comptes de jeux vidéo

**Groupe :**

* Yassine Azzouz
* Selim Barka
* Achraf Chawki

---

# Table des matières

1. [Introduction](#introduction)
2. [Types d'utilisateurs](#types-dutilisateurs)
3. [User Stories](#user-stories)
4. [Use Case – Création d'annonce](#use-case--création-dannonce)
5. [Technologies et Architecture](#technologies-et-architecture)
6. [Planning des sprints](#planning-des-sprints)
7. [Conclusion](#conclusion)

---

# Introduction

Ce document présente la conception de l'application **GameTrade**, une plateforme permettant aux utilisateurs d'acheter et de vendre des comptes de jeux vidéo.

Il décrit :

* les **user stories**
* les **choix technologiques**
* l'**architecture globale**
* les **types d'utilisateurs**
* le **planning des sprints** pour le développement du MVP.

---

# Types d'utilisateurs

### Vendeur

* Crée des annonces pour vendre ses comptes
* Modifie ou supprime ses annonces
* Reçoit des notifications sur ses ventes

### Acheteur

* Recherche des comptes
* Filtre par jeu, prix ou rareté
* Contacte les vendeurs pour acheter

### Administrateur (optionnel)

* Gère les utilisateurs
* Surveille les annonces
* Vérifie le flux Kafka pour assurer la bonne distribution des notifications

---

# User Stories

**US1 – Liste des jeux**
En tant qu'utilisateur, je veux voir la liste des jeux disponibles pour pouvoir rechercher des comptes à vendre.

**US2 – Détail d'un jeu**
En tant qu'utilisateur, je veux voir le détail d'un jeu (titre, genre, plateforme, description) pour décider si je veux acheter un compte.

**US3 – Création d'annonce**
En tant que vendeur, je veux créer une annonce de vente de compte pour partager mon compte avec d'autres utilisateurs.

**US4 – Modification / suppression d'annonce**
En tant que vendeur, je veux modifier ou supprimer mes annonces pour les tenir à jour.

**US5 – Recherche / filtrage**
En tant qu'acheteur, je veux filtrer les annonces par jeu, prix ou rareté pour trouver rapidement ce que je cherche.

**US6 – Contact vendeur**
En tant qu'acheteur, je veux contacter le vendeur pour finaliser la transaction.

**US7 – Notifications**
En tant qu'utilisateur, je veux recevoir une notification lorsqu'une annonce correspondant à mes critères est publiée.

**US8 – Profil utilisateur**
En tant qu'utilisateur, je veux voir mes annonces et mes interactions pour suivre mes ventes et achats.

---

# Use Case – Création d'annonce

**Acteur :** Vendeur

## Description

Le vendeur souhaite mettre en vente un compte de jeu.
Il renseigne les informations nécessaires, le système valide les entrées et publie l'annonce.

### Pré-condition

L'utilisateur est connecté en tant que vendeur.

### Scénario principal

1. Le vendeur clique sur **Créer une annonce**
2. Le vendeur renseigne :

   * le jeu
   * le niveau
   * la rareté
   * le prix du compte
3. Le système valide les informations et enregistre l'annonce en base
4. Le système publie un événement sur **Kafka** pour notifier les utilisateurs intéressés
5. Le vendeur reçoit une confirmation de publication

### Post-condition

* L'annonce est visible par les acheteurs
* Un événement est publié sur Kafka

---

# Technologies et Architecture

## Technologies

* **Backend :** Java 17, Spring Boot, Spring Security (authentification simple)
* **Messaging :** Apache Kafka pour notifications et suivi des annonces
* **Frontend :** React.js pour un mini frontend interactif
* **Base de données :** PostgreSQL
* **Containerisation :** Docker + docker-compose
* **API externe :** RAWG ou IGDB pour récupérer les informations sur les jeux
* **CI/CD :** GitLab CI pour build, tests et déploiement

---

## Architecture

### Description

* Le **frontend** communique avec le **backend** via une **API REST**

Le **backend Spring Boot** gère :

* gestion des utilisateurs et authentification
* CRUD sur les annonces
* intégration avec l’API externe pour récupérer les informations de jeux
* publication des événements sur **Kafka** (nouvelles annonces, notifications)

### Infrastructure

* **Kafka**

  * un topic principal pour les nouvelles annonces
  * un topic pour les événements utilisateurs

* **PostgreSQL**

  * stockage des utilisateurs
  * stockage des annonces
  * stockage des jeux

* **Docker**

  * containerisation du projet
  * lancement rapide via **docker-compose**

---

# Planning des sprints

| Sprint                         | Objectifs                                                                                        | Livrables                                                         |
| ------------------------------ | ------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------- |
| Sprint 1 (19-26 Février)       | Mise en place de l'environnement DevOps et Docker, initialisation du projet Spring Boot et React | Docker-compose fonctionnel, backend minimal CRUD, README initial  |
| Sprint 2 (27 Février - 5 Mars) | Implémentation des annonces (CRUD complet), intégration de Kafka pour les événements             | Backend CRUD complet, topics Kafka créés, tests unitaires de base |
| Sprint 3 (6-12 Mars)           | Frontend : affichage liste des annonces et détails, intégration avec backend REST                | Frontend fonctionnel pour lister et consulter les annonces        |
| Sprint 4 (13-19 Mars)          | Filtrage et recherche des annonces, création d'un profil utilisateur                             | Filtrage fonctionnel, profils utilisateur opérationnels           |
| Sprint 5 (20-27 Mars)          | Notifications Kafka, amélioration CI/CD, tests de couverture                                     | Notifications via Kafka opérationnelles, pipeline CI/CD complet   |
| Sprint 6 (28 Mars - 10 Avril)  | Stabilisation, corrections bugs, audit sécurité                                                  | Backend et frontend stabilisés, documentation Swagger             |
| Sprint 7 (11-24 Avril)         | Préparation release, démonstration, soutenance                                                   | Release 1.0 prête, images Docker publiées                         |

---

# Conclusion

Ce document fournit la base pour le développement du projet **GameTrade**.

Le **MVP** sera concentré sur :

* la création d'annonces
* la consultation d'annonces
* la recherche d'annonces

Kafka sera utilisé pour la **distribution d'événements et notifications**.

L'architecture choisie garantit un projet :

* maintenable
* évolutif
* reproductible dans un contexte industriel.
