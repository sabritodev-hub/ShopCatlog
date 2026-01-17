<template>
  <div class="login-page">
    <div class="login-container">
      <div class="login-header">
        <span class="login-icon">🔐</span>
        <h1>Administration</h1>
        <p>Connectez-vous pour gérer les articles</p>
      </div>
      
      <form @submit.prevent="handleSubmit" class="login-form">
        <div v-if="error" class="error-message">
          {{ error }}
        </div>
        
        <BaseInput
          v-model="email"
          type="email"
          label="Email"
          placeholder="admin@example.com"
          :error="errors.email"
          required
        />
        
        <BaseInput
          v-model="password"
          type="password"
          label="Mot de passe"
          placeholder="••••••••"
          :error="errors.password"
          required
        />
        
        <BaseButton
          type="submit"
          variant="primary"
          :loading="loading"
          full-width
        >
          Se connecter
        </BaseButton>
      </form>
      
      <div class="login-footer">
        <p class="text-muted text-sm">
          Accès réservé aux administrateurs
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import { BaseInput, BaseButton, BaseModal } from '@/components/ui'
import { login, register } from '@/services/authService.js'

export default {
  name: 'LoginPage',
  components: {
    BaseInput,
    BaseButton,
    BaseModal
  },
  data() {
    return {
      email: '',
      password: '',
      error: '',
      errors: {},
      loading: false,
      showRegister: false,
      registerForm: {
        nom: '',
        email: '',
        password: '',
        confirmPassword: ''
      },
      registerError: '',
      registerSuccess: '',
      registerLoading: false
    }
  },
  methods: {
    validate() {
      this.errors = {}
      
      if (!this.email) {
        this.errors.email = 'L\'email est requis'
      }
      
      if (!this.password) {
        this.errors.password = 'Le mot de passe est requis'
      }
      
      return Object.keys(this.errors).length === 0
    },
    
    async handleSubmit() {
      if (!this.validate()) return
      
      this.loading = true
      this.error = ''
      
      try {
        await login(this.email, this.password)
        this.$router.push('/admin')
      } catch (err) {
        if (err.message.includes('Invalid login')) {
          this.error = 'Email ou mot de passe incorrect'
        } else {
          this.error = 'Erreur de connexion. Veuillez réessayer.'
        }
      } finally {
        this.loading = false
      }
    },
    
    async handleRegister() {
      this.registerError = ''
      this.registerSuccess = ''
      
      if (this.registerForm.password !== this.registerForm.confirmPassword) {
        this.registerError = 'Les mots de passe ne correspondent pas'
        return
      }
      
      if (this.registerForm.password.length < 6) {
        this.registerError = 'Le mot de passe doit contenir au moins 6 caractères'
        return
      }
      
      this.registerLoading = true
      
      try {
        await register(
          this.registerForm.email,
          this.registerForm.password,
          this.registerForm.nom
        )
        this.registerSuccess = 'Compte créé ! Vérifiez votre email pour confirmer.'
        this.registerForm = { nom: '', email: '', password: '', confirmPassword: '' }
      } catch (err) {
        if (err.message.includes('already registered')) {
          this.registerError = 'Cet email est déjà utilisé'
        } else {
          this.registerError = 'Erreur lors de la création du compte'
        }
      } finally {
        this.registerLoading = false
      }
    }
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, var(--color-gray-800) 0%, var(--color-gray-900) 100%);
  padding: var(--spacing-4);
}

.login-container {
  width: 100%;
  max-width: 400px;
  background-color: var(--color-white);
  border-radius: var(--border-radius-xl);
  box-shadow: var(--shadow-2xl);
  padding: var(--spacing-8);
}

.login-header {
  text-align: center;
  margin-bottom: var(--spacing-8);
}

.login-icon {
  font-size: 3rem;
  display: block;
  margin-bottom: var(--spacing-4);
}

.login-header h1 {
  font-size: var(--font-size-2xl);
  margin-bottom: var(--spacing-2);
}

.login-header p {
  color: var(--color-text-muted);
  margin: 0;
}

.login-form,
.register-form {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-4);
}

.error-message {
  background-color: var(--color-danger-bg);
  color: var(--color-danger);
  padding: var(--spacing-3) var(--spacing-4);
  border-radius: var(--border-radius-md);
  font-size: var(--font-size-sm);
}

.success-message {
  background-color: var(--color-success-bg);
  color: var(--color-success);
  padding: var(--spacing-3) var(--spacing-4);
  border-radius: var(--border-radius-md);
  font-size: var(--font-size-sm);
}

.login-footer {
  margin-top: var(--spacing-6);
  text-align: center;
}

.login-footer a {
  color: var(--color-primary);
  text-decoration: none;
}

.login-footer a:hover {
  text-decoration: underline;
}
</style>
