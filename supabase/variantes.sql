-- =============================================
-- Table pour les variantes d'articles
-- À exécuter dans: Supabase Dashboard > SQL Editor
-- =============================================

CREATE TABLE IF NOT EXISTS article_variantes (
  id BIGSERIAL PRIMARY KEY,
  article_id BIGINT NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  nom_variante VARCHAR(100) NOT NULL,
  valeur VARCHAR(255) NOT NULL,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour les performances
CREATE INDEX IF NOT EXISTS idx_article_variantes_article_id ON article_variantes(article_id);

-- Fonction pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_variantes_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger pour updated_at
DROP TRIGGER IF EXISTS update_article_variantes_updated_at ON article_variantes;
CREATE TRIGGER update_article_variantes_updated_at
  BEFORE UPDATE ON article_variantes
  FOR EACH ROW
  EXECUTE FUNCTION update_variantes_updated_at_column();

-- Activer Row Level Security (RLS)
ALTER TABLE article_variantes ENABLE ROW LEVEL SECURITY;

-- Politique pour permettre la lecture publique
CREATE POLICY "Lecture publique des variantes" ON article_variantes
  FOR SELECT
  USING (true);

-- Politique pour permettre l'insertion
CREATE POLICY "Insertion des variantes" ON article_variantes
  FOR INSERT
  WITH CHECK (true);

-- Politique pour permettre la modification
CREATE POLICY "Modification des variantes" ON article_variantes
  FOR UPDATE
  USING (true);

-- Politique pour permettre la suppression
CREATE POLICY "Suppression des variantes" ON article_variantes
  FOR DELETE
  USING (true);

-- =============================================
-- Exemples de variantes (optionnel)
-- =============================================

-- Variantes de couleur pour Nike Air Max 90 (id 3)
-- INSERT INTO article_variantes (article_id, nom_variante, valeur, image_url) VALUES
-- (3, 'Couleur', 'Noir', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=400&fit=crop'),
-- (3, 'Couleur', 'Blanc', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=400&fit=crop'),
-- (3, 'Couleur', 'Rouge', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=400&fit=crop'),
-- (3, 'Taille', '36', NULL),
-- (3, 'Taille', '37', NULL),
-- (3, 'Taille', '38', NULL),
-- (3, 'Taille', '39', NULL),
-- (3, 'Taille', '40', NULL);
