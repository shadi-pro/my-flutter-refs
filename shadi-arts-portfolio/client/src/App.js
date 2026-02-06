


import React, {useState ,useEffect} from 'react';
import './App.css';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import About from './components/About';
import Gallery from './components/Gallery';
import OrderForm from './components/OrderForm';
 

function App() {
  return (
    <div className="App">
      {/* 1. شريط التنقل الثابت */}
      <Navbar />
      
      {/* 2. القسم الرئيسي - الصفحة الأولى */}
      <Hero />
      
      {/* 3. قسم التعريف بالفنان */}
      <About />
      
      {/* 4. معرض الأعمال الفنية */}
      <Gallery />
      
      {/* 5. نموذج طلب البورتريه */}
      <OrderForm />
      
      {/* 6. قسم الاتصال (مؤقت) */}
      <section className="contact-section" id="contact">
        <div className="contact-container">
          <h2 className="contact-title">Contact Information</h2>
          <div className="contact-info">
            <div className="contact-method">
              <div className="contact-icon">📧</div>
              <div className="contact-details">
                <h3>Official Email</h3>
                <a href="mailto:shadiarts.official@gmail.com" className="contact-link">
                  shadiarts.official@gmail.com
                </a>
              </div>
            </div>
            
            <div className="contact-method">
              <div className="contact-icon">💬</div>
              <div className="contact-details">
                <h3>WhatsApp Business</h3>
                <a 
                  href="https://wa.me/20115163884" 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="contact-link"
                >
                  +20 1151638804
                </a>
              </div>
            </div>
            
            <div className="contact-method">
              <div className="contact-icon">▶️</div>
              <div className="contact-details">
                <h3>YouTube Channel</h3>
                <a 
                  href="https://www.youtube.com/@ShadiArts100" 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="contact-link"
                >
                  youtube.com/@ShadiArts100
                </a>
              </div>
            </div>
          </div>
          
          <div className="copyright">
            <p>© {new Date().getFullYear()} Shadi Arts 100. All rights reserved.</p>
            <p className="copyright-note">Professional Pencil Portrait Artist</p>
          </div>
        </div>
      </section>
    </div>
  );
}

export default App;