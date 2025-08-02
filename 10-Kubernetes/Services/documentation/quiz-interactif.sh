#!/bin/bash
# Quiz Interactif - Services Kubernetes
# Version simplifié avec 10 questions essentielles

clear
echo "🧠 Quiz Interactif : Services Kubernetes"
echo "========================================"
echo
echo "📋 10 questions essentielles pour tester vos connaissances"
echo "⏱️  Temps estimé : 10 minutes"
echo

read -p "Prêt à commencer ? (y/n) : " start
if [ "$start" != "y" ]; then
    echo "👋 À bientôt !"
    exit 0
fi

# Initialisation du score
score=0
total=10

clear
echo "🎯 QUESTION 1/10"
echo "=================="
echo
echo "Vous développez en local avec Kind. Quel service pour accéder via localhost:31200 ?"
echo
echo "A) ClusterIP"
echo "B) NodePort avec extraPortMappings"
echo "C) LoadBalancer"
echo "D) Ingress"
echo
read -p "Votre réponse (A/B/C/D) : " q1

if [ "$q1" = "B" ] || [ "$q1" = "b" ]; then
    echo "✅ Correct ! NodePort + extraPortMappings pour Kind"
    ((score++))
else
    echo "❌ Incorrect. Réponse : B) NodePort avec extraPortMappings"
fi
read -p "Appuyez sur Entrée pour continuer..."

clear
echo "🎯 QUESTION 2/10"
echo "=================="
echo
echo "Base de données accessible UNIQUEMENT dans le cluster. Quel service ?"
echo
echo "A) NodePort"
echo "B) LoadBalancer" 
echo "C) ClusterIP"
echo "D) ExternalName"
echo
read -p "Votre réponse (A/B/C/D) : " q2

if [ "$q2" = "C" ] || [ "$q2" = "c" ]; then
    echo "✅ Correct ! ClusterIP pour accès interne uniquement"
    ((score++))
else
    echo "❌ Incorrect. Réponse : C) ClusterIP"
fi
read -p "Appuyez sur Entrée pour continuer..."

clear
echo "🎯 QUESTION 3/10"
echo "=================="
echo
echo "5 microservices à exposer en production. Solution économique ?"
echo
echo "A) 5 LoadBalancers séparés"
echo "B) 5 NodePorts"
echo "C) 1 Ingress + 5 ClusterIP"
echo "D) 5 ExternalNames"
echo
read -p "Votre réponse (A/B/C/D) : " q3

if [ "$q3" = "C" ] || [ "$q3" = "c" ]; then
    echo "✅ Correct ! Ingress économise : $18/mois vs $90/mois"
    ((score++))
else
    echo "❌ Incorrect. Réponse : C) 1 Ingress + 5 ClusterIP"
fi
read -p "Appuyez sur Entrée pour continuer..."

clear
echo "🎯 QUESTION 4/10"
echo "=================="
echo
echo "LoadBalancer reste en <pending>. Cause probable ?"
echo
echo "A) Pas assez de pods"
echo "B) Environnement sans cloud (Kind/Minikube)"
echo "C) Port mal configuré"
echo "D) Labels incorrects"
echo
read -p "Votre réponse (A/B/C/D) : " q4

if [ "$q4" = "B" ] || [ "$q4" = "b" ]; then
    echo "✅ Correct ! LoadBalancer nécessite un cloud provider"
    ((score++))
else
    echo "❌ Incorrect. Réponse : B) Environnement sans cloud"
fi
read -p "Appuyez sur Entrée pour continuer..."

clear
echo "🎯 QUESTION 5/10"
echo "=================="
echo
echo "Déploiement canary (10% nouvelle version). Comment ?"
echo
echo "A) 2 LoadBalancers avec DNS pondéré"
echo "B) Ingress avec canary-weight: '10'"
echo "C) NodePort avec load balancer externe"
echo "D) Modifier les réplicas"
echo
read -p "Votre réponse (A/B/C/D) : " q5

if [ "$q5" = "B" ] || [ "$q5" = "b" ]; then
    echo "✅ Correct ! NGINX Ingress supporte canary nativement"
    ((score++))
else
    echo "❌ Incorrect. Réponse : B) Ingress avec canary-weight"
fi
read -p "Appuyez sur Entrée pour continuer..."

clear
echo "🎯 QUESTION 6/10"
echo "=================="
echo
echo "Coût mensuel approximatif d'un LoadBalancer cloud ?"
echo
echo "A) $5/mois"
echo "B) $18/mois"
echo "C) $50/mois"
echo "D) $100/mois"
echo
read -p "Votre réponse (A/B/C/D) : " q6

if [ "$q6" = "B" ] || [ "$q6" = "b" ]; then
    echo "✅ Correct ! ~$18/mois sur AWS/Azure/GCP"
    ((score++))
else
    echo "❌ Incorrect. Réponse : B) $18/mois"
fi
read -p "Appuyez sur Entrée pour continuer..."

