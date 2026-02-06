const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

// Import routes
const orderRoutes = require('./routes/orderRoutes');

const app = express();

// ==================== MIDDLEWARE ====================
app.use(cors({
  origin: process.env.CLIENT_URL || 'http://localhost:3000',
  credentials: true
}));

app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// ==================== DATABASE CONNECTION ====================
console.log('⚠️  Database connection is currently COMMENTED OUT');
console.log('📝 To enable: Uncomment mongoose.connect() in server.js');

// ==================== ROUTES ====================

// Welcome route
app.get('/api', (req, res) => {
  res.json({ 
    message: '🚀 Shadi Arts Backend API',
    version: '1.0.0',
    status: 'Running',
    database: 'Disabled (commented out)',
    endpoints: {
      orders: '/api/orders',
      health: '/api/health'
    }
  });
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Order routes
app.use('/api/orders', orderRoutes);

// ==================== 404 HANDLER ====================
app.use((req, res) => {
  res.status(404).json({
    error: 'Route not found',
    path: req.originalUrl
  });
});

// ==================== ERROR HANDLER ====================
app.use((err, req, res, next) => {
  console.error('🔥 Server Error:', err);
  
  res.status(500).json({
    error: 'Internal server error',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
  });
});

// ==================== SERVER START ====================
const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`🎨 ====================================`);
  console.log(`🎨 Shadi Arts Server Started`);
  console.log(`🎨 Port: ${PORT}`);
  console.log(`🎨 API: http://localhost:${PORT}/api`);
  console.log(`🎨 Health: http://localhost:${PORT}/api/health`);
  console.log(`🎨 Orders: http://localhost:${PORT}/api/orders`);
  console.log(`🎨 ====================================`);
});