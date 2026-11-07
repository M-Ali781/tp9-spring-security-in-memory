package ma.fstg.security;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.test.context.support.WithAnonymousUser;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestBuilders.formLogin;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestBuilders.logout;
import static org.springframework.security.test.web.servlet.response.SecurityMockMvcResultMatchers.authenticated;
import static org.springframework.security.test.web.servlet.response.SecurityMockMvcResultMatchers.unauthenticated;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class SpringSecurityDemoApplicationTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Test
    @DisplayName("1. Page d'accueil accessible publiquement (HTTP 200)")
    void publicHomePageShouldBeAccessible() throws Exception {
        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(view().name("index"));
    }

    @Test
    @DisplayName("2. Page de connexion accessible publiquement (HTTP 200)")
    void loginPageShouldBeAccessible() throws Exception {
        mockMvc.perform(get("/login"))
                .andExpect(status().isOk())
                .andExpect(view().name("login"));
    }

    @Test
    @DisplayName("3. Accès anonyme à /user/dashboard redirige vers /login (HTTP 302)")
    @WithAnonymousUser
    void unauthenticatedAccessToUserDashboardRedirectsToLogin() throws Exception {
        mockMvc.perform(get("/user/dashboard"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrlPattern("**/login"));
    }

    @Test
    @DisplayName("4. Accès anonyme à /admin/dashboard redirige vers /login (HTTP 302)")
    @WithAnonymousUser
    void unauthenticatedAccessToAdminDashboardRedirectsToLogin() throws Exception {
        mockMvc.perform(get("/admin/dashboard"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrlPattern("**/login"));
    }

    @Test
    @DisplayName("5. Authentification réussie pour l'utilisateur 'user' avec mot de passe '1111'")
    void formLoginSuccessForUser() throws Exception {
        mockMvc.perform(formLogin().user("user").password("1111"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"))
                .andExpect(authenticated().withUsername("user").withRoles("USER"));
    }

    @Test
    @DisplayName("6. Authentification réussie pour l'administrateur 'admin' avec mot de passe '1234'")
    void formLoginSuccessForAdmin() throws Exception {
        mockMvc.perform(formLogin().user("admin").password("1234"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"))
                .andExpect(authenticated().withUsername("admin").withRoles("ADMIN", "USER"));
    }

    @Test
    @DisplayName("7. Échec d'authentification en cas de mauvais mot de passe (Redirection vers /login?error=true)")
    void formLoginFailureWithWrongPassword() throws Exception {
        mockMvc.perform(formLogin().user("user").password("wrongpassword"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/login?error=true"))
                .andExpect(unauthenticated());
    }

    @Test
    @DisplayName("8. Utilisateur avec ROLE_USER peut accéder à /user/dashboard (HTTP 200)")
    @WithMockUser(username = "user", roles = {"USER"})
    void userCanAccessUserDashboard() throws Exception {
        mockMvc.perform(get("/user/dashboard"))
                .andExpect(status().isOk())
                .andExpect(view().name("user_dashboard"));
    }

    @Test
    @DisplayName("9. Utilisateur avec ROLE_USER reçoit un refus d'accès (Code HTTP 403 Forbidden)")
    @WithMockUser(username = "user", roles = {"USER"})
    void userCannotAccessAdminDashboard() throws Exception {
        mockMvc.perform(get("/admin/dashboard"))
                .andExpect(status().isForbidden())
                .andExpect(forwardedUrl("/access-denied"));
    }

    @Test
    @DisplayName("10. Administrateur avec ROLE_ADMIN peut accéder à /admin/dashboard (HTTP 200)")
    @WithMockUser(username = "admin", roles = {"ADMIN", "USER"})
    void adminCanAccessAdminDashboard() throws Exception {
        mockMvc.perform(get("/admin/dashboard"))
                .andExpect(status().isOk())
                .andExpect(view().name("admin_dashboard"));
    }

    @Test
    @DisplayName("11. Administrateur avec ROLE_ADMIN & ROLE_USER peut également accéder à /user/dashboard (HTTP 200)")
    @WithMockUser(username = "admin", roles = {"ADMIN", "USER"})
    void adminCanAccessUserDashboard() throws Exception {
        mockMvc.perform(get("/user/dashboard"))
                .andExpect(status().isOk())
                .andExpect(view().name("user_dashboard"));
    }

    @Test
    @DisplayName("12. Déconnexion invalide la session et redirige vers /login?logout=true")
    @WithMockUser(username = "user", roles = {"USER"})
    void logoutInvalidatesSessionAndRedirects() throws Exception {
        mockMvc.perform(logout())
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/login?logout=true"))
                .andExpect(unauthenticated());
    }

    @Test
    @DisplayName("13. Vérification du chiffrement BCrypt des mots de passe")
    void verifyBCryptPasswordEncoder() {
        String encoded1111 = passwordEncoder.encode("1111");
        String encoded1234 = passwordEncoder.encode("1234");

        assertTrue(passwordEncoder.matches("1111", encoded1111), "BCrypt doit valider le mot de passe 1111");
        assertTrue(passwordEncoder.matches("1234", encoded1234), "BCrypt doit valider le mot de passe 1234");
    }
}
