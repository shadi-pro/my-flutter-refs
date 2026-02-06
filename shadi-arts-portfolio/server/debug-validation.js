const http = require('http');

console.log('🧪 Debugging Validation\n');

// Test data with ONLY required fields (should PASS)
const completeData = JSON.stringify({
  customerName: 'Test Customer',
  email: 'test@example.com',
  portraitType: 'single',
  paperSize: 'A4'
});

// Test data MISSING email (should FAIL with 400)
const incompleteData = JSON.stringify({
  customerName: 'Test Customer',
  portraitType: 'single',
  paperSize: 'A4'
  // MISSING EMAIL!
});

const testRequest = (data, description) => {
  return new Promise((resolve) => {
    const options = {
      hostname: 'localhost',
      port: 5000,
      path: '/api/orders',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(data)
      }
    };

    const req = http.request(options, (res) => {
      let responseData = '';
      res.on('data', (chunk) => {
        responseData += chunk;
      });
      
      res.on('end', () => {
        console.log(`\n📡 ${description}`);
        console.log(`   Status Code: ${res.statusCode}`);
        
        try {
          const json = JSON.parse(responseData);
          console.log(`   Success: ${json.success}`);
          console.log(`   Message: ${json.message}`);
          
          if (json.errors) {
            console.log(`   Errors: ${json.errors.map(e => e.msg).join(', ')}`);
          }
        } catch (e) {
          console.log(`   Raw Response: ${responseData.substring(0, 200)}...`);
        }
        
        resolve();
      });
    });

    req.on('error', (err) => {
      console.log(`❌ ${description} - Request error: ${err.message}`);
      resolve();
    });

    req.write(data);
    req.end();
  });
};

(async () => {
  console.log('🔍 Testing POST /api/orders validation...');
  
  // Test 1: Complete data (should succeed with 201)
  await testRequest(completeData, '✅ COMPLETE DATA (all required fields)');
  
  // Test 2: Incomplete data (should fail with 400)
  await testRequest(incompleteData, '❌ INCOMPLETE DATA (missing email)');
  
  console.log('\n🎯 Expected Results:');
  console.log('   Test 1: Should return 201 (success)');
  console.log('   Test 2: Should return 400 (validation error)');
})();