#!/bin/bash
# scan-all.sh — détection automatique des sous-projets par contenu

set -e

if [ -z "$SONAR_TOKEN" ]; then
    echo "ERREUR : la variable SONAR_TOKEN n'est pas définie."
    exit 1
fi

PROJETS_DIR="./epita-projects"
SONAR_URL="http://localhost:9000"

if [ ! -d "$PROJETS_DIR" ]; then
    echo "ERREUR : le répertoire $PROJETS_DIR n'existe pas."
    exit 1
fi

# Profondeur max de recherche des pom.xml / package.json
MAX_DEPTH=3

scan_backend_maven() {
    local dir="$1"
    local project_key="$2"
    
    echo ">> Scan backend Maven : $project_key ($(realpath --relative-to="$PWD" "$dir"))"
    
    docker run --rm \
        -v "$(realpath "$dir"):/usr/src" \
        -v "$HOME/.m2:/root/.m2" \
        -w /usr/src \
        maven:3.9-eclipse-temurin-21 \
        mvn -B clean compile test-compile -DskipTests || {
            echo "   ⚠ La compilation a échoué — scan Sonar annulé pour $project_key"
            return 1
        }
    
    docker run --rm \
        --network=host \
        -v "$(realpath "$dir"):/usr/src" \
        -v "$HOME/.m2:/root/.m2" \
        -w /usr/src \
        maven:3.9-eclipse-temurin-21 \
        mvn -B sonar:sonar \
            -Dsonar.host.url="$SONAR_URL" \
            -Dsonar.token="$SONAR_TOKEN" \
            -Dsonar.projectKey="$project_key" \
            -Dsonar.projectName="$project_key"
}

scan_frontend() {
    local dir="$1"
    local project_key="$2"
    
    echo ">> Scan frontend : $project_key ($(realpath --relative-to="$PWD" "$dir"))"
    
    docker run --rm \
        --network=host \
        -v "$(realpath "$dir"):/usr/src" \
        -e SONAR_HOST_URL="$SONAR_URL" \
        -e SONAR_TOKEN="$SONAR_TOKEN" \
        -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=$project_key -Dsonar.projectName=$project_key -Dsonar.sources=src -Dsonar.exclusions=**/node_modules/**,**/dist/**,**/*.spec.ts,**/*.test.ts" \
        sonarsource/sonar-scanner-cli
}

scan_generic() {
    local dir="$1"
    local project_key="$2"
    
    echo ">> Scan générique : $project_key"
    
    docker run --rm \
        --network=host \
        -v "$(realpath "$dir"):/usr/src" \
        -e SONAR_HOST_URL="$SONAR_URL" \
        -e SONAR_TOKEN="$SONAR_TOKEN" \
        -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=$project_key -Dsonar.projectName=$project_key -Dsonar.sources=. -Dsonar.exclusions=**/node_modules/**,**/dist/**,**/target/**,**/*.java" \
        sonarsource/sonar-scanner-cli
}

for dir in "$PROJETS_DIR"/*/; do
    equipe=$(basename "$dir")
    echo ""
    echo "=========================================="
    echo "=== $equipe"
    echo "=========================================="
    
    # Trouve tous les pom.xml à profondeur MAX_DEPTH, en excluant target/ et node_modules/
    mapfile -t pom_files < <(find "$dir" -maxdepth "$MAX_DEPTH" -name "pom.xml" \
        -not -path "*/target/*" -not -path "*/node_modules/*" 2>/dev/null)
    
    # Trouve tous les package.json qui sont vraiment des projets (pas des sous-deps)
    mapfile -t pkg_files < <(find "$dir" -maxdepth "$MAX_DEPTH" -name "package.json" \
        -not -path "*/node_modules/*" 2>/dev/null)
    
    # Normalise : on ne garde que les répertoires parents
    backend_dirs=()
    for pom in "${pom_files[@]}"; do
        backend_dirs+=("$(dirname "$pom")")
    done
    
    frontend_dirs=()
    for pkg in "${pkg_files[@]}"; do
        # Filtre : on ne veut pas les package.json de tooling (ceux sans "dependencies" ou "scripts")
        # Astuce : si le package.json est dans un dossier qui contient aussi un pom.xml, 
        # c'est probablement un wrapper, on skip
        pkg_dir="$(dirname "$pkg")"
        if [ ! -f "$pkg_dir/pom.xml" ]; then
            frontend_dirs+=("$pkg_dir")
        fi
    done
    
    echo "Détection : ${#backend_dirs[@]} backend(s) Maven, ${#frontend_dirs[@]} frontend(s)"
    for b in "${backend_dirs[@]}"; do echo "   - Maven  : $(realpath --relative-to="$PWD" "$b")"; done
    for f in "${frontend_dirs[@]}"; do echo "   - Front  : $(realpath --relative-to="$PWD" "$f")"; done
    
    # Scanne chaque backend Maven détecté
    if [ ${#backend_dirs[@]} -gt 0 ]; then
        for bdir in "${backend_dirs[@]}"; do
            # Clé de projet : nom du dossier si différent de l'équipe, sinon juste l'équipe
            sub=$(basename "$bdir")
            if [ "$sub" = "$equipe" ]; then
                key="${equipe}-backend"
            else
                key="${equipe}-${sub}"
            fi
            scan_backend_maven "$bdir" "$key" || echo "✗ backend $key échoué"
        done
    fi
    
    # Scanne chaque frontend détecté
    if [ ${#frontend_dirs[@]} -gt 0 ]; then
        for fdir in "${frontend_dirs[@]}"; do
            sub=$(basename "$fdir")
            if [ "$sub" = "$equipe" ]; then
                key="${equipe}-frontend"
            else
                key="${equipe}-${sub}"
            fi
            scan_frontend "$fdir" "$key" || echo "✗ frontend $key échoué"
        done
    fi
    
    # Aucun des deux détecté : fallback générique
    if [ ${#backend_dirs[@]} -eq 0 ] && [ ${#frontend_dirs[@]} -eq 0 ]; then
        echo "→ Aucun pom.xml ni package.json détecté, scan générique"
        scan_generic "$dir" "$equipe" || echo "✗ scan échoué"
    fi
done

echo ""
echo "=========================================="
echo "Tous les scans sont terminés."
echo "Résultats : $SONAR_URL"
echo "=========================================="
