# First Connection Guide

## Initial Setup

### 1. Environment Configuration

First, configure the required environment variables as described in `.env.example`:

- `CREATE_ORG_NAME`: Name of the initial organization
- `CREATE_ORG_ADMIN_EMAIL`: Email address for initial admin user

### 2. Authentication Setup

Two authentication methods are available for first login:

#### Option A: Social Sign-In (Recommended)

1. Configure Firebase authentication providers in your project (works out of the box with the emulator)
2. Use the configured email (`CREATE_ORG_ADMIN_EMAIL`) to sign in

#### Option B: Email/Password

1. Click "Is it your first connection? Sign up" link on the sign in page

2. Create your account with:

   - Email: Value of `CREATE_ORG_ADMIN_EMAIL`
   - Choose a secure password

3. Verify your email:
   - In development: Check Firebase emulator logs for verification link (or set up the password directly in the auth emulator interface, http://localhost:4000 by default)
   - In production: Check your email for verification link

> 💡 **Note**: These environment variables are only used during first startup. They can be removed after initial setup is complete.
