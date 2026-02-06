import React, { useState } from "react";
import "./Navbar.css";

const Navbar = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  const closeMenu = () => {
    setIsMenuOpen(false);
  };

  return (
    <>
      <nav className="navbar">
        <div className="navbar-container">
          {/* الهوية الكاملة */}
          <div className="navbar-brand">
            <a href="#home" className="brand-link" onClick={closeMenu}>
              {/* اللوجو */}
              <div className="brand-logo-container">
                <img
                  src="/assets/shadi-logo.png"
                  alt="Shadi Arts Official Logo"
                  className="brand-logo"
                  onError={(e) => {
                    e.target.style.display = "none";
                    e.target.src = "/assets/logo-fallback.jpeg";
                    e.target.nextElementSibling.style.display = "flex";
                  }}
                />
                <div className="logo-fallback">🎨</div>
              </div>                            

              {/* الاسم والعلمة */}
              <div className="brand-text">
                <h1 className="brand-name">
                  Shadi <span className="brand-accent">Arts</span>
                </h1>
                <div className="brand-subtitle">
                  <span className="official-badge">OFFICIAL</span>
                  <span className="tagline">Portrait Artist</span>
                </div>
              </div>
            </a>
          </div>

          {/* Hamburger Icon للجوال */}
          <button
            className={`hamburger ${isMenuOpen ? "active" : ""}`}
            onClick={toggleMenu}
            aria-label="Toggle menu"
          >
            <span className="hamburger-line"></span>
            <span className="hamburger-line"></span>
            <span className="hamburger-line"></span>
          </button>

          {/* القائمة الرئيسية */}
          <ul className={`navbar-menu ${isMenuOpen ? "active" : ""}`}>
            <li className="nav-item">
              <a href="#home" className="nav-link" onClick={closeMenu}>
                <span className="nav-icon">🏠</span>
                Home
              </a>
            </li>

            <li className="nav-item">
              <a href="#about" className="nav-link" onClick={closeMenu}>
                <span className="nav-icon">👨‍🎨</span>
                About
              </a>
            </li>

            <li className="nav-item">
              <a href="#gallery" className="nav-link" onClick={closeMenu}>
                <span className="nav-icon">🖼️</span>
                Gallery
              </a>
            </li>

            <li className="nav-item">
              <a href="#order" className="nav-link" onClick={closeMenu}>
                <span className="nav-icon">✏️</span>
                Order
              </a>
            </li>

            <li className="nav-item youtube-item">
              <a
                href="https://www.youtube.com/@ShadiArts100"
                target="_blank"
                rel="noopener noreferrer"
                className="nav-link youtube-link"
                onClick={closeMenu}
              >
                <span className="nav-icon">▶️</span>
                YouTube
                <span className="external-indicator">↗</span>
              </a>
            </li>
          </ul>

          {/* أيقونات التواصل (للشاشات الكبيرة فقط) */}
          {/* أيقونات التواصل الاجتماعي */}
          {/* أيقونات نصية - مضمونة الظهور */}
          <div className="navbar-social">
            <div className="social-item">
              <a
                href="https://www.youtube.com/@ShadiArts100"
                target="_blank"
                rel="noopener noreferrer"
                className="social-link youtube"
                title="YouTube Channel"
              >
                <span className="text-icon">▶️</span>
                <span className="youtube-badge">1.6K</span>
              </a>
              <span className="social-tooltip">YouTube Channel</span>
            </div>

            <div className="social-item">
              <a
                href="https://wa.me/201151638804"
                target="_blank"
                rel="noopener noreferrer"
                className="social-link whatsapp"
                title="WhatsApp"
              >
                <span className="text-icon">💬</span>
              </a>
              <span className="social-tooltip">WhatsApp Business</span>
            </div>

            <div className="social-item">
              <a
                href="mailto:shadiarts.official@gmail.com"
                className="social-link email"
                title="Email"
              >
                <span className="text-icon">📧</span>
              </a>
              <span className="social-tooltip">Official Email</span>
            </div>
          </div>
        </div>
      </nav>

      {/* شريط اليوتيوب */}
      <div className="youtube-bar">
        <div className="youtube-bar-container">
          <span className="youtube-label">Official Channel:</span>
          <a
            href="https://www.youtube.com/@ShadiArts100"
            target="_blank"
            rel="noopener noreferrer"
            className="youtube-channel-link"
          >
            <span className="youtube-icon">▶️</span>
            <span className="channel-name">Shadi Arts</span>
            <span className="subscriber-count">1.6K subscribers</span>
            <span className="channel-arrow">→</span>
          </a>
        </div>
      </div>
    </>
  );
};

export default Navbar;
