package Utils;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class SendEmail {

    /**
     * Sends an email to the specified recipient with the given title and
     * content.
     *
     * @param sentTo The email address of the recipient.
     * @param title The title of the email.
     * @param content The content of the email, which can be HTML formatted.
     */
    public static void sendMail(String sentTo, String title, String content) {
        // Email account credentials
//        final String username = "trantrungtoan17092003@gmail.com";
//        final String password = "nlps rmti aasy hgal";

        final String username = "kienga445@gmail.com";
        final String password = "yyil ebfq urtu kxpa";
        // Set up email server properties
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        // Authenticate and establish session with email server
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
        try {
            // Create a new email message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username)); // Set sender
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(sentTo)); // Set recipient
            message.setSubject(title); // Set email subject
            // Set content as HTML with UTF-8 encoding
            message.setContent(content, "text/html; charset=UTF-8");
            // Send the email
            Transport.send(message);
            System.out.println("Email sent successfully!");
        } catch (MessagingException e) {
            // Print error message if sending fails
            System.out.println("Error at :" + e.getMessage());
        }
    }

    public static void main(String[] args) {
        SendEmail.sendMail("tpashop123321@gmail.com", "hello TPA", "<h1>qua dep</h1>");
    }
}
