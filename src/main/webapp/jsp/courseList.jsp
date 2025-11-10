<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course List - E-Learning Platform</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: #f5f7fa;
            color: #333;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            margin: -20px -20px 20px -20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .header h1 {
            font-size: 24px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .main-content {
            background: white;
            border-radius: 8px;
            padding: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
        }

        .page-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid #e1e8ed;
        }

        .page-title h2 {
            font-size: 22px;
            color: #2c3e50;
            font-weight: 600;
        }

        .btn-new-course {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: transform 0.2s, box-shadow 0.2s;
            text-decoration: none;
        }

        .btn-new-course:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .filters-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .filter-group label {
            font-size: 12px;
            color: #6c757d;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .filter-group select,
        .filter-group input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            background: white;
            transition: border-color 0.2s;
        }

        .filter-group select:hover,
        .filter-group input:hover {
            border-color: #667eea;
        }

        .filter-group select:focus,
        .filter-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .search-container {
            position: relative;
            grid-column: span 2;
        }

        .search-container input {
            width: 100%;
            padding-left: 36px;
        }

        .search-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }

        .search-button {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            background: #667eea;
            color: white;
            border: none;
            padding: 6px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            transition: background 0.2s;
        }

        .search-button:hover {
            background: #5a67d8;
        }

        .filter-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .clear-filters {
            padding: 8px 16px;
            background: white;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.2s;
        }

        .clear-filters:hover {
            background: #f8f9fa;
            border-color: #667eea;
        }

        .table-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .results-info {
            font-size: 14px;
            color: #6c757d;
        }

        .export-button {
            background: white;
            border: 1px solid #ddd;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .export-button:hover {
            background: #f8f9fa;
            border-color: #667eea;
        }

        .table-container {
            overflow-x: auto;
            border: 1px solid #dee2e6;
            border-radius: 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
        }

        th {
            padding: 12px;
            text-align: left;
            font-size: 12px;
            font-weight: 600;
            color: #495057;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        th.sortable {
            cursor: pointer;
            user-select: none;
        }

        th.sortable:hover {
            background: #e9ecef;
        }

        .sort-icon {
            display: inline-block;
            margin-left: 5px;
            font-size: 10px;
            color: #6c757d;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #f1f3f4;
            font-size: 14px;
            vertical-align: middle;
        }

        tbody tr:hover {
            background: #f8f9fa;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .checkbox-cell {
            width: 40px;
        }

        .course-name {
            font-weight: 500;
            color: #2c3e50;
            cursor: pointer;
        }

        .course-name:hover {
            color: #667eea;
            text-decoration: underline;
        }

        .thumbnail-img {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 4px;
        }

        .placeholder-thumbnail {
            width: 40px;
            height: 40px;
            background: #e9ecef;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            font-size: 12px;
        }

        .category-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .cat-programming {
            background: #e3f2fd;
            color: #1976d2;
        }

        .cat-web {
            background: #f3e5f5;
            color: #7b1fa2;
        }

        .cat-design {
            background: #ede7f6;
            color: #512da8;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-indicator {
            width: 6px;
            height: 6px;
            border-radius: 50%;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-active .status-indicator {
            background: #28a745;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .status-inactive .status-indicator {
            background: #dc3545;
        }

        .action-links {
            display: flex;
            gap: 10px;
        }

        .action-link {
            color: #667eea;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            transition: color 0.2s;
        }

        .action-link:hover {
            color: #5a67d8;
            text-decoration: underline;
        }

        .action-link.danger {
            color: #dc3545;
        }

        .action-link.danger:hover {
            color: #c82333;
        }

        .btn-edit, .btn-delete {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 18px;
            padding: 4px;
            margin: 0 2px;
            transition: transform 0.2s;
        }

        .btn-edit:hover, .btn-delete:hover {
            transform: scale(1.2);
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
        }

        .pagination button {
            padding: 8px 12px;
            background: white;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.2s;
        }

        .pagination button:hover:not(:disabled) {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .pagination button:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .pagination button.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .page-size {
            margin-left: auto;
        }

        .page-size select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background: white;
            cursor: pointer;
        }

        /* Message Alerts */
        .alert {
            padding: 12px 20px;
            margin-bottom: 20px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                📚 Course Management System
            </h1>
        </div>

        <div class="main-content">
            <!-- Display messages -->
            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-success">
                    ✅ ${sessionScope.message}
                </div>
                <c:remove var="message" scope="session" />
            </c:if>
            
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-error">
                    ❌ ${sessionScope.error}
                </div>
                <c:remove var="error" scope="session" />
            </c:if>

            <div class="page-title">
                <h2>📋 Course List</h2>
                <a href="${pageContext.request.contextPath}/courseDetail" class="btn-new-course">
                    ➕ Add New Course
                </a>
            </div>

            <form id="filterForm" action="${pageContext.request.contextPath}/courseList" method="get">
                <div class="filters-section">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="category">Category</label>
                            <select id="category" name="category" onchange="this.form.submit()">
                                <option value="">All Categories</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat}" ${param.category == cat ? 'selected' : ''}>${cat}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-group">
                            <label for="instructor">Instructor</label>
                            <select id="instructor" name="instructor" onchange="this.form.submit()">
                                <option value="">All Instructors</option>
                                <c:forEach items="${instructors}" var="inst">
                                    <option value="${inst}" ${param.instructor == inst ? 'selected' : ''}>${inst}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-group">
                            <label for="status">Status</label>
                            <select id="status" name="status" onchange="this.form.submit()">
                                <option value="">All Statuses</option>
                                <option value="Active" ${param.status == 'Active' ? 'selected' : ''}>Active</option>
                                <option value="Inactive" ${param.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>

                        <div class="filter-group search-container">
                            <label for="search">Search</label>
                            <span class="search-icon">🔍</span>
                            <input type="text" id="search" name="search" 
                                   placeholder="Search by name, category or instructor..." 
                                   value="${param.search}">
                            <button type="submit" class="search-button">Search</button>
                        </div>
                    </div>

                    <div class="filter-actions">
                        <button type="button" class="clear-filters" onclick="clearFilters()">🔄 Clear Filters</button>
                    </div>
                </div>

                <!-- Hidden fields for sorting -->
                <input type="hidden" name="sortColumn" value="${param.sortColumn}">
                <input type="hidden" name="sortOrder" value="${param.sortOrder}">
                <input type="hidden" name="page" value="${param.page}">
                <input type="hidden" name="pageSize" value="${param.pageSize}">
            </form>

            <div class="table-controls">
                <div class="results-info">
                    Showing <strong>${fn:length(courses)}</strong> courses
                    <c:if test="${not empty param.search or not empty param.category or not empty param.instructor or not empty param.status}">
                        (filtered)
                    </c:if>
                </div>
                <button class="export-button" onclick="exportData()">
                    📥 Export
                </button>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th class="checkbox-cell">
                                <input type="checkbox" id="selectAll">
                            </th>
                            <th>#</th>
                            <th>Thumbnail</th>
                            <th class="sortable" onclick="sortTable('course_name')">
                                Course Name
                                <span class="sort-icon">
                                    <c:if test="${param.sortColumn == 'course_name'}">
                                        ${param.sortOrder == 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </span>
                            </th>
                            <th class="sortable" onclick="sortTable('category')">
                                Category
                                <span class="sort-icon">
                                    <c:if test="${param.sortColumn == 'category'}">
                                        ${param.sortOrder == 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </span>
                            </th>
                            <th class="sortable" onclick="sortTable('instructor')">
                                Instructor
                                <span class="sort-icon">
                                    <c:if test="${param.sortColumn == 'instructor'}">
                                        ${param.sortOrder == 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </span>
                            </th>
                            <th class="sortable" onclick="sortTable('listed_price')">
                                Listed Price
                                <span class="sort-icon">
                                    <c:if test="${param.sortColumn == 'listed_price'}">
                                        ${param.sortOrder == 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </span>
                            </th>
                            <th class="sortable" onclick="sortTable('sales_price')">
                                Sales Price
                                <span class="sort-icon">
                                    <c:if test="${param.sortColumn == 'sales_price'}">
                                        ${param.sortOrder == 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </span>
                            </th>
                            <th class="sortable" onclick="sortTable('status')">
                                Status
                                <span class="sort-icon">
                                    <c:if test="${param.sortColumn == 'status'}">
                                        ${param.sortOrder == 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </span>
                            </th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty courses}">
                                <tr>
                                    <td colspan="10" style="text-align: center; padding: 30px;">
                                        <div style="color: #6c757d;">
                                            <div style="font-size: 48px; margin-bottom: 10px;">📚</div>
                                            <div style="font-size: 16px;">No courses found</div>
                                            <c:if test="${not empty param.search or not empty param.category or not empty param.instructor or not empty param.status}">
                                                <div style="font-size: 14px; margin-top: 5px;">Try adjusting your filters</div>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${courses}" var="course" varStatus="status">
                                    <tr>
                                        <td class="checkbox-cell">
                                            <input type="checkbox" name="selectedCourses" value="${course.course_id}">
                                        </td>
                                        <td>${status.count}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty course.thumbnailUrl}">
                                                    <img src="${course.thumbnailUrl}" alt="Thumbnail" class="thumbnail-img">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="placeholder-thumbnail">📷</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="course-name" title="${course.description}">${course.courseName}</span>
                                        </td>
                                        <td>
                                            <span class="category-badge cat-programming">${course.category}</span>
                                        </td>
                                        <td>${course.instructor}</td>
                                        <td>
                                            <fmt:formatNumber value="${course.listedPrice}" type="currency" currencySymbol="$" />
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${course.salesPrice}" type="currency" currencySymbol="$" />
                                        </td>
                                        <td>
                                            <span class="status-badge ${course.status == 'Active' ? 'status-active' : 'status-inactive'}">
                                                <span class="status-indicator"></span>
                                                ${course.status}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="action-links">
                                                <a href="${pageContext.request.contextPath}/courseDetail?id=${course.course_id}" 
                                                   class="btn-edit" title="Edit">✏️</a>
                                                <form action="${pageContext.request.contextPath}/deleteCourse" method="post" 
                                                      style="display:inline;" 
                                                      onsubmit="return confirm('Are you sure you want to delete this course?');">
                                                    <input type="hidden" name="courseId" value="${course.course_id}">
                                                    <button type="submit" class="btn-delete" title="Delete">🗑️</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <button onclick="goToPage(${currentPage - 1})" ${currentPage == 1 ? 'disabled' : ''}>◄</button>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <button class="active">${i}</button>
                            </c:when>
                            <c:when test="${i == 1 or i == totalPages or (i >= currentPage - 2 and i <= currentPage + 2)}">
                                <button onclick="goToPage(${i})">${i}</button>
                            </c:when>
                            <c:when test="${i == currentPage - 3 or i == currentPage + 3}">
                                <span>...</span>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    
                    <button onclick="goToPage(${currentPage + 1})" ${currentPage == totalPages ? 'disabled' : ''}>►</button>
                    
                    <div class="page-size">
                        <select id="pageSize" onchange="changePageSize(this.value)">
                            <option value="10" ${param.pageSize == '10' ? 'selected' : ''}>10 per page</option>
                            <option value="25" ${param.pageSize == '25' or empty param.pageSize ? 'selected' : ''}>25 per page</option>
                            <option value="50" ${param.pageSize == '50' ? 'selected' : ''}>50 per page</option>
                            <option value="100" ${param.pageSize == '100' ? 'selected' : ''}>100 per page</option>
                        </select>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        // Select all checkbox functionality
        document.getElementById('selectAll').addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('tbody input[type="checkbox"]');
            checkboxes.forEach(cb => cb.checked = this.checked);
        });

        // Individual checkbox handling
        document.querySelectorAll('tbody input[type="checkbox"]').forEach(cb => {
            cb.addEventListener('change', function() {
                const allCheckboxes = document.querySelectorAll('tbody input[type="checkbox"]');
                const selectAllCheckbox = document.getElementById('selectAll');
                const allChecked = Array.from(allCheckboxes).every(cb => cb.checked);
                const someChecked = Array.from(allCheckboxes).some(cb => cb.checked);
                
                selectAllCheckbox.checked = allChecked;
                selectAllCheckbox.indeterminate = someChecked && !allChecked;
            });
        });

        // Sort functionality
        function sortTable(column) {
            const form = document.getElementById('filterForm');
            const sortColumnInput = form.querySelector('input[name="sortColumn"]');
            const sortOrderInput = form.querySelector('input[name="sortOrder"]');
            
            if (sortColumnInput.value === column) {
                sortOrderInput.value = sortOrderInput.value === 'asc' ? 'desc' : 'asc';
            } else {
                sortColumnInput.value = column;
                sortOrderInput.value = 'asc';
            }
            
            form.submit();
        }

        // Clear filters functionality
        function clearFilters() {
            const form = document.getElementById('filterForm');
            form.querySelector('select[name="category"]').value = '';
            form.querySelector('select[name="instructor"]').value = '';
            form.querySelector('select[name="status"]').value = '';
            form.querySelector('input[name="search"]').value = '';
            form.querySelector('input[name="sortColumn"]').value = '';
            form.querySelector('input[name="sortOrder"]').value = '';
            form.submit();
        }

        // Pagination functions
        function goToPage(page) {
            if (page < 1) return;
            const form = document.getElementById('filterForm');
            form.querySelector('input[name="page"]').value = page;
            form.submit();
        }

        function changePageSize(size) {
            const form = document.getElementById('filterForm');
            form.querySelector('input[name="pageSize"]').value = size;
            form.querySelector('input[name="page"]').value = 1; // Reset to first page
            form.submit();
        }

        // Export functionality
        function exportData() {
            const formats = ['CSV', 'Excel (.xlsx)', 'PDF'];
            const format = prompt('Select export format:\n1. CSV\n2. Excel (.xlsx)\n3. PDF\n\nEnter number (1-3):');
            if (format && format >= 1 && format <= 3) {
                // Get current filter parameters
                const params = new URLSearchParams(window.location.search);
                params.append('export', formats[format - 1].toLowerCase().replace(/[^a-z]/g, ''));
                
                // Redirect to export endpoint
                window.location.href = '${pageContext.request.contextPath}/exportCourses?' + params.toString();
            }
        }

        // Search with debounce
        let searchTimeout;
        document.getElementById('search').addEventListener('input', function() {
            clearTimeout(searchTimeout);
            const searchButton = this.nextElementSibling;
            searchButton.textContent = 'Searching...';
            
            searchTimeout = setTimeout(() => {
                searchButton.textContent = 'Search';
                // Auto-submit after typing stops for 1 second
                if (this.value.length === 0 || this.value.length >= 3) {
                    document.getElementById('filterForm').submit();
                }
            }, 1000);
        });

        // Highlight search terms
        <c:if test="${not empty param.search}">
        window.addEventListener('DOMContentLoaded', function() {
            const searchTerm = "${fn:escapeXml(param.search)}".toLowerCase();
            const courseNames = document.querySelectorAll('.course-name');
            courseNames.forEach(function(element) {
                const text = element.textContent;
                const lowerText = text.toLowerCase();
                if (lowerText.includes(searchTerm)) {
                    const regex = new RegExp('(' + searchTerm + ')', 'gi');
                    element.innerHTML = text.replace(regex, '<mark>$1</mark>');
                }
            });
        });
        </c:if>

        // Bulk actions
        function performBulkAction(action) {
            const checkedBoxes = document.querySelectorAll('tbody input[type="checkbox"]:checked');
            if (checkedBoxes.length === 0) {
                alert('Please select at least one course');
                return;
            }
            
            const courseIds = Array.from(checkedBoxes).map(cb => cb.value);
            
            if (confirm(`Are you sure you want to ${action} ${courseIds.length} course(s)?`)) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/bulkAction';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = action;
                form.appendChild(actionInput);
                
                courseIds.forEach(id => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'courseIds';
                    input.value = id;
                    form.appendChild(input);
                });
                
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl/Cmd + K for search focus
            if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                e.preventDefault();
                document.getElementById('search').focus();
            }
            
            // Escape to clear search
            if (e.key === 'Escape') {
                const searchInput = document.getElementById('search');
                if (searchInput === document.activeElement && searchInput.value) {
                    searchInput.value = '';
                    document.getElementById('filterForm').submit();
                }
            }
        });
    </script>
</body>
</html>
