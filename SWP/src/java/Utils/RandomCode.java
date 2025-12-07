/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

import java.util.Random;

public class RandomCode {

    /**
     * rundome an code
     *
     * @param number number character code random
     * @return code rumdom with number character
     */
    public static int randomCode(int number) {
        Random rand = new Random();
        int max = (int) Math.pow(10, number);
        int min = (int) Math.pow(10, number - 1);
        int random = rand.nextInt(max - min + 1) + min;
        return random;
    }
    public static void main(String[] args) {
        int code = randomCode(6);
        System.out.println(code);
    }
}
