const axios = require('axios');

const BASE_URL = 'http://localhost:5000/api';

const runTests = async () => {
  console.log('🧪 ========================================');
  console.log('🧪 Testing Shadi Arts Backend API - FINAL');
  console.log('🧪 ========================================\n');
  
  const tests = [];
  
  try {
    // Test 1: Basic API endpoint
    console.log('1️⃣ Testing basic API endpoint...');
    const res1 = await axios.get(`${BASE_URL}`);
    tests.push({
      name: 'Basic API',
      status: '✅ PASS',
      message: res1.data.message,
      data: res1.data
    });
    console.log('   ✅ Response:', res1.data.message);
    
    // Test 2: Health check
    console.log('\n2️⃣ Testing health endpoint...');
    const res2 = await axios.get(`${BASE_URL}/health`);
    tests.push({
      name: 'Health Check',
      status: '✅ PASS', 
      message: `Status: ${res2.data.status}`,
      data: res2.data
    });
    console.log('   ✅ Status:', res2.data.status);
    
    // Test 3: Order routes health
    console.log('\n3️⃣ Testing order routes health...');
    const res3 = await axios.get(`${BASE_URL}/orders/health`);
    tests.push({
      name: 'Order Routes',
      status: '✅ PASS',
      message: res3.data.message,
      data: res3.data
    });
    console.log('   ✅ Message:', res3.data.message);
    
    // Test 4: Get all orders (should return empty array without DB)
    console.log('\n4️⃣ Testing GET /orders...');
    const res4 = await axios.get(`${BASE_URL}/orders`);
    tests.push({
      name: 'GET Orders',
      status: '✅ PASS',
      message: `Count: ${res4.data.orders?.length || 0} orders`,
      data: res4.data
    });
    console.log('   ✅ Found:', res4.data.orders?.length || 0, 'orders');
    
    // Test 5: Create order with COMPLETE data (should succeed)
    console.log('\n5️⃣ Testing POST /orders (complete data)...');
    try {
      const completeOrder = {
        customerName: 'Test Customer',
        email: 'test@example.com',
        portraitType: 'single',
        paperSize: 'A4'
        // All required fields present
      };
      
      const res5 = await axios.post(`${BASE_URL}/orders`, completeOrder);
      
      if (res5.status === 201) {
        tests.push({
          name: 'POST Order (Complete)',
          status: '✅ PASS',
          message: 'Order created successfully (database disabled)',
          data: { 
            message: res5.data.message,
            note: res5.data.note 
          }
        });
        console.log('   ✅ Success:', res5.data.message);
      } else {
        tests.push({
          name: 'POST Order (Complete)',
          status: '⚠️ UNEXPECTED',
          message: `Got status ${res5.status} instead of 201`,
          data: res5.data
        });
        console.log('   ⚠️ Unexpected status:', res5.status);
      }
    } catch (error) {
      tests.push({
        name: 'POST Order (Complete)',
        status: '❌ FAIL',
        message: 'Failed with complete data',
        data: error.response?.data
      });
      console.log('   ❌ Failed:', error.response?.status, error.response?.data?.message);
    }
    
    // Test 6: Create order with INCOMPLETE data (should fail validation)
    console.log('\n6️⃣ Testing POST /orders (missing required field)...');
    try {
      const incompleteOrder = {
        customerName: 'Test Customer',
        // MISSING email (required field)
        portraitType: 'single',
        paperSize: 'A4'
      };
      
      await axios.post(`${BASE_URL}/orders`, incompleteOrder);
      tests.push({
        name: 'POST Order Validation',
        status: '❌ FAIL',
        message: 'Should have failed validation (missing email)',
        data: null
      });
      console.log('   ❌ Unexpected success - validation not working');
    } catch (error) {
      if (error.response?.status === 400) {
        tests.push({
          name: 'POST Order Validation',
          status: '✅ PASS',
          message: 'Validation working correctly',
          data: {
            message: error.response.data.message,
            errors: error.response.data.errors?.map(e => e.msg)
          }
        });
        console.log('   ✅ Validation working (returned 400)');
        console.log('   Error message:', error.response.data.message);
      } else if (error.response?.status === 503) {
        tests.push({
          name: 'POST Order Validation',
          status: '⚠️ DATABASE DISABLED',
          message: 'Database disabled (returned 503)',
          data: error.response.data
        });
        console.log('   ⚠️ Database disabled (503) - expected when DB is off');
      } else {
        tests.push({
          name: 'POST Order Validation',
          status: '⚠️ UNEXPECTED',
          message: `Got status ${error.response?.status} instead of 400`,
          data: error.response?.data
        });
        console.log('   ⚠️ Got status:', error.response?.status);
      }
    }
    
  } catch (error) {
    console.error('\n🔥 Critical error:', error.message);
    if (error.response) {
      console.error('Response:', error.response.status, error.response.data);
    }
    tests.push({
      name: 'Overall Test Suite',
      status: '❌ FAIL',
      message: error.message,
      data: error.response?.data
    });
  }
  
  // Print summary
  console.log('\n📊 ========================================');
  console.log('📊 TEST SUMMARY - FINAL');
  console.log('📊 ========================================');
  
  tests.forEach((test, index) => {
    const emoji = test.status.includes('PASS') ? '✅' : 
                  test.status.includes('FAIL') ? '❌' : '⚠️';
    console.log(`${emoji} ${index + 1}. ${test.name}: ${test.status}`);
    if (test.message) {
      console.log(`   ${test.message}`);
    }
  });
  
  const passed = tests.filter(t => t.status.includes('PASS')).length;
  const total = tests.length;
  
  console.log('\n📈 ========================================');
  console.log(`📈 Results: ${passed}/${total} tests passed`);
  console.log('📈 ========================================');
  
  if (passed === total) {
    console.log('🎉 PERFECT! All tests passed!');
    console.log('\n🚀 Backend is fully functional!');
    console.log('   Next steps:');
    console.log('   1. Uncomment MongoDB connection in server.js');
    console.log('   2. Build gallery system (Artwork model)');
    console.log('   3. Connect React frontend to backend');
  } else if (passed >= total - 1) {
    console.log('👍 Excellent! Most tests passed.');
    console.log('💡 Check any warnings above.');
  } else {
    console.log('⚠️ Some tests need attention.');
    console.log('🔧 Check the errors above.');
  }
  
  console.log('\n🔗 Tested endpoints:');
  console.log(`   ${BASE_URL}`);
  console.log(`   ${BASE_URL}/health`);
  console.log(`   ${BASE_URL}/orders`);
  console.log(`   ${BASE_URL}/orders/health`);
  console.log('📝 Note: Database connection is currently disabled');
  
  return tests;
};

// Run tests
runTests().catch(console.error);