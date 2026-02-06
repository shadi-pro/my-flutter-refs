require('dotenv').config();
const cloudinary = require('cloudinary').v2;

// Configure Cloudinary
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

// Test configuration
console.log('🔧 Testing Cloudinary Configuration:');
console.log('Cloud Name:', cloudinary.config().cloud_name);
console.log('API Key:', cloudinary.config().api_key ? '✓ Set' : '✗ Missing');
console.log('API Secret:', cloudinary.config().api_secret ? '✓ Set' : '✗ Missing');

// Quick upload test (optional - local image)
const testUpload = async () => {
  try {
    console.log('\n🚀 Testing upload...');
    
    // You can create a simple test image or skip this
    const result = await cloudinary.uploader.upload(
      'https://res.cloudinary.com/demo/image/upload/getting-started/shoes.jpg',
      { 
        folder: 'shadi-arts/test',
        public_id: 'test_upload_' + Date.now()
      }
    );
    
    console.log('✅ Upload successful!');
    console.log('URL:', result.secure_url);
    console.log('Public ID:', result.public_id);
    
    // Test delete
    await cloudinary.uploader.destroy(result.public_id);
    console.log('✅ Test cleanup successful!');
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
  }
};

// Run test if all config is present
if (cloudinary.config().cloud_name && 
    cloudinary.config().api_key && 
    cloudinary.config().api_secret) {
  testUpload();
} else {
  console.log('⚠️ Missing configuration. Check your .env file.');
}