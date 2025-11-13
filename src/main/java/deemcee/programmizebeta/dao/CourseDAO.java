package deemcee.programmizebeta.dao;

import deemcee.programmizebeta.DatabaseConnection;
import deemcee.programmizebeta.model.Course;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    // Get all courses with filters (adjusted for actual database columns)
    public List<Course> getAllCourses(String category, String instructor,
                                      String status, String searchKeyword,
                                      String sortColumn, String sortOrder) {
        List<Course> courses = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM courses WHERE 1=1");

        if (status != null && !status.isEmpty() && !status.equals("All Statuses") && !status.equals("")) {
            sql.append(" AND status = ?");
        }
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            // Only search in columns that exist
            sql.append(" AND (course_name LIKE ? OR description LIKE ?)");
        }

        // Add sorting (fix column names for database)
        if (sortColumn != null && !sortColumn.isEmpty()) {
            // Map frontend column names to actual database columns
            String actualColumn = sortColumn;
            if (sortColumn.equals("sales_price")) {
                actualColumn = "sale_price";  // Fix column name
            } else if (sortColumn.equals("id")) {
                actualColumn = "course_id";   // Fix column name
            } else if (sortColumn.equals("course_name")) {
                actualColumn = "course_name";
            }

            sql.append(" ORDER BY ").append(actualColumn);
            if (sortOrder != null && sortOrder.equalsIgnoreCase("desc")) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        } else {
            // Default sorting by course_id
            sql.append(" ORDER BY course_id ASC");
        }

        System.out.println("Executing SQL: " + sql.toString()); // Debug line

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();
            if (conn == null) {
                System.err.println("Failed to get database connection!");
                return courses;
            }

            stmt = conn.prepareStatement(sql.toString());

            int paramIndex = 1;

            // Set parameters (only for columns that exist)
            if (status != null && !status.isEmpty() && !status.equals("All Statuses") && !status.equals("")) {
                stmt.setString(paramIndex++, status);
                System.out.println("Setting status parameter: " + status);
            }
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String searchPattern = "%" + searchKeyword + "%";
                stmt.setString(paramIndex++, searchPattern);
                stmt.setString(paramIndex++, searchPattern);
                System.out.println("Setting search parameter: " + searchPattern);
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setThumbnailUrl(rs.getString("thumbnail_url"));
                course.setCourseName(rs.getString("course_name"));
                course.setCourseCategory(rs.getString("course_category"));
                course.setCourseInstructor(rs.getString("course_instructor"));
                course.setListedPrice(rs.getBigDecimal("listed_price"));
                course.setSalePrice(rs.getBigDecimal("sale_price"));
                course.setDescription(rs.getString("description"));
                course.setStatus(rs.getString("status"));
                courses.add(course);
            }

            System.out.println("Number of courses retrieved: " + courses.size()); // Debug line

        } catch (SQLException e) {
            System.err.println("SQL Error in getAllCourses: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Properly close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return courses;
    }

    // ✅ NEW: Get all distinct categories
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT course_category FROM courses WHERE course_category IS NOT NULL ORDER BY course_category";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String category = rs.getString("course_category");
                if (category != null && !category.trim().isEmpty()) {
                    categories.add(category);
                }
            }
            System.out.println("Retrieved " + categories.size() + " categories");
        } catch (SQLException e) {
            System.err.println("Error getting categories: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }
    // ✅ NEW: Get all distinct instructors
    public List<String> getAllInstructors() {
        List<String> instructors = new ArrayList<>();
        String sql = "SELECT DISTINCT course_instructor FROM courses WHERE course_instructor IS NOT NULL ORDER BY course_instructor";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String instructor = rs.getString("course_instructor");
                if (instructor != null && !instructor.trim().isEmpty()) {
                    instructors.add(instructor);
                }
            }
            System.out.println("Retrieved " + instructors.size() + " instructors");
        } catch (SQLException e) {
            System.err.println("Error getting instructors: " + e.getMessage());
            e.printStackTrace();
        }
        return instructors;
    }

    // Delete course by ID
    public boolean deleteCourse(int courseId) {
        String sql = "DELETE FROM courses WHERE course_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, courseId);
            int rowsAffected = stmt.executeUpdate();

            System.out.println("Delete course ID " + courseId + ": " + rowsAffected + " rows affected");
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting course: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Get course by ID
    public Course getCourseById(int courseId) {
        String sql = "SELECT * FROM courses WHERE course_id = ?";
        Course course = null;

        System.out.println("Getting course by ID: " + courseId); // Debug

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setThumbnailUrl(rs.getString("thumbnail_url"));
                course.setCourseName(rs.getString("course_name"));
                course.setCourseCategory(rs.getString("course_category"));
                course.setCourseInstructor(rs.getString("course_instructor"));
                course.setListedPrice(rs.getBigDecimal("listed_price"));
                course.setSalePrice(rs.getBigDecimal("sale_price"));
                course.setDescription(rs.getString("description"));
                course.setStatus(rs.getString("status"));

                System.out.println("Found course: " + course.getCourseName()); // Debug
            } else {
                System.out.println("No course found with ID: " + courseId); // Debug
            }
        } catch (SQLException e) {
            System.err.println("Error getting course by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return course;
    }

    // Add new course
    public boolean addCourse(Course course) {
        String sql = "INSERT INTO courses (thumbnail_url, course_name, course_category, course_instructor, " +
                "listed_price, sale_price, description, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, course.getThumbnailUrl());
            stmt.setString(2, course.getCourseName());
            stmt.setString(3, course.getCourseCategory());
            stmt.setString(4, course.getCourseInstructor());
            stmt.setBigDecimal(5, course.getListedPrice());
            stmt.setBigDecimal(6, course.getSalePrice());
            stmt.setString(7, course.getDescription());
            stmt.setString(8, course.getStatus());

            int rowsAffected = stmt.executeUpdate();
            System.out.println("Add course: " + rowsAffected + " rows affected");

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error adding course: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Update existing course
    public boolean updateCourse(Course course) {
        String sql = "UPDATE courses SET thumbnail_url=?, course_name=?, course_category=?, course_instructor=?, " +
                "listed_price=?, sale_price=?, description=?, status=? WHERE course_id=?";

        System.out.println("=== UPDATE COURSE DEBUG ===");
        System.out.println("Course ID: " + course.getCourseId());
        System.out.println("Course Name: " + course.getCourseName());
        System.out.println("Category: " + course.getCourseCategory());
        System.out.println("Instructor: " + course.getCourseInstructor());
        System.out.println("Listed Price: " + course.getListedPrice());
        System.out.println("Sale Price: " + course.getSalePrice());
        System.out.println("Status: " + course.getStatus());
        System.out.println("SQL: " + sql);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, course.getThumbnailUrl());
            stmt.setString(2, course.getCourseName());
            stmt.setString(3, course.getCourseCategory());
            stmt.setString(4, course.getCourseInstructor());
            stmt.setBigDecimal(5, course.getListedPrice());
            stmt.setBigDecimal(6, course.getSalePrice());
            stmt.setString(7, course.getDescription());
            stmt.setString(8, course.getStatus());
            stmt.setInt(9, course.getCourseId());

            int rowsAffected = stmt.executeUpdate();

            System.out.println("Update result: " + rowsAffected + " rows affected");

            if (rowsAffected > 0) {
                System.out.println("✓ Course updated successfully!");
                return true;
            } else {
                System.out.println("✗ No rows updated - course ID may not exist");
                return false;
            }

        } catch (SQLException e) {
            System.err.println("✗ Error updating course: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}