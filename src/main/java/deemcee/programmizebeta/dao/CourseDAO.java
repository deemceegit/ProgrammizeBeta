package deemcee.programmizebeta.dao;

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

        // Since category and instructor don't exist in database, skip those filters

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
                course.setCourseId(rs.getInt("course_id"));  // Fixed: use setCourseId
                course.setThumbnailUrl(rs.getString("thumbnail_url"));
                course.setCourseName(rs.getString("course_name"));
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

    // Delete course by ID
    public boolean deleteCourse(int courseId) {
        String sql = "DELETE FROM courses WHERE course_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, courseId);
            return stmt.executeUpdate() > 0;

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

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                course = new Course();
                course.setCourseId(rs.getInt("course_id"));  // Fixed: use setCourseId
                course.setThumbnailUrl(rs.getString("thumbnail_url"));
                course.setCourseName(rs.getString("course_name"));
                course.setListedPrice(rs.getBigDecimal("listed_price"));
                course.setSalePrice(rs.getBigDecimal("sale_price"));
                course.setDescription(rs.getString("description"));
                course.setStatus(rs.getString("status"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting course by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return course;
    }

    // Add new course
    public boolean addCourse(Course course) {
        String sql = "INSERT INTO courses (thumbnail_url, course_name, " +
                "listed_price, sale_price, description, status) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, course.getThumbnailUrl());
            stmt.setString(2, course.getCourseName());
            stmt.setBigDecimal(3, course.getListedPrice());
            stmt.setBigDecimal(4, course.getSalePrice());
            stmt.setString(5, course.getDescription());
            stmt.setString(6, course.getStatus());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error adding course: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Update existing course
    public boolean updateCourse(Course course) {
        String sql = "UPDATE courses SET thumbnail_url=?, course_name=?, " +
                "listed_price=?, sale_price=?, description=?, status=? WHERE course_id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, course.getThumbnailUrl());
            stmt.setString(2, course.getCourseName());
            stmt.setBigDecimal(3, course.getListedPrice());
            stmt.setBigDecimal(4, course.getSalePrice());
            stmt.setString(5, course.getDescription());
            stmt.setString(6, course.getStatus());
            stmt.setInt(7, course.getCourseId());  // Fixed: use getCourseId

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating course: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}