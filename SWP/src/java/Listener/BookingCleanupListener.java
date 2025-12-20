package Listener;

import DAL.Booking.DAOBooking;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class BookingCleanupListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("DEBUG: BookingCleanupListener initialized.");
        scheduler = Executors.newSingleThreadScheduledExecutor();

        // Schedule task to run every 30 seconds
        scheduler.scheduleAtFixedRate(() -> {
            try {
                System.out.println("DEBUG: Running automated booking cleanup task...");
                int minutes = 5; // Cancel unpaid bookings older than 5 minutes
                int cancelledCount = DAOBooking.INSTANCE.cancelUnpaidBookings(minutes);
                if (cancelledCount > 0) {
                    System.out.println("DEBUG: Automatically cancelled " + cancelledCount + " unpaid bookings.");
                } else {
                    System.out.println("DEBUG: No unpaid bookings to cancel.");
                }
            } catch (Exception e) {
                System.err.println("ERROR: automated booking cleanup task failed: " + e.getMessage());
                e.printStackTrace();
            }
        }, 0, 30, TimeUnit.SECONDS); // Initial delay 0, repeat every 30 seconds
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
        System.out.println("DEBUG: BookingCleanupListener destroyed.");
    }
}
