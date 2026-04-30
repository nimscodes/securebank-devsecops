# SecureBank

SecureBank is a production-style DevSecOps portfolio monorepo. Phase 1 creates the application foundation only: a Next.js frontend, an Express API, PostgreSQL with Prisma, and local Docker orchestration.

## Repository Structure

```text
apps/
  web/        Next.js frontend with TypeScript and Tailwind
  api/        Node.js Express API with TypeScript and Prisma
infra/
  terraform/ Reserved for later infrastructure phases
docs/         Project documentation
.github/
  workflows/ Reserved for CI/CD workflows
```

## Prerequisites

- Node.js 20.11+
- npm 10.2+
- Docker and Docker Compose

## Local Development

1. Install dependencies:

   ```bash
   npm install
   ```

2. Create environment files:

   ```bash
   cp apps/web/.env.example apps/web/.env
   cp apps/api/.env.example apps/api/.env
   ```

3. Start PostgreSQL and pgAdmin:

   ```bash
   docker compose up -d postgres pgadmin
   ```

4. Generate Prisma client and run migrations:

   ```bash
   npm run prisma:generate -w apps/api
   npm run prisma:migrate -w apps/api
   ```

5. Run the applications:

   ```bash
   npm run dev
   ```

Frontend: http://localhost:3000  
API: http://localhost:4000  
pgAdmin: http://localhost:5050

pgAdmin credentials:

```text
Email: admin@securebank.dev
Password: securebank_admin
```

## Docker Development Stack

Build and run everything locally:

```bash
docker compose up --build
```

The stack includes:

- `web`: Next.js app on port 3000
- `api`: Express API on port 4000
- `postgres`: PostgreSQL on port 5432
- `pgadmin`: pgAdmin on port 5050

## Phase 1 Scope

- Next.js frontend with TypeScript and Tailwind
- Express API with TypeScript
- Prisma PostgreSQL connection
- Auth-ready domain models for users, accounts, and transactions
- Dockerfiles for frontend and API
- Docker Compose for app services and database tooling

AWS deployment, CI/CD hardening, secrets management, and runtime security scanning are intentionally deferred to later phases.
