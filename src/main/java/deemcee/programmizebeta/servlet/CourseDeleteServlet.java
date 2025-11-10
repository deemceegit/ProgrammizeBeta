package deemcee.programmizebeta.servlet;

import deemcee.programmizebeta.dao.CourseDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/deleteCourse")
public class CourseDeleteServlet extends HttpServlet {
    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String courseIdStr = request.getParameter("courseId");

        if (courseIdStr != null) {
            int courseId = Integer.parseInt(courseIdStr);
            boolean deleted = courseDAO.deleteCourse(courseId);

            if (deleted) {
                request.getSession().setAttribute("message", "Course deleted successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to delete course");
            }
        }

        response.sendRedirect("courseList");
    }
}
