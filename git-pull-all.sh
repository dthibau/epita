#!/bin/bash

# git-pull-all.sh
# Parcourt un répertoire et effectue un git pull sur chaque dépôt trouvé

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Répertoire cible (par défaut : répertoire courant)
TARGET_DIR="${1:-.}"

# Vérification que le répertoire existe
if [ ! -d "$TARGET_DIR" ]; then
  echo -e "${RED}Erreur : le répertoire '$TARGET_DIR' n'existe pas.${NC}"
  exit 1
fi

TARGET_DIR="$(realpath "$TARGET_DIR")"
echo -e "${BLUE}🔍 Recherche de dépôts Git dans : $TARGET_DIR${NC}\n"

# Compteurs
count_ok=0
count_err=0
count_total=0

# Recherche de tous les dossiers .git
while IFS= read -r git_dir; do
  repo_dir="$(dirname "$git_dir")"
  repo_name="$(basename "$repo_dir")"
  count_total=$((count_total + 1))

  echo -e "${YELLOW}📁 $repo_name${NC} (${repo_dir})"

  # Lancement du git pull
  output=$(git -C "$repo_dir" pull 2>&1)
  exit_code=$?

  if [ $exit_code -eq 0 ]; then
    echo -e "   ${GREEN}✔ $output${NC}"
    count_ok=$((count_ok + 1))
  else
    echo -e "   ${RED}✘ $output${NC}"
    count_err=$((count_err + 1))
  fi

  echo ""

done < <(find "$TARGET_DIR" -maxdepth 3 -name ".git" -type d 2>/dev/null)

# Résumé
echo -e "${BLUE}─────────────────────────────────────────${NC}"
echo -e "${BLUE}📊 Résumé : $count_total dépôt(s) trouvé(s)${NC}"
echo -e "   ${GREEN}✔ $count_ok succès${NC}"
[ $count_err -gt 0 ] && echo -e "   ${RED}✘ $count_err erreur(s)${NC}"
echo -e "${BLUE}─────────────────────────────────────────${NC}"
