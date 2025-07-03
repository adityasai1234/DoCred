'use client';

import { motion, AnimatePresence } from 'framer-motion';
import { Sun, Moon, Monitor } from 'lucide-react';
import { useTheme } from '@/contexts/ThemeContext';

export default function ThemeIndicator() {
  const { theme, setTheme } = useTheme();

  const themes = [
    { id: 'light', icon: Sun, label: 'Light', color: 'text-yellow-500' },
    { id: 'dark', icon: Moon, label: 'Dark', color: 'text-blue-500' },
    { id: 'system', icon: Monitor, label: 'System', color: 'text-gray-500' },
  ] as const;

  const handleThemeChange = (newTheme: 'light' | 'dark' | 'system') => {
    if (newTheme === 'system') {
      const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      setTheme(systemPrefersDark ? 'dark' : 'light');
    } else {
      setTheme(newTheme);
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: -20 }}
      animate={{ opacity: 1, y: 0 }}
      className="fixed top-6 right-6 z-50 bg-white/10 dark:bg-gray-900/10 backdrop-blur-lg border border-white/20 dark:border-gray-700/20 rounded-2xl p-2 shadow-lg"
    >
      <div className="flex gap-1">
        {themes.map((themeOption) => {
          const Icon = themeOption.icon;
          const isActive = theme === themeOption.id;
          
          return (
            <motion.button
              key={themeOption.id}
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => handleThemeChange(themeOption.id)}
              className={`p-2 rounded-xl transition-all duration-200 ${
                isActive 
                  ? 'bg-white/20 dark:bg-gray-800/20 shadow-md' 
                  : 'hover:bg-white/10 dark:hover:bg-gray-800/10'
              }`}
              aria-label={`Switch to ${themeOption.label} mode`}
            >
              <Icon className={`w-4 h-4 ${themeOption.color}`} />
            </motion.button>
          );
        })}
      </div>
    </motion.div>
  );
} 