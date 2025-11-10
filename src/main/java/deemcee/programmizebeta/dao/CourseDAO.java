package deemcee.programmizebeta.dao;

import deemcee.programmizebeta.model.Course;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    // Get all courses with filters
    public List<Course> getAllCourses(String category, String instructor,
                                      String status, String searchKeyword,
                                      String sortColumn, String sortOrder) {
        List<Course> courses = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM courses WHERE 1=1");

        // Build dynamic WHERE clause
        if (category != null && !category.equals("All Categories")) {
            sql.append(" AND category = ?");
        }
        if (instructor != null && !instructor.equals("All Instructors")) {
            sql.append(" AND instructor = ?");
        }
        if (status != null && !status.equals("All Statuses")) {
            sql.append(" AND status = ?");
        }
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (course_name LIKE ? OR category LIKE ? OR instructor LIKE ?)");
        }

        // Add sorting
        if (sortColumn != null && !sortColumn.isEmpty()) {
            sql.append(" ORDER BY ").append(sortColumn);
            if (sortOrder != null && sortOrder.equalsIgnoreCase("desc")) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            // Set parameters
            if (category != null && !category.equals("All Categories")) {
                stmt.setString(paramIndex++, category);
            }
            if (instructor != null && !instructor.equals("All Instructors")) {
                stmt.setString(paramIndex++, instructor);
            }
            if (status != null && !status.equals("All Statuses")) {
                stmt.setString(paramIndex++, status);
            }
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String searchPattern = "%" + searchKeyword + "%";
                stmt.setString(paramIndex++, searchPattern);
                stmt.setString(paramIndex++, searchPattern);
                stmt.setString(paramIndex++, searchPattern);
            }

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setThumbnailUrl(rs.getString("thumbnail"));
                course.setCourseName(rs.getString("course_name"));
                course.setListedPrice(rs.getBigDecimal("listed_price"));
                course.setsalePrice(rs.getBigDecimal("sales_price"));
                course.setDescription(rs.getString("description"));
                course.setStatus(rs.getString("status"));
                courses.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return courses;
    }

//    // Get distinct categories for filter
//    public List<String> getAllCategories() {
//        List<String> categories = new ArrayList<>();
//        String sql = "SELECT DISTINCT category FROM courses WHERE category IS NOT NULL";
//
//        try (Connection conn = DatabaseConnection.getConnection();
//             Statement stmt = conn.createStatement();
//             ResultSet rs = stmt.executeQuery(sql)) {
//
//            while (rs.next()) {
//                categories.add(rs.getString("category"));
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        return categories;
//    }

//    // Get distinct instructors for filter
//    public List<String> getAllInstructors() {
//        List<String> instructors = new ArrayList<>();
//        String sql = "SELECT DISTINCT instructor FROM courses WHERE instructor IS NOT NULL";
//
//        try (Connection conn = DatabaseConnection.getConnection();
//             Statement stmt = conn.createStatement();
//             ResultSet rs = stmt.executeQuery(sql)) {
//
//            while (rs.next()) {
//                instructors.add(rs.getString("instructor"));
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        return instructors;
//    }

    // Delete course by ID
    public boolean deleteCourse(int courseId) {
        String sql = "DELETE FROM courses WHERE course_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, courseId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
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
                course.setId(rs.getInt("course_id"));
                course.setThumbnailUrl(rs.getString("thumbnail"));
                course.setCourseName(rs.getString("course_name"));
                course.setListedPrice(rs.getBigDecimal("listed_price"));
                course.setsalePrice(rs.getBigDecimal("sales_price"));
                course.setDescription(rs.getString("description"));
                course.setStatus(rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return course;
    }

    // Add new course
    public boolean addCourse(Course course) {
        String sql = "INSERT INTO courses (thumbnail, course_name, " +
                "listed_price, sales_price, description, status) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, course.getThumbnailUrl());
            stmt.setString(2, course.getCourseName());
            stmt.setBigDecimal(3, course.getListedPrice());
            stmt.setBigDecimal(4, course.getsalePrice());
            stmt.setString(5, course.getDescription());
            stmt.setString(6, course.getStatus());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update existing course
    public boolean updateCourse(Course course) {
        String sql = "UPDATE courses SET thumbnail=?, course_name=?" +
                "listed_price=?, sales_price=?, description=?, status=? WHERE course_id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, course.getThumbnailUrl());
            stmt.setString(2, course.getCourseName());
            stmt.setBigDecimal(3, course.getListedPrice());
            stmt.setBigDecimal(4, course.getsalePrice());
            stmt.setString(5, course.getDescription());
            stmt.setString(6, course.getStatus());
            stmt.setInt(7, course.getCourseId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
