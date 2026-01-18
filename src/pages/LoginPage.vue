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
/* ===== LOGIN PAGE - LIQUID GLASS ===== */
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: var(--spacing-6);
  position: relative;
  z-index: 1;
}

.login-container {
  position: relative;
  width: 100%;
  max-width: 440px;
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(20px) saturate(120%);
  -webkit-backdrop-filter: blur(20px) saturate(120%);
  border-radius: var(--radius-2xl);
  border: 1px solid rgba(0, 0, 0, 0.06);
  box-shadow: var(--shadow-glass-float);
  padding: var(--spacing-10);
  overflow: hidden;
}

/* Reflet supérieur */
.login-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 50%;
  background: linear-gradient(
    180deg,
    rgba(255, 255, 255, 0.5) 0%,
    transparent 100%
  );
  pointer-events: none;
  border-radius: var(--radius-2xl) var(--radius-2xl) 0 0;
}

.login-header {
  position: relative;
  text-align: center;
  margin-bottom: var(--spacing-8);
  z-index: 1;
}

.login-icon {
  font-size: 3.5rem;
  display: block;
  margin-bottom: var(--spacing-4);
  animation: floatIcon 3s ease-in-out infinite;
}

@keyframes floatIcon {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-8px); }
}

.login-header h1 {
  font-size: var(--font-size-2xl);
  font-weight: var(--font-weight-bold);
  margin-bottom: var(--spacing-2);
  color: var(--color-text-primary);
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.login-header p {
  color: var(--color-text-secondary);
  margin: 0;
}

.login-form,
.register-form {
  position: relative;
  display: flex;
  flex-direction: column;
  gap: var(--spacing-5);
  z-index: 1;
}

.error-message {
  background: linear-gradient(
    135deg,
    rgba(239, 68, 68, 0.2) 0%,
    rgba(239, 68, 68, 0.1) 100%
  );
  color: var(--color-danger-light);
  padding: var(--spacing-4);
  border-radius: var(--radius-lg);
  font-size: var(--font-size-sm);
  border: 1px solid rgba(239, 68, 68, 0.3);
  backdrop-filter: blur(10px);
}

.success-message {
  background: linear-gradient(
    135deg,
    rgba(34, 197, 94, 0.2) 0%,
    rgba(34, 197, 94, 0.1) 100%
  );
  color: var(--color-success-light);
  padding: var(--spacing-4);
  border-radius: var(--radius-lg);
  font-size: var(--font-size-sm);
  border: 1px solid rgba(34, 197, 94, 0.3);
  backdrop-filter: blur(10px);
}

.login-footer {
  position: relative;
  margin-top: var(--spacing-6);
  text-align: center;
  z-index: 1;
  color: var(--color-text-secondary);
}

.login-footer a {
  color: var(--color-primary-light);
  text-decoration: none;
  font-weight: var(--font-weight-medium);
  transition: color var(--transition-fast);
}

.login-footer a:hover {
  color: var(--color-white);
}

/* ===== MOBILE ===== */
@media (max-width: 480px) {
  .login-page {
    padding: var(--spacing-4);
    align-items: flex-start;
    padding-top: var(--spacing-10);
  }
  
  .login-container {
    padding: var(--spacing-6);
    border-radius: var(--radius-xl);
  }
  
  .login-header h1 {
    font-size: var(--font-size-xl);
  }
  
  .login-icon {
    font-size: 2.5rem;
  }
  
  .login-form,
  .register-form {
    gap: var(--spacing-4);
  }
}

/* Animation d'entrée fluide */
@keyframes containerSlideIn {
  from {
    opacity: 0;
    transform: scale(0.92) translateY(30px);
  }
  to {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

.login-container {
  animation: containerSlideIn 0.6s var(--transition-spring) forwards;
}

/* Préférence mouvement réduit */
@media (prefers-reduced-motion: reduce) {
  .login-container {
    animation: none;
  }
}
</style>
