// Time App Engine Logic
document.addEventListener('DOMContentLoaded', () => {
    // State Persistence
    let is24Hour = localStorage.getItem('time_is24h') === 'true';
    let showSeconds = localStorage.getItem('time_show_seconds') !== 'false';
    let keepScreenOn = localStorage.getItem('time_wakelock') !== 'false';
    let currentFont = localStorage.getItem('time_font') || 'font-orbitron';
    let currentTheme = localStorage.getItem('time_theme') || 'theme-cyber-neon';
    let isNightMode = false;

    // DOM Elements
    const hoursEl = document.getElementById('clock-hours');
    const minutesEl = document.getElementById('clock-minutes');
    const secondsEl = document.getElementById('clock-seconds');
    const colonSecondsEl = document.getElementById('colon-seconds');
    const ampmEl = document.getElementById('clock-ampm');
    const dateEl = document.getElementById('date-display');
    const batteryEl = document.getElementById('battery-display');
    const timezoneEl = document.getElementById('timezone-display');
    const clockContainer = document.getElementById('clock-container');
    const controlPanel = document.getElementById('control-panel');
    const closePanelBtn = document.getElementById('close-panel-btn');
    const nightModeBtn = document.getElementById('night-mode-btn');

    // Toggles
    const toggle24h = document.getElementById('toggle-24h');
    const toggleSeconds = document.getElementById('toggle-seconds');
    const toggleWakelock = document.getElementById('toggle-wakelock');

    // Initialize UI State
    document.body.className = `${currentTheme} ${currentFont}`;
    if (toggle24h) toggle24h.checked = is24Hour;
    if (toggleSeconds) toggleSeconds.checked = showSeconds;
    if (toggleWakelock) toggleWakelock.checked = keepScreenOn;

    updateFontChips();
    updateThemeChips();

    // Haptics Trigger
    function triggerHaptics() {
        if (window.AndroidTimeBridge && window.AndroidTimeBridge.vibrate) {
            window.AndroidTimeBridge.vibrate();
        }
    }

    // High Precision Clock Update Engine
    function updateClock() {
        const now = new Date();

        // Hours & AM/PM
        let hours = now.getHours();
        let ampm = '';

        if (!is24Hour) {
            ampm = hours >= 12 ? 'PM' : 'AM';
            hours = hours % 12;
            hours = hours ? hours : 12; // 0 becomes 12
        }

        const hoursStr = String(hours).padStart(2, '0');
        const minutesStr = String(now.getMinutes()).padStart(2, '0');
        const secondsStr = String(now.getSeconds()).padStart(2, '0');

        if (hoursEl) hoursEl.textContent = hoursStr;
        if (minutesEl) minutesEl.textContent = minutesStr;
        if (secondsEl) secondsEl.textContent = secondsStr;

        if (ampmEl) {
            if (is24Hour) {
                ampmEl.style.display = 'none';
            } else {
                ampmEl.style.display = 'block';
                ampmEl.textContent = ampm;
            }
        }

        // Seconds Visibility
        if (secondsEl && colonSecondsEl) {
            if (showSeconds) {
                secondsEl.style.display = 'inline-block';
                colonSecondsEl.style.display = 'inline-block';
            } else {
                secondsEl.style.display = 'none';
                colonSecondsEl.style.display = 'none';
            }
        }

        // Date Display
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        if (dateEl) dateEl.textContent = now.toLocaleDateString('en-US', options).toUpperCase();

        // Timezone
        if (timezoneEl) {
            const timeZoneName = Intl.DateTimeFormat().resolvedOptions().timeZone;
            timezoneEl.textContent = `${timeZoneName.toUpperCase()} • REAL-TIME CLOCK`;
        }
    }

    setInterval(updateClock, 200);
    updateClock();

    // Battery API Telemetry
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
        }).catch(() => {
            if (batteryEl) batteryEl.style.display = 'none';
        });
    }

    // Font Selection
    document.querySelectorAll('.font-chip').forEach(btn => {
        btn.addEventListener('click', () => {
            triggerHaptics();
            currentFont = btn.dataset.font;
            localStorage.setItem('time_font', currentFont);
            document.body.className = `${currentTheme} ${currentFont}`;
            updateFontChips();
        });
    });

    function updateFontChips() {
        document.querySelectorAll('.font-chip').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.font === currentFont);
        });
    }

    // Theme Selection
    document.querySelectorAll('.theme-chip').forEach(btn => {
        btn.addEventListener('click', () => {
            triggerHaptics();
            currentTheme = btn.dataset.theme;
            localStorage.setItem('time_theme', currentTheme);
            document.body.className = `${currentTheme} ${currentFont}`;
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
            updateClock();
        });
    }

    if (toggleSeconds) {
        toggleSeconds.addEventListener('change', (e) => {
            triggerHaptics();
            showSeconds = e.target.checked;
            localStorage.setItem('time_show_seconds', showSeconds);
            updateClock();
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
        if (e.target.closest('#night-mode-btn') || e.target.closest('#control-panel')) return;
        controlPanel.classList.toggle('active');
        triggerHaptics();
    });

    if (closePanelBtn) {
        closePanelBtn.addEventListener('click', () => {
            controlPanel.classList.remove('active');
            triggerHaptics();
        });
    }
});
