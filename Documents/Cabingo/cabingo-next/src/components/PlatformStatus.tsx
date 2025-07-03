'use client';

import { motion } from 'framer-motion';

const platforms = [
  { name: 'Uber', icon: '🚗', online: true },
  { name: 'Lyft', icon: '🚙', online: true },
  { name: 'Local Taxis', icon: '🚕', online: true }
];

export default function PlatformStatus() {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      className="fixed bottom-6 right-6 bg-white/95 dark:bg-gray-900/95 backdrop-blur-lg rounded-2xl p-4 shadow-2xl dark:shadow-gray-900/50"
    >
      <div className="flex gap-4">
        {platforms.map((platform, index) => (
          <div key={index} className="flex items-center gap-2">
            <span className="text-lg">{platform.icon}</span>
            <span className="text-sm font-medium text-gray-700 dark:text-gray-200">{platform.name}</span>
            <div className={`w-2 h-2 rounded-full ${platform.online ? 'bg-green-500' : 'bg-red-500'} animate-pulse`}></div>
          </div>
        ))}
      </div>
    </motion.div>
  );
} 