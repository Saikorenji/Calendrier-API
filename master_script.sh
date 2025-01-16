#!/bin/bash

# Script principal pour gérer les fonctionnalités

# Vérification de l'existence des scripts nécessaires
if [[ ! -f "cours_semaine.sh" ]] || [[ ! -f "controles_semaine.sh" ]] || [[ ! -f "compter_heures_semaine.sh" ]]; then
  echo -e "\e[31mErreur :\e[0m Les scripts nécessaires doivent exister dans le répertoire actuel."
  exit 1
fi

# Menu principal
while true; do
  echo -e "\n\e[34m======= Menu Principal =======\e[0m"
  echo "1. Afficher les cours pour une semaine donnée"
  echo "2. Afficher les contrôles pour une semaine donnée"
  echo "3. Calculer le total des heures de cours pour une semaine"
  echo "4. Quitter"
  echo -n "Choisissez une option : "
  read -r choice

  case $choice in
    1)
      ./cours_semaine.sh
      ;;
    2)
      ./controles_semaine.sh
      ;;
    3)
      ./compter_heures_semaine.sh
      ;;
    4)
      echo "Au revoir !"
      exit 0
      ;;
    *)
      echo -e "\e[31mOption invalide. Veuillez choisir entre 1 et 4.\e[0m"
      ;;
  esac
done
