import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;
import java.util.ResourceBundle.Control;

public class App {
    public static void main(String[] args) throws Exception {
        File file = new File("/Users/alexradford/Downloads/classdata/src/testdata.txt");
        Scanner scan = new Scanner(file);

        ArrayList<Course> courses = new ArrayList<>();

        HashMap<String, String> codes = SubjectCodes.getCodes();

        while(scan.hasNextLine()) {
            String line = scan.nextLine();
            // System.out.println(line);
            String[] spaceSplit = line.split(" ");
            if(spaceSplit.length < 4 || line.length() < 7) {
                continue;
            }
            if(spaceSplit[0].length() == 4 && spaceSplit[1].length() == 4) {
                String code = spaceSplit[0] + spaceSplit[1];

                String name = "";

                String subjectCode = spaceSplit[0];
                String subjectName = codes.get(subjectCode);

                for(int i=2; i<spaceSplit.length; i++) {
                    name += (spaceSplit[i] + " ");
                }

                int creditHours = 0;
                String creditHourLine = scan.nextLine();
                try {
                    creditHours = Integer.parseInt(creditHourLine.split(": ")[1].split("")[0]);
                } catch(Exception e) {
                    System.out.println("ERROR: " + creditHourLine);
                    continue;
                }

                String description = scan.nextLine();

                Course course = new Course(code, name, description, creditHours, subjectCode, subjectName);
                System.out.println(course + "");
                courses.add(course);
            }

            // System.out.println(scan.nextLine());
        }

        String jsonString = "[";

            for(int i = 0; i<courses.size(); i++) {
                jsonString += (courses.get(i).toJSONString());
                if(i < (courses.size()-1)) {
                    jsonString += ",";
                }
                jsonString+="\n";
            }
            jsonString += "]";
            File outFile = new File("data.json");
            FileWriter writer = new FileWriter(outFile);
            writer.write(jsonString);
            writer.close();

    }
}
