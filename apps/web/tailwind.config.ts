import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        bank: {
          ink: "#17212b",
          green: "#14795b",
          mint: "#d8f3e7",
          gold: "#c79a2b",
          sky: "#d8ebff",
          paper: "#f7f8f5"
        }
      },
      boxShadow: {
        soft: "0 18px 50px rgba(23, 33, 43, 0.08)"
      }
    }
  },
  plugins: []
};

export default config;
