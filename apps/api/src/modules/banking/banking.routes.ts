import { Router } from "express";
import { listAccounts, listTransactions, listUsers } from "./banking.service";

export const bankingRouter = Router();

bankingRouter.get("/users", async (_req, res, next) => {
  try {
    res.json({ data: await listUsers() });
  } catch (error) {
    next(error);
  }
});

bankingRouter.get("/accounts", async (_req, res, next) => {
  try {
    res.json({ data: await listAccounts() });
  } catch (error) {
    next(error);
  }
});

bankingRouter.get("/transactions", async (_req, res, next) => {
  try {
    res.json({ data: await listTransactions() });
  } catch (error) {
    next(error);
  }
});
