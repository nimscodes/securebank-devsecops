import cors from "cors";
import express from "express";
import helmet from "helmet";
import pinoHttp from "pino-http";
import { env } from "./config/env";
import { errorHandler } from "./middleware/error-handler";
import { bankingRouter } from "./modules/banking/banking.routes";
import { healthRouter } from "./routes/health.routes";

export function createApp() {
  const app = express();

  app.disable("x-powered-by");
  app.use(helmet());
  app.use(
    cors({
      origin: env.CORS_ORIGIN,
      credentials: true
    })
  );
  app.use(express.json({ limit: "1mb" }));
  app.use(pinoHttp());

  app.use("/health", healthRouter);
  app.use("/api/v1", bankingRouter);

  app.use((_req, res) => {
    res.status(404).json({
      error: {
        message: "Route not found",
        statusCode: 404
      }
    });
  });

  app.use(errorHandler);

  return app;
}
