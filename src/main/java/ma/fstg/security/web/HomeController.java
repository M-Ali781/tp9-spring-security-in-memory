package ma.fstg.security.web;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.stream.Collectors;

@Controller
public class HomeController {

    /**
     * Page d'accueil publique (accessible à tous)
     */
    @GetMapping("/")
    public String index(Authentication authentication, Model model) {
        populateAuthInfo(authentication, model);
        return "index";
    }

    /**
     * Espace utilisateur (nécessite le rôle USER)
     */
    @GetMapping("/user/dashboard")
    public String userDashboard(Authentication authentication, Model model) {
        populateAuthInfo(authentication, model);
        return "user_dashboard";
    }

    /**
     * Espace administrateur (nécessite le rôle ADMIN)
     */
    @GetMapping("/admin/dashboard")
    public String adminDashboard(Authentication authentication, Model model) {
        populateAuthInfo(authentication, model);
        return "admin_dashboard";
    }

    /**
     * Formulaire personnalisé de connexion (Étape 8)
     */
    @GetMapping("/login")
    public String login(Authentication authentication) {
        // Si l'utilisateur est déjà authentifié, rediriger vers l'accueil
        if (authentication != null && authentication.isAuthenticated() && !authentication.getPrincipal().equals("anonymousUser")) {
            return "redirect:/";
        }
        return "login";
    }

    /**
     * Page d'erreur personnalisée pour accès refusé (Code 403)
     */
    @GetMapping("/access-denied")
    public String accessDenied(Authentication authentication, Model model) {
        populateAuthInfo(authentication, model);
        return "access_denied";
    }

    private void populateAuthInfo(Authentication authentication, Model model) {
        if (authentication != null && authentication.isAuthenticated() && !authentication.getPrincipal().equals("anonymousUser")) {
            model.addAttribute("authenticated", true);
            model.addAttribute("username", authentication.getName());
            String roles = authentication.getAuthorities().stream()
                    .map(GrantedAuthority::getAuthority)
                    .collect(Collectors.joining(", "));
            model.addAttribute("roles", roles);
        } else {
            model.addAttribute("authenticated", false);
        }
    }
}

