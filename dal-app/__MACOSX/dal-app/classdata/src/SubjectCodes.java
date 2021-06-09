import java.io.File;
import java.util.Dictionary;
import java.util.HashMap;
import java.util.Scanner;

class SubjectCodes {
    public static void main(String[] args) throws Exception {
        getCodes();
    }

    public static HashMap<String, String> getCodes() throws Exception {
        File file = new File("src/subjectCodes.txt");
        Scanner scan = new Scanner(file);

        HashMap<String, String> dict = new HashMap();
        System.out.println("[");
        while(scan.hasNextLine()) {
            String line = scan.nextLine();
            String code = line.split(" - ")[0];
            String name = line.split(" - ")[1];
            System.out.println("{"+"\"code\": \"" + code + "\", \"name\": \""+name+"\"},");
            dict.put(code, name);
        }

        return dict;
    }
}