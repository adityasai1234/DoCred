'use client';

import { motion } from 'framer-motion';
import { Clock, Route, Car, Star } from 'lucide-react';

interface RideCardProps {
  ride: {
    id: number;
    platform: string;
    platformIcon: string;
    platformColor: string;
    price: number;
    eta: number;
    distance: number;
    driver: string;
    rating: number;
    vehicle: string;
    surge: number;
  };
  isBestPrice: boolean;
  onBook: (platform: string, price: number) => void;
}
export default function RideCard({ ride, isBestPrice, onBook }: RideCardProps) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      whileHover={{ y: -2 }}
      className={`bg-white dark:bg-gray-800 rounded-2xl p-6 shadow-lg border-l-4 transition-all ${
        isBestPrice ? 'border-green-500 bg-gradient-to-r from-green-50 to-white dark:from-green-900/20 dark:to-gray-800' : 'border-purple-500 dark:border-purple-400'
      }`}
    >
      <div className="flex justify-between items-start mb-4">
        <div className="flex items-center gap-4">
          <div className={`w-12 h-12 rounded-xl flex items-center justify-center text-2xl ${ride.platformColor}`}>
            {ride.platformIcon}
          </div>
          <div>
            <h3 className="font-bold text-lg text-gray-800 dark:text-gray-100">{ride.platform}</h3>
            <p className="text-gray-600 dark:text-gray-300">{ride.driver} • {ride.vehicle}</p>
          </div>
        </div>
        <div className="text-right">
          <div className="flex items-center gap-2">
            <span className={`text-2xl font-bold ${isBestPrice ? 'text-green-600 dark:text-green-400' : 'text-gray-800 dark:text-gray-100'}`}>
              ${ride.price.toFixed(2)}
            </span>
            {ride.surge > 1 && (
              <span className="bg-red-500 text-white px-2 py-1 rounded text-xs font-bold">
                {ride.surge.toFixed(1)}x
              </span>
            )}
          </div>
          <div className="flex items-center gap-1 text-gray-600 dark:text-gray-400 mt-1">
            <Star className="w-4 h-4 text-yellow-400 fill-current" />
            <span className="text-sm">{ride.rating}</span>
          </div>
        </div>
      </div>
      
      <div className="grid grid-cols-3 gap-4 mb-4">
        <div className="text-center">
          <Clock className="w-5 h-5 text-purple-600 dark:text-purple-400 mx-auto mb-1" />
          <p className="text-xs text-gray-600 dark:text-gray-400">ETA</p>
          <p className="font-semibold text-gray-800 dark:text-gray-100">{ride.eta} min</p>
        </div>
        <div className="text-center">
          <Route className="w-5 h-5 text-purple-600 dark:text-purple-400 mx-auto mb-1" />
          <p className="text-xs text-gray-600 dark:text-gray-400">Distance</p>
          <p className="font-semibold text-gray-800 dark:text-gray-100">{ride.distance} km</p>
        </div>
        <div className="text-center">
          <Car className="w-5 h-5 text-purple-600 dark:text-purple-400 mx-auto mb-1" />
          <p className="text-xs text-gray-600 dark:text-gray-400">Vehicle</p>
          <p className="font-semibold text-gray-800 dark:text-gray-100">{ride.vehicle.split(' ').slice(0, 2).join(' ')}</p>
        </div>
      </div>
      
      <motion.button
        whileHover={{ scale: 1.02 }}
        whileTap={{ scale: 0.98 }}
        onClick={() => onBook(ride.platform, ride.price)}
        className="w-full bg-gradient-to-r from-purple-600 to-blue-600 dark:from-purple-500 dark:to-blue-500 text-white py-3 rounded-xl font-semibold hover:shadow-lg transition-all"
      >
        Book Now
      </motion.button>
    </motion.div>
  );
} 