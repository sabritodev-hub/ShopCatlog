#!/bin/bash
# Script pour créer la branche feature/article-variantes et committer les changements

cd /Users/rachidrezig/Documents/Travail/ShopCatlog

# 1. Créer une nouvelle branche
echo "📦 Création de la branche feature/article-variantes..."
git checkout -b feature/article-variantes

# 2. Ajouter tous les changements
echo "📝 Ajout de tous les fichiers..."
git add .

# 3. Créer le commit
echo "💾 Création du commit..."
git commit -m "feat: ajouter système de variantes pour articles

- Création table article_variantes en Supabase
- Ajout fonctions CRUD variantes dans articleService.js
- Création composant VarianteInput pour l'admin
- Création composant VarianteSelector pour le client
- Intégration dans ArticleForm.vue
- Intégration dans ArticleDetailPage.vue
- Documentation guide VARIANTES_GUIDE.md"

# 4. Vérifier le statut
echo ""
echo "✅ État du git:"
git status

# 5. Afficher l'historique
echo ""
echo "📋 Derniers commits:"
git log --oneline -5

# 6. Afficher la branche actuelle
echo ""
echo "🌳 Branche actuelle:"
git branch
