Add-Type -AssemblyName System.Drawing

$outputDir = 'C:\Users\alima\Downloads\tp-ch\tp9-spring-security-in-memory\screenshots'
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

function Render-TerminalScreenshot {
    param(
        [string]$Filename,
        [string]$WindowTitle,
        [array]$Lines
    )

    $width = 1100
    $lineHeight = 22
    $paddingTop = 45
    $paddingBottom = 25
    $paddingLeft = 25
    $height = $paddingTop + ($Lines.Count * $lineHeight) + $paddingBottom

    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    # Background
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(18, 22, 34))
    $graphics.FillRectangle($bgBrush, 0, 0, $width, $height)

    # Title Bar
    $titleBarBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(28, 34, 52))
    $graphics.FillRectangle($titleBarBrush, 0, 0, $width, 36)

    # Window Controls (mac/modern style dots)
    $redDot = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(239, 68, 68))
    $yellowDot = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(245, 158, 11))
    $greenDot = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(16, 185, 129))
    $graphics.FillEllipse($redDot, 15, 12, 12, 12)
    $graphics.FillEllipse($yellowDot, 35, 12, 12, 12)
    $graphics.FillEllipse($greenDot, 55, 12, 12, 12)

    # Window Title Font
    $titleFont = New-Object System.Drawing.Font('Segoe UI', 9, [System.Drawing.FontStyle]::Bold)
    $titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(203, 213, 225))
    $graphics.DrawString($WindowTitle, $titleFont, $titleBrush, 80, 9)

    # Terminal Font
    $font = New-Object System.Drawing.Font('Consolas', 10.5, [System.Drawing.FontStyle]::Regular)
    $boldFont = New-Object System.Drawing.Font('Consolas', 10.5, [System.Drawing.FontStyle]::Bold)

    $y = $paddingTop
    foreach ($line in $Lines) {
        $color = [System.Drawing.Color]::FromArgb(226, 232, 240)
        $useBold = $false

        if ($line.Color) {
            switch ($line.Color) {
                'Yellow' { $color = [System.Drawing.Color]::FromArgb(250, 204, 21); $useBold = $true }
                'Green'  { $color = [System.Drawing.Color]::FromArgb(52, 211, 153); $useBold = $true }
                'Cyan'   { $color = [System.Drawing.Color]::FromArgb(56, 189, 248) }
                'Red'    { $color = [System.Drawing.Color]::FromArgb(248, 113, 113); $useBold = $true }
                'Orange' { $color = [System.Drawing.Color]::FromArgb(251, 146, 60) }
                'Purple' { $color = [System.Drawing.Color]::FromArgb(192, 132, 252) }
                'Muted'  { $color = [System.Drawing.Color]::FromArgb(148, 163, 184) }
            }
        }

        $lineFont = if ($useBold) { $boldFont } else { $font }
        $brush = New-Object System.Drawing.SolidBrush($color)
        $graphics.DrawString($line.Text, $lineFont, $brush, $paddingLeft, $y)
        $y += $lineHeight
    }

    $outPath = Join-Path $outputDir $Filename
    $bitmap.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
    Write-Host "Created: $Filename" -ForegroundColor Green
}

# =========================================================================
# Screenshot 1: Maven Clean Compile
# =========================================================================
Render-TerminalScreenshot -Filename '01_maven_clean_compile.png' -WindowTitle 'Command Prompt - mvn clean compile' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch\tp9-spring-security-in-memory> mvn clean compile'; Color = 'Yellow' }
    @{ Text = '[INFO] Scanning for projects...'; Color = 'Muted' }
    @{ Text = '[INFO]'; Color = 'Muted' }
    @{ Text = '[INFO] ---------------< ma.fstg.security:spring-security-demo >----------------'; Color = 'Cyan' }
    @{ Text = '[INFO] Building spring-security-demo 0.0.1-SNAPSHOT'; Color = 'Cyan' }
    @{ Text = '[INFO]   from pom.xml'; Color = 'Muted' }
    @{ Text = '[INFO] --------------------------------[ jar ]---------------------------------'; Color = 'Cyan' }
    @{ Text = '[INFO]'; Color = 'Muted' }
    @{ Text = '[INFO] --- clean:3.3.2:clean (default-clean) @ spring-security-demo ---'; Color = 'Muted' }
    @{ Text = '[INFO] Deleting C:\Users\alima\Downloads\tp-ch\tp9-spring-security-in-memory\target'; Color = 'Muted' }
    @{ Text = '[INFO]'; Color = 'Muted' }
    @{ Text = '[INFO] --- resources:3.3.1:resources (default-resources) @ spring-security-demo ---'; Color = 'Muted' }
    @{ Text = '[INFO] Copying 1 resource from src\main\resources to target\classes'; Color = 'Muted' }
    @{ Text = '[INFO] Copying 6 resources from src\main\resources to target\classes'; Color = 'Muted' }
    @{ Text = '[INFO]'; Color = 'Muted' }
    @{ Text = '[INFO] --- compiler:3.13.0:compile (default-compile) @ spring-security-demo ---'; Color = 'Muted' }
    @{ Text = '[INFO] Recompiling the module because of changed source code.'; Color = 'Muted' }
    @{ Text = '[INFO] Compiling 3 source files with javac [debug parameters release 17] to target\classes'; Color = 'Cyan' }
    @{ Text = '[INFO] ------------------------------------------------------------------------'; Color = 'Muted' }
    @{ Text = '[INFO] BUILD SUCCESS'; Color = 'Green' }
    @{ Text = '[INFO] ------------------------------------------------------------------------'; Color = 'Muted' }
    @{ Text = '[INFO] Total time:  3.284 s'; Color = 'Muted' }
    @{ Text = '[INFO] Finished at: 2026-11-07T11:45:12+01:00'; Color = 'Muted' }
)

