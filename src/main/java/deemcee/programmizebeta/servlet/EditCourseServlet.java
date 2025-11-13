package deemcee.programmizebeta.servlet;

import deemcee.programmizebeta.dao.CourseDAO;
import deemcee.programmizebeta.model.Course;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/editCourse")
public class EditCourseServlet extends HttpServlet {
    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
    }

    // GET: Hiển thị form edit với dữ liệu course hiện tại
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy course ID từ parameter
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                // Nếu không có ID, redirect về course list
                response.sendRedirect(request.getContextPath() + "/courseList");
                return;
            }

            int courseId = Integer.parseInt(idParam);

            // Lấy thông tin course từ database
            Course course = courseDAO.getCourseById(courseId);

            if (course == null) {
                // Nếu không tìm thấy course, redirect về course list với error message
                request.getSession().setAttribute("errorMessage", "Course not found!");
                response.sendRedirect(request.getContextPath() + "/courseList");
                return;
            }

            // Set course vào request attribute để JSP sử dụng
            request.setAttribute("course", course);

            // Forward đến trang edit
            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/editCourse.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            // Nếu ID không hợp lệ
            request.getSession().setAttribute("errorMessage", "Invalid course ID!");
            response.sendRedirect(request.getContextPath() + "/courseList");
        }
    }

    // POST: Xử lý submit form edit (cập nhật database)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy tất cả parameters từ form
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String courseName = request.getParameter("courseName");
            String courseCategory = request.getParameter("courseCategory");
            String courseInstructor = request.getParameter("courseInstructor");
            String thumbnailUrl = request.getParameter("thumbnailUrl");
            String description = request.getParameter("description");
            String status = request.getParameter("status");

            // Parse prices
            BigDecimal listedPrice = new BigDecimal(request.getParameter("listedPrice"));
            BigDecimal salePrice = new BigDecimal(request.getParameter("salePrice"));

            // Tạo Course object với dữ liệu mới
            Course course = new Course();
            course.setCourseId(courseId);
            course.setCourseName(courseName);
            course.setCourseCategory(courseCategory);
            course.setCourseInstructor(courseInstructor);
            course.setThumbnailUrl(thumbnailUrl);
            course.setDescription(description);
            course.setListedPrice(listedPrice);
            course.setSalePrice(salePrice);
            course.setStatus(status);

            // Gọi DAO để update database
            boolean success = courseDAO.updateCourse(course);

            if (success) {
                // Nếu update thành công, set success message
                request.getSession().setAttribute("successMessage",
                    "Course '" + courseName + "' updated successfully!");
            } else {
                // Nếu update thất bại, set error message
                request.getSession().setAttribute("errorMessage",
                    "Failed to update course. Please try again.");
            }

            // Redirect về course list
            response.sendRedirect(request.getContextPath() + "/courseList");

        } catch (NumberFormatException e) {
            // Nếu có lỗi parse number
            request.getSession().setAttribute("errorMessage",
                "Invalid input format. Please check your data.");
            response.sendRedirect(request.getContextPath() + "/courseList");
        } catch (Exception e) {
            // Nếu có lỗi khác
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage",
                "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/courseList");
        }
    }
}
