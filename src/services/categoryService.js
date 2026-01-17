/**
 * Service de gestion des catégories avec Supabase
 */

import { supabase } from '@/lib/supabase.js'

// Nom de la table dans Supabase
const TABLE_NAME = 'categories'

// Flag pour utiliser les données mock si Supabase n'est pas configuré
const useSupabase = () => {
  const key = import.meta.env.VITE_SUPABASE_ANON_KEY
  return key && key !== '' && key !== 'VOTRE_CLE_ANON'
}

// Stockage local pour le mode mock
let mockCategories = [
  { id: 1, nom: 'Électronique', description: 'Appareils électroniques et gadgets', couleur: '#3b82f6' },
  { id: 2, nom: 'Vêtements', description: 'Mode et habillement', couleur: '#f59e0b' },
  { id: 3, nom: 'Chaussures', description: 'Chaussures et accessoires', couleur: '#8b5cf6' },
  { id: 4, nom: 'Accessoires', description: 'Accessoires divers', couleur: '#06b6d4' },
  { id: 5, nom: 'Mobilier', description: 'Meubles et décoration', couleur: '#10b981' }
]

/**
 * Récupère toutes les catégories
 * @returns {Promise<Array>} Liste des catégories
 */
export async function getCategories() {
  if (!useSupabase()) {
    await delay(200)
    return [...mockCategories]
  }

  const { data, error } = await supabase
    .from(TABLE_NAME)
    .select('*')
    .order('nom', { ascending: true })

  if (error) {
    console.error('Erreur Supabase:', error)
    throw error
  }

  return data || []
}

/**
 * Récupère une catégorie par son ID
 * @param {number} id - ID de la catégorie
 * @returns {Promise<Object|null>} La catégorie trouvée ou null
 */
export async function getCategoryById(id) {
  if (!useSupabase()) {
    await delay(100)
    return mockCategories.find(c => c.id === parseInt(id)) || null
  }

  const { data, error } = await supabase
    .from(TABLE_NAME)
    .select('*')
    .eq('id', id)
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    console.error('Erreur Supabase:', error)
    throw error
  }

  return data
}

/**
 * Crée une nouvelle catégorie
 * @param {Object} categoryData - Données de la catégorie
 * @returns {Promise<Object>} La catégorie créée
 */
export async function createCategory(categoryData) {
  if (!useSupabase()) {
    await delay(300)
    const newCategory = {
      id: Math.max(...mockCategories.map(c => c.id), 0) + 1,
      nom: categoryData.nom,
      description: categoryData.description || '',
      couleur: categoryData.couleur || '#6b7280'
    }
    mockCategories.push(newCategory)
    return newCategory
  }

  const { data, error } = await supabase
    .from(TABLE_NAME)
    .insert([{
      nom: categoryData.nom,
      description: categoryData.description || '',
      couleur: categoryData.couleur || '#6b7280'
    }])
    .select()
    .single()

  if (error) {
    console.error('Erreur Supabase:', error)
    throw error
  }

  return data
}

/**
 * Met à jour une catégorie existante
 * @param {number} id - ID de la catégorie
 * @param {Object} categoryData - Nouvelles données
 * @returns {Promise<Object|null>} La catégorie mise à jour ou null
 */
export async function updateCategory(id, categoryData) {
  if (!useSupabase()) {
    await delay(300)
    const index = mockCategories.findIndex(c => c.id === parseInt(id))
    if (index === -1) return null
    mockCategories[index] = { ...mockCategories[index], ...categoryData }
    return mockCategories[index]
  }

  const { data, error } = await supabase
    .from(TABLE_NAME)
    .update({
      nom: categoryData.nom,
      description: categoryData.description,
      couleur: categoryData.couleur
    })
    .eq('id', id)
    .select()
    .single()

  if (error) {
    console.error('Erreur Supabase:', error)
    throw error
  }

  return data
}

/**
 * Supprime une catégorie
 * @param {number} id - ID de la catégorie
 * @returns {Promise<boolean>} true si supprimée, false sinon
 */
export async function deleteCategory(id) {
  if (!useSupabase()) {
    await delay(200)
    const index = mockCategories.findIndex(c => c.id === parseInt(id))
    if (index === -1) return false
    mockCategories.splice(index, 1)
    return true
  }

  const { error } = await supabase
    .from(TABLE_NAME)
    .delete()
    .eq('id', id)

  if (error) {
    console.error('Erreur Supabase:', error)
    throw error
  }

  return true
}

/**
 * Récupère les noms de catégories (pour les sélecteurs)
 * @returns {Promise<Array<string>>} Liste des noms de catégories
 */
export async function getCategoryNames() {
  const categories = await getCategories()
  return categories.map(c => c.nom)
}

// Utilitaire pour simuler un délai réseau
function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms))
}

export default {
  getCategories,
  getCategoryById,
  createCategory,
  updateCategory,
  deleteCategory,
  getCategoryNames
}
