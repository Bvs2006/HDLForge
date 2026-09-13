"use client";

import Link from "next/link";
import { useState } from "react";
import { useAuth } from "@/lib/auth";
import {
  Code2,
  Trophy,
  Award,
  BookOpen,
  LayoutDashboard,
  LogIn,
  UserPlus,
  LogOut,
  Menu,
  X,
  ChevronRight,
} from "lucide-react";

const navLinks = [
  { href: "/problems", label: "Problems", icon: Code2 },
  { href: "/leaderboard", label: "Leaderboard", icon: Trophy },
  { href: "/achievements", label: "Achievements", icon: Award },
  { href: "/learn", label: "Learn", icon: BookOpen },
];

export default function Navbar() {
  const [mobileOpen, setMobileOpen] = useState(false);
  const { user, loading, logout } = useAuth();

  return (
    <header className="sticky top-0 z-50 h-12 border-b border-border bg-panel/80 backdrop-blur-xl">
      <nav className="mx-auto flex h-full max-w-[1600px] items-center justify-between px-4">
        <div className="flex items-center gap-6">
          <Link href="/" className="flex items-center gap-2 group">
            <div className="flex h-7 w-7 items-center justify-center rounded-lg bg-accent/10 text-accent transition-all group-hover:bg-accent/20 group-hover:shadow-[0_0_12px_rgba(0,217,165,0.2)]">
              <Code2 className="h-4 w-4" />
            </div>
            <span className="text-sm font-bold tracking-tight text-text-primary">
              HDL<span className="text-accent">Forge</span>
            </span>
          </Link>

          <div className="hidden items-center gap-0.5 md:flex">
            {navLinks.map((link) => {
              const Icon = link.icon;
              return (
                <Link
                  key={link.href}
                  href={link.href}
                  className="flex items-center gap-1.5 rounded-lg px-3 py-1.5 text-xs font-medium text-text-secondary transition-all hover:bg-accent/5 hover:text-text-primary"
                >
                  <Icon className="h-3.5 w-3.5" />
                  {link.label}
                </Link>
              );
            })}
          </div>
        </div>

        <div className="hidden items-center gap-2 md:flex">
          {loading ? (
            <div className="h-7 w-7 animate-pulse rounded-lg bg-border" />
          ) : user ? (
            <div className="flex items-center gap-2">
              <Link
                href="/dashboard"
                className="flex items-center gap-1.5 rounded-lg px-3 py-1.5 text-xs font-medium text-text-secondary transition-all hover:bg-accent/5 hover:text-text-primary"
              >
                <LayoutDashboard className="h-3.5 w-3.5" />
                Dashboard
              </Link>
              <div className="h-4 w-px bg-border" />
              <Link
                href="/dashboard"
                className="flex items-center gap-2 rounded-lg py-1.5 pl-1.5 pr-3 transition-all hover:bg-accent/5"
              >
                <div className="flex h-7 w-7 items-center justify-center rounded-lg bg-accent/10 text-xs font-bold text-accent">
                  {user.displayName?.[0] || user.username[0].toUpperCase()}
                </div>
                <span className="text-xs font-medium text-text-secondary">
                  {user.displayName || user.username}
                </span>
              </Link>
              <button
                onClick={() => logout()}
                className="flex items-center gap-1.5 rounded-lg px-2.5 py-1.5 text-xs font-medium text-text-muted transition-all hover:bg-error/10 hover:text-error"
                title="Logout"
              >
                <LogOut className="h-3.5 w-3.5" />
              </button>
            </div>
          ) : (
            <div className="flex items-center gap-1.5">
              <Link
                href="/login"
                className="flex items-center gap-1.5 rounded-lg px-3 py-1.5 text-xs font-medium text-text-secondary transition-all hover:bg-accent/5 hover:text-text-primary"
              >
                <LogIn className="h-3.5 w-3.5" />
                Login
              </Link>
              <Link
                href="/signup"
                className="flex items-center gap-1.5 rounded-lg bg-accent px-3.5 py-1.5 text-xs font-semibold text-[#070707] transition-all hover:bg-accent-hover hover:shadow-[0_0_16px_rgba(0,217,165,0.3)]"
              >
                <UserPlus className="h-3.5 w-3.5" />
                Sign Up
              </Link>
            </div>
          )}
        </div>

        <button
          onClick={() => setMobileOpen(!mobileOpen)}
          className="flex items-center justify-center rounded-lg p-1.5 text-text-muted transition-all hover:bg-accent/5 hover:text-text-primary md:hidden"
          aria-label="Toggle navigation"
        >
          {mobileOpen ? <X className="h-4 w-4" /> : <Menu className="h-4 w-4" />}
        </button>
      </nav>

      {mobileOpen && (
        <div className="border-t border-border bg-panel md:hidden">
          <div className="flex flex-col gap-0.5 px-3 py-2">
            {navLinks.map((link) => {
              const Icon = link.icon;
              return (
                <Link
                  key={link.href}
                  href={link.href}
                  onClick={() => setMobileOpen(false)}
                  className="flex items-center justify-between rounded-lg px-3 py-2.5 text-sm font-medium text-text-secondary transition-all hover:bg-accent/5 hover:text-text-primary"
                >
                  <span className="flex items-center gap-2">
                    <Icon className="h-4 w-4" />
                    {link.label}
                  </span>
                  <ChevronRight className="h-3.5 w-3.5 text-text-dim" />
                </Link>
              );
            })}
            {user ? (
              <>
                <div className="my-1 h-px bg-border" />
                <Link
                  href="/dashboard"
                  onClick={() => setMobileOpen(false)}
                  className="flex items-center gap-2 rounded-lg px-3 py-2.5 text-sm font-medium text-text-secondary transition-all hover:bg-accent/5 hover:text-text-primary"
                >
                  <LayoutDashboard className="h-4 w-4" />
                  Dashboard
                </Link>
                <button
                  onClick={() => {
                    logout();
                    setMobileOpen(false);
                  }}
                  className="flex items-center gap-2 rounded-lg px-3 py-2.5 text-sm font-medium text-error/70 transition-all hover:bg-error/10 hover:text-error"
                >
                  <LogOut className="h-4 w-4" />
                  Logout
                </button>
              </>
            ) : (
              <>
                <div className="my-1 h-px bg-border" />
                <Link
                  href="/login"
                  onClick={() => setMobileOpen(false)}
                  className="flex items-center gap-2 rounded-lg px-3 py-2.5 text-sm font-medium text-text-secondary transition-all hover:bg-accent/5 hover:text-text-primary"
                >
                  <LogIn className="h-4 w-4" />
                  Login
                </Link>
                <Link
                  href="/signup"
                  onClick={() => setMobileOpen(false)}
                  className="flex items-center gap-2 rounded-lg bg-accent px-3 py-2.5 text-center text-sm font-semibold text-[#070707] transition-all hover:bg-accent-hover"
                >
                  <UserPlus className="h-4 w-4" />
                  Sign Up
                </Link>
              </>
            )}
          </div>
        </div>
      )}
    </header>
  );
}
