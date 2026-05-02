document.addEventListener('DOMContentLoaded', () => {
  const loginForm = document.getElementById('login-form');
  const studentForm = document.getElementById('student-form');
  const refreshButton = document.getElementById('refresh-students');
  const logoutButton = document.getElementById('logout-button');
  const statusLogin = document.getElementById('login-status');
  const statusStudent = document.getElementById('student-status');
  const studentSection = document.getElementById('student-management');
  const studentTableBody = document.querySelector('#students-table tbody');

  function showMessage(container, message, type = 'neutral') {
    container.textContent = message;
    container.className = `status-message ${type}`;
  }

  function setStudentPanel(visible) {
    studentSection.classList.toggle('hidden', !visible);
  }

  async function fetchStudents() {
    try {
      const response = await fetch('/students', { credentials: 'same-origin' });
      const data = await response.json();
      if (!response.ok) {
        throw new Error(data.error || 'Unable to load students');
      }

      if (Array.isArray(data) && data.length) {
        studentTableBody.innerHTML = data.map(student => `
          <tr>
            <td>${student.StudentID}</td>
            <td>${student.Name}</td>
            <td>${student.DepartmentID}</td>
            <td>${student.EnrollmentYear}</td>
          </tr>
        `).join('');
      } else {
        studentTableBody.innerHTML = '<tr><td colspan="4" class="empty-row">No students found.</td></tr>';
      }
    } catch (error) {
      studentTableBody.innerHTML = `<tr><td colspan="4" class="empty-row">${error.message}</td></tr>`;
      setStudentPanel(false);
      showMessage(statusLogin, error.message, 'error');
    }
  }

  loginForm?.addEventListener('submit', async event => {
    event.preventDefault();
    showMessage(statusLogin, 'Signing in…', 'neutral');

    const formData = new FormData(loginForm);
    const body = {
      ProfessorID: formData.get('ProfessorID'),
      Email: formData.get('Email')
    };

    try {
      const response = await fetch('/login', {
        method: 'POST',
        credentials: 'same-origin',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
      });
      const data = await response.json();
      if (!response.ok) {
        throw new Error(data.error || 'Login failed');
      }
      showMessage(statusLogin, 'Signed in successfully.', 'success');
      setStudentPanel(true);
      await fetchStudents();
    } catch (error) {
      showMessage(statusLogin, error.message, 'error');
    }
  });

  studentForm?.addEventListener('submit', async event => {
    event.preventDefault();
    showMessage(statusStudent, 'Saving student…', 'neutral');

    const formData = new FormData(studentForm);
    const body = {
      StudentID: formData.get('StudentID'),
      Name: formData.get('Name'),
      DepartmentID: formData.get('DepartmentID'),
      EnrollmentYear: formData.get('EnrollmentYear')
    };

    try {
      const response = await fetch('/students', {
        method: 'POST',
        credentials: 'same-origin',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
      });
      const data = await response.json();
      if (!response.ok) {
        throw new Error(data.error || 'Could not create student');
      }
      showMessage(statusStudent, 'Student created successfully.', 'success');
      studentForm.reset();
      await fetchStudents();
    } catch (error) {
      showMessage(statusStudent, error.message, 'error');
    }
  });

  refreshButton?.addEventListener('click', async () => {
    showMessage(statusLogin, 'Refreshing student list…', 'neutral');
    await fetchStudents();
    showMessage(statusLogin, 'Student list refreshed.', 'success');
  });

  logoutButton?.addEventListener('click', async () => {
    await fetch('/logout', { method: 'POST', credentials: 'same-origin' });
    setStudentPanel(false);
    studentTableBody.innerHTML = '<tr><td colspan="4" class="empty-row">Sign in to view students.</td></tr>';
    showMessage(statusLogin, 'Logged out successfully.', 'neutral');
  });
});
