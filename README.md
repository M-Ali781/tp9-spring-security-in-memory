# TP 9 : Authentification en mémoire avec Spring Security

Ce projet implémente le **TP 9** du module *Développement JakartaEE : Spring* portant sur l'authentification en mémoire avec **Spring Security 6** et **Spring Boot 3**, le hachage sécurisé des mots de passe avec **BCryptPasswordEncoder**, le contrôle d'accès basé sur les rôles (`ROLE_USER`, `ROLE_ADMIN`), ainsi que la personnalisation de la page de connexion Thymeleaf.

---

## 1. Compilation Maven du projet Spring Boot

![1. Compilation Maven du projet Spring Boot (mvn clean compile)](screenshots/01_maven_clean_compile.png)

---

## 2. Exécution de la suite de tests unitaires et d'intégration

![2. Exécution de la suite de tests unitaires et d'intégration (mvn test)](screenshots/02_maven_test_suite.png)

---

## 3. Démarrage de l'application Spring Boot sur le port 8080

![3. Démarrage de l'application Spring Boot sur le port 8080](screenshots/03_spring_boot_startup.png)

---

## 4. Accès public à la page d'accueil (GET /) - HTTP 200 OK

![4. Accès public à la page d'accueil (GET /) - HTTP 200 OK](screenshots/04_public_access_home.png)

---

## 5. Tentative d'accès non authentifié à /user/dashboard (Redirection 302 vers /login)

![5. Tentative d'accès non authentifié à /user/dashboard (Redirection 302 vers /login)](screenshots/05_unauth_user_dashboard_redirect.png)

---

## 6. Tentative d'accès non authentifié à /admin/dashboard (Redirection 302 vers /login)

![6. Tentative d'accès non authentifié à /admin/dashboard (Redirection 302 vers /login)](screenshots/06_unauth_admin_dashboard_redirect.png)

---

## 7. Affichage du formulaire de connexion personnalisé (GET /login)

![7. Affichage du formulaire de connexion personnalisé (GET /login)](screenshots/07_login_page_custom_view.png)

---

## 8. Échec d'authentification avec identifiants erronés (POST /login)

![8. Échec d'authentification avec identifiants erronés (POST /login)](screenshots/08_login_failure_bad_credentials.png)

---

## 9. Authentification réussie du compte 'user' (mot de passe '1111' hashé BCrypt)

![9. Authentification réussie du compte 'user' (mot de passe '1111' hashé BCrypt)](screenshots/09_login_success_user.png)

---

## 10. Accès autorisé à l'Espace Utilisateur (/user/dashboard) pour le rôle USER

![10. Accès autorisé à l'Espace Utilisateur (/user/dashboard) pour le rôle USER](screenshots/10_user_access_user_dashboard.png)

---

## 11. Refus d'accès à l'Espace Admin (/admin/dashboard) pour 'user' - HTTP 403 Forbidden

![11. Refus d'accès à l'Espace Admin (/admin/dashboard) pour 'user' - HTTP 403 Forbidden](screenshots/11_user_access_admin_dashboard_403.png)

---

## 12. Authentification réussie du compte 'admin' (mot de passe '1234' hashé BCrypt)

![12. Authentification réussie du compte 'admin' (mot de passe '1234' hashé BCrypt)](screenshots/12_login_success_admin.png)

---

## 13. Accès autorisé à l'Espace Admin (/admin/dashboard) pour le rôle ADMIN

![13. Accès autorisé à l'Espace Admin (/admin/dashboard) pour le rôle ADMIN](screenshots/13_admin_access_admin_dashboard.png)

---

## 14. Accès autorisé à l'Espace Utilisateur pour le compte 'admin' (cumul des rôles)

![14. Accès autorisé à l'Espace Utilisateur pour le compte 'admin' (cumul des rôles)](screenshots/14_admin_access_user_dashboard.png)

---

## 15. Déconnexion et invalidation de la session (POST /logout)

![15. Déconnexion et invalidation de la session (POST /logout)](screenshots/15_logout_session_invalidation.png)

