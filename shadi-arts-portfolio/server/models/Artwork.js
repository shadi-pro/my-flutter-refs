const mongoose = require('mongoose');

const ArtworkSchema = new mongoose.Schema({
  // Basic Information
  title: {
    type: String,
    required: [true, 'Artwork title is required'],
    trim: true,
    maxlength: [100, 'Title cannot exceed 100 characters']
  },
  
  category: {
    type: String,
    required: [true, 'Category is required'],
    enum: ['Celebrities', 'Families', 'Couples', 'Children', 'Elders', 'Pets', 'Other']
  },
  
  description: {
    type: String,
    required: [true, 'Description is required'],
    trim: true,
    maxlength: [500, 'Description cannot exceed 500 characters']
  },
  
  // Visual Content
  imageUrl: {
    type: String,
    required: [true, 'Image URL is required']
  },
  
  thumbnailUrl: {
    type: String,
    required: [true, 'Thumbnail URL is required']
  },
  
  // Cloudinary References
  cloudinaryPublicId: {
    type: String,
    required: true
  },
  
  imageDimensions: {
    width: {
      type: Number,
      default: 1200
    },
    height: {
      type: Number,
      default: 800
    }
  },
  
  // Art Details
  year: {
    type: String,
    required: [true, 'Year is required'],
    match: [/^\d{4}$/, 'Year must be 4 digits']
  },
  
  size: {
    type: String,
    required: [true, 'Size is required'],
    enum: ['A4', 'A3', 'A2', 'A1', 'custom'],
    default: 'A4'
  },
  
  medium: {
    type: String,
    default: 'Graphite Pencil on Paper',
    enum: [
      'Graphite Pencil on Paper',
      'Charcoal on Paper', 
      'Colored Pencil on Paper',
      'Mixed Media'
    ]
  },
  
  hours: {
    type: Number,
    min: [1, 'Hours must be at least 1'],
    max: [200, 'Hours cannot exceed 200'],
    default: 25
  },
  
  // Tags & Metadata
  tags: [{
    type: String,
    trim: true,
    lowercase: true
  }],
  
  // Display & Ordering
  featured: {
    type: Boolean,
    default: false
  },
  
  displayOrder: {
    type: Number,
    default: 0,
    min: 0
  },
  
  // Status
  published: {
    type: Boolean,
    default: true
  },
  
  // Statistics
  views: {
    type: Number,
    default: 0,
    min: 0
  },
  
  likes: {
    type: Number,
    default: 0,
    min: 0
  },
  
  // Timestamps
  createdAt: {
    type: Date,
    default: Date.now
  },
  
  updatedAt: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true, // Auto-manage createdAt and updatedAt
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Virtual for formatted size
ArtworkSchema.virtual('formattedSize').get(function() {
  const sizeMap = {
    'A4': 'A4 (21x29.7 cm)',
    'A3': 'A3 (29.7x42 cm)', 
    'A2': 'A2 (42x59.4 cm)',
    'A1': 'A1 (59.4x84.1 cm)',
    'custom': 'Custom Size'
  };
  return sizeMap[this.size] || this.size;
});

// Virtual for estimated completion time
ArtworkSchema.virtual('completionTime').get(function() {
  if (this.hours <= 25) return '3-4 weeks';
  if (this.hours <= 40) return '4-6 weeks';
  return '6-8 weeks';
});

// Update timestamp on save
ArtworkSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  
  // Auto-generate tags from title and category if empty
  if (this.tags.length === 0) {
    const autoTags = [
      ...this.title.toLowerCase().split(' ').filter(word => word.length > 3),
      this.category.toLowerCase(),
      this.medium.toLowerCase().split(' ')[0]
    ].filter((tag, index, array) => array.indexOf(tag) === index);
    
    this.tags = autoTags;
  }
  
  next();
});

// Create indexes for better performance
ArtworkSchema.index({ category: 1, featured: -1, displayOrder: 1 });
ArtworkSchema.index({ tags: 1 });
ArtworkSchema.index({ title: 'text', description: 'text', tags: 'text' });

// Static method to get artworks by category
ArtworkSchema.statics.findByCategory = function(category) {
  return this.find({ 
    category: new RegExp(category, 'i'),
    published: true 
  }).sort({ displayOrder: 1, createdAt: -1 });
};

// Static method to get featured artworks
ArtworkSchema.statics.getFeatured = function(limit = 6) {
  return this.find({ 
    featured: true, 
    published: true 
  })
  .sort({ displayOrder: 1, createdAt: -1 })
  .limit(limit);
};

// Instance method to increment views
ArtworkSchema.methods.incrementViews = function() {
  this.views += 1;
  return this.save();
};

// Instance method to increment likes
ArtworkSchema.methods.incrementLikes = function() {
  this.likes += 1;
  return this.save();
};

module.exports = mongoose.model('Artwork', ArtworkSchema);