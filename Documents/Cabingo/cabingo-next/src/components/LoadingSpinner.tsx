'use client';

import { motion } from 'framer-motion';

export default function LoadingSpinner() {
  return (
    <div className="bg-white/95 dark:bg-gray-900/95 backdrop-blur-lg rounded-3xl p-12 text-center shadow-2xl dark:shadow-gray-900/50">
      <div className="w-16 h-16 border-4 border-purple-200 dark:border-purple-800 border-t-purple-600 dark:border-t-purple-400 rounded-full animate-spin mx-auto mb-6"></div>
      <h3 className="text-2xl font-bold text-gray-800 dark:text-gray-100 mb-3">Scanning for the best prices...</h3>
      <p className="text-gray-600 dark:text-gray-300 mb-8">Searching across Uber, Lyft, and other platforms</p>
      <div className="relative h-1 bg-gray-200 dark:bg-gray-600 rounded-full overflow-hidden">
        <motion.div
          className="absolute top-0 left-0 h-full bg-gradient-to-r from-transparent via-purple-600 dark:via-purple-400 to-transparent w-full"
          animate={{ x: ['-100%', '100%'] }}
          transition={{ duration: 2, repeat: Infinity, ease: 'easeInOut' }}
        />
      </div>
    </div>
  );
} 