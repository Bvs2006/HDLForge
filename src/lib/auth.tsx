"use client";

import { createContext, useCallback, useContext, useEffect, useState, ReactNode } from "react";
import { User } from "./types";

interface AuthContextType {
  user: User | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  register: (email: string, username: string, password: string, displayName?: string) => Promise<void>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000";

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  const fetchUser = useCallback(async () => {
    try {
      const res = await fetch(`${API_BASE}/api/auth/me`, {
        credentials: "include",
      });
      if (res.ok) {
        const data = await res.json();
        setUser({
          id: data.id,
          email: data.email,
          username: data.username,
          displayName: data.display_name,
          avatarUrl: data.avatar_url,
          createdAt: data.created_at,
          lastLoginAt: data.last_login_at,
          xp: data.xp ?? 0,
          level: data.level ?? 1,
          solvedCount: data.solved_count ?? 0,
        });
      }
    } catch {
      // Not authenticated
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    void fetchUser();
  }, [fetchUser]);

  const login = useCallback(async (email: string, password: string) => {
    const res = await fetch(`${API_BASE}/api/auth/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      credentials: "include",
      body: JSON.stringify({ email, password }),
    });

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data.detail || "Login failed");
    }

    const data = await res.json();
    setUser({
      id: data.user.id,
      email: data.user.email,
      username: data.user.username,
      displayName: data.user.display_name,
      avatarUrl: data.user.avatar_url,
      createdAt: data.user.created_at,
      lastLoginAt: data.user.last_login_at,
      xp: data.user.xp ?? 0,
      level: data.user.level ?? 1,
      solvedCount: data.user.solved_count ?? 0,
    });
  }, []);

  const register = useCallback(async (email: string, username: string, password: string, displayName?: string) => {
    const res = await fetch(`${API_BASE}/api/auth/register`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      credentials: "include",
      body: JSON.stringify({ email, username, password, display_name: displayName }),
    });

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data.detail || "Registration failed");
    }

    const data = await res.json();
    setUser({
      id: data.user.id,
      email: data.user.email,
      username: data.user.username,
      displayName: data.user.display_name,
      avatarUrl: data.user.avatar_url,
      createdAt: data.user.created_at,
      lastLoginAt: data.user.last_login_at,
      xp: data.user.xp ?? 0,
      level: data.user.level ?? 1,
      solvedCount: data.user.solved_count ?? 0,
    });
  }, []);

  const logout = useCallback(async () => {
    await fetch(`${API_BASE}/api/auth/logout`, {
      method: "POST",
      credentials: "include",
    });
    setUser(null);
  }, []);

  return (
    <AuthContext.Provider value={{ user, loading, login, register, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
}
