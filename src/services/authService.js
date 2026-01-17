/**
 * Service d'authentification avec Supabase Auth
 */

import { supabase } from '@/lib/supabase.js'

/**
 * Connexion d'un administrateur
 * @param {string} email 
 * @param {string} password 
 * @returns {Promise<Object>}
 */
export async function login(email, password) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password
  })

  if (error) {
    console.error('Erreur de connexion:', error)
    throw error
  }

  return data
}

/**
 * Inscription d'un nouvel administrateur
 * @param {string} email 
 * @param {string} password 
 * @param {string} nom 
 * @returns {Promise<Object>}
 */
export async function register(email, password, nom = '') {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: {
        nom: nom
      }
    }
  })

  if (error) {
    console.error('Erreur d\'inscription:', error)
    throw error
  }

  return data
}

/**
 * Déconnexion
 * @returns {Promise<void>}
 */
export async function logout() {
  const { error } = await supabase.auth.signOut()
  
  if (error) {
    console.error('Erreur de déconnexion:', error)
    throw error
  }
}

/**
 * Récupère l'utilisateur connecté
 * @returns {Promise<Object|null>}
 */
export async function getCurrentUser() {
  const { data: { user } } = await supabase.auth.getUser()
  return user
}

/**
 * Récupère la session actuelle
 * @returns {Promise<Object|null>}
 */
export async function getSession() {
  const { data: { session } } = await supabase.auth.getSession()
  return session
}

/**
 * Vérifie si l'utilisateur est connecté
 * @returns {Promise<boolean>}
 */
export async function isAuthenticated() {
  const session = await getSession()
  return !!session
}

/**
 * Écoute les changements d'état d'authentification
 * @param {Function} callback 
 * @returns {Function} Fonction pour se désabonner
 */
export function onAuthStateChange(callback) {
  const { data: { subscription } } = supabase.auth.onAuthStateChange(
    (event, session) => {
      callback(event, session)
    }
  )
  
  return () => subscription.unsubscribe()
}

/**
 * Réinitialisation du mot de passe
 * @param {string} email 
 * @returns {Promise<void>}
 */
export async function resetPassword(email) {
  const { error } = await supabase.auth.resetPasswordForEmail(email, {
    redirectTo: `${window.location.origin}/reset-password`
  })

  if (error) {
    console.error('Erreur reset password:', error)
    throw error
  }
}

export default {
  login,
  register,
  logout,
  getCurrentUser,
  getSession,
  isAuthenticated,
  onAuthStateChange,
  resetPassword
}