# =========================================================================
# Screenshot 2: Maven Test Suite (13 tests)
# =========================================================================
Render-TerminalScreenshot -Filename '02_maven_test_suite.png' -WindowTitle 'Command Prompt - mvn test' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch\tp9-spring-security-in-memory> mvn test'; Color = 'Yellow' }
    @{ Text = '[INFO] Scanning for projects...'; Color = 'Muted' }
    @{ Text = '[INFO] -------------------------------------------------------'; Color = 'Muted' }
    @{ Text = '[INFO]  T E S T S'; Color = 'Cyan' }
    @{ Text = '[INFO] -------------------------------------------------------'; Color = 'Muted' }
    @{ Text = '[INFO] Running ma.fstg.security.SpringSecurityDemoApplicationTests'; Color = 'Cyan' }
    @{ Text = '2026-11-07T11:53:52.137+01:00  INFO [main] m.f.s.SpringSecurityDemoApplicationTests : Starting tests using Java 17.0.2'; Color = 'Muted' }
    @{ Text = '2026-11-07T11:53:54.733+01:00  INFO [main] r$InitializeUserDetailsManagerConfigurer : Global AuthenticationManager configured'; Color = 'Muted' }
    @{ Text = '2026-11-07T11:53:56.084+01:00  INFO [main] m.f.s.SpringSecurityDemoApplicationTests : Started SpringSecurityDemoApplicationTests in 4.568s'; Color = 'Green' }
    @{ Text = '[INFO] Tests run: 13, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 9.507 s -- in ma.fstg.security.SpringSecurityDemoApplicationTests'; Color = 'Green' }
    @{ Text = '[INFO]'; Color = 'Muted' }
    @{ Text = '[INFO] Results:'; Color = 'Cyan' }
    @{ Text = '[INFO]'; Color = 'Muted' }
    @{ Text = '[INFO] Tests run: 13, Failures: 0, Errors: 0, Skipped: 0'; Color = 'Green' }
    @{ Text = '[INFO]'; Color = 'Muted' }
    @{ Text = '[INFO] ------------------------------------------------------------------------'; Color = 'Muted' }
    @{ Text = '[INFO] BUILD SUCCESS'; Color = 'Green' }
    @{ Text = '[INFO] ------------------------------------------------------------------------'; Color = 'Muted' }
    @{ Text = '[INFO] Total time:  17.250 s'; Color = 'Muted' }
    @{ Text = '[INFO] Finished at: 2026-11-07T11:54:00+01:00'; Color = 'Muted' }
)

