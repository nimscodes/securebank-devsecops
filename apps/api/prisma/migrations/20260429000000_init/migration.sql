CREATE TYPE "AccountType" AS ENUM ('CHECKING', 'SAVINGS', 'CREDIT', 'INVESTMENT');

CREATE TYPE "AccountStatus" AS ENUM ('ACTIVE', 'FROZEN', 'CLOSED');

CREATE TYPE "TransactionType" AS ENUM ('DEBIT', 'CREDIT', 'TRANSFER');

CREATE TYPE "TransactionStatus" AS ENUM ('PENDING', 'POSTED', 'FAILED', 'REVERSED');

CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "accounts" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "accountNumber" TEXT NOT NULL,
    "type" "AccountType" NOT NULL,
    "status" "AccountStatus" NOT NULL DEFAULT 'ACTIVE',
    "balance" DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "accounts_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "transactions" (
    "id" TEXT NOT NULL,
    "fromAccountId" TEXT,
    "toAccountId" TEXT,
    "type" "TransactionType" NOT NULL,
    "status" "TransactionStatus" NOT NULL DEFAULT 'PENDING',
    "amount" DECIMAL(14,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "description" TEXT,
    "reference" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "postedAt" TIMESTAMP(3),

    CONSTRAINT "transactions_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "users_email_key" ON "users"("email");
CREATE INDEX "users_email_idx" ON "users"("email");

CREATE UNIQUE INDEX "accounts_accountNumber_key" ON "accounts"("accountNumber");
CREATE INDEX "accounts_userId_idx" ON "accounts"("userId");
CREATE INDEX "accounts_accountNumber_idx" ON "accounts"("accountNumber");

CREATE UNIQUE INDEX "transactions_reference_key" ON "transactions"("reference");
CREATE INDEX "transactions_fromAccountId_idx" ON "transactions"("fromAccountId");
CREATE INDEX "transactions_toAccountId_idx" ON "transactions"("toAccountId");
CREATE INDEX "transactions_reference_idx" ON "transactions"("reference");
CREATE INDEX "transactions_createdAt_idx" ON "transactions"("createdAt");

ALTER TABLE "accounts" ADD CONSTRAINT "accounts_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "transactions" ADD CONSTRAINT "transactions_fromAccountId_fkey" FOREIGN KEY ("fromAccountId") REFERENCES "accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "transactions" ADD CONSTRAINT "transactions_toAccountId_fkey" FOREIGN KEY ("toAccountId") REFERENCES "accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
