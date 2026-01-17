-- =============================================
-- Table et configuration pour les administrateurs
-- À exécuter dans: Supabase Dashboard > SQL Editor
-- =============================================

-- Table pour les profils administrateurs
CREATE TABLE IF NOT EXISTS admin_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL,
  nom VARCHAR(255),
  role VARCHAR(50) DEFAULT 'admin',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index
CREATE INDEX IF NOT EXISTS idx_admin_profiles_email ON admin_profiles(email);

-- Activer RLS
ALTER TABLE admin_profiles ENABLE ROW LEVEL SECURITY;

-- Politique: les admins peuvent voir leur propre profil
CREATE POLICY "Les admins peuvent voir leur profil" ON admin_profiles
  FOR SELECT
  USING (auth.uid() = id);

-- Politique: les admins peuvent modifier leur profil
CREATE POLICY "Les admins peuvent modifier leur profil" ON admin_profiles
  FOR UPDATE
  USING (auth.uid() = id);

-- =============================================
-- Mettre à jour les politiques des articles pour l'admin
-- =============================================

-- Supprimer les anciennes politiques trop permissives
DROP POLICY IF EXISTS "Insertion des articles" ON articles;
DROP POLICY IF EXISTS "Modification des articles" ON articles;
DROP POLICY IF EXISTS "Suppression des articles" ON articles;

-- Nouvelle politique: seuls les admins authentifiés peuvent insérer
CREATE POLICY "Admins peuvent insérer" ON articles
  FOR INSERT
  WITH CHECK (
    EXISTS (SELECT 1 FROM admin_profiles WHERE id = auth.uid())
  );

-- Nouvelle politique: seuls les admins authentifiés peuvent modifier
CREATE POLICY "Admins peuvent modifier" ON articles
  FOR UPDATE
  USING (
    EXISTS (SELECT 1 FROM admin_profiles WHERE id = auth.uid())
  );

-- Nouvelle politique: seuls les admins authentifiés peuvent supprimer
CREATE POLICY "Admins peuvent supprimer" ON articles
  FOR DELETE
  USING (
    EXISTS (SELECT 1 FROM admin_profiles WHERE id = auth.uid())
  );

-- =============================================
-- Fonction pour créer automatiquement un profil admin
-- lors de l'inscription
-- =============================================

CREATE OR REPLACE FUNCTION public.handle_new_admin()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.admin_profiles (id, email, nom)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'nom');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger pour créer le profil automatiquement
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_admin();
