/**
 * Service de gestion des articles avec Supabase
 * Connexion à la base de données PostgreSQL via Supabase
 * Les articles sont reliés aux catégories via categorie_id
 */

import { supabase } from '@/lib/supabase.js'
import { articles as mockArticles, categories as mockCategories } from '@/data/articles.js'

// Nom de la table dans Supabase
const TABLE_NAME = 'articles'

// Flag pour utiliser les données mock si Supabase n'est pas configuré
const useSupabase = () => {
  const key = import.meta.env.VITE_SUPABASE_ANON_KEY
  return key && key !== '' && key !== 'VOTRE_CLE_ANON'
}

// Stockage local pour le mode mock
let mockData = [...mockArticles]

/**
 * Récupère tous les articles avec leurs catégories
 * @returns {Promise<Array>} Liste des articles avec catégorie
 */
export async function getArticles() {
  if (!useSupabase()) {
    await delay(200)
    return [...mockData]
  }

  const { data, error } = await supabase
    .from(TABLE_NAME)
    .select(`
      *,
      categories:categorie_id (
        id,
        nom,
        couleur
      )
    `)
    .order('id', { ascending: true })

  if (error) {
    console.error('Erreur Supabase:', error)
    throw error
  }

  // Transformer les données pour compatibilité avec l'ancien format
  return (data || []).map(article => ({
    ...article,
    categorie: article.categories?.nom || 'Non catégorisé',
    categorie_couleur: article.categories?.couleur || '#6b7280'
  }))
}

/**
 * Récupère un article par son ID
 * @param {number} id - ID de l'article
 * @returns {Promise<Object|null>} L'article trouvé ou null
 */
export async function getArticleById(id) {
  if (!useSupabase()) {
    await delay(100)
    return mockData.find(a => a.id === parseInt(id)) || null
  }

  const { data, error } = await supabase
    .from(TABLE_NAME)
    .select(`
      *,
      categories:categorie_id (
        id,
        nom,
        couleur
      )
    `)
    .eq('id', id)
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    console.error('Erreur Supabase:', error)
    throw error
  }

  if (data) {
    return {
      ...data,
      categorie: data.categories?.nom || 'Non catégorisé',
      categorie_couleur: data.categories?.couleur || '#6b7280'
    }
  }

  return data
}

/**
 * Récupère les articles par catégorie (par ID de catégorie)
 * @param {number} categorieId - ID de la catégorie
 * @returns {Promise<Array>} Liste des articles de la catégorie
 */
export async function getArticlesByCategory(categorieId) {
  if (!useSupabase()) {
    await delay(200)
    return mockData.filter(a => a.categorie_id === categorieId)
  }

  const { data, error } = await supabase
    .from(TABLE_NAME)
    .select(`
      *,
      categories:categorie_id (
        id,
        nom,
        couleur
      )
    `)
    .eq('categorie_id', categorieId)
    .order('id', { ascending: true })

  if (error) {
    console.error('Erreur Supabase:', error)
    throw error
  }

  return (data || []).map(article => ({
    ...article,
    categorie: article.categories?.nom || 'Non catégorisé',
    categorie_couleur: article.categories?.couleur || '#6b7280'
  }))
}

/**
 * Crée un nouvel article
 * @param {Object} articleData - Données de l'article (avec categorie_id)
 * @returns {Promise<Object>} L'article créé
 */
export async function createArticle(articleData) {
  if (!useSupabase()) {
    await delay(300)
    const newArticle = {
      id: Math.max(...mockData.map(a => a.id), 0) + 1,
      nom: articleData.nom,
      prix: parseFloat(articleData.prix),
      quantite: parseInt(articleData.quantite),
      photo: articleData.photo,
      categorie_id: articleData.categorie_id,
      categorie: articleData.categorie
    }
    mockData.push(newArticle)
    return newArticle
  }

  const { data, error } = await supabase
    .from(TABLE_NAME)
    .insert([{
      nom: articleData.nom,
      prix: parseFloat(articleData.prix),
      quantite: parseInt(articleData.quantite),
      photo: articleData.photo,
      categorie_id: articleData.categorie_id
    }])
    .select(`
      *,
      categories:categorie_id (
        id,
        nom,
        couleur
      )
    `)
    .single()

  if (error) {
    console.error('Erreur Supabase:', error)
    throw error
  }

  return {
    ...data,
    categorie: data.categories?.nom || 'Non catégorisé',
    categorie_couleur: data.categories?.couleur || '#6b7280'
  }
}

