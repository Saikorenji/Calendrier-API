#!/bin/bash

# Fichier JSON contenant les données
FILE="program_778.json"

# Vérification de l'existence du fichier
if [[ ! -f $FILE ]]; then
  echo -e "\e[31m[ERREUR]\e[0m Le fichier \e[1m$FILE\e[0m n'existe pas."
  exit 1
fi

echo -e "\e[34m=== Calcul des heures de cours ===\e[0m"
read -p "Entrez la date de début de la semaine (YYYY-MM-DD) : " start_date

if ! date -d "$start_date" &>/dev/null; then
  echo -e "\e[31m[ERREUR]\e[0m Date invalide. Utilisez le format \e[1mYYYY-MM-DD\e[0m."
  exit 1
fi

dates_semaine=()
for i in {0..6}; do
  dates_semaine+=("$(date -d "$start_date +$i days" +"%Y-%m-%d")")
done

total_heures=0

for date in "${dates_semaine[@]}"; do
  echo -e "\n\e[33m[INFO]\e[0m Vérification des cours pour le \e[1m$date\e[0m..."
  cours=$(jq -r --arg date "$date" '
    .rows[] | select(.srvTimeCrDateFrom | startswith($date)) |
    "\(.timeCrTimeFrom) \(.timeCrTimeTo)"
  ' "$FILE")

  if [[ -z "$cours" ]]; then
    echo -e "\e[33mAucun cours trouvé pour cette date.\e[0m"
    continue
  fi

  while IFS=" " read -r debut fin; do
    if [[ ! "$debut" =~ ^[0-9]{4}$ || ! "$fin" =~ ^[0-9]{4}$ ]]; then
      echo -e "\e[31mHeures invalides : $debut-$fin\e[0m"
      continue
    fi
    heure_debut=$((10#${debut:0:2} * 60 + 10#${debut:2:2}))
    heure_fin=$((10#${fin:0:2} * 60 + 10#${fin:2:2}))
    duree=$(( (heure_fin - heure_debut) / 60 ))
    total_heures=$((total_heures + duree))
  done <<< "$cours"
done

echo -e "\n\e[32m[RESULTAT]\e[0m Total des heures pour la semaine : \e[1m$total_heures heures\e[0m."
