import javax.xml.parsers.DocumentBuilder;
import java.net.URL;
import javax.xml.parsers.*;

import org.w3c.dom.*;

import javax.xml.transform.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import javax.xml.transform.stream.*;
import javax.xml.transform.dom.*;


public class Main {
    static PrintStream out;
    static File output_file;
    static String[] header_tags = {"title", "description", "link", "pubDate", "guid", "tags"};
    static StringBuilder htmlBuilder = new StringBuilder();

    public static void main(String[] args) {

        String urll = "http://www.ynet.co.il/Integration/StoryRss2.xml";

// Parse The Xml file from api
        try {
            URL url = new URL(urll);
            out = new PrintStream(System.out, true, StandardCharsets.UTF_8);

            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(url.openStream());

            //Normalize the XML Structure; It's just too important !!
            doc.getDocumentElement().normalize();

            //Get all items
            NodeList nList = doc.getElementsByTagName("item");
            System.out.println("============================");
            create_file();
            for (int temp = 0; temp < nList.getLength(); temp++) {
                Node node = nList.item(temp);
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    //Print each item's detail
                    Element eElement = (Element) node;
                    //     System.out.println("item title : "    + eElement.getAttribute("id"));
                    addItem(eElement);

                    //   out.println("item title : "  + eElement.getElementsByTagName("title").item(0).getTextContent());
                }
            }
            end_table();
            write_to_file(htmlBuilder.toString());// write the row to the end of file


            //printDocument(doc, System.out);
        } catch (Exception e) {

            System.out.println(e);
        }


    }


    public static void addItem(Element element) {
        //  out.println("item title : "  + eElement.getElementsByTagName("title").item(0).getTextContent());

        htmlBuilder.append("<tr>");

        // extract the tags one by one from the attribute
        String value_tag = "";
        for (String tag : header_tags) {

            //exist
            value_tag = element.getElementsByTagName(tag).item(0).getTextContent();
            htmlBuilder.append(String.format("<td>%s</td>\n", value_tag));

        }

        htmlBuilder.append("</tr>"); // end the row of table for this item

    }

    public static void start_table() {


        // Style the Table
        htmlBuilder.append("<!DOCTYPE html>\n" +
                "<html dir=\"rtl\" lang=\"he\">\n" +
                "<head>\n" +
                "<meta charset=\"utf-8\"/>\n" +
                "<style>\n" +
                "table, th, td {\n" +
                "  border: 1px solid black;\n" +
                "  border-collapse: collapse;\n" +
                "}\n" +
                "</style>\n" +
                "</head>");
        ///
        htmlBuilder.append("<table>");
        htmlBuilder.append("<tr>"); // for the header line

        for (int i = 0; i < header_tags.length; i++) {
            htmlBuilder.append(String.format("<th>%s</th>", header_tags[i]));
        }

        htmlBuilder.append("</tr>"); // for the end of header line
    }

    public static void end_table() {
        htmlBuilder.append("</table></html>");// end the table + end file


    }

    /// IO FILE
    public static void create_file() {
        try {
            output_file = new File("output.html");
            if (output_file.createNewFile()) {
                System.out.println("File created: " + output_file.getName());
                start_table();

            } else {
                System.out.println("File already exists.");
            }
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
    }

    public static void write_to_file(String str) {

        try (BufferedWriter wr = Files.newBufferedWriter(Paths.get("output.html"), StandardCharsets.UTF_8)) {
            wr.write(str);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}