/**
 * Met à jour un article existant
 * @param {number} id - ID de l'article
 * @param {Object} articleData - Nouvelles données (avec categorie_id)
 * @returns {Promise<Object|null>} L'article mis à jour ou null
 */
export async function updateArticle(id, articleData) {
  if (!useSupabase()) {
    await delay(300)
    const index = mockData.findIndex(a => a.id === parseInt(id))
    if (index === -1) return null
    mockData[index] = { ...mockData[index], ...articleData }
    return mockData[index]
  }

  const { data, error } = await supabase
    .from(TABLE_NAME)
    .update({
      nom: articleData.nom,
      prix: parseFloat(articleData.prix),
      quantite: parseInt(articleData.quantite),
      photo: articleData.photo,
      categorie_id: articleData.categorie_id
    })
    .eq('id', id)
    .select(`
      *,
      categories:categorie_id (
        id,
        nom,
        couleur
      )
    `)
    .single()

  if (error) {
    console.error('Erreur Supabase:', error)
    throw error
  }

  return {
    ...data,
    categorie: data.categories?.nom || 'Non catégorisé',
    categorie_couleur: data.categories?.couleur || '#6b7280'
  }
}

/**
 * Supprime un article
 * @param {number} id - ID de l'article
 * @returns {Promise<boolean>} true si supprimé, false sinon
 */
export async function deleteArticle(id) {
  if (!useSupabase()) {
    await delay(200)
    const index = mockData.findIndex(a => a.id === parseInt(id))
    if (index === -1) return false
    mockData.splice(index, 1)
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
 * Récupère toutes les catégories (noms uniquement pour compatibilité)
 * @returns {Promise<Array>} Liste des noms de catégories
 */
export async function getCategories() {
  if (!useSupabase()) {
    await delay(100)
    return [...mockCategories]
  }

  // Essayer d'abord de récupérer depuis la table categories
  const { data: categoriesData, error: categoriesError } = await supabase
    .from('categories')
    .select('nom')
    .order('nom', { ascending: true })

  if (!categoriesError && categoriesData && categoriesData.length > 0) {
    return categoriesData.map(c => c.nom)
  }

  // Fallback: récupérer les catégories depuis les articles existants
  const { data, error } = await supabase
    .from(TABLE_NAME)
    .select('categorie')
    .order('categorie', { ascending: true })

  if (error) {
    console.error('Erreur Supabase:', error)
    throw error
  }

  const categories = [...new Set(data.map(item => item.categorie))]
  return categories
}

/**
 * Recherche des articles
 * @param {string} query - Terme de recherche
 * @returns {Promise<Array>} Liste des articles correspondants
 */
export async function searchArticles(query) {
  if (!useSupabase()) {
    await delay(200)
    const searchTerm = query.toLowerCase()
    return mockData.filter(a =>
      a.nom.toLowerCase().includes(searchTerm) ||
      a.categorie.toLowerCase().includes(searchTerm)
    )
  }

  const { data, error } = await supabase
    .from(TABLE_NAME)
    .select('*')
    .or(`nom.ilike.%${query}%,categorie.ilike.%${query}%`)
    .order('id', { ascending: true })

  if (error) {
    console.error('Erreur Supabase:', error)
    throw error
  }

  return data || []
}

/**
 * Initialise la table avec les données de démonstration
 * @returns {Promise<boolean>}
 */
export async function seedDatabase() {
  if (!useSupabase()) {
    console.log('Supabase non configuré')
    return false
  }

  try {
    const { data: existing } = await supabase
      .from(TABLE_NAME)
      .select('id')
      .limit(1)

    if (existing && existing.length > 0) {
      console.log('Données déjà présentes')
      return false
    }

    const articlesToInsert = mockArticles.map(({ id, ...rest }) => rest)
    
    const { error } = await supabase
      .from(TABLE_NAME)
      .insert(articlesToInsert)

    if (error) throw error

    console.log('Base initialisée avec succès')
    return true
  } catch (error) {
    console.error('Erreur seeding:', error)
    return false
  }
}

// Utilitaire pour simuler un délai réseau
function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms))
}

// Export par défaut de l'API
export default {
  getArticles,
  getArticleById,
  getArticlesByCategory,
  createArticle,
  updateArticle,
  deleteArticle,
  getCategories,
  searchArticles
}
