// D:\Bussiness\My Bussines\Shadi Arts\shadi-arts-portfolio\client\src\components\Gallery.jsx

import React, { useState, useEffect, useRef } from 'react';
import './Gallery.css';

// بيانات الأعمال الحقيقية - معدلة مع تأثيرات
const initialArtworks = [
  {
    id: 1,
    title: "The Thinker",
    category: "Celebrities",
    description: "Portrait of a famous actor in thoughtful pose",
    year: "2023",
    size: "A4",
    tags: ["celebrity", "dramatic", "detailed"],
    imageUrl: "/assets/shadi-profile.jpg" 
  },
  {
    id: 2,
    title: "Eternal Love",
    category: "Couples",
    description: "Wedding portrait capturing intimate moment",
    year: "2022",
    size: "A4",
    tags: ["wedding", "romantic", "couple"],
    imageUrl: "/assets/shadi-logo.jpeg" 
  },
  {
    id: 3,
    title: "Wisdom in Eyes",
    category: "Elders",
    description: "Elderly person with lifetime of stories",
    year: "2024",
    size: "A4",
    tags: ["elderly", "expressive", "character"],
    imageUrl: "/assets/youtube-banner.png" 
  },
  {
    id: 4,
    title: "Innocent Smile",
    category: "Children",
    description: "Child portrait capturing pure joy",
    year: "2023",
    size: "A4",
    tags: ["child", "innocent", "happy"],
    imageUrl: "/assets/shadi-profile.jpg"  
  },
  {
    id: 5,
    title: "Musical Soul",
    category: "Celebrities",
    description: "Famous musician with instrument",
    year: "2022",
    size: "A4",
    tags: ["musician", "artistic", "dynamic"],
    imageUrl: "/assets/shadi-logo.jpeg"  
  },
  {
    id: 6,
    title: "Family Bond",
    category: "Families",
    description: "Three generations together",
    year: "2024",
    size: "A4",   
    tags: ["family", "generations", "group"],
    imageUrl: "/assets/youtube-banner.png"  
  }
];

