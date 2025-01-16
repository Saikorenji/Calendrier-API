#!/bin/bash

# Fichier JSON contenant les données
FILE="program_778.json"

# Vérification de l'existence du fichier
if [[ ! -f $FILE ]]; then
  echo -e "\e[31m[ERREUR]\e[0m Le fichier \e[1m$FILE\e[0m n'existe pas."
  exit 1
fi

echo -e "\e[34m=== Affichage des cours ===\e[0m"
read -p "Entrez la date de début de la semaine (YYYY-MM-DD) : " start_date

if ! date -d "$start_date" &>/dev/null; then
  echo -e "\e[31m[ERREUR]\e[0m Date invalide. Utilisez le format \e[1mYYYY-MM-DD\e[0m."
  exit 1
fi

# Fonction pour formater les heures
format_heure() {
  local heure="$1"
  printf "%02dh%02d" "${heure:0:2}" "${heure:2:2}"
}

# Calcul des dates de la semaine
dates_semaine=()
for i in {0..6}; do
  dates_semaine+=("$(date -d "$start_date +$i days" +"%Y-%m-%d")")
done

for date in "${dates_semaine[@]}"; do
  echo -e "\n\e[33m=== Cours pour le $date ===\e[0m"
  cours=$(jq -r --arg date "$date" '
    .rows[] | select(.srvTimeCrDateFrom | startswith($date)) |
    "\(.srvTimeCrDateFrom) \(.timeCrTimeFrom) \(.timeCrTimeTo) \(.valDescription) \(.tchResName)"
  ' "$FILE")

  if [[ -z "$cours" ]]; then
    echo -e "\e[33mAucun cours trouvé.\e[0m"
    continue
  fi

  echo "$cours" | while IFS=" " read -r datetime from to desc prof; do
    heure_debut=$(format_heure "$from")
    heure_fin=$(format_heure "$to")
    echo -e "  - \e[1m$datetime\e[0m : $heure_debut à $heure_fin - $desc (Prof : $prof)"
  done
done
