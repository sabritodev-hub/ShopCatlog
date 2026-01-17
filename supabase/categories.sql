-- =============================================
-- Script SQL pour créer la table categories dans Supabase
-- À exécuter dans: Supabase Dashboard > SQL Editor
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

-- Trigger pour updated_at
DROP TRIGGER IF EXISTS update_categories_updated_at ON categories;
CREATE TRIGGER update_categories_updated_at
  BEFORE UPDATE ON categories
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Activer Row Level Security (RLS)
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Politique pour permettre la lecture publique
CREATE POLICY "Lecture publique des categories" ON categories
  FOR SELECT
  USING (true);

-- Politique pour permettre l'insertion aux utilisateurs authentifiés
CREATE POLICY "Insertion des categories par admin" ON categories
  FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- Politique pour permettre la modification aux utilisateurs authentifiés
CREATE POLICY "Modification des categories par admin" ON categories
  FOR UPDATE
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

-- Politique pour permettre la suppression aux utilisateurs authentifiés
CREATE POLICY "Suppression des categories par admin" ON categories
  FOR DELETE
  USING (auth.role() = 'authenticated');

-- =============================================
-- Insertion des catégories par défaut
-- =============================================
INSERT INTO categories (nom, description, couleur) VALUES
  ('Électronique', 'Appareils électroniques et gadgets', '#3b82f6'),
  ('Vêtements', 'Mode et habillement', '#f59e0b'),
  ('Chaussures', 'Chaussures et accessoires', '#8b5cf6'),
  ('Accessoires', 'Accessoires divers', '#06b6d4'),
  ('Mobilier', 'Meubles et décoration', '#10b981')
ON CONFLICT (nom) DO NOTHING;
