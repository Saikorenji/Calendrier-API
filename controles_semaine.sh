#!/bin/bash

# Fichier JSON contenant les données
FILE="program_778.json"

# Vérification de l'existence du fichier
if [[ ! -f $FILE ]]; then
  echo -e "\e[31m[ERREUR]\e[0m Le fichier \e[1m$FILE\e[0m n'existe pas."
  exit 1
fi

echo -e "\e[34m=== Liste des contrôles ===\e[0m"

jq -r '
  .rows[] | select(.valDescription | test("(?i)contrôle|examen|évaluation")) |
  "\(.srvTimeCrDateFrom) \(.timeCrTimeFrom) \(.timeCrTimeTo) \(.valDescription) \(.tchResName)"
' "$FILE" | while IFS=" " read -r datetime from to desc prof; do
  heure_debut=$(printf "%02dh%02d" "${from:0:2}" "${from:2:2}")
  heure_fin=$(printf "%02dh%02d" "${to:0:2}" "${to:2:2}")
  echo -e "  - \e[1m$datetime\e[0m : $heure_debut à $heure_fin - $desc (Prof : $prof)"
done