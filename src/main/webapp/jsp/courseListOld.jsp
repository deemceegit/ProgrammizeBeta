<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Course List</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <h1>Course List</h1>

    <!-- Filters Section -->
    <form action="courseList" method="get" class="filters-form">
        <select name="category" onchange="this.form.submit()">
            <option value="All Categories">All Categories</option>
            <c:forEach items="${categories}" var="cat">
                <option value="${cat}" ${selectedCategory == cat ? 'selected' : ''}>${cat}</option>
            </c:forEach>
        </select>

        <select name="instructor" onchange="this.form.submit()">
            <option value="All Instructors">All Instructors</option>
            <c:forEach items="${instructors}" var="inst">
                <option value="${inst}" ${selectedInstructor == inst ? 'selected' : ''}>${inst}</option>
            </c:forEach>
        </select>

        <select name="status" onchange="this.form.submit()">
            <option value="All Statuses">All Statuses</option>
            <option value="Active" ${selectedStatus == 'Active' ? 'selected' : ''}>Active</option>
            <option value="Inactive" ${selectedStatus == 'Inactive' ? 'selected' : ''}>Inactive</option>
        </select>

        <input type="text" name="search" placeholder="Search..."
               value="${searchKeyword}">
        <button type="submit">🔍</button>

        <a href="courseDetail" class="btn-add">+ Add New</a>
    </form>

    <!-- Course Table -->
    <table class="course-table">
        <thead>
        <tr>
            <th>#</th>
            <th>Thumbnail</th>
            <th><a href="?sortColumn=course_name&sortOrder=${param.sortOrder == 'asc' ? 'desc' : 'asc'}">Course Name</a></th>
            <th><a href="?sortColumn=category&sortOrder=${param.sortOrder == 'asc' ? 'desc' : 'asc'}">Category</a></th>
            <th><a href="?sortColumn=instructor&sortOrder=${param.sortOrder == 'asc' ? 'desc' : 'asc'}">Instructor</a></th>
            <th><a href="?sortColumn=listed_price&sortOrder=${param.sortOrder == 'asc' ? 'desc' : 'asc'}">Listed Price</a></th>
            <th><a href="?sortColumn=sales_price&sortOrder=${param.sortOrder == 'asc' ? 'desc' : 'asc'}">Sales Price</a></th>
            <th><a href="?sortColumn=status&sortOrder=${param.sortOrder == 'asc' ? 'desc' : 'asc'}">Status</a></th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${courses}" var="course" varStatus="status">
            <tr>
                <td>${status.count}</td>
                <td>
                    <c:if test="${not empty course.thumbnail}">
                        <img src="${course.thumbnail}" alt="Thumbnail" width="50">
                    </c:if>
                </td>
                <td>${course.courseName}</td>
                <td>${course.category}</td>
                <td>${course.instructor}</td>
                <td>$${course.listedPrice}</td>
                <td>$${course.salesPrice}</td>
                <td>
                            <span class="status-badge ${course.status == 'Active' ? 'active' : 'inactive'}">
                                    ${course.status}
                            </span>
                </td>
                <td>
                    <a href="courseDetail?id=${course.id}" class="btn-edit">✏️</a>
                    <form action="deleteCourse" method="post" style="display:inline;"
                          onsubmit="return confirm('Are you sure you want to delete this course?');">
                        <input type="hidden" name="courseId" value="${course.id}">
                        <button type="submit" class="btn-delete">🗑️</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
