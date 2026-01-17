-- =============================================
-- Script SQL COMPLET pour ShopCatalog avec Supabase
-- Crée les tables categories et articles avec relation
-- À exécuter dans: Supabase Dashboard > SQL Editor
-- =============================================

-- =============================================
-- 1. TABLE CATEGORIES (à créer EN PREMIER)
-- =============================================

-- Création de la table categories
CREATE TABLE IF NOT EXISTS categories (
  id BIGSERIAL PRIMARY KEY,
  nom VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  couleur VARCHAR(20) DEFAULT '#6b7280',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_categories_nom ON categories(nom);

-- =============================================
-- 2. TABLE ARTICLES (avec clé étrangère vers categories)
-- =============================================

-- Supprimer l'ancienne table articles si elle existe (ATTENTION: perte de données)
-- DROP TABLE IF EXISTS articles;

-- Création de la table articles avec relation vers categories
CREATE TABLE IF NOT EXISTS articles (
  id BIGSERIAL PRIMARY KEY,
  nom VARCHAR(255) NOT NULL,
  prix DECIMAL(10, 2) NOT NULL,
  quantite INTEGER NOT NULL DEFAULT 0,
  photo TEXT NOT NULL,
  categorie_id BIGINT NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour améliorer les performances de recherche
CREATE INDEX IF NOT EXISTS idx_articles_categorie_id ON articles(categorie_id);
CREATE INDEX IF NOT EXISTS idx_articles_nom ON articles(nom);

-- =============================================
-- 3. FONCTION ET TRIGGERS
-- =============================================

-- Fonction pour mettre à jour updated_at automatiquement
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger pour categories
DROP TRIGGER IF EXISTS update_categories_updated_at ON categories;
CREATE TRIGGER update_categories_updated_at
  BEFORE UPDATE ON categories
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trigger pour articles
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

-- Insertion des catégories
INSERT INTO categories (nom, description, couleur) VALUES
  ('Électronique', 'Appareils électroniques et gadgets', '#3b82f6'),
  ('Vêtements', 'Mode et habillement', '#f59e0b'),
  ('Chaussures', 'Chaussures et accessoires', '#8b5cf6'),
  ('Accessoires', 'Accessoires divers', '#06b6d4'),
  ('Mobilier', 'Meubles et décoration', '#10b981')
ON CONFLICT (nom) DO NOTHING;

-- Insertion des articles de démonstration (utilise les IDs des catégories)
INSERT INTO articles (nom, prix, quantite, photo, categorie_id) 
SELECT 'MacBook Pro 14"', 2499.99, 15, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&h=400&fit=crop', id FROM categories WHERE nom = 'Électronique';

INSERT INTO articles (nom, prix, quantite, photo, categorie_id) 
SELECT 'iPhone 15 Pro', 1199.99, 25, 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500&h=400&fit=crop', id FROM categories WHERE nom = 'Électronique';

INSERT INTO articles (nom, prix, quantite, photo, categorie_id) 
SELECT 'Nike Air Max 90', 149.99, 50, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=400&fit=crop', id FROM categories WHERE nom = 'Chaussures';

INSERT INTO articles (nom, prix, quantite, photo, categorie_id) 
SELECT 'Casque Sony WH-1000XM5', 379.99, 30, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=400&fit=crop', id FROM categories WHERE nom = 'Électronique';

INSERT INTO articles (nom, prix, quantite, photo, categorie_id) 
SELECT 'Sac à dos Fjällräven', 89.99, 40, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=400&fit=crop', id FROM categories WHERE nom = 'Accessoires';

INSERT INTO articles (nom, prix, quantite, photo, categorie_id) 
SELECT 'Veste en cuir classique', 299.99, 12, 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500&h=400&fit=crop', id FROM categories WHERE nom = 'Vêtements';

INSERT INTO articles (nom, prix, quantite, photo, categorie_id) 
SELECT 'Chaise de bureau ergonomique', 449.99, 8, 'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=500&h=400&fit=crop', id FROM categories WHERE nom = 'Mobilier';

INSERT INTO articles (nom, prix, quantite, photo, categorie_id) 
SELECT 'Sneakers Adidas Ultraboost', 189.99, 45, 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=500&h=400&fit=crop', id FROM categories WHERE nom = 'Chaussures';
