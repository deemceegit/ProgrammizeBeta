<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Course List</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
<div class="container">
    <h1>📚 Course List</h1>

<%--    <!-- Debug Information - Remove this in production -->--%>
<%--    <div class="debug-info">--%>
<%--        <strong>Debug Info:</strong><br>--%>
<%--        Courses object: ${courses != null ? 'Not null' : 'Null'}<br>--%>
<%--        Number of courses: ${courses != null ? courses.size() : '0'}<br>--%>
<%--        Request URL: ${pageContext.request.requestURL}<br>--%>
<%--        Servlet Path: ${pageContext.request.servletPath}<br>--%>
<%--    </div>--%>

    <!-- Simple Filters -->
    <div class="filters">
        <form action="${pageContext.request.contextPath}/courseList" method="get">
            <input type="text" name="search" placeholder="Search courses..."
                   value="${param.search}" style="width: 300px;">

            <select name="status">
                <option value="">All Statuses</option>
                <option value="1" ${param.status == '1' ? 'selected' : ''}>Active (1)</option>
                <option value="0" ${param.status == '0' ? 'selected' : ''}>Inactive (0)</option>
            </select>

            <button type="submit" class="btn">Search</button>
            <a href="${pageContext.request.contextPath}/courseList" class="btn" style="background: #666;">Clear</a>
        </form>
    </div>

    <!-- Course Table -->
    <c:choose>
        <c:when test="${empty courses}">
            <div class="no-data">
                <h2>No courses found</h2>
                <p>The courses list is empty. This could mean:</p>
                <ul style="text-align: left; display: inline-block;">
                    <li>No data in database</li>
                    <li>Database connection issue</li>
                    <li>Query returned no results</li>
                </ul>
            </div>
        </c:when>
        <c:otherwise>
            <p>Showing ${courses.size()} course(s)</p>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Course Name</th>
                    <th>Description</th>
                    <th>Listed Price</th>
                    <th>Sale Price</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${courses}" var="course" varStatus="loop">
                    <tr>
                        <td>${course.courseId != null ? course.courseId : course.id}</td>
                        <td>
                            <strong>${course.courseName}</strong>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty course.description}">
                                    ${course.description.length() > 50 ?
                                              course.description.substring(0, 50).concat('...') :
                                              course.description}
                                </c:when>
                                <c:otherwise>
                                    <em>No description</em>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <fmt:formatNumber value="${course.listedPrice}"
                                              type="currency"
                                              currencySymbol="$" />
                        </td>
                        <td>
                            <fmt:formatNumber value="${course.salePrice}"
                                              type="currency"
                                              currencySymbol="$" />
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${course.status == '1' || course.status == 'Active'}">
                                    <span class="status-active">Active</span>
                                </c:when>
                                <c:when test="${course.status == '0' || course.status == 'Inactive'}">
                                    <span class="status-inactive">Inactive</span>
                                </c:when>
                                <c:otherwise>
                                    ${course.status}
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="#" class="btn" style="padding: 4px 8px; font-size: 12px;">Edit</a>
                            <button class="btn btn-danger" style="padding: 4px 8px; font-size: 12px;"
                                    onclick="if(confirm('Delete this course?')) alert('Delete feature not implemented yet');">
                                Delete
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

<%--    <!-- Test Data Display -->--%>
<%--    <div style="margin-top: 30px; padding: 20px; background: #f0f0f0; border-radius: 5px;">--%>
<%--        <h3>Raw Data Test (Debug Only)</h3>--%>
<%--        <c:forEach items="${courses}" var="course" varStatus="status">--%>
<%--            <div style="margin: 10px 0; padding: 10px; background: white; border-left: 4px solid #4CAF50;">--%>
<%--                <strong>Course ${status.index + 1}:</strong><br>--%>
<%--                - ID: ${course.courseId != null ? course.courseId : course.id}<br>--%>
<%--                - Name: ${course.courseName}<br>--%>
<%--                - Listed Price: ${course.listedPrice}<br>--%>
<%--                - Sale Price: ${course.salePrice}<br>--%>
<%--                - Status: ${course.status}<br>--%>
<%--                - Description: ${course.description}<br>--%>
<%--                - Thumbnail: ${course.thumbnailUrl}--%>
<%--            </div>--%>
<%--        </c:forEach>--%>
<%--    </div>--%>
</div>

<script>
    // Simple JavaScript for debugging
    console.log("Page loaded successfully");
    console.log("Context Path: ${pageContext.request.contextPath}");
</script>
</body>
</html>
