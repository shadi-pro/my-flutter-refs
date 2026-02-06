/*  
  ✅ Features Identified:
    (4) Step Form with progress tracking

    File upload with preview (max 5 images, 5MB each)

    Price calculation with multiple factors

    WhatsApp integration for order submission

    Local storage for draft saving

    Cloud link (Dropbox/Google Drive) support
 
*/


import React, { useState } from "react";
import "./OrderForm.css";

const OrderForm = () => {
  const [step, setStep] = useState(1);
  const [formData, setFormData] = useState({
    // Phase 1 / Portrait type :
    portraitType: "",
    subjectCount: "1",
    paperSize: "A4",

    // Phase 2 / addition details :
    backgroundStyle: "simple",
    includeFrame: false,
    urgencyLevel: "normal",

    // Phase 3 :  Personal info
    fullName: "",
    email: "",
    phone: "",
    country: "Egypt",
    
    
    // Phase 4 :  Referencial Images :
    referencePhotos: [],
    dropboxLink: "",
    specialInstructions: "",

    // Price property
    estimatedPrice: 0,
  });

  //  Available Portraits types + price policies    :
  const portraitTypes = [
    {
      id: "single",
      name: "Single Portrait",
      basePrice: 1500,
      description: "One person portrait",
    },
    {
      id: "couple",
      name: "Couple Portrait",
      basePrice: 2500,
      description: "Two people together",
    },
    {
      id: "family",
      name: "Family Portrait",
      basePrice: 3500,
      description: "3-5 people",
    },
    {
      id: "pet",
      name: "Pet Portrait",
      basePrice: 1200,
      description: "Your beloved pet",
    },
    {
      id: "celebrity",
      name: "Celebrity Portrait",
      basePrice: 2000,
      description: "Famous personality",
    },
  ];

  // Paper sizes  : 
  const paperSizes = [
    { id: "A4", name: "A4 (21x29.7 cm)", priceMultiplier: 1 },
    { id: "A3", name: "A3 (29.7x42 cm)", priceMultiplier: 1.5 },
    { id: "A2", name: "A2 (42x59.4 cm)", priceMultiplier: 2 },
    { id: "custom", name: "Custom Size", priceMultiplier: 2.5 },
  ];

  // Urgent level  : 
  const urgencyLevels = [
    { id: "relaxed", name: "Relaxed (4-6 weeks)", priceMultiplier: 1 },
    { id: "normal", name: "Normal (2-3 weeks)", priceMultiplier: 1.2 },
    { id: "urgent", name: "Urgent (1 week)", priceMultiplier: 1.5 },
    { id: "express", name: "Express (3-4 days)", priceMultiplier: 2 },
  ];

  // ==================== Image file handling functions    ====================
  const handleFileUpload = (files) => {
    const allowedTypes = ["image/jpeg", "image/png", "image/jpg", "image/webp"];
    const maxSize = 5 * 1024 * 1024; // 5MB
    const maxFiles = 5;

    const validFiles = [];

    Array.from(files).forEach((file) => {
      if (!allowedTypes.includes(file.type)) {
        alert(
          `❌ ${file.name} is not a supported image type (JPEG, PNG, WebP only)`
        );
        return;
      }

      if (file.size > maxSize) {
        alert(`❌ ${file.name} is too large (max 5MB)`);
        return;
      }

      if (formData.referencePhotos.length + validFiles.length >= maxFiles) {
        alert(`❌ Maximum ${maxFiles} photos allowed`);
        return;
      }

      // Image Preview Creation :
      const reader = new FileReader();
      reader.onload = (e) => {
        const photoWithPreview = {
          file,
          name: file.name,
          size: file.size,
          type: file.type,
          preview: e.target.result,
        };

        setFormData((prev) => ({
          ...prev,
          referencePhotos: [...prev.referencePhotos, photoWithPreview],
        }));
      };
      reader.readAsDataURL(file);

      validFiles.push(file);
    });
  };

  const handleFileDrop = (files) => {
    handleFileUpload(files);
  };

  const removePhoto = (index) => {
    setFormData((prev) => ({
      ...prev,
      referencePhotos: prev.referencePhotos.filter((_, i) => i !== index),
    }));
  };

  // ====================  Price Calculation   ====================
  const calculatePrice = () => {
    const selectedType = portraitTypes.find(
      (t) => t.id === formData.portraitType
    );
    const selectedSize = paperSizes.find((s) => s.id === formData.paperSize);
    const selectedUrgency = urgencyLevels.find(
      (u) => u.id === formData.urgencyLevel
    );

    if (!selectedType || !selectedSize || !selectedUrgency) return 0;

    let price =
      selectedType.basePrice *
      selectedSize.priceMultiplier *
      selectedUrgency.priceMultiplier;

    // Adding the [Image Frame] cost if it desired : 
    if (formData.includeFrame) price += 500;

    // Considering [10%] discount percentage for more than one person :  
    if (formData.subjectCount > 1) price *= 0.9;

    return Math.round(price);  // [retunrign the final price ] 
  };

  // ====================  [Inputs processing ] ====================
  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: type === "checkbox" ? checked : value,
    }));
  };

  // ====================  transporting betweeen steps  ====================
  const nextStep = () => {
    if (step < 4) setStep(step + 1);
  };

  const prevStep = () => {
    if (step > 1) setStep(step - 1);
  };

  // ====================  Prepairing  Watsapp messages  ====================
  const createWhatsAppMessage = () => {
    const selectedType = portraitTypes.find(
      (t) => t.id === formData.portraitType
    );
    const selectedSize = paperSizes.find((s) => s.id === formData.paperSize);
    const selectedUrgency = urgencyLevels.find(
      (u) => u.id === formData.urgencyLevel
    );

    let message =
      `🎨 *New Portrait Order - Shadi Arts* 🎨%0A%0A` +
      `*Customer Information:*%0A` +
      `👤 Name: ${formData.fullName || "Not provided"}%0A` +
      `📧 Email: ${formData.email || "Not provided"}%0A` +
      `📞 Phone: ${formData.phone || "Not provided"}%0A` +
      `📍 Country: ${formData.country}%0A%0A` +
      `*Order Details:*%0A` +
      `🖼️ Type: ${selectedType?.name || "Not selected"}%0A` +
      `📏 Size: ${selectedSize?.name || "Not selected"}%0A` +
      `👥 Subjects: ${formData.subjectCount} person(s)%0A` +
      `⏱️ Timeline: ${selectedUrgency?.name || "Not selected"}%0A` +
      `🖼️ Framing: ${formData.includeFrame ? "Yes (+EGP 500)" : "No"}%0A` +
      `💰 Estimated Total: *EGP ${calculatePrice()}*%0A%0A` +
      `*Special Instructions:*%0A${
        formData.specialInstructions || "None provided"
      }%0A%0A`;

    // Adding images info or the Watsapp message  :
    if (formData.referencePhotos.length > 0) {
      message += `📸 *Photos Uploaded:* ${formData.referencePhotos.length} photo(s) via website%0A`;
    }

    if (formData.dropboxLink) {
      message += `☁️ *Cloud Link:* ${formData.dropboxLink}%0A%0A`;
    }

    message +=
      `📸 *NEXT STEPS:*%0A` +
      `1️⃣ ${
        formData.referencePhotos.length > 0
          ? "Photos uploaded via website - ready to start!"
          : "Please send REFERENCE PHOTO(S) for the portrait"
      }%0A` +
      `2️⃣ Higher quality photos = Better results%0A` +
      `3️⃣ I'll send a sketch preview before final work%0A%0A` +
      `_Order submitted via Shadi Arts Portfolio Website_`;

    return message;
  };

  // ==================== Sending the wtatapp  ====================
  const submitViaWhatsApp = () => {
    if (!formData.fullName || !formData.email) {
      alert("⚠️ Please fill in your name and email before ordering.");
      return;
    }

    const userConfirmed = window.confirm(
      `🎨 Ready to Order?\n\n` +
        `1️⃣ This will open WhatsApp with your order details\n` +
        `2️⃣ ${
          formData.referencePhotos.length > 0
            ? "Photos already uploaded via website"
            : "Please send your REFERENCE PHOTO(S) after the message"
        }\n` +
        `3️⃣ Higher quality photos = Better portrait results\n` +
        `4️⃣ I'll respond within 2-4 hours\n\n` +
        `Click OK to proceed to WhatsApp.`
    );

    if (!userConfirmed) return;

    const message = createWhatsAppMessage();
    const whatsappNumber = "201234567890";

    window.open(`https://wa.me/${whatsappNumber}?text=${message}`, "_blank");

    setTimeout(() => {
      alert(
        "✅ WhatsApp opened! Please:\n\n1. Send the message\n2. Wait for my confirmation reply"
      );
    }, 500);
  };

  return (
    <section className="order-form-section" id="order">
      <div className="form-container">
        {/* Main  Form Order  Title  */}
        <div className="form-header">
          <h2 className="form-title">
            <span className="title-accent">Order</span> Your Custom Portrait
          </h2>
          <p className="form-subtitle">
            Commission a hand-drawn pencil portrait in 4 simple steps
          </p>
        </div>

        {/* Offers + Discounts */}
        <div className="special-offers">
          <div className="offer-card discount-offer">
            <div className="offer-badge">🎉 SPECIAL OFFER</div>
            <div className="offer-content">
              <h4 className="offer-title">
                Family & Multiple Portraits Discount
              </h4>
              <p className="offer-description">
                Order 2+ portraits and get <strong>10% discount</strong> on
                total order!
              </p>
              <div className="offer-details">
                <span className="offer-detail">👥 2 portraits: 10% off</span>
                <span className="offer-detail">👨‍👩‍👧‍👦 3+ portraits: 15% off</span>
                <span className="offer-detail">
                  🔄 Repeat customers: 20% off
                </span>
              </div>
            </div>
          </div>

          <div className="offer-card whatsapp-offer">
            <div className="offer-content">
              <h4 className="offer-title">Direct WhatsApp Order</h4>
              <p className="offer-description">
                Order via WhatsApp for <strong>priority processing</strong> and
                direct communication with the artist!
              </p>
              <div className="offer-features">
                <span className="offer-feature">⚡ Instant response</span>
                <span className="offer-feature">
                  💬 Direct artist communication
                </span>
                <span className="offer-feature">
                  🎨 Customization discussions
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* Progress Indicator */}
        <div className="progress-steps">
          {[1, 2, 3, 4].map((stepNum) => (
            <div key={stepNum} className="step-container">
              <div className={`step-circle ${step >= stepNum ? "active" : ""}`}>
                {stepNum}
              </div>
              <div className="step-label">
                {stepNum === 1 && "Portrait Type"}
                {stepNum === 2 && "Details"}
                {stepNum === 3 && "Your Info & Photos"}
                {stepNum === 4 && "Review & Order"}
              </div>
              {stepNum < 4 && <div className="step-connector"></div>}
            </div>
          ))}
        </div>

        {/* MultiSteps Form  */}
        <form className="multi-step-form">
          {/*   step 1 / Protrait Type  */}
          {step === 1 && (
            <div className="form-step animated-step">
              <h3 className="step-title">Select Portrait Type</h3>

              <div className="portrait-type-grid">
                {portraitTypes.map((type) => (
                  <div
                    key={type.id}
                    className={`type-card ${
                      formData.portraitType === type.id ? "selected" : ""
                    }`}
                    onClick={() =>
                      setFormData((prev) => ({
                        ...prev,
                        portraitType: type.id,
                      }))
                    }
                  >
                    <div className="type-icon">
                      {type.id === "single" && "👤"}
                      {type.id === "couple" && "👫"}
                      {type.id === "family" && "👨‍👩‍👧‍👦"}
                      {type.id === "pet" && "🐾"}
                      {type.id === "celebrity" && "⭐"}
                    </div>
                    <h4 className="type-name">{type.name}</h4>
                    <p className="type-description">{type.description}</p>
                    <div className="type-price">
                      Starting from EGP {type.basePrice}
                    </div>
                  </div>
                ))}
              </div>

              <div className="size-selection">
                <h4>Select Paper Size</h4>
                <div className="size-options">
                  {paperSizes.map((size) => (
                    <label key={size.id} className="size-option">
                      <input
                        type="radio"
                        name="paperSize"
                        value={size.id}
                        checked={formData.paperSize === size.id}
                        onChange={handleInputChange}
                      />
                      <span className="size-label">{size.name}</span>
                    </label>
                  ))}
                </div>
              </div>

              <div className="step-buttons single-button">
                <button
                  type="button"
                  className="btn-next"
                  onClick={nextStep}
                  disabled={!formData.portraitType}
                >
                  Next: Details →
                </button>
              </div>
            </div>
          )}

          {/*  Step 2 /  Portrait details    */}
          {step === 2 && (
            <div className="form-step animated-step">
              <h3 className="step-title">Additional Details</h3>

              <div className="form-group">
                <label>Number of Subjects</label>
                <select
                  name="subjectCount"
                  value={formData.subjectCount}
                  onChange={handleInputChange}
                  className="form-select"
                >
                  {[1, 2, 3, 4, 5].map((num) => (
                    <option key={num} value={num}>
                      {num} {num === 1 ? "Person" : "People"}
                      {num > 1 ? " (10% discount)" : ""}
                    </option>
                  ))}
                </select>
              </div>

              <div className="form-group">
                <label>Background Style</label>
                <div className="background-options">
                  {["simple", "detailed", "minimal", "custom"].map((style) => (
                    <label key={style} className="background-option">
                      <input
                        type="radio"
                        name="backgroundStyle"
                        value={style}
                        checked={formData.backgroundStyle === style}
                        onChange={handleInputChange}
                      />
                      <span className="option-label">
                        {style.charAt(0).toUpperCase() + style.slice(1)}
                      </span>
                    </label>
                  ))}
                </div>
              </div>

              <div className="form-group">
                <label className="checkbox-label">
                  <input
                    type="checkbox"
                    name="includeFrame"
                    checked={formData.includeFrame}
                    onChange={handleInputChange}
                  />
                  <span>Include Professional Framing (+EGP 500)</span>
                </label>
              </div>

              <div className="form-group">
                <label>Delivery Timeline</label>
                <div className="urgency-options">
                  {urgencyLevels.map((level) => (
                    <label key={level.id} className="urgency-option">
                      <input
                        type="radio"
                        name="urgencyLevel"
                        value={level.id}
                        checked={formData.urgencyLevel === level.id}
                        onChange={handleInputChange}
                      />
                      <span className="urgency-label">
                        {level.name}
                        <span className="urgency-price">
                          ×{level.priceMultiplier}
                        </span>
                      </span>
                    </label>
                  ))}
                </div>
              </div>

              <div className="step-buttons">
                <button type="button" className="btn-prev" onClick={prevStep}>
                  ← Back
                </button>
                <button type="button" className="btn-next" onClick={nextStep}>
                  Next: Your Info & Photos →
                </button>
              </div>
            </div>
          )}

          {/* Step 3/ Personal info and Image  */}
          {step === 3 && (
            <div className="form-step animated-step">
              <h3 className="step-title">
                Your Information & Reference Photos
              </h3>

              <div className="form-group">
                <label>Full Name *</label>
                <input
                  type="text"
                  name="fullName"
                  value={formData.fullName}
                  onChange={handleInputChange}
                  placeholder="Enter your full name"
                  required
                />
              </div>

              <div className="form-row">
                <div className="form-group">
                  <label>Email Address *</label>
                  <input
                    type="email"
                    name="email"
                    value={formData.email}
                    onChange={handleInputChange}
                    placeholder="your@email.com"
                    required
                  />
                </div>

                <div className="form-group">
                  <label>Phone Number (WhatsApp)</label>
                  <input
                    type="tel"
                    name="phone"
                    value={formData.phone}
                    onChange={handleInputChange}
                    placeholder="+20 123 456 7890"
                  />
                </div>
              </div>

              <div className="form-group">
                <label>Country</label>
                <select
                  name="country"
                  value={formData.country}
                  onChange={handleInputChange}
                  className="form-select"
                >
                  <option value="Egypt">Egypt</option>
                  <option value="Other">Other Country</option>
                </select>
              </div>

              {/*  Uploading image section  */}
              <div className="photo-upload-section">
                <div className="photo-upload-header">
                  <h4>📸 Reference Photo(s) - REQUIRED</h4>
                  <p className="photo-upload-note">
                    Upload photos directly or send via WhatsApp after order
                  </p>
                </div>

                {/*  Image direct uploading area  */}
                <div className="upload-method-card">
                  <div className="method-header">
                    <div className="method-icon">⬆️</div>
                    <div className="method-title">
                      <h5>Direct Upload (Recommended)</h5>
                      <p className="method-subtitle">
                        Upload photos directly here
                      </p>
                    </div>
                  </div>

                  <div className="method-content">
                    <p>
                      Upload your reference photos directly. Max 5 photos, 5MB
                      each.
                    </p>

                    <div
                      className="upload-area"
                      onClick={() =>
                        document.getElementById("photo-upload").click()
                      }
                      onDragOver={(e) => {
                        e.preventDefault();
                        e.currentTarget.classList.add("dragover");
                      }}
                      onDragLeave={(e) => {
                        e.preventDefault();
                        e.currentTarget.classList.remove("dragover");
                      }}
                      onDrop={(e) => {
                        e.preventDefault();
                        e.currentTarget.classList.remove("dragover");
                        handleFileDrop(e.dataTransfer.files);
                      }}
                    >
                      {formData.referencePhotos.length > 0 ? (
                        <div className="upload-preview">
                          <div className="preview-count">
                            📷 {formData.referencePhotos.length} photo(s)
                            selected
                          </div>
                          <button
                            type="button"
                            className="clear-photos-btn"
                            onClick={(e) => {
                              e.stopPropagation();
                              setFormData((prev) => ({
                                ...prev,
                                referencePhotos: [],
                              }));
                            }}
                          >
                            Clear All
                          </button>
                        </div>
                      ) : (
                        <div className="upload-placeholder">
                          <div className="placeholder-icon">📤</div>
                          <div className="placeholder-text">
                            <strong>Click or drag photos here</strong>
                            <p>JPEG, PNG, max 5MB per photo</p>
                          </div>
                        </div>
                      )}

                      <input
                        id="photo-upload"
                        type="file"
                        accept="image/*"
                        multiple
                        style={{ display: "none" }}
                        onChange={(e) => handleFileUpload(e.target.files)}
                      />
                    </div>

                    {formData.referencePhotos.length > 0 && (
                      <div className="uploaded-photos">
                        <h6>Selected Photos:</h6>
                        <div className="photos-grid">
                          {formData.referencePhotos.map((photo, index) => (
                            <div key={index} className="photo-item">
                              <div className="photo-preview">
                                {photo.preview && (
                                  <img
                                    src={photo.preview}
                                    alt={`Reference ${index + 1}`}
                                  />
                                )}
                              </div>
                              <div className="photo-info">
                                <span className="photo-name">{photo.name}</span>
                                <span className="photo-size">
                                  {(photo.size / 1024 / 1024).toFixed(2)} MB
                                </span>
                              </div>
                              <button
                                type="button"
                                className="remove-photo-btn"
                                onClick={() => removePhoto(index)}
                              >
                                ✕
                              </button>
                            </div>
                          ))}
                        </div>
                      </div>
                    )}
                  </div>
                </div>

                {/* Cloud links  [ for google || Dropbox ]  */}
                <div className="upload-method-card">
                  <div className="method-header">
                    <div className="method-icon">☁️</div>
                    <div className="method-title">
                      <h5>Cloud Link (Dropbox/Google Drive)</h5>
                      <p className="method-subtitle">Share a download link</p>
                    </div>
                  </div>

                  <div className="method-content">
                    <div className="cloud-link-input">
                      <input
                        type="url"
                        placeholder="https://drive.google.com/... or https://dropbox.com/..."
                        value={formData.dropboxLink}
                        onChange={(e) =>
                          setFormData((prev) => ({
                            ...prev,
                            dropboxLink: e.target.value,
                          }))
                        }
                      />
                      <button
                        type="button"
                        className="paste-link-btn"
                        onClick={async () => {
                          try {
                            const text = await navigator.clipboard.readText();
                            setFormData((prev) => ({
                              ...prev,
                              dropboxLink: text,
                            }));
                          } catch (err) {
                            alert("Cannot access clipboard. Paste manually.");
                          }
                        }}
                      >
                        📋 Paste
                      </button>
                    </div>
                    <p className="cloud-note">
                      Make sure the link is publicly accessible
                      <strong> shadiarts.official@gmail.com</strong>
                    </p>
                  </div>
                </div>
              </div>

              <div className="form-group">
                <label>Special Instructions (Optional)</label>
                <textarea
                  name="specialInstructions"
                  value={formData.specialInstructions}
                  onChange={handleInputChange}
                  placeholder="Any specific details, emotions, or elements you want to include..."
                  rows="4"
                />
              </div>

              <div className="step-buttons">
                <button type="button" className="btn-prev" onClick={prevStep}>
                  ← Back
                </button>
                <button type="button" className="btn-next" onClick={nextStep}>
                  Next: Review & Order →
                </button>
              </div>
            </div>
          )}

          {/* Step 4 / Preview + ; Placing  Order    */}
          {step === 4 && (
            <div className="form-step animated-step">
              <h3 className="step-title">Review & Place Order</h3>

              <div className="order-summary">
                <div className="summary-header">
                  <h4>Order Summary</h4>
                  <div className="estimated-price">
                    Total:{" "}
                    <span className="price-amount">EGP {calculatePrice()}</span>
                    {formData.subjectCount > 1 && (
                      <span className="discount-badge">
                        🎉 10% Multi-Subject Discount Applied
                      </span>
                    )}
                  </div>
                </div>

                {/* Price details  (EG)  */}
                <div className="price-breakdown">
                  <div className="breakdown-item">
                    <span className="breakdown-label">Base Price:</span>
                    <span className="breakdown-value">
                      EGP{" "}
                      {
                        portraitTypes.find(
                          (t) => t.id === formData.portraitType
                        )?.basePrice
                      }
                    </span>
                  </div>

                  <div className="breakdown-item">
                    <span className="breakdown-label">
                      Size ({formData.paperSize}):
                    </span>
                    <span className="breakdown-value">
                      ×
                      {
                        paperSizes.find((s) => s.id === formData.paperSize)
                          ?.priceMultiplier
                      }
                    </span>
                  </div>

                  <div className="breakdown-item">
                    <span className="breakdown-label">Timeline:</span>
                    <span className="breakdown-value">
                      ×
                      {
                        urgencyLevels.find(
                          (u) => u.id === formData.urgencyLevel
                        )?.priceMultiplier
                      }
                    </span>
                  </div>

                  {formData.includeFrame && (
                    <div className="breakdown-item">
                      <span className="breakdown-label">
                        Professional Framing:
                      </span>
                      <span className="breakdown-value">+ EGP 500</span>
                    </div>
                  )}

                  {formData.subjectCount > 1 && (
                    <div className="breakdown-item discount">
                      <span className="breakdown-label">
                        {formData.subjectCount} Subject
                        {formData.subjectCount > 1 ? "s" : ""} Discount:
                      </span>
                      <span className="breakdown-value">-10%</span>
                    </div>
                  )}

                  <div className="breakdown-total">
                    <span className="total-label">Estimated Total:</span>
                    <span className="total-value">EGP {calculatePrice()}</span>
                  </div>
                </div>

                {/* Order Options */}
                <div className="order-options">
                  <h5>Complete Your Order</h5>

                  {/*  Watsapp Options  */}
                  <div className="order-option primary-option">
                    <div className="option-header">
                      <div className="option-icon">💬</div>
                      <div className="option-title">
                        <h6>Order via WhatsApp (Recommended)</h6>
                        <p className="option-subtitle">Fast, Direct, Secure</p>
                      </div>
                    </div>

                    <p className="option-description">
                      {formData.referencePhotos.length > 0
                        ? `✅ ${formData.referencePhotos.length} photo(s) uploaded - ready to go!`
                        : "Send order details directly to my WhatsApp. Photos can be sent in the chat."}
                    </p>

                    <button
                      type="button"
                      className="btn-whatsapp"
                      onClick={submitViaWhatsApp}
                      disabled={!formData.fullName || !formData.email}
                    >
                      💬 Order via WhatsApp
                    </button>

                    <p className="option-note">
                      {formData.referencePhotos.length > 0
                        ? "Photos already included in order"
                        : "You'll send photos after order confirmation"}
                    </p>
                  </div>
                </div>

                {/*  Policies and Insturctions  */}
                <div className="order-policies">
                  <div className="policy-item">
                    <span className="policy-icon">🛡️</span>
                    <div className="policy-content">
                      <h6>100% Satisfaction Guarantee</h6>
                      <p>
                        Unlimited revisions until you're completely satisfied.
                      </p>
                    </div>
                  </div>

                  <div className="policy-item">
                    <span className="policy-icon">⚡</span>
                    <div className="policy-content">
                      <h6>Fast Response Time</h6>
                      <p>Response within 2-4 hours on WhatsApp.</p>
                    </div>
                  </div>

                  <div className="policy-item">
                    <span className="policy-icon">🎁</span>
                    <div className="policy-content">
                      <h6>Loyalty Discount</h6>
                      <p>15% off your next order after completing this one!</p>
                    </div>
                  </div>
                </div>
              </div>

              <div className="step-buttons">
                <button type="button" className="btn-prev" onClick={prevStep}>
                  ← Modify Order
                </button>
                <button
                  type="button"
                  className="btn-save"
                  onClick={() => {
                    localStorage.setItem(
                      "shadiArtsDraftOrder",
                      JSON.stringify({
                        ...formData,
                        referencePhotos: formData.referencePhotos.map((p) => ({
                          name: p.name,
                          size: p.size,
                        })),
                      })
                    );
                    alert(
                      "✅ Order saved as draft! You can complete it later."
                    );
                  }}
                >
                  💾 Save as Draft
                </button>
              </div>
            </div>
          )}
        </form>

        {/*  Quick Order Options  */}
        <div className="quick-orders">
          <h4 className="quick-orders-title">Quick Order Options</h4>
          <p className="quick-orders-subtitle">
            Popular portrait types for fast ordering
          </p>

          <div className="quick-order-buttons">
            <button
              className="quick-order-btn"
              onClick={() => {
                setStep(1);
                setFormData((prev) => ({
                  ...prev,
                  portraitType: "single",
                  paperSize: "A4",
                  urgencyLevel: "normal",
                  subjectCount: "1",
                }));
              }}
            >
              <span className="quick-icon">👤</span>
              <span className="quick-text">Single Portrait</span>
              <span className="quick-price">EGP 1500</span>
            </button>

            <button
              className="quick-order-btn"
              onClick={() => {
                setStep(1);
                setFormData((prev) => ({
                  ...prev,
                  portraitType: "couple",
                  subjectCount: "2",
                  paperSize: "A3",
                  urgencyLevel: "normal",
                }));
              }}
            >
              <span className="quick-icon">👫</span>
              <span className="quick-text">Couple Portrait</span>
              <span className="quick-price">EGP 2500</span>
            </button>

            <button
              className="quick-order-btn"
              onClick={() => {
                setStep(1);
                setFormData((prev) => ({
                  ...prev,
                  portraitType: "family",
                  subjectCount: "4",
                  paperSize: "A2",
                  urgencyLevel: "relaxed",
                }));
              }}
            >
              <span className="quick-icon">👨‍👩‍👧‍👦</span>
              <span className="quick-text">Family Portrait</span>
              <span className="quick-price">EGP 3500</span>
            </button>
          </div>

          <div className="whatsapp-direct">
            <button
              className="whatsapp-direct-btn"
              onClick={() =>
                window.open("https://wa.me/201151638804", "_blank")
              }
            >
              <span className="whatsapp-icon">💬</span>
              <span className="whatsapp-text">
                Message directly on WhatsApp for custom requests
              </span>
              <span className="whatsapp-arrow">→</span>
            </button>
            <p className="whatsapp-note">
              For urgent orders or complex custom requests
            </p>
          </div>
        </div>

        {/* Addtional info  */}
        <div className="form-footer">
          <div className="guarantee-card">
            <div className="guarantee-icon">✅</div>
            <h5>Quality Guarantee</h5>
            <p>
              Every portrait is drawn with professional grade materials and
              techniques.
            </p>
          </div>

          <div className="process-info">
            <h5>Process Timeline</h5>
            <ul>
              <li>📝 Order confirmation within 24 hours</li>
              <li>✏️ Work begins after order confirmation</li>
              <li>📸 Progress updates provided</li>
              <li>📦 Digital preview before shipping</li>
            </ul>
          </div>
        </div>
      </div>
    </section>
  );
};

export default OrderForm;
