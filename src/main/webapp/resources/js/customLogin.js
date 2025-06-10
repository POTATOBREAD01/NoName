
const passwordInput = document.getElementById('password');
const togglePassword = document.getElementById('togglePassword');
const icon = togglePassword.querySelector('i');

togglePassword.addEventListener('click', () => {
  const isPassword = passwordInput.type === 'password';
  passwordInput.type = isPassword ? 'text' : 'password';
  icon.classList.toggle('fa-eye');
  icon.classList.toggle('fa-eye-slash');
}); 