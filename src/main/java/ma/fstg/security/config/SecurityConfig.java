package ma.fstg.security.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    /**
     * Configuration de la chaîne de filtres de sécurité Spring Security 6 / Spring Boot 3
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                // Ressources publiques accessibles sans authentification
                .requestMatchers("/", "/login", "/access-denied", "/css/**", "/images/**", "/js/**").permitAll()
                // Espace utilisateur : réservé aux utilisateurs ayant le rôle USER
                .requestMatchers("/user/**").hasRole("USER")
                // Espace administrateur : réservé aux utilisateurs ayant le rôle ADMIN
                .requestMatchers("/admin/**").hasRole("ADMIN")
                // Toute autre requête nécessite d'être authentifié
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .defaultSuccessUrl("/", false)
                .failureUrl("/login?error=true")
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login?logout=true")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            )
            .exceptionHandling(ex -> ex
                .accessDeniedPage("/access-denied")
            );

        return http.build();
    }

    /**
     * Bean pour l'encodage des mots de passe avec l'algorithme BCrypt (Étape 7)
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * Configuration des utilisateurs en mémoire avec mots de passe hashés par BCrypt (Étape 6 & 7)
     */
    @Bean
    public UserDetailsService userDetailsService(PasswordEncoder passwordEncoder) {
        // Utilisateur standard avec rôle USER
        UserDetails user = User.builder()
                .username("user")
                .password(passwordEncoder.encode("1111"))
                .roles("USER")
                .build();

        // Administrateur avec les rôles ADMIN et USER
        UserDetails admin = User.builder()
                .username("admin")
                .password(passwordEncoder.encode("1234"))
                .roles("ADMIN", "USER")
                .build();

        return new InMemoryUserDetailsManager(user, admin);
    }
}

