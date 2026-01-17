/**
 * Configuration et client Supabase
 */
import { createClient } from '@supabase/supabase-js'

// Configuration Supabase
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://oxtwoujwwnzbcnaovvqv.supabase.co'
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || ''

// Options de configuration pour le client Supabase
const supabaseOptions = {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true
  }
}

// Création du client Supabase
export const supabase = createClient(supabaseUrl, supabaseAnonKey, supabaseOptions)

// Fonction utilitaire pour vérifier si Supabase est configuré
export const isSupabaseConfigured = () => {
  return supabaseUrl && supabaseAnonKey && supabaseAnonKey.length > 0
}

export default supabase