clear
echo "🎯 QUESTION 7/10"
echo "=================="
echo
echo "Service sans endpoints. Première vérification ?"
echo
echo "A) kubectl get svc"
echo "B) kubectl get endpoints"
echo "C) kubectl describe pods"
echo "D) kubectl get ingress"
echo
read -p "Votre réponse (A/B/C/D) : " q7

if [ "$q7" = "B" ] || [ "$q7" = "b" ]; then
    echo "✅ Correct ! Endpoints montrent si pods sont sélectionnés"
    ((score++))
else
    echo "❌ Incorrect. Réponse : B) kubectl get endpoints"
fi
read -p "Appuyez sur Entrée pour continuer..."

clear
echo "🎯 QUESTION 8/10"
echo "=================="
echo
echo "DNS interne pour service 'api' dans namespace 'prod' ?"
echo
echo "A) api.svc.cluster.local"
echo "B) api.prod.svc.cluster.local"
echo "C) prod.api.cluster.local"
echo "D) api.cluster.local"
echo
read -p "Votre réponse (A/B/C/D) : " q8

if [ "$q8" = "B" ] || [ "$q8" = "b" ]; then
    echo "✅ Correct ! Format: service.namespace.svc.cluster.local"
    ((score++))
else
    echo "❌ Incorrect. Réponse : B) api.prod.svc.cluster.local"
fi
read -p "Appuyez sur Entrée pour continuer..."

clear
echo "🎯 QUESTION 9/10"
echo "=================="
echo
echo "Type de service par DÉFAUT si non spécifié ?"
echo
echo "A) NodePort"
echo "B) LoadBalancer"
echo "C) ClusterIP"
echo "D) Ingress"
echo
read -p "Votre réponse (A/B/C/D) : " q9

if [ "$q9" = "C" ] || [ "$q9" = "c" ]; then
    echo "✅ Correct ! ClusterIP est le type par défaut"
    ((score++))
else
    echo "❌ Incorrect. Réponse : C) ClusterIP"
fi
read -p "Appuyez sur Entrée pour continuer..."

clear
echo "🎯 QUESTION 10/10"
echo "=================="
echo
echo "Plage de ports par défaut pour NodePort ?"
echo
echo "A) 1-1024"
echo "B) 8000-9000"
echo "C) 30000-32767"
echo "D) 40000-50000"
echo
read -p "Votre réponse (A/B/C/D) : " q10

if [ "$q10" = "C" ] || [ "$q10" = "c" ]; then
    echo "✅ Correct ! 30000-32767 est la plage standard"
    ((score++))
else
    echo "❌ Incorrect. Réponse : C) 30000-32767"
fi
read -p "Appuyez sur Entrée pour voir les résultats..."

# Affichage des résultats
clear
echo "🎉 RÉSULTATS DU QUIZ"
echo "===================="
echo
echo "📊 Votre score : $score/$total"

percentage=$((score * 100 / total))
echo "📈 Pourcentage : $percentage%"
echo

if [ $score -ge 9 ]; then
    echo "🌟 EXCELLENT ! Vous maîtrisez les services Kubernetes !"
    echo "🚀 Vous êtes prêt pour des configurations avancées"
elif [ $score -ge 7 ]; then
    echo "✅ TRÈS BIEN ! Bonne compréhension des concepts"
    echo "📚 Quelques révisions sur les points manqués"
elif [ $score -ge 5 ]; then
    echo "🛠️ BIEN ! Base solide à consolider"
    echo "📖 Relire les modules sur vos points faibles"
elif [ $score -ge 3 ]; then
    echo "🎓 CORRECT ! Continuez l'apprentissage"
    echo "📚 Réviser les concepts de base (modules 1-3)"
else
    echo "📚 RÉVISION NÉCESSAIRE"
    echo "🎯 Commencez par le module 1 (Introduction)"
fi

echo
echo "📋 Recommandations :"

if [ $score -lt 7 ]; then
    echo "• 📖 Relire les modules correspondants"
    echo "• 🧪 Pratiquer avec Kind/Minikube"
    echo "• 🔄 Reprendre le quiz dans quelques jours"
fi

if [ $score -ge 7 ]; then
    echo "• 🚀 Pratiquer les déploiements avancés"
    echo "• 💰 Explorer l'optimisation des coûts"
    echo "• 🎯 Tenter le quiz complet (50 questions)"
fi

echo
echo "📚 Quiz complet disponible dans :"
echo "   documentation/08-quiz-services-kubernetes.md"
echo
echo "🎯 Modules à réviser selon vos erreurs :"
echo "   • ClusterIP : Module 2"
echo "   • NodePort : Module 3" 
echo "   • LoadBalancer : Module 4"
echo "   • Ingress : Module 5"
echo "   • Coûts : Module 6"
echo "   • Debug : Module 6"
echo
read -p "Appuyez sur Entrée pour terminer..."

echo "👋 Merci d'avoir participé au quiz !"
echo "🚀 Continuez votre apprentissage Kubernetes !"