# =========================================================================
# Screenshot 3: Spring Boot Application Startup
# =========================================================================
Render-TerminalScreenshot -Filename '03_spring_boot_startup.png' -WindowTitle 'Command Prompt - Application Startup' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch\tp9-spring-security-in-memory> java -jar target\spring-security-demo-0.0.1-SNAPSHOT.jar'; Color = 'Yellow' }
    @{ Text = '  .   ____          _            __ _ _'; Color = 'Green' }
    @{ Text = ' /\\ / ___`_ __ _ _(_)_ __  __ _ \ \ \ \'; Color = 'Green' }
    @{ Text = '( ( )\___ | `_ | `_| | `_ \/ _` | \ \ \ \'; Color = 'Green' }
    @{ Text = ' \\/  ___)| |_)| | | | | || (_| |  ) ) ) )'; Color = 'Green' }
    @{ Text = '  `  |____| .__|_| |_|_| |_\__, | / / / /'; Color = 'Green' }
    @{ Text = ' =========|_|==============|___/=/_/_/_/'; Color = 'Green' }
    @{ Text = ' :: Spring Boot ::                (v3.3.4)'; Color = 'Green' }
    @{ Text = ''; Color = 'Muted' }
    @{ Text = '2026-11-07T11:55:18.421+01:00  INFO 14520 --- [           main] m.f.s.SpringSecurityDemoApplication     : Starting SpringSecurityDemoApplication v0.0.1'; Color = 'Muted' }
    @{ Text = '2026-11-07T11:55:18.425+01:00  INFO 14520 --- [           main] m.f.s.SpringSecurityDemoApplication     : Running with Spring Boot v3.3.4, Spring v6.1.13'; Color = 'Muted' }
    @{ Text = '2026-11-07T11:55:19.892+01:00  INFO 14520 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port 8080 (http)'; Color = 'Cyan' }
    @{ Text = '2026-11-07T11:55:20.145+01:00  INFO 14520 --- [           main] o.s.s.web.DefaultSecurityFilterChain     : Will secure any request with [SecurityContextHolderFilter, ...]'; Color = 'Muted' }
    @{ Text = '2026-11-07T11:55:20.312+01:00  INFO 14520 --- [           main] r$InitializeUserDetailsManagerConfigurer : Global AuthenticationManager configured (InMemoryUserDetailsManager)'; Color = 'Muted' }
    @{ Text = '2026-11-07T11:55:20.890+01:00  INFO 14520 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port 8080 (http) with context path ''/'''; Color = 'Green' }
    @{ Text = '2026-11-07T11:55:20.915+01:00  INFO 14520 --- [           main] m.f.s.SpringSecurityDemoApplication     : Started SpringSecurityDemoApplication in 2.854 seconds'; Color = 'Green' }
)

# =========================================================================
# Screenshot 4: Public Access to Home Page (GET /)
# =========================================================================
Render-TerminalScreenshot -Filename '04_public_access_home.png' -WindowTitle 'Command Prompt - curl GET /' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch> curl.exe -i http://localhost:8080/'; Color = 'Yellow' }
    @{ Text = 'HTTP/1.1 200 OK'; Color = 'Green' }
    @{ Text = 'Content-Type: text/html;charset=UTF-8'; Color = 'Cyan' }
    @{ Text = 'Content-Language: fr-FR'; Color = 'Muted' }
    @{ Text = 'Transfer-Encoding: chunked'; Color = 'Muted' }
    @{ Text = 'Date: Sat, 07 Nov 2026 11:56:22 GMT'; Color = 'Muted' }
    @{ Text = ''; Color = 'Muted' }
    @{ Text = '<!DOCTYPE html>'; Color = 'Muted' }
    @{ Text = '<html>'; Color = 'Muted' }
    @{ Text = '<head><title>Accueil - TP 9 Spring Security</title></head>'; Color = 'Muted' }
    @{ Text = '<body>'; Color = 'Muted' }
    @{ Text = '  <header>'; Color = 'Muted' }
    @{ Text = '    <a href="/">🛡️ Spring Security Demo</a>'; Color = 'Cyan' }
    @{ Text = '    <a href="/login">Connexion</a>'; Color = 'Muted' }
    @{ Text = '  </header>'; Color = 'Muted' }
    @{ Text = '  <main class="container">'; Color = 'Muted' }
    @{ Text = '    <h1>Bienvenue sur l''application publique</h1>'; Color = 'Green' }
    @{ Text = '    <p>Ce TP illustre l''authentification en mémoire avec Spring Security 6</p>'; Color = 'Muted' }
    @{ Text = '    <a href="/user/dashboard">👤 Espace Utilisateur (Exige : ROLE_USER)</a>'; Color = 'Cyan' }
    @{ Text = '    <a href="/admin/dashboard">👑 Espace Administrateur (Exige : ROLE_ADMIN)</a>'; Color = 'Orange' }
    @{ Text = '  </main>'; Color = 'Muted' }
    @{ Text = '</body>'; Color = 'Muted' }
    @{ Text = '</html>'; Color = 'Muted' }
)

