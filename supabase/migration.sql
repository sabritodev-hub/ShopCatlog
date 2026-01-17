-- =============================================
-- Script de MIGRATION pour ShopCatalog
-- Modifie les tables existantes (categories + articles)
-- Ajoute le support multi-photos avec Supabase Storage
-- NE TOUCHE PAS à la table users
-- À exécuter dans: Supabase Dashboard > SQL Editor
-- =============================================

-- =============================================
-- 1. FONCTION UTILITAIRE (créée si n'existe pas)
-- =============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- =============================================
-- 2. TABLE CATEGORIES - Création ou mise à jour
-- =============================================

-- Créer la table si elle n'existe pas
CREATE TABLE IF NOT EXISTS categories (
  id BIGSERIAL PRIMARY KEY,
  nom VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  couleur VARCHAR(20) DEFAULT '#6b7280',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Ajouter les colonnes manquantes si elles n'existent pas
DO $$
BEGIN
  -- Ajouter description si manquante
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'categories' AND column_name = 'description') THEN
    ALTER TABLE categories ADD COLUMN description TEXT;
  END IF;
  
  -- Ajouter couleur si manquante
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'categories' AND column_name = 'couleur') THEN
    ALTER TABLE categories ADD COLUMN couleur VARCHAR(20) DEFAULT '#6b7280';
  END IF;
  
  -- Ajouter created_at si manquant
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'categories' AND column_name = 'created_at') THEN
    ALTER TABLE categories ADD COLUMN created_at TIMESTAMPTZ DEFAULT NOW();
  END IF;
  
  -- Ajouter updated_at si manquant
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'categories' AND column_name = 'updated_at') THEN
    ALTER TABLE categories ADD COLUMN updated_at TIMESTAMPTZ DEFAULT NOW();
  END IF;
END $$;

-- Index pour les catégories
CREATE INDEX IF NOT EXISTS idx_categories_nom ON categories(nom);

-- Trigger pour updated_at sur categories
DROP TRIGGER IF EXISTS update_categories_updated_at ON categories;
CREATE TRIGGER update_categories_updated_at
  BEFORE UPDATE ON categories
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- 3. TABLE ARTICLES - Mise à jour avec categorie_id et photos multiples
-- =============================================

-- Si la table articles existe mais n'a pas categorie_id, on doit la modifier
DO $$
BEGIN
  -- Vérifier si la table articles existe
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'articles') THEN
    
    -- Ajouter categorie_id si manquant
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'articles' AND column_name = 'categorie_id') THEN
      -- Ajouter la colonne categorie_id (nullable d'abord)
      ALTER TABLE articles ADD COLUMN categorie_id BIGINT;
      
      -- Si une colonne 'categorie' (texte) existe, migrer les données
      IF EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'articles' AND column_name = 'categorie') THEN
        -- Mettre à jour categorie_id en fonction du nom de catégorie existant
        UPDATE articles a
        SET categorie_id = c.id
        FROM categories c
        WHERE LOWER(a.categorie) = LOWER(c.nom);
        
        -- Supprimer l'ancienne colonne categorie (texte)
        ALTER TABLE articles DROP COLUMN IF EXISTS categorie;
      END IF;
      
      -- Ajouter la contrainte de clé étrangère
      ALTER TABLE articles 
        ADD CONSTRAINT fk_articles_categories 
        FOREIGN KEY (categorie_id) 
        REFERENCES categories(id) 
        ON DELETE RESTRICT;
    END IF;
    
    -- Ajouter les colonnes pour photos supplémentaires
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'articles' AND column_name = 'photo_2') THEN
      ALTER TABLE articles ADD COLUMN photo_2 TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'articles' AND column_name = 'photo_3') THEN
      ALTER TABLE articles ADD COLUMN photo_3 TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'articles' AND column_name = 'photo_4') THEN
      ALTER TABLE articles ADD COLUMN photo_4 TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'articles' AND column_name = 'photo_5') THEN
      ALTER TABLE articles ADD COLUMN photo_5 TEXT;
    END IF;
    
    -- Ajouter description de l'article
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'articles' AND column_name = 'description') THEN
      ALTER TABLE articles ADD COLUMN description TEXT;
    END IF;
    
  ELSE
    -- Créer la table articles si elle n'existe pas
    CREATE TABLE articles (
      id BIGSERIAL PRIMARY KEY,
      nom VARCHAR(255) NOT NULL,
      description TEXT,
      prix DECIMAL(10, 2) NOT NULL,
      quantite INTEGER NOT NULL DEFAULT 0,
      photo TEXT NOT NULL,
      photo_2 TEXT,
      photo_3 TEXT,
      photo_4 TEXT,
      photo_5 TEXT,
      categorie_id BIGINT NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      updated_at TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;
END $$;

-- Ajouter colonnes manquantes sur articles
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'articles' AND column_name = 'created_at') THEN
    ALTER TABLE articles ADD COLUMN created_at TIMESTAMPTZ DEFAULT NOW();
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'articles' AND column_name = 'updated_at') THEN
    ALTER TABLE articles ADD COLUMN updated_at TIMESTAMPTZ DEFAULT NOW();
  END IF;
