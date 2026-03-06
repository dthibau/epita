# Sprint Planning

## Sprint 0: Base Infrastructure & Discovery
**Goal:** Establish the technical foundation and instantiate the core data model.

* **Epic: Infrastructure**
  * Automate infrastructure provisioning and configuration management using Terraform and Ansible.
  * Containerize all basic micro-services using Docker.
  * Configure automated CI/CD pipelines targeting both pre-production and production environments.
* **Epic: Catalog Data**
  * Set up the PostgreSQL database for persistent game data.
  * Develop the internal `Fetch_api` service to start synchronizing data from the IGDB API.

---

## Sprint 1: Platform Core & Authentication
**Goal:** Implement container orchestration, user identity, and advanced data search.

* **Epic: Infrastructure**
  * Set up the Kubernetes cluster to start orchestrating deployed services.
* **Epic: Authentication**
  * Develop the secure Authentication microservice using Laravel.
  * Implement OAuth2 protocol and PKCE flow for safe account creation, management, and session control.
* **Epic: Catalog Data**
  * Implement the powerful search engine, including custom sorting and complex filtering of game data.
  * Publish the standardized technical API documentation via Swagger.

---

## Sprint 2: Transactions & Streaming Setup
**Goal:** Unlock the primary commercial flow and establish the real-time communication backbone.

* **Epic: Marketplace**
  * Manage the primary marketplace allowing users to securely buy and sell basic game keys.
  * Develop the user-to-user resell system for secure connection and trades.
* **Epic: Notifications**
  * Set up the Kafka broker to enable asynchronous messaging and high-throughput inter-service communication.
  * Initialize the Next.js frontend managed via Bun to connect to real-time streams.

---

## Sprint 3: Integrations & Active Notifications
**Goal:** Polish the buying experience and deliver active insights to users.

* **Epic: Marketplace**
  * Integrate Apple and Amazon gift cards as payment components.
  * Implement functional shopping carts and detailed order tracking.
* **Epic: Notifications**
  * Develop the Notification service to push configured alerts (e.g., specific price drops) continuously to the Next.js frontend.
* **Epic: User Experience**
  * Connect with the external Steam API to securely fetch user profiles and data.

---

## Sprint 4: Social Features & Platform Observability
**Goal:** Maximize user engagement and ensure production readiness.

* **Epic: User Experience**
  * Roll out the social gamification system (e.g., seniority badges).
  * Launch the custom engine to recommend "Trending" games and match user preferences.
* **Epic: Infrastructure**
  
  * Deploy the centralized observability stack utilizing Grafana for metrics and Elasticstack for log aggregation.