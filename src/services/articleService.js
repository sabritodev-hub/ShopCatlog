/**
 * Service de gestion des articles
 * Simule des appels API avec les données locales
 * Sera facilement remplaçable par de vrais appels API plus tard
 */

import { articles as initialArticles, categories } from '@/data/articles.js'

// Stockage local des articles (simulation de base de données)
let articlesData = [...initialArticles]
let nextId = Math.max(...articlesData.map(a => a.id)) + 1

/**
 * Récupère tous les articles
 * @returns {Promise<Array>} Liste des articles
 */
export async function getArticles() {
  // Simule un délai réseau
  await delay(200)
  return [...articlesData]
}

/**
 * Récupère un article par son ID
 * @param {number} id - ID de l'article
 * @returns {Promise<Object|null>} L'article trouvé ou null
 */
export async function getArticleById(id) {
  await delay(100)
  const article = articlesData.find(a => a.id === parseInt(id))
  return article ? { ...article } : null
}

/**
 * Récupère les articles par catégorie
 * @param {string} categorie - Nom de la catégorie
 * @returns {Promise<Array>} Liste des articles de la catégorie
 */
export async function getArticlesByCategory(categorie) {
  await delay(200)
  return articlesData.filter(a => a.categorie === categorie).map(a => ({ ...a }))
}

/**
 * Crée un nouvel article
 * @param {Object} articleData - Données de l'article
 * @returns {Promise<Object>} L'article créé
 */
export async function createArticle(articleData) {
  await delay(300)
  
  const newArticle = {
    id: nextId++,
    nom: articleData.nom,
    prix: parseFloat(articleData.prix),
    quantite: parseInt(articleData.quantite),
    photo: articleData.photo,
    categorie: articleData.categorie
  }
  
  articlesData.push(newArticle)
  return { ...newArticle }
}

/**
 * Met à jour un article existant
 * @param {number} id - ID de l'article
 * @param {Object} articleData - Nouvelles données
 * @returns {Promise<Object|null>} L'article mis à jour ou null
 */
export async function updateArticle(id, articleData) {
  await delay(300)
  
  const index = articlesData.findIndex(a => a.id === parseInt(id))
  if (index === -1) return null
  
  const updatedArticle = {
    ...articlesData[index],
    nom: articleData.nom ?? articlesData[index].nom,
    prix: articleData.prix !== undefined ? parseFloat(articleData.prix) : articlesData[index].prix,
    quantite: articleData.quantite !== undefined ? parseInt(articleData.quantite) : articlesData[index].quantite,
    photo: articleData.photo ?? articlesData[index].photo,
    categorie: articleData.categorie ?? articlesData[index].categorie
  }
  
  articlesData[index] = updatedArticle
  return { ...updatedArticle }
}

/**
 * Supprime un article
 * @param {number} id - ID de l'article
 * @returns {Promise<boolean>} true si supprimé, false sinon
 */
export async function deleteArticle(id) {
  await delay(200)
  
  const index = articlesData.findIndex(a => a.id === parseInt(id))
  if (index === -1) return false
  
  articlesData.splice(index, 1)
  return true
}

/**
 * Récupère toutes les catégories
 * @returns {Promise<Array>} Liste des catégories
 */
export async function getCategories() {
  await delay(100)
  return [...categories]
}

/**
 * Recherche des articles
 * @param {string} query - Terme de recherche
 * @returns {Promise<Array>} Liste des articles correspondants
 */
export async function searchArticles(query) {
  await delay(200)
  
  const searchTerm = query.toLowerCase()
  return articlesData
    .filter(a => 
      a.nom.toLowerCase().includes(searchTerm) ||
      a.categorie.toLowerCase().includes(searchTerm)
    )
    .map(a => ({ ...a }))
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
