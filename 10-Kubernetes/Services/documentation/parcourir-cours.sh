#!/bin/bash
# Script pour naviguer facilement dans le cours Services Kubernetes

clear
echo "📚 Cours Exhaustif : Services Kubernetes"
echo "========================================"
echo
echo "📖 Modules disponibles :"
echo
echo "1. 🎯 Introduction aux Services Kubernetes"
echo "2. 🔒 ClusterIP - Communication interne" 
echo "3. 🚪 NodePort - Développement et test"
echo "4. ⚖️  LoadBalancer - Production cloud"
echo "5. 🌐 Ingress - Solution moderne"
echo "6. 📊 Comparaisons et bonnes pratiques"
echo "7. 🎨 Visualisations exhaustives"
echo "8. 🧠 Quiz 50 questions (NOUVEAU!)"
echo "9. 📋 README - Vue d'ensemble du cours"
echo "10. 🔧 Voir les fichiers d'exemples"
echo "11. 🏃 Lancer le script de déploiement"
echo "0. ❌ Quitter"
echo

read -p "Choisissez un module (0-11) : " choice

case $choice in
    1)
        echo "📖 Ouverture du module 1..."
        cat "01-introduction-services-kubernetes.md" | less
        ;;
    2)
        echo "📖 Ouverture du module 2..."
        cat "02-clusterip-service.md" | less
        ;;
    3)
        echo "📖 Ouverture du module 3..."
        cat "03-nodeport-service.md" | less
        ;;
    4)
        echo "📖 Ouverture du module 4..."
        cat "04-loadbalancer-service.md" | less
        ;;
    5)
        echo "📖 Ouverture du module 5..."
        cat "05-ingress-solution-moderne.md" | less
        ;;
    6)
        echo "📖 Ouverture du module 6..."
        cat "06-comparaisons-et-bonnes-pratiques.md" | less
        ;;
    7)
        echo "🎨 Ouverture du module Visualisations..."
        cat "07-visualisations-services-kubernetes.md" | less
        ;;
    8)
        echo "🧠 Ouverture du Quiz..."
        cat "08-quiz-services-kubernetes.md" | less
        ;;
    9)
        echo "📖 Ouverture du README..."
        cat "README.md" | less
        ;;
    10)
        echo "📁 Fichiers d'exemples :"
        ls -la examples/
        echo
        read -p "Voulez-vous voir un fichier d'exemple ? (y/n) : " show_example
        if [ "$show_example" = "y" ]; then
            ls examples/
            read -p "Nom du fichier : " filename
            if [ -f "examples/$filename" ]; then
                cat "examples/$filename"
            else
                echo "❌ Fichier non trouvé"
            fi
        fi
        ;;
    11)
        echo "🏃 Lancement du script de déploiement..."
        if [ -f "../deploy-script.sh" ]; then
            bash ../deploy-script.sh
        else
            echo "❌ Script de déploiement non trouvé"
        fi
        ;;
    0)
        echo "👋 Au revoir ! Bon apprentissage Kubernetes !"
        exit 0
        ;;
    *)
        echo "❌ Choix invalide"
        ;;
esac

echo
read -p "Appuyez sur Entrée pour revenir au menu..." dummy
exec "$0"  # Relancer le script