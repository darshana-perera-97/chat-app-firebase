// Chat App Main JavaScript File

// DOM Elements
const authContainer = document.getElementById('auth-container');
const chatContainer = document.getElementById('chat-container');
const loginForm = document.getElementById('login-form');
const signupForm = document.getElementById('signup-form');
const showSignupLink = document.getElementById('show-signup');
const showLoginLink = document.getElementById('show-login');
const logoutBtn = document.getElementById('logout-btn');
const messageForm = document.getElementById('message-form');
const messageInput = document.getElementById('message-input');
const chatMessages = document.getElementById('chat-messages');
const userName = document.getElementById('user-name');
const userAvatar = document.getElementById('user-avatar');
const loading = document.getElementById('loading');

// Global variables
let currentUser = null;
let unsubscribeMessages = null;

// Event Listeners
document.addEventListener('DOMContentLoaded', () => {
    setupEventListeners();
    checkAuthState();
});

function setupEventListeners() {
    // Auth form submissions
    loginForm.addEventListener('submit', handleLogin);
    signupForm.addEventListener('submit', handleSignup);
    
    // Form switching
    showSignupLink.addEventListener('click', (e) => {
        e.preventDefault();
        switchToSignup();
    });
    
    showLoginLink.addEventListener('click', (e) => {
        e.preventDefault();
        switchToLogin();
    });
    
    // Chat functionality
    logoutBtn.addEventListener('click', handleLogout);
    messageForm.addEventListener('submit', handleSendMessage);
}

// Authentication Functions
async function handleLogin(e) {
    e.preventDefault();
    showLoading(true);
    
    const email = document.getElementById('login-email').value;
    const password = document.getElementById('login-password').value;
    
    try {
        await auth.signInWithEmailAndPassword(email, password);
        showLoading(false);
    } catch (error) {
        showLoading(false);
        showError('Login failed: ' + error.message);
    }
}

async function handleSignup(e) {
    e.preventDefault();
    showLoading(true);
    
    const name = document.getElementById('signup-name').value;
    const email = document.getElementById('signup-email').value;
    const password = document.getElementById('signup-password').value;
    
    try {
        const userCredential = await auth.createUserWithEmailAndPassword(email, password);
        const user = userCredential.user;
        
        // Update user profile with display name
        await user.updateProfile({
            displayName: name
        });
        
        // Create user document in Firestore
        await db.collection('users').doc(user.uid).set({
            name: name,
            email: email,
            createdAt: firebase.firestore.FieldValue.serverTimestamp()
        });
        
        showLoading(false);
    } catch (error) {
        showLoading(false);
        showError('Signup failed: ' + error.message);
    }
}

async function handleLogout() {
    try {
        if (unsubscribeMessages) {
            unsubscribeMessages();
        }
        await auth.signOut();
    } catch (error) {
        showError('Logout failed: ' + error.message);
    }
}

// Auth State Observer
function checkAuthState() {
    auth.onAuthStateChanged(async (user) => {
        if (user) {
            currentUser = user;
            await loadUserData();
            showChat();
            setupRealTimeMessages();
        } else {
            currentUser = null;
            showAuth();
        }
    });
}

// UI Functions
function switchToSignup() {
    loginForm.classList.add('hidden');
    signupForm.classList.remove('hidden');
}

function switchToLogin() {
    signupForm.classList.add('hidden');
    loginForm.classList.remove('hidden');
}

function showAuth() {
    authContainer.classList.remove('hidden');
    chatContainer.classList.add('hidden');
}

function showChat() {
    authContainer.classList.add('hidden');
    chatContainer.classList.remove('hidden');
}

function showLoading(show) {
    if (show) {
        loading.classList.remove('hidden');
    } else {
        loading.classList.add('hidden');
    }
}

function showError(message) {
    alert(message); // Simple error display - you can enhance this with a better UI
}

// User Data Functions
async function loadUserData() {
    try {
        const userDoc = await db.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists) {
            const userData = userDoc.data();
            userName.textContent = userData.name || currentUser.displayName || 'User';
            
            // Generate avatar from user's name
            const initials = (userData.name || currentUser.displayName || 'U')
                .split(' ')
                .map(n => n[0])
                .join('')
                .toUpperCase();
            
            userAvatar.src = `https://ui-avatars.com/api/?name=${encodeURIComponent(userData.name || currentUser.displayName || 'User')}&background=667eea&color=fff&size=40`;
        }
    } catch (error) {
        console.error('Error loading user data:', error);
    }
}

// Chat Functions
function setupRealTimeMessages() {
    unsubscribeMessages = db.collection('messages')
        .orderBy('timestamp', 'asc')
        .onSnapshot((snapshot) => {
            snapshot.docChanges().forEach((change) => {
                if (change.type === 'added') {
                    displayMessage(change.doc.data());
                }
            });
            
            // Scroll to bottom
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }, (error) => {
            console.error('Error listening to messages:', error);
        });
}

async function handleSendMessage(e) {
    e.preventDefault();
    
    const messageText = messageInput.value.trim();
    if (!messageText) return;
    
    try {
        const messageData = {
            text: messageText,
            userId: currentUser.uid,
            userName: currentUser.displayName || 'Anonymous',
            timestamp: firebase.firestore.FieldValue.serverTimestamp()
        };
        
        await db.collection('messages').add(messageData);
        messageInput.value = '';
    } catch (error) {
        showError('Failed to send message: ' + error.message);
    }
}

function displayMessage(messageData) {
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${messageData.userId === currentUser.uid ? 'own' : ''}`;
    
    const avatar = document.createElement('img');
    avatar.className = 'message-avatar';
    avatar.src = `https://ui-avatars.com/api/?name=${encodeURIComponent(messageData.userName)}&background=667eea&color=fff&size=35`;
    avatar.alt = messageData.userName;
    
    const content = document.createElement('div');
    content.className = 'message-content';
    
    const info = document.createElement('div');
    info.className = 'message-info';
    
    const name = document.createElement('span');
    name.textContent = messageData.userName;
    
    const time = document.createElement('span');
    time.textContent = messageData.timestamp ? formatTime(messageData.timestamp.toDate()) : 'Just now';
    
    info.appendChild(name);
    info.appendChild(time);
    
    const text = document.createElement('div');
    text.className = 'message-text';
    text.textContent = messageData.text;
    
    content.appendChild(info);
    content.appendChild(text);
    
    messageDiv.appendChild(avatar);
    messageDiv.appendChild(content);
    
    chatMessages.appendChild(messageDiv);
}

function formatTime(date) {
    const now = new Date();
    const diff = now - date;
    const minutes = Math.floor(diff / 60000);
    const hours = Math.floor(diff / 3600000);
    const days = Math.floor(diff / 86400000);
    
    if (minutes < 1) return 'Just now';
    if (minutes < 60) return `${minutes}m ago`;
    if (hours < 24) return `${hours}h ago`;
    if (days < 7) return `${days}d ago`;
    
    return date.toLocaleDateString();
}

// Utility Functions
function generateAvatarUrl(name, size = 40) {
    return `https://ui-avatars.com/api/?name=${encodeURIComponent(name)}&background=667eea&color=fff&size=${size}`;
}

// Error handling
window.addEventListener('error', (e) => {
    console.error('Global error:', e.error);
    showError('An unexpected error occurred. Please refresh the page.');
});

// Network status handling
window.addEventListener('online', () => {
    console.log('App is online');
});

window.addEventListener('offline', () => {
    console.log('App is offline');
    showError('You are offline. Messages will be sent when you reconnect.');
});
