export type ApiHealth = {
  status: string;
  service: string;
  timestamp: string;
  database: string;
};

const apiUrl =
  process.env.API_INTERNAL_URL ?? process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:4000";

export async function getApiHealth(): Promise<ApiHealth | null> {
  try {
    const response = await fetch(`${apiUrl}/health`, {
      cache: "no-store",
      headers: {
        Accept: "application/json"
      }
    });

    if (!response.ok) {
      return null;
    }

    return (await response.json()) as ApiHealth;
  } catch {
    return null;
  }
}
