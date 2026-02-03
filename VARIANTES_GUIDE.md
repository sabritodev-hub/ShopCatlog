# 📦 Système de Variantes - Guide d'Utilisation

## Vue d'ensemble

Le système de variantes permet aux administrateurs de créer des déclinaisons de produits (couleur, taille, modèle, etc.) et aux clients de les sélectionner lors de l'achat.

### Exemple
- **Article**: Nike Air Max 90
- **Variantes**:
  - Type: Couleur | Valeur: Noir | Image: [photo noire]
  - Type: Couleur | Valeur: Blanc | Image: [photo blanche]
  - Type: Taille | Valeur: 36 | Image: null
  - Type: Taille | Valeur: 37 | Image: null

---

## 🛠️ Pour l'Administrateur

### Ajouter une variante

1. **Ouvrir la page d'ajout/modification d'article**
2. **Scroller jusqu'à la section "Variantes d'article"**
3. **Cliquer sur "+ Ajouter une variante"**
4. **Remplir les champs**:
   - **Type de variante**: Couleur, Taille, Modèle, etc.
   - **Valeur**: La valeur spécifique (ex: Noir, M, Pro)
   - **Image** (optionnel): Une photo de cette variante
5. **Cliquer "Ajouter"**

### Supprimer une variante

1. Dans la liste des variantes, cliquer sur 🗑️ à côté de la variante
2. La variante est immédiatement supprimée

### Structure de données

**Table Supabase**: `article_variantes`

```sql
CREATE TABLE article_variantes (
  id BIGSERIAL PRIMARY KEY,
  article_id BIGINT NOT NULL REFERENCES articles(id),
  nom_variante VARCHAR(100),      -- ex: "Couleur", "Taille"
  valeur VARCHAR(255),            -- ex: "Noir", "M"
  image_url TEXT,                 -- URL de l'image de la variante
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ
)
```

---

## 👥 Pour le Client

### Sélectionner une variante

**Sur la page de détail du produit**:

1. **Voir la section "Variantes disponibles"**
2. **Pour chaque type** (Couleur, Taille, etc.):
   - Cliquer sur la valeur souhaitée
   - Si la variante a une image, elle est affichée
3. **Les variantes sélectionnées sont visibles** (bouton actif)
4. **L'image change** si la variante a une photo associée

### Exemple d'interface

```
Variantes disponibles

COULEUR
┌─────────┐  ┌─────────┐  ┌─────────┐
│  Image  │  │  Image  │  │  Image  │
│ Noir    │  │ Blanc   │  │ Rouge   │
└─────────┘  └─────────┘  └─────────┘
   (actif)

TAILLE
┌────┐  ┌────┐  ┌────┐  ┌────┐  ┌────┐
│36  │  │37  │  │38  │  │39  │  │40  │
└────┘  └────┘  └────┘  └────┘  └────┘
```

---

## 📝 API Service

### Functions disponibles

```javascript
// Récupérer toutes les variantes d'un article
const variantes = await getVariantes(articleId);

// Créer une nouvelle variante
const newVariante = await createVariante(articleId, {
  nom_variante: 'Couleur',
  valeur: 'Noir',
  image_url: 'https://...'
});

// Mettre à jour une variante
const updated = await updateVariante(varianteId, {
  valeur: 'Gris'
});

// Supprimer une variante
await deleteVariante(varianteId);

// Récupérer variantes groupées par type
const grouped = await getVariantesGroupees(articleId);
// Retourne: { "Couleur": [...], "Taille": [...] }
```

---

## 🎨 Composants Vue

### VarianteInput (Admin)
- Formulaire pour ajouter/supprimer variantes
- Uploader d'images
- Affichage en liste

### VarianteSelector (Client)
- Affiche les variantes groupées par type
- Selection interactive
- Affichage optionnel d'images
- États actif/inactif

---

## 💡 Bonnes Pratiques

### Pour les images
- **Format**: JPG ou PNG
- **Taille**: 300x300px minimum
- **Compression**: Optimiser avant upload

### Nommage des types
- Utiliser des noms cohérents (ex: toujours "Couleur" et pas "Color")
- Types recommandés: Couleur, Taille, Modèle, Capacité, Matière

### Complétude
- **Avec images**: Couleur, Motif (choses visuelles)
- **Sans images**: Taille, Poids, Capacité (choses non-visuelles)

---

## 🔄 Flux complet

### Côté Admin
```
Article → Ouvrir formulaire → Ajouter variantes → Sauvegarder
                                    ↓
                          Appels API (createVariante)
                                    ↓
                          Stockage en BD Supabase
```

### Côté Client
```
Catalogue → Cliquer article → Voir variantes → Sélectionner
                                                    ↓
                                          Image change si URL
                                                    ↓
                                          Variantes sélectionnées
```

---

## 🐛 Troubleshooting

### Les variantes n'apparaissent pas
- Vérifier que l'article a été créé/modifié
- Vérifier la table Supabase existe
- Vérifier les logs navigateur (F12)

### Les images ne s'affichent pas
- Vérifier l'URL de l'image
- Vérifier les permissions Supabase Storage
- Vérifier le format de l'URL

### Erreur "article_id not found"
- Vérifier que l'article existe en BD
- Vérifier l'ID article transmis

---

## 📋 Checklist Migration

Si vous migrez d'une ancienne version:

- [ ] Exécuter le script SQL `variantes.sql` dans Supabase
- [ ] Importer les composants `VarianteInput` et `VarianteSelector`
- [ ] Mettre à jour `ArticleForm.vue`
- [ ] Mettre à jour `ArticleDetailPage.vue`
- [ ] Mettre à jour `articleService.js`
- [ ] Tester l'ajout de variantes
- [ ] Tester la sélection de variantes
- [ ] Tester les images de variantes

---

## 🚀 Prochaines améliorations possibles

- [ ] Édition de variantes (pas juste création/suppression)
- [ ] Gestion du prix par variante
- [ ] Gestion du stock par variante
- [ ] Pré-sélection de variantes (URL params)
- [ ] Historique des variantes sélectionnées
- [ ] Combinaisons interdites de variantes
- [ ] Variants avec plusieurs attributs (couleur + taille)

---

**Version**: 1.0  
**Date**: February 2026  
**Statut**: ✅ Production Ready
