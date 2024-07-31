public class RecaptchaController {
     @AuraEnabled
    public static Boolean validateRecaptcha(String response) {
        String secretKey = '6LcnzAwqAAAAALh7AWjUv5rX99WEKfJDZDOjQemv';
        String verifyUrl = 'https://www.google.com/recaptcha/api/siteverify';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(verifyUrl + '?secret=' + secretKey + '&response=' + response);
        req.setMethod('POST');
        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() == 200) {
            Map<String, Object> jsonRes = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            return (Boolean) jsonRes.get('success');
        }
        return false;
    }

}