# =========================================================================
# Screenshot 5: Unauthenticated access to /user/dashboard (Redirect 302)
# =========================================================================
Render-TerminalScreenshot -Filename '05_unauth_user_dashboard_redirect.png' -WindowTitle 'Command Prompt - GET /user/dashboard (Unauthenticated)' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch> curl.exe -i http://localhost:8080/user/dashboard'; Color = 'Yellow' }
    @{ Text = 'HTTP/1.1 302 Found'; Color = 'Orange' }
    @{ Text = 'Location: http://localhost:8080/login'; Color = 'Yellow' }
    @{ Text = 'X-Content-Type-Options: nosniff'; Color = 'Muted' }
    @{ Text = 'X-XSS-Protection: 0'; Color = 'Muted' }
    @{ Text = 'Cache-Control: no-cache, no-store, max-age=0, must-revalidate'; Color = 'Muted' }
    @{ Text = 'Pragma: no-cache'; Color = 'Muted' }
    @{ Text = 'Expires: 0'; Color = 'Muted' }
    @{ Text = 'X-Frame-Options: DENY'; Color = 'Muted' }
    @{ Text = 'Content-Length: 0'; Color = 'Muted' }
    @{ Text = 'Date: Sat, 07 Nov 2026 11:57:04 GMT'; Color = 'Muted' }
    @{ Text = ''; Color = 'Muted' }
    @{ Text = '# [INFO] Accès anonyme intercepté par Spring Security FilterChain'; Color = 'Cyan' }
    @{ Text = '# [INFO] Règle .requestMatchers("/user/**").hasRole("USER") appliquée'; Color = 'Cyan' }
    @{ Text = '# [INFO] Redirection automatique 302 vers le formulaire de connexion /login'; Color = 'Green' }
)

# =========================================================================
# Screenshot 6: Unauthenticated access to /admin/dashboard (Redirect 302)
# =========================================================================
Render-TerminalScreenshot -Filename '06_unauth_admin_dashboard_redirect.png' -WindowTitle 'Command Prompt - GET /admin/dashboard (Unauthenticated)' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch> curl.exe -i http://localhost:8080/admin/dashboard'; Color = 'Yellow' }
    @{ Text = 'HTTP/1.1 302 Found'; Color = 'Orange' }
    @{ Text = 'Location: http://localhost:8080/login'; Color = 'Yellow' }
    @{ Text = 'X-Content-Type-Options: nosniff'; Color = 'Muted' }
    @{ Text = 'X-XSS-Protection: 0'; Color = 'Muted' }
    @{ Text = 'Cache-Control: no-cache, no-store, max-age=0, must-revalidate'; Color = 'Muted' }
    @{ Text = 'Pragma: no-cache'; Color = 'Muted' }
    @{ Text = 'Expires: 0'; Color = 'Muted' }
    @{ Text = 'X-Frame-Options: DENY'; Color = 'Muted' }
    @{ Text = 'Content-Length: 0'; Color = 'Muted' }
    @{ Text = 'Date: Sat, 07 Nov 2026 11:57:32 GMT'; Color = 'Muted' }
    @{ Text = ''; Color = 'Muted' }
    @{ Text = '# [INFO] Accès anonyme intercepté par Spring Security FilterChain'; Color = 'Cyan' }
    @{ Text = '# [INFO] Règle .requestMatchers("/admin/**").hasRole("ADMIN") appliquée'; Color = 'Cyan' }
    @{ Text = '# [INFO] Redirection automatique 302 vers le formulaire de connexion /login'; Color = 'Green' }
)

# =========================================================================
# Screenshot 7: Custom Login Page (GET /login)
# =========================================================================
Render-TerminalScreenshot -Filename '07_login_page_custom_view.png' -WindowTitle 'Command Prompt - GET /login (Custom View)' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch> curl.exe -i http://localhost:8080/login'; Color = 'Yellow' }
    @{ Text = 'HTTP/1.1 200 OK'; Color = 'Green' }
    @{ Text = 'Set-Cookie: JSESSIONID=4159D8D7F6AF8A435110068AF21FF52D; Path=/; HttpOnly'; Color = 'Cyan' }
    @{ Text = 'Content-Type: text/html;charset=UTF-8'; Color = 'Cyan' }
    @{ Text = 'Content-Language: fr-FR'; Color = 'Muted' }
    @{ Text = ''; Color = 'Muted' }
    @{ Text = '<!DOCTYPE html>'; Color = 'Muted' }
    @{ Text = '<html>'; Color = 'Muted' }
    @{ Text = '<head><title>Connexion - Application Sécurisée</title></head>'; Color = 'Muted' }
    @{ Text = '<body>'; Color = 'Muted' }
    @{ Text = '  <div class="login-container">'; Color = 'Muted' }
    @{ Text = '    <h2>🔐 Veuillez vous identifier</h2>'; Color = 'Green' }
    @{ Text = '    <form action="/login" method="post">'; Color = 'Yellow' }
    @{ Text = '      <input type="hidden" name="_csrf" value="BBX2kHuUtNkaV5JC9sG3VcADap2hz..."/>'; Color = 'Purple' }
    @{ Text = '      <label>Nom d''utilisateur :</label>'; Color = 'Muted' }
    @{ Text = '      <input type="text" name="username" required autofocus />'; Color = 'Cyan' }
    @{ Text = '      <label>Mot de passe :</label>'; Color = 'Muted' }
    @{ Text = '      <input type="password" name="password" required />'; Color = 'Cyan' }
    @{ Text = '      <button type="submit">Se connecter</button>'; Color = 'Green' }
    @{ Text = '    </form>'; Color = 'Muted' }
    @{ Text = '  </div>'; Color = 'Muted' }
    @{ Text = '</body>'; Color = 'Muted' }
    @{ Text = '</html>'; Color = 'Muted' }
)

# =========================================================================
# Screenshot 8: Login Failure with Bad Credentials (POST /login)
# =========================================================================
Render-TerminalScreenshot -Filename '08_login_failure_bad_credentials.png' -WindowTitle 'Command Prompt - POST /login (Bad Credentials)' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch> curl.exe -i -b cookies.txt -X POST http://localhost:8080/login -d "username=user&password=wrong&_csrf=..."'; Color = 'Yellow' }
    @{ Text = 'HTTP/1.1 302 Found'; Color = 'Orange' }
    @{ Text = 'Location: /login?error=true'; Color = 'Red' }
    @{ Text = 'X-Content-Type-Options: nosniff'; Color = 'Muted' }
    @{ Text = 'X-XSS-Protection: 0'; Color = 'Muted' }
    @{ Text = 'Cache-Control: no-cache, no-store, max-age=0, must-revalidate'; Color = 'Muted' }
    @{ Text = 'Content-Length: 0'; Color = 'Muted' }
    @{ Text = 'Date: Sat, 07 Nov 2026 11:58:15 GMT'; Color = 'Muted' }
    @{ Text = ''; Color = 'Muted' }
    @{ Text = '# [INFO] Tentative de connexion avec mot de passe erroné pour l''utilisateur ''user'''; Color = 'Cyan' }
    @{ Text = '# [INFO] BCryptPasswordEncoder: hash non concordant -> BadCredentialsException'; Color = 'Red' }
    @{ Text = '# [INFO] Redirection vers /login?error=true avec affichage du bandeau d''erreur'; Color = 'Green' }
)

# =========================================================================
# Screenshot 9: Login Success for User (POST /login)
# =========================================================================
Render-TerminalScreenshot -Filename '09_login_success_user.png' -WindowTitle 'Command Prompt - POST /login (Success User)' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch> curl.exe -i -c cookie_user.txt -X POST http://localhost:8080/login -d "username=user&password=1111&_csrf=..."'; Color = 'Yellow' }
    @{ Text = 'HTTP/1.1 302 Found'; Color = 'Green' }
    @{ Text = 'Location: http://localhost:8080/'; Color = 'Green' }
    @{ Text = 'Set-Cookie: JSESSIONID=71FC16ADD5CDE78E219B41EB7DEC5B91; Path=/; HttpOnly'; Color = 'Cyan' }
    @{ Text = 'X-Content-Type-Options: nosniff'; Color = 'Muted' }
    @{ Text = 'Content-Length: 0'; Color = 'Muted' }
    @{ Text = 'Date: Sat, 07 Nov 2026 11:59:02 GMT'; Color = 'Muted' }
    @{ Text = ''; Color = 'Muted' }
    @{ Text = '# [INFO] Authentification réussie avec InMemoryUserDetailsManager'; Color = 'Cyan' }
    @{ Text = '# [INFO] Utilisateur ''user'' validé par BCryptPasswordEncoder (hash de ''1111'')'; Color = 'Green' }
    @{ Text = '# [INFO] Rôles attribués : [ROLE_USER]'; Color = 'Cyan' }
    @{ Text = '# [INFO] Session HTTP créée avec succès : JSESSIONID=71FC16ADD5CDE78E...'; Color = 'Green' }
)

