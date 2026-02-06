const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const orderController = require('../controllers/orderController');
const mongoose = require('mongoose');

// ==================== VALIDATION RULES ====================

const orderValidationRules = [
  // Customer Information
  body('customerName')
    .trim()
    .notEmpty().withMessage('Full name is required')
    .isLength({ min: 2, max: 100 }).withMessage('Name must be 2-100 characters'),
  
  body('email')
    .trim()
    .notEmpty().withMessage('Email is required')
    .isEmail().withMessage('Valid email required')
    .normalizeEmail(),
  
  body('phone')
    .optional({ checkFalsy: true })
    .trim()
    .matches(/^[\+]?[0-9\s\-\(\)]{8,}$/)
    .withMessage('Valid phone number required'),
  
  body('country')
    .optional()
    .trim()
    .isLength({ max: 100 }).withMessage('Country name too long'),
  
  // Order Details (REQUIRED FIELDS)
  body('portraitType')
    .notEmpty().withMessage('Portrait type is required')
    .isIn(['single', 'couple', 'family', 'pet', 'celebrity'])
    .withMessage('Valid portrait type required'),
  
  body('paperSize')
    .notEmpty().withMessage('Paper size is required')
    .isIn(['A4', 'A3', 'A2', 'custom'])
    .withMessage('Valid paper size required'),
  
  // Optional fields with validation
  body('subjectCount')
    .optional()
    .isInt({ min: 1, max: 10 }).withMessage('1-10 subjects allowed'),
  
  body('backgroundStyle')
    .optional()
    .isIn(['simple', 'detailed', 'minimal', 'custom'])
    .withMessage('Valid background style required'),
  
  body('includeFrame')
    .optional()
    .isBoolean().withMessage('Include frame must be true/false'),
  
  body('urgencyLevel')
    .optional()
    .isIn(['relaxed', 'normal', 'urgent', 'express'])
    .withMessage('Valid urgency level required'),
  
  // Reference Information
  body('dropboxLink')
    .optional()
    .trim()
    .isURL().withMessage('Valid URL required')
    .matches(/^(https:\/\/drive\.google\.com\/|https:\/\/dropbox\.com\/)/)
    .withMessage('Only Google Drive or Dropbox links accepted'),
  
  body('specialInstructions')
    .optional()
    .trim()
    .isLength({ max: 1000 }).withMessage('Max 1000 characters'),
  
  // Validation middleware - MUST BE LAST IN ARRAY
  (req, res, next) => {
    console.log('🔍 Validating order data...');
    const errors = validationResult(req);
    
    if (!errors.isEmpty()) {
      console.log('❌ Validation failed:', errors.array());
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }
    
    console.log('✅ Validation passed');
    next();
  }
];

// ==================== API ROUTES (CORRECT ORDER) ====================

// 1. HEALTH CHECK - MUST BE FIRST
router.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'Order routes are working',
    timestamp: new Date().toISOString(),
    database: mongoose.connection.readyState === 1 ? 'Connected' : 'Not Connected',
    note: 'Make sure to uncomment mongoose.connect() in server.js to enable database'
  });
});

// 2. CREATE ORDER (with validation middleware)
router.post('/', orderValidationRules, orderController.createOrder);

// 3. GET ALL ORDERS
router.get('/', orderController.getAllOrders);

// 4. GET STATISTICS
router.get('/stats', orderController.getOrderStats);

// 5. GET SINGLE ORDER BY ID
router.get('/:id', orderController.getOrderById);

// 6. UPDATE ORDER STATUS
router.put('/:id/status', orderController.updateOrderStatus);

// 7. DELETE ORDER
router.delete('/:id', orderController.deleteOrder);

// ==================== ERROR HANDLING ====================

// 404 for order routes
router.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Order route not found',
    path: req.originalUrl,
    method: req.method,
    timestamp: new Date().toISOString()
  });
});

// Error handling middleware
router.use((err, req, res, next) => {
  console.error('🔥 Order route error:', err);
  
  if (err.name === 'ValidationError') {
    return res.status(400).json({
      success: false,
      error: 'Validation error',
      details: err.errors
    });
  }
  
  if (err.name === 'CastError') {
    return res.status(400).json({
      success: false,
      error: 'Invalid ID format'
    });
  }
  
  res.status(err.status || 500).json({
    success: false,
    error: 'Internal server error',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong',
    timestamp: new Date().toISOString()
  });
});

module.exports = router;