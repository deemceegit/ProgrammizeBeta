package deemcee.programmizebeta.model;

import java.math.BigDecimal;
import java.util.Objects;

public class Course {
    private Integer course_id;
    private String courseName;
    private BigDecimal listedPrice;
    private BigDecimal salePrice;
    private String thumbnailUrl;
    private String description;
    private String status;

    public Course() {}


    // Parameterized constructor
    public Course(String courseName, String thumbnailUrl, String description,
                  BigDecimal listedPrice, BigDecimal salePrice, String status) {
        this.courseName = courseName;
        this.thumbnailUrl = thumbnailUrl;
        this.description = description;
        this.listedPrice = listedPrice;
        this.salePrice = salePrice;
        this.status = status;
    }

    public int getCourseId() {
        return course_id;
    }
    public void setId(Integer id) {
        this.course_id = course_id;
    }

    public String getCourseName() {
        return courseName;
    }
    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public BigDecimal getListedPrice() {
        return listedPrice;
    }
    public void setListedPrice(BigDecimal listedPrice) {
        this.listedPrice = listedPrice;
    }

    public BigDecimal getsalePrice() {
        return salePrice;
    }
    public void setsalePrice(BigDecimal salePrice) {
        this.salePrice = salePrice;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }
    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    // Optional: Override toString() method for debugging purposes
    @Override
    public String toString() {
        return "Course{" +
                "course_id=" + course_id +
                ", courseName='" + courseName + '\'' +
                ", listedPrice=" + listedPrice +
                ", salePrice=" + salePrice +
                ", thumbnailUrl='" + thumbnailUrl + '\'' +
                ", description='" + description + '\'' +
                ", status='" + status + '\'' +
                '}';
    }

    // Optional: Override equals() and hashCode() methods
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Course course = (Course) o;

        if (course_id != course.course_id) return false;
        if (!Objects.equals(courseName, course.courseName)) return false;
        if (!Objects.equals(listedPrice, course.listedPrice)) return false;
        if (!Objects.equals(salePrice, course.salePrice)) return false;
        if (!Objects.equals(thumbnailUrl, course.thumbnailUrl)) return false;
        if (!Objects.equals(description, course.description)) return false;
        return Objects.equals(status, course.status);
    }

    @Override
    public int hashCode() {
        int result = course_id;
        result = 31 * result + (courseName != null ? courseName.hashCode() : 0);
        result = 31 * result + (listedPrice != null ? listedPrice.hashCode() : 0);
        result = 31 * result + (salePrice != null ? salePrice.hashCode() : 0);
        result = 31 * result + (thumbnailUrl != null ? thumbnailUrl.hashCode() : 0);
        result = 31 * result + (description != null ? description.hashCode() : 0);
        result = 31 * result + (status != null ? status.hashCode() : 0);
        return result;
    }
}