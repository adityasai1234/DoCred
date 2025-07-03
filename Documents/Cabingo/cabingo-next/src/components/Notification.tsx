'use client';

import { motion } from 'framer-motion';
import { CheckCircle, AlertCircle, Info } from 'lucide-react';

interface NotificationProps {
  message: string;
  type: 'success' | 'error' | 'info' | 'warning';
  onClose: () => void;
}

export default function Notification({ message, type, onClose }: NotificationProps) {
  const getIcon = () => {
    switch (type) {
      case 'success':
        return <CheckCircle className="w-5 h-5" />;
      case 'error':
      case 'warning':
        return <AlertCircle className="w-5 h-5" />;
      default:
        return <Info className="w-5 h-5" />;
    }
  };

  const getColor = () => {
    switch (type) {
      case 'success':
        return 'bg-green-500';
      case 'error':
        return 'bg-red-500';
      case 'warning':
        return 'bg-yellow-500';
      default:
        return 'bg-blue-500';
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, x: 400 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: 400 }}
      className={`fixed top-6 right-6 ${getColor()} text-white px-6 py-4 rounded-xl shadow-2xl z-50 flex items-center gap-3 min-w-80`}
    >
      {getIcon()}
      <span className="font-medium flex-1">{message}</span>
      <button
        onClick={onClose}
        className="text-white/80 hover:text-white transition-colors"
      >
        ×
      </button>
    </motion.div>
  );
} 