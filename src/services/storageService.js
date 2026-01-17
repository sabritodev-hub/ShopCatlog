/**
 * Service de gestion des fichiers avec Supabase Storage
 * Permet l'upload et la suppression d'images pour les articles
 */

import { supabase } from '@/lib/supabase.js'

// Nom du bucket pour les images d'articles
const BUCKET_NAME = 'articles'

/**
 * Upload une image vers Supabase Storage
 * @param {File} file - Le fichier image à uploader
 * @param {string} folder - Le dossier de destination (ex: 'covers', 'gallery')
 * @returns {Promise<{url: string, path: string}>} L'URL publique et le chemin du fichier
 */
export async function uploadImage(file, folder = 'images') {
  if (!file) {
    throw new Error('Aucun fichier fourni')
  }

  // Vérifier le type de fichier
  const allowedTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif']
  if (!allowedTypes.includes(file.type)) {
    throw new Error('Type de fichier non autorisé. Utilisez JPG, PNG, WebP ou GIF.')
  }

  // Limiter la taille à 5MB
  const maxSize = 5 * 1024 * 1024
  if (file.size > maxSize) {
    throw new Error('Le fichier est trop volumineux. Taille maximale: 5MB')
  }

  // Générer un nom de fichier unique
  const timestamp = Date.now()
  const randomString = Math.random().toString(36).substring(2, 8)
  const extension = file.name.split('.').pop()
  const fileName = `${folder}/${timestamp}_${randomString}.${extension}`

  // Upload vers Supabase Storage
  const { data, error } = await supabase.storage
    .from(BUCKET_NAME)
    .upload(fileName, file, {
      cacheControl: '3600',
      upsert: false
    })

  if (error) {
    console.error('Erreur upload:', error)
    throw new Error(`Erreur lors de l'upload: ${error.message}`)
  }

  // Récupérer l'URL publique
  const { data: urlData } = supabase.storage
    .from(BUCKET_NAME)
    .getPublicUrl(data.path)

  return {
    url: urlData.publicUrl,
    path: data.path
  }
}

/**
 * Upload plusieurs images
 * @param {FileList|File[]} files - Les fichiers à uploader
 * @param {string} folder - Le dossier de destination
 * @returns {Promise<Array<{url: string, path: string}>>} Liste des URLs et chemins
 */
export async function uploadMultipleImages(files, folder = 'images') {
  const uploadPromises = Array.from(files).map(file => uploadImage(file, folder))
  return Promise.all(uploadPromises)
}

/**
 * Supprime une image de Supabase Storage
 * @param {string} path - Le chemin du fichier à supprimer
 * @returns {Promise<void>}
 */
export async function deleteImage(path) {
  if (!path) return

  // Ne supprimer que les fichiers hébergés sur Supabase
  if (!path.includes(BUCKET_NAME)) return

  // Extraire le chemin relatif depuis l'URL
  const relativePath = path.split(`${BUCKET_NAME}/`).pop()
  
  if (!relativePath) return

  const { error } = await supabase.storage
    .from(BUCKET_NAME)
    .remove([relativePath])

  if (error) {
    console.error('Erreur suppression:', error)
    throw new Error(`Erreur lors de la suppression: ${error.message}`)
  }
}

/**
 * Supprime plusieurs images
 * @param {string[]} paths - Les chemins des fichiers à supprimer
 * @returns {Promise<void>}
 */
export async function deleteMultipleImages(paths) {
  const validPaths = paths.filter(p => p && p.includes(BUCKET_NAME))
  
  if (validPaths.length === 0) return

  const relativePaths = validPaths.map(path => path.split(`${BUCKET_NAME}/`).pop())
  
  const { error } = await supabase.storage
    .from(BUCKET_NAME)
    .remove(relativePaths)

  if (error) {
    console.error('Erreur suppression multiple:', error)
    throw new Error(`Erreur lors de la suppression: ${error.message}`)
  }
}

/**
 * Vérifie si une URL est une image Supabase Storage
 * @param {string} url - L'URL à vérifier
 * @returns {boolean}
 */
export function isSupabaseStorageUrl(url) {
  return url && url.includes('supabase') && url.includes(BUCKET_NAME)
}
