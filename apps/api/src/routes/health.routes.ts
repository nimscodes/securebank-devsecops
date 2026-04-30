import { Router } from "express";
import { prisma } from "../db/prisma";

export const healthRouter = Router();

healthRouter.get("/", async (_req, res) => {
  let database = "connected";

  try {
    await prisma.$queryRaw`SELECT 1`;
  } catch {
    database = "unavailable";
  }

  res.status(database === "connected" ? 200 : 503).json({
    status: database === "connected" ? "ok" : "degraded",
    service: "securebank-api",
    timestamp: new Date().toISOString(),
    database
  });
});
