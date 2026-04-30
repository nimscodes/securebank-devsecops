import nextPlugin from "@next/eslint-plugin-next";
import tsParser from "@typescript-eslint/parser";

export default [
  {
    ignores: [".next/**", "node_modules/**"]
  },
  nextPlugin.flatConfig.coreWebVitals,
  {
    files: ["**/*.{ts,tsx}"],
    languageOptions: {
      parser: tsParser
    }
  }
];