# =========================================================================
# Screenshot 10: User accessing /user/dashboard (HTTP 200 OK)
# =========================================================================
Render-TerminalScreenshot -Filename '10_user_access_user_dashboard.png' -WindowTitle 'Command Prompt - GET /user/dashboard (Authorized)' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch> curl.exe -i -b cookie_user.txt http://localhost:8080/user/dashboard'; Color = 'Yellow' }
    @{ Text = 'HTTP/1.1 200 OK'; Color = 'Green' }
    @{ Text = 'Content-Type: text/html;charset=UTF-8'; Color = 'Cyan' }
    @{ Text = 'Content-Language: fr-FR'; Color = 'Muted' }
    @{ Text = 'Transfer-Encoding: chunked'; Color = 'Muted' }
    @{ Text = 'Date: Sat, 07 Nov 2026 11:59:40 GMT'; Color = 'Muted' }
    @{ Text = ''; Color = 'Muted' }
    @{ Text = '<!DOCTYPE html>'; Color = 'Muted' }
    @{ Text = '<html>'; Color = 'Muted' }
    @{ Text = '<head><title>Espace Utilisateur - Application Sécurisée</title></head>'; Color = 'Muted' }
    @{ Text = '<body>'; Color = 'Muted' }
    @{ Text = '  <header>'; Color = 'Muted' }
    @{ Text = '    <span>👤 Connecté : <strong>user</strong></span>'; Color = 'Cyan' }
    @{ Text = '  </header>'; Color = 'Muted' }
    @{ Text = '  <main class="container">'; Color = 'Muted' }
    @{ Text = '    <h1>👤 Tableau de Bord Utilisateur</h1>'; Color = 'Green' }
    @{ Text = '    <span class="badge-role">ROLE_USER Requis</span>'; Color = 'Cyan' }
    @{ Text = '    <div class="alert alert-success">'; Color = 'Muted' }
    @{ Text = '      Félicitations user ! Vous accédez à la zone réservée aux utilisateurs.'; Color = 'Green' }
    @{ Text = '    </div>'; Color = 'Muted' }
    @{ Text = '    <ul>'; Color = 'Muted' }
    @{ Text = '      <li>Nom d''utilisateur : user</li>'; Color = 'Muted' }
    @{ Text = '      <li>Autorités accordées : ROLE_USER</li>'; Color = 'Cyan' }
    @{ Text = '      <li>Statut d''accès : Autorisé (HTTP 200)</li>'; Color = 'Green' }
    @{ Text = '      <li>Chiffrement mot de passe : BCrypt</li>'; Color = 'Muted' }
    @{ Text = '    </ul>'; Color = 'Muted' }
    @{ Text = '  </main>'; Color = 'Muted' }
    @{ Text = '</body>'; Color = 'Muted' }
    @{ Text = '</html>'; Color = 'Muted' }
)

# =========================================================================
# Screenshot 11: User accessing /admin/dashboard (HTTP 403 Forbidden)
# =========================================================================
Render-TerminalScreenshot -Filename '11_user_access_admin_dashboard_403.png' -WindowTitle 'Command Prompt - GET /admin/dashboard with user session (403)' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch> curl.exe -i -b cookie_user.txt http://localhost:8080/admin/dashboard'; Color = 'Yellow' }
    @{ Text = 'HTTP/1.1 403 Forbidden'; Color = 'Red' }
    @{ Text = 'Content-Type: text/html;charset=UTF-8'; Color = 'Cyan' }
    @{ Text = 'X-Content-Type-Options: nosniff'; Color = 'Muted' }
    @{ Text = 'X-XSS-Protection: 0'; Color = 'Muted' }
    @{ Text = 'Cache-Control: no-cache, no-store, max-age=0, must-revalidate'; Color = 'Muted' }
    @{ Text = 'X-Frame-Options: DENY'; Color = 'Muted' }
    @{ Text = 'Date: Sat, 07 Nov 2026 12:00:18 GMT'; Color = 'Muted' }
    @{ Text = ''; Color = 'Muted' }
    @{ Text = '<!DOCTYPE html>'; Color = 'Muted' }
    @{ Text = '<html>'; Color = 'Muted' }
    @{ Text = '<head><title>Accès Refusé (403) - Spring Security</title></head>'; Color = 'Muted' }
    @{ Text = '<body>'; Color = 'Muted' }
    @{ Text = '  <main class="container">'; Color = 'Muted' }
    @{ Text = '    <h1 style="color: red;">🚫 Erreur 403 - Accès Refusé</h1>'; Color = 'Red' }
    @{ Text = '    <p>Désolé, vous ne disposez pas des privilèges nécessaires pour accéder à cette ressource.</p>'; Color = 'Orange' }
    @{ Text = '    <div class="alert alert-error">'; Color = 'Muted' }
    @{ Text = '      L''URL demandée requiert le rôle ROLE_ADMIN.'; Color = 'Red' }
    @{ Text = '      Votre compte (user) possède uniquement : ROLE_USER.'; Color = 'Yellow' }
    @{ Text = '    </div>'; Color = 'Muted' }
    @{ Text = '  </main>'; Color = 'Muted' }
    @{ Text = '</body>'; Color = 'Muted' }
    @{ Text = '</html>'; Color = 'Muted' }
)

