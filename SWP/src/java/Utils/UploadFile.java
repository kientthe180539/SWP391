
package Utils;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class UploadFile {

    private String UPLOAD_DIRECTORY;

    public List<String> fileUpload(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the real path to the "build/web" directory
        String realPath = request.getServletContext().getRealPath("");
        // Navigate to the "web/uploadFiles" directory
        Path uploadPath = Paths.get(realPath).getParent().getParent().resolve("web/images");
        UPLOAD_DIRECTORY = uploadPath.toString();
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        List<String> uploadedFileNames = new ArrayList<>();

        try {
            // Tìm tất cả các phần được gửi từ form
            for (Part part : request.getParts()) {
                // Kiểm tra nếu phần dữ liệu này là một tệp
                if (part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                    // Lấy tên của tập tin được gửi
                    String fileName = extractFileName(part);
                    if (fileName != null && !fileName.isEmpty()) {
                        // 1. Define Source Path (Project Workspace)
                        Path sourcePath = Paths.get(UPLOAD_DIRECTORY, fileName);

                        // 2. Define Build Path (Tomcat deployment dir)
                        // realPath is "build/web"
                        Path buildPath = Paths.get(realPath, "images", fileName);

                        System.out.println("Saving to Source: " + sourcePath);
                        System.out.println("Saving to Build: " + buildPath);

                        // 3. Save to Source Directory (Persistence)
                        part.write(sourcePath.toString());

                        // 4. Copy to Build Directory (Immediate View)
                        // Make sure build/web/images exists
                        if (!Files.exists(buildPath.getParent())) {
                            Files.createDirectories(buildPath.getParent());
                        }
                        Files.copy(sourcePath, buildPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);

                        // Thêm tên tập tin vào danh sách
                        uploadedFileNames.add(fileName);
                    }
                }
            }
        } catch (ServletException | IOException e) {
            System.out.println("===========================");
            System.out.println("Error at upload file: " + e.getMessage());
            e.printStackTrace(); // Changed from e.getStackTrace() to e.printStackTrace() for proper error
                                 // logging
        }
        return uploadedFileNames;
    }

    /**
     * Phương thức hỗ trợ để trích xuất tên tập tin từ phần được gửi trong yêu
     * cầu HTTP multipart.
     *
     * @param part Phần chứa thông tin về tập tin được gửi.
     * @return Tên của tập tin được trích xuất từ phần, hoặc chuỗi trống nếu
     *         không tìm thấy.
     */
    private String extractFileName(Part part) {
        // Lấy tiêu đề "content-disposition" từ phần
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                // Lấy tên tập tin ban đầu
                String originalFileName = s.substring(s.indexOf("=") + 2, s.length() - 1);
                // Tạo một chuỗi duy nhất (UUID) để thêm vào tên tập tin
                String uniqueID = UUID.randomUUID().toString();
                // Tách phần mở rộng của tập tin (nếu có)
                String fileExtension = "";
                int dotIndex = originalFileName.lastIndexOf('.');
                if (dotIndex != -1) {
                    fileExtension = originalFileName.substring(dotIndex);
                    originalFileName = originalFileName.substring(0, dotIndex);
                }
                // Kết hợp tên tập tin ban đầu với UUID để tạo ra tên tập tin duy nhất
                return originalFileName + "_" + uniqueID + fileExtension;
            }
        }
        return "";
    }
}