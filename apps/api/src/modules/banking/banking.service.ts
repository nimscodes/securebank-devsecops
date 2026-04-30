import { prisma } from "../../db/prisma";

export async function listUsers() {
  return prisma.user.findMany({
    select: {
      id: true,
      email: true,
      firstName: true,
      lastName: true,
      isActive: true,
      createdAt: true
    },
    orderBy: {
      createdAt: "desc"
    }
  });
}

export async function listAccounts() {
  return prisma.account.findMany({
    select: {
      id: true,
      name: true,
      accountNumber: true,
      type: true,
      status: true,
      balance: true,
      currency: true,
      userId: true
    },
    orderBy: {
      createdAt: "desc"
    }
  });
}

export async function listTransactions() {
  return prisma.transaction.findMany({
    select: {
      id: true,
      type: true,
      status: true,
      amount: true,
      currency: true,
      description: true,
      reference: true,
      createdAt: true,
      postedAt: true
    },
    orderBy: {
      createdAt: "desc"
    },
    take: 25
  });
}