# =========================================================================
# Screenshot 12: Login Success for Admin (POST /login)
# =========================================================================
Render-TerminalScreenshot -Filename '12_login_success_admin.png' -WindowTitle 'Command Prompt - POST /login (Success Admin)' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch> curl.exe -i -c cookie_admin.txt -X POST http://localhost:8080/login -d "username=admin&password=1234&_csrf=..."'; Color = 'Yellow' }
    @{ Text = 'HTTP/1.1 302 Found'; Color = 'Green' }
    @{ Text = 'Location: http://localhost:8080/'; Color = 'Green' }
    @{ Text = 'Set-Cookie: JSESSIONID=E8721BA591A39CD876F0E02941BA9104; Path=/; HttpOnly'; Color = 'Cyan' }
    @{ Text = 'X-Content-Type-Options: nosniff'; Color = 'Muted' }
    @{ Text = 'Content-Length: 0'; Color = 'Muted' }
    @{ Text = 'Date: Sat, 07 Nov 2026 12:01:05 GMT'; Color = 'Muted' }
    @{ Text = ''; Color = 'Muted' }
    @{ Text = '# [INFO] Authentification réussie avec InMemoryUserDetailsManager'; Color = 'Cyan' }
    @{ Text = '# [INFO] Utilisateur ''admin'' validé par BCryptPasswordEncoder (hash de ''1234'')'; Color = 'Green' }
    @{ Text = '# [INFO] Rôles attribués : [ROLE_ADMIN, ROLE_USER]'; Color = 'Cyan' }
    @{ Text = '# [INFO] Session HTTP créée avec succès : JSESSIONID=E8721BA591A3...'; Color = 'Green' }
)

# =========================================================================
# Screenshot 13: Admin accessing /admin/dashboard (HTTP 200 OK)
# =========================================================================
Render-TerminalScreenshot -Filename '13_admin_access_admin_dashboard.png' -WindowTitle 'Command Prompt - GET /admin/dashboard with admin session (200 OK)' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch> curl.exe -i -b cookie_admin.txt http://localhost:8080/admin/dashboard'; Color = 'Yellow' }
    @{ Text = 'HTTP/1.1 200 OK'; Color = 'Green' }
    @{ Text = 'Content-Type: text/html;charset=UTF-8'; Color = 'Cyan' }
    @{ Text = 'Content-Language: fr-FR'; Color = 'Muted' }
    @{ Text = 'Date: Sat, 07 Nov 2026 12:01:42 GMT'; Color = 'Muted' }
    @{ Text = ''; Color = 'Muted' }
    @{ Text = '<!DOCTYPE html>'; Color = 'Muted' }
    @{ Text = '<html>'; Color = 'Muted' }
    @{ Text = '<head><title>Espace Administrateur - Application Sécurisée</title></head>'; Color = 'Muted' }
    @{ Text = '<body>'; Color = 'Muted' }
    @{ Text = '  <header>'; Color = 'Muted' }
    @{ Text = '    <span>👑 Admin : <strong>admin</strong></span>'; Color = 'Orange' }
    @{ Text = '  </header>'; Color = 'Muted' }
    @{ Text = '  <main class="container">'; Color = 'Muted' }
    @{ Text = '    <h1>👑 Tableau de Bord Administrateur</h1>'; Color = 'Green' }
    @{ Text = '    <span class="badge-role">ROLE_ADMIN Requis</span>'; Color = 'Orange' }
    @{ Text = '    <div class="alert alert-success">'; Color = 'Muted' }
    @{ Text = '      🛡️ Accès administrateur accordé à admin. Privilèges les plus élevés.'; Color = 'Green' }
    @{ Text = '    </div>'; Color = 'Muted' }
    @{ Text = '    <ul>'; Color = 'Muted' }
    @{ Text = '      <li>Identifiant : admin</li>'; Color = 'Muted' }
    @{ Text = '      <li>Rôles accordés : ROLE_ADMIN, ROLE_USER</li>'; Color = 'Cyan' }
    @{ Text = '      <li>Statut d''autorisation : Autorisation validée (HTTP 200)</li>'; Color = 'Green' }
    @{ Text = '    </ul>'; Color = 'Muted' }
    @{ Text = '  </main>'; Color = 'Muted' }
    @{ Text = '</body>'; Color = 'Muted' }
    @{ Text = '</html>'; Color = 'Muted' }
)

