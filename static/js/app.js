document.addEventListener('DOMContentLoaded', () => {
  // Elements
  const loginForm = document.getElementById('login-form');
  const searchBtn = document.getElementById('search-btn');
  const searchInput = document.getElementById('student-search-input');
  const searchResults = document.getElementById('search-results');
  const navLogout = document.getElementById('nav-logout');

  // Dashboard Elements
  const enrollForm = document.getElementById('enroll-form');
  const courseForm = document.getElementById('course-form');
  const gradesTableBody = document.querySelector('#grades-table tbody');
  const myCoursesTableBody = document.querySelector('#my-courses-table tbody');
  const studentSelect = document.getElementById('enroll-student-select');
  const courseSelect = document.getElementById('enroll-course-select');

  // Modal Elements
  const editModal = document.getElementById('edit-modal');
  const editForm = document.getElementById('edit-grade-form');
  const closeModal = document.querySelector('.close-modal');
  const editStatus = document.getElementById('edit-status');

  // Status containers
  const statusLogin = document.getElementById('login-status');
  const statusEnroll = document.getElementById('enroll-status');
  const statusCourse = document.getElementById('course-status');

  function showMessage(container, message, type = 'neutral') {
    if (!container) return;
    container.textContent = message;
    container.className = `status-message ${type}`;
  }

  // --- Student Search (Home Page) ---
  const handleSearch = async () => {
    const name = searchInput.value.trim();
    if (!name) return;

    searchResults.innerHTML = '<p class="status-message neutral">Searching...</p>';
    searchResults.classList.remove('hidden');

    try {
      const response = await fetch(`/student/search?name=${encodeURIComponent(name)}`);
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || data.error || 'Search failed');
      }

      searchResults.innerHTML = `
        <div class="app-panel">
          <h3>Results for "${name}"</h3>
          <div class="table-wrap">
            <table class="data-table">
              <thead>
                <tr>
                  <th>Course</th>
                  <th>Score</th>
                  <th>Grade</th>
                </tr>
              </thead>
              <tbody>
                ${data.map(item => `
                  <tr>
                    <td>${item.CourseName}</td>
                    <td>${item.NumericScore ?? 'N/A'}</td>
                    <td>${item.LetterGrade ?? 'N/A'}</td>
                  </tr>
                `).join('')}
              </tbody>
            </table>
          </div>
        </div>
      `;
    } catch (error) {
      searchResults.innerHTML = `<p class="status-message error">${error.message}</p>`;
    }
  };

  searchBtn?.addEventListener('click', handleSearch);
  searchInput?.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') handleSearch();
  });

  // --- Login ---
  loginForm?.addEventListener('submit', async event => {
    event.preventDefault();
    const formData = new FormData(loginForm);
    const body = {
      ProfessorID: formData.get('ProfessorID'),
      Email: formData.get('Email')
    };

    try {
      const response = await fetch('/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.error || 'Login failed');
      
      window.location.reload();
    } catch (error) {
      showMessage(statusLogin, error.message, 'error');
    }
  });

  // --- Dashboard Logic ---
  if (document.getElementById('dashboard')) {
    fetchDashboardData();
    populateEnrollmentDropdowns();

    enrollForm?.addEventListener('submit', async e => {
      e.preventDefault();
      const formData = new FormData(enrollForm);
      const body = { StudentID: formData.get('StudentID'), CourseID: formData.get('CourseID') };
      
      try {
        const res = await fetch('/enroll', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(body)
        });
        const data = await res.json();
        if (!res.ok) throw new Error(data.error);
        showMessage(statusEnroll, 'Student enrolled successfully!', 'success');
        enrollForm.reset();
        fetchDashboardData();
      } catch (err) {
        showMessage(statusEnroll, err.message, 'error');
      }
    });

    courseForm?.addEventListener('submit', async e => {
      e.preventDefault();
      const formData = new FormData(courseForm);
      const body = {
        CourseID: formData.get('CourseID'),
        CourseName: formData.get('CourseName'),
        Credits: formData.get('Credits')
      };
      
      try {
        const res = await fetch('/courses', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(body)
        });
        const data = await res.json();
        if (!res.ok) throw new Error(data.error);
        showMessage(statusCourse, 'Course created successfully!', 'success');
        courseForm.reset();
        fetchDashboardData();
        populateEnrollmentDropdowns();
      } catch (err) {
        showMessage(statusCourse, err.message, 'error');
      }
    });

    // Modal Events
    closeModal?.addEventListener('click', () => editModal.style.display = 'none');
    window.onclick = (event) => {
      if (event.target == editModal) editModal.style.display = 'none';
    };

    editForm?.addEventListener('submit', async e => {
      e.preventDefault();
      const formData = new FormData(editForm);
      const gradeId = formData.get('GradeID');
      const body = {
        NumericScore: formData.get('NumericScore'),
        LetterGrade: formData.get('LetterGrade')
      };

      try {
        const res = await fetch(`/grades/${gradeId}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(body)
        });
        if (!res.ok) throw new Error('Update failed');
        
        editModal.style.display = 'none';
        fetchDashboardData();
      } catch (err) {
        showMessage(editStatus, err.message, 'error');
      }
    });
  }

  async function populateEnrollmentDropdowns() {
    try {
      const sRes = await fetch('/students');
      const students = await sRes.json();
      if (studentSelect) {
        studentSelect.innerHTML = '<option value="">-- Select Student --</option>' + 
          students.map(s => `<option value="${s.StudentID}">${s.Name} (${s.StudentID})</option>`).join('');
      }

      const cRes = await fetch('/courses');
      const courses = await cRes.json();
      if (courseSelect) {
        courseSelect.innerHTML = '<option value="">-- Select Course --</option>' + 
          courses.map(c => `<option value="${c.CourseID}">${c.CourseName} (${c.CourseID})</option>`).join('');
      }
    } catch (err) {
      console.error('Error populating dropdowns:', err);
    }
  }

  async function fetchDashboardData() {
    try {
      const gRes = await fetch('/professor/grades');
      const grades = await gRes.json();
      if (gradesTableBody) {
        gradesTableBody.innerHTML = grades.map(g => `
          <tr>
            <td><code>${g.StudentID}</code></td>
            <td>${g.StudentName}</td>
            <td>${g.CourseName}</td>
            <td>${g.NumericScore ?? 'N/A'}</td>
            <td>${g.LetterGrade ?? 'N/A'}</td>
            <td style="display: flex; gap: 0.5rem;">
              <button class="button button-secondary" onclick="openEditModal('${g.GradeID}', '${g.StudentName}', '${g.CourseName}', '${g.NumericScore || ''}', '${g.LetterGrade || ''}')">Edit</button>
              <button class="button button-danger" onclick="deleteGrade('${g.GradeID}')">Remove</button>
            </td>
          </tr>
        `).join('') || '<tr><td colspan="6" class="empty-row">No students enrolled in your courses.</td></tr>';
      }

      const cRes = await fetch('/professor/courses');
      const courses = await cRes.json();
      if (myCoursesTableBody) {
        myCoursesTableBody.innerHTML = courses.map(c => `
          <tr>
            <td><code>${c.CourseID}</code></td>
            <td>${c.CourseName}</td>
            <td>${c.Credits}</td>
          </tr>
        `).join('') || '<tr><td colspan="3" class="empty-row">You haven\'t created any courses yet.</td></tr>';
      }
    } catch (err) {
      console.error('Error fetching dashboard data:', err);
    }
  }

  window.openEditModal = (gradeId, studentName, courseName, score, letter) => {
    document.getElementById('edit-grade-id').value = gradeId;
    document.getElementById('edit-student-name').textContent = studentName;
    document.getElementById('edit-course-name').textContent = courseName;
    document.getElementById('edit-numeric-score').value = score;
    document.getElementById('edit-letter-grade').value = letter;
    editModal.style.display = 'block';
  };

  window.deleteGrade = async (gradeId) => {
    if (!confirm('Are you sure you want to remove this enrollment?')) return;
    try {
      const res = await fetch(`/grades/${gradeId}`, { method: 'DELETE' });
      if (!res.ok) throw new Error('Delete failed');
      fetchDashboardData();
    } catch (err) {
      alert('Failed to delete');
    }
  };

  const handleLogout = async (e) => {
    if (e) e.preventDefault();
    await fetch('/logout', { method: 'POST' });
    window.location.href = '/';
  };

  navLogout?.addEventListener('click', handleLogout);
});
