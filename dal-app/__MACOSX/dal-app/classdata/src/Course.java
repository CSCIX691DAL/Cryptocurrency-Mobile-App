public class Course {

    public Course(String code, String name, String description, int creditHours, String subjectCode, String subjectName) {
        this.code = code;
        this.name = name;
        this.description = description;
        this.creditHours = creditHours;
        this.subjectCode = subjectCode;
        this.subjectName = subjectName;
    }

    String code;
    String subjectCode;
    String subjectName;
    String name;
    String description;
    int creditHours;

    public String toString() {
        return this.code;
    }

    public String toJSONString() {
        return "{\"code\": \""+ this.code + 
            "\", \"subjectCode\": \"" + this.subjectCode + 
            "\", \"subjectName\": \"" + this.subjectName +  
            "\", \"name\": \"" + this.name + 
            "\", \"description\": \"" + this.description.replaceAll("\"", "\\\\\"").replaceAll("CALENDAR NOTES:", "") + 
            "\", \"creditHours\": "+this.creditHours+
            "}";
    }
}
