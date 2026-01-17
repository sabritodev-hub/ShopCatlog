-- =============================================
-- Script SQL pour créer la table articles dans Supabase
-- À exécuter dans: Supabase Dashboard > SQL Editor
-- =============================================

-- Création de la table articles
CREATE TABLE IF NOT EXISTS articles (
  id BIGSERIAL PRIMARY KEY,
  nom VARCHAR(255) NOT NULL,
  prix DECIMAL(10, 2) NOT NULL,
  quantite INTEGER NOT NULL DEFAULT 0,
  photo TEXT NOT NULL,
  categorie VARCHAR(100) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour améliorer les performances de recherche
CREATE INDEX IF NOT EXISTS idx_articles_categorie ON articles(categorie);
CREATE INDEX IF NOT EXISTS idx_articles_nom ON articles(nom);

-- Fonction pour mettre à jour updated_at automatiquement
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger pour updated_at
DROP TRIGGER IF EXISTS update_articles_updated_at ON articles;
CREATE TRIGGER update_articles_updated_at
  BEFORE UPDATE ON articles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Activer Row Level Security (RLS)
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;

-- Politique pour permettre la lecture publique
CREATE POLICY "Lecture publique des articles" ON articles
  FOR SELECT
  USING (true);

-- Politique pour permettre l'insertion (à adapter selon vos besoins d'auth)
CREATE POLICY "Insertion des articles" ON articles
  FOR INSERT
  WITH CHECK (true);

-- Politique pour permettre la modification
CREATE POLICY "Modification des articles" ON articles
  FOR UPDATE
  USING (true);

-- Politique pour permettre la suppression
CREATE POLICY "Suppression des articles" ON articles
  FOR DELETE
  USING (true);

-- =============================================
-- Données de démonstration (optionnel)
-- =============================================

INSERT INTO articles (nom, prix, quantite, photo, categorie) VALUES
  ('MacBook Pro 14"', 2499.99, 15, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&h=400&fit=crop', 'Électronique'),
  ('iPhone 15 Pro', 1199.99, 25, 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500&h=400&fit=crop', 'Électronique'),
  ('Nike Air Max 90', 149.99, 50, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=400&fit=crop', 'Chaussures'),
  ('Casque Sony WH-1000XM5', 379.99, 30, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=400&fit=crop', 'Électronique'),
  ('Sac à dos Fjällräven', 89.99, 40, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=400&fit=crop', 'Accessoires'),
  ('Montre Apple Watch Ultra', 899.99, 20, 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=500&h=400&fit=crop', 'Électronique'),
  ('Veste en cuir classique', 299.99, 12, 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500&h=400&fit=crop', 'Vêtements'),
  ('Lunettes de soleil Ray-Ban', 179.99, 35, 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500&h=400&fit=crop', 'Accessoires'),
  ('Chaise de bureau ergonomique', 449.99, 8, 'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=500&h=400&fit=crop', 'Mobilier'),
  ('Sneakers Adidas Ultraboost', 189.99, 45, 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=500&h=400&fit=crop', 'Chaussures'),
  ('Tablette iPad Pro 12.9"', 1299.99, 18, 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=400&fit=crop', 'Électronique'),
  ('Lampe de bureau LED', 79.99, 60, 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=500&h=400&fit=crop', 'Mobilier');
