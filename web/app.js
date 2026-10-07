// Time v2.0 Ultimate Clock Engine Logic
document.addEventListener('DOMContentLoaded', () => {
    // State Persistence
    let is24Hour = localStorage.getItem('time_is24h') === 'true';
    let showSeconds = localStorage.getItem('time_show_seconds') !== 'false';
    let showParticles = localStorage.getItem('time_particles') !== 'false';
    let keepScreenOn = localStorage.getItem('time_wakelock') !== 'false';
    let currentFont = localStorage.getItem('time_font') || 'font-orbitron';
    let currentTheme = localStorage.getItem('time_theme') || 'theme-cyber-neon';
    let currentMode = localStorage.getItem('time_mode') || 'layout-digital';
    let isNightMode = false;
    let isSoundOn = false;

    // Sliders
    let glowValue = localStorage.getItem('time_glow') || 70;
    let sizeValue = localStorage.getItem('time_size') || 100;

    // DOM Elements
    const hoursEl = document.getElementById('clock-hours');
    const minutesEl = document.getElementById('clock-minutes');
    const secondsEl = document.getElementById('clock-seconds');
    const colonSecondsEl = document.getElementById('colon-seconds');
    const ampmEl = document.getElementById('clock-ampm');
    const dateEl = document.getElementById('date-display');
    const batteryEl = document.getElementById('battery-display');
    const timezoneEl = document.getElementById('timezone-display');

    // Clock Views
    const digitalView = document.getElementById('digital-clock-view');
    const analogView = document.getElementById('analog-clock-view');
    const wordView = document.getElementById('word-clock-view');

    // Analog Hands
    const hourHand = document.getElementById('analog-hour-hand');
    const minuteHand = document.getElementById('analog-minute-hand');
    const secondHand = document.getElementById('analog-second-hand');
    const wordText = document.getElementById('word-clock-text');

    // Drawers & Modals
    const clockContainer = document.getElementById('clock-container');
    const controlPanel = document.getElementById('control-panel');
    const closePanelBtn = document.getElementById('close-panel-btn');
    const nightModeBtn = document.getElementById('night-mode-btn');
    const soundTickBtn = document.getElementById('sound-tick-btn');

    // Sliders & Toggles
    const glowSlider = document.getElementById('glow-slider');
    const sizeSlider = document.getElementById('size-slider');
    const toggle24h = document.getElementById('toggle-24h');
    const toggleSeconds = document.getElementById('toggle-seconds');
    const toggleParticles = document.getElementById('toggle-particles');
    const toggleWakelock = document.getElementById('toggle-wakelock');

    // Initialize UI State
    document.body.className = `${currentTheme} ${currentFont} ${currentMode}`;
    if (toggle24h) toggle24h.checked = is24Hour;
    if (toggleSeconds) toggleSeconds.checked = showSeconds;
    if (toggleParticles) toggleParticles.checked = showParticles;
    if (toggleWakelock) toggleWakelock.checked = keepScreenOn;
    if (glowSlider) glowSlider.value = glowValue;
    if (sizeSlider) sizeSlider.value = sizeValue;

    applySliders();
    updateModeView();
    updateFontChips();
    updateThemeChips();
    updateModeChips();

    // Haptics Trigger
    function triggerHaptics() {
        if (window.AndroidTimeBridge && window.AndroidTimeBridge.vibrate) {
            window.AndroidTimeBridge.vibrate();
        }
    }

    // Apply Sliders
    function applySliders() {
        document.documentElement.style.setProperty('--glow-radius', `${glowValue / 2}px`);
        document.documentElement.style.setProperty('--font-scale', `${sizeValue / 100}`);
    }

    if (glowSlider) {
        glowSlider.addEventListener('input', (e) => {
            glowValue = e.target.value;
            localStorage.setItem('time_glow', glowValue);
            applySliders();
        });
    }

    if (sizeSlider) {
        sizeSlider.addEventListener('input', (e) => {
            sizeValue = e.target.value;
            localStorage.setItem('time_size', sizeValue);
            applySliders();
        });
    }

    // Synthesized Audio Tick
    let audioCtx = null;
    function playTickSound() {
        if (!isSoundOn) return;
        try {
            if (!audioCtx) audioCtx = new (window.AudioContext || window.webkitAudioContext)();
            const osc = audioCtx.createOscillator();
            const gain = audioCtx.createGain();
            osc.type = 'sine';
            osc.frequency.setValueAtTime(800, audioCtx.currentTime);
            gain.gain.setValueAtTime(0.05, audioCtx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.03);
            osc.connect(gain);
            gain.connect(audioCtx.destination);
            osc.start();
            osc.stop(audioCtx.currentTime + 0.03);
        } catch (e) {}
    }

    if (soundTickBtn) {
        soundTickBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            triggerHaptics();
            isSoundOn = !isSoundOn;
            soundTickBtn.textContent = isSoundOn ? '🔊' : '🔇';
        });
    }

    // Word Clock Generator
    const numberWords = ["ZERO", "ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "TEN", "ELEVEN", "TWELVE", "THIRTEEN", "FOURTEEN", "FIFTEEN", "SIXTEEN", "SEVENTEEN", "EIGHTEEN", "NINETEEN", "TWENTY", "TWENTY-ONE", "TWENTY-TWO", "TWENTY-THREE", "TWENTY-FOUR", "TWENTY-FIVE", "TWENTY-SIX", "TWENTY-SEVEN", "TWENTY-EIGHT", "TWENTY-NINE", "THIRTY", "THIRTY-ONE", "THIRTY-TWO", "THIRTY-THREE", "THIRTY-FOUR", "THIRTY-FIVE", "THIRTY-SIX", "THIRTY-SEVEN", "THIRTY-EIGHT", "THIRTY-NINE", "FORTY", "FORTY-ONE", "FORTY-TWO", "FORTY-THREE", "FORTY-FOUR", "FORTY-FIVE", "FORTY-SIX", "FORTY-SEVEN", "FORTY-EIGHT", "FORTY-NINE", "FIFTY", "FIFTY-ONE", "FIFTY-TWO", "FIFTY-THREE", "FIFTY-FOUR", "FIFTY-FIVE", "FIFTY-SIX", "FIFTY-SEVEN", "FIFTY-EIGHT", "FIFTY-NINE"];

    function getWordTime(hours, minutes, is24) {
        let hWord = "";
        let mWord = "";
        let ampmStr = "";

        if (!is24) {
            ampmStr = hours >= 12 ? " PM" : " AM";
            let h12 = hours % 12;
            h12 = h12 ? h12 : 12;
            hWord = numberWords[h12];
        } else {
            hWord = numberWords[hours];
        }

        if (minutes === 0) {
            mWord = "O'CLOCK";
        } else {
            mWord = numberWords[minutes];
        }

        return `IT IS ${hWord} ${mWord}${ampmStr}`;
    }

    // High Precision Clock Update Loop
    let lastSecond = -1;
    function updateClock() {
        const now = new Date();
        const curSecond = now.getSeconds();

        if (curSecond !== lastSecond) {
            playTickSound();
            lastSecond = curSecond;
        }

        // 1. Digital Clock
        let hours = now.getHours();
        let ampm = '';

        if (!is24Hour) {
            ampm = hours >= 12 ? 'PM' : 'AM';
            hours = hours % 12;
            hours = hours ? hours : 12;
        }

        if (hoursEl) hoursEl.textContent = String(hours).padStart(2, '0');
        if (minutesEl) minutesEl.textContent = String(now.getMinutes()).padStart(2, '0');
        if (secondsEl) secondsEl.textContent = String(curSecond).padStart(2, '0');

        if (ampmEl) {
            if (is24Hour) {
                ampmEl.style.display = 'none';
            } else {
                ampmEl.style.display = 'block';
                ampmEl.textContent = ampm;
            }
        }

        if (secondsEl && colonSecondsEl) {
            secondsEl.style.display = showSeconds ? 'inline-block' : 'none';
            colonSecondsEl.style.display = showSeconds ? 'inline-block' : 'none';
        }

        // 2. Analog Clock
        if (currentMode === 'layout-analog') {
            const h = now.getHours() % 12;
            const m = now.getMinutes();
            const s = curSecond + now.getMilliseconds() / 1000;

            const hDeg = (h * 30) + (m * 0.5);
            const mDeg = (m * 6) + (s * 0.1);
            const sDeg = s * 6;

            if (hourHand) hourHand.style.transform = `translateX(-50%) rotate(${hDeg}deg)`;
            if (minuteHand) minuteHand.style.transform = `translateX(-50%) rotate(${mDeg}deg)`;
            if (secondHand) secondHand.style.transform = `translateX(-50%) rotate(${sDeg}deg)`;
        }

        // 3. Word Clock
        if (currentMode === 'layout-word' && wordText) {
            wordText.textContent = getWordTime(now.getHours(), now.getMinutes(), is24Hour);
        }

        // Date Display
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        if (dateEl) dateEl.textContent = now.toLocaleDateString('en-US', options).toUpperCase();

        // Timezone
        if (timezoneEl) {
            const timeZoneName = Intl.DateTimeFormat().resolvedOptions().timeZone;
            timezoneEl.textContent = `${timeZoneName.toUpperCase()} • REAL-TIME CLOCK`;
        }

        requestAnimationFrame(updateClock);
    }

    requestAnimationFrame(updateClock);

    // Battery Telemetry
    if (navigator.getBattery) {
        navigator.getBattery().then(battery => {
            function updateBattery() {
                const level = Math.round(battery.level * 100);
                const charging = battery.charging ? '⚡ ' : '🔋 ';
                if (batteryEl) batteryEl.textContent = `${charging}${level}%`;
            }
            updateBattery();
            battery.addEventListener('levelchange', updateBattery);
            battery.addEventListener('chargingchange', updateBattery);
        }).catch(() => {});
    }

    // Mode Selector
    document.querySelectorAll('.mode-chip').forEach(btn => {
        btn.addEventListener('click', () => {
            triggerHaptics();
            currentMode = btn.dataset.mode;
            localStorage.setItem('time_mode', currentMode);
            document.body.className = `${currentTheme} ${currentFont} ${currentMode}`;
            updateModeChips();
            updateModeView();
        });
    });

    function updateModeChips() {
        document.querySelectorAll('.mode-chip').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.mode === currentMode);
        });
    }

    function updateModeView() {
        if (digitalView) digitalView.style.display = currentMode === 'layout-digital' ? 'flex' : 'none';
        if (analogView) analogView.style.display = currentMode === 'layout-analog' ? 'flex' : 'none';
        if (wordView) wordView.style.display = currentMode === 'layout-word' ? 'flex' : 'none';
    }

    // Font Selector
    document.querySelectorAll('.font-chip').forEach(btn => {
        btn.addEventListener('click', () => {
            triggerHaptics();
            currentFont = btn.dataset.font;
            localStorage.setItem('time_font', currentFont);
            document.body.className = `${currentTheme} ${currentFont} ${currentMode}`;
            updateFontChips();
        });
    });

    function updateFontChips() {
        document.querySelectorAll('.font-chip').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.font === currentFont);
        });
    }

    // Theme Selector
    document.querySelectorAll('.theme-chip').forEach(btn => {
        btn.addEventListener('click', () => {
            triggerHaptics();
            currentTheme = btn.dataset.theme;
            localStorage.setItem('time_theme', currentTheme);
            document.body.className = `${currentTheme} ${currentFont} ${currentMode}`;
            updateThemeChips();
        });
    });

    function updateThemeChips() {
        document.querySelectorAll('.theme-chip').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.theme === currentTheme);
        });
    }

    // Toggles logic
    if (toggle24h) {
        toggle24h.addEventListener('change', (e) => {
            triggerHaptics();
            is24Hour = e.target.checked;
            localStorage.setItem('time_is24h', is24Hour);
        });
    }

    if (toggleSeconds) {
        toggleSeconds.addEventListener('change', (e) => {
            triggerHaptics();
            showSeconds = e.target.checked;
            localStorage.setItem('time_show_seconds', showSeconds);
        });
    }

    if (toggleParticles) {
        toggleParticles.addEventListener('change', (e) => {
            triggerHaptics();
            showParticles = e.target.checked;
            localStorage.setItem('time_particles', showParticles);
            const canvas = document.getElementById('particles-canvas');
            if (canvas) canvas.style.display = showParticles ? 'block' : 'none';
        });
    }

    if (toggleWakelock) {
        toggleWakelock.addEventListener('change', (e) => {
            triggerHaptics();
            keepScreenOn = e.target.checked;
            localStorage.setItem('time_wakelock', keepScreenOn);
            if (window.AndroidTimeBridge && window.AndroidTimeBridge.setKeepScreenOn) {
                window.AndroidTimeBridge.setKeepScreenOn(keepScreenOn);
            }
        });
    }

    // Night Dim Mode
    if (nightModeBtn) {
        nightModeBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            triggerHaptics();
            isNightMode = !isNightMode;
            document.body.classList.toggle('night-mode', isNightMode);
        });
    }

    // Control Drawer Open / Close Logic
    clockContainer.addEventListener('click', (e) => {
        if (e.target.closest('#night-mode-btn') || e.target.closest('#sound-tick-btn') || e.target.closest('#control-panel')) return;
        controlPanel.classList.toggle('active');
        triggerHaptics();
    });

    if (closePanelBtn) {
        closePanelBtn.addEventListener('click', () => {
            controlPanel.classList.remove('active');
            triggerHaptics();
        });
    }

    // Particles Canvas Background Engine
    const canvas = document.getElementById('particles-canvas');
    if (canvas) {
        const ctx = canvas.getContext('2d');
        let particles = [];

        function resizeCanvas() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        }

        window.addEventListener('resize', resizeCanvas);
        resizeCanvas();

        for (let i = 0; i < 40; i++) {
            particles.push({
                x: Math.random() * canvas.width,
                y: Math.random() * canvas.height,
                radius: Math.random() * 2 + 0.5,
                alpha: Math.random() * 0.5 + 0.2,
                speedY: Math.random() * 0.4 + 0.1
            });
        }

        function drawParticles() {
            if (!showParticles) return;
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.fillStyle = 'rgba(255, 255, 255, 0.4)';

            particles.forEach(p => {
                ctx.beginPath();
                ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
                ctx.fillStyle = `rgba(255, 255, 255, ${p.alpha})`;
                ctx.fill();

                p.y -= p.speedY;
                if (p.y < 0) {
                    p.y = canvas.height;
                    p.x = Math.random() * canvas.width;
                }
            });

            requestAnimationFrame(drawParticles);
        }

        drawParticles();
    }
});
