const mongoose = require('mongoose');

const OrderSchema = new mongoose.Schema({
  // Customer Information
  customerName: {
    type: String,
    required: [true, 'Customer name is required'],
    trim: true
  },
  email: {
    type: String,
    required: [true, 'Email is required'],
    match: [/^\S+@\S+\.\S+$/, 'Please enter a valid email']
  },
  phone: {
    type: String,
    trim: true
  },
  country: {
    type: String,
    default: 'Egypt'
  },
  
  // Order Details
  portraitType: {
    type: String,
    required: [true, 'Portrait type is required'],
    enum: ['single', 'couple', 'family', 'pet', 'celebrity']
  },
  subjectCount: {
    type: Number,
    default: 1,
    min: 1,
    max: 10
  },
  paperSize: {
    type: String,
    required: true,
    enum: ['A4', 'A3', 'A2', 'custom']
  },
  backgroundStyle: {
    type: String,
    default: 'simple',
    enum: ['simple', 'detailed', 'minimal', 'custom']
  },
  includeFrame: {
    type: Boolean,
    default: false
  },
  urgencyLevel: {
    type: String,
    default: 'normal',
    enum: ['relaxed', 'normal', 'urgent', 'express']
  },
  
  // Reference Photos
  referencePhotos: [{
    public_id: String,    // Cloudinary public ID
    url: String,          // Cloudinary URL
    filename: String,
    size: Number,
    uploadedAt: {
      type: Date,
      default: Date.now
    }
  }],
  dropboxLink: {
    type: String,
    trim: true
  },
  specialInstructions: {
    type: String,
    trim: true,
    maxlength: [1000, 'Instructions cannot exceed 1000 characters']
  },
  
  // Pricing
  estimatedPrice: {
    type: Number,
    required: true,
    min: 0
  },
  finalPrice: {
    type: Number,
    min: 0
  },
  
  // Status Tracking
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'in-progress', 'completed', 'shipped', 'cancelled'],
    default: 'pending'
  },
  paymentStatus: {
    type: String,
    enum: ['pending', 'partial', 'paid', 'refunded'],
    default: 'pending'
  },
  
  // Timestamps
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  },
  completedAt: Date
}, {
  timestamps: true // Automatically manages createdAt and updatedAt
});

// Update the updatedAt field on save
OrderSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

// Create a text index for search
OrderSchema.index({ 
  customerName: 'text', 
  email: 'text', 
  specialInstructions: 'text' 
});

module.exports = mongoose.model('Order', OrderSchema);