END $$;

-- Index pour articles
CREATE INDEX IF NOT EXISTS idx_articles_categorie_id ON articles(categorie_id);
CREATE INDEX IF NOT EXISTS idx_articles_nom ON articles(nom);

-- Trigger pour updated_at sur articles
DROP TRIGGER IF EXISTS update_articles_updated_at ON articles;
CREATE TRIGGER update_articles_updated_at
  BEFORE UPDATE ON articles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- 4. ROW LEVEL SECURITY (RLS)
-- =============================================

-- Categories RLS
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Supprimer les anciennes policies pour éviter les conflits
DROP POLICY IF EXISTS "Lecture publique des categories" ON categories;
DROP POLICY IF EXISTS "Insertion des categories par admin" ON categories;
DROP POLICY IF EXISTS "Modification des categories par admin" ON categories;
DROP POLICY IF EXISTS "Suppression des categories par admin" ON categories;

-- Recréer les policies
CREATE POLICY "Lecture publique des categories" ON categories
  FOR SELECT USING (true);

CREATE POLICY "Insertion des categories par admin" ON categories
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Modification des categories par admin" ON categories
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Suppression des categories par admin" ON categories
  FOR DELETE USING (auth.role() = 'authenticated');

-- Articles RLS
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;

-- Supprimer les anciennes policies
DROP POLICY IF EXISTS "Lecture publique des articles" ON articles;
DROP POLICY IF EXISTS "Insertion des articles par admin" ON articles;
DROP POLICY IF EXISTS "Modification des articles par admin" ON articles;
DROP POLICY IF EXISTS "Suppression des articles par admin" ON articles;

-- Recréer les policies
CREATE POLICY "Lecture publique des articles" ON articles
  FOR SELECT USING (true);

CREATE POLICY "Insertion des articles par admin" ON articles
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Modification des articles par admin" ON articles
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Suppression des articles par admin" ON articles
  FOR DELETE USING (auth.role() = 'authenticated');

-- =============================================
-- 5. DONNÉES DE DÉMONSTRATION
-- =============================================

-- Insérer les catégories par défaut (ignorées si existent déjà)
INSERT INTO categories (nom, description, couleur) VALUES
  ('Électronique', 'Appareils électroniques et gadgets', '#3b82f6'),
  ('Vêtements', 'Mode et habillement', '#f59e0b'),
  ('Chaussures', 'Chaussures et accessoires', '#8b5cf6'),
  ('Accessoires', 'Accessoires divers', '#06b6d4'),
  ('Mobilier', 'Meubles et décoration', '#10b981')
ON CONFLICT (nom) DO NOTHING;

-- =============================================
-- 6. CONFIGURATION SUPABASE STORAGE
-- =============================================
-- IMPORTANT: Le bucket doit être créé manuellement dans Supabase Dashboard
-- Aller dans: Storage > New Bucket > Nom: "articles" > Public: ON

-- =============================================
-- 7. VÉRIFICATION FINALE
-- =============================================
SELECT 
  'Migration terminée avec succès!' AS status,
  (SELECT COUNT(*) FROM categories) AS nb_categories,
  (SELECT COUNT(*) FROM articles) AS nb_articles;
