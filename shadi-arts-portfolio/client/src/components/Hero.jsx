import React from 'react';
import './Hero.css';

const Hero = () => {
  return (
    <section className="hero" id="home">
      <div className="hero-container">
        <div className="hero-content">
          <h1 className="hero-title">
            <span className="title-line">Professional</span>
            <span className="title-line accent">Pencil Portrait</span>
            <span className="title-line">Artist</span>
          </h1>
          
          <p className="hero-subtitle">
            Transforming moments into timeless <span className="accent">black & white</span> art
          </p>
          
          <p className="hero-description">
            Each portrait is hand-drawn with precision and passion, 
            capturing the soul and personality in every stroke. 
            From celebrities to personal memories, I bring faces to life on paper.
          </p>
          
          <div className="hero-buttons">
            <a href="#gallery" className="btn btn-primary">
              🎨 View Gallery
            </a>
            <a href="#order" className="btn btn-secondary">
              ✏️ Order Portrait
            </a>
            <a 
              href="https://www.youtube.com/@ShadiArts100" 
              target="_blank" 
              rel="noopener noreferrer"
              className="btn btn-youtube"
            >
              ▶️ Watch on YouTube
            </a>
          </div>
          
          <div className="hero-stats">
            <div className="stat">
              <span className="stat-number">50+</span>
              <span className="stat-label">Portraits</span>
            </div>
            <div className="stat">
              <span className="stat-number">100%</span>
              <span className="stat-label">Satisfaction</span>
            </div>
            <div className="stat">
              <span className="stat-number">7+</span>
              <span className="stat-label">Years Experience</span>
            </div>
            <div className="stat">
              <span className="stat-number">20+</span>
              <span className="stat-label">Happy Clients</span>
            </div>
          </div>
        </div>
        
        <div className="hero-image">
          {/* بانر اليوتيوب الرسمي - نفس القناة */}
          <div className="official-youtube-banner">
            <div className="banner-overlay">
              <div className="banner-branding">
                <div className="channel-logo">
                  <img 
                    src="/assets/shadi-logo.jpeg" 
                    alt="Shadi Arts Official Logo"
                    className="channel-logo-image"
                    onError={(e) => {
                      e.target.style.display = 'none';
                      e.target.nextElementSibling.style.display = 'block';
                    }}
                  />
                  <div className="channel-logo-fallback">🎨</div>
                </div>
                
                <div className="channel-info">
                  <h3 className="channel-title">
                    <span className="channel-name-main">Shadi Arts</span>
                    <span className="verified-badge">✓</span>
                  </h3>
                  <p className="channel-stats">
                    <span className="stat-item">🎬 4 videos</span>
                    <span className="stat-item">👁️ 1.6K views</span>
                    <span className="stat-item">👥 20 subscribers</span>
                  </p>
                </div>
              </div>
              
              <div className="banner-cta">
                <a 
                  href="https://www.youtube.com/@ShadiArts100" 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="subscribe-button"
                >
                  <span className="youtube-icon-red">▶️</span>
                  Subscribe to Official Channel
                </a>
                <p className="banner-notice">
                  This is the <strong>official website</strong> of Shadi Arts YouTube channel
                </p>
              </div>
            </div>
            
            {/* صورة البانر نفسها */}
            <img 
              src="/assets/youtube-banner.png" 
              alt="Shadi Arts Official YouTube Channel Banner"
              className="youtube-banner-image"
              onError={(e) => {
                e.target.style.display = 'none';
                e.target.nextElementSibling.style.display = 'flex';
              }}
            />
            <div className="banner-image-fallback">
              <div className="fallback-gradient"></div>
            </div>
          </div>
          
          {/* البانر يظهر أيضا على الجوال */}
          <div className="mobile-youtube-banner">
            <div className="mobile-banner-content">
              <span className="mobile-verified">✓ OFFICIAL</span>
              <h4>Shadi Arts YouTube Channel</h4>
              <a 
                href="https://www.youtube.com/@ShadiArts100" 
                target="_blank" 
                rel="noopener noreferrer"
                className="mobile-subscribe"
              >
                Visit Channel
              </a>
            </div>
          </div>
          
          {/* صورتك الشخصية */}
          <div className="artist-profile">
            <div className="profile-image-container">
              <img 
                src="/assets/shadi-profile.jpg" 
                alt="Shadi - Portrait Artist" 
                className="profile-image"
                onError={(e) => {
                  e.target.style.display = 'none';
                  e.target.nextElementSibling.style.display = 'flex';
                }}
              />
              <div className="profile-fallback">
                <span className="profile-icon">👨‍🎨</span>
              </div>
              
              {/* علامة الفنان */}
              <div className="artist-badge">
                <span className="badge-text">Artist</span>
              </div>
            </div>
            
            <div className="profile-info">
              <h4 className="profile-name">Shadi</h4>
              <p className="profile-title">Professional Portrait Artist</p>
              
              <div className="profile-contact">
                <a 
                  href="mailto:shadiarts.official@gmail.com" 
                  className="contact-email"
                >
                  📧 shadiarts.official@gmail.com
                </a>
                <a 
                  href="https://wa.me/201151638804" 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="contact-whatsapp"
                >
                  💬 +20 1151638804
                </a>
              </div>
              
              <div className="profile-credentials">
                <span className="credential">💎 100% Hand-Drawn</span>
                <span className="credential">🎓 Self-Taught Artist</span>
                <span className="credential">🎵 Classical Musician</span>
              </div>
            </div>
          </div>
          
          {/* شهادة/علامة تميز */}
          <div className="hero-badge">
            <span className="badge-icon">⭐</span>
            <span className="badge-text">Official YouTube Channel Verified</span>
          </div>
        </div>
      </div>
      
      {/* مؤشر للتمرير للأسفل */}
      <div className="scroll-indicator">
        <div className="mouse">
          <div className="wheel"></div>
        </div>
        <span className="scroll-text">Scroll to explore</span>
      </div>
      
      {/* موجز اليوتيوب */}
      <div className="youtube-highlights">
        <div className="highlight-card">
          <div className="highlight-icon">🎬</div>
          <div className="highlight-content">
            <h5>Watch My Process</h5>
            <p>Time-lapse videos on YouTube showing portrait creation</p>
          </div>
        </div>
        
        <div className="highlight-card">
          <div className="highlight-icon">💬</div>
          <div className="highlight-content">
            <h5>Direct Communication</h5>
            <p>Discuss your portrait ideas directly with the artist</p>
          </div>
        </div>
        
        <div className="highlight-card">
          <div className="highlight-icon">🛡️</div>
          <div className="highlight-content">
            <h5>Official & Verified</h5>
            <p>This is the only official website for Shadi Arts</p>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Hero;