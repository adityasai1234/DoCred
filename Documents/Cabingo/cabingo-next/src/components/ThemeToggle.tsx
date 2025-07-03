'use client';

import { motion } from 'framer-motion';
import { Sun, Moon } from 'lucide-react';
import { useTheme } from '@/contexts/ThemeContext';

export default function ThemeToggle() {
  const { isDark, toggleTheme } = useTheme();

  return (
    <motion.button
      whileHover={{ scale: 1.05 }}
      whileTap={{ scale: 0.95 }}
      onClick={toggleTheme}
      className="fixed top-6 left-6 z-50 bg-white/10 dark:bg-gray-900/10 backdrop-blur-lg border border-white/20 dark:border-gray-700/20 rounded-full p-3 shadow-lg hover:bg-white/20 dark:hover:bg-gray-900/20 transition-all duration-300"
      aria-label="Toggle theme"
    >
      <motion.div
        initial={false}
        animate={{ rotate: isDark ? 0 : 180 }}
        transition={{ duration: 0.3 }}
      >
        {isDark ? (
          <Sun className="w-5 h-5 text-yellow-400" />
        ) : (
          <Moon className="w-5 h-5 text-blue-600 dark:text-blue-400" />
        )}
      </motion.div>
    </motion.button>
  );
} 