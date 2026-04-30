import {
  ArrowDownLeft,
  ArrowUpRight,
  Landmark,
  LockKeyhole,
  ShieldCheck,
  WalletCards
} from "lucide-react";
import { getApiHealth } from "@/lib/api";

const accounts = [
  { name: "Primary Checking", balance: "$12,840.50", status: "Active" },
  { name: "Emergency Savings", balance: "$48,220.00", status: "Protected" },
  { name: "Travel Reserve", balance: "$6,940.10", status: "Active" }
];

const transactions = [
  { label: "Payroll deposit", amount: "+$4,250.00", type: "credit" },
  { label: "Mortgage payment", amount: "-$2,180.42", type: "debit" },
  { label: "Card purchase", amount: "-$84.18", type: "debit" }
];

export default async function Home() {
  const health = await getApiHealth();

  return (
    <main className="min-h-screen bg-bank-paper">
      <section className="border-b border-black/10 bg-white">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-md bg-bank-green text-white">
              <Landmark size={22} aria-hidden="true" />
            </div>
            <div>
              <h1 className="text-lg font-semibold tracking-normal">SecureBank</h1>
              <p className="text-sm text-slate-500">DevSecOps banking platform</p>
            </div>
          </div>
          <div className="flex items-center gap-2 rounded-md border border-black/10 bg-bank-mint px-3 py-2 text-sm font-medium text-bank-green">
            <ShieldCheck size={16} aria-hidden="true" />
            {health ? "API online" : "API unavailable"}
          </div>
        </div>
      </section>

      <section className="mx-auto grid max-w-7xl gap-6 px-6 py-8 lg:grid-cols-[1.5fr_1fr]">
        <div className="rounded-md bg-bank-ink p-8 text-white shadow-soft">
          <div className="flex flex-col gap-6 md:flex-row md:items-start md:justify-between">
            <div>
              <p className="text-sm font-medium text-bank-sky">Total balance</p>
              <p className="mt-2 text-4xl font-semibold">$68,000.60</p>
            </div>
            <div className="flex items-center gap-2 rounded-md bg-white/10 px-3 py-2 text-sm">
              <LockKeyhole size={16} aria-hidden="true" />
              Auth-ready foundation
            </div>
          </div>
          <div className="mt-8 grid gap-4 md:grid-cols-3">
            {accounts.map((account) => (
              <article key={account.name} className="rounded-md border border-white/15 bg-white/10 p-4">
                <p className="text-sm text-white/70">{account.name}</p>
                <p className="mt-3 text-xl font-semibold">{account.balance}</p>
                <p className="mt-2 text-sm text-bank-mint">{account.status}</p>
              </article>
            ))}
          </div>
        </div>

        <aside className="rounded-md bg-white p-6 shadow-soft">
          <div className="flex items-center justify-between">
            <h2 className="text-base font-semibold">Service health</h2>
            <WalletCards size={20} className="text-bank-green" aria-hidden="true" />
          </div>
          <dl className="mt-6 space-y-4 text-sm">
            <div className="flex justify-between gap-4">
              <dt className="text-slate-500">API</dt>
              <dd className="font-medium">{health?.status ?? "offline"}</dd>
            </div>
            <div className="flex justify-between gap-4">
              <dt className="text-slate-500">Database</dt>
              <dd className="font-medium">{health?.database ?? "unknown"}</dd>
            </div>
            <div className="flex justify-between gap-4">
              <dt className="text-slate-500">Service</dt>
              <dd className="font-medium">{health?.service ?? "securebank-api"}</dd>
            </div>
          </dl>
        </aside>
      </section>

      <section className="mx-auto max-w-7xl px-6 pb-10">
        <div className="rounded-md bg-white p-6 shadow-soft">
          <h2 className="text-base font-semibold">Recent transactions</h2>
          <div className="mt-5 divide-y divide-black/10">
            {transactions.map((transaction) => {
              const isCredit = transaction.type === "credit";
              const Icon = isCredit ? ArrowDownLeft : ArrowUpRight;

              return (
                <div key={transaction.label} className="flex items-center justify-between gap-4 py-4">
                  <div className="flex items-center gap-3">
                    <div className="flex h-10 w-10 items-center justify-center rounded-md bg-bank-sky text-bank-ink">
                      <Icon size={18} aria-hidden="true" />
                    </div>
                    <p className="font-medium">{transaction.label}</p>
                  </div>
                  <p className={isCredit ? "font-semibold text-bank-green" : "font-semibold text-slate-700"}>
                    {transaction.amount}
                  </p>
                </div>
              );
            })}
          </div>
        </div>
      </section>
    </main>
  );
}
