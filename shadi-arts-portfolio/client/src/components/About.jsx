import React from 'react';
import './About.css';

const About = () => {
  return (
    <section className="about-section" id="about">
      <div className="about-container">
        <div className="about-header">
          <h2 className="about-title">
            About <span className="title-accent">Shadi</span>
          </h2>
          <p className="about-subtitle">The Artist Behind the Portraits</p>
        </div>

        <div className="about-content">
          {/* صورتك الشخصية */}
          <div className="about-image">
            <div className="image-frame">
              <img 
                src="/assets/shadi-profile.jpg" 
                alt="Shadi - Portrait Artist" 
                className="artist-portrait"
                onError={(e) => {
                  e.target.style.display = 'none';
                  e.target.nextElementSibling.style.display = 'flex';
                }}
              />
              <div className="portrait-fallback">
                <div className="fallback-content">
                  <span className="fallback-icon">👨‍🎨</span>
                  <span className="fallback-text">Shadi</span>
                </div>
              </div>
              
              {/* إطار فني */}
              <div className="artistic-frame"></div>
            </div>
            
            {/* علامة التوقيع */}
            <div className="signature">
              <span className="signature-text">Shadi</span>
              <span className="signature-line"></span>
            </div>
          </div>

          {/* المعلومات الشخصية */}
          <div className="about-info">
            <div className="bio-section">
              <h3 className="bio-title">My Artistic Journey</h3>
              <p className="bio-text">
                As a <strong>classically trained musician</strong> and <strong>self-taught artist</strong>, 
                I've spent over 7 years perfecting the art of pencil portraiture. 
                My background in music gives me a unique sensitivity to rhythm, harmony, 
                and emotion—qualities I translate into every stroke of my pencil.
              </p>
              
              <p className="bio-text">
                Each portrait is more than just a drawing; it's a <strong>story captured in graphite</strong>. 
                From the subtle play of light and shadow to the intricate details that reveal personality, 
                I strive to create pieces that resonate emotionally and stand the test of time.
              </p>
            </div>

            {/* المهارات */}
            <div className="skills-section">
              <h4 className="skills-title">My Expertise</h4>
              <div className="skills-grid">
                <div className="skill-card">
                  <div className="skill-icon">✏️</div>
                  <div className="skill-content">
                    <h5>Pencil Portraiture</h5>
                    <p>Specialized in graphite pencil drawings with exceptional detail</p>
                  </div>
                </div>
                
                <div className="skill-card">
                  <div className="skill-icon">👁️</div>
                  <div className="skill-content">
                    <h5>Character Capture</h5>
                    <p>Focus on capturing personality and emotion, not just likeness</p>
                  </div>
                </div>
                
                <div className="skill-card">
                  <div className="skill-icon">🎨</div>
                  <div className="skill-content">
                    <h5>Artistic Sensitivity</h5>
                    <p>Musician's ear translated to artist's eye for harmony and balance</p>
                  </div>
                </div>
              </div>
            </div>

            {/* روابط */}
            <div className="links-section">
              <h4 className="links-title">Connect With Me</h4>
              <div className="social-links">
                <a 
                  href="https://www.youtube.com/@ShadiArts100" 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="social-link youtube-link"
                >
                  <span className="link-icon">📺</span>
                  <span className="link-text">YouTube Channel</span>
                  <span className="link-arrow">→</span>
                </a>
                
                <a 
                  href="https://wa.me/201234567890" 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="social-link whatsapp-link"
                >
                  <span className="link-icon">💬</span>
                  <span className="link-text">WhatsApp Business</span>
                  <span className="link-arrow">→</span>
                </a>
                
                <a 
                  href="mailto:shadiartsportfolio@gmail.com" 
                  className="social-link email-link"
                >
                  <span className="link-icon">📧</span>
                  <span className="link-text">Email Consultation</span>
                  <span className="link-arrow">→</span>
                </a>
              </div>
            </div>
          </div>
        </div>

        {/* علامة YouTube */}
        <div className="youtube-cta">
          <div className="cta-content">
            <div className="cta-icon">🎬</div>
            <div className="cta-text">
              <h4>Watch My Creative Process on YouTube</h4>
              <p>Subscribe to see time-lapses, tutorials, and portrait creation stories</p>
            </div>
            <a 
              href="https://www.youtube.com/@ShadiArts100" 
              target="_blank" 
              rel="noopener noreferrer"
              className="cta-button"
            >
              Subscribe Now
            </a>
          </div>
        </div>
      </div>
    </section>
  );
};

export default About;