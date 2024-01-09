package server.utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class Security {

    private static final int saltLength = 20;
    private static final int hashLength = 224;
    private static final String pepper = "$34Mp@12_*456";

    private static Security security = new Security();
    
    private Security() {}
    
    public static Security getSecurity() {
    	return security;
    }
    
    /*
    private void test() {
        String hash = getPasswordHash("12345");
        System.out.println(hash);
        System.out.println(checkPassword(hash, "12345"));

        hash = getPasswordHash("54321");
        System.out.println(hash);
        System.out.println(checkPassword(hash, "54329"));
    }
    */

    public String getPasswordHash(String password) {

        // подготовить соль
        byte[] salt = prepareSalt();

        // получить хэш пароля
        byte[] passwordHash = getPasswordHash(password, salt);

        // для хранения перевести в Base64
        String passwordHashBase64 = Base64.getEncoder().encodeToString(passwordHash);
        if (passwordHashBase64 == null) {
            return null;
        }

        // вернуть <соль>$<пароль> одной строкой
        String saltBase64 = Base64.getEncoder().encodeToString(salt);
        return saltBase64 + '$' + passwordHashBase64;
    }


    /**
     * Проверить совпадение hash сохраненного пароля и введенного пользователем.
     */
    public boolean checkPassword(String storedPassword, String inputPassword) {
        if (storedPassword == null || inputPassword == null) {
            return false;
        }

        // найти соль и хэш пароля
        int separator = storedPassword.indexOf('$');
        if (separator < 0) {
            return false;
        }
        String saltBase64 = storedPassword.substring(0,  separator);
        String storedPasswordBase64 = storedPassword.substring(separator + 1);

        // получить соль
        byte[] salt;
        try {
            salt = Base64.getDecoder().decode(saltBase64);
        } catch (IllegalArgumentException e) {
            return false;
        }

        // получить хэш введенного пароля
        byte[] inputPasswordHash = getPasswordHash(inputPassword, salt);
        if (inputPasswordHash == null) {
            return false;
        }

        // получить Base64 введенного пароля
        String inputPasswordHashBase64 = Base64.getEncoder().encodeToString(inputPasswordHash);

        boolean passwordEqual = storedPasswordBase64.equalsIgnoreCase(inputPasswordHashBase64);
        return passwordEqual;
    }

    /**
     * Подготовить соль.
     */
    private byte[] prepareSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[saltLength];
        random.nextBytes(salt);
        return salt;
    }

    /**
     * С помощью java security получить hash сигнатуру пароля.
     */
    private byte[] getPasswordHash(String password, byte[] salt) {
        MessageDigest md = null;
        try {
            md = MessageDigest.getInstance("SHA-" + hashLength);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
        md.update(salt);
        md.update((password + pepper).getBytes(StandardCharsets.UTF_8));
        byte[] result = md.digest();
        return result;
    }

}
