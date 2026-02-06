// this file :  For handling image uploads to Cloudinary  :

const cloudinary = require('cloudinary').v2;
const { CloudinaryStorage } = require('multer-storage-cloudinary');
const multer = require('multer');
const path = require('path');

// ==================== CLOUDINARY CONFIGURATION ====================
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

// ==================== VALIDATION FUNCTIONS ====================
const validateImageFile = (file) => {
  const allowedMimeTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/gif'];
  const maxSize = 5 * 1024 * 1024; // 5MB
  
  if (!allowedMimeTypes.includes(file.mimetype)) {
    throw new Error(`Invalid file type: ${file.mimetype}. Allowed types: JPEG, PNG, WebP, GIF`);
  }
  
  if (file.size > maxSize) {
    throw new Error(`File too large: ${(file.size / 1024 / 1024).toFixed(2)}MB. Maximum: 5MB`);
  }
  
  return true;
};

// ==================== STORAGE CONFIGURATIONS ====================

// 1. For Order Reference Photos
const orderPhotosStorage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'shadi-arts/orders/reference-photos',
    allowed_formats: ['jpg', 'jpeg', 'png', 'webp', 'gif'],
    transformation: [
      { width: 1200, height: 1200, crop: 'limit' }, // Max dimensions
      { quality: 'auto:good' } // Auto quality
    ],
    public_id: (req, file) => {
      // Generate unique filename: order_{timestamp}_{random}
      const timestamp = Date.now();
      const random = Math.floor(Math.random() * 10000);
      const originalName = path.parse(file.originalname).name;
      return `order_${timestamp}_${random}_${originalName}`;
    }
  }
});

// 2. For Gallery Artworks (Higher quality)
const artworkStorage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'shadi-arts/gallery/artworks',
    allowed_formats: ['jpg', 'jpeg', 'png', 'webp'],
    transformation: [
      { width: 2000, height: 2000, crop: 'limit' }, // Higher resolution for artworks
      { quality: 'auto:best' } // Best quality
    ],
    public_id: (req, file) => {
      const timestamp = Date.now();
      const random = Math.floor(Math.random() * 10000);
      const title = req.body.title 
        ? req.body.title.replace(/\s+/g, '_').toLowerCase().substring(0, 30)
        : 'artwork';
      return `artwork_${title}_${timestamp}_${random}`;
    }
  }
});

// 3. For Thumbnails (Automatically generated)
const thumbnailStorage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'shadi-arts/gallery/thumbnails',
    allowed_formats: ['jpg', 'jpeg', 'png', 'webp'],
    transformation: [
      { width: 400, height: 400, crop: 'fill', gravity: 'auto' }, // Square thumbnails
      { quality: 'auto:good' }
    ],
    public_id: (req, file) => {
      const timestamp = Date.now();
      return `thumb_${timestamp}_${Math.floor(Math.random() * 10000)}`;
    }
  }
});

// ==================== MULTER UPLOAD INSTANCES ====================

// For order reference photos (multiple files)
const uploadOrderPhotos = multer({
  storage: orderPhotosStorage,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB per file
    files: 5 // Max 5 photos per order
  },
  fileFilter: (req, file, cb) => {
    try {
      validateImageFile(file);
      cb(null, true);
    } catch (error) {
      cb(error);
    }
  }
}).array('referencePhotos', 5); // Field name: 'referencePhotos', max 5 files

// For single artwork upload
const uploadArtwork = multer({
  storage: artworkStorage,
  limits: {
    fileSize: 10 * 1024 * 1024 // 10MB for artworks
  },
  fileFilter: (req, file, cb) => {
    try {
      validateImageFile(file);
      cb(null, true);
    } catch (error) {
      cb(error);
    }
  }
}).single('artworkImage'); // Field name: 'artworkImage', single file

// For thumbnail upload (optional)
const uploadThumbnail = multer({
  storage: thumbnailStorage,
  limits: {
    fileSize: 2 * 1024 * 1024 // 2MB for thumbnails
  },
  fileFilter: (req, file, cb) => {
    try {
      validateImageFile(file);
      cb(null, true);
    } catch (error) {
      cb(error);
    }
  }
}).single('thumbnail'); // Field name: 'thumbnail', single file

// ==================== CLOUDINARY UTILITY FUNCTIONS ====================

/**
 * Delete image from Cloudinary
 * @param {string} publicId - Cloudinary public ID
 * @returns {Promise} - Result of deletion
 */
const deleteImage = async (publicId) => {
  try {
    const result = await cloudinary.uploader.destroy(publicId);
    console.log('🗑️ Image deleted from Cloudinary:', publicId);
    return result;
  } catch (error) {
    console.error('❌ Error deleting image from Cloudinary:', error);
    throw error;
  }
};

/**
 * Generate thumbnail URL from main image
 * @param {string} publicId - Original image public ID
 * @param {object} options - Thumbnail options
 * @returns {string} - Thumbnail URL
 */
const generateThumbnailUrl = (publicId, options = {}) => {
  const defaultOptions = {
    width: 400,
    height: 400,
    crop: 'fill',
    gravity: 'auto',
    quality: 'auto:good'
  };
  
  const thumbnailOptions = { ...defaultOptions, ...options };
  return cloudinary.url(publicId, thumbnailOptions);
};

/**
 * Extract public ID from Cloudinary URL
 * @param {string} url - Cloudinary URL
 * @returns {string} - Public ID
 */
const extractPublicId = (url) => {
  if (!url) return null;
  
  // Match Cloudinary URL pattern
  const match = url.match(/\/v\d+\/(.+)\.\w+$/);
  return match ? match[1] : null;
};

/**
 * Upload buffer to Cloudinary (for base64 images)
 * @param {Buffer} buffer - Image buffer
 * @param {string} folder - Cloudinary folder
 * @returns {Promise} - Upload result
 */
const uploadBuffer = async (buffer, folder = 'shadi-arts/uploads') => {
  return new Promise((resolve, reject) => {
    const uploadStream = cloudinary.uploader.upload_stream(
      {
        folder: folder,
        resource_type: 'image'
      },
      (error, result) => {
        if (error) reject(error);
        else resolve(result);
      }
    );
    
    uploadStream.end(buffer);
  });
};

// ==================== ERROR HANDLING MIDDLEWARE ====================

const handleUploadError = (err, req, res, next) => {
  if (err instanceof multer.MulterError) {
    // Multer-specific errors
    if (err.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({
        error: 'File too large',
        message: 'Maximum file size is 5MB for photos, 10MB for artworks'
      });
    }
    
    if (err.code === 'LIMIT_FILE_COUNT') {
      return res.status(400).json({
        error: 'Too many files',
        message: 'Maximum 5 photos per order'
      });
    }
    
    if (err.code === 'LIMIT_UNEXPECTED_FILE') {
      return res.status(400).json({
        error: 'Unexpected file field',
        message: 'Check file field names'
      });
    }
  }
  
  if (err.message && err.message.includes('Invalid file type')) {
    return res.status(400).json({
      error: 'Invalid file type',
      message: 'Only JPEG, PNG, WebP, and GIF images are allowed'
    });
  }
  
  // Pass to default error handler
  next(err);
};

// ==================== EXPORTS ====================
module.exports = {
  // Upload instances
  uploadOrderPhotos,
  uploadArtwork,
  uploadThumbnail,
  
  // Utility functions
  cloudinary,
  deleteImage,
  generateThumbnailUrl,
  extractPublicId,
  uploadBuffer,
  
  // Error handling
  handleUploadError,
  
  // Validation
  validateImageFile
};