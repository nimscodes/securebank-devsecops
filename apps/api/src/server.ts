import { createServer } from "node:http";
import { createApp } from "./app";
import { env } from "./config/env";
import { disconnectPrisma } from "./db/prisma";

const app = createApp();
const server = createServer(app);

server.listen(env.PORT, () => {
  console.log(`SecureBank API listening on port ${env.PORT}`);
});

async function shutdown(signal: string) {
  console.log(`${signal} received. Shutting down SecureBank API.`);

  server.close(async () => {
    await disconnectPrisma();
    process.exit(0);
  });
}

process.on("SIGINT", () => void shutdown("SIGINT"));
process.on("SIGTERM", () => void shutdown("SIGTERM"));
