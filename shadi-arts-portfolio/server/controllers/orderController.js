const Order = require('../models/Order');
const { uploadOrderPhotos, deleteImage } = require('../middleware/uploadMiddleware');
const { validationResult } = require('express-validator');

// ==================== HELPER FUNCTIONS ====================

const calculatePrice = (orderData) => {
  const portraitTypes = {
    single: 1500, couple: 2500, family: 3500, pet: 1200, celebrity: 2000
  };
  const paperSizes = {
    A4: 1, A3: 1.5, A2: 2, custom: 2.5
  };
  const urgencyLevels = {
    relaxed: 1, normal: 1.2, urgent: 1.5, express: 2
  };

  const basePrice = portraitTypes[orderData.portraitType] || 1500;
  const sizeMultiplier = paperSizes[orderData.paperSize] || 1;
  const urgencyMultiplier = urgencyLevels[orderData.urgencyLevel] || 1;

  let price = basePrice * sizeMultiplier * urgencyMultiplier;
  if (orderData.includeFrame) price += 500;
  if (orderData.subjectCount > 1) price *= 0.9;

  return Math.round(price);
};

const formatOrderResponse = (order) => {
  if (!order) return null;
  
  return {
    id: order._id,
    customer: {
      name: order.customerName,
      email: order.email,
      phone: order.phone,
      country: order.country
    },
    orderDetails: {
      portraitType: order.portraitType,
      subjectCount: order.subjectCount,
      paperSize: order.paperSize,
      backgroundStyle: order.backgroundStyle,
      includeFrame: order.includeFrame,
      urgencyLevel: order.urgencyLevel
    },
    photos: order.referencePhotos ? order.referencePhotos.map(photo => ({
      url: photo.url, filename: photo.filename, size: photo.size
    })) : [],
    specialInstructions: order.specialInstructions,
    dropboxLink: order.dropboxLink,
    pricing: { estimated: order.estimatedPrice, final: order.finalPrice },
    status: { order: order.status, payment: order.paymentStatus },
    dates: { created: order.createdAt, updated: order.updatedAt, completed: order.completedAt },
    whatsappMessage: order.whatsappMessage
  };
};

const generateWhatsAppMessage = (order) => {
  const portraitTypes = {
    single: 'Single Portrait', couple: 'Couple Portrait', family: 'Family Portrait',
    pet: 'Pet Portrait', celebrity: 'Celebrity Portrait'
  };
  const paperSizes = {
    A4: 'A4 (21x29.7 cm)', A3: 'A3 (29.7x42 cm)', A2: 'A2 (42x59.4 cm)', custom: 'Custom Size'
  };
  const urgencyLevels = {
    relaxed: 'Relaxed (4-6 weeks)', normal: 'Normal (2-3 weeks)',
    urgent: 'Urgent (1 week)', express: 'Express (3-4 days)'
  };

  let message = `🎨 *New Portrait Order - Shadi Arts* 🎨%0A%0A` +
    `*Customer Information:*%0A` +
    `👤 Name: ${order.customerName || 'Not provided'}%0A` +
    `📧 Email: ${order.email || 'Not provided'}%0A` +
    `📞 Phone: ${order.phone || 'Not provided'}%0A` +
    `📍 Country: ${order.country || 'Egypt'}%0A%0A` +
    `*Order Details:*%0A` +
    `🖼️ Type: ${portraitTypes[order.portraitType] || 'Not selected'}%0A` +
    `📏 Size: ${paperSizes[order.paperSize] || 'Not selected'}%0A` +
    `👥 Subjects: ${order.subjectCount || 1} person(s)%0A` +
    `⏱️ Timeline: ${urgencyLevels[order.urgencyLevel] || 'Not selected'}%0A` +
    `🖼️ Framing: ${order.includeFrame ? 'Yes (+EGP 500)' : 'No'}%0A` +
    `💰 Estimated Total: *EGP ${order.estimatedPrice || 0}*%0A%0A` +
    `*Special Instructions:*%0A${order.specialInstructions || 'None provided'}%0A%0A`;

  if (order.referencePhotos && order.referencePhotos.length > 0) {
    message += `📸 *Photos Uploaded:* ${order.referencePhotos.length} photo(s) via website%0A`;
  }
  if (order.dropboxLink) {
    message += `☁️ *Cloud Link:* ${order.dropboxLink}%0A%0A`;
  }

  message += `📸 *NEXT STEPS:*%0A` +
    `1️⃣ ${order.referencePhotos && order.referencePhotos.length > 0
      ? 'Photos uploaded via website - ready to start!'
      : 'Please send REFERENCE PHOTO(S) for the portrait'
    }%0A` +
    `2️⃣ Higher quality photos = Better results%0A` +
    `3️⃣ I'll send a sketch preview before final work%0A%0A` +
    `_Order submitted via Shadi Arts Portfolio Website_`;

  return message;
};

// ==================== CONTROLLER FUNCTIONS ====================

const createOrder = async (req, res) => {
  try {
    // Database is disabled - simulate order creation
    console.log('📝 Order creation simulated (database disabled)');
    
    const orderData = {
      ...req.body,
      _id: 'simulated_' + Date.now(),
      referencePhotos: [],
      subjectCount: parseInt(req.body.subjectCount) || 1,
      includeFrame: req.body.includeFrame === 'true' || req.body.includeFrame === true,
      estimatedPrice: calculatePrice(req.body),
      createdAt: new Date(),
      updatedAt: new Date(),
      status: 'pending',
      paymentStatus: 'pending',
      whatsappMessage: ''
    };

    orderData.whatsappMessage = generateWhatsAppMessage(orderData);

    console.log(`✅ Order simulated: ${orderData.customerName}`);

    res.status(201).json({
      success: true,
      message: 'Order created successfully (database disabled)',
      order: formatOrderResponse(orderData),
      whatsapp: {
        message: orderData.whatsappMessage,
        url: `https://wa.me/201151638804?text=${encodeURIComponent(orderData.whatsappMessage)}`
      },
      note: 'Database connection is disabled. To save orders, uncomment mongoose.connect() in server.js'
    });

  } catch (error) {
    console.error('❌ Create order error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating order',
      error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
    });
  }
};

const getAllOrders = async (req, res) => {
  try {
    console.log('📝 Getting orders (database disabled)');
    res.json({
      success: true,
      count: 0, total: 0, pages: 0, currentPage: 1,
      orders: [],
      note: 'Database connection is disabled. Uncomment mongoose.connect in server.js'
    });
  } catch (error) {
    console.error('❌ Get orders error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching orders',
      error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
    });
  }
};

const getOrderById = async (req, res) => {
  try {
    res.status(404).json({
      success: false,
      message: 'Order not found (database disabled)',
      note: 'Database connection is disabled. Uncomment mongoose.connect() in server.js'
    });
  } catch (error) {
    console.error('❌ Get order error:', error);
    res.status(500).json({ success: false, message: 'Error fetching order' });
  }
};

const updateOrderStatus = async (req, res) => {
  try {
    res.status(503).json({
      success: false,
      message: 'Database not available',
      note: 'Database connection is disabled. Uncomment mongoose.connect() in server.js'
    });
  } catch (error) {
    console.error('❌ Update order error:', error);
    res.status(500).json({ success: false, message: 'Error updating order' });
  }
};

const deleteOrder = async (req, res) => {
  try {
    res.status(503).json({
      success: false,
      message: 'Database not available',
      note: 'Database connection is disabled. Uncomment mongoose.connect() in server.js'
    });
  } catch (error) {
    console.error('❌ Delete order error:', error);
    res.status(500).json({ success: false, message: 'Error deleting order' });
  }
};

const getOrderStats = async (req, res) => {
  try {
    res.json({
      success: true,
      stats: { total: 0, pending: 0, completed: 0, revenue: 0, monthly: [] },
      note: 'Database connection is disabled. Uncomment mongoose.connect() in server.js'
    });
  } catch (error) {
    console.error('❌ Get stats error:', error);
    res.status(500).json({ success: false, message: 'Error fetching statistics' });
  }
};

// ==================== EXPORTS ====================
module.exports = {
  createOrder, getAllOrders, getOrderById,
  updateOrderStatus, deleteOrder, getOrderStats
};