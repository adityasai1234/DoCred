'use client';

import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  Car, 
  MapPin, 
  Search, 
  Clock, 
  Route, 
  Star, 
  DollarSign,
  Zap,
  CheckCircle,
  AlertCircle,
  Info,
  Loader2
} from 'lucide-react';
import RideCard from '@/components/RideCard';
import Notification from '@/components/Notification';
import LoadingSpinner from '@/components/LoadingSpinner';
import PlatformStatus from '@/components/PlatformStatus';
import ThemeToggle from '@/components/ThemeToggle';
import ThemeIndicator from '@/components/ThemeIndicator';

interface Ride {
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
}

export default function Home() {
  const [pickup, setPickup] = useState('Current Location');
  const [destination, setDestination] = useState('');
  const [searchRange, setSearchRange] = useState(100);
  const [isSearching, setIsSearching] = useState(false);
  const [results, setResults] = useState<Ride[]>([]);
  const [sortBy, setSortBy] = useState<'price' | 'time' | 'distance'>('price');
  const [notification, setNotification] = useState<{
    message: string;
    type: 'success' | 'error' | 'info' | 'warning';
  } | null>(null);

  const showNotification = (message: string, type: 'success' | 'error' | 'info' | 'warning') => {
    setNotification({ message, type });
    setTimeout(() => setNotification(null), 3000);
  };

  const generateMockResults = (pickup: string, destination: string, range: number): Ride[] => {
    const platforms = [
      { name: 'Uber', icon: '🚗', color: 'bg-black', basePrice: 15 },
      { name: 'Lyft', icon: '🚙', color: 'bg-pink-500', basePrice: 14 },
      { name: 'Local Taxi', icon: '🚕', color: 'bg-yellow-500', basePrice: 18 },
      { name: 'UberX', icon: '🚗', color: 'bg-black', basePrice: 12 },
      { name: 'Lyft XL', icon: '🚙', color: 'bg-pink-500', basePrice: 16 },
      { name: 'Premium Taxi', icon: '🚕', color: 'bg-yellow-500', basePrice: 22 }
    ];

    const basePrice = Math.floor(Math.random() * 10) + 8;
    const results: Ride[] = [];

    platforms.forEach((platform, index) => {
      const priceVariation = (Math.random() - 0.5) * 6;
      const timeVariation = Math.floor(Math.random() * 10) - 5;
      const distanceVariation = Math.floor(Math.random() * 2) - 1;

      const price = Math.max(5, Math.round((basePrice + priceVariation) * 100) / 100);
      const eta = Math.max(2, 8 + timeVariation);
      const distance = Math.max(0.5, 2.5 + distanceVariation);

      const firstNames = ['John', 'Sarah', 'Mike', 'Emma', 'David', 'Lisa', 'Alex', 'Maria'];
      const lastNames = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller'];
      const firstName = firstNames[Math.floor(Math.random() * firstNames.length)];
      const lastName = lastNames[Math.floor(Math.random() * lastNames.length)];
      const driver = `${firstName} ${lastName.charAt(0)}.`;

      const vehicles = ['Toyota Camry', 'Honda Civic', 'Ford Focus', 'Hyundai Elantra'];
      const colors = ['White', 'Black', 'Silver', 'Blue', 'Red', 'Gray'];
      const vehicle = vehicles[Math.floor(Math.random() * vehicles.length)];
      const color = colors[Math.floor(Math.random() * colors.length)];

      results.push({
        id: index,
        platform: platform.name,
        platformIcon: platform.icon,
        platformColor: platform.color,
        price,
        eta,
        distance,
        driver,
        rating: Number((4 + Math.random()).toFixed(1)),
        vehicle: `${color} ${vehicle}`,
        surge: Math.random() > 0.8 ? Math.random() * 0.5 + 1 : 1
      });
    });

    return results.sort((a, b) => a.price - b.price);
  };

  const performSearch = async () => {
    if (!destination.trim()) {
      showNotification('Please enter a destination', 'error');
      return;
    }

    setIsSearching(true);
    setResults([]);

    // Simulate API call delay
    await new Promise(resolve => setTimeout(resolve, 2000 + Math.random() * 2000));

    const mockResults = generateMockResults(pickup, destination, searchRange);
    setResults(mockResults);
    setIsSearching(false);
    showNotification(`Found ${mockResults.length} rides in ${searchRange}m range`, 'success');
  };

  const handleSort = (sortType: 'price' | 'time' | 'distance') => {
    setSortBy(sortType);
    const sortedResults = [...results].sort((a, b) => {
      switch (sortType) {
        case 'price':
          return a.price - b.price;
        case 'time':
          return a.eta - b.eta;
        case 'distance':
          return a.distance - b.distance;
        default:
          return 0;
      }
    });
    setResults(sortedResults);
  };

  const bookRide = (platform: string, price: number) => {
    showNotification(`Booking ${platform} ride for $${price.toFixed(2)}...`, 'info');
    setTimeout(() => {
      showNotification(`Successfully booked ${platform} ride!`, 'success');
    }, 1500);
  };



  const lowestPrice = results.length > 0 ? Math.min(...results.map(r => r.price)) : 0;

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-600 via-blue-600 to-purple-800 dark:from-gray-900 dark:via-purple-900 dark:to-gray-800">
      <div className="max-w-7xl mx-auto px-4 py-8">
        <ThemeToggle />
        <ThemeIndicator />
        {/* Header */}
        <motion.header 
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-center mb-10"
        >
          <div className="bg-white/95 dark:bg-gray-900/95 backdrop-blur-lg rounded-3xl p-8 shadow-2xl dark:shadow-gray-900/50">
            <div className="flex items-center justify-center gap-4 mb-3">
              <Car className="w-12 h-12 text-purple-600 dark:text-purple-400" />
              <h1 className="text-5xl font-bold bg-gradient-to-r from-purple-600 to-blue-600 dark:from-purple-400 dark:to-blue-400 bg-clip-text text-transparent">
                Cabingo
              </h1>
            </div>
            <p className="text-lg text-gray-600 dark:text-gray-300">Find the cheapest cab prices in your area</p>
          </div>
        </motion.header>

        {/* Main Content */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Search Section */}
          <motion.section 
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            className="lg:col-span-2"
          >
            <div className="bg-white/95 dark:bg-gray-900/95 backdrop-blur-lg rounded-3xl p-8 shadow-2xl dark:shadow-gray-900/50">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 dark:text-gray-200 mb-2">
                    Pickup Location
                  </label>
                  <div className="relative">
                    <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 text-purple-600 dark:text-purple-400 w-5 h-5" />
                    <input
                      type="text"
                      value={pickup}
                      onChange={(e) => setPickup(e.target.value)}
                      className="w-full pl-12 pr-4 py-4 border-2 border-gray-200 dark:border-gray-600 rounded-xl focus:border-purple-600 dark:focus:border-purple-400 focus:ring-4 focus:ring-purple-100 dark:focus:ring-purple-900/20 transition-all bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 placeholder-gray-500 dark:placeholder-gray-400"
                      placeholder="Enter pickup address"
                    />
                  </div>
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 dark:text-gray-200 mb-2">
                    Destination
                  </label>
                  <div className="relative">
                    <MapPin className="absolute left-4 top-1/2 transform -translate-y-1/2 text-purple-600 dark:text-purple-400 w-5 h-5" />
                    <input
                      type="text"
                      value={destination}
                      onChange={(e) => setDestination(e.target.value)}
                      onKeyPress={(e) => e.key === 'Enter' && performSearch()}
                      className="w-full pl-12 pr-4 py-4 border-2 border-gray-200 dark:border-gray-600 rounded-xl focus:border-purple-600 dark:focus:border-purple-400 focus:ring-4 focus:ring-purple-100 dark:focus:ring-purple-900/20 transition-all bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 placeholder-gray-500 dark:placeholder-gray-400"
                      placeholder="Enter destination address"
                    />
                  </div>
                </div>
              </div>
              
              <div className="flex flex-col md:flex-row items-center gap-6">
                <div className="flex-1 min-w-0">
                  <label className="block text-sm font-semibold text-gray-700 dark:text-gray-200 mb-2">
                    Search Range: {searchRange}m
                  </label>
                  <input
                    type="range"
                    min="50"
                    max="100"
                    value={searchRange}
                    onChange={(e) => setSearchRange(Number(e.target.value))}
                    className="w-full h-2 bg-gray-200 dark:bg-gray-600 rounded-lg appearance-none cursor-pointer slider"
                  />
                </div>
                <motion.button
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  onClick={performSearch}
                  disabled={isSearching}
                  className="bg-gradient-to-r from-purple-600 to-blue-600 dark:from-purple-500 dark:to-blue-500 text-white px-8 py-4 rounded-xl font-semibold flex items-center gap-3 shadow-lg hover:shadow-xl transition-all disabled:opacity-50"
                >
                  {isSearching ? (
                    <Loader2 className="w-5 h-5 animate-spin" />
                  ) : (
                    <Search className="w-5 h-5" />
                  )}
                  {isSearching ? 'Searching...' : 'Find Cheapest Prices'}
                </motion.button>
              </div>
            </div>
          </motion.section>

          {/* Results Section */}
          {results.length > 0 && (
            <motion.section
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="space-y-6"
            >
              <div className="bg-white/95 dark:bg-gray-900/95 backdrop-blur-lg rounded-3xl shadow-2xl dark:shadow-gray-900/50 overflow-hidden">
                <div className="p-6 border-b border-gray-100 dark:border-gray-700">
                  <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <h2 className="text-2xl font-bold text-gray-800 dark:text-gray-100">Available Rides</h2>
                    <div className="flex gap-2">
                      {(['price', 'time', 'distance'] as const).map((sort) => (
                        <button
                          key={sort}
                          onClick={() => handleSort(sort)}
                          className={`px-4 py-2 rounded-lg font-medium transition-all flex items-center gap-2 ${
                            sortBy === sort
                              ? 'bg-purple-600 dark:bg-purple-500 text-white'
                              : 'bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-200 hover:bg-gray-200 dark:hover:bg-gray-600'
                          }`}
                        >
                          {sort === 'price' && <DollarSign className="w-4 h-4" />}
                          {sort === 'time' && <Clock className="w-4 h-4" />}
                          {sort === 'distance' && <Route className="w-4 h-4" />}
                          {sort.charAt(0).toUpperCase() + sort.slice(1)}
                        </button>
                      ))}
                    </div>
                  </div>
                </div>
                
                <div className="p-6 max-h-96 overflow-y-auto">
                  <div className="space-y-4">
                    {results.map((ride) => {
                      const isBestPrice = ride.price === lowestPrice;
                      return (
                        <RideCard
                          key={ride.id}
                          ride={ride}
                          isBestPrice={isBestPrice}
                          onBook={bookRide}
                        />
                      );
                    })}
                  </div>
                </div>
              </div>
            </motion.section>
          )}

          {/* Loading Section */}
          <AnimatePresence>
            {isSearching && (
              <motion.section
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                exit={{ opacity: 0, scale: 0.9 }}
                className="lg:col-span-2"
              >
                <LoadingSpinner />
              </motion.section>
            )}
          </AnimatePresence>

          {/* Map Section */}
          <motion.section
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            className="space-y-6"
          >
            <div className="bg-white/95 dark:bg-gray-900/95 backdrop-blur-lg rounded-3xl h-96 shadow-2xl dark:shadow-gray-900/50 flex items-center justify-center">
              <div className="text-center text-gray-600 dark:text-gray-300">
                <div className="w-16 h-16 bg-purple-100 dark:bg-purple-900/30 rounded-full flex items-center justify-center mx-auto mb-4">
                  <MapPin className="w-8 h-8 text-purple-600 dark:text-purple-400" />
                </div>
                <h3 className="text-xl font-semibold mb-2">Interactive Map</h3>
                <p className="text-sm">Showing pickup, destination, and available drivers</p>
              </div>
            </div>
          </motion.section>
        </div>

        {/* Platform Status */}
        <PlatformStatus />

        {/* Notification */}
        <AnimatePresence>
          {notification && (
            <Notification
              message={notification.message}
              type={notification.type}
              onClose={() => setNotification(null)}
            />
          )}
        </AnimatePresence>
      </div>

      <style jsx>{`
        .slider::-webkit-slider-thumb {
          appearance: none;
          width: 20px;
          height: 20px;
          border-radius: 50%;
          background: #9333ea;
          cursor: pointer;
          box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        }
        
        .slider::-moz-range-thumb {
          width: 20px;
          height: 20px;
          border-radius: 50%;
          background: #9333ea;
          cursor: pointer;
          border: none;
          box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        }
        
        .dark .slider::-webkit-slider-thumb {
          background: #a855f7;
          box-shadow: 0 2px 6px rgba(168, 85, 247, 0.3);
        }
        
        .dark .slider::-moz-range-thumb {
          background: #a855f7;
          box-shadow: 0 2px 6px rgba(168, 85, 247, 0.3);
        }
      `}</style>
    </div>
  );
}
