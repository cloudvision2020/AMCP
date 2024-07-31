public class CommunityUserController {

    // Method to create a new community user
    public static String createCommunityUser(String firstName, String lastName, String email, String password) {
        // Profile for the community user
        Profile communityUserProfile = [SELECT Id FROM Profile WHERE Name = 'Customer Community User' LIMIT 1];

        // Create new User record
        User newUser = new User(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Username = email,
            Alias = firstName.substring(0, 1) + lastName,
            CommunityNickname = firstName + lastName,
            ProfileId = communityUserProfile.Id,
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            UserRoleId = null,
            IsActive = true
        );

        try {
            // Insert the new User record
            insert newUser;
            
            // Set the password for the new user
            System.setPassword(newUser.Id, password);
            
            return 'User registered successfully';
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}