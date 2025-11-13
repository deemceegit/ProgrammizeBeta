<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Course - Programmize</title>
    <link rel="stylesheet" type="text/css" href="css/styleEditCourse.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>✏️ Edit Course</h1>
            <p>Update course information below</p>
        </div>

        <form action="${pageContext.request.contextPath}/editCourse" method="post">
            <!-- Hidden field for course ID -->
            <input type="hidden" name="courseId" value="${course.courseId}" />

            <!-- Course ID Display (read-only) -->
            <div class="form-group">
                <label>Course ID</label>
                <div class="course-id-display">
                    #${course.courseId}
                </div>
            </div>

            <!-- Course Name -->
            <div class="form-group">
                <label for="courseName">
                    Course Name <span class="required">*</span>
                </label>
                <input type="text" 
                       id="courseName" 
                       name="courseName" 
                       value="${course.courseName}"
                       required 
                       maxlength="255"
                       placeholder="e.g., Complete Java Programming Masterclass">
            </div>

            <!-- Category and Instructor -->
            <div class="form-row">
                <div class="form-group">
                    <label for="courseCategory">
                        Category <span class="required">*</span>
                    </label>
                    <input type="text" 
                           id="courseCategory" 
                           name="courseCategory" 
                           value="${course.courseCategory}"
                           required 
                           maxlength="100"
                           placeholder="e.g., Programming">
                </div>

                <div class="form-group">
                    <label for="courseInstructor">
                        Instructor <span class="required">*</span>
                    </label>
                    <input type="text" 
                           id="courseInstructor" 
                           name="courseInstructor" 
                           value="${course.courseInstructor}"
                           required 
                           maxlength="100"
                           placeholder="e.g., John Doe">
                </div>
            </div>

            <!-- Prices -->
            <div class="form-row">
                <div class="form-group">
                    <label for="listedPrice">
                        Listed Price ($) <span class="required">*</span>
                    </label>
                    <input type="number" 
                           id="listedPrice" 
                           name="listedPrice" 
                           value="${course.listedPrice}"
                           required 
                           min="0" 
                           step="0.01"
                           placeholder="99.99">
                    <div class="help-text">Original price before discount</div>
                </div>

                <div class="form-group">
                    <label for="salePrice">
                        Sale Price ($) <span class="required">*</span>
                    </label>
                    <input type="number" 
                           id="salePrice" 
                           name="salePrice" 
                           value="${course.salePrice}"
                           required 
                           min="0" 
                           step="0.01"
                           placeholder="49.99">
                    <div class="help-text">Current selling price</div>
                </div>
            </div>

            <!-- Thumbnail URL -->
            <div class="form-group">
                <label for="thumbnailUrl">
                    Thumbnail URL <span class="required">*</span>
                </label>
                <input type="text" 
                       id="thumbnailUrl" 
                       name="thumbnailUrl" 
                       value="${course.thumbnailUrl}"
                       required 
                       placeholder="https://example.com/image.jpg">
                <div class="help-text">Full URL to the course thumbnail image</div>
            </div>

            <!-- Description -->
            <div class="form-group">
                <label for="description">
                    Description <span class="required">*</span>
                </label>
                <textarea id="description" 
                          name="description" 
                          required 
                          maxlength="1000"
                          placeholder="Enter a detailed description of the course...">${course.description}</textarea>
                <div class="help-text">Maximum 1000 characters</div>
            </div>

            <!-- Status -->
            <div class="form-group">
                <label>Status <span class="required">*</span></label>
                <div>
                    <label>
                        <input type="radio" name="status" value="1"
                        ${course.status == '1' ? 'checked' : ''} required>
                        Active
                    </label>
                    <label style="margin-left: 15px;">
                        <input type="radio" name="status" value="0"
                        ${course.status == '0' ? 'checked' : ''}>
                        Inactive
                    </label>
                </div>
            </div>

            <!-- Buttons -->
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/courseList" class="btn btn-secondary">
                    ← Cancel
                </a>
                <button type="submit" class="btn btn-primary">
                    💾 Save Changes
                </button>
            </div>
        </form>
    </div>

    <script>
        // Validation: Sale price should not be greater than listed price
        document.querySelector('form').addEventListener('submit', function(e) {
            const listedPrice = parseFloat(document.getElementById('listedPrice').value);
            const salePrice = parseFloat(document.getElementById('salePrice').value);
            
            if (salePrice > listedPrice) {
                e.preventDefault();
                alert('Sale price cannot be greater than listed price!');
                document.getElementById('salePrice').focus();
            }
        });

        // Real-time validation feedback
        document.getElementById('salePrice').addEventListener('input', function() {
            const listedPrice = parseFloat(document.getElementById('listedPrice').value);
            const salePrice = parseFloat(this.value);
            
            if (salePrice > listedPrice) {
                this.style.borderColor = '#e74c3c';
            } else {
                this.style.borderColor = '#e0e0e0';
            }
        });
    </script>
</body>
</html>