const Gallery = () => {
  const [artworks, setArtworks] = useState(initialArtworks);
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [selectedArtwork, setSelectedArtwork] = useState(null);
  const [filterChange, setFilterChange] = useState(false);
  const galleryRef = useRef(null);
  const cardRefs = useRef([]);

  //  Dynamic List :
  const categories = ['All', ...new Set(artworks.map(art => art.category))];

  const filteredArtworks = selectedCategory === 'All' 
    ? artworks 
    : artworks.filter(art => art.category === selectedCategory);

  const handleCategoryClick = (category) => {
    setFilterChange(true);
    setSelectedCategory(category);
    
    // إضافة animation class للكروت
    cardRefs.current.forEach(card => {
      if (card) {
        card.classList.add('filter-change');
        setTimeout(() => {
          card.classList.remove('filter-change');
        }, 600);
      }
    });
    
    setTimeout(() => {
      setFilterChange(false);
    }, 300);
  };

  const handleArtworkClick = (artwork) => {
    setSelectedArtwork(artwork);
    // إضافة اهتزاز خفيف عند النقر
    const card = cardRefs.current[artwork.id - 1];
    if (card) {
      card.style.transform = 'scale(0.98)';
      setTimeout(() => {
        card.style.transform = '';
      }, 150);
    }
  };

  const closeModal = () => {
    setSelectedArtwork(null);
  };

  // ==================== 🔒 حماية الصور - FINAL VERSION ====================
  useEffect(() => {
    // إضافة CSS protection مباشرة - بدون تعقيد
    const styleId = 'image-protection-global';
    if (!document.getElementById(styleId)) {
      const style = document.createElement('style');
      style.id = styleId;
      style.textContent = `
        /* حماية أساسية - لا تتعارض مع أي شيء */
        .real-portrait-image, 
        .modal-real-image,
        .artwork-real-img {
          pointer-events: none !important;
          -webkit-user-drag: none !important;
          user-drag: none !important;
        }
        
        /* watermark بسيط */
        .real-image-container::after,
        .modal-real-image-container::after {
          content: '' !important;
        }
        
        /* رسالة الحماية */
        #gallery-protection-toast {
          position: fixed;
          bottom: 20px;
          right: 20px;
          background: #1a1a1a;
          color: #f0a500;
          padding: 12px 18px;
          border-radius: 8px;
          border: 1px solid #f0a500;
          z-index: 99999;
          font-weight: bold;
          display: none;
          max-width: 300px;
        }
        
        #gallery-protection-toast.show {
          display: block;
          animation: fadeIn 0.3s ease;
        }
        
        @keyframes fadeIn {
          from { opacity: 0; transform: translateY(10px); }
          to { opacity: 1; transform: translateY(0); }
        }
      `;
      document.head.appendChild(style);
    }
    
    // دالة لعرض الرسالة
    const showProtectionAlert = (type) => {
      // إزالة الرسالة القديمة إذا موجودة
      const oldToast = document.getElementById('gallery-protection-toast');
      if (oldToast) oldToast.remove();
      
      // إنشاء رسالة جديدة
      const toast = document.createElement('div');
      toast.id = 'gallery-protection-toast';
      toast.className = 'gallery-protection-toast';
      
      const message = type === 'right-click' 
        ? '🛡️ الصورة محمية - للاستفسارات: +20 1151638804'
        : '📋 المحتوى محمي © Shadi Arts';
      
      toast.textContent = message;
      document.body.appendChild(toast);
      
      // إظهار الرسالة
      setTimeout(() => toast.classList.add('show'), 10);
      
      // إخفاء بعد 3 ثواني
      setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => {
          if (toast.parentNode) toast.remove();
        }, 300);
      }, 3000);
    };
    
    // منع right-click بسيط
    const handleRightClick = (e) => {
      if (e.target.tagName === 'IMG') {
        e.preventDefault();
        showProtectionAlert('right-click');
        return false;
      }
    };
    
    // إضافة event listener
    document.addEventListener('contextmenu', handleRightClick);
    
    // تنظيف
    return () => {
      document.removeEventListener('contextmenu', handleRightClick);
      const toast = document.getElementById('gallery-protection-toast');
      if (toast) toast.remove();
      const style = document.getElementById('image-protection-global');
      if (style) style.remove();
    };
  }, []);

  // إضافة reveal on scroll
  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('revealed');
          }
        });
      },
      {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
      }
    );

    const elements = document.querySelectorAll('.reveal-on-scroll');
    elements.forEach(el => observer.observe(el));

    return () => observer.disconnect();
  }, []);

  return (
    <section className="gallery reveal-on-scroll" id="gallery" ref={galleryRef}>
      <div className="gallery-container">
        <div className="gallery-header reveal-on-scroll">
          <h2 className="gallery-title">
            <span className="title-underline">Portfolio</span> Gallery
          </h2>
          <p className="gallery-subtitle">
            A collection of hand-drawn pencil portraits, each telling a unique story
          </p>
        </div>

        {/* فلاتر التصنيف */}
        <div className="category-filters reveal-on-scroll">
          {categories.map(category => (
            <button
              key={category}
              className={`category-btn ${selectedCategory === category ? 'active' : ''} floating`}
              onClick={() => handleCategoryClick(category)}
            >
              {category}
              <span className="btn-underline"></span>
            </button>
          ))}
        </div>

        {/* شبكة الصور */}
        <div className="artworks-grid">
          {filteredArtworks.map((artwork, index) => (
            <div 
              key={artwork.id} 
              className={`artwork-card ${filterChange ? 'filter-change' : ''}`}
              onClick={() => handleArtworkClick(artwork)}
              ref={el => cardRefs.current[index] = el}
              style={{ animationDelay: `${index * 0.1}s` }}
            >
              <div className="artwork-image shimmer">
                {/* عرض الصورة الحقيقية */}
                {artwork.imageUrl ? (
                  <div className="real-image-container">
                    <img 
                      src={artwork.imageUrl} 
                      alt={artwork.title}
                      className="real-portrait-image protected-image"
                      onError={(e) => {
                        e.target.style.display = 'none';
                        const placeholder = e.target.nextElementSibling;
                        if (placeholder) placeholder.style.display = 'block';
                      }}
                    />
                    {/* placeholder احتياطي */}
                    <div className="placeholder-art" style={{ display: 'none' }}>
                      <div className="art-preview">
                        <div className="pencil-stroke stroke-1"></div>
                        <div className="pencil-stroke stroke-2"></div>
                        <div className="pencil-stroke stroke-3"></div>
                        <div className="artwork-overlay">
                          <span className="view-text">👁️ View Details</span>
                        </div>
                      </div>
                    </div>
                  </div>
                ) : (
                  <div className="placeholder-art">
                    <div className="art-preview">
                      <div className="pencil-stroke stroke-1"></div>
                      <div className="pencil-stroke stroke-2"></div>
                      <div className="pencil-stroke stroke-3"></div>
                      <div className="artwork-overlay">
                        <span className="view-text">👁️ View Details</span>
                      </div>
                    </div>
                  </div>
                )}
                
                <div className="category-tag floating">
                  {artwork.category}
                </div>
              </div>
              
              <div className="artwork-info">
                <h3 className="artwork-title">{artwork.title}</h3>
                <p className="artwork-description">{artwork.description}</p>
                
                <div className="artwork-meta">
                  <span className="meta-item">
                    <span className="meta-icon">📅</span>
                    {artwork.year}
                  </span>
                  <span className="meta-item">
                    <span className="meta-icon">📏</span>
                    {artwork.size}
                  </span>
                </div>
                
                <div className="artwork-tags">
                  {artwork.tags.map(tag => (
                    <span key={tag} className="tag">{tag}</span>
                  ))}
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* ملاحظة للمستخدم */}
        <div className="gallery-note reveal-on-scroll">
          <div className="note-icon">💡</div>
          <p className="note-text">
            <strong>Note:</strong> These are sample artworks. Your actual pencil portraits will be displayed here. 
            Each portrait takes approximately 20-40 hours to complete.
          </p>
        </div>
      </div>

      {/* Modal */}
      {selectedArtwork && (
        <div className="artwork-modal" onClick={closeModal}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <button className="modal-close" onClick={closeModal}>×</button>
            
            <div className="modal-body">
              <div className="modal-image">
                {/* عرض الصورة الحقيقية في الـ Modal */}
                {selectedArtwork.imageUrl ? (
                  <div className="modal-real-image-container">
                    <img 
                      src={selectedArtwork.imageUrl} 
                      alt={selectedArtwork.title}
                      className="modal-real-image protected-image"
                      onError={(e) => {
                        e.target.style.display = 'none';
                        const placeholder = e.target.nextElementSibling;
                        if (placeholder) placeholder.style.display = 'flex';
                      }}
                    />
                    <div className="modal-placeholder shimmer" style={{ display: 'none' }}>
                      <div className="modal-preview">
                        <div className="modal-stroke stroke-1"></div>
                        <div className="modal-stroke stroke-2"></div>
                        <div className="modal-stroke stroke-3"></div>
                        <div className="modal-stroke stroke-4"></div>
                      </div>
                      <div className="image-watermark">Shadi Arts ©</div>
                    </div>
                  </div>
                ) : (
                  <div className="modal-placeholder shimmer">
                    <div className="modal-preview">
                      <div className="modal-stroke stroke-1"></div>
                      <div className="modal-stroke stroke-2"></div>
                      <div className="modal-stroke stroke-3"></div>
                      <div className="modal-stroke stroke-4"></div>
                    </div>
                    <div className="image-watermark">Shadi Arts ©</div>
                  </div>
                )}
              </div>
              
              <div className="modal-details">
                <h3 className="modal-title">{selectedArtwork.title}</h3>
                <div className="modal-category floating">{selectedArtwork.category}</div>
                
                <p className="modal-description">{selectedArtwork.description}</p>
                
                <div className="modal-specs">
                  <div className="spec">
                    <span className="spec-label">Year:</span>
                    <span className="spec-value">{selectedArtwork.year}</span>
                  </div>
                  <div className="spec">
                    <span className="spec-label">Size:</span>
                    <span className="spec-value">{selectedArtwork.size}</span>
                  </div>
                  <div className="spec">
                    <span className="spec-label">Medium:</span>
                    <span className="spec-value">Graphite Pencil on Paper</span>
                  </div>
                  <div className="spec">
                    <span className="spec-label">Time:</span>
                    <span className="spec-value">25-35 hours</span>
                  </div>
                </div>
                
                <div className="modal-tags">
                  {selectedArtwork.tags.map(tag => (
                    <span key={tag} className="modal-tag floating">{tag}</span>
                  ))}
                </div>
                
                <div className="modal-actions">
                  <button className="modal-btn primary floating">
                    🛒 Order Similar Portrait
                  </button>
                  <button className="modal-btn secondary">
                    📩 Contact for Custom Work
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </section>
  );
};

export default Gallery;