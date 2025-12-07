/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

/**
 * Utility class for checking input against a specified pattern. This class
 * provides a static method to check if a given input string matches a specified
 * pattern. The pattern is defined using regular expressions.
 *
 * @author 
 */
public class CheckPattent {

    /**
     * Checks if the input string matches the specified pattern.
     *
     * @param input The input string to be checked.
     * @param pattern The pattern to be matched against the input string,
     * defined using regular expressions.
     * @return true if the input string matches the pattern, false otherwise.
     */
    public static boolean checkPattent(String input, String pattern) {
        return input.matches(pattern);
    }
}
