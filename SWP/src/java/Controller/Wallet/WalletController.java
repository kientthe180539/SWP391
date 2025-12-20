package Controller.Wallet;

import DAL.Wallet.DAOWallet;
import Model.User;
import Model.Wallet;
import Model.WalletTransaction;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "WalletController", urlPatterns = { "/wallet", "/wallet/deposit" })
public class WalletController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/wallet" -> showWalletPage(request, response, currentUser);
            case "/wallet/deposit" -> showDepositPage(request, response, currentUser);
            default -> response.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/wallet/deposit" -> processDeposit(request, response, currentUser);
            default -> response.sendError(404);
        }
    }

    private void showWalletPage(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        // Get or create wallet
        Wallet wallet = DAOWallet.INSTANCE.getOrCreateWallet(currentUser.getUserId());

        // Get transaction history
        List<WalletTransaction> transactions = DAOWallet.INSTANCE.getTransactionHistory(wallet.getWalletId());

        request.setAttribute("wallet", wallet);
        request.setAttribute("transactions", transactions);

        request.getRequestDispatcher("/Views/Wallet/Wallet.jsp").forward(request, response);
    }

    private void showDepositPage(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        Wallet wallet = DAOWallet.INSTANCE.getOrCreateWallet(currentUser.getUserId());
        request.setAttribute("wallet", wallet);

        request.getRequestDispatcher("/Views/Wallet/Deposit.jsp").forward(request, response);
    }

    private void processDeposit(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String amountStr = request.getParameter("amount");

        try {
            BigDecimal amount = new BigDecimal(amountStr.replace(",", "").replace(".", "").trim());

            // Validate amount
            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                session.setAttribute("error", "Amount must be greater than 0");
                response.sendRedirect(request.getContextPath() + "/wallet/deposit");
                return;
            }

            if (amount.compareTo(new BigDecimal("100000000")) > 0) {
                session.setAttribute("error", "Maximum deposit amount is 100,000,000 VND");
                response.sendRedirect(request.getContextPath() + "/wallet/deposit");
                return;
            }

            // Process deposit (simulated)
            String description = "Wallet top-up";
            boolean success = DAOWallet.INSTANCE.deposit(currentUser.getUserId(), amount, description);

            if (success) {
                session.setAttribute("success", "Top-up successful! Amount: " +
                        String.format("%,.0f", amount) + " VND has been added to your wallet.");
            } else {
                session.setAttribute("error", "Top-up failed. Please try again.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid amount");
        }

        response.sendRedirect(request.getContextPath() + "/wallet");
    }
}
