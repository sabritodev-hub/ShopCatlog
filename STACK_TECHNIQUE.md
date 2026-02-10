# 📚 Stack Technique - Template de Projet Vue.js + Supabase

Ce document décrit la stack technique complète utilisée dans ce projet. Utilisez-le comme prompt pour recréer un projet similaire avec une autre logique métier.

---

## 🎯 Architecture Générale

**Type**: Application Web Single Page Application (SPA)
**Pattern**: Architecture en couches (Services, Composants, Pages)
**Structure**: Composants réutilisables + Services métier

---

## 🛠️ Technologies & Frameworks

### Frontend Core
- **Vue.js 3.5.24** - Framework JavaScript progressif avec Composition API et Options API
- **Vue Router 4.5.0** - Routing client-side avec guards d'authentification
- **Vite 7.2.4** - Build tool moderne et rapide avec HMR
- **@vitejs/plugin-vue 6.0.1** - Plugin Vite pour Vue.js SFC

### Backend as a Service (BaaS)
- **Supabase** (@supabase/supabase-js 2.90.1)
  - PostgreSQL Database
  - Authentication (Email/Password)
  - Row Level Security (RLS)
  - Storage (Upload d'images)
  - API REST auto-générée

### Styling
- **CSS Moderne** - CSS Variables + CSS Grid + Flexbox
- **Design System** - Variables CSS centralisées (2026 Modern Minimal)
- **Google Fonts** - Inter (weights: 300, 400, 500, 600, 700, 800)
- **Responsive Design** - Mobile-first avec media queries

---

## 📁 Structure des Dossiers

```
project-root/
├── public/                      # Assets statiques
│   ├── favicon.svg
│   └── vite.svg
├── src/
│   ├── main.js                 # Point d'entrée de l'application
│   ├── App.vue                 # Composant racine
│   ├── style.css              # Styles globaux de base
│   │
│   ├── assets/                 # Assets (images, styles)
│   │   ├── styles/
│   │   │   ├── index.css      # Import centralisé des styles
│   │   │   ├── variables.css  # Variables CSS (couleurs, spacing, fonts)
│   │   │   └── base.css       # Reset CSS + styles de base
│   │   └── [images]/
│   │
│   ├── components/             # Composants Vue réutilisables
│   │   ├── ui/                # Composants UI génériques
│   │   │   ├── index.js       # Export barrel de tous les composants UI
│   │   │   ├── BaseButton.vue
│   │   │   ├── BaseInput.vue
│   │   │   ├── BaseCard.vue
│   │   │   ├── BaseModal.vue
│   │   │   ├── BaseSelect.vue
│   │   │   ├── BaseBadge.vue
│   │   │   └── ImageUploader.vue
│   │   └── [feature]/         # Composants spécifiques au métier
│   │
│   ├── pages/                  # Composants de pages (routes)
│   │   ├── CatalogPage.vue
│   │   ├── DetailPage.vue
│   │   ├── AdminPage.vue
│   │   └── LoginPage.vue
│   │
│   ├── router/                 # Configuration du routing
│   │   └── index.js           # Routes + Navigation Guards
│   │
│   ├── services/               # Logique métier et API calls
│   │   ├── authService.js     # Authentification Supabase
│   │   ├── dataService.js     # CRUD des données métier
│   │   └── storageService.js  # Upload/Delete de fichiers
│   │
│   ├── lib/                    # Librairies et configurations
│   │   └── supabase.js        # Client Supabase configuré
│   │
│   └── data/                   # Données mock (fallback)
│       └── mockData.js
│
├── supabase/                   # Scripts SQL pour la base de données
│   ├── schema.sql             # Schéma des tables
│   ├── auth.sql               # Configuration auth
│   └── migration.sql          # Migrations
│
├── .env                        # Variables d'environnement (non versionnées)
├── .env.example               # Template des variables d'environnement
├── package.json               # Dépendances et scripts
├── vite.config.js            # Configuration Vite
└── README.md                 # Documentation projet
```

---

## 🔧 Configuration du Projet

### 1. Installation Initiale

```bash
# Créer le projet Vue + Vite
npm create vite@latest mon-projet -- --template vue

# Installer les dépendances
cd mon-projet
npm install

# Installer Supabase
npm install @supabase/supabase-js

# Installer Vue Router
npm install vue-router
```

### 2. Configuration Vite (`vite.config.js`)

```javascript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { fileURLToPath, URL } from 'node:url'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  }
})
```

### 3. Variables d'Environnement (`.env`)

```env
VITE_SUPABASE_URL=https://votre-projet.supabase.co
VITE_SUPABASE_ANON_KEY=votre_cle_anon_key
```

⚠️ **Important**: Ajouter `.env` au `.gitignore`

### 4. Configuration Supabase (`src/lib/supabase.js`)

```javascript
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

const supabaseOptions = {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true
  }
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey, supabaseOptions)

export const isSupabaseConfigured = () => {
  return supabaseUrl && supabaseAnonKey && supabaseAnonKey.length > 0
}

export default supabase
```

---

## 🎨 Design System

### Variables CSS (`src/assets/styles/variables.css`)

**Organisation**:
- Couleurs primaires + gradients
- Couleurs de statut (success, warning, danger, info)
- Palette de gris (50 à 900)
- Spacing (échelle 8pt: 0, 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 20, 24, 32)
- Typography (tailles, poids, line-heights)
- Border radius (sm, md, lg, xl, full)
- Shadows (sm, md, lg, xl)
- Transitions (fast, normal, slow)
- Z-index (échelle cohérente)

**Exemples**:
```css
:root {
  /* Couleurs */
  --color-primary: #6366f1;
  --color-primary-gradient: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);

  /* Spacing */
  --spacing-1: 0.25rem;  /* 4px */
  --spacing-2: 0.5rem;   /* 8px */
  --spacing-4: 1rem;     /* 16px */

  /* Typography */
  --font-family-base: 'Inter', sans-serif;
  --font-size-base: 1rem;
  --font-weight-normal: 400;
  --font-weight-semibold: 600;

  /* Radius */
  --radius-md: 0.5rem;
  --radius-lg: 0.75rem;

  /* Shadows */
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);

  /* Transitions */
  --transition-fast: 150ms ease-in-out;
}
```

### Base CSS (`src/assets/styles/base.css`)

- Reset CSS complet
- Styles de base (body, html)
- Typographie globale
- Animations globales
- Scrollbar personnalisée

---

## 🧩 Composants UI Génériques

### Architecture des Composants UI

**Localisation**: `src/components/ui/`
**Export centralisé**: `src/components/ui/index.js`

```javascript
export { default as BaseButton } from './BaseButton.vue'
export { default as BaseInput } from './BaseInput.vue'
export { default as BaseCard } from './BaseCard.vue'
// ... autres composants
```

### BaseButton.vue

**Props**:
- `variant`: 'primary', 'secondary', 'success', 'danger', 'warning', 'outline', 'ghost'
- `size`: 'sm', 'md', 'lg'
- `type`: 'button', 'submit', 'reset'
- `disabled`: boolean
- `loading`: boolean (affiche un spinner)
- `fullWidth`: boolean
- `icon`: boolean (pour les boutons icon-only)

**Slots**:
- `default`: Texte du bouton
- `icon`: Icône (SVG)

**Events**:
- `@click`: Émis au clic

**Usage**:
```vue
<BaseButton variant="primary" size="md" :loading="isLoading" @click="handleClick">
  <template #icon>
    <svg>...</svg>
  </template>
  Sauvegarder
</BaseButton>
```

### BaseInput.vue

**Props**:
- `modelValue`: string | number (v-model)
- `type`: 'text', 'email', 'password', 'number', 'textarea', etc.
- `label`: string
- `placeholder`: string
- `hint`: string (texte d'aide)
- `error`: string (message d'erreur)
- `disabled`: boolean
- `readonly`: boolean
- `required`: boolean
- `size`: 'sm', 'md', 'lg'
- `min`, `max`, `step`: pour type="number"
- `rows`: pour textarea

**Slots**:
- `prefix`: Icône/texte avant l'input
- `suffix`: Icône/texte après l'input

**Events**:
- `@update:modelValue`: v-model
- `@blur`, `@focus`

**Usage**:
```vue
<BaseInput
  v-model="form.email"
  type="email"
  label="Email"
  placeholder="exemple@email.com"
  :error="errors.email"
  required
>
  <template #prefix>
    <svg>...</svg>
  </template>
</BaseInput>
```

### BaseCard.vue

**Props**:
- `padding`: 'none', 'sm', 'md', 'lg'
- `hover`: boolean (effet hover)
- `shadow`: 'none', 'sm', 'md', 'lg'
- `border`: boolean

**Slots**:
- `default`: Contenu principal
- `header`: En-tête optionnel
- `footer`: Pied optionnel

### BaseModal.vue

**Props**:
- `show`: boolean (v-model pour afficher/masquer)
- `title`: string
- `size`: 'sm', 'md', 'lg', 'xl', 'full'
- `closeOnBackdrop`: boolean
- `showClose`: boolean

**Slots**:
- `default`: Contenu
- `header`: En-tête personnalisé
- `footer`: Actions/boutons

**Events**:
- `@close`: Émis à la fermeture

### BaseSelect.vue

**Props**:
- `modelValue`: valeur sélectionnée
- `options`: Array<{value, label}>
- `label`: string
- `placeholder`: string
- `error`: string
- `disabled`: boolean
- `required`: boolean

### BaseBadge.vue

**Props**:
- `variant`: 'primary', 'success', 'warning', 'danger', 'info'
- `size`: 'sm', 'md', 'lg'
- `rounded`: boolean (pill shape)

### ImageUploader.vue

**Props**:
- `modelValue`: URL de l'image
- `accept`: types de fichiers acceptés
- `maxSize`: taille max en MB
- `preview`: boolean (affiche un aperçu)

**Events**:
- `@update:modelValue`: nouvelle URL
- `@upload`: fichier uploadé

---

## 🔐 Authentification avec Supabase

### Service d'Authentification (`src/services/authService.js`)

**Fonctions essentielles**:

```javascript
// Connexion
export async function login(email, password) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password
  })
  if (error) throw error
  return data
}

// Inscription
export async function register(email, password, metadata = {}) {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: metadata  // Données utilisateur supplémentaires
    }
  })
  if (error) throw error
  return data
}

// Déconnexion
export async function logout() {
  const { error } = await supabase.auth.signOut()
  if (error) throw error
}

// Utilisateur actuel
export async function getCurrentUser() {
  const { data: { user } } = await supabase.auth.getUser()
  return user
}

// Session actuelle
export async function getSession() {
  const { data: { session } } = await supabase.auth.getSession()
  return session
}

// Vérifier si authentifié
export async function isAuthenticated() {
  const session = await getSession()
  return !!session
}

// Écouter les changements d'auth
export function onAuthStateChange(callback) {
  const { data: { subscription } } = supabase.auth.onAuthStateChange(
    (event, session) => {
      callback(event, session)
    }
  )
  return () => subscription.unsubscribe()
}
```

### Configuration dans App.vue

```javascript
import { onMounted, onUnmounted, ref } from 'vue'
import { onAuthStateChange } from '@/services/authService'

const isAuthenticated = ref(false)
let unsubscribe = null

onMounted(() => {
  // Écouter les changements d'authentification
  unsubscribe = onAuthStateChange((event, session) => {
    isAuthenticated.value = !!session
  })
})

onUnmounted(() => {
  if (unsubscribe) unsubscribe()
})
```

---

## 🛣️ Routing avec Vue Router

### Configuration (`src/router/index.js`)

```javascript
import { createRouter, createWebHistory } from 'vue-router'
import { getSession } from '@/services/authService'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: HomePage,
    meta: { title: 'Accueil' }
  },
  {
    path: '/login',
    name: 'Login',
    component: LoginPage,
    meta: { title: 'Connexion' }
  },
  {
    path: '/admin',
    name: 'Admin',
    component: AdminPage,
    meta: {
      title: 'Administration',
      requiresAuth: true  // Route protégée
    }
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/'  // 404 redirect
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0 }
    }
  }
})

// Navigation Guard pour protéger les routes
router.beforeEach(async (to, from, next) => {
  // Mettre à jour le titre de la page
  document.title = to.meta.title || 'Mon App'

  // Vérifier l'authentification pour les routes protégées
  if (to.meta.requiresAuth) {
    const session = await getSession()

    if (!session) {
      next({ name: 'Login', query: { redirect: to.fullPath } })
      return
    }
  }

  // Rediriger si déjà connecté et accès à /login
  if (to.name === 'Login') {
    const session = await getSession()
    if (session) {
      next({ name: 'Admin' })
      return
    }
  }

  next()
})

export default router
```

---

## 💾 Base de Données Supabase

### Structure des Tables

**Pattern SQL général**:

```sql
-- Table principale
CREATE TABLE IF NOT EXISTS ma_table (
  id BIGSERIAL PRIMARY KEY,
  nom VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour les recherches fréquentes
CREATE INDEX IF NOT EXISTS idx_ma_table_nom ON ma_table(nom);

-- Fonction pour updated_at automatique
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger pour updated_at
CREATE TRIGGER update_ma_table_updated_at
  BEFORE UPDATE ON ma_table
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (RLS)
ALTER TABLE ma_table ENABLE ROW LEVEL SECURITY;

-- Politique: Lecture publique
CREATE POLICY "Lecture publique" ON ma_table
  FOR SELECT
  USING (true);

-- Politique: Modification authentifiée seulement
CREATE POLICY "Modification authentifiée" ON ma_table
  FOR ALL
  USING (auth.uid() IS NOT NULL);
```

### Relations entre Tables

```sql
-- Table avec foreign key
CREATE TABLE IF NOT EXISTS sous_table (
  id BIGSERIAL PRIMARY KEY,
  parent_id BIGINT REFERENCES ma_table(id) ON DELETE CASCADE,
  nom VARCHAR(255) NOT NULL
);

-- Index sur la clé étrangère
CREATE INDEX IF NOT EXISTS idx_sous_table_parent ON sous_table(parent_id);
```

---

## 🔌 Services de Données (CRUD)

### Template de Service (`src/services/dataService.js`)

```javascript
import { supabase } from '@/lib/supabase'

const TABLE_NAME = 'ma_table'

// CREATE - Créer un nouvel élément
export async function createItem(itemData) {
  const { data, error } = await supabase
    .from(TABLE_NAME)
    .insert(itemData)
    .select()
    .single()

  if (error) {
    console.error('Erreur création:', error)
    throw error
  }
  return data
}

// READ - Récupérer tous les éléments
export async function getItems() {
  const { data, error } = await supabase
    .from(TABLE_NAME)
    .select('*')
    .order('created_at', { ascending: false })

  if (error) {
    console.error('Erreur récupération:', error)
    throw error
  }
  return data
}

// READ - Récupérer un élément par ID
export async function getItemById(id) {
  const { data, error } = await supabase
    .from(TABLE_NAME)
    .select('*')
    .eq('id', id)
    .single()

  if (error) {
    console.error('Erreur récupération:', error)
    throw error
  }
  return data
}

// READ - Récupérer avec relations (JOIN)
export async function getItemsWithRelations() {
  const { data, error } = await supabase
    .from(TABLE_NAME)
    .select(`
      *,
      relation_table:relation_id (
        id,
        nom
      )
    `)
    .order('created_at', { ascending: false })

  if (error) {
    console.error('Erreur récupération:', error)
    throw error
  }
  return data
}

// UPDATE - Mettre à jour un élément
export async function updateItem(id, updates) {
  const { data, error } = await supabase
    .from(TABLE_NAME)
    .update(updates)
    .eq('id', id)
    .select()
    .single()

  if (error) {
    console.error('Erreur mise à jour:', error)
    throw error
  }
  return data
}

// DELETE - Supprimer un élément
export async function deleteItem(id) {
  const { error } = await supabase
    .from(TABLE_NAME)
    .delete()
    .eq('id', id)

  if (error) {
    console.error('Erreur suppression:', error)
    throw error
  }
}

// SEARCH - Rechercher avec filtres
export async function searchItems(searchTerm, filters = {}) {
  let query = supabase
    .from(TABLE_NAME)
    .select('*')

  // Recherche textuelle
  if (searchTerm) {
    query = query.ilike('nom', `%${searchTerm}%`)
  }

  // Filtres additionnels
  Object.keys(filters).forEach(key => {
    if (filters[key]) {
      query = query.eq(key, filters[key])
    }
  })

  const { data, error } = await query.order('created_at', { ascending: false })

  if (error) {
    console.error('Erreur recherche:', error)
    throw error
  }
  return data
}
```

---

## 📤 Storage (Upload de Fichiers)

### Service de Storage (`src/services/storageService.js`)

```javascript
import { supabase } from '@/lib/supabase'

const BUCKET_NAME = 'mon-bucket'

// Upload une image
export async function uploadImage(file, folder = 'images') {
  if (!file) throw new Error('Aucun fichier fourni')

  // Vérifications
  const allowedTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif']
  if (!allowedTypes.includes(file.type)) {
    throw new Error('Type de fichier non autorisé')
  }

  const maxSize = 5 * 1024 * 1024  // 5MB
  if (file.size > maxSize) {
    throw new Error('Fichier trop volumineux (max 5MB)')
  }

  // Nom unique
  const timestamp = Date.now()
  const randomString = Math.random().toString(36).substring(2, 8)
  const extension = file.name.split('.').pop()
  const fileName = `${folder}/${timestamp}_${randomString}.${extension}`

  // Upload
  const { data, error } = await supabase.storage
    .from(BUCKET_NAME)
    .upload(fileName, file, {
      cacheControl: '3600',
      upsert: false
    })

  if (error) {
    console.error('Erreur upload:', error)
    throw error
  }

  // Récupérer l'URL publique
  const { data: { publicUrl } } = supabase.storage
    .from(BUCKET_NAME)
    .getPublicUrl(data.path)

  return {
    url: publicUrl,
    path: data.path
  }
}

// Supprimer une image
export async function deleteImage(filePath) {
  if (!filePath) return

  const { error } = await supabase.storage
    .from(BUCKET_NAME)
    .remove([filePath])

  if (error) {
    console.error('Erreur suppression:', error)
    throw error
  }
}

// Lister les fichiers d'un dossier
export async function listFiles(folder = '') {
  const { data, error } = await supabase.storage
    .from(BUCKET_NAME)
    .list(folder, {
      limit: 100,
      offset: 0,
      sortBy: { column: 'created_at', order: 'desc' }
    })

  if (error) {
    console.error('Erreur listage:', error)
    throw error
  }

  return data
}
```

### Configuration du Bucket Supabase

1. Aller dans **Storage** dans le dashboard Supabase
2. Créer un nouveau bucket
3. Configurer les politiques RLS:

```sql
-- Lecture publique
CREATE POLICY "Public Access" ON storage.objects
  FOR SELECT
  USING (bucket_id = 'mon-bucket');

-- Upload authentifié
CREATE POLICY "Authenticated Upload" ON storage.objects
  FOR INSERT
  WITH CHECK (
    bucket_id = 'mon-bucket'
    AND auth.uid() IS NOT NULL
  );

-- Suppression authentifiée
CREATE POLICY "Authenticated Delete" ON storage.objects
  FOR DELETE
  USING (
    bucket_id = 'mon-bucket'
    AND auth.uid() IS NOT NULL
  );
```

---

## 🎭 Patterns de Composants

### Composant de Page (Page Component)

```vue
<template>
  <div class="page-container">
    <header class="page-header">
      <h1>{{ title }}</h1>
      <BaseButton @click="handleAction">Action</BaseButton>
    </header>

    <main class="page-content">
      <!-- Contenu principal -->
    </main>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { BaseButton } from '@/components/ui'
import { getItems } from '@/services/dataService'

export default {
  name: 'MaPage',
  components: { BaseButton },
  setup() {
    const items = ref([])
    const loading = ref(false)

    const loadData = async () => {
      loading.value = true
      try {
        items.value = await getItems()
      } catch (error) {
        console.error('Erreur chargement:', error)
      } finally {
        loading.value = false
      }
    }

    onMounted(() => {
      loadData()
    })

    return {
      items,
      loading,
      loadData
    }
  }
}
</script>

<style scoped>
.page-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: var(--spacing-6);
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--spacing-6);
}
</style>
```

### Composant de Formulaire

```vue
<template>
  <form @submit.prevent="handleSubmit">
    <BaseInput
      v-model="form.nom"
      label="Nom"
      placeholder="Entrez le nom"
      :error="errors.nom"
      required
    />

    <BaseInput
      v-model="form.description"
      type="textarea"
      label="Description"
      :rows="4"
    />

    <div class="form-actions">
      <BaseButton type="button" variant="ghost" @click="handleCancel">
        Annuler
      </BaseButton>
      <BaseButton type="submit" :loading="loading">
        Enregistrer
      </BaseButton>
    </div>
  </form>
</template>

<script>
import { ref, reactive } from 'vue'
import { BaseInput, BaseButton } from '@/components/ui'
import { createItem } from '@/services/dataService'

export default {
  name: 'MonFormulaire',
  components: { BaseInput, BaseButton },
  emits: ['success', 'cancel'],
  setup(props, { emit }) {
    const form = reactive({
      nom: '',
      description: ''
    })

    const errors = reactive({})
    const loading = ref(false)

    const validate = () => {
      errors.nom = form.nom ? '' : 'Le nom est requis'
      return !errors.nom
    }

    const handleSubmit = async () => {
      if (!validate()) return

      loading.value = true
      try {
        await createItem(form)
        emit('success')
      } catch (error) {
        console.error('Erreur:', error)
      } finally {
        loading.value = false
      }
    }

    const handleCancel = () => {
      emit('cancel')
    }

    return {
      form,
      errors,
      loading,
      handleSubmit,
      handleCancel
    }
  }
}
</script>

<style scoped>
form {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-4);
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: var(--spacing-3);
  margin-top: var(--spacing-4);
}
</style>
```

---

## 📱 Responsive Design

### Breakpoints Standards

```css
/* Mobile first approach */

/* Mobile: < 640px (par défaut) */

/* Tablet: >= 640px */
@media (min-width: 640px) {
  /* Styles tablette */
}

/* Desktop: >= 1024px */
@media (min-width: 1024px) {
  /* Styles desktop */
}

/* Large Desktop: >= 1280px */
@media (min-width: 1280px) {
  /* Styles grand écran */
}
```

### Container Responsive

```css
.container {
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 var(--spacing-4);
}

@media (min-width: 640px) {
  .container {
    padding: 0 var(--spacing-6);
  }
}
```

### Grille Responsive

```css
.grid {
  display: grid;
  gap: var(--spacing-4);
  grid-template-columns: 1fr;
}

@media (min-width: 640px) {
  .grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (min-width: 1024px) {
  .grid {
    grid-template-columns: repeat(3, 1fr);
  }
}
```

---

## 🚀 Scripts NPM

```json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext .vue,.js,.jsx",
    "format": "prettier --write \"src/**/*.{vue,js,css}\""
  }
}
```

**Commandes**:
- `npm run dev` - Lancer le serveur de développement
- `npm run build` - Build de production
- `npm run preview` - Prévisualiser le build de production

---

## 🔒 Sécurité & Bonnes Pratiques

### Row Level Security (RLS)

Toujours activer RLS sur les tables Supabase:

```sql
ALTER TABLE ma_table ENABLE ROW LEVEL SECURITY;

-- Exemples de politiques

-- 1. Lecture publique, écriture authentifiée
CREATE POLICY "Public read" ON ma_table
  FOR SELECT USING (true);

CREATE POLICY "Authenticated write" ON ma_table
  FOR ALL USING (auth.uid() IS NOT NULL);

-- 2. Utilisateur peut seulement modifier ses propres données
CREATE POLICY "Users own data" ON ma_table
  FOR ALL USING (auth.uid() = user_id);

-- 3. Admin seulement
CREATE POLICY "Admin only" ON ma_table
  FOR ALL USING (
    auth.jwt() ->> 'role' = 'admin'
  );
```

### Variables d'Environnement

- **Jamais** commiter les fichiers `.env`
- Utiliser `.env.example` pour documenter les variables nécessaires
- Préfixer avec `VITE_` pour les rendre accessibles côté client
- Stocker les secrets sensibles côté serveur uniquement

### Validation des Données

Toujours valider:
1. Côté client (UX)
2. Côté serveur/base de données (sécurité)

```javascript
// Validation côté client
const validate = () => {
  if (!form.email.includes('@')) {
    errors.email = 'Email invalide'
    return false
  }
  return true
}

// Contraintes SQL
CREATE TABLE users (
  email VARCHAR(255) NOT NULL UNIQUE CHECK (email ~ '^[^@]+@[^@]+\.[^@]+$')
);
```

---

## 🎯 Checklist de Création de Projet

### Phase 1: Setup Initial
- [ ] Créer le projet Vite + Vue
- [ ] Installer les dépendances (Supabase, Vue Router)
- [ ] Configurer `vite.config.js` avec alias `@`
- [ ] Créer la structure de dossiers
- [ ] Configurer `.env` et `.env.example`

### Phase 2: Design System
- [ ] Créer `variables.css` avec toutes les CSS variables
- [ ] Créer `base.css` avec reset et styles globaux
- [ ] Créer `index.css` pour importer tous les styles
- [ ] Importer les styles dans `main.js`

### Phase 3: Composants UI
- [ ] Créer `BaseButton.vue` avec variantes
- [ ] Créer `BaseInput.vue` avec validation
- [ ] Créer `BaseCard.vue`
- [ ] Créer `BaseModal.vue`
- [ ] Créer `BaseSelect.vue`
- [ ] Créer `BaseBadge.vue`
- [ ] Créer `ImageUploader.vue`
- [ ] Créer `index.js` pour exports

### Phase 4: Supabase
- [ ] Créer un projet Supabase
- [ ] Configurer `lib/supabase.js`
- [ ] Créer les tables SQL avec RLS
- [ ] Configurer les Storage buckets avec politiques
- [ ] Tester la connexion

### Phase 5: Services
- [ ] Créer `authService.js` avec toutes les fonctions d'auth
- [ ] Créer `dataService.js` pour le CRUD
- [ ] Créer `storageService.js` pour les uploads
- [ ] Tester chaque service

### Phase 6: Routing
- [ ] Créer les composants de pages
- [ ] Configurer `router/index.js` avec les routes
- [ ] Ajouter les navigation guards
- [ ] Tester la navigation et la protection des routes

### Phase 7: App Principal
- [ ] Configurer `App.vue` avec navigation
- [ ] Ajouter l'écoute des changements d'auth
- [ ] Implémenter le layout (header, nav, footer)
- [ ] Tester le flux complet

### Phase 8: Features Métier
- [ ] Créer les composants spécifiques au métier
- [ ] Implémenter les fonctionnalités CRUD
- [ ] Connecter avec les services
- [ ] Tester toutes les fonctionnalités

### Phase 9: Polish
- [ ] Responsive design sur tous les écrans
- [ ] Messages d'erreur et feedback utilisateur
- [ ] Loading states
- [ ] Animations et transitions
- [ ] Tests

### Phase 10: Déploiement
- [ ] Build de production (`npm run build`)
- [ ] Tester le build localement (`npm run preview`)
- [ ] Déployer (Vercel, Netlify, etc.)
- [ ] Configurer les variables d'environnement en production

---

## 📝 Prompt pour Recréer un Projet Similaire

```
Je veux créer une application web avec la stack technique suivante:

TECHNOLOGIES:
- Vue.js 3 avec Composition API et Options API
- Vite comme build tool
- Vue Router pour le routing
- Supabase comme backend (PostgreSQL + Auth + Storage)
- CSS moderne avec variables CSS (pas de framework CSS)

ARCHITECTURE:
- Structure en couches: pages, components (ui génériques + spécifiques), services, router, lib
- Design system avec variables CSS centralisées (couleurs, spacing, typography, shadows, etc.)
- Composants UI réutilisables: BaseButton, BaseInput, BaseCard, BaseModal, BaseSelect, BaseBadge, ImageUploader
- Services pour: authentification (authService), CRUD données (dataService), upload fichiers (storageService)
- Routing avec navigation guards pour protéger les routes admin
- Configuration Supabase avec RLS sur toutes les tables

COMPOSANTS UI REQUIS (tous avec variants, sizes, states):
1. BaseButton: variants (primary, secondary, success, danger, outline, ghost), sizes (sm, md, lg), loading state
2. BaseInput: avec label, error, hint, prefix/suffix slots, types multiples (text, email, password, number, textarea)
3. BaseCard: avec padding, hover, shadow options, slots (header, default, footer)
4. BaseModal: avec backdrop, animations, sizes, close button
5. BaseSelect: avec options array, placeholder, disabled state
6. BaseBadge: pour afficher des tags/statuts
7. ImageUploader: avec preview, validation type/taille, intégration Storage Supabase

BASE DE DONNÉES:
- Tables avec: id BIGSERIAL, created_at, updated_at (avec trigger auto)
- Index sur les colonnes de recherche fréquentes
- RLS activé partout
- Politiques: lecture publique, écriture authentifiée
- Relations avec foreign keys et ON DELETE CASCADE

AUTHENTIFICATION:
- Login/Register avec email/password
- Session persistence
- Protected routes avec navigation guards
- Écoute des changements d'état auth dans App.vue

STORAGE:
- Bucket pour les images
- Validation: types (jpg, png, webp, gif), taille max 5MB
- Noms de fichiers uniques (timestamp + random)
- Politiques RLS sur le bucket

DESIGN:
- Mobile-first responsive
- Design system moderne 2026: gradients vibrants, shadows douces, animations fluides
- Google Font Inter
- Couleurs: primaire (indigo/purple gradient), statuts (success, warning, danger, info)
- Breakpoints: mobile (<640px), tablet (640px+), desktop (1024px+)
- Transitions smooth sur tous les états hover/focus

STRUCTURE DES DOSSIERS:
Respecter exactement la structure fournie dans le document avec:
- src/components/ui/ pour composants génériques
- src/pages/ pour les pages/routes
- src/services/ pour la logique métier
- src/router/ pour Vue Router
- src/lib/ pour configs externes (Supabase)
- src/assets/styles/ pour CSS (variables, base, index)

Le sujet métier du projet sera: [DÉCRIRE LE SUJET ICI]

Les fonctionnalités spécifiques seront: [LISTER LES FONCTIONNALITÉS]

Génère tout le code nécessaire en respectant cette architecture technique.
```

---

## 🎓 Concepts Clés à Maîtriser

1. **Vue.js Composition API**: `ref`, `reactive`, `computed`, `watch`, lifecycle hooks
2. **Vue Router**: Routes, navigation guards, programmatic navigation
3. **Supabase Client**: `.from()`, `.select()`, `.insert()`, `.update()`, `.delete()`, `.auth`, `.storage`
4. **Row Level Security**: Comprendre les politiques SQL pour sécuriser les données
5. **CSS Variables**: Design system cohérent et maintenable
6. **Composants Props/Slots/Events**: Communication parent-enfant
7. **Async/Await**: Gestion des opérations asynchrones
8. **Error Handling**: Try/catch, messages d'erreur utilisateur

---

## 📚 Ressources Utiles

- **Vue.js**: https://vuejs.org/
- **Vue Router**: https://router.vuejs.org/
- **Vite**: https://vitejs.dev/
- **Supabase**: https://supabase.com/docs
- **CSS Variables**: https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties

---

## 🎨 Philosophie de Design

**Principes**:
1. **Simplicité**: Code propre, lisible, maintenable
2. **Réutilisabilité**: Composants génériques, DRY
3. **Cohérence**: Design system strict, patterns répétés
4. **Performance**: Lazy loading, optimisations Vite
5. **Accessibilité**: Labels, ARIA, navigation clavier
6. **Responsive**: Mobile-first, fluid typography
7. **Sécurité**: RLS, validation, sanitization

---

**Date de création**: 2026
**Dernière mise à jour**: Février 2026
**Version**: 1.0