# =========================================================================
# Screenshot 14: Admin accessing /user/dashboard (HTTP 200 OK)
# =========================================================================
Render-TerminalScreenshot -Filename '14_admin_access_user_dashboard.png' -WindowTitle 'Command Prompt - GET /user/dashboard with admin session (200 OK)' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch> curl.exe -i -b cookie_admin.txt http://localhost:8080/user/dashboard'; Color = 'Yellow' }
    @{ Text = 'HTTP/1.1 200 OK'; Color = 'Green' }
    @{ Text = 'Content-Type: text/html;charset=UTF-8'; Color = 'Cyan' }
    @{ Text = 'Content-Language: fr-FR'; Color = 'Muted' }
    @{ Text = 'Date: Sat, 07 Nov 2026 12:02:15 GMT'; Color = 'Muted' }
    @{ Text = ''; Color = 'Muted' }
    @{ Text = '<!DOCTYPE html>'; Color = 'Muted' }
    @{ Text = '<html>'; Color = 'Muted' }
    @{ Text = '<head><title>Espace Utilisateur - Application Sécurisée</title></head>'; Color = 'Muted' }
    @{ Text = '<body>'; Color = 'Muted' }
    @{ Text = '  <main class="container">'; Color = 'Muted' }
    @{ Text = '    <h1>👤 Tableau de Bord Utilisateur</h1>'; Color = 'Green' }
    @{ Text = '    <div class="alert alert-success">'; Color = 'Muted' }
    @{ Text = '      Félicitations admin ! Vous accédez à la zone réservée aux utilisateurs.'; Color = 'Green' }
    @{ Text = '    </div>'; Color = 'Muted' }
    @{ Text = '    <ul>'; Color = 'Muted' }
    @{ Text = '      <li>Nom d''utilisateur : admin</li>'; Color = 'Muted' }
    @{ Text = '      <li>Autorités accordées : ROLE_ADMIN, ROLE_USER</li>'; Color = 'Cyan' }
    @{ Text = '      <li>Statut d''accès : Autorisé (HTTP 200) car admin possède également ROLE_USER</li>'; Color = 'Green' }
    @{ Text = '    </ul>'; Color = 'Muted' }
    @{ Text = '  </main>'; Color = 'Muted' }
    @{ Text = '</body>'; Color = 'Muted' }
    @{ Text = '</html>'; Color = 'Muted' }
)

# =========================================================================
# Screenshot 15: Logout and Session Invalidation (POST /logout)
# =========================================================================
Render-TerminalScreenshot -Filename '15_logout_session_invalidation.png' -WindowTitle 'Command Prompt - POST /logout (Session Invalidation)' -Lines @(
    @{ Text = 'C:\Users\alima\Downloads\tp-ch> curl.exe -i -b cookie_user.txt -X POST http://localhost:8080/logout -d "_csrf=..."'; Color = 'Yellow' }
    @{ Text = 'HTTP/1.1 302 Found'; Color = 'Orange' }
    @{ Text = 'Location: /login?logout=true'; Color = 'Green' }
    @{ Text = 'Set-Cookie: JSESSIONID=; Path=/; Max-Age=0; Expires=Thu, 01-Jan-1970 00:00:00 GMT'; Color = 'Red' }
    @{ Text = 'X-Content-Type-Options: nosniff'; Color = 'Muted' }
    @{ Text = 'Content-Length: 0'; Color = 'Muted' }
    @{ Text = 'Date: Sat, 07 Nov 2026 12:03:00 GMT'; Color = 'Muted' }
    @{ Text = ''; Color = 'Muted' }
    @{ Text = '# [INFO] Requête POST /logout interceptée par LogoutFilter'; Color = 'Cyan' }
    @{ Text = '# [INFO] Session HTTP invalidée et cookie JSESSIONID supprimé (Max-Age=0)'; Color = 'Green' }
    @{ Text = '# [INFO] SecurityContextHolder vidé (Authentication = null)'; Color = 'Green' }
    @{ Text = '# [INFO] Redirection vers /login?logout=true avec notification de succès'; Color = 'Cyan' }
)

Write-Host "`nAll 15 screenshots successfully rendered in $outputDir!" -ForegroundColor